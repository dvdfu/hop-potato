require 'lib.AnAL'
Controller = require 'controller'
Timer = require 'timer'
Player = Class('Player')

Player.static.move_vel = 4
Player.static.jump_vel = 12
Player.static.gravity = 0.3

function Player:initialize(num, name)
	self.name = name
	self.num = num
	self.vx = 0
	self.vy = 0
	self.w = 32
	self.h = 32

	self:respawn()
	self.controller = Controller:new(num)
	self.timer = Timer:new(2)
	self.injured = false
	self.injuryFlicker = 0

	self.alive = true

	--user-specific data
	self.colorR = 100
	self.colorG = 100
	self.colorB = 100
	if num == 1 then
		self.left = 'a'
		self.right = 'd'
		self.colorR = 255
	elseif num == 2 then
		self.left = 'left'
		self.right = 'right'
		self.colorG = 255
	elseif num == 3 then
		self.left = 'f'
		self.right = 'g'
		self.colorB = 255
	elseif num == 4 then
		self.left = 'j'
		self.right = 'k'
		self.colorG = 255
		self.colorR = 255
	elseif num == 5 then
		self.left = '1'
		self.right = '2'
		self.colorG = 255
		self.colorB = 255
	elseif num == 6 then
		self.left = '4'
		self.right = '5'
		self.colorR = 255
		self.colorB = 255
	elseif num == 7 then
		self.left = '7'
		self.right = '8'
		self.colorG = 180
		self.colorR = 255
	elseif num == 8 then
		self.left = '0'
		self.right = '-'
		self.colorR = 255
		self.colorB = 255
		self.colorG = 255
	end

	self.name = 'player'
	world:add(self, self.x, self.y, self.w, self.h)

	--resources
	jump = love.audio.newSource("sfx/jump.wav")
	death = love.audio.newSource("sfx/death.wav")
	local img = love.graphics.newImage('img/player.png')
	self.sprite = newAnimation(img, 16, 16, 0.5, 0)

end

--define collision properties
local type = function(item, other)
	-- if other.name == 'platform' then
	-- 	return 'slide'
	-- end
	return 'cross'
end

function Player:collide()
	local actualX, actualY, cols, len = world:move(self, self.x + self.vx, self.y + self.vy, type)
	self.x, self.y = self.x + self.vx, self.y + self.vy
	for i = 1, len do
		local col = cols[i]
		if col.other.name == 'platform' then
			if col.normal.y == -1 and self.y + self.h - self.vy < col.other.y then
				self.x, self.y = actualX, actualY
				self.y = col.other.y - self.h
				self.vy = -Player.jump_vel
				col.other:leaveDust(self.x + 16, self.y + 32)
				col.other:move()
				jump:play()
			end
		end
		if col.other.name == 'player' and col.other.alive then
			if col.normal.y == -1 and self.y + self.h - self.vy < col.other.y then
				self.y = col.other.y - self.h
				self.vy = -Player.jump_vel
				col.other.vy = 0
			end
		end
	end
end

function Player:update(dt)
	if not self.alive then return end

	self.sprite:update(dt)

	if owner == self and not self.respawning then
		self.timer:update(dt)
	end

	if self.injured then
		self.injuryFlicker = self.injuryFlicker + 1
	end

	self.respawning = self.respawnTime > 0

	--movement
	local speedBoost = 0
	if owner == self then
		speedBoost = 0.8
	end
	self.vx = self.controller:leftAnalogX() * (Player.move_vel + speedBoost)

	--control falling speed
	if self.respawning then
		self.respawnTime = self.respawnTime - dt
	elseif self.vy < 20 then
		local fallBoost = 0
		if self.controller:leftAnalogY() > 0 then
			fallBoost = self.controller:leftAnalogY()
		end
		if self.vy > 0 then
			self.injured = false
		end
		self.vy = self.vy + Player.gravity + fallBoost / 3
	else
		self.vy = 20
	end

	--wrap around room
	local nocol = false --to skip collision checking
	if self.y < 0 then
		self.y = 0
		self.vy = 0
	elseif self.y > lavaLevel then
		death:play()
		self.y = lavaLevel - self.h
		self.vy = -18
		-- self.timer:addTime(-3)
		potato:attach(self)
		self.injured = true
		self.injuryFlicker = 0
		nocol = true
	end
	if self.x > love.window.getWidth() then
		self.x = 0
		nocol = true
	elseif self.x < 0 then
		self.x = love.window.getWidth()
		nocol = true
	end

	--collision
	if nocol then
		world:update(self, self.x + self.vx, self.y + self.vy)
	else
		self:collide()
	end

	--checks for death
	if self.timer:getTime() <= 0 then
		self.alive = false
		world:remove(self)
		numAlive = numAlive - 1
	end
end

function Player:draw()
	if not self.alive then return end

	if not self.injured or self.injuryFlicker % 4 < 2 then
		if owner == self then
			love.graphics.setBlendMode('additive')
			love.graphics.setColor(255, 200, 0, 255)
			love.graphics.rectangle('fill', self.x - 2, self.y - 2, self.w + 4, self.h + 4)
			love.graphics.rectangle('fill', self.x - 2 - love.graphics.getWidth(), self.y - 2, self.w + 4, self.h + 4)
			love.graphics.setBlendMode('alpha')
		end
		love.graphics.setColor(self.colorR, self.colorG, self.colorB, 255)
		self.sprite:draw(self.x, self.y, 0, 2, 2)
		self.sprite:draw(self.x - love.graphics.getWidth(), self.y, 0, 2, 2)
		love.graphics.setColor(255, 255, 255, 255)
	end
	self.timer:draw(self.x, self.y - 25, 32)
	self.timer:draw(self.x - love.graphics.getWidth(), self.y - 25, 32)
end

function Player:respawn()
	carrier = self
	owner = carrier
	carrierTime = 0
	self.respawnTime = 2
	self.x = math.random(0, love.window.getWidth())
	self.y = 20
	self.vy = 0
end

function Player:getName()
	return self.name
end

return Player
