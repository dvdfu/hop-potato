class = require 'lib.middleclass'
Controller = require 'controller'
Player = class('Player')

--define collision properties
local type = function(item, other)
	if other.name == 'platform' then
		return 'cross'
	elseif other.name == 'player' then
		return 'cross'
	else
		return 'slide'
	end
end

function Player:initialize(num)
	--consts
	self.moveVel = 6
	self.jumpVel = 8

	self.num = num
	self.x = math.random(0, 500)
	self.y = math.random(0, 500)
	self.vx = 0
	self.vy = 0
	self.w = 32
	self.h = 32

	self.controller = Controller:new(num)

	if num == 1 then
		self.left = 'a'
		self.right = 'd'
	elseif num == 2 then
		self.left = 'left'
		self.right = 'right'
	end

	--name for collision identification
	self.name = 'player'
	--world is defined in main.lua
	world:add(self, self.x, self.y, self.w, self.h)
end

function Player:update()
	--movement
	if love.keyboard.isDown(self.left) then --keyboard fallback
		self.vx = -3
	elseif love.keyboard.isDown(self.right) then
		self.vx = 3
	else
		self.vx = self.controller:leftAnalogMove() * self.moveVel
	end

	--control falling speed
	if self.vy < 20 then
		self.vy = self.vy + 0.3
	else
		self.vy = 20
	end

	--wrap around room
	if self.y > love.window.getHeight() then self.y = -self.h end
	if self.x > love.window.getWidth() then self.x = -self.w
	elseif self.x < -self.w then self.x = love.window.getWidth() end

	--collision
	local actualX, actualY, cols, len = world:move(self, self.x + self.vx, self.y + self.vy, type)
	self.x, self.y = actualX, actualY
	for i = 1, len do
		local col = cols[i]
		if col.other.name == 'platform' then
			if col.normal.y == -1 and self.y + self.h - self.vy < col.other.y then
				self.y = col.other.y - self.h
				self.vy = -self.jumpVel
				col.other:move()
			end
		end
		if col.other.name == 'player' then
			if carrier == self and carrierTime > 1 then
				carrier = col.other
				carrierTime = 0
			end
			if col.normal.y == -1 and self.y + self.h - self.vy < col.other.y then
				self.y = col.other.y - self.h
				self.vy = -self.jumpVel
				col.other.vy = 0
			end
		end
	end
end

function Player:draw()
	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
	if carrier == self then
		love.graphics.setColor(255, 200, 0, 255)
		love.graphics.rectangle('fill', self.x, self.y - 8, self.w, 8)
	end
	love.graphics.setColor(255, 255, 255, 255)
end

return Player
