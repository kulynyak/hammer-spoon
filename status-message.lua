local drawing = require 'hs.drawing'
local geometry = require 'hs.geometry'
local screen = require 'hs.screen'
local styledtext = require 'hs.styledtext'

local statusmessage = {}

statusmessage.new = function(messageText)
    local buildParts = function(msgText)
        local frame = screen.primaryScreen():frame()

        local styledText = styledtext.new('🔨 ' .. msgText, {
            font = {
                name = 'Monaco',
                size = 24
            }
        })

        local styledTextSize = drawing.getTextDrawingSize(styledText)

        local textRect = {
            x = frame.w - styledTextSize.w - 40,
            y = frame.h - styledTextSize.h,
            w = styledTextSize.w + 40,
            h = styledTextSize.h + 40
        }

        local background = drawing.rectangle {
            x = frame.w - styledTextSize.w - 45,
            y = frame.h - styledTextSize.h - 3,
            w = styledTextSize.w + 15,
            h = styledTextSize.h + 6
        }
        background:setRoundedRectRadii(10, 10)
        background:setFillColor({
            red = 250,
            green = 206,
            blue = 250,
            alpha = 0.3
        })

        local text = drawing.text(textRect, styledText):setAlpha(0.8)

        return background, text
    end

    local status = {
        _buildParts = buildParts,
        show = function(self)
            self:hide()
            self.background, self.text = self._buildParts(messageText)
            self.background:show()
            self.text:show()
        end,
        hide = function(self)
            if self.background then
                self.background:delete()
                self.background = nil
            end
            if self.text then
                self.text:delete()
                self.text = nil
            end
        end,
        notify = function(self, seconds)
            self:show()
            hs.timer.doAfter(seconds or 1, function()
                self:hide()
            end)
        end
    }
    return status
end

return statusmessage
