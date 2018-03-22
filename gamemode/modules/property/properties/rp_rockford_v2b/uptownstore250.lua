local property = {}

property.name = "Uptown Store 250"

property.category = Fusion.property.categories.uptown_business

property.price = 250

property.doors = {
	Vector(2236, 2706, 596.2509765625),
	Vector(2236, 2798, 596.2509765625),
}

property.cams = {
	pos = {
		Vector(2827.490234, 2776.400391, 697.432312),
	},

	ang = {
		Angle(0, -180, 0),
	}
}

property.government = false

Fusion.property:Register(property)