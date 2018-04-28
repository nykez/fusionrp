local property = {}

property.name = "Suburban House #3"

property.category = Fusion.property.categories.sub_house

property.price = 250

property.doors = {
	Vector(8194, 5649.919921875, 1620),
	Vector(8378.080078125, 5506, 1620),
	Vector(8386, 5614, 1620),
	Vector(8318, 5614.080078125, 1620),
	Vector(8032, 5248, 1632),
	Vector(8032, 5248, 1632),
	Vector(8386, 5614, 1620),
	Vector(8826, 5540, 1623),
	Vector(8191.009765625, 6299, 1596.0100097656),
}



property.cams = {
	pos = {
		Vector(7345.214355, 6098.890625, 1872.298584),
		Vector(8759.269531, 5464.517578, 1654.887451),
	},

	ang = {
		Angle(0, -25, 0),
		Angle(0, 115, 0),
	}
}

property.government = false

Fusion.property:Register(property)