Fusion.util = Fusion.util or {}

function Fusion.util:AddDownloads(strFolder)
	local files, folders = file.Find("materials/"..strFolder.."/*.*", "GAME")

	if files then
		for k,v in pairs(files) do
			resource.AddFile("materials/"..strFolder.."/"..v)
		end
	end

end

Fusion.util:AddDownloads("f_phone")