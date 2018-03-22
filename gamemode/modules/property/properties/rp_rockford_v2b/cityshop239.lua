local property = {}

property.name = "City Shop 239"

property.category = Fusion.property.categories.downtown_business

property.price = 250

property.doors = {
	Vector(-8668, 1194, 60),
	Vector(-8668, 1102, 60),
	Vector(-8034, 694, 60),
}

property.cams = {
	pos = {
		Vector(-9329.874023, 1022.513672, 145.827209),
	},

	ang = {
		Angle(0, 0, 0),
	}
}

property.government = false

Fusion.property:Register(property)