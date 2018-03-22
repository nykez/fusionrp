local property = {}

property.name = "Fire Station"

property.category = Fusion.property.categories.downtown

property.price = 250

property.doors = {
	Vector(-4736, -3680.0200195313, 141.05999755859),
	Vector(-4992, -3680, 141.05999755859),
	Vector(-5248, -3680, 141.05999755859),
	Vector(-5504.0200195313, -3680, 141.05999755859),
	Vector(-5504, -2880, 141.05999755859),
	Vector(-5248, -2880, 141.05999755859),
	Vector(-4992, -2880, 141.05999755859),
	Vector(-4736, -2880, 141.05999755859),
	Vector(-5362, -3396, 324.25),
	Vector(-4722, -3396, 324.25),
	Vector(-4722, -3132, 324.25),
	Vector(-4966, -3132, 324.25),
	Vector(-5362, -3132, 324.25),
	Vector(-5764, -3770, 59.744499206543),
	Vector(-5800, -3386, 60.25),
	Vector(-5974, -3070, 60.25),
	Vector(-6001.919921875, -3070, 60.25),
	Vector(-6204, -3310, 60.250701904297),
	Vector(-6204, -3218, 60.250701904297),
}

property.cams = {
	pos = {
		Vector(-4923.382813, -1920.673340, 291.672882),
	},

	ang = {
		Angle(0, -100, 0),
	}
}

property.government = true

Fusion.property:Register(property)