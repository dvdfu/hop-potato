class = require 'lib.middleclass'
Timer = class('Timer')

function Timer:initialize()
	font = love.graphics.newFont(14)
	love.graphics.setFont(font)

	self.time = 30
end

function Timer:update(dt)
	if self.time - dt <= 0 then 
		self.time = 0
	else 
		self.time = self.time - dt
	end
end

function Timer:draw(x, y, textWidth)
	love.graphics.printf(string.format("%i", self.time), x, y, textWidth or 25, "center")
end

function Timer:getTime()
	return self.time
end

return Timer