local veh = {}

veh.id = "lincoln_ls"

veh.make = 'Lincoln'

veh.name = "LS"

veh.price = 15

veh.model = "models/fusion/ls.mdl"

veh.script = "scripts/vehicles/fusion/fusion_ls.txt"

veh.lplate = {
	Vec = Vector(0, -105.5, 37),
	Ang = Angle(0, 0, 95),
}

Fusion.vehicles:Register(veh)