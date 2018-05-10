Fusion.inventory = Fusion.inventory or {}
Fusion.inventory.cache = Fusion.inventory.cache or {}

local ITEM = Fusion.meta.item or {}
ITEM.__index = ITEM
ITEM.name = "Undefined"
ITEM.desc = "An item."
ITEM.id = ITEM.id or 0
ITEM.unique = "undefined"


function ITEM:getID()
	return self.id
end

function ITEM:getName()
	return self.name
end

function ITEM:getDesc()
	if (!self.desc) then return "ERROR" end
	
	return L(self.desc or "noDesc")
end

function ITEM:call(method, client, entity, ...)
	local oldPlayer, oldEntity = self.player, self.entity

	self.player = client or self.player
	self.entity = entity or self.entity

	if (type(self[method]) == "function") then
		local results = {self[method](self, ...)}

		self.player = nil
		self.entity = nil

		return unpack(results)
	end

	self.player = oldPlayer
	self.entity = oldEntity
end


function ITEM:getOwner()
	local id = self.id

end


Fusion.meta.item = ITEM