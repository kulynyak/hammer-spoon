-- open folder
local function directoryLaunchKeyRemap(mods, key, dir)
  hs.hotkey.bind(mods, key, function()
    local shell_command = 'open ' .. dir
    hs.execute(shell_command)
  end)
end

directoryLaunchKeyRemap({ 'ctrl' }, '1', '/Applications')
