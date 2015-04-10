class = require 'lib.middleclass'
Timer = class('Timer')

function Timer:initialize(start)
	self.time = start
	self.font = love.graphics.newFont("font/Retro Computer_DEMO.ttf", 32)
end

function Timer:update(dt)
	if self.time - dt <= 0 then
		self.time = 0
	else
		self.time = self.time - dt
	end
end

function Timer:draw(x, y, textWidth)
	love.graphics.setFont(self.font)
	love.graphics.printf(string.format("%i", math.ceil(self.time)), x, y, textWidth, "center")
end

function Timer:getTime()
	return self.time
end

function Timer:addTime(time)
	self.time = self.time + time
end

return Timer
