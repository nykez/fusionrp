local property = {}

property.name = "Pacific Standard Tavern"

property.category = Fusion.property.categories.uptown_business

property.price = 250

property.doors = {
	Vector(-1212, 5474, 628),
	Vector(-1212, 5382, 628),
}

property.cams = {
	pos = {
		Vector(-2236.206055, 5381.477539, 780.090271),
		Vector(-1173.585693, 5369.830566, 651.204529),
	},

	ang = {
		Angle(0, 15, 0),
		Angle(0, 50, 0),
	}
}

property.government = false

Fusion.property:Register(property)