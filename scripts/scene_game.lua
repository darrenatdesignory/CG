local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

----------------------------------------------------------------------------------
-- 
--      NOTE:
--      
--      Code outside of listener functions (below) will only be executed once,
--      unless storyboard.removeScene() is called.
-- 
---------------------------------------------------------------------------------


-- local forward references should go here --


---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------


local function exitGameView(event)
	
	storyboard:gotoScene("scripts.scene_login", storyboardOptions)
	
	webView.isVisible = true
	--webView:request("html/login.html", system.ResourceDirectory)

	local navBarHandle = _G.GUI.GetHandle("NAVBAR")
	navBarHandle.isVisible = true
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	print("now in createScene")

	local group = self.view

-----------------------------------------------------------------------------

--      CREATE display objects and add them to 'group' here.
--      Example use-case: Restore 'group' from previously saved state.

-----------------------------------------------------------------------------

	-- include the grid module here, and initialize
	-- the game grid object
	
	local grid = require "scripts.grid"
	
	grid.group = group
	grid.buildGrid(game) -- game is set in main.lua
	
	-- add a button to exit to navigation bar forms
	local exitButton = display.newImageRect( group, "images/exit.png", 40, 40 )
	exitButton.y = display.contentHeight - 20
	exitButton.x = display.contentWidth - 20
	
	exitButton:addEventListener("tap", exitGameView)
end


-- Called BEFORE scene has moved onscreen:
function scene:willEnterScene( event )
   local group = self.view

 -----------------------------------------------------------------------------

 --      This event requires build 2012.782 or later.

 -----------------------------------------------------------------------------

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view

	 -----------------------------------------------------------------------------

	--      INSERT code here (e.g. start timers, load audio, start listeners, etc.)

	-----------------------------------------------------------------------------

end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	 local group = self.view

	 -----------------------------------------------------------------------------

	 --      INSERT code here (e.g. stop timers, remove listeners, unload     sounds,etc.)

-----------------------------------------------------------------------------

end


-- Called AFTER scene has finished moving offscreen:
function scene:didExitScene( event )
	local group = self.view

-----------------------------------------------------------------------------

--      This event requires build 2012.782 or later.

-----------------------------------------------------------------------------

end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	 local group = self.view

	 -----------------------------------------------------------------------------

	 --      INSERT code here (e.g. remove listeners, widgets, save state, etc.)

	 -----------------------------------------------------------------------------

end


-- Called if/when overlay scene is displayed via storyboard.showOverlay()
function scene:overlayBegan( event )
	 local group = self.view
	 local overlay_name = event.sceneName  -- name of the overlay scene

	 -----------------------------------------------------------------------------

	 --      This event requires build 2012.797 or later.

	 -----------------------------------------------------------------------------

end


-- Called if/when overlay scene is hidden/removed via storyboard.hideOverlay()
function scene:overlayEnded( event )
	 local group = self.view
	 local overlay_name = event.sceneName  -- name of the overlay scene

	 -----------------------------------------------------------------------------

	 --      This event requires build 2012.797 or later.

	 -----------------------------------------------------------------------------

end



---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "willEnterScene" event is dispatched before scene transition begins
scene:addEventListener( "willEnterScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "didExitScene" event is dispatched after scene has finished transitioning out
scene:addEventListener( "didExitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-- "overlayBegan" event is dispatched when an overlay scene is shown
scene:addEventListener( "overlayBegan", scene )

-- "overlayEnded" event is dispatched when an overlay scene is hidden/removed
scene:addEventListener( "overlayEnded", scene )

---------------------------------------------------------------------------------

return scene