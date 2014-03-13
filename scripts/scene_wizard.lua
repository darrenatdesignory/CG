local storyboard = require("storyboard")

local scene = storyboard.newScene()

webView = nil

local function webListener( event )

	local url = event.url

    if url == "corona:loadgame?" then
        print( "You are visiting: " .. event.url .. ' / ' .. url )
        storyboard:gotoScene("scripts.scene_game", storyboardOptions)
        
		webView:removeSelf()
	    webView = nil 
       

    end

    if event.type then
        print( "The event.type is " .. event.type ) -- print the type of request
    end

    if event.errorCode then
        native.showAlert( "Error!", event.errorMessage, { "OK" } )
    end
end

function scene:createScene( event )
    
    local group = self.view
    
       -- this will vary depending on the sport
    local background = display.newImageRect(group, "images/defaultbg.png", 480, 360)
    
    background.x = display.contentCenterX
    background.y = display.contentCenterY 
    
    formLabelHTML(group, "html/wizard.html", 0, 0, nil, 300, webListener)

    
	--[[
	local webView = native.newWebView( 0, 0, display.contentWidth * 2, display.contentHeight * 2, webListener )
	
	webView.hasBackground = false
	webView.anchorX = 0
	webView.anchorY = 0
	webView:request( "login.html" )

	webView:addEventListener( "urlRequest", webListener )

	group:insert(webView)
	--]]
	
    -- button to take us to the build scene
        
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
    local group = self.view    
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene