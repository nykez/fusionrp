local property = {}

property.name = "Car Dealer"

property.category = Fusion.property.categories.downtown

property.price = 250

property.doors = {
	Vector(-5356, -1664, 112),
	Vector(-4142, -1084, 52),
	Vector(-4050, -1084, 52),
}

property.cams = {
	pos = {
		Vector(-2808.740967, -2709.495605, 309.882080),
	},

	ang = {
		Angle(0, 130, 0),
	}
}

property.government = true

Fusion.property:Register(property)