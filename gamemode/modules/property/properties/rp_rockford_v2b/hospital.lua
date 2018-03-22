local property = {}

property.name = "Hospital"

property.category = Fusion.property.categories.downtown

property.price = 250

property.doors = {
	Vector(-68, -4840, 216),
	Vector(-68, -4840, 216),
	Vector(708, -4840, 216),
	Vector(708, -4840, 216),
	Vector(-378, -5886, 114),
	Vector(-278, -6050, 116.25),
	Vector(-226, -5658, 114),
	Vector(-126.08000183105, -5442.080078125, 116),
	Vector(-126, -5382, 116),
	Vector(350, -5154, 114),
	Vector(638, -5342, 114),
	Vector(761.91998291016, -5562.080078125, 116),
	Vector(126, -6330, 116),
	Vector(-278, -6050, 116.25),
}

property.cams = {
	pos = {
		Vector(-2273.510986, -5993.766113, 334.363831),
	},

	ang = {
		Angle(0, 10, 0),
	}
}

property.government = true

Fusion.property:Register(property)