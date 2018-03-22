local property = {}

property.name = "City Shop 169"

property.category = Fusion.property.categories.downtown_business

property.price = 250

	property.doors = {
	Vector(-8668, -3826, 60),
	Vector(-8668, -3918, 60),
}

property.cams = {
	pos = {
		Vector(-9329.942383, -3888.538086, 180.896286),
	},

	ang = {
		Angle(0, 0, 0),
	}
}

property.government = false

Fusion.property:Register(property)