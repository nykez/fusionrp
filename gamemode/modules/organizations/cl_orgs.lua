
netstream.Hook("Fusion_UpdateOrgs", function(id, data)
	print("updating orgs")
	Fusion.orgs.cache[id] = data

	PrintTable(Fusion.orgs.cache)
end)