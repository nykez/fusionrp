local property = {}

property.name = "City Hall"

property.category = Fusion.property.categories.downtown

property.price = 250

property.doors = {
	Vector(-5262, -5756, 116),
	Vector(-5170, -5756, 116),
	Vector(-4686, -5756, 116),
	Vector(-4594, -5756, 116),
	Vector(-4110, -5756, 116),
	Vector(-4018, -5756, 116),
	Vector(-4412, -4804, 116),
	Vector(-4412, -4900.080078125, 116),
	Vector(-4948, -5686, 776),
	Vector(-4444, -5686, 776),
	Vector(-4980.080078125, -5132, 772),
	Vector(-4884, -5132, 772),
	Vector(-4452.080078125, -5132, 772),
	Vector(-4356, -5132, 772),
	Vector(-4084.080078125, -5132, 772),
	Vector(-3988, -5132, 772),
}

property.cams = {
	pos = {
		Vector(-5264.626953, -7092.220215, 520.912109),
	},

	ang = {
		Angle(0, 75, 0),
	}
}

property.government = true

Fusion.property:Register(property)