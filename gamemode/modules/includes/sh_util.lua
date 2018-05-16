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

-- Includes a file from the prefix.
function Fusion.util.include(fileName, state)
	if (!fileName) then
		error("No file name specified for including.")
	end

	-- Only include server-side if we're on the server.
	if ((state == "server" or fileName:find("sv_")) and SERVER) then
		include(fileName)
	-- Shared is included by both server and client.
	elseif (state == "shared" or fileName:find("sh_")) then
		if (SERVER) then
			-- Send the file to the client if shared so they can run it.
			AddCSLuaFile(fileName)
		end

		include(fileName)
	-- File is sent to client, included on client.
	elseif (state == "client" or fileName:find("cl_")) then
		if (SERVER) then
			AddCSLuaFile(fileName)
		else
			include(fileName)
		end
	end
end

-- Include files based off the prefix within a directory.
function Fusion.util.includeDir(directory, fromLua, recursive)
	local baseDir = "fusionrp"
	
	if (SCHEMA and SCHEMA.folder and SCHEMA.loading) then
		baseDir = SCHEMA.folder.."/schema/"
	else
		baseDir = baseDir.."/gamemode/"
	end 
	
	if recursive then
		local function AddRecursive(folder)
			local files, folders = file.Find(folder.."/*", "LUA")
			if (!files) then MsgN("Warning! This folder is empty!") return end

			for k, v in pairs(files) do
				Fusion.util.include(folder .. "/" .. v)
			end

			for k, v in pairs(folders) do
				AddRecursive(folder .. "/" .. v)
			end
		end
		AddRecursive((fromLua and "" or baseDir)..directory)
	else
		-- Find all of the files within the directory.
		for k, v in ipairs(file.Find((fromLua and "" or baseDir)..directory.."/*.lua", "LUA")) do
			-- Include the file from the prefix.
			Fusion.util.include(directory.."/"..v)
		end
	end
end


