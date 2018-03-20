local property = {}

property.name = "Suburban House #10"

property.category = Fusion.property.categories.sub_house

property.price = 850

property.doors = {
	Vector(10688, 5472, 1632),
	Vector(10688, 5472, 1632),
	Vector(10882, 4734, 1620),
	Vector(11074, 5374, 1620),
	Vector(11074, 4893.919921875, 1620),
	Vector(10830, 4226, 1620),
	Vector(11246.099609375, 5002, 1756),
	Vector(11266, 4941.919921875, 1756),
	Vector(11266, 4813.919921875, 1756),
	Vector(11198, 4590.080078125, 1756),
	Vector(11198, 4478.080078125, 1756),
	Vector(10941.900390625, 4670, 1756),
	Vector(10814.099609375, 4610, 1756),
	Vector(11675, 5288.990234375, 1596.0100097656)
}

property.cams = {
	pos = {
		Vector(11045.565430, 6524.541504, 1768.200562),
        Vector(11395.776367, 3263.053955, 1608.031250),
	},

	ang = {
		Angle(4.308490, -97.321152, 0.000000),
		Angle(-1.773999, 107.880203, 0.000000)
	}
}

property.government = false

Fusion.property:Register(property)
