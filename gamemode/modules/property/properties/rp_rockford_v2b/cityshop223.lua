local property = {}

property.name = "City Shop 223"

property.category = Fusion.property.categories.downtown_business

property.price = 250

property.doors = {
	Vector(-8668, 94, 60),
	Vector(-8668, 2, 60),
	Vector(-7966, 442, 60),
	Vector(-7778, 314, 60),
}

property.cams = {
	pos = {
		Vector(-9405.764648, 37.232338, 185.510437),
	},

	ang = {
		Angle(0, 0, 0),
	}
}

property.government = false

Fusion.property:Register(property)