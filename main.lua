--[[------------------------
		ASSET DATA
------------------------]]--

love.graphics.setDefaultFilter("nearest", "nearest")

local function bit2rgb(data)
	local height = #data
	local width = #data[1]
	local ret = {}
	for _, row in ipairs(data) do
		for i = 1, #row do
			table.insert(ret, string.char((row:sub(i,i) == ' ') and 0 or 255):rep(4))
		end
	end
	return love.graphics.newImage(love.image.newImageData(width, height, nil, table.concat(ret)))
end

local player = bit2rgb({
	' 0 0    ',
	'0 0000  ',
	'0 0   0 ',
	' 0  000 ',
	' 0 0000 ',
	'  0  0  ',
	'  0000  ',
	'  0  0  '
})

local tiles = {
	bit2rgb({
		'        ',
		'        ',
		'        ',
		'        ',
		'        ',
		'        ',
		'        ',
		'        ',
	}),
	bit2rgb({
		'00000000',
		'00000000',
		'00000000',
		'00000000',
		'00000000',
		'00000000',
		'00000000',
		'00000000',
	}),
	bit2rgb({
		'00000000',
		'00000000',
		'00000000',
		'00000000',
		'00000000',
		'00000000',
		'00000000',
		'00000000',
	})
}

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
