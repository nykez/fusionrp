local property = {}

property.name = "Police Station"

property.category = Fusion.property.categories.downtown

property.price = 250

property.doors = {
	Vector(-8892, -5786, 60.25),
	Vector(-8892, -5878, 60.25),
	Vector(-8538, -5636, 59.744499206543),
	Vector(-7717.919921875, -4932, 60.25),
	Vector(-7481.919921875, -4932, 60.25),
	Vector(-7846, -5020, 59.744499206543),
	Vector(-7548, -5034, 59.744499206543),
	Vector(-7548, -5178, 59.744499206543),
	Vector(-7456, -5125.919921875, 60.25),
	Vector(-7469.919921875, -5308, 60.25),
	Vector(-7324, -5322, 60.25),
	Vector(-7529.990234375, -5764, 60.25),
	Vector(-7620, -5952, 148),
	Vector(-7370, -5380, -1356),
	Vector(-7228, -5402, -1356.2600097656),
	Vector(-7228, -5650, -1356.2600097656),
	Vector(-7548, -5650, -1356.2600097656),
}

property.cams = {
	pos = {
		Vector(-9358.084961, -6748.453125, 581.590698),
	},

	ang = {
		Angle(15, 45, 0),
	}
}

property.government = true

Fusion.property:Register(property)