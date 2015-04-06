class = require 'lib.middleclass'
Player = class('Player')

function Player:initialize(num)
	self.num = num
	self.x = math.random(0, 500)
	self.y = math.random(0, 500)
	self.vx = 0
	self.vy = 0

	if num == 1 then
		self.left = 'a'
		self.right = 'd'
	end
end

function Player:update()
	--TODO: use controllers
	if love.keyboard.isDown(self.left) then
		self.vx = -3
	elseif love.keyboard.isDown(self.right) then
		self.vx = 3
	else
		self.vx = 0
	end

	if self.vy < 20 then
		self.vy = self.vy + 0.1
	else
		self.vy = 20
	end

	self.x = self.x + self.vx
	self.y = self.y + self.vy

	if self.y > love.window.getHeight() then self.y = -32 end
	if self.x > love.window.getWidth() then self.x = -32
	elseif self.x < -32 then self.x = love.window.getWidth() end
end

function Player:draw()
	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.rectangle('fill', self.x, self.y, 32, 32)
	love.graphics.setColor(255, 255, 255, 255)
end

return Player