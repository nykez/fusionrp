local property = {}

property.name = "Suburban House #11"

property.category = Fusion.property.categories.sub_house

property.price = 250

property.doors = {
	Vector(10798, 7170, 1620),
	Vector(10654, 7806, 1620),
	Vector(10750, 7806, 1620),
	Vector(10810, 7794, 1620),
	Vector(10874, 7438, 1620),
	Vector(10937.900390625, 7450, 1620),
	Vector(10994, 7457.919921875, 1620),
	Vector(10998, 7790.080078125, 1620),
	Vector(11383, 7431, 1596.0100097656),
}



property.cams = {
	pos = {
		Vector(10721.775391, 6444.859863, 1821.503540),
		Vector(10388.250000, 7238.729980, 1671.316895),
	},

	ang = {
		Angle(0, 80, 0),
		Angle(0, 40, 0),
	}
}

property.government = false

Fusion.property:Register(property)