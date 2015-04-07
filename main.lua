Class = require 'lib.middleclass'
PlayScreen = require 'play-screen'
MenuScreen = require 'menu-screen'

screens = {}

function love.load()
	math.randomseed(os.time())
	love.graphics.setDefaultFilter('nearest', 'nearest')
	love.graphics.setBackgroundColor(40, 40, 40)

	font = love.graphics.newImageFont("img/font.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`'*#=[]\"")
	love.graphics.setFont(font)

	screenNum = 0
	screens:enterScreen(PlayScreen)
end

function love.update(dt)
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end
	screens[screenNum]:update(dt)
end

function love.draw()
	screens[screenNum]:draw()
end

function screens:enterScreen(screen)
	screenNum = screenNum + 1
	screens[screenNum] = screen:new()
end

function screens:exitScreen()
	if screenNum > 0 then
		screens[screenNum] = nil
		screenNum = screenNum - 1
	end
end