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
	for i = 1, 10, 1 do
		gPrint(i*100, i*100, 10)
	end
	gPrint(self.subTitle, love.graphics.getWidth()/3-string.len(self.subTitle)/2, love.graphics.getHeight()/3)
	if self.playersConfigured then
		self:drawGameOver()
	else
		self:drawPlayerScreens()
	end
	love.graphics.print(string.format('%.3f', self.timer), 300, 300)
end

function MenuScreen:drawPlayerScreens()
	self.jsCount = 8
	for i = 1, self.jsCount, 1 do
		local bottomMargin = 50
		local height = love.graphics.getHeight()/3
		local width = (love.graphics.getWidth()-10)/self.jsCount-10
		local x = (love.graphics.getWidth()-10)/self.jsCount
		local y = love.graphics.getHeight() - height - bottomMargin
		gRec('line', 10+(i-1)*x, y, width, height)
		table.foreach(self.joysticksReady, function (i)
			if self.joysticksReady[i] then
				gPrint('Player '..i, (width - x)/3+x, (height - y)/3 + y)

				local r, g, b, a = love.graphics.getColor()
				love.graphics.setColor(getPlayerColor(i), 255)
				self.sprite:draw(self.x, self.y, 0, 2, 2)
				love.graphics.setColor(r, g, b, a)
			else
				gPrint(self.readyText, (width - x)/3+x, (height - y)/3 + y)
			end
		end)
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

return MenuScreen
