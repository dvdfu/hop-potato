Platform = require 'platform'
Timer = require 'timer'

platforms = {}

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')
	love.graphics.setBackgroundColor(40, 50, 60)

	for i = 0, 10, 1 do
		platforms[i] = Platform:new(20 * i, 30 * i, 7 * i)
	end

	timer = Timer:new()
end

function love.update(dt)
	timer:update(dt)
end

function love.draw()
	for i = 0, 10, 1 do
		platforms[i]:draw()
	end

	timer:draw()
end