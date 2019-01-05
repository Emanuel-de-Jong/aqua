local ceil = math.ceil
local floor = math.floor
local abs = math.abs

local math = {}

math.round = function(x)
	return x % 1 < 0.5 and floor(x) or ceil(x)
end

math.sign = function(x)
	return x == 0 and 0 or x / abs(x)
end

math.belong = function(x, a, b)
	return a <= x and x <= b
end

math.map = function(x, a, b, c, d)
	return (x - a) * (d - c) / (b - a) + c
end

return math