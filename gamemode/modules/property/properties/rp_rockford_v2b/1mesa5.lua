local property = {}

property.name = "Mesa Apartment 1, Apartment 5"

property.category = Fusion.property.categories.mesa

property.price = 250

property.doors = {
	Vector(-1278, 9218, 940),
	Vector(-946, 9470, 940),
	Vector(-826, 9426, 940),
	Vector(-946, 9342, 940),
	Vector(-974, 8962, 940),
}

property.cams = {
	pos = {
		Vector(-1810.732422, 7820.032715, 892.102661),
	},

	ang = {
		Angle(0, 70, 0),
	}
}

property.government = false

Fusion.property:Register(property)