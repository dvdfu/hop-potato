Bump = require 'lib.bump'
Flux = require 'lib.flux'
Platform = require 'platform'
Player = require 'player'
Potato = require 'potato'

PlayScreen = Class('PlayScreen')

function PlayScreen:initialize(lastWinner)
	--consts
	lavaLevel = love.graphics.getHeight()

	world = Bump.newWorld(64)
	players = {}
	local numPlayers = 0
	table.foreach(joysticks, function (i)
		if joysticks[i].controller ~= nil and joysticks[i].ready then
			numPlayers = numPlayers + 1
			players[numPlayers] = Player:new(i)
		end
	end)
	if lastWinner == nil then
		carrier = players[math.floor(math.random(numPlayers))]
	else
		carrier = players[lastWinner]
	end
	owner = carrier
	platforms = {}
	local numPlatforms = love.graphics.getWidth() * love.graphics.getHeight() / 50000
	for i = 0, numPlatforms, 1 do platforms[i] = Platform:new() end
	potato = Potato:new()
	winner = 0
	numAlive = numPlayers

	music = love.audio.newSource("sfx/yakety-sax.mp3")
	music:setLooping(true)
	-- music:play()

	gameOverFont = love.graphics.newFont("font/Retro Computer_DEMO.ttf", 48)
	subheadingFont = love.graphics.newFont("font/Retro Computer_DEMO.ttf", 24)
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
	table.foreach(platforms, function (i)
		platforms[i]:update(dt)
	end)

	local highscore = 0
	table.foreach(players, function (i)
		players[i]:update(dt)
		if players[i].timer:getTime() > highscore then
			highscore = players[i].timer:getTime()
		end

		if numAlive == 1 and players[i].alive then
			winner = i
		end

		if winner ~= 0 then
			if players[i].controller:startButton() then
				screens:changeScreen(PlayScreen:new(winner))
			elseif players[i].controller:selectButton() then
				screens:exitScreen()
			end
		end
	end)

	--set crowns
	table.foreach(players, function (i)
		players[i].crown = players[i].timer:getTime() == highscore
	end)

	potato:update(dt)
end

function PlayScreen:draw()
	table.foreach(platforms, function (i)
		platforms[i]:draw()
	end)

	table.foreach(players, function (i)
		players[i]:draw()
	end)

	potato:draw()

	love.graphics.setBlendMode('additive')
	love.graphics.draw(self.fire)
	love.graphics.setBlendMode('alpha')

	if winner ~= 0 then
		love.graphics.setColor(0, 0, 0, 200)
		love.graphics.rectangle('fill', 200, 400, love.window.getWidth() - 400, love.window.getHeight() - 760)
		love.graphics.setColor(players[winner].colorR, players[winner].colorG, players[winner].colorB, 255)
		love.graphics.setFont(gameOverFont)
		love.graphics.printf(joysticks[winner].name .. " WINS!", 0, love.window.getHeight() / 2 - 30, love.window.getWidth(), "center")

		love.graphics.setFont(subheadingFont)
		love.graphics.setColor(255, 255, 255)
		love.graphics.printf("[START] - play again", 0, love.window.getHeight() / 2 + 30, love.window.getWidth(), "center")

		screens:setDefaultFont()
	end
end

function PlayScreen:onClose()
	music:stop()
end

return PlayScreen
