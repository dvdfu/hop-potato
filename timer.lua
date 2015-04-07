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

function Timer:draw(x, y, w)
	love.graphics.printf(string.format("%.0f", time), x, y, w, 'center')
end

function Timer:getTime()
	return time
end

return Timer