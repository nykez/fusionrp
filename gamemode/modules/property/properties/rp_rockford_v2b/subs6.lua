local property = {}

property.name = "Suburban House #6"

property.category = Fusion.property.categories.sub_house

property.price = 250

property.doors = {
	Vector(9034, 1522, 1620),
	Vector(8942.080078125, 1538, 1620),
	Vector(8710, 1474.0799560547, 1620),
	Vector(8382, 1490.0799560547, 1620),
	Vector(8393.919921875, 1414, 1620),
	Vector(8958, 1306.0799560547, 1620),
	Vector(8878.080078125, 1218, 1620),
	Vector(8296, 960, 1656),
	Vector(9598, 990.08001708984, 1620),
}

property.cams = {
	pos = {
		Vector(9343.987305, 2145.188965, 1676.696289),
		Vector(9604.826172, 1367.830933, 1666.818359),
	},

	ang = {
		Angle(0, -115, 0),
		Angle(0, -155, 0),
	}
}

property.government = false

Fusion.property:Register(property)