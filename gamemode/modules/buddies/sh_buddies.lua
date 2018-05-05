
Fusion.buddies = Fusion.buddies or {}

-- local character = Fusion.meta.character

-- // Also accepts a character meta -> converts to id

-- if SERVER then
-- 	function character:AddBuddy(id)
-- 		if (type(id) != "number" and id.getID) then
-- 			id = id:getID()
-- 		end

-- 		local buddies = self:getData("buddies", {})
-- 		if buddies[id] then return end

-- 		buddies[id] = {
-- 			car = false,
-- 			house = false,
-- 			props = false,
-- 		}

-- 		self:setData("buddies", buddies)
-- 	end

-- 	function character:ModifyBuddy(id, tblData)
-- 		if (type(id) != "number" and id.getID) then
-- 			id = id:getID()
-- 		end

-- 		if not id then return end
		
-- 		local buddies = self:getData("buddies", {})

-- 		if buddies[id] then
-- 			buddies[id] = tblData
-- 			self:setData("buddies", buddies)
-- 		end
-- 	end

-- 	function character:RemoveBuddy(id)
-- 		if (type(id) != "number" and id.getID) then
-- 			id = id:getID()
-- 		end

-- 		if not id then return end

-- 		local buddies = self:getData("buddies", {})

-- 		if buddies[id] then
-- 			buddies[id] = nil
-- 			self:setData("buddies", buddies)
-- 		end
-- 	end
-- end

-- -- function Fusion.buddies.HasPerms(character, id, strType)
-- -- 	if not character then return end

-- -- 	local buddies = character:getData("buddies", {})

-- -- 	if buddies[id] and buddies[id][strType] == true then
-- -- 		return true
-- -- 	end

-- -- 	return false
-- -- end