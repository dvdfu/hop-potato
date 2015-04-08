class = require 'lib.middleclass'
Timer = class('Timer')

function Timer:initialize(start)
	font = love.graphics.newFont(14)
	love.graphics.setFont(font)

	self.time = start
end

function Timer:update(dt)
	if self.time - dt <= 0 then
		self.time = 0
	else
		self.time = self.time - dt
	end
end

function Timer:draw(x, y, textWidth)
	love.graphics.printf(string.format("%i", self.time), x, y, 25, "center")
end

function Timer:getTime()
	return self.time
end

return Timer
