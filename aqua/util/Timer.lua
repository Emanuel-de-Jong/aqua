local Class = require("aqua.util.Class")

local Timer = Class:new()

Timer.rate = 1
Timer.offset = 0
Timer.currentTime = 0
Timer.pauseTime = 0
Timer.adjustDelta = 0
Timer.rateDelta = 0
Timer.positionDelta = 0
Timer.state = "waiting"

Timer.update = function(self)
	local deltaTime = love.timer.getTime() - (self.startTime or 0)
	self.deltaTime = deltaTime
	
	if self.state == "waiting" or self.state == "paused" then
		return
	elseif self.state == "playing" then
		self.currentTime = (deltaTime - self.adjustDelta - self.pauseTime - self.rateDelta) * self.rate + self.positionDelta
	end
	
	if self.getAdjustTime then
		self:adjustTime()
	end
end

Timer.adjustTime = function(self, force)
	local adjustTime = self:getAdjustTime()
	if adjustTime and self.state ~= "paused" then
		local dt = math.min(love.timer.getDelta(), 1 / 60)
		local targetAdjustDelta
			= self.deltaTime
			- self.rateDelta
			- self.pauseTime
			- (adjustTime - self.positionDelta)
			/ self.rate
		
		if force then
			self.adjustDelta = targetAdjustDelta
		else
			self.adjustDelta
				= self.adjustDelta
				+ (targetAdjustDelta - self.adjustDelta)
				* dt
		end
	end
end

Timer.setRate = function(self, rate)
	if self.startTime then
		local pauseTime
		if self.state == "paused" then
			pauseTime = self.pauseTime + love.timer.getTime() - self.pauseStartTime
		else
			pauseTime = self.pauseTime
		end
		local deltaTime = love.timer.getTime() - self.startTime - pauseTime
		self.rateDelta = (self.rateDelta - deltaTime) * self.rate / rate + deltaTime
	end

	local adjust = false
	if rate * self.rate < 0 then
		if self.getAdjustTime then
			adjust = true
		end
	end

	self.rate = rate

	if adjust then
		self:adjustTime(true)
	end
end

Timer.getTime = function(self)
	return self.currentTime + self.offset
end

Timer.setPosition = function(self, position)
	self.positionDelta = self.positionDelta + position - self.currentTime - self.offset
	self:update()
end

Timer.setOffset = function(self, offset)
	self.offset = offset
end

Timer.pause = function(self)
	self.state = "paused"
	self.pauseStartTime = love.timer.getTime()
end

Timer.play = function(self)
	if self.state == "waiting" then
		self.state = "playing"
		self.startTime = love.timer.getTime() - self.currentTime
	elseif self.state == "paused" then
		self.state = "playing"
		self.pauseTime = self.pauseTime + love.timer.getTime() - self.pauseStartTime
		self.pauseStartTime = love.timer.getTime()
	end
end

return Timer
