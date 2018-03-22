local property = {}

property.name = "Uptown Store 220"

property.category = Fusion.property.categories.uptown_business

property.price = 250

property.doors = {
	Vector(2236, 1938, 596.2509765625),
	Vector(2236, 2030, 596.2509765625),
}

property.cams = {
	pos = {
		Vector(2832.532959, 2003.925659, 697.432312),
	},

	ang = {
		Angle(0, -180, 0),
	}
}

property.government = false

Fusion.property:Register(property)