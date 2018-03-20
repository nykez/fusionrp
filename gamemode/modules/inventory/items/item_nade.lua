
local item = {}

item.id = 5

item.name = "Grenade"

item.model = "models/weapons/w_grenade.mdl"

item.desc = "You can kill combine with this weapon.. I think anyways!"

item.weapon = "weapon_frag"

item.equipslot = Fusion.inventory.slots.misc

Fusion.inventory:RegisterItem(item)