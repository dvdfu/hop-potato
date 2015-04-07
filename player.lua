require 'lib.AnAL'
Controller = require 'controller'
Player = Class('Player')

Player.static.move_vel = 4
Player.static.jump_vel = 8
Player.static.gravity = 0.2

function Player:initialize(num)
	self.num = num
	self.x = math.random(0, 500)
	self.y = math.random(0, 500)
	self.vx = 0
	self.vy = 0
	self.w = 32
	self.h = 32

	self.controller = Controller:new(num)

	local img = love.graphics.newImage('img/player'..num..'.png')
	self.sprite = newAnimation(img, 16, 16, 0.5, 0)

	--name for collision identification
	self.name = 'player'
	--world is defined in main.lua
	world:add(self, self.x, self.y, self.w, self.h)
end

--define collision properties
local type = function(item, other)
	return 'cross'
end

function Player:collide()
	local actualX, actualY, cols, len = world:move(self, self.x + self.vx, self.y + self.vy, type)
	self.x, self.y = actualX, actualY
	for i = 1, len do
		local col = cols[i]
		if col.other.name == 'platform' then
			if col.normal.y == -1 and self.y + self.h - self.vy < col.other.y then
				self.y = col.other.y - self.h
				self.vy = -Player.jump_vel
				col.other:leaveDust(self.x + 16, self.y + 32)
				col.other:move()
			end
		end
		if col.other.name == 'player' then
			if col.normal.y == -1 and self.y + self.h - self.vy < col.other.y then
				self.y = col.other.y - self.h
				self.vy = -Player.jump_vel
				col.other.vy = 0
			end
		end
	end
end

function Player:update(dt)

	self.sprite:update(dt)

	--movement
	self.vx = self.controller:leftAnalogMove() * Player.move_vel

	--control falling speed
	if self.vy < 20 then
		self.vy = self.vy + Player.gravity
	else
		self.vy = 20
	end

	--wrap around room
	local nocol = false--to skip collision checking
	if self.y > love.window.getHeight() then
		self.y = -self.h
		nocol = true;
	end
	if self.x > love.window.getWidth() then
		self.x = -self.w
		nocol = true;
	elseif self.x < -self.w then
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

function Player:draw()
	love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
	self.sprite:draw(self.x, self.y, 0, 2, 2)
end

return Player
