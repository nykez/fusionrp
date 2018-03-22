local property = {}

property.name = "Uptown Store 260"

property.category = Fusion.property.categories.uptown_business

property.price = 250

property.doors = {
	Vector(2236, 3090, 596.2509765625),
	Vector(2236, 3182, 596.2509765625),
}

property.cams = {
	pos = {
		Vector(2730.458008, 3131.351074, 682.771240),
	},

	ang = {
		Angle(0, -180, 0),
	}
}

property.government = false

Fusion.property:Register(property)