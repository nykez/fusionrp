local property = {}

property.name = "Power Plant"

property.category = Fusion.property.categories.industrial

property.price = 250

property.doors = {
	Vector(-7892.009765625, 5972.009765625, 136),
	Vector(-7980.009765625, 5972.009765625, 136),
	Vector(-8570, 5554, 116),
	Vector(-8442, 5554, 116),
	Vector(-7298, 5554, 116),
	Vector(-7426, 5554, 116),
}

property.cams = {
	pos = {
		Vector(-8531.932617, 7028.481445, 415.849976),
	},

	ang = {
		Angle(0, -70, 0),
	}
}

property.government = false

Fusion.property:Register(property)