--- spoons.lua — Spoon (plugin) setup.
--  Installs and configures community Spoons: Caffeine, BingDaily,
--  RoundedCorners, TextClipboardHistory.

hs.loadSpoon('SpoonInstall')
spoon.SpoonInstall.use_syncinstall = true

local hyper = { 'command', 'option', 'shift', 'control' }

local Install = spoon.SpoonInstall

Install:andUse('Caffeine')
local caffeine = spoon.Caffeine:start()
caffeine.clicked()

Install:andUse('BingDaily')

Install:andUse('RoundedCorners', { start = true, config = { radius = 12 } })

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

spoon.SpoonInstall:asyncUpdateAllRepos()
