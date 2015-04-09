Class = require 'lib.middleclass'
PlayScreen = require 'play-screen'
MenuScreen = require 'menu-screen'
TestScreen = require 'test-screen'

screens = {}

function screens:enterScreen(screen)
	screenNum = screenNum + 1
	screens[screenNum] = screen:new()
end

function screens:exitScreen()
	if screenNum > 1 then
		screens[screenNum]:onClose()
		screens[screenNum] = nil
		screenNum = screenNum - 1
	else
		love.event.push('quit')
	end
end

function screens:changeScreen(screen)
	screens:exitScreen()
	screens:enterScreen(screen)
end

function screens:setDefaultFont()
	love.graphics.setColor(255, 255, 255, 255)
	self.font = love.graphics.newFont("font/Retro Computer_DEMO.ttf", 15)
	love.graphics.setFont(self.font);
end

function love.load()
	math.randomseed(os.time())
	love.graphics.setDefaultFilter('nearest', 'nearest')
	love.graphics.setBackgroundColor(50, 50, 40)

	font = love.graphics.newImageFont("img/font.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`'*#=[]\"")
	-- font.setWidth(4)
	love.graphics.setFont(font)

	screenNum = 0
	screens:enterScreen(MenuScreen)
end

function love.update(dt)
	screens[screenNum]:update(dt)
	if love.keyboard.isDown('escape') then
		screens:exitScreen()
	end
end

function love.draw()
	screens[screenNum]:draw()
end
