local property = {}

property.name = "Taco Bell"

property.category = Fusion.property.categories.uptown_business

property.price = 250

property.doors = {
	Vector(622, 2308, 596),
	Vector(530, 2308, 596),
	Vector(697.99798583984, 2266, 596),
	Vector(698, 1485.9200439453, 596),
}

property.cams = {
	pos = {
		Vector(37.354614, 2817.838135, 723.971130),
	},

	ang = {
		Angle(0, -50, 0),
	}
}

property.government = false

Fusion.property:Register(property)