local property = {}

property.name = "Country Shelll"

property.category = Fusion.property.categories.country_business

property.price = 250

property.doors = {
	Vector(-14276, 2610, 444),
	Vector(-14276, 2702, 444),
}

property.cams = {
	pos = {
		Vector(-13024.175781, 2233.506348, 670.845581),
	},

	ang = {
		Angle(0, -160, 0),
	}
}

property.government = false

Fusion.property:Register(property)