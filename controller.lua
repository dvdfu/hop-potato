Controller = class('Controller')

function Controller:initialize(i)
	self.controller = i
	self.joystick = love.joystick.getJoysticks()[i]
	self.inputtype, self.rbumper = self.joystick:getGamepadMapping('rightshoulder')
	self.vibration = self.joystick:isVibrationSupported()
	self.id = self.joystick:getID()
	print(self.joystick:getID())
	print(self.joystick:getGamepadMapping('rightshoulder'))
end

function Controller:leftAnalogMove()
	if self.joystick == nil then return 0 end
	local leftx = self.joystick:getGamepadAxis('leftx') or 0
	if math.abs(leftx) > 0.075 then return leftx
	else return 0 end
end

function Controller:rightAnalogX()
	if self.joystick == nil then return 0 end
	local rightx = self.joystick:getGamepadAxis('rightx') or 0
	if math.abs(rightx) > 0.075 then return rightx
	else return 0 end
end

function Controller:rightAnalogY()
	if self.joystick == nil then return 0 end
	local righty = self.joystick:getGamepadAxis('righty') or 0
	if math.abs(righty) > 0.075 then return righty
	else return 0 end
end

function Controller:rightBumper()
	if self.joystick == nil then return false end
	return self.joystick:isDown(self.rbumper)
end

return Controller
