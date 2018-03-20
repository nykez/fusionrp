local property = {}

property.name = "Suburban House #8"

property.category = Fusion.property.categories.sub_house

property.price = 600

property.doors = {
	Vector(10805.900390625, 2558, 1620),
	Vector(10990, 2050, 1620),
	Vector(10770, 2054, 1620),
	Vector(10662, 2130, 1620),
	Vector(10778.099609375, 2242, 1620),
	Vector(10430, 2426, 1620),
	Vector(10518.099609375, 2050, 1620),
	Vector(10598.099609375, 1730, 1620),
}

property.cams = {
	pos = {
		Vector(11484.977539, 1219.336914, 1795.470093),
        Vector(11001.874023, 3095.264404, 1675.338135)
	},

	ang = {
		Angle(10.559966, 127.366318, 0.000000),
		Angle(5.998038, -112.249847, 0.000000)
	}
}

property.government = false

Fusion.property:Register(property)
