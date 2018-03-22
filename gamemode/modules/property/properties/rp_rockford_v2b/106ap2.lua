local property = {}

property.name = "Apartment Building 106, Apartment 2"

property.category = Fusion.property.categories.apartment

property.price = 250

property.doors = {
	Vector(-3880, -7329, 177.28100585938),
	Vector(-4272, -7329, 175),
	Vector(-4184, -7249, 175),
}

property.cams = {
	pos = {
		Vector(-3405.359131, -6612.591309, 236.591400),
		Vector(-4700.693359, -6595.572754, 202.486893),
	},

	ang = {
		Angle(0, -120, 0),
		Angle(0, -60, 0),
	}
}

property.government = false

Fusion.property:Register(property)