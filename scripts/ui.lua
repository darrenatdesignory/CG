-- ui.lua (currently includes Button class with labels, font selection and optional event model)

-- Version 1.5 (works with multitouch, adds setText() method to buttons)
--
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of 
-- this software and associated documentation files (the "Software"), to deal in the 
-- Software without restriction, including without limitation the rights to use, copy, 
-- modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
-- and to permit persons to whom the Software is furnished to do so, subject to the 
-- following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all copies 
-- or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
-- DEALINGS IN THE SOFTWARE.

module(..., package.seeall)

-----------------
-- Helper function for newButton utility function below
local function newButtonHandler(self, event)

    local result = true

    local default = self[2]
    local over = self[3]

    -- General "onEvent" function overrides onPress and onRelease, if present
    local onEvent = self._onEvent

    local onPress = self._onPress
    local onRelease = self._onRelease

    local buttonEvent = {}
    buttonEvent.target = self
    if (self._id) then
        buttonEvent.id = self._id
    end
    if self._region then
        buttonEvent.region = self._region
    end
    
    local phase = event.phase

    if phase ~= "began" and self.isFocus ~= true then
        return false
    end

    if phase == "moved" then --and self.isFocus ~= true then
        --print("button phase:" .. phase)
        if math.abs(event.x - event.xStart) > 30 then
            default.isVisible = true
            over.isVisible = false
            self.isFocus = false
            display.getCurrentStage():setFocus(self, nil)
        end
        return false
    end


    if "began" == phase then
        if over then
            default.isVisible = false
            over.isVisible = true
        end

        if onEvent then
            buttonEvent.phase = "press"
            result = onEvent(buttonEvent)
        elseif onPress then
            result = onPress(event)
        end

        -- Subsequent touch events will target button even if they are outside the contentBounds of button
        display.getCurrentStage():setFocus(self, event.id)
        self.isFocus = true

    elseif self.isFocus then
        print("button focused")
        local bounds = self.contentBounds
        local x, y = event.x, event.y
        local isWithinBounds =
        bounds.xMin <= x and bounds.xMax >= x and bounds.yMin <= y and bounds.yMax >= y

        if "moved" == phase then
            if over then
                -- The rollover image should only be visible while the finger is within button's contentBounds
                default.isVisible = not isWithinBounds
                over.isVisible = isWithinBounds
            end

        elseif "ended" == phase or "cancelled" == phase then
            if over then
                default.isVisible = true
                over.isVisible = false
            end

            if "ended" == phase then
                -- Only consider this a "click" if the user lifts their finger inside button's contentBounds
                if isWithinBounds then
                    if onEvent then
                        buttonEvent.phase = "release"
                        result = onEvent(buttonEvent)
                    elseif onRelease then
                        result = onRelease(event)
                    end
                end
            end

            -- Allow touch events to be sent normally to the objects they "hit"
            display.getCurrentStage():setFocus(self, nil)
            self.isFocus = false
        end
    end

    return result
end


---------------
-- Button class
function newButtonWithBackground(params)
    local button, default, over, size, font, textColor, offset
    local w, h = params.dim, params.dim
    if params.w ~= nil then
        w = params.w
    end
    if params.h ~= nil then
        h = params.h
    end
    if params.default then

        local bkrect = display.newRoundedRect(0, 0, w, h, 14)
        bkrect:setFillColor(0, 0, 0, 0)
        button = display.newGroup(bkrect)
        --	button:insert(bkrect)
        default = display.newImageRect(params.default, w, h)
        default.y = -button.height * .5 + default.height * .5
        button:insert(default)
    end

    if params.over then
        over = display.newImageRect(params.over, w, h)
        over.isVisible = false
        over.y = -button.height * .5 + over.height * .5
        button:insert(over)
    end
    
    if params.coin ~= nil then
        if params.coin > 0 then
            local coin = display.newImageRect("Coin"..params.coin..".png", 64,56)
            coin.y = -button.height*.5 + coin.height*.25
            coin.x = button.width*.5 - coin.width*.25
            button:insert(coin)
        end
    end

    -- Public methods
    function button:Refresh(param)
        if self.score ~= nil then
            self.score:setText(param.score)
        else
            button:SetScore(param.text)
        end

        if self.text ~= nil then
            self.text:setText(param.levelText)
        else
            button:setText(param.levelText)
        end
        local default = button[2]
        local over = button[3]
        default:removeSelf()
        default = nil
        over:removeSelf()
        over = nil
        default = display.newImageRect(param.default, param.dim, param.dim)
        default.y = -button.height * .5 + default.height * .5
        button:insert(default, 2)
        over = display.newImageRect(param.over, param.dim, param.dim)
        over.isVisible = false
        over.y = -button.height * .5 + over.height * .5
        button:insert(over, 3)
    end

    function button:SetScore(newText)
        local labelText = self.score
        if (labelText) then
            labelText:removeSelf()
            self.score = nil
        end
        local size = 18
        if (params.font) then font = params.font else font = "GROBOLD" end
        -- if (params.textColor) then textColor = params.textColor else textColor = { 189, 16, 7, 255 } end

        labelText = display.newText(newText, 0, 0, font, size)
        labelText:setTextColor(189, 16, 7, 255)
        button:insert(labelText, true)
        labelText.y = 33 --default.height * .5
        self.score = labelText
    end

    function button:setText(newText)

        local labelText = self.text
        if (labelText) then
            labelText:removeSelf()
            self.text = nil
        end

        local labelShadow = self.shadow
        if (labelShadow) then
            labelShadow:removeSelf()
            self.shadow = nil
        end

        local labelHighlight = self.highlight
        if (labelHighlight) then
            labelHighlight:removeSelf()
            self.highlight = nil
        end

        if (params.size and type(params.size) == "number") then size = params.size else size = 20 end
        if (params.font) then font = params.font else font = "GROBOLD" end
        --if (params.textColor) then textColor = params.textColor else textColor = { 254, 245, 105, 255 } end

        -- Optional vertical correction for fonts with unusual baselines (I'm looking at you, Zapfino)
        if (params.offset and type(params.offset) == "number") then offset = params.offset else offset = 0 end

        if (params.emboss) then
            -- Make the label text look "embossed" (also adjusts effect for textColor brightness)
            local textBrightness = (254 + 245 + 105) / 3

            --[[ labelHighlight = display.newText(newText, 0, 0, font, size)
          if (textBrightness > 127) then
            labelHighlight:setTextColor(255, 255, 255, 20)
          else
            labelHighlight:setTextColor(255, 255, 255, 140)
          end
          button:insert(labelHighlight, true)
          labelHighlight.x = labelHighlight.x - 3.5; labelHighlight.y = labelHighlight.y + 1.5 + offset
          self.highlight = labelHighlight]]

            labelShadow = display.newText(newText, 0, 0, font, size + 4)
            labelShadow:setTextColor(0, 0, 0, 255)
            button:insert(labelShadow, true)
            labelShadow.x = labelShadow.x - 5.5; --labelShadow.y = labelShadow.y - 1 + offset
            self.shadow = labelShadow
        end

        labelText = display.newText(newText, 0, 0, font, size)
        labelText:setTextColor(254, 245, 105, 255)
        button:insert(labelText, true)
        labelText.x = -5
        --labelText.y = -labelText.height * .5  -- -default.height * .5 + labelText.height
        self.text = labelText
    end

    if params.text and params.locked == false then
        button:SetScore(params.text)
        button:setText(params.levelText)
    end

    if (params.onPress and (type(params.onPress) == "function")) then
        button._onPress = params.onPress
    end
    if (params.onRelease and (type(params.onRelease) == "function")) then
        button._onRelease = params.onRelease
    end

    if (params.onEvent and (type(params.onEvent) == "function")) then
        button._onEvent = params.onEvent
    end

    -- Set button as a table listener by setting a table method and adding the button as its own table listener for "touch" events
    button.touch = newButtonHandler
    button:addEventListener("touch", button)

    if params.x then
        button.x = params.x
    end

    if params.y then
        button.y = params.y
    end

    if params.id then
        button._id = params.id
    end
    if params.region then
        button._region = params.region
    end
    
    return button
end

function newButton(params)
    local button, default, over, size, font, textColor, offset

    if params.default then



        button = display.newGroup()

        default = display.newImageRect(params.default, params.dim, params.dim)

        button:insert(default)
    end

    if params.over then
        over = display.newImageRect(params.over, params.dim, params.dim)
        over.isVisible = false

        button:insert(over, true)
    end

    -- Public methods
    function button:setText(newText)

        local labelText = self.text
        if (labelText) then
            labelText:removeSelf()
            self.text = nil
        end

        local labelShadow = self.shadow
        if (labelShadow) then
            labelShadow:removeSelf()
            self.shadow = nil
        end

        local labelHighlight = self.highlight
        if (labelHighlight) then
            labelHighlight:removeSelf()
            self.highlight = nil
        end

        if (params.size and type(params.size) == "number") then size = params.size else size = 20 end
        if (params.font) then font = params.font else font = native.systemFontBold end
        if (params.textColor) then textColor = params.textColor else textColor = { 255, 255, 255, 255 } end

        -- Optional vertical correction for fonts with unusual baselines (I'm looking at you, Zapfino)
        if (params.offset and type(params.offset) == "number") then offset = params.offset else offset = 0 end

        if (params.emboss) then
            -- Make the label text look "embossed" (also adjusts effect for textColor brightness)
            local textBrightness = (textColor[1] + textColor[2] + textColor[3]) / 3

            labelHighlight = display.newText(newText, 0, 0, font, size)
            if (textBrightness > 127) then
                labelHighlight:setTextColor(255, 255, 255, 20)
            else
                labelHighlight:setTextColor(255, 255, 255, 140)
            end
            button:insert(labelHighlight, true)
            labelHighlight.x = labelHighlight.x + 1.5; labelHighlight.y = labelHighlight.y + 1.5 + offset
            self.highlight = labelHighlight

            labelShadow = display.newText(newText, 0, 0, font, size)
            if (textBrightness > 127) then
                labelShadow:setTextColor(0, 0, 0, 128)
            else
                labelShadow:setTextColor(0, 0, 0, 20)
            end
            button:insert(labelShadow, true)
            labelShadow.x = labelShadow.x - 1; labelShadow.y = labelShadow.y - 1 + offset
            self.shadow = labelShadow
        end

        labelText = display.newText(newText, 0, 0, font, size)
        labelText:setTextColor(textColor[1], textColor[2], textColor[3], textColor[4])
        button:insert(labelText, true)
        labelText.y = labelText.y + offset
        self.text = labelText
    end

    if params.text then
        button:setText(params.text)
    end

    if (params.onPress and (type(params.onPress) == "function")) then
        button._onPress = params.onPress
    end
    if (params.onRelease and (type(params.onRelease) == "function")) then
        button._onRelease = params.onRelease
    end

    if (params.onEvent and (type(params.onEvent) == "function")) then
        button._onEvent = params.onEvent
    end

    -- Set button as a table listener by setting a table method and adding the button as its own table listener for "touch" events
    button.touch = newButtonHandler
    button:addEventListener("touch", button)

    if params.x then
        button.x = params.x
    end

    if params.y then
        button.y = params.y
    end

    if params.id then
        button._id = params.id
    end

    return button
end

--------------
-- Label class
function newLabel(params)
    local labelText
    local size, font, textColor, align
    local t = display.newGroup()

    if (params.bounds) then
        local bounds = params.bounds
        local left = bounds[1]
        local top = bounds[2]
        local width = bounds[3]
        local height = bounds[4]

        if (params.size and type(params.size) == "number") then size = params.size else size = 20 end
        if (params.font) then font = params.font else font = native.systemFontBold end
        if (params.textColor) then textColor = params.textColor else textColor = { 255, 255, 255, 255 } end
        if (params.offset and type(params.offset) == "number") then offset = params.offset else offset = 0 end
        if (params.align) then align = params.align else align = "center" end

        if (params.text) then
            labelText = display.newText(params.text, 0, 0, font, size)
            labelText:setTextColor(textColor[1], textColor[2], textColor[3], textColor[4])
            t:insert(labelText)
            -- TODO: handle no-initial-text case by creating a field with an empty string?

            if (align == "left") then
                labelText.x = left + labelText.contentWidth * 0.5
            elseif (align == "right") then
                labelText.x = (left + width) - labelText.contentWidth * 0.5
            else
                labelText.x = ((2 * left) + width) * 0.5
            end
        end

        labelText.y = top + labelText.contentHeight * 0.5

        -- Public methods
        function t:setText(newText)
            if (newText) then
                labelText.text = newText

                if ("left" == align) then
                    labelText.x = left + labelText.contentWidth / 2
                elseif ("right" == align) then
                    labelText.x = (left + width) - labelText.contentWidth / 2
                else
                    labelText.x = ((2 * left) + width) / 2
                end
            end
        end

        function t:setTextColor(r, g, b, a)
            local newR = 255
            local newG = 255
            local newB = 255
            local newA = 255

            if (r and type(r) == "number") then newR = r end
            if (g and type(g) == "number") then newG = g end
            if (b and type(b) == "number") then newB = b end
            if (a and type(a) == "number") then newA = a end

            labelText:setTextColor(r, g, b, a)
        end
    end

    -- Return instance (as display group)
    return t
end