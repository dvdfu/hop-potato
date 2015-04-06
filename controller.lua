Controller = class('Controller')

function Controller:initialize(i)
	self.controller = i
	self.joystick = love.joystick.getJoysticks()[i]
end

function Controller:leftAnalogMove()
	local leftx = self.joystick:getGamepadAxis('leftx')
	return leftx if math.abs(leftx) > 0.75 else 0
end

return Controller
