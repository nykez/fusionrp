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


function ITEM:setData(key, value, receivers, noSave, noCheckEntity)
	self.data = self.data or {}
	self.data[key] = value

	if (SERVER) then
		if (!noCheckEntity) then
			local ent = self:getEntity()

			if (IsValid(ent)) then
				local data = ent:getNetVar("data", {})
				data[key] = value

				ent:setNetVar("data", data)
			end
		end
	end

	if (receivers != false) then
		if (receivers or self:getOwner()) then
			netstream.Start(receivers or self:getOwner(), "invData", self:getID(), key, value)
		end
	end

	if (!noSave) then
		// save inventory data here 
	end	
end

function ITEM:getData(key, default)
	self.data = self.data or {}

	if (self.data) then
		if (key == true) then
			return self.data
		end

		local value = self.data[key]

		if (value != nil) then
			return value
		elseif (IsValid(self.entity)) then
			local data = self.entity:getNetVar("data", {})
			local value = data[key]

			if (value != nil) then
				return value
			end
		end
	else
		self.data = {}
	end

	if (default != nil) then
		return default
	end

	return
end


if SERVER then
	function ITEM:getEntity()
		local id = self:getID()

		for k, v in ipairs(ents.FindByClass("ent_item")) do
			if (v.ItemID == id) then
				return v
			end
		end
	end
end


Fusion.meta.item = ITEM