local storyboard = require("storyboard")
local widget = require("widget")

-- navigation tab bar

local scene = storyboard.newScene()
local navigationBar = nil

local function onCameraComplete(event)
   local photo = event.target

   print( "onComplete called ..." )

   if photo then
       print( "photo w,h = " .. photo.width .. "," .. photo.height )
    end
end

function iconBarHandler(iconIndex)

	--_G.GUI.GetHandle("NAVBAR"):setMarker(iconIndex, true)

	-- update the html form as appropriate
	print("iconIndex = " .. iconIndex)
	
	_G.GUI.GetHandle("NAVBAR"):setMarker(iconIndex, true)
	
	if ( iconIndex == 1 ) then
		webView:request("html/login.html", system.ResourceDirectory)
		
	elseif ( iconIndex == 2 ) then
		webView:request("html/login.html?page=chooseSport", system.ResourceDirectory)
	
	elseif ( iconIndex == 3 ) then
		webView:request("html/login.html?page=calendar", system.ResourceDirectory)
	
	elseif ( iconIndex == 4 ) then
	
		if ( media.hasSource(media.Camera) ) then
			media.capturePhoto( {listener = onCameraComplete, destination = {baseDir=system.TemporaryDirectory, filename="image.jpg", type="image"} } )
		else
			native.showAlert( "Unsupported Media", "This device does not have a camera.", { "OK" } )
		end
	
		webView:request("html/login.html?page=media", system.ResourceDirectory)	
	
	elseif ( iconIndex == 5 ) then
		--open the playbook
        storyboard:gotoScene("scripts.scene_game", storyboardOptions)
        
        webView.isVisible = false
        
		--webView:removeSelf()
	    --webView = nil 
	    
	    local navBarHandle = _G.GUI.GetHandle("NAVBAR")
	    navBarHandle.isVisible = false
		
		--webView:request("html/login.html?page=playbook", system.ResourceDirectory)	
	
	elseif ( iconIndex == 6 ) then
		webView:request("html/login.html?page=reports", system.ResourceDirectory)	
	
	else
		-- invalid iconIndex?
	end
end

local function webListener( event )

	local url = event.url
	
	if string.find(url, "chooseSport") ~= nil then
    	print( "Now activating navigation bar: " .. event.url .. '/' .. url)
    	--storyboard:gotoScene("scripts.scene_wizard", storyboardOptions) 
        	
    	local navBarHandle = _G.GUI.GetHandle("NAVBAR")
    	
		-- SELECT ICON NUMBER 2

    	if ( navBarHandle == nil ) then
    		print("now creating icon bar")
    		tabIconBar(group)      		
    		navBarHandle = _G.GUI.GetHandle("NAVBAR")
		end
		
    	navBarHandle:setMarker(2) 
    	
    end

    if event.type then
        print( "The event.type is " .. event.type ) -- print the type of request
    end

	-- ignore -999 errors, show others
    if event.errorCode ~= -999 then
        native.showAlert( "Error!", event.errorMessage, { "OK" } )
    end
end

function scene:createScene( event )
    
    local group = self.view
    
       -- this will vary depending on the sport
    local background = display.newImageRect(group, "images/defaultbg.png", display.contentWidth, display.contentHeight)
    
    background.x = display.contentCenterX
    background.y = display.contentCenterY 
    
    formLabelHTML(group, "html/login.html", 0, 0, nil, nil, webListener)
        
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
    local group = self.view    
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene