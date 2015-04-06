class = require 'lib.middleclass'
Controller = require 'controller'
Player = class('Player')

--define collision properties
local type = function(item, other)
	if other.name == 'platform' then
		return 'cross'
	else
		return 'slide'
	end
end

function Player:initialize(num)
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
	end

	--name for collision identification
	self.name = 'player' .. num
	--world is defined in main.lua
	world:add(self, self.x, self.y, self.w, self.h)
end

function Player:update()
	--TODO: use controllers

	self.vx = self.controller:leftAnalogMove() * 5

	--control falling speed
	if self.vy < 20 then
		self.vy = self.vy + 0.3
	else
		self.vy = 20
	end

	--update position
	-- self.x = self.x + self.vx
	-- self.y = self.y + self.vy

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
			if col.normal.y == -1 then
				self.y = col.other.y - self.h
				self.vy = -8
			end
		end
	end
end

function Player:draw()
	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
	love.graphics.setColor(255, 255, 255, 255)
end

return Player
