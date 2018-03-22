local property = {}

property.name = "Mesa Apartment 2, Apartment 1"

property.category = Fusion.property.categories.mesa

property.price = 250

property.doors = {
	Vector(254, 8190, 668),
	Vector(-78, 7938, 668),
	Vector(-198, 7982, 668),
	Vector(-78, 8066, 668),
}

property.cams = {
	pos = {
		Vector(-1810.732422, 7820.032715, 892.102661),
	},

	ang = {
		Angle(0, -70, 0),
	}
}

property.government = false

Fusion.property:Register(property)