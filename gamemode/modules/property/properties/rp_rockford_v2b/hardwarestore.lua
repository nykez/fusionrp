local property = {}

property.name = "Hardware Store"

property.category = Fusion.property.categories.downtown_business

property.price = 250

property.doors = {
	Vector(-7268.7299804688, -3244, 60),
}

property.cams = {
	pos = {
		Vector(-6647.017090, -3413.674561, 207.294968),
	},

	ang = {
		Angle(0, 165, 0),
	}
}

property.government = true

Fusion.property:Register(property)