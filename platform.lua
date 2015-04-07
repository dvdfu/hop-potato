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
	self.dust:setParticleLifetime(0.2, 0.5)
	self.dust:setColors(160, 160, 160, 255, 160, 160, 160, 255, 160, 160, 160, 255)
	self.dust:setAreaSpread('normal', 6, 0)
	self.dust:setSpread(math.pi / 2)
	self.dust:setDirection(-math.pi / 2)
	self.dust:setSpeed(160)
	self.dust:setLinearAcceleration(0, 200, 0, 500)
end

function Platform:update(dt)
	world:update(self, self.x, self.y)
	self.dust:update(dt)
end

function Platform:draw()
	love.graphics.rectangle('fill', self.x, self.y, self.w, 16)
	love.graphics.draw(self.dust);
end

function Platform:move()
	local destX = math.random(0, love.graphics.getWidth() - self.w)
	local destY = math.random(100, love.graphics.getHeight() - 16)
	Flux.to(self, 1, {
		x = destX,
		y = destY
	}):ease('cubicout')
end

function Platform:leaveDust(x, y)
	self.dust:setPosition(x, y)
	self.dust:emit(10)
end

return Platform
