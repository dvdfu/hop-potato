Potato = Class('Potato')

function Potato:initialize()
	self.sprite = love.graphics.newImage('img/potato.png')
	self.x, self.y = carrier.x, carrier.y
	self.vx, self.vy = 0, 0

	--fire configuration
	self.fireSprite = love.graphics.newImage('img/particle.png')
	self.fire = love.graphics.newParticleSystem(self.fireSprite, 100)
	self.fire:setAreaSpread('normal', 6, 0)
	self.fire:setParticleLifetime(0.1, 0.15)
	self.fire:setDirection(-math.pi / 2)
	self.fire:setSpeed(160, 300)
	self.fire:setColors(255, 0, 0, 255, 255, 120, 0, 255, 255, 200, 0, 255)
	self.fire:setEmissionRate(200)
	self.fire:setSizeVariation(0)

	self.name = 'potato'
	world:add(self, self.x, self.y, 32, 32)

	throw = love.audio.newSource("sfx/throw.wav")
end

--define collision properties
local type = function(item, other)
	return 'cross'
end

function Potato:collide()
	if carrier ~= nil and carrier.respawning then end

	local actualX, actualY, cols, len = world:move(self, self.x + self.vx, self.y + self.vy, type)
	self.x, self.y = actualX, actualY
	for i = 1, len do
		local col = cols[i]
		if col.other.name == 'player' and col.other ~= carrier and carrierTime > 1 then
			carrier = col.other
			carrierTime = 0
		elseif carrier == nil and col.other.name == 'platform' and col.normal.y == -1 then
			self.y = col.other.y - 32
			self.vy = -8
			col.other:move()
		end
	end
end

function Potato:update(dt)
	--update fire
	self.fire:setPosition(self.x + 16, self.y + 16)
	self.fire:update(dt)

	--follow trajectory when thrown
	if carrier == nil then
		self.vy = self.vy + 0.3
		self.vx = self.vx * 0.99
		self.x = self.x + self.vx
		self.y = self.y + self.vy

	--move potato and check for throws
	else
		self.vx, self.vy = 0, 0
		local xOffset = carrier.controller:rightAnalogX() * 48
		local yOffset = carrier.controller:rightAnalogY() * 48
		self.x, self.y = carrier.x + xOffset, carrier.y + yOffset
		if carrier.controller:rightBumper() and not carrier.respawning and xOffset * yOffset ~= 0 then
			carrier = nil
			local angle = math.atan2(yOffset, xOffset)
			self.vx = math.cos(angle) * 8
			self.vy = math.sin(angle) * 8
			throw:play()
		end
	end

	--wrap around room
	local nocol = false--to skip collision checking
	if self.y > love.window.getHeight() then
		self.y = -32
		nocol = true;
	end
	if self.x > love.window.getWidth() then
		self.x = -32
		nocol = true;
	elseif self.x < -32 then
		self.x = love.window.getWidth()
		nocol = true;
	end

	--collision
	if nocol then
		world:update(self, self.x + self.vx, self.y + self.vy)
	else
		self:collide()
	end
end

function Potato:draw()
	love.graphics.setBlendMode('additive')
	love.graphics.draw(self.fire)
	love.graphics.setBlendMode('alpha')
	love.graphics.draw(self.sprite, self.x, self.y, 0, 2, 2)
end

return Potato
