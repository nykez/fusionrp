local property = {}

property.name = "Apartment Building 201, Apartment 2"

property.category = Fusion.property.categories.apartment

property.price = 250

property.doors = {
	Vector(-3225.3100585938, -7375, 177.28100585938),
	Vector(-2920, -7295, 175),
	Vector(-2832, -7375, 175),
}

property.cams = {
	pos = {
		Vector(-3649.507813, -6539.818848, 155.514313),
		Vector(-2388.806152, -6449.779297, 162.898499),
	},

	ang = {
		Angle(0, -60, 0),
		Angle(0, -120, 0),
	}
}

property.government = false

Fusion.property:Register(property)