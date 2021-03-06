Fusion.orgs = Fusion.orgs or {}
Fusion.orgs.cache = Fusion.orgs.cache or {}

Fusion.orgs.flags = {
	{"i", "Invite"},
	{"f", "Flush Invite"},
	{"k", "Kick"},
	{"c", "Create Ranks"},
	{"m", "Edit MOTD"},
	{"w", "Withdraw Money"},
	{"d", "Deposit Money"},
}

local org = Fusion.meta.orgs or {}
org.__index = org

function org:getName()
	return self.data.name
end

function org:getMOTD()
	return self.data.motd or "No MOTD"
end

function org:getMembers()
	return self.data.members or false
end

function org:setData(str, value)
	self.data[str] = value

	if SERVER then
		netstream.Start(nil, "Fusion_UpdateOrg", self.id, str, value)
		if str == "members" then
			local updateObj = mysql:Update("fusion_orgs");
			updateObj:Update("members", util.TableToJSON(self.data.members))
			updateObj:Where("id", self:getID())
			updateObj:Execute();
		else
			local updateObj = mysql:Update("fusion_orgs");
			updateObj:Update("data", util.TableToJSON(self.data))
			updateObj:Where("id", self:getID())
			updateObj:Execute();
		end
	end
end

function org:getData(str, default)
	if self.data[str] then 
		return self.data[str]
	elseif default then 
		return default
	else
		return {}
	end
end

function org:getID()
	return self.id or self.data.id or false
end

function org:getRanks()
	return self.data.ranks or {}
end

function org:getMembers()
	return self.data.members or {} 
end

function org:HasPermissions(character, flag)
	local members = self:getMembers()

	local rank = nil

	if members[character:getPlayer():SteamID()] then
		rank = members[character:getPlayer():SteamID()].rank
	end

	if !rank then return false end 

	if rank == "owner" then return true end

	local ourRanks = self:getRanks()

	if ourRanks[rank] then
		if type(flag) == 'table' then
			for k,v in pairs(flag) do
				if table.HasValue(ourRanks[rank], v) then
					return true 
				end
			end
		else
			if table.HasValue(ourRanks[rank], flag) then
				return true 
			end
		end
	end


	return false
end

function org:GetRank(pPlayer)
	local members = self:getMembers()

	local rank = false

	if members[pPlayer:SteamID()] then
		rank = members[pPlayer:SteamID()].rank
	end

	return rank
end

function org:CreateRank(character, strRank, tblflags)
	if not character then return end 

	local ranks = self:getRanks()

	if !self:HasPermissions(character, "c") then 
		character:getPlayer():Notify("No permissions.")
		return 
	end

	if ranks and ranks[strRank] then
		character:getPlayer():Notify("A rank with that name already exists.")
		return
	end

	ranks[strRank] = tblflags

	self:setData("ranks", ranks)

	character:getPlayer():Notify("Rank created succesfullly.")
end

function org:DeletRank(character, strRank)
	if not character then return end 

	local ranks = self:getRanks()

	if !self:HasPermissions(character, "c") then 
		character:getPlayer():Notify("No permissions.")
		return 
	end


	if !ranks and !ranks[strRank] then
		character:getPlayer():Notify("No rank with that name exists")
		return
	end

	ranks[strRank] = nil

	self:setData("ranks", ranks)

	character:getPlayer():Notify("Rank deleted succesfullly.")
end

function org:EditRank(character, strRank, tblflags)
	if not character then return end 

	local ranks = self:getRanks()

	if !self:HasPermissions(character, "c") then return end

	if !ranks[strRank] then return end 


	ranks[strRank] = tblflags

	self:setData("ranks", ranks)

	character:getPlayer():Notify("Rank editted succesfullly.")
end

function org:AddUser(user, userRank)
	local ranks = self:getRanks()

	if not ranks[userRank] then return false end 

	local members = self:getMembers()
	if not members then return false end 

	members[user:SteamID()] = {name = user:getChar():getName(), rank = userRank}

	self:setData("members", members)

	return true 
end

function org:RemoveUser(user)
	if not user then return end
	
	local member = self:getMembers()

	if member and member[user:SteamID()] then
		member[user:SteamID()] = nil
		self:setData("members", member)

		return true
	end

	return false 
end

Fusion.meta.orgs = org


local PLAYER = FindMetaTable("Player")

function PLAYER:OrgObject()
	return Fusion.orgs.cache[tonumber(self:getChar():getOrg())] or false
end


function Fusion.orgs.New(name, motd, tblMembers, money, id, data)
	local self = setmetatable({}, Fusion.meta.orgs)

	if data then
		self.data = data
		self.data.name = name
		self.data.members = tblMembers
		self.data.money = money
		self.data.id = id
		self.id = id
	else
		self.data = {}

		self.data.name = name
		self.data.motd = motd
		self.data.members = tblMembers
		self.data.money = money
		self.data.id = id 
		self.id = id
	end


	return self;
end


