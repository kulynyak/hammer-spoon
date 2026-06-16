
local utf8 = require('hs.utf8')
local withCopiedSelection = require('util').withCopiedSelection

function utf8.sub(s, i, j)
  i = utf8.offset(s, i)
  if not i then return nil end
  local j_off = j and utf8.offset(s, j + 1)
  if j_off then
    j = j_off - 1
  else
    j = #s
  end
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

local function transform(text)
  -- TODO: try to recognize direction for more precise transformation
  local t1, t2 = {}, {}
  local n1, n2 = 0, 0
  for i = 1, utf8.len(text), 1 do
    local char = utf8.sub(text, i, i)
    local fix1 = enuk[char]
    local fix2 = uken[char]
    if fix1 then
      t1[i] = fix1
      n1 = n1 + 1
    else
      t1[i] = char
    end
    if fix2 then
      t2[i] = fix2
      n2 = n2 + 1
    else
      t2[i] = char
    end
  end
  if n1 > n2 then
    return table.concat(t1), 'Ukrainian - Typography'
  else
    return table.concat(t2), 'ABC'
  end
end


local function fix()
  withCopiedSelection(function(selectedText, originalClipboardContents)
    local transformedText, targetLayout = transform(selectedText)
    hs.pasteboard.setContents(transformedText)
    hs.eventtap.keyStroke({ 'cmd' }, 9)

    hs.timer.doAfter(0.2, function()
      hs.pasteboard.setContents(originalClipboardContents)
      hs.keycodes.setLayout(targetLayout)
    end)
  end)
end


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
    -- Toggle logic: find first cased character, flip its case
    for i = 1, utf8.len(text) do
      local c = utf8.sub(text, i, i)
      local sc = hs.styledtext.new(c)
      if sc:upper():getString() ~= sc:lower():getString() then
        if c == sc:upper():getString() then
          transformed = st:lower()
        else
          transformed = st:upper()
        end
        break
      end
    end
    if not transformed then
      transformed = text
    end
  end

  return transformed:getString()
end

local function runCaseFix(mode)
  withCopiedSelection(function(selected, originalClipboard)
    local newText = transformCase(selected, mode)
    hs.pasteboard.setContents(newText)
    hs.eventtap.keyStroke({ 'cmd' }, 9)

    hs.timer.doAfter(0.2, function()
      hs.pasteboard.setContents(originalClipboard)
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
