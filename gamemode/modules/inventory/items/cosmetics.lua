local item = {}

item.id = 7

item.name = "A Cool Hat"

item.model = "models/props_c17/FurnitureFridge001a.mdl"

item.desc = "This will make you very cool... lol."

item.cosmetic = true

item.equipslot = Fusion.inventory.slots.cosmetic

item.cosmeticslot = "hat"

item.data = {
	bone = 'ValveBiped.Bip01_Head1',
	pos = Vector(0, 0, 5),
	ang = Angle(30, 90, 0),
}

Fusion.inventory:RegisterItem(item)