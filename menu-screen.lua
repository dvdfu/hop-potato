PlayScreen = require 'play-screen'

MenuScreen = Class('MenuScreen')

function MenuScreen:initialize()
	timer = 1
end

function MenuScreen:update(dt)
	if timer > 0 then
		timer = timer - dt
	else
		screens:enterScreen(PlayScreen)
		timer = 5
	end
end

function MenuScreen:draw()
	love.graphics.print(string.format('%.3f', timer), 300, 300)
end

return MenuScreen
