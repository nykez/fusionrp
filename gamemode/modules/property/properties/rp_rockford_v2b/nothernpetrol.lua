local property = {}

property.name = "Nothern Petrol"

property.category = Fusion.property.categories.industrial

property.price = 250

property.doors = {
	Vector(-5699, 7166.5, 54),
	Vector(-6429, 6978.5, 54),
	Vector(-6445, 6211, 54),
}

property.cams = {
	pos = {
		Vector(-7306.110352, 6937.851074, 379.228882),
		Vector(-6372.750000, 6177.519531, 298.547974),
	},

	ang = {
		Angle(0, 15, 0),
		Angle(0, 50, 0),
	}
}

property.government = false

Fusion.property:Register(property)