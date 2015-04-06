Platform = require 'platform'
Controller = require 'controller'

platforms = {}

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')
	love.graphics.setBackgroundColor(40, 50, 60)
	local joysticks = love.joystick.getJoysticks()
	controller = Controller:new(joysticks)


	for i = 0, 10, 1 do
		platforms[i] = Platform:new(20 * i, 30 * i, 7 * i)
	end
end

function love.update(dt)
	controller:moveBall()
end

function love.draw()
	for i = 0, 10, 1 do
		platforms[i]:draw()
	end
	love.graphics.circle("fill", controller:getPos().x, controller:getPos().y, 50)
end
