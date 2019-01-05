local Container = require("aqua.graphics.Container")
local Class = require("aqua.util.Class")

local Screen = Class:new()

Screen.construct = function(self)
	self.container = Container:new()
end

Screen.update = function(self)
	self.container:update()
end

Screen.draw = function(self)
	self.container:draw()
end

return Screen
