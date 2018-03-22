local property = {}

property.name = "Rockford Customs"

property.category = Fusion.property.categories.uptown

property.price = 250

property.doors = {
	Vector(-8000, -1912, 132),
}

property.cams = {
	pos = {
		Vector(-7768.192871, -2707.219727, 263.408905),
	},

	ang = {
		Angle(0, 110, 0),
	}
}

property.government = true

Fusion.property:Register(property)