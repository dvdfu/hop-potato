Platform = Class('Platform')

--define collision properties
local type = function(item, other)
	return 'cross'
end

function Platform:initialize()
	self.w = math.random(60, 100)
	self.x = math.random(0, love.graphics.getWidth() - self.w)
	self.y = math.random(100, love.graphics.getHeight() - 16)
	self.name = 'platform'
	world:add(self, self.x, self.y, self.w, 16)

	self.dustSprite = love.graphics.newImage('img/particle.png')
	self.dust = love.graphics.newParticleSystem(self.dustSprite, 100)
	self.dust:setAreaSpread('normal', 6, 0)
	self.dust:setParticleLifetime(2, 5)
	self.dust:setEmissionRate(50)
	self.dust:setSizeVariation(0)
	self.dust:setColors(204, 204, 204, 0.7)
end

	-- self.fire = love.graphics.newParticleSystem(self.fireSprite, 100)
	-- self.fire:setAreaSpread('normal', 6, 0)
	-- self.fire:setParticleLifetime(0.1, 0.15)
	-- self.fire:setDirection(-math.pi / 2)
	-- self.fire:setSpeed(160, 300)
	-- self.fire:setColors(255, 0, 0, 255, 255, 120, 0, 255, 255, 200, 0, 255)
	-- self.fire:setEmissionRate(200)
	-- self.fire:setSizeVariation(0)

function Platform:update(dt)
	self.dust:setPosition(self.x, self.y)
	self.dust:update(dt)
	world:update(self, self.x, self.y)
end

function Platform:draw()
	love.graphics.rectangle('fill', self.x, self.y, self.w, 16)
end

function Platform:move()
	local destX = math.random(0, love.graphics.getWidth() - self.w)
	local destY = math.random(100, love.graphics.getHeight() - 16)
	Flux.to(self, 1, {
		x = destX,
		y = destY
	}):ease('cubicout')
end

function Platform:leaveDust()
	love.graphics.draw(self.dust);
end

return Platform
