local property = {}

property.name = "Mesa Apartment 2, Apartment 5"

property.category = Fusion.property.categories.mesa

property.price = 250

property.doors = {
	Vector(-50, 8446, 940),
	Vector(-78, 7938, 940),
	Vector(-198, 7982, 940),
	Vector(-78, 8066, 940),
	Vector(254, 8190, 940),
}

property.cams = {
	pos = {
		Vector(-1810.732422, 7820.032715, 892.102661),
	},

	ang = {
		Angle(0, -90, 0),
	}
}

property.government = false

Fusion.property:Register(property)