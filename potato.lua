Potato = Class('Potato')

function Potato:initialize()
	self.sprite = love.graphics.newImage('img/potato.png')
	self.x, self.y = carrier.x, carrier.y
	self.vx, self.vy = 0, 0
	self.rotation = 0
	self.dead = false

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

	--resources
	throw = love.audio.newSource("sfx/throw.wav")
	jump = love.audio.newSource("sfx/jump.wav")
	hit = love.audio.newSource("sfx/hit.wav")
	death = love.audio.newSource("sfx/death.wav")
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
			self:attach(col.other)
			hit:play()
		elseif carrier == nil and col.other.name == 'platform' and col.normal.y == -1 then
			self.y = col.other.y - 32
			self.vy = -8
			col.other:move()
			jump:play()
		end
	end
end

function Potato:update(dt)
	local nocol = false

	--update fire
	self.fire:setPosition(self.x + 16, self.y + 16)
	self.fire:update(dt)

	if carrier ~= nil and not carrier.alive then	
		table.foreach(players, function (i)
			if players[i].alive then
				self:attach(players[i])				
			end
		end)

		if not carrier.alive then
			carrier = nil
		end
	end

	--follow trajectory when thrown
	if carrier == nil then
		local speed = math.sqrt(self.vx * self.vx + self.vy * self.vy)
		self.rotation = self.rotation + speed / 30
		if self.vy < 20 then
			self.vy = self.vy + 0.3
		else
			self.vy = 20
		end
		self.vx = self.vx * 0.98

	--move potato and check for throws
	else
		self.rotation = 0
		self.vx, self.vy = 0, 0
		local xOffset = carrier.controller:rightAnalogX() * 64
		local yOffset = carrier.controller:rightAnalogY() * 64
		self.x, self.y = carrier.x + xOffset, carrier.y + yOffset
		if carrier.controller:rightBumper() and not carrier.respawning and xOffset * yOffset ~= 0 then
			nocol = true
			carrier = nil
			local angle = math.atan2(yOffset, xOffset)
			self.vx = math.cos(angle) * 25
			self.vy = math.sin(angle) * 25
			throw:play()
		end
	end

	--wrap around room
	if self.y + self.vy < 0 then
		self.y = 0
		self.vy = -self.vy
	elseif self.y  + self.vy > lavaLevel then
		self:attach(owner)
		nocol = true;
		death:play()
	end
	if self.x > love.window.getWidth() then
		self.x = self.x - love.window.getWidth()
		nocol = true;
	elseif self.x < 0 then
		self.x = self.x + love.window.getWidth()
		nocol = true;
	end

	--collision
	if nocol then
		world:update(self, self.x + self.vx, self.y + self.vy)
	else
		self:collide()
	end
end

function Potato:attach(player)
	carrier = player
	if carrier ~= nil then
		owner = player
	end
	carrierTime = 0
end

function Potato:draw()
	love.graphics.setBlendMode('additive')
	love.graphics.draw(self.fire)
	love.graphics.draw(self.fire, -love.graphics.getWidth())
	love.graphics.setBlendMode('alpha')
	love.graphics.draw(self.sprite, self.x + 16, self.y + 16, self.rotation, 2, 2, 8, 8)
	love.graphics.draw(self.sprite, self.x + 16 - love.graphics.getWidth(), self.y + 16, self.rotation, 2, 2, 8, 8)
end

return Potato
