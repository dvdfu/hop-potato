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

function Platform:draw()
	love.graphics.rectangle('fill', self.x, self.y, self.w, 16)
end

function Platform:move()
	local destX = math.random(0, love.graphics.getWidth() - self.w)
	local destY = math.random(100, love.graphics.getHeight() - 16)
	local actualX, actualY, cols, len = world:move(self, destX, destY, type)
	-- self.x, self.y = actualX, actualY
	Flux.to(self, 0.3, {
		x = actualX,
		y = actualY
	})
end

return Platform