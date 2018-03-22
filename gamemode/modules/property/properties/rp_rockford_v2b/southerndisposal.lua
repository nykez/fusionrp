local property = {}

property.name = "Southern Disposal"

property.category = Fusion.property.categories.country_business

property.price = 250

property.doors = {
	Vector(7280, -12860, 428),
	Vector(7481, -12858, 390),
}

property.cams = {
	pos = {
		Vector(7271.249512, -12145.814453, 556.217896),
		Vector(7110.425781, -13585.560547, 569.568665),
	},

	ang = {
		Angle(0, -90, 0),
		Angle(0, 65, 0),
	}
}

property.government = false

Fusion.property:Register(property)