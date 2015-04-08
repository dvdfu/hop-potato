PlayScreen = require 'play-screen'

MenuScreen = Class('MenuScreen')

function MenuScreen:initialize()
	self.timer = 1000
	self.playersConfigured = false
	self.subTitle = 'DON\'T STEP IN THE LAVA AND MAKE SURE TO GET RID OF THE POTATO'
	self.readyText = 'Press any button to lock in...'
	self.gameOverText = 'Game over...'
	self.joysticks = love.joystick.getJoysticks()
	self.jsCount = love.joystick.getJoystickCount()
	print('jsCount ' ..self.jsCount)
	self.joysticksReady = {}
	for i=1,8 do
		self.joysticksReady[i] = false
	end

	local img = love.graphics.newImage('img/player.png')
	self.sprite = newAnimation(img, 16, 16, 0.5, 0)
end

function MenuScreen:update(dt)
	if self.timer > 0 then
		self.timer = self.timer - dt
		if self.timer < 0 then self.timer = 0 end
	else
		screens:enterScreen(PlayScreen)
		self.timer = 5
	end
end

function MenuScreen:draw()
	gPrint(self.subTitle, love.graphics.getWidth()/7, love.graphics.getHeight()/4)
	if self.playersConfigured then
		self:drawGameOver()
	else
		self:drawPlayerScreens()
	end
	love.graphics.print(string.format('%.3f', self.timer), 100, 100)
end

function MenuScreen:drawPlayerScreens()
	self.jsCount = 8
	if self.jsCount % 2 == 1 then
		self.jsCount = self.jsCount + 1
	end
	local halfJsCount = self.jsCount / 2

	for i = 1, self.jsCount, 1 do
		local bottomMargin = 10
		local height = love.graphics.getHeight()/4-10
		local width = (love.graphics.getWidth()-10)/(self.jsCount/2)-10

		local x = (love.graphics.getWidth()-10)/self.jsCount
		local y = height + bottomMargin
		if i <= halfJsCount then
			y = y * 2
			self.joysticksReady[i] = true
		end

		gRec('line', 10+((i-1)%halfJsCount)*x*2, love.graphics.getHeight() - y, width, height)

		if self.joysticksReady[i] then
			gPrint('Player '..i, 10+((i-1)%halfJsCount)*x*2 + x*2/3, love.graphics.getHeight() - y+40)
			local r, g, b, a = love.graphics.getColor()
			local colorR, colorG, colorB = getPlayerColor(i)
			love.graphics.setColor(colorR, colorG, colorB, 255)
			self.sprite:draw(10+((i-1)%halfJsCount)*x*2 + x*7/8, love.graphics.getHeight() - y, 0, 2, 2)
			love.graphics.setColor(r, g, b, a)
		else
			gPrint(self.readyText, 10+((i-1)%halfJsCount)*x*2 + 10, love.graphics.getHeight() - y + 5)
		end
	end

end

function MenuScreen:drawGameOver()

end

function gPrint(...)
	love.graphics.print(...)
end

function gDraw(...)
	love.graphics.draw(...)
end

function gRec(...)
	love.graphics.rectangle(...)
end

function getPlayerColor(num)
	--user-specific data
	local colorR = 100
	local colorG = 100
	local colorB = 100
	if num == 1 then
		colorR = 255
	elseif num == 2 then
		colorG = 255
	elseif num == 3 then
		colorB = 255
	elseif num == 4 then
		colorG = 255
		colorR = 255
	elseif num == 5 then
		colorG = 255
		colorB = 255
	elseif num == 6 then
		colorR = 255
		colorB = 255
	elseif num == 7 then
		colorG = 180
		colorR = 255
	elseif num == 8 then
		colorR = 255
		colorG = 255
		colorB = 255
	end
	return colorR, colorG, colorB
end

function MenuScreen:onClose()
end

return MenuScreen
