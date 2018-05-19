local item = {}

item.id = 7

item.name = "A Cool Hat"

item.model = "models/captainbigbutt/skeyler/hats/deadmau5.mdl"

item.desc = "This will make you very cool... lol."

item.cosmetic = true

item.equipslot = Fusion.inventory.slots.cosmetic

item.cosmeticslot = "hat"

item.price = 50

item.data = {
	bone = 'ValveBiped.Bip01_Head1',
	pos = Vector(0, 3, 0),
	ang = Angle(-80, 0, -90),
}

Fusion.inventory:RegisterItem(item)

local item = {}

item.id = 8

item.name = "A Cool Hat"

item.model = "models/gmod_tower/fedorahat.mdl"

item.desc = "This will make you very cool... lol."

item.cosmetic = true

item.equipslot = Fusion.inventory.slots.cosmetic

item.cosmeticslot = "hat"

item.price = 50

item.data = {
	bone = 'ValveBiped.Bip01_Head1',
	pos = Vector(0, 3, 0),
	ang = Angle(-60, 0, -90),
}

Fusion.inventory:RegisterItem(item)


local item = {}

item.id = 9

item.name = "Jetpack"

item.model = "models/gmod_tower/jetpack.mdl"

item.desc = "This will make you very cool... lol."

item.cosmetic = true

item.price = 50

item.equipslot = Fusion.inventory.slots.cosmetic

item.cosmeticslot = "back"

item.data = {
	bone = 'ValveBiped.Bip01_Spine',
	pos = Vector(-4, 5, 0),
	ang = Angle(-90, 0, 90),
}

Fusion.inventory:RegisterItem(item)

