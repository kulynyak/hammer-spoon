local util = require('util')
local keyUpDown = util.keyUpDown

local utf8 = require('hs.utf8')

function utf8.sub(s, i, j)
  i = utf8.offset(s, i)
  j = utf8.offset(s, j + 1) - 1
  return string.sub(s, i, j)
end

local function makeTab(from, to)
  local map = {}
  for i = 1, utf8.len(from), 1 do
    local f, t = utf8.sub(from, i, i), utf8.sub(to, i, i)
    map[f] = t
  end
  return map
end

local en = "qwertyuiop[]\\asdfghjkl;'zxcvbnm,./QWERTYUIOP{}|ASDFGHJKL:\"ZXCVBNM<>?"
local uk = 'йцукенгшщзхї/фівапролджєячсмитьбю.ЙЦУКЕНГШЩЗХЇ|ФІВАПРОЛДЖЄЯЧСМИТЬБЮ,'

local enuk = makeTab(en, uk)
local uken = makeTab(uk, en)

local layouts = {
  -- ['U.S.'] = 'Ukrainian',
  -- ['Ukrainian'] = 'U.S.'
  ['ABC'] = 'Ukrainian - Typography',
  ['Ukrainian - Typography'] = 'ABC',
}

local function transform(text)
  -- TODO: try to recognize direction for more precize transformation
  local res1 = ''
  local res2 = ''
  local r1 = 0
  local r2 = 0
  for i = 1, utf8.len(text), 1 do
    local char = utf8.sub(text, i, i)
    local fix1 = enuk[char]
    local fix2 = uken[char]
    if fix1 then
      res1 = res1 .. fix1
      r1 = r1 + 1
    else
      res1 = res1 .. char
    end
    if fix2 then
      res2 = res2 .. fix2
      r2 = r2 + 1
    else
      res2 = res2 .. char
    end
  end
  if r1 > r2 then
    return res1
  else
    return res2
  end
end

local function fix()
  -- Preserve the current contents of the system clipboard
  local originalClipboardContents = hs.pasteboard.getContents()
  -- Copy the currently-selected text to the system clipboard
  keyUpDown('cmd', 'c')
  -- Allow some time for the command+c keystroke to fire asynchronously before
  -- we try to read from the clipboard
  hs.timer.doAfter(0.2, function()
    -- Construct the transformed output and paste it over top of the
    -- currently-selected text
    local selectedText = hs.pasteboard.getContents()
    local transformedText = transform(selectedText)
    hs.pasteboard.setContents(transformedText)
    keyUpDown('cmd', 'v')

    -- Allow some time for the command+v keystroke to fire asynchronously before
    -- we restore the original clipboard
    hs.timer.doAfter(0.2, function()
      hs.pasteboard.setContents(originalClipboardContents)
      local curLayout = hs.keycodes.currentLayout()
      hs.keycodes.setLayout(layouts[curLayout])
    end)
  end)
end

-- Use the utf8 library you already required at the top: local utf8 = require('hs.utf8')

local function transformCase(text, mode)
  if not text or text == '' then
    return ''
  end

  -- Use macOS styledtext engine for perfect UTF-8 casing
  local st = hs.styledtext.new(text)
  local transformed

  if mode == 'upper' then
    transformed = st:upper()
  elseif mode == 'lower' then
    transformed = st:lower()
  else
    -- Toggle logic: Check the first character using your existing utf8.sub
    local first = utf8.sub(text, 1, 1)
    local upperFirst = hs.styledtext.new(first):upper():getString()

    if first == upperFirst then
      transformed = st:lower()
    else
      transformed = st:upper()
    end
  end

  return transformed:getString()
end

local function runCaseFix(mode)
  local original = hs.pasteboard.getContents()

  -- Use keycodes 8 (C) and 9 (V) to avoid the "key not found" warning
  hs.eventtap.keyStroke({ 'cmd' }, 8)

  hs.timer.doAfter(0.2, function()
    local selected = hs.pasteboard.getContents()
    if not selected or selected == original then
      return
    end

    local newText = transformCase(selected, mode)
    hs.pasteboard.setContents(newText)

    hs.eventtap.keyStroke({ 'cmd' }, 9)

    hs.timer.doAfter(0.2, function()
      hs.pasteboard.setContents(original)
    end)
  end)
end

-- Create a table to export the functions
local M = {}

-- Export the original layout fixer
M.fix = fix
M.toUpper = function()
  runCaseFix('upper')
end
M.toLower = function()
  runCaseFix('lower')
end

return M
