PlayScreen = require 'play-screen'

MenuScreen = Class('MenuScreen')

function MenuScreen:initialize()
	timer = 1

	self.title = 'DON\'T STEP IN THE LAVA AND MAKE SURE TO GET RID OF THE POTATO'
end

function MenuScreen:update(dt)
	if timer > 0 then
		timer = timer - dt
		if timer < 0 then timer = 0 end
	else
		screens:enterScreen(PlayScreen)
		timer = 5
	end
end

function MenuScreen:draw()
	love.graphics.print(self.title, love.graphics.getWidth()/2-string.length(self.title)/2, love.graphics.getHeight()/3)
	love.graphics.print(string.format('%.3f', timer), 300, 300)
end

return MenuScreen
