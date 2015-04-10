Controller = Class('Controller')

Controller.static.buffer = 0.075

function Controller:initialize(i)
	self.controller = i
	self.joystick = love.joystick.getJoysticks()[i]
	_, self.rBumper = self.joystick:getGamepadMapping('rightshoulder')
	_, self.start = self.joystick:getGamepadMapping('start')
	_, self.select = self.joystick:getGamepadMapping('back')

	self.canVibrate = self.joystick:isVibrationSupported()
	self.id = self.joystick:getID()
	if self.canVibrate then
		self.left, self.right = self.joystick:getVibration()
	else
		self.left, self.right = nil
	end
end

function Controller:leftAnalogX()
	if self.joystick == nil then return 0 end
	local leftx = self.joystick:getGamepadAxis('leftx') or 0
	if math.abs(leftx) > Controller.buffer then return leftx
	else return 0 end
end

function Controller:leftAnalogY()
	if self.joystick == nil then return 0 end
	local lefty = self.joystick:getGamepadAxis('lefty') or 0
	if math.abs(lefty) > Controller.buffer then return lefty
	else return 0 end
end

function Controller:rightAnalogX()
	if self.joystick == nil then return 0 end
	local rightx = self.joystick:getGamepadAxis('rightx') or 0
	if math.abs(rightx) > Controller.buffer then return rightx
	else return 0 end
end

function Controller:rightAnalogY()
	if self.joystick == nil then return 0 end
	local righty = self.joystick:getGamepadAxis('righty') or 0
	if math.abs(righty) > Controller.buffer then return righty
	else return 0 end
end

function Controller:rightBumper()
	if self.joystick == nil then return false end
	return self.joystick:isDown(self.rBumper or 5)
end

function Controller:startButton()
	if self.joystick == nil then return false
	else return self.joystick:isDown(self.start or 4) end
end

function Controller:selectButton()
	if self.joystick == nil then return false
	else return self.joystick:isDown(self.select) end
end

return Controller
