
function GM:PlayerBindPress(client, bind, pressed)
	bind = bind:lower()
	
	if (bind:find("gm_showhelp") and pressed) then

	elseif ((bind:find("use") or bind:find("attack")) and pressed) then
		local menu, callback = Fusion.menu.getActiveMenu()

		if (menu and Fusion.menu.onButtonPressed(menu, callback)) then
			return true
		elseif (bind:find("use") and pressed) then
			local data = {}
				data.start = client:GetShootPos()
				data.endpos = data.start + client:GetAimVector()*96
				data.filter = client
			local trace = util.TraceLine(data)
			local entity = trace.Entity

			if (IsValid(entity) and entity:GetClass() == "ent_item") then
				hook.Run("ItemShowEntityMenu", entity)
			end
		end
	elseif (bind:find("speed") and client:KeyDown(IN_WALK) and pressed) then
		if (LocalPlayer():Crouching()) then
			RunConsoleCommand("-duck")
		else
			RunConsoleCommand("+duck")
		end
	end
end

-- Called when use has been pressed on an item.
function GM:ItemShowEntityMenu(entity)
	for k, v in ipairs(Fusion.menu.list) do
		if (v.entity == entity) then
			table.remove(Fusion.menu.list, k)
		end
	end

	local options = {}
	local itemTable = entity:getItemTable()

	if (!itemTable) then
		pPlayer:Notify('Item broken. Informing admins now.')
		return false
	end

	local function callback(index)
		if (IsValid(entity)) then
			netstream.Start("invAct", index, entity)
		end
	end

	itemTable.player = LocalPlayer()
	itemTable.entity = entity

	for k, v in SortedPairs(itemTable.functions) do

		if (v.onCanRun) then
			if (v.onCanRun(itemTable) == false) then
				continue
			end
		end

		options[(v.name or k)] = function()
			local send = true

			if (v.onClick) then
				send = v.onClick(itemTable)
			end

			if (v.sound) then
				surface.PlaySound(v.sound)
			end

			if (send != false) then
				callback(k)
			end
		end
	end

	if (table.Count(options) > 0) then
		entity.fusionMenuIndex = Fusion.menu.add(options, entity)
	end

	itemTable.player = nil
	itemTable.entity = nil
end