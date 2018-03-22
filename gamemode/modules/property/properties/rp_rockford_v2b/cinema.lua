local property = {}

property.name = "Cinema"

property.category = Fusion.property.categories.uptown

property.price = 250

property.doors = {
	Vector(-964, 2334, 596),
	Vector(-964, 2426, 596),
	Vector(-964, 2438, 596),
	Vector(-964, 2530, 596),
	Vector(-1724, 2116, 596.25),
	Vector(-1724, 2020, 596.25),
}

property.cams = {
	pos = {
		Vector(17.673615, 2606.478271, 776.063660),
	},

	ang = {
		Angle(0, -160, 0),
	}
}

property.government = false

Fusion.property:Register(property)