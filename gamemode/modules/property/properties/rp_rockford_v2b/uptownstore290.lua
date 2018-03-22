local property = {}

property.name = "Uptown Store 290"

property.category = Fusion.property.categories.uptown_business

property.price = 250

property.doors = {
	Vector(2236, 3474, 596.2509765625),
	Vector(2236, 3566, 596.2509765625),
}

property.cams = {
	pos = {
		Vector(2545.593750, 3526.963135, 678.895874),
	},

	ang = {
		Angle(0, -180, 0),
	}
}

property.government = false

Fusion.property:Register(property)