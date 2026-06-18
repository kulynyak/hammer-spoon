--- util.lua — Shared utility functions.
--  keyUpDown:  wrapper around hs.eventtap.keyStroke with 0 delay
--  withCopiedSelection: async clipboard polling for Cmd+C operations

local keyUpDown = function(modifiers, key)
  -- Un-comment & reload config to log each keystroke that we're triggering
  -- log.d('Sending keystroke:', hs.inspect(modifiers, key)
  hs.eventtap.keyStroke(modifiers, key, 0)
end

local function withCopiedSelection(callback)
  local original = hs.pasteboard.getContents()
  hs.eventtap.keyStroke({ 'cmd' }, 8)

  local function poll(attempt)
    local selected = hs.pasteboard.getContents()
    if selected ~= original then
      callback(selected, original)
    elseif attempt < 10 then
      hs.timer.doAfter(0.05, function()
        poll(attempt + 1)
      end)
    end
  end

  hs.timer.doAfter(0.05, function()
    poll(1)
  end)
end

return {
  keyUpDown = keyUpDown,
  withCopiedSelection = withCopiedSelection,
}
