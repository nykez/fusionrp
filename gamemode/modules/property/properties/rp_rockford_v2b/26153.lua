local property = {}

property.name = "26153"

property.category = Fusion.property.categories.country

property.price = 250

property.doors = {
	Vector(-8098, -13830, 196),
	Vector(-7998, -13886.099609375, 196),
	Vector(-7998, -13998.099609375, 196),
	Vector(-7998, -14022, 196),
	Vector(-8262, -14090, 196),
	Vector(-8510, -13950, 196),
	Vector(-8394, -13826, 196),
	Vector(-8699.990234375, -13852, 228),
	Vector(-9350.990234375, -13823, 60.009998321533),
	Vector(-7998, -13886.099609375, 60),
	Vector(-7998, -13998.099609375, 60),
	Vector(-7998, -14022, 60),
	Vector(-8062, -14074, 60),
	Vector(-8330, -14010, 60),
	Vector(-8394, -13826, 60),
}

property.cams = {
	pos = {
		Vector(-8480.000000, -12624.126953, 356.704834),
		Vector(-7364.973145, -14807.009766, 307.739624),
	},

	ang = {
		Angle(0, -70, 0),
		Angle(0, 130, 0),
	}
}

property.government = false

Fusion.property:Register(property)