local bass = require("aqua.audio.bass")
local bass_fx = require("aqua.audio.bass_fx")
local Audio = require("aqua.audio.Audio")

local Stream = Audio:new()

Stream.construct = function(self)
	self.channel = bass.BASS_StreamCreateFile(false, self.path, 0, 0, 0)
end

return Stream
