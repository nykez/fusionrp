ITEM.name = "Blueprint Base"
ITEM.model = "models/props_lab/binderblue.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.desc = "Crafting's basic."
ITEM.isBlueprint = true

function ITEM:getDesc()
	return ""
end

function ITEM:onRegistered()
	if (SERVER) then
		if (self.requirements and self.result) then
			if (!self.base) then
				ErrorNoHalt(self.uniqueID .. " does not have proper craft data!")
			end
		end
	end

	if self.mixture then
		
	end
end


ITEM.functions.use = {
	name = "Learn",
	tip = "useTip",
	icon = "icon16/add.png",
	onRun = function(item)

		
		return true
	end,
}