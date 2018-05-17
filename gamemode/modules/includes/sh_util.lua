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

//
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


	baseDir = baseDir.."/gamemode/"
	
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

local playerMeta = FindMetaTable("Player")
function playerMeta:getItemDropPos()
		-- Start a trace.
	local data = {}
		data.start = self:GetShootPos()
		data.endpos = self:GetShootPos() + self:GetAimVector()*86
		data.filter = self
	local trace = util.TraceLine(data)
		data.start = trace.HitPos
		data.endpos = data.start + trace.HitNormal*46
		data.filter = {}
	trace = util.TraceLine(data)

	return trace.HitPos
end


if CLIENT then
	
	function Fusion.util.drawText(text, x, y, color, alignX, alignY, font, alpha)
		color = color or color_white

		return draw.TextShadow({
			text = text,
			font = font or "TargetID",
			pos = {x, y},
			color = color,
			xalign = alignX or 0,
			yalign = alignY or 0
		}, 1, alpha or (color.a * 0.575))
	end
end