Platform = Class('Platform')

--define collision properties
local type = function(item, other)
	return 'cross'
end

function Platform:initialize()
	self.name = 'platform'
	self.w, self.h = 128, 16
	world:add(self, 0, 0, self.w, self.h)
	self.x, self.y = self:newLocation()

	self.dustSprite = love.graphics.newImage('img/particle.png')
	self.dust = love.graphics.newParticleSystem(self.dustSprite, 100)
	self.dust:setParticleLifetime(0.2, 0.5)
	self.dust:setColors(160, 160, 160, 255, 160, 160, 160, 255, 160, 160, 160, 255)
	self.dust:setAreaSpread('normal', 6, 0)
	self.dust:setSpread(math.pi / 2)
	self.dust:setDirection(-math.pi / 2)
	self.dust:setSpeed(160)
	self.dust:setLinearAcceleration(0, 200, 0, 500)
	self.dust:setSizes(1, 0.5)

	self.sprite = love.graphics.newImage('img/platform.png')
end

function Platform:update(dt)
	world:update(self, self.x, self.y)
	self.dust:update(dt)
end

function Platform:draw()
	love.graphics.draw(self.sprite, self.x, self.y, 0, self.w / 40, self.h / 8)
	love.graphics.draw(self.dust);
end

function Platform:move()
	local destX, destY = self:newLocation()
	Flux.to(self, 1, {
		x = destX,
		y = destY
	}):ease('cubicout')
end

function Platform:newLocation()
	local rx = math.random(0, love.graphics.getWidth() - self.w)
	local ry = math.random(300, lavaLevel - self.h)
	local actualX, actualY, cols, len = world:move(self, rx, ry, type)
	if len > 1 then return self:newLocation()
	else return rx, ry end
end

function Platform:leaveDust(x, y)
	self.dust:setPosition(x, y)
	self.dust:emit(10)
end

return Platform
