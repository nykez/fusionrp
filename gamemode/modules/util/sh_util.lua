Fusion.util = Fusion.util or {}

function Fusion.util:JSON(tbl)
	return util.TableToJSON(tbl)
end

function Fusion.util:Table(JSON)
	return util.JSONToTable(json)
end