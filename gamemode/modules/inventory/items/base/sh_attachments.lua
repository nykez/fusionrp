
ITEM.name = "Attachment Base"
ITEM.model = "models/Items/BoxSRounds.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.desc = "%s attachment"
ITEM.category = "Attachment"

function ITEM:getDesc()
	return Format(self.name)
end

local function attach(item, data, bool)
    local client = item.player
    local char = client:getChar()
    local inv = char:getInv()
    local items = inv:getItems()


end


ITEM.functions.use = {
	name = "Attach",
	tip = "useTip",
	icon = "icon16/add.png",
	onRun = function(item)
		
		return true
	end,
}