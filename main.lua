Platform = require 'platform'

platforms = {}

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')
	love.graphics.setBackgroundColor(40, 50, 60)

	for i = 0, 10, 1 do
		platforms[i] = Platform:new(20 * i, 30 * i, 7 * i)
	end
end

function love.update(dt)
end

function love.draw()
	for i = 0, 10, 1 do
		platforms[i]:draw()
	end
end