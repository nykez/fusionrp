
Fusion.skills = Fusion.skills or {}
Fusion.skills.cache = Fusion.skills.cache or {}
Fusion.skills.cats = Fusion.skills.cat or {}

local MAX_LEVEL = 35

local skills = {
	["Crafting"] = {MaxLevel = 25, Const = 0.20, Cat = "Player"},
	["Herbology"] = {MaxLevel = 25, Const = 0.20, Cat = "Player"},
	["Mining"] = {MaxLevel = 25, Const = 0.20, Cat = "Player"},
	["Forestry"] = {MaxLevel = 25, Const = 0.20, Cat = "Player"},
	["Bartering"] = {MaxLevel = 25, Const = 0.20, Cat = "Player"},
	["Endurance"] = {MaxLevel = 25, Const = 0.20, Cat = "Player"},
	["Cooking"] = {MaxLevel = 25, Const = 0.20, Cat = "Player"},

	["Police"] = {MaxLevel = 25, Const = 0.20, Cat = "Government"},
	["EMT"] = {MaxLevel = 25, Const = 0.20, Cat = "Government"},
	["Firefighter"] = {MaxLevel = 25, Const = 0.20, Cat = "Government"},

	["Light Weapons"] = {MaxLevel = 25, Const = 0.20, Cat = "Weapon Proficiency"},
	["Assault Rifles"] = {MaxLevel = 25, Const = 0.20, Cat = "Weapon Proficiency"},
	["Long Rifles"] = {MaxLevel = 25, Const = 0.20, Cat = "Weapon Proficiency"},
	["Explosives"] = {MaxLevel = 25, Const = 0.20, Cat = "Weapon Proficiency"},
	["Melee"] = {MaxLevel = 25, Const = 0.20, Cat = "Weapon Proficiency"},


}

//

function Fusion.skills.Load()
	for k,v in pairs(skills) do
		Fusion.skills:Register(k, v.MaxLevel, v.Const, v.Reduce)
		Fusion.skills.cats[v.Cat] = Fusion.skills.cats[v.Cat] or {}
		Fusion.skills.cats[v.Cat][k] = v
	end
end
hook.Add("PostGamemodeLoaded", "FusionRP.LoadSkillsTable", Fusion.skills.Load)

function Fusion.skills:GetCat(strCat)
	return Fusion.skills.cats[strCat]
end

function Fusion.skills:Register(strSkill, intMaxLevel, intXPConst, intReduceRatio )
	Fusion.skills.cache[strSkill] = {Max = intMaxLevel, Const = intXPConst, Ratio = intReduceRatio}
end

Fusion.skills.Load()


local charMeta = Fusion.meta.character

function charMeta:GetSkillLevel(strSkill)
	local skillData = Fusion.skills.cache[strSkill]
	if not skillData then return end 

	return self:getLevels()[strSkill] or 1
end

function charMeta:GetSkillXP(strSkill)
	return self:getSkills()[strSkill] or 0 
end

function charMeta:GetRequiredXP(strSkill)
	local skills = self:getSkills()

	local mySkill = self:GetSkillLevel(strSkill)

	return (((10+(((mySkill or 1)*((mySkill or 1)+1)*90))))*2)
end

if SERVER then
	function charMeta:AddSkillXP(strSkill, intAmount)
		local skill = Fusion.skills.cache[strSkill]

		intAmount = tonumber(intAmount)

		if not skill then return end
		
		local ourSkills = self:getSkills()
		local client = self:getPlayer()

		local oldLevel = self:GetSkillLevel(strSkill)
		if oldLevel >= MAX_LEVEL then return end


		if ourSkills[strSkill] then
			ourSkills[strSkill] = ourSkills[strSkill] + intAmount
		else
			ourSkills[strSkill] = intAmount
		end


		if ourSkills[strSkill] > self:GetRequiredXP(strSkill) then
			local levels = self:getLevels()

			if levels[strSkill] then
				levels[strSkill] = levels[strSkill] + 1
			else
				levels[strSkill] = 2
			end

			self:setLevels(levels)

			ourSkills[strSkill] = 0

			client:Notify('You leveled up '.. strSkill .. "!")
		end
		
		self:setSkills(ourSkills)

		self:Save()
	end

	concommand.Add("addskill", function(pPlayer)
		local char = pPlayer:getChar()

		char:AddSkillXP("Crafting", 40)

		pPlayer:Notify("Level: " .. char:GetSkillLevel("Crafting"))

		//
	end)
else
	netstream.Hook("skills", function(id, key, value)
		local character = Fusion.character.loaded[id]

		if (character) then
			character:getSkills()[key] = value
		end
	end)
end



