--- init.lua — Hammerspoon config entry point.
--  Hyper key = Cmd+Opt+Shift+Ctrl (all four)
--  Coc key  = Ctrl+Opt+Cmd (three-finger chord)
require('hs.ipc')
-- hs.logger.defaultLogLevel = "debug"
hs.logger.defaultLogLevel = 'nothing'
--

-- Modifier chords used throughout the config
-- hyper (4-finger) for app switching, window layout, keyboard fix
-- coc (3-finger) for system actions: lock, hide, paste, reload
local hyper = { 'command', 'option', 'shift', 'control' }
local coc = { 'control', 'option', 'command' }

-- require('delete-words') -- conflicts with Astronvim/NvChad
require('windows')
require('spoons')
local launchApps = require('launch')
require('notify')

-- require 'signal-watcher'

-- setup apps {{{
require('apps')(hyper)
-- }}}

-- setup keyboard layout fix {{{
local kbl = require('kbl')
hs.hotkey.bind(hyper, '0', nil, kbl.fix)
hs.hotkey.bind(hyper, '6', nil, kbl.toUpper)
hs.hotkey.bind(hyper, '7', nil, kbl.toLower)
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
local function muteOnWake(eventType)
  if eventType == hs.caffeinate.watcher.systemDidWake then
    local output = hs.audiodevice.defaultOutputDevice()
    output:setMuted(muteSound)
  end
end

-- Wake handler: re-launch hidden apps + re-mute audio {{{
local wakeHandler = hs.caffeinate.watcher.new(function(eventType)
  muteOnWake(eventType)
  if eventType == hs.caffeinate.watcher.systemDidWake then
    launchApps()
  end
end)
wakeHandler:start()
-- }}}

-- force to switch desktop keyboard layout after start {{{
hs.keycodes.setLayout('ABC')
local kbdTable = { en = 'ABC', uk = 'Ukrainian Slashes' }
local function setKbd(src)
  local keyL = kbdTable[src]
  hs.keycodes.setLayout(keyL)
end

-- }}}

-- force to set desired keyboard layout for apps on open/focus {{{
local appLayout = {}
for _, entry in ipairs(require('apps-def')) do
  local path = entry[2]
  if path then
    appLayout[path] = entry[3]
  end
end

hs.window.filter.default:subscribe(
  hs.window.filter.windowFocused,
  function(window, _)
    local path = window:application():path()
    local im = appLayout[path]
    if im then
      setKbd(im)
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

-- Reload config {{{
hs.hotkey.bind(coc, '`', nil, hs.reload)
hs.notify
  .new({ title = 'Hammerspoon', informativeText = 'Ready to rock' })
  :send()
-- }}}

-- Toggle console {{{
hs.hotkey.bind(coc, '6', nil, hs.toggleConsole)
-- }}}
