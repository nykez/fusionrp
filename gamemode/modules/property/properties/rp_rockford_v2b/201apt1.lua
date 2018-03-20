local property = {}

property.name = "Apartment Building 201, Apartment 1"

property.category = Fusion.property.categories.apartment

property.price = 250

property.doors = {
	Vector(-3225.3100585938, -7375, 57.28099822998),
	Vector(-2920, -7295, 55),
	Vector(-2832, -7375, 55),
}

property.cams = {
	pos = {
		Vector(-3225.3100585938, -7375, 57.28099822998),
		Vector(-2920, -7295, 55),
		Vector(-2832, -7375, 55)
	},

	ang = {
		Angle(0, 0, 0),
		Angle(0, 0, 0),
		Angle(0, 0, 0)
	}
}

property.government = false

Fusion.property:Register(property)
