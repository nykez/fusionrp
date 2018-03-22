local property = {}

property.name = "Impound Lot"

property.category = Fusion.property.categories.industrial

property.price = 250

	property.doors = {
	Vector(-7226, 318, 60),
	Vector(-7290, -210, 60),
	Vector(-7108, 142, 60),
	Vector(-7108, 50, 60),
}

property.cams = {
	pos = {
		Vector(-6464.195313, -98.237007, 164.370621),
	},

	ang = {
		Angle(0, 180, 0),
	}
}

property.government = true

Fusion.property:Register(property)