class = require 'lib.middleclass'
Platform = class('Platform')

function Platform:initialize(x, y, width)
	self.x = x -- ALWAYS use self. to refer to own properties
	self.y = y
	self.width = width
end

function Platform:draw()
	love.graphics.rectangle('fill', self.x, self.y, self.width, 16) -- ALWAYS
end

return Platform