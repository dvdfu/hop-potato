class = require 'lib.middleclass'
Timer = class('Timer')

function Timer:initialize()
	font = love.graphics.newFont(14)
	love.graphics.setFont(font)

	time = 30
end

function Timer:update(dt)
	if time - dt <= 0 then 
		time = 0
	else 
		time = time - dt
	end
end

function Timer:draw()
	love.graphics.printf(string.format("%.1f", time), love.graphics.getWidth() - 34, 10, 25, 'right')
end

return Timer