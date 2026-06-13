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
