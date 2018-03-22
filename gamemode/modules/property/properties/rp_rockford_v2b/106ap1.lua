local property = {}

property.name = "Apartment Building 106, Apartment 1"

property.category = Fusion.property.categories.apartment

property.price = 250

property.doors = {
	Vector(-3880, -7329, 57.28099822998),
	Vector(-4272, -7329, 55),
	Vector(-4184, -7249, 55),
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