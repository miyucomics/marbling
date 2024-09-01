local Drop = require("libraries.classic"):extend()
local Vector = require("libraries.vector")

local resolution = 100

function Drop:new(position, radius)
	local verts = {}
	for i = 0, resolution - 1 do
		local angle = (i / resolution) * math.pi * 2
		local x = math.cos(angle)
		local y = math.sin(angle)
		table.insert(verts, { position.x + x * radius, position.y + y * radius })
	end
	self.mesh = love.graphics.newMesh({ { "VertexPosition", "float", 2 } }, verts, "fan")
end

function Drop:marble(position, radius)
	for i = 1, self.mesh:getVertexCount() do
		local x, y = self.mesh:getVertex(i)
		local diff = Vector(x, y) - position
		local newPosition = position + diff * math.sqrt(1 + (radius / diff:length()) ^ 2)
		self.mesh:setVertex(i, newPosition.x, newPosition.y)
	end
end

function Drop:tine(position, tine, z, c)
	local u = 1 / (2 ^ (1 / c))
    local normal = Vector(-tine.y, tine.x)
	for i = 1, self.mesh:getVertexCount() do
		local x, y = self.mesh:getVertex(i)
		local vertex = Vector(x, y)
		local offset = vertex - position
		local d = math.abs(offset.x * normal.x + offset.y * normal.y)
		local mag = z * u ^ d
		local newPosition = vertex + tine * mag
		self.mesh:setVertex(i, newPosition.x, newPosition.y)
	end
end

function Drop:draw()
	love.graphics.draw(self.mesh)
end

return Drop
