local property = {}

property.name = "City Shop 195"

property.category = Fusion.property.categories.downtown_business

property.price = 250

property.doors = {
	Vector(-8668, -3154, 60),
	Vector(-8668, -3246, 60),
}

property.cams = {
	pos = {
		Vector(-9351.721680, -3128.805176, 183.995850),
	},

	ang = {
		Angle(0, 0, 0),
	}
}

property.government = false

Fusion.property:Register(property)