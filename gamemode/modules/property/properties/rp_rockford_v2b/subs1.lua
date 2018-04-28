local property = {}

property.name = "Suburban House #1"

property.category = Fusion.property.categories.sub_house

property.price = 250

property.doors = {
	Vector(8170, 7233.919921875, 1620),
	Vector(8430, 7290, 1620),
	Vector(8490, 7185.919921875, 1620),
	Vector(8429.919921875, 7174, 1620),
	Vector(8199.009765625, 7653, 1596.0100097656),
}


property.cams = {
	pos = {
		Vector(7543.426270, 6824.900391, 1724.063599),
		Vector(8219.839844, 6971.673340, 1665.753418),
	},

	ang = {
		Angle(0, 25, 0),
		Angle(0, 60, 0),
	}
}

property.government = false

Fusion.property:Register(property)