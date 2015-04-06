Bump = require 'lib.bump'
Platform = require 'platform'
Timer = require 'timer'
Player = require 'player'

function love.load()
	math.randomseed(os.time())
	love.graphics.setDefaultFilter('nearest', 'nearest')
	love.graphics.setBackgroundColor(40, 50, 60)

	world = Bump.newWorld(64)
	players = {}
	for i = 1, 2, 1 do
		players[i] = Player:new(i)
	end
	platforms = {}
	for i = 0, 20, 1 do
		local width = math.random(60, 100)
		local x = math.random(0, love.graphics.getWidth() - width)
		local y = math.random(100, love.graphics.getHeight() - 16)
		platforms[i] = Platform:new(x, y, width)
	end

	timer = Timer:new()

	music = love.audio.newSource("sfx/yakety-sax.mp3")
	music:setLooping(true)
	-- music:play()
end

function love.update(dt)
	table.foreach(players, function (i)
		players[i]:update()
	end)

	timer:update(dt)
end

function love.draw()
	table.foreach(platforms, function (i)
		platforms[i]:draw()
	end)

	table.foreach(players, function (i)
		players[i]:draw()
	end)
	timer:draw()
end
