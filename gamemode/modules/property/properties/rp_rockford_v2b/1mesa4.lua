local property = {}

property.name = "Mesa Apartment 1, Apartment 4"

property.category = Fusion.property.categories.mesa

property.price = 250

property.doors = {
	Vector(-1538, 9266, 804),
	Vector(-1870, 9466, 804),
	Vector(-1990, 9382, 804),
	Vector(-1870, 9338, 804),
	Vector(-1838.0799560547, 8962, 804),
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