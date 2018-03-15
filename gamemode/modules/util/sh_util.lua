Fusion.util = Fusion.util or {}

function Fusion.util:JSON(tbl)
	return util.TableToJSON(tbl)
end

function Fusion.util:Table(JSON)
	return util.JSONToTable(json)
end

if SERVER then
	function Fusion.util:Font(strFont)
		resource.AddFile("resource/fonts/"..strFont..".ttf")
		print("[Fusion RP] Added Font -> " ..strFont)
	end
end