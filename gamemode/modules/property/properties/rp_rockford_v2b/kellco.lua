local property = {}

property.name = "Kell Co."

property.category = Fusion.property.categories.country_business

property.price = 250

property.doors = {
	Vector(-13380, 12320, 604),
	Vector(-13378, 12119, 566),
}

property.cams = {
	pos = {
		Vector(-12694.573242, 12331.083984, 703.177246),
		Vector(-14081.096680, 12474.363281, 748.171387),
	},

	ang = {
		Angle(0, -180, 0),
		Angle(0, -15, 0),
	}
}

property.government = false

Fusion.property:Register(property)