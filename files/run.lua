--[[------------------------
		ASSET DATA
------------------------]]--

love.graphics.setDefaultFilter("nearest", "nearest")

print(':3')
local player = love.graphics.newImage(love.filesystem.newFileData("assets/player"))
print(':?')

local canvas = love.graphics.newCanvas(25 * 16, 25 * 9)

local t = 0

function love.draw()
	t = t + 0.01
	canvas:renderTo(function()
		love.graphics.clear(0, 0, 0)
		love.graphics.draw(player, 5+math.cos(t)*5, 5+math.sin(t)*5, 0, 1, 1)
	end)
	love.graphics.draw(canvas, 0, 0, 0, 6, 6)
end
