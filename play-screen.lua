Bump = require 'lib.bump'
Flux = require 'lib.flux'
Platform = require 'platform'
Player = require 'player'
Potato = require 'potato'

PlayScreen = Class('PlayScreen')

function PlayScreen:initialize()
	world = Bump.newWorld(64)
	players = {}
	for i = 1, love.joystick.getJoystickCount(), 1 do players[i] = Player:new(i) end
	carrier = players[1]
	carrierTime = 0
	platforms = {}
	for i = 0, 10, 1 do platforms[i] = Platform:new() end
	potato = Potato:new()

	music = love.audio.newSource("sfx/yakety-sax.mp3")
	music:setLooping(true)
	-- music:play()

	print(love.joystick.getJoystickCount())
end

function PlayScreen:update(dt)
	Flux.update(dt)
	carrierTime = carrierTime + dt
	table.foreach(platforms, function (i)
		platforms[i]:update(dt)
	end)
	table.foreach(players, function (i)
		players[i]:update(dt)
	end)
	potato:update(dt)
end

function PlayScreen:draw()
	local joysticks = love.joystick.getJoysticks()
	for i, joystick in ipairs(joysticks) do
		love.graphics.print(joystick:getName(), 10, i * 20)
	end

	table.foreach(platforms, function (i)
		platforms[i]:draw()
	end)

	table.foreach(players, function (i)
		players[i]:draw()
	end)
	potato:draw()
end

return PlayScreen
