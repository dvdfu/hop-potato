TestScreen = Class('TestScreen')

function TestScreen:initialize()
	explosionSprite = love.graphics.newImage('img/particle.png')
	explosion = love.graphics.newParticleSystem(explosionSprite, 1000)
	explosion:setAreaSpread('normal', 30, 30)
	explosion:setParticleLifetime(0, 0.6)
	explosion:setSpread(math.pi * 2)
	explosion:setSpeed(250, 450)
	explosion:setColors(255, 255, 255, 255, 255, 255, 0, 255, 255, 30, 0, 255, 100, 100, 100, 255)
	explosion:setSizes(3, 0)
	-- explosion:setRadialAcceleration(400)
end

function TestScreen:update(dt)
	explosion:update(dt)
	if love.keyboard.isDown('a') and explosion:getCount() == 0 then
		explosion:emit(600)
	end
end

function TestScreen:draw()
	love.graphics.setBlendMode('additive')
	love.graphics.draw(explosion, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
	love.graphics.setBlendMode('alpha')


end

function TestScreen:onClose()
end

return TestScreen
