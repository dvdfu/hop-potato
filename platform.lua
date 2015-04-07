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
end

function Platform:update(dt)
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

return Platform