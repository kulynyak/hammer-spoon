
local utf8 = require('hs.utf8')

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
    return res1, 'Ukrainian - Typography'
  else
    return res2, 'ABC'
  end
end

local function withCopiedSelection(callback)
  local original = hs.pasteboard.getContents()
  hs.eventtap.keyStroke({ 'cmd' }, 8)

  local function poll(attempt)
    local selected = hs.pasteboard.getContents()
    if selected ~= original then
      callback(selected, original)
    elseif attempt < 10 then
      hs.timer.doAfter(0.05, function() poll(attempt + 1) end)
    end
  end

  hs.timer.doAfter(0.05, function() poll(1) end)
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
