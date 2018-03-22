local property = {}

property.name = "City Shop 255"

property.category = Fusion.property.categories.downtown_business

property.price = 250

property.doors = {
	Vector(-8668.6201171875, 1704, 60),
	Vector(-8290, 1398, 60),
}

property.cams = {
	pos = {
		Vector(-9040.951172, 1338.430054, 118.827187),
	},

	ang = {
		Angle(0, 35, 0),
	}
}

property.government = false

Fusion.property:Register(property)