-- alt+F to jump Forward by a word
-- alt+B to jump Backward by a word
-- alt+D to delete a word starting from the current cursor position
-- ctrl+W to remove the word backwards from cursor position
-- ctrl+A to jump to start of the line
-- ctrl+E to jump to end of the line
-- ctrl+K to kill the line starting from the cursor position
-- ctrl+Y to paste text from the kill buffer
-- ctrl+F to move forward by a char
-- ctrl+B to move backward by a char
-- -- delete word to right forward
-- hs.hotkey.bind( {"alt"}, "d", function()
--     hs.eventtap.keyStroke({"ctrl", "alt", "shift"}, "f")
--     hs.eventtap.keyStroke({}, "delete")
--   end
-- )
hs.loadSpoon('SpoonInstall')
spoon.SpoonInstall.use_syncinstall = true

local hyper = { 'command', 'option', 'shift', 'control' }

local Install = spoon.SpoonInstall

-- Install:andUse('Commander')

-- Install:andUse('HoldToQuit', {
--   start = true,
-- })

Install:andUse('Caffeine')
local caffeine = spoon.Caffeine:start()
caffeine.clicked()

Install:andUse('BingDaily')

Install:andUse('RoundedCorners', { start = true })

Install:andUse('TextClipboardHistory', {
  start = true,
  config = {
    show_in_menubar = false,
    hist_size = 50,
    paste_on_select = false,
  },
  hotkeys = {
    toggle_clipboard = { hyper, 'v' },
  },
})

-- local col = hs.drawing.color.x11
-- Install:andUse('MenubarFlag', {
--   start = true,
--   config = {
--     colors = {
--       ['U.S.'] = {},
--       ['Ukrainian - PC'] = { col.blue, col.yellow },
--       ['Ukrainian'] = { col.blue, col.yellow },
--       ['Ukrainian+'] = { col.blue, col.yellow },
--     },
--   },
-- })

local chrome = 'com.google.Chrome'
-- local opera = 'com.operasoftware.Opera'
local safari = 'com.apple.Safari'
local firefox = 'org.mozilla.firefox'
-- local firefoxDev = "org.mozilla.firefoxdeveloperedition"
-- local vivaldi = 'com.vivaldi.Vivaldi'
-- local brave = 'com.brave.Browser'
-- local edge = 'com.microsoft.edgemac'
-- local arc = 'company.thebrowser.Browser'

-- local defBrowser = opera
-- local defBrowser = safari
-- local defBrowser = firefox
local defBrowser = firefox
-- local devBrowser = chrome
local devBrowser = chrome
-- local myBrowser = firefox
local myBrowser = safari
-- local zsuBrowser = chrome
local zsuBrowser = firefox
-- local googleBrowser = chrome
local googleBrowser = chrome

local function executeApplescript(appBandle, args)
  local appName = hs.application.get(appBandle):name()
  local script = string.format(
    [[
        tell application "%s" to activate
        do shell script "open -a '%s' %s"
    ]],
    appName,
    appName,
    args
  )
  hs.osascript.applescript(script)
end

local fireIf = function(browser)
  return function(url)
    local target = defBrowser
    if hs.application.find(browser) then
      target = browser
    end
    executeApplescript(target, url)
  end
end

local function openFFContainer(container)
  return function(url)
    local target = defBrowser
    local theUrl = url
    local firefox = 'org.mozilla.firefox'
    if hs.application.get(firefox) then
      target = firefox
      theUrl = "'ext+container:name=" .. container .. '&url=' .. url .. "'"
      executeApplescript(firefox, theUrl)
      return
    end
    hs.application.launchOrFocusByBundleID(target)
    hs.urlevent.openURLWithBundle(url, target)
  end
end

Install:andUse('URLDispatcher', {
  -- https://www.hammerspoon.org/Spoons/URLDispatcher.html
  start = false,
  -- Enable debug logging if you get unexpected behavior
  loglevel = 'info',
  config = {
    url_patterns = {
      -- messingers
      { 'msteams:', 'com.microsoft.teams2' },
      { 'zoommtg:', 'us.zoom.xos' },
      { 'tg:',      'ru.keepcoder.Telegram' },
      -- vezha
      {
        {
          'https://lab.volvo.mito/.*',
          'https://identity.ganesha.karmf.net/admin/.*',
          'https://github.com/vezhadev/.*',
          'https://github.com/orgs/vezhadev/.*',
          'https://github.com/orgs/gtakontur/.*',
          'https://.*mil.gov.ua/.*',
          'https://.*mil.ua/.*',
          'https://.*oak.in.ua/.*',
          'https://grafana.*/explore.*',
          'https://data.*/graphql/.*',
          'https://.*nextcloud.karmf.net/.*',
          'https://.*.mq.eu-central-1.amazonaws.com/.*',
          'https://.*forms.office.com/.*',
          'https://.*green-house-corp.atlassian.net/.*',
          'https://.*id.atlassian.com/.*',
        },
        openFFContainer('Zsu'),
      },
      -- zsu
      {
        {
          'https://.*vezha.live/.*',
          'https://.*karmf.net/.*',
          'https://.*vezhalive.sentry.io/.*',
        },
        zsuBrowser,
        fireIf(zsuBrowser),
      },
      -- dev http://localhost:8080
      {
        { '.*localhost.*', '.*127%.0%.0%.1.*' },
        devBrowser,
        fireIf(devBrowser),
      },
      --
      {
        { 'https?://.*meet.google.com/.*', 'https?://.*chat.google.com/.*' },
        googleBrowser,
        fireIf(googleBrowser),
      },
      -- bank
      {
        { 'https?://.*otpay.com.ua.*', 'https?://.*otpsmart.com.ua.*' },
        openFFContainer('Banking'),
      },
      -- youtube
      {
        { 'https?://.*youtube.com.*', 'https?://.*maps%.google%.com.*' },
        openFFContainer('Personal'),
      },
    },
    url_redir_decoders = {
      {
        'MS Teams URLs',
        '(https?://teams%.microsoft%.com.*)',
        'msteams:%1',
        true,
      },
      {
        'Zoom URLs',
        'https?://.*zoom%.us/j/(%d+)%?pwd=(%w)',
        'zoommtg://zoom.us/join?confno=%1&pwd=%2',
        true,
      },
      {
        'Telegram URLs',
        'https?://t.me/(.*)',
        'tg://t.me/%1',
        true,
      },
      {
        'Fix broken Preview anchor URLs',
        '%%23',
        '#',
        false,
        'Preview',
      },
    },
    default_handler = defBrowser, -- create function here
  },
})

spoon.SpoonInstall:asyncUpdateAllRepos()
