Fusion.util = Fusion.util or {}

function Fusion.util:JSON(tbl)
	return util.TableToJSON(tbl)
end

function Fusion.util:Table(JSON)
	return util.JSONToTable(JSON)
end

if SERVER then
	Fusion.util.fonts = Fusion.util.fonts or {}
	function Fusion.util:Font(strFont)
		if Fusion.util.fonts[strFont] then return end
		resource.AddFile("resource/fonts/"..strFont..".ttf")
		Fusion.util.fonts[strFont] = true
	end
end


