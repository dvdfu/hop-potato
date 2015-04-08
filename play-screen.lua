Bump = require 'lib.bump'
Flux = require 'lib.flux'
Platform = require 'platform'
Player = require 'player'
Potato = require 'potato'

PlayScreen = Class('PlayScreen')

function PlayScreen:initialize()
	--consts
	lavaLevel = love.graphics.getHeight()

	world = Bump.newWorld(64)
	players = {}
	local numPlayers = 0
	table.foreach(joysticks, function (i)
		if joysticks[i].controller ~= nil then
			numPlayers = numPlayers + 1
			players[numPlayers] = Player:new(i)
		end
	end)
	carrier = players[math.floor(math.random(numPlayers))]
	owner = carrier
	carrierTime = 0
	platforms = {}
	local numPlatforms = love.graphics.getWidth() * love.graphics.getHeight() / 50000
	for i = 0, numPlatforms, 1 do platforms[i] = Platform:new() end
	potato = Potato:new()

	music = love.audio.newSource("sfx/yakety-sax.mp3")
	music:setLooping(true)
	-- music:play()
	rippleShader = love.graphics.newShader('data/ripple.glsl')

	gameOverFont = love.graphics.newFont(36)
	subheadingFont = love.graphics.newFont(24)
	defaultFont = love.graphics.newFont(14)

	--fire configuration
	self.fireSprite = love.graphics.newImage('img/flame.png')
	self.fire = love.graphics.newParticleSystem(self.fireSprite, 3000)
	self.fire:setPosition(love.graphics.getWidth() / 2, love.graphics.getHeight())
	self.fire:setAreaSpread('normal', love.graphics.getWidth() / 2, 0)
	self.fire:setParticleLifetime(0, 0.5)
	self.fire:setDirection(-math.pi / 2)
	self.fire:setSpeed(160, 300)
	self.fire:setColors(255, 0, 0, 255, 255, 120, 0, 255, 255, 200, 0, 255)
	self.fire:setEmissionRate(2000)
	self.fire:setSizes(1, 0.5)
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
			screens:changeScreen(PlayScreen)
		end
	end)
	potato:update(dt)
end

function PlayScreen:draw()
	love.graphics.setShader(rippleShader)
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

			love.graphics.setFont(subheadingFont)	
			love.graphics.printf("(Press start to play again)", 0, love.window.getHeight() / 2 + 50, love.window.getWidth(), "center")

			love.graphics.setFont(defaultFont)
		end
	end)
	
	potato:draw()

	love.graphics.setBlendMode('additive')
	-- love.graphics.setColor(255, 0, 0, 255)
	-- love.graphics.rectangle('fill', 0, lavaLevel, love.graphics.getWidth(), 64)
	-- love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.fire)
	love.graphics.setBlendMode('alpha')
end

function PlayScreen:onClose()
	music:stop()
end

return PlayScreen
