Potato = Class('Potato')

function Potato:initialize()
	self.sprite = love.graphics.newImage('img/potato.png')
	self.x, self.y = carrier.x, carrier.y
	self.name = 'potato'
	world:add(self, self.x, self.y, 32, 32)
end

--define collision properties
local type = function(item, other)
	return 'cross'
end

function Potato:update(dt)
	if carrier == nil then
	else
		local xOffset = carrier.controller:rightAnalogX() * 48
		local yOffset = carrier.controller:rightAnalogY() * 48
		self.x, self.y = carrier.x + xOffset, carrier.y + yOffset
	end

	local actualX, actualY, cols, len = world:move(self, self.x, self.y, type)
	self.x, self.y = actualX, actualY
	for i = 1, len do
		local col = cols[i]
		if col.other.name == 'player' and col.other ~= carrier and carrierTime > 1 then
			carrier = col.other
			carrierTime = 0
		end
	end
end

function Potato:draw()
	love.graphics.draw(self.sprite, self.x, self.y, 0, 2, 2)
end

return Potato