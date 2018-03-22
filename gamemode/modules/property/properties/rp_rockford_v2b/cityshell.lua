local property = {}

property.name = "City Shell"

property.category = Fusion.property.categories.uptown

property.price = 250

property.doors = {
	Vector(644, 3982, 596),
	Vector(644, 3890, 596),
}

property.cams = {
	pos = {
		Vector(-556.535156, 3927.900146, 685.376282),
	},

	ang = {
		Angle(0, -0, 0),
	}
}

property.government = true

Fusion.property:Register(property)