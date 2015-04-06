Platform = require 'platform'
Player = require 'player'
Bump = require 'lib.bump'

function love.load()
	math.randomseed(os.time())
	love.graphics.setDefaultFilter('nearest', 'nearest')
	love.graphics.setBackgroundColor(40, 50, 60)

	world = Bump.newWorld(64)
	players = {}
	players[1] = Player:new(1)
	platforms = {}
	for i = 0, 10, 1 do
		local width = math.random(60, 100)
		local x = math.random(0, love.graphics.getWidth() - width)
		local y = math.random(0, love.graphics.getHeight() - 16)
		platforms[i] = Platform:new(x, y, width)
	end
end

function love.update(dt)
	for i = 1, table.getn(players) do
		players[i]:update()
	end
end

function love.draw()
	for i = 0, 10, 1 do
		platforms[i]:draw()
	end
	for i = 1, table.getn(players) do
		players[i]:draw()
	end
end