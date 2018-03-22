local property = {}

property.name = "Club Catalyst"

property.category = Fusion.property.categories.club

property.price = 250

property.doors = {
	Vector(-9860, -1006, 60),
	Vector(-9860, -914, 60),
}

property.cams = {
	pos = {
		Vector(-9203.218750, -723.672913, 200.410477),
		Vector(-7957.341309, -1460.797729, -92.062225),
	},

	ang = {
		Angle(0, -160, 0),
		Angle(0, 135, 0),
	}
}

property.government = false

Fusion.property:Register(property)