-------------------------------
--[[ widget candy settings ]]--
-------------------------------

local theme = 2
_G.GUI = require("scripts.widget_candy")
_G.GUI.LoadTheme("theme_"..theme, "theme_"..theme.."/")-- LOAD THEME X
local physicalW = math.round( (display.contentWidth  - display.screenOriginX*2) / display.contentScaleX)
local physicalH = math.round( (display.contentHeight - display.screenOriginY*2) / display.contentScaleY)
_G.isTablet     = false
if physicalW >= 1024 or physicalH >= 1024 then 
	isTablet = true 
end
_G.GUIScale = 1
-- _G.GUI.SetLogLevel(2)
_G.theme = "theme_"..theme
_G.GUI.SetAllowedOrientations({"landscapeRight","landscapeLeft","portrait","portraitUpsideDown"})

-----------------------------
--[[ storyboard settings ]]--
-----------------------------

storyboardOptions =
{
    effect = "fade", -- formerly slideIn
    time = 0,
    params = { var1 = "custom", myVar = "another" }
}

--------------------------
--[[ UI font settings ]]--
--------------------------

font = native.systemFont
fontBold = native.systemFontBold
fontSize = 10
fontColor1 = 0
fontColor2 = 0
fontColor3 = 0
scale = 0.7 -- scale for all fonts
inputTextScale = 1.2 -- scale for input text fields

--local fontSize = 24 /  display.contentScaleY

-- the user input font scaling (for tablets)
if ( _G.isTablet == true ) then
    scale = 0.7
    inputTextScale = 3 
end

-- default color for all line objects
display.setDefault("lineColor", 0, 0, 0, 0.2)

lightboxVisible = false
webView = nil