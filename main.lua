-----------------------------------------------------------------------------------------
--
-- main.lua
-- Copyright 2012 Darren Gates. All Rights Reserved.
-----------------------------------------------------------------------------------------

-- global module objects

-- these globals must be set on a per-game basis
game = "soccer" -- will be used to load soccer.xml and soccer.png

-- include utility functions
require("scripts.utility")
require("scripts.settings")

local storyboard = require "storyboard"

display.setStatusBar(display.HiddenStatusBar)

function main()
    -- verify that main is running!
    print( "hello from main" )
    
    -- create the login/registration scene
	storyboard.gotoScene("scripts.scene_login")    

end

main()

