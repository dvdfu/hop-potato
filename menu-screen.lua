PlayScreen = require 'play-screen'
Controller = require 'controller'
Dictionary = require 'dictionary'

MenuScreen = Class('MenuScreen')

function MenuScreen:initialize()
	self.startTimerThreshhold = 2
	self.playersConfigured = false
	self.subTitle = 'DON\'T STEP IN THE LAVA AND MAKE SURE TO GET RID OF THE POTATO'
	self.readyText = 'Press any button to lock in...'
	self.gameOverText = 'Game over...'

	joysticks = {}
	self.dict = Dictionary:new()
	for i=1,8 do
		joysticks[i] = { ready = false, controller = nil, joystick = nil, name = self.dict:generateName(), timer = 0 }
	end

	self.jsCount = love.joystick.getJoystickCount()
	print('js connected: ' .. self.jsCount)
	if self.jsCount > 0 then
		local curJS = love.joystick.getJoysticks()
		table.foreach(curJS, function (i)
			joysticks[i].controller = Controller:new(i)
			joysticks[i].joystick = curJS[i]
		end)
	end

	local img = love.graphics.newImage('img/player.png')
	self.sprite = newAnimation(img, 16, 16, 0.5, 0)

	self.font = love.graphics.newFont("font/Retro Computer_DEMO.ttf", 15)
	love.graphics.setFont(self.font);
end

function MenuScreen:update(dt)
	local startGame = 0
	local secondStartPressed = false

	updateJSTimer(dt)

	local curJS = love.joystick.getJoysticks()
	local curJSCount = love.joystick.getJoystickCount()
	if self.jsCount < curJSCount then
		print('new controller connected')

		for i=self.jsCount+1,curJSCount do
			print('jsCount ' ..i)
			joysticks[i].controller = Controller:new(i)
			joysticks[i].joystick = curJS[i]
		end
		self.jsCount = curJSCount
		resetJSTimer()
	end

	if joysticks ~= nil then
		table.foreach(joysticks, function (i)
			if joysticks[i].controller ~= nil then
				if joysticks[i].controller:startButton() then
					if joysticks[i].ready and allJSTimerAbove(self.startTimerThreshhold) then
						print('Second start pressed, lets start the game!')
						secondStartPressed = true
					end
					joysticks[i].ready = true
					if joysticks[i].timer >= self.startTimerThreshhold then
						joysticks[i].timer = 0
					end
				elseif joysticks[i].controller:selectButton() then
					joysticks[i].name = self.dict:generateName()
					joysticks[i].ready = false
					joysticks[i].timer = 0
				end
			end
		end)

		table.foreach(joysticks, function (i)
			if joysticks[i].ready then startGame = startGame + 1 end
		end)
	end
	if startGame >= 2 and secondStartPressed then screens:enterScreen(PlayScreen) end
end

function MenuScreen:draw()
	gPrint(self.subTitle, love.graphics.getWidth()/2 - self.font:getWidth(self.subTitle) / 2, love.graphics.getHeight()/4)
	if self.playersConfigured then
		self:drawGameOver()
	else
		self:drawPlayerScreens()
	end
	local curJS = love.joystick.getJoysticks()
	gPrint('curJS', 10, 10)
	table.foreach(curJS, function (i)
		if curJS ~= nil then
			gPrint(curJS[i]:getName(), 10, i * 20 + 10)
		end
	end)
	gPrint('joystick', 700, 10)
	if joysticks ~= nil then
		table.foreach(joysticks, function (i)
			if joysticks[i].joystick ~= nil then
				gPrint(joysticks[i].joystick:getName(), 700, i * 20+10)
			end
		end)
	end
end

function MenuScreen:drawPlayerScreens()
	local jsCount = 8
	if jsCount % 2 == 1 then
		jsCount = jsCount + 1
	end
	local halfJsCount = jsCount / 2

	local readyTextWidth = self.font:getWidth(self.readyText)
	local spriteWidth = self.sprite:getWidth()

	local readyTextHeight = self.font:getHeight(self.readyText)
	local spriteHeight = self.sprite:getHeight()

	for i = 1, jsCount, 1 do
		local bottomMargin = 10
		local height = love.graphics.getHeight()/4-10
		local width = (love.graphics.getWidth()-10)/(jsCount/2)-10

		local x = (love.graphics.getWidth()-10)/jsCount
		local y = height + bottomMargin
		if i <= halfJsCount then
			y = y * 2
		end

		gRec('line', 10+((i-1)%halfJsCount)*x*2, love.graphics.getHeight() - y, width, height)

		if joysticks ~= nil and joysticks[i] ~= nil and joysticks[i].ready then
			local usernameWidth = self.font:getWidth(joysticks[i].name.. ' ready!')
			local usernameHeight = self.font:getHeight(joysticks[i].name.. ' ready!')
			gPrint(joysticks[i].name.. ' ready!', 10+((i-1)%halfJsCount)*x*2 + width/2 - usernameWidth / 2, love.graphics.getHeight() - y + usernameHeight + height/2)
			local r, g, b, a = love.graphics.getColor()
			local colorR, colorG, colorB = getPlayerColor(i)
			love.graphics.setColor(colorR, colorG, colorB, 255)
			self.sprite:draw(10+((i-1)%halfJsCount)*x*2 + width/2 - spriteWidth/2, love.graphics.getHeight() - y - spriteHeight - 10 + height / 2, 0, 2, 2)
			love.graphics.setColor(r, g, b, a)
		else
			gPrint(self.readyText, 10+((i-1)%halfJsCount)*x*2 + width/2 - readyTextWidth/2, love.graphics.getHeight() - y - readyTextHeight + height/2)
		end
	end
end

function updateJSTimer(dt)
	if joysticks ~= nil then
		table.foreach(joysticks, function (i)
			joysticks[i].timer = joysticks[i].timer + dt
		end)
	end
end

function resetJSTimer()
	if joysticks ~= nil then
		table.foreach(joysticks, function (i)
			joysticks[i].timer = 0
		end)
	end
end

function allJSTimerAbove(num)
	local ret = true
	if joysticks ~= nil then
		table.foreach(joysticks, function (i)
			if joysticks[i].timer < num then
				ret =  false
			end
		end)
	end
	return ret
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
