Class = require 'lib.middleclass'
MenuScreen = require 'menu-screen'

screens = {}

function love.load()
	math.randomseed(os.time())
	love.graphics.setDefaultFilter('nearest', 'nearest')
	love.graphics.setBackgroundColor(40, 50, 60)
	screenNum = 0
	screens:enterScreen(MenuScreen)
end

function love.update(dt)
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