local property = {}

property.name = "J&M Glass Co."

property.category = Fusion.property.categories.country_business

property.price = 250

property.doors = {
	Vector(-1763.9899902344, 12464, 622),
	Vector(-1766, 12665, 584),
}

property.cams = {
	pos = {
		Vector(-2513.998047, 12495.260742, 791.115906),
		Vector(-1014.049377, 12288.285156, 743.374207),
	},

	ang = {
		Angle(0, 0, 0),
		Angle(0, 160, 0),
	}
}

property.government = false

Fusion.property:Register(property)