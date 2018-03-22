local property = {}

property.name = "Uptown Store 230"

property.category = Fusion.property.categories.uptown_business

property.price = 250

property.doors = {
	Vector(2236, 2322, 596.2509765625),
	Vector(2236, 2414, 596.2509765625),
}

property.cams = {
	pos = {
		Vector(2830.609131, 2363.912598, 697.432312),
	},

	ang = {
		Angle(0, -180, 0),
	}
}

property.government = false

Fusion.property:Register(property)