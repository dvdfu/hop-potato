Platform = require 'platform'
Player = require 'player'

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')
	love.graphics.setBackgroundColor(40, 50, 60)

	player = Player:new(1)
	platforms = {}
	for i = 0, 10, 1 do
		local width = math.random(60, 100)
		local x = math.random(0, love.graphics.getWidth() - width)
		local y = math.random(0, love.graphics.getHeight() - 16)
		platforms[i] = Platform:new(x, y, width)
	end
end

function love.update(dt)
	player:update()
end

function love.draw()
	for i = 0, 10, 1 do
		platforms[i]:draw()
	end
	player:draw()
end