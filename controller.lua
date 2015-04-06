Controller = class('Controller')

function Controller:initialize(joysticks)
	self.lastbutton = "none"
	self.position = {x = 400, y = 300}
	self.speed = 10
	self.joysticks = joysticks
end

function Controller:getPos()
	return self.position
end

function Controller:moveBall()
	table.foreach(self.joysticks, function(_index)
		local leftx = self.joysticks[_index]:getGamepadAxis("leftx")

		if leftx < -0.1 or leftx > 0.1 then
			local delta = self.position.x + leftx * self.speed
			self.position.x = delta
		end
	end)
end

return Controller
