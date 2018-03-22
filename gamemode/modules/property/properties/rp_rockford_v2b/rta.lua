local property = {}

property.name = "RTA"

property.category = Fusion.property.categories.uptown

property.price = 250

property.doors = {
	Vector(-1394, 4220, 596),
	Vector(-1486, 4220, 596),
}

property.cams = {
	pos = {
		Vector(-868.749756, 4991.894043, 695.505127),
	},

	ang = {
		Angle(0, -115, 0),
	}
}

property.government = false

Fusion.property:Register(property)