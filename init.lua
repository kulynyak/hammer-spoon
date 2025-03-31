require('hs.ipc')
-- hs.logger.defaultLogLevel = "debug"
hs.logger.defaultLogLevel = 'nothing'
local log = hs.logger.new('init')

local hyper = { 'command', 'option', 'shift', 'control' }
local coc = { 'control', 'option', 'command' }

-- require('delete-words') -- conflicts with Astronvim/NvChad
-- require('windows')
require('spoons')
require('launch')
require('notify')

-- require 'signal-watcher'
hs.window.switcher.ui.fontName = 'Lucida Grande'
hs.window.switcher.ui.textSize = 12
hs.window.switcher.ui.textColor = { 1, 1, 1 }
hs.window.switcher.ui.titleBackgroundColor = { 0, 0, 0, 0 }
hs.window.switcher.ui.showThumbnails = true
hs.window.switcher.ui.thumbnailSize = 128
hs.window.switcher.ui.highlightColor = { 100 / 255, 149 / 255, 237 / 255, 1 }
hs.window.switcher.ui.backgroundColor = { 0.4, 0.4, 0.4, 0.6 }
hs.window.switcher.ui.showSelectedThumbnail = false
hs.window.switcher.ui.onlyActiveApplication = false
local switcher_space = hs.window.switcher.new()
hs.hotkey.bind('alt', 'tab', function()
  switcher_space:next()
end)
hs.hotkey.bind({'alt','shift'}, 'tab', function()
  switcher_space:previous()
end)

-- setup apps {{{
require('apps')(hyper)
-- }}}

-- setup keyboard layout fix {{{
local kbl = require('kbl')
hs.hotkey.bind(hyper, '0', nil, kbl)
-- }}}

-- setup translation {{{
local wm = hs.webview.windowMasks
local translator = require('PopupTranslateSelection')
translator.popup_style = wm.utility
  | wm.HUD
  | wm.titled
  | wm.closable
  | wm.resizable
translator:bindHotkeys({
  translate_uk_en = { hyper, '8' },
  translate_en_uk = { hyper, '9' },
})
-- }}}

-- Lock Screen - Ctrl+Opt+Cmd+\ {{{
hs.hotkey.bind(coc, '\\', nil, hs.caffeinate.lockScreen)
-- }}}

-- Hide all windows - Ctrl-Opt-Cmd-Y {{{
hs.hotkey.bind(coc, 'y', nil, function()
  -- loop over all running applications
  -- hide if not hidden
  -- except for Finder, for that, just close visible windows
  -- the 'Desktop' window will remain open
  local running = hs.application.runningApplications()
  for _, app in ipairs(running) do
    if app:isHidden() == false then
      if app:name() ~= 'Finder' then
        app:hide()
      else
        for _, win in ipairs(app:visibleWindows()) do
          win:close()
        end
      end
    end
  end
end)
-- }}}

-- Instant is better than animated {{{
hs.window.animationDuration = 0
hs.hints.style = 'vimperator'
-- }}}

-- Window shadows off {{{
hs.window.setShadows(false)
-- }}}

-- mute on wake {{{
local muteSound = true
function muteOnWake(eventType)
  if eventType == hs.caffeinate.watcher.systemDidWake then
    local output = hs.audiodevice.defaultOutputDevice()
    output:setMuted(muteSound)
  end
end

caffeinateWatcher = hs.caffeinate.watcher.new(muteOnWake)
caffeinateWatcher:start()
-- }}}

-- force to switch desktop keyboard layout after start {{{
hs.keycodes.setLayout('ABC')
kbdTable = { en = 'ABC', uk = 'Ukrainian' }
function setKbd(src)
  keyL = kbdTable[src]
  hs.keycodes.setLayout(keyL)
end

-- }}}

-- force to set desired keyboard layout for apps on open/focus {{{
local key2App = require('apps-def')
hs.window.filter.default:subscribe(
  hs.window.filter.windowFocused,
  function(window, appName)
    for key, app in pairs(key2App) do
      local path = app[2]
      local im = app[3]
      log.d('current: ' .. path .. ',path: ' .. window:application():path())
      if window:application():path() == path then
        if im then
          log.d('found: ' .. path .. ', im: ' .. im)
          -- hs.timer.doAfter(0.1, function() setKbd(im) end)
          setKbd(im)
        end
        break
      end
    end
  end
)
-- }}}

-- Use {{{
local kc = require('keychain')
hs.hotkey.bind(
  coc,
  'u',
  nil,
  hs.fnutils.partial(kc.pasteValue, kc, 'vpn.infra', 'username')
)
hs.hotkey.bind(
  coc,
  'p',
  nil,
  hs.fnutils.partial(kc.pasteValue, kc, 'vpn.infra', 'password')
)
--- }}}

-- {{{
-- Test
-- require('test')
-- }}}

-- Use coc + ` to reload Hammerspoon config {{{
hs.hotkey.bind(coc, '`', nil, hs.reload)
hs.notify
  .new({ title = 'Hammerspoon', informativeText = 'Ready to rock' })
  :send()
-- }}}

-- Use coc + ` to reload Hammerspoon config {{{
hs.hotkey.bind(coc, '6', nil, hs.toggleConsole)
-- }}}

-- local notifications = require('notifications')

-- -- Start the notifications module
-- notifications.start()

-- Stop the notifications module
-- notifications.stop()
