-- Default keybindings for WindowLayout Mode
--
-- To customize the key bindings for WindowLayout Mode, create a copy of this
-- file, save it as `windows-bindings.lua`, and edit the table below to
-- configure your preferred shortcuts.
--
--------------------------------------------------------------------------------
-- WindowLayout Mode
--
--   Activate:  ⌃⌥⌘+S  (control+option+command+s)
--   Deactivate: same chord again, or any mapped key (exits after action)
--
-- Within the mode:
--   h  → left half
--   j  → bottom half
--   k  → top half
--   l  → right half
--   H  (⇧+h) → left 40%
--   L  (⇧+l) → right 60%
--   i  → top-left quarter
--   o  → top-right quarter
--   ,  → bottom-left quarter
--   .  → bottom-right quarter
--   c  → center, 55% width
--   space → center, 80% width
--   return → full screen
--   n  → next monitor
--   right → monitor east
--   left  → monitor west
--------------------------------------------------------------------------------

return {
  modifiers = { 'control', 'option', 'command' },
  showHelp = true,
  trigger = 's',
  mappings = {
    { {},          'return', 'maximize' },
    { {},          'c',      'centerWithFullHeight' },
    { {},          'space',  'centerWithFullHeightLarge' },
    { {},          'h',      'left' },
    { {},          'j',      'down' },
    { {},          'k',      'up' },
    { {},          'l',      'right' },
    { { 'shift' }, 'h',      'left40' },
    { { 'shift' }, 'l',      'right60' },
    { {},          'i',      'upLeft' },
    { {},          'o',      'upRight' },
    { {},          ',',      'downLeft' },
    { {},          '.',      'downRight' },
    { {},          'n',      'nextScreen' },
    { {},          'right',  'moveOneScreenEast' },
    { {},          'left',   'moveOneScreenWest' },
  },
}
