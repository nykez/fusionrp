local property = {}

property.name = "Country House 1"

property.category = Fusion.property.categories.country

property.price = 250

property.doors = {
	Vector(12158, -8944, 404.25),
	Vector(12158, -8848, 404.25),
	Vector(11454, -8806, 404),
	Vector(11630, -9018, 404),
	Vector(11518, -9006, 404),
	Vector(11266, -8658, 404),
	Vector(11534, -8902, 540),
	Vector(11326, -8902, 540),
}

property.cams = {
	pos = {
		Vector(13054.131836, -8860.246094, 540.784546),
		Vector(12740.519531, -5256.138672, 505.740997),
	},

	ang = {
		Angle(0, -180, 0),
		Angle(0, -120, 0),
	}
}

property.government = false

Fusion.property:Register(property)