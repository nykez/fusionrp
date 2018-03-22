local property = {}

property.name = "Parker Building Materials"

property.category = Fusion.property.categories.industrial

property.price = 250

property.doors = {
	Vector(-8000, 4030, 128),
	Vector(-8388.6796875, 4163, 62),
}

property.cams = {
	pos = {
		Vector(-7790.725098, 5425.562500, 374.216431),
		Vector(-7150.730469, 3462.506836, 242.945297),
	},

	ang = {
		Angle(0, -100, 0),
		Angle(0, 160, 0),
	}
}

property.government = false

Fusion.property:Register(property)