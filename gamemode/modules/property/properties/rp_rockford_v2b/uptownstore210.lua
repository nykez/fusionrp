local property = {}

property.name = "Uptown Store 210"

property.category = Fusion.property.categories.uptown_business

property.price = 250

property.doors = {
	Vector(2236, 1554, 596.2509765625),
	Vector(2236, 1646, 596.2509765625),
}

property.cams = {
	pos = {
		Vector(2686.978271, 1611.602173, 676.233398),
	},

	ang = {
		Angle(0, -180, 0),
	}
}

property.government = false

Fusion.property:Register(property)