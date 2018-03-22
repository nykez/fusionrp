local property = {}

property.name = "Mesa Apartment 2, Apartment 4"

property.category = Fusion.property.categories.mesa

property.price = 250

property.doors = {
	Vector(514, 8142, 804),
	Vector(846, 8070, 804),
	Vector(966, 8026, 804),
	Vector(846, 7942, 804),
	Vector(814.083984375, 8446, 804),
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