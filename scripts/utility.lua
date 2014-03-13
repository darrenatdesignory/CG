-- utility functions
local widget = require("widget")
local textFields = {}

-- split string to a table (like PHP explode)
function explode(div, str)
    if (div=='') then return false end
    local pos,arr = 0,{}
    for st,sp in function() return string.find(str,div,pos,true) end do
        table.insert(arr,string.sub(str,pos,st-1))
        pos = sp + 1
    end
    table.insert(arr,string.sub(str,pos))
    return arr
end

--table dumper
function dump(t, indent)
	
	local notindent = (indent == nil)
	if (notindent) then print('-----dump-----'); indent='{}'; end
	if (t and type(t) == 'table') then
			for k, v in pairs(t) do
					if (type(k) ~= 'number') then
							print(indent .. '.' .. k .. ' = ' .. tostring(v))
							if (indent) then
									dump(v, indent..'.'..k)
							end
					end
			end
			for i=1, #t do
					print(indent .. '[' .. i .. '] = ' .. tostring(t[i]))
					dump(t[i], indent .. '[' .. i .. ']')
			end
	end
	if (notindent) then print('-----dump-----'); end
end 


-- form UI elements
function formLabel(group, name, x, y, width, height)
        
        if ( width ~= nil ) then
            
            if ( height == nil ) then
                height = "auto"
            end
            
            -- use widget candy text 
            local theText = _G.GUI.NewText(
            {
                x		= x - 6, -- adjustment
                y		= y,
                parentGroup     = group, 
                scale		= _G.GUIScale,                    
                theme           = _G.theme,
                width       = width,
                fontSize    = fontSize + 2,
                height      = height,
                caption     = name,
                textAlign   = "left"
            } )  
            return theText

        else
            -- use built-in corona label
            local temp = display.newText(group, name, x, y, font, fontSize)
            temp:setFillColor(fontColor1,fontColor2,fontColor3)
            temp.anchorX = 0

            return temp 
        end
end

function formLabelHTML(group, htmlFile, x, y, width, height, listener) 
    if height == nil then
        height = display.contentHeight - 60
    end
    if width == nil then
        width = display.contentWidth
    end

    -- this is a global object so that we can remove it in the listener function   
    webView = native.newWebView( x , y, width, height ) 
    
    if listener ~= nil then
    	webView:addEventListener("urlRequest", listener)
    end

    webView.hasBackground = false
    webView.anchorX = 0
    webView.anchorY = 0
    group:insert(webView)
    webView:request(htmlFile, system.ResourceDirectory)
end

-- similar to Label, but header of column
function formHeader(group, name, x, y)
	local temp = display.newText(group, name, x, y, fontBold, fontSize)
	temp:setFillColor(fontColor1,fontColor2,fontColor3)
	return temp
end

function formTextField(group, x, y, w, h)
	local temp = native.newTextField(x, y, w, h)
        
	temp.anchorX = 0
       
	temp:setTextColor(fontColor1, fontColor2, fontColor3)
	temp.font = native.newFont(font, fontSize * inputTextScale)
	temp.hasBackground = false
        
        table.insert(textFields, temp)
        --temp.isVisible = false
        
	temp:addEventListener('userInput', fieldHandler)
	
	-- set image behind this text input
	local tempBorder = display.newRoundedRect(temp.x - 2, temp.y, temp.width + 2, temp.height + 4, 3)
	tempBorder.anchorX = 0
	tempBorder:setFillColor(100,100,100)
	tempBorder:setStrokeColor(0, 0, 0, 0.2)
	tempBorder.strokeWidth = 2
	
	group:insert(temp)
	group:insert(tempBorder)
	
	return temp
end

function formButton(group, name, x, y, handler)

	local loginBtn = _G.GUI.NewButton({
		x               = x - (4*scale),
		y		= y - (20*scale),
		parentGroup     = group, 
		scale		= scale,                    
		theme           = _G.theme,
		textAlign	= "center",
		caption		= name,
		onPress		= handler
	})
end

-- draws a horizontal line
function formHLine(group, x1, y1, x2, y2)
    
    if ( x2 == nil ) then
        x2 = display.contentWidth
    end
    
    if ( y2 == nil ) then
       y2 = y1
    end
    
    local theNewLine = display.newLine(x1, y1, x2, y2)
    theNewLine.width = 1
    group:insert(theNewLine)
end

function enableTextFields() 
    
    -- reenable all text fields
    for i,j in pairs(textFields) do 
        j.isVisible = true
    end
end

function disableTextFields()
    
    for i,j in pairs(textFields) do
        j.isVisible = false
    end
end

function tabIconBar(group)
	-- CREATE A HORIZONTAL BAR
	_G.GUI.NewIconBar(
		{
		x               = "right",                
		y               = "bottom",                
		width           = "100%",
		height          = 60,
		scale           = _G.GUIScale,
		name            = "NAVBAR",            
		parentGroup     = group,                     
		theme           = theme,               
		border          = {"normal", 1, 0, .37,.37,.37,0.1,  .37,.37,.37,.1}, 
		bgImage         = {"images/iconbar_background.png", .45, "add" },
		marker          = {4,1, 1,1,1,.39,  0,0,0,.1}, 
		glossy		= 0,
		iconSize        = 32,
		fontSize        = 10,
		textColor       = {.7,.7,.7},
		textColorActive = {0.1,0.1,0.1},
		textAlign       = "bottom",
		iconAlign       = "top",

		icons           = 
			{
				{image = "images/navbar/home.png" , baseDir = system.ResourceDirectory, flipX = false, text = "Home"},
				{image = "images/navbar/wizard.png" , baseDir = system.ResourceDirectory, flipX = false, text = "Setup Wizard"},
				{image = "images/navbar/calendar.png", baseDir = system.ResourceDirectory, flipX = false, text = "Calendar"},
				{image = "images/navbar/media.png", baseDir = system.ResourceDirectory, flipX = false , text = "Photos/Videos"},
				{image = "images/navbar/playbook.png", baseDir = system.ResourceDirectory, flipX = false, text = "Playbook"},
				{image = "images/navbar/reports.png", baseDir = system.ResourceDirectory, flipX = false, text = "Reports"}
			},

		onPress         = function(EventData) iconBarHandler(EventData.selectedIcon) end, 
		-- onRelease    = function(EventData) EventData.Widget:setMarker(0) end,
		} )
end

function lightbox(group, caption, contents)

    -- temporarily disable all text fields to avoid the "tap-through" problem
    disableTextFields()
    
    local obj = formLabel(group, contents, 0, 0, 388, 2000)

    local scrollView = widget.newScrollView {

        top = 40,
        left = 15,
        width = obj.width,
        height = 280,
        scrollWidth = 300,
        scrollHeight = 600,
        hideBackground = true,
    }

    scrollView.hideBackground = true

    scrollView:insert(obj)

    local win = _G.GUI.NewWindow(
     {
         scale = scale,
         x = 100,
         y = 50,
         width = display.contentWidth / 2 + 40,
         height = 240,
         name   = "temp",
         dragX = "true",
         dragY = "true",
         theme  = theme,
         closeButton = true,
         modal = false,
         noTitle = false,
         shadow = false,
         parentGroup = group,
         caption = "    " .. caption,
         onClose  = function(EventData) _G.GUI.GetHandle("temp"):destroy(); enableTextFields(); end,
     })

     win:insert(scrollView)

end
