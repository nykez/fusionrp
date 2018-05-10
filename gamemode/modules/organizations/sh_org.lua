Fusion.orgs = Fusion.orgs or {}
Fusion.orgs.cache = Fusion.orgs.cache or {}


// Checks if a player has a valid org
function Fusion.orgs.HasPlayerOrg(pPlayer)
	if not pPlayer then return end 

	local char = pPlayer:getChar()

	return char:getOrg() and char:getOrg()["id"] and true or false 
end

// Returns the characters org id //
function Fusion.orgs.GetPlayerOrg(pPlayer)
	if not pPlayer then return end 

	local char = pPlayer:getChar()

	return char:getOrg() and char:getOrg()['id'] or false
end

// Returns the data to the org
function Fusion.orgs.GetOrg(id)
	return Fusion.orgs.cache[id] or false
end

// Can only pass a character to this //
// Owner is super rank will always have permisisons //
function Fusion.orgs.HasPerms(character, flags)
	if character:getOrg()["id"] then
		if character:getOrg()["rank"] == "owner" then
			return true 
		elseif table.HasValue(character:getOrg()["rank"]["flags"], flags) then
			return true
		end
	end

	return false
end