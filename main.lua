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

function love.load()
	math.randomseed(os.time())
	love.graphics.setDefaultFilter('nearest', 'nearest')
	love.graphics.setBackgroundColor(40, 50, 60)

	font = love.graphics.newImageFont("img/font.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`'*#=[]\"")
	-- font.setWidth(4)
	love.graphics.setFont(font)

	screenNum = 0
	screens:enterScreen(TestScreen)
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