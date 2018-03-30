hook.Add("PreDrawHalos", "AddHalos", function()
	local h = {}

	for k, v in pairs(ents.FindInSphere(LocalPlayer():GetPos(), 300)) do
		if v:IsValid() && v:GetClass() == "ent_item" then
			local trace = LocalPlayer():GetEyeTrace()

			if trace.Entity && IsValid(trace.Entity) && trace.Entity == v then
				table.insert(h, v)
			end
		end
	end

    halo.Add(h, Color(80, 255, 80), 2, 2, 2)
end)
