local property = {}

property.name = "Country House 2"

property.category = Fusion.property.categories.country

property.price = 250

property.doors = {
	Vector(12798, -5552, 404.25),
	Vector(12798, -5456, 404.25),
	Vector(12270, -5626, 404),
	Vector(12158, -5614, 404),
	Vector(12094, -5414, 404),
	Vector(11906, -5266, 404),
	Vector(12174, -5510, 540),
	Vector(11966, -5510, 540),
}

property.cams = {
	pos = {
		Vector(13398.114258, -5409.800293, 620.270142),
		Vector(12740.519531, -5256.138672, 505.740997),
	},

	ang = {
		Angle(0, 180, 0),
		Angle(0, -140, 0),
	}
}

property.government = false

Fusion.property:Register(property)