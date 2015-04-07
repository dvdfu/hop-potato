Bump = require 'lib.bump'
Flux = require 'lib.flux'
Platform = require 'platform'
Player = require 'player'
Potato = require 'potato'

PlayScreen = Class('PlayScreen')

function PlayScreen:initialize()
	--consts
	lavaLevel = love.graphics.getHeight() * 0.8

	world = Bump.newWorld(64)
	players = {}
	for i = 1, love.joystick.getJoystickCount(), 1 do players[i] = Player:new(i) end
	carrier = players[1]
	carrierTime = 0
	platforms = {}
	local numPlatforms = love.graphics.getWidth() * love.graphics.getHeight() / 50000
	for i = 0, numPlatforms, 1 do platforms[i] = Platform:new() end
	potato = Potato:new()

	music = love.audio.newSource("sfx/yakety-sax.mp3")
	music:setLooping(true)
	-- music:play()

	gameOverFont = love.graphics.newFont(36)
	subheadingFont = love.graphics.newFont(24)
	defaultFont = love.graphics.newFont(14)
	
	--fire configuration
	self.fireSprite = love.graphics.newImage('img/particle.png')
	self.fire = love.graphics.newParticleSystem(self.fireSprite, 1000)
	self.fire:setPosition(love.graphics.getWidth() / 2, lavaLevel)
	self.fire:setAreaSpread('normal', love.graphics.getWidth() / 2, 0)
	self.fire:setParticleLifetime(0, 0.2)
	self.fire:setDirection(-math.pi / 2)
	self.fire:setSpeed(160, 300)
	self.fire:setColors(255, 0, 0, 255, 255, 120, 0, 255, 255, 200, 0, 255)
	self.fire:setEmissionRate(3000)
	self.fire:setSizeVariation(0)
end

function PlayScreen:update(dt)
	self.fire:update(dt)
	Flux.update(dt)
	carrierTime = carrierTime + dt
	table.foreach(platforms, function (i)
		platforms[i]:update(dt)
	end)
	table.foreach(players, function (i)
		players[i]:update(dt)

		if players[i].timer:getTime() <= 0 and players[i].controller:startButton() then
			screens:exitScreen()
			screens:enterScreen(PlayScreen)
		end

	end)
	potato:update(dt)
end

function PlayScreen:draw()
	table.foreach(platforms, function (i)
		platforms[i]:draw()
	end)

	local joysticks = love.joystick.getJoysticks()
	for i, joystick in ipairs(joysticks) do
		love.graphics.print(joystick:getName(), 10, i * 20)
	end

	table.foreach(players, function (i)
		players[i]:draw()

		if players[i].timer:getTime() <= 0 then
			love.graphics.setFont(gameOverFont)
			love.graphics.printf("PLAYER " .. i .. " GOT REKT!", 0, love.window.getHeight() / 2 - 50, love.window.getWidth(), "center")

			love.graphics.setFont(font)	
			love.graphics.printf("(Press start to play again)", 0, love.window.getHeight() / 2 + 50, love.window.getWidth(), "center")

			love.graphics.setFont(defaultFont)
		end
	end)
	potato:draw()

	love.graphics.setBlendMode('additive')
	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.rectangle('fill', 0, lavaLevel, love.graphics.getWidth(), love.graphics.getHeight() * 0.2)
	love.graphics.setColor(255, 255, 255, 255)
	-- love.graphics.draw(self.fire)
	love.graphics.setBlendMode('alpha')
end

return PlayScreen
