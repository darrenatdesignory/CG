local grid = {}

-- Set initial variables to 0
grid.playerPosX = 0;
grid.playerPosY = 0;

grid.fieldCells = {}

grid.group = nil

-- width and height of the grid square (use 60 for 1024/768 field size)
grid.gridSize = 48

MultiTouch = require("scripts.dmc_multitouch")
XML = require("scripts.xml")

local xml = require( "scripts.xml" ).newParser()

grid.showBackground = function(game)

	-- this will vary depending on the sport
	local background = display.newImageRect(grid.group, "images/" .. game .. ".png", 480, 360)

	background.x = display.contentCenterX
	background.y = display.contentCenterY

end

local strokeWidth

-- Display outlines for all positions
grid.buildGrid = function(game)

	-- display the background for the grid
	grid.showBackground(game)

	local gameParams = xml:loadFile("xml/" .. game .. ".xml")
		
	local xCount, yCount, lineColor, bgColor, layout, orientation, itemType
	
	-- create an 8 by 6 grid
	-- rows
	
	print( "#gameParams = " .. #gameParams.child )
	
	for elementCount = 1, #gameParams.child, 1 do
	
		if ( gameParams.child[elementCount].name == "grid" ) then
			xCount = gameParams.child[elementCount].properties.cols --.value
	
			-- columns
			yCount = gameParams.child[elementCount].properties.rows --.value
	
			-- grid line color
			lineColor = gameParams.child[elementCount].properties.lineColor
	
			--grid line size
			strokeWidth = gameParams.child[elementCount].properties.strokeWidth

			-- grid background color
			bgColor = gameParams.child[elementCount].properties.bgColor
			
		elseif ( gameParams.child[elementCount].name == "items" ) then
		
			grid.createItemList( gameParams.child[elementCount].properties )
		end
	end
	
	local lineColorTbl = explode(',', lineColor)
	local bgColorTbl = explode(',', bgColor)
	
	-- grid offset
	
	print( "content height = " .. display.contentHeight )
	print( "content width = " .. display.contentWidth )
	
	-- possibly make these xml props later
	local xOffset = 26
	local yOffset = 40
		
	-- create a 10-square grid
	for countHorizontal = 0, xCount, 1 do 

		x = countHorizontal * grid.gridSize
		
		for countVertical = 0, yCount, 1 do
		
			local sqLine = display.newRect(grid.group, grid.gridSize * countHorizontal + xOffset, grid.gridSize * (countVertical-1) + yOffset, grid.gridSize, grid.gridSize)
						
			sqLine.strokeWidth = strokeWidth
			sqLine:setStrokeColor(lineColorTbl[1], lineColorTbl[2], lineColorTbl[3])
			sqLine:setFillColor(bgColorTbl[1], bgColorTbl[2], bgColorTbl[3], bgColorTbl[4])	
			
			grid.fieldCells[#grid.fieldCells + 1] = sqLine --countVertical .. '-' .. countHorizontal] = sqLine;	
                        --grid:setFillColor(0.2, 50, 0, 0)
                
			if ( countHorizontal == 0 or countHorizontal == xCount ) then
				sqLine:setStrokeColor(0, 0, 0, 0)
				sqLine:setFillColor(0, 0, 0, 0 )
			end
			
			if ( countVertical == 0 or countVertical == yCount ) then 
				sqLine:setStrokeColor(0, 0, 0, 0)
				sqLine:setFillColor(0, 0, 0, 0 )				
			end
			
		end
	end
	
	-- execute dragging functions
	
end

grid.gridItemDrag = function(event)

	if ( event == nil ) then
		return
	end
	
	local t = event.target

	-- check to see where they released the person
	
	if ( event.phase == "ended" or event.phase == "moved" or event.phase == "began" ) then
		
		local playerx = t.x
		local playery = t.y
		local halfCell = grid.gridSize/2
		local fullCell = grid.gridSize
		
		local cellx, celly, cell
		
		for tblItem = 1, #grid.fieldCells, 1 do 
		 	cellx = grid.fieldCells[tblItem].x
		 	celly = grid.fieldCells[tblItem].y
		 	cell = grid.fieldCells[tblItem]
		 	
		 	-- when I start moving the item again, unhighlight this cell
		 	if ( t == cell.item and cell.item ~= nil) then
                               --cell:setFillColor(0.5, 0.1, 0.1, 0)
                               cell.strokeWidth = strokeWidth
                        end
		 			 	
		 	-- determine if we are close to the middle of a cell
		 	if ( cellx - playerx < halfCell and celly - playery < halfCell ) then
                                                        
                                t.x = cellx
                                t.y = celly

		 		--print( "cellx = " .. cellx .. " / celly = " .. celly )	
		 		--print( "playerx = " .. playerx .. " / playery = " .. playery )	 		
		 		
	 			if ( event.phase == "ended" ) then
                                        if ( cellx + halfCell > playerx and celly + halfCell > playery ) then
	 					
	 					-- check the bounds
	 					if ( celly > 0 and playery > 0 and cellx > fullCell and playerx > fullCell ) then
	 						-- gray the cell background when the item is set
   
                                                        --cell:setFillColor( 1, 0.2, 0.2 )                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
                                                        cell.strokeWidth = strokeWidth + 2
                                                                                                    
                                                        --cell:setFillColor(0.5, 0.5, 0.5, 0.9)
	 						cell.item = t -- associated this item with this cell

	 					end
	 				end                                   
	 			end

		 		-- allow users to re-position items
		 		--MultiTouch.deactivate(t)
		 	end
		end
	end
end



grid.createItemList = function( props )

	-- horizontal or vertical item layout
	local layout = props.layout
	
	-- top/bottom/top/bottom item orientation
	local orientation = props.orientation
	
	-- type of object to display (person, letter, number, etc.)
	local itemType = props.itemType
	
	-- maximum number of items to show
	local maxItems = props.maxItems

	local playerTable = {}
	local x = 1
	local player
	local dim = grid.gridSize
	local pad = 0 -- space between items
	local xOffset = 40
	local yOffset = 20
	
	for countHorizontal = 1, tonumber(maxItems), 1 do
		
		if ( itemType == "person" ) then
			player = display.newImageRect(grid.group, "images/person.png", dim, dim)
			
		elseif ( itemType == "letter" ) then
			player = display.newImageRect(grid.group, "images/letter.png", dim, dim)
		
		elseif ( itemType == "number" ) then
			player = display.newImageRect(grid.group, "images/number.png", dim, dim)
		end
		
		if ( layout == "vertical" ) then
			if ( orientation == "left" ) then
				player.x = dim/2
			else
				player.x = display.contentWidth - dim/2
			end
			
			player.y = (pad+dim) * countHorizontal + yOffset + (-1*dim/2)
			
		elseif ( layout == "horizontal" ) then
			if ( orientation == "bottom" ) then
				player.y = display.contentHeight - dim/2
			else
				player.y = dim/2;
			end
			
			player.x = (pad+dim) * countHorizontal + xOffset
		end
		
		player:addEventListener(MultiTouch.MULTITOUCH_EVENT, grid.gridItemDrag);
		MultiTouch.activate(player, "move", "single")
		
		playerTable[x] = player
		x = x + 1
	end
end


return grid
