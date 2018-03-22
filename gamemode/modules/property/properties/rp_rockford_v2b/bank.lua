local property = {}

property.name = "Bank"

property.category = Fusion.property.categories.downtown

property.price = 250

property.doors = {
	Vector(-2848, -2916, 84.25),
	Vector(-2915.9399414063, -2848.0600585938, 84.25),
	Vector(-3780, -3324, 84),
	Vector(-3880, -4096, 124.2799987793),
	Vector(-3716, -3370, 84),
}

property.cams = {
	pos = {
		Vector(-2239.076904, -2107.135498, 279.609039),
	},

	ang = {
		Angle(0, -130, 0),
	}
}

property.government = true

Fusion.property:Register(property)