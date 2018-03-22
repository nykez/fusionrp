local property = {}

property.name = "Frosty Fashion"

property.category = Fusion.property.categories.uptown_business

property.price = 250

property.doors = {
	Vector(2236, 3858, 596.2509765625),
	Vector(2236, 3950, 596.2509765625),
	Vector(2062, 3737.919921875, 596.25),
}

property.cams = {
	pos = {
		Vector(2812.072266, 3906.453613, 684.064392),
	},

	ang = {
		Angle(0, -180, 0),
	}
}

property.government = true

Fusion.property:Register(property)