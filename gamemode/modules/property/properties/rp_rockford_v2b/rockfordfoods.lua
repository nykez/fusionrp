local property = {}

property.name = "Rockford Foods"

property.category = Fusion.property.categories.uptown_business

property.price = 250

property.doors = {
	Vector(1752, 6024, 626),
	Vector(1752, 6088, 626),
}

property.cams = {
	pos = {
		Vector(2617.619629, 6384.071289, 704.770813),
		Vector(581.562012, 6268.258789, 697.447327),
	},

	ang = {
		Angle(0, -160, 0),
		Angle(0, -20, 0),
	}
}

property.government = true

Fusion.property:Register(property)