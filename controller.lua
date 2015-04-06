Controller = class('Controller')

function Controller:initialize(i)
	self.controller = i
	self.joystick = love.joystick.getJoysticks()[i]
end

function Controller:leftAnalogMove()
	if self.joystick == nil then return 0 end
	local leftx = self.joystick:getGamepadAxis('leftx') or 0
	if math.abs(leftx) > 0.075 then return leftx
	else return 0 end
end

return Controller
