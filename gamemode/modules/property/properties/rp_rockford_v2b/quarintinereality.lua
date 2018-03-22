local property = {}

property.name = "Quarintine Reality"

property.category = Fusion.property.categories.downtown

property.price = 250

property.doors = {
	Vector(-1272, 6578, 544.25),
	Vector(-1272, 6478, 544.25),
	Vector(-1054, 6463.8999023438, 596),
}

property.cams = {
	pos = {
		Vector(-1936.368652, 6535.194824, 673.435852),
	},

	ang = {
		Angle(0, 0, 0),
	}
}

property.government = true

Fusion.property:Register(property)