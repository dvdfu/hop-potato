Class = require 'lib.middleclass'
Bump = require 'lib.bump'
Flux = require 'lib.flux'
Platform = require 'platform'
Timer = require 'timer'
Player = require 'player'
Potato = require 'potato'

function love.load()
	math.randomseed(os.time())
	love.graphics.setDefaultFilter('nearest', 'nearest')
	love.graphics.setBackgroundColor(40, 50, 60)

	world = Bump.newWorld(64)
	players = {}
	for i = 1, 2, 1 do players[i] = Player:new(i) end
	carrier = players[1]
	carrierTime = 0
	platforms = {}
	for i = 0, 10, 1 do platforms[i] = Platform:new() end
	potato = Potato:new()
	timer = Timer:new()

	music = love.audio.newSource("sfx/yakety-sax.mp3")
	music:setLooping(true)
	-- music:play()
end

function love.update(dt)
	Flux.update(dt)
	carrierTime = carrierTime + dt
	table.foreach(players, function (i)
		players[i]:update(dt)
	end)
	potato:update(dt)
	timer:update(dt)
end

function love.draw()
	table.foreach(platforms, function (i)
		platforms[i]:draw()
	end)

	table.foreach(players, function (i)
		players[i]:draw()
	end)
	potato:draw()
	-- timer:draw(0, 25, love.graphics.getWidth())
	love.graphics.print(string.format('%.3f', carrierTime), 80, 80)
end
