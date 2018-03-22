local property = {}

property.name = "Mesa Apartment 1, Apartment 3"

property.category = Fusion.property.categories.mesa

property.price = 250

property.doors = {
	Vector(-1278, 9218, 804),
	Vector(-946, 9470, 804),
	Vector(-826, 9426, 804),
	Vector(-946, 9342, 804),
	Vector(-974, 8962, 804),
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