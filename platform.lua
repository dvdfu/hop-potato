class = require 'lib.middleclass'
Platform = class('Platform')

function Platform:initialize(x, y, w)
	self.x = x -- ALWAYS use self. to refer to own properties
	self.y = y
	self.w = w
	
	self.name = 'platform'
	world:add(self, self.x, self.y, self.w, 16)
end

function Platform:draw()
	love.graphics.rectangle('fill', self.x, self.y, self.w, 16)
end

return Platform