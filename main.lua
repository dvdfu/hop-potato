Platform = require 'platform'

platforms = {}

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')
	love.graphics.setBackgroundColor(40, 50, 60)

	for i = 0, 10, 1 do
		platforms[i] = Platform:new(20 * i, 30 * i, 7 * i)
	end

	font = love.graphics.newFont(14)
	love.graphics.setFont(font)

	timer = 30
end

function love.update(dt)
	if timer - dt <= 0 then 
		timer = 0
	else 
		timer = timer - dt
	end
end

function love.draw()
	for i = 0, 10, 1 do
		platforms[i]:draw()
	end

	love.graphics.printf(string.format("%.1f", timer), love.graphics.getWidth() - 34, 10, 25, 'right')
end