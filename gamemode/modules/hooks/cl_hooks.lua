

local nextUpdate = 0
local lastTrace = {}
local lastEntity
local mathApproach = math.Approach
local surface = surface
local hookRun = hook.Run
local toScreen = FindMetaTable("Vector").ToScreen

local vignetteAlphaGoal = 0
local vignetteAlphaDelta = 0
local blurGoal = 0
local blurDelta = 0
local hasVignetteMaterial = vignette != "___error"


paintedEntitiesCache = {}

function GM:HUDPaintBackground()
	local localPlayer = LocalPlayer()

	if (!localPlayer.getChar(localPlayer)) then
		return
	end
	
	local realTime = RealTime()
	local frameTime = FrameTime()
	local scrW, scrH = surface.ScreenWidth(), surface.ScreenHeight()



	if (localPlayer.getChar(localPlayer) and nextUpdate < realTime) then
		nextUpdate = realTime + 0.5

		lastTrace.start = localPlayer.GetShootPos(localPlayer)
		lastTrace.endpos = lastTrace.start + localPlayer.GetAimVector(localPlayer)*160
		lastTrace.filter = localPlayer		
		lastTrace.mins = Vector( -4, -4, -4 )
		lastTrace.maxs = Vector( 4, 4, 4 )
		lastTrace.mask = MASK_SHOT_HULL

		lastEntity = util.TraceHull(lastTrace).Entity

		if (IsValid(lastEntity) and (lastEntity.DrawEntityInfo or (lastEntity.onShouldDrawEntityInfo and lastEntity:onShouldDrawEntityInfo()) or hookRun("ShouldDrawEntityInfo", lastEntity))) then
			paintedEntitiesCache[lastEntity] = true
		end
	end
    
	for entity, drawing in pairs(paintedEntitiesCache) do
		if (IsValid(entity)) then
			local goal = drawing and 255 or 0
			local alpha = mathApproach(entity.fusionAlpha or 0, goal, frameTime * 1000)

			if (lastEntity != entity) then
				paintedEntitiesCache[entity] = false
			end

			if (alpha > 0) then
				local client = entity.getNetVar(entity, "player")

				if (IsValid(client)) then
					local position = toScreen(entity.LocalToWorld(entity, entity.OBBCenter(entity)))

					hookRun("DrawEntityInfo", client, alpha, position)
				elseif (entity.onDrawEntityInfo) then
					entity.onDrawEntityInfo(entity, alpha)
				else
					hookRun("DrawEntityInfo", entity, alpha)
				end
			end

			entity.fusionAlpha = alpha

			if (alpha == 0 and goal == 0) then
				paintedEntitiesCache[entity] = nil
			end
		else
			paintedEntitiesCache[entity] = nil
		end
	end

	blurGoal = localPlayer.getLocalVar(localPlayer, "blur", 0) + (hookRun("AdjustBlurAmount", blurGoal) or 0)

	if (blurDelta != blurGoal) then
		blurDelta = mathApproach(blurDelta, blurGoal, frameTime * 20)
	end


	//self.BaseClass.PaintWorldTips(self.BaseClass)

	if (hook.Run("CanDrawAmmoHUD") != false) then
		local weapon = localPlayer.GetActiveWeapon(localPlayer)

		if (IsValid(weapon) and weapon.DrawAmmo != false) then
			local clip = weapon.Clip1(weapon)
			local count = localPlayer.GetAmmoCount(localPlayer, weapon.GetPrimaryAmmoType(weapon))
			local secondary = localPlayer.GetAmmoCount(localPlayer, weapon.GetSecondaryAmmoType(weapon))
			local x, y = scrW - 80, scrH - 80


		end
	end
	
	if (localPlayer.getLocalVar(localPlayer, "restricted") and !localPlayer.getLocalVar(localPlayer, "restrictNoMsg")) then
		Fusion.util.drawText("restricted", scrW * 0.5, scrH * 0.33, nil, 1, 1, "TargetID")
	end


end

function GM:PostDrawHUD()

end

function GM:ShouldDrawEntityInfo(entity)
	if (entity:IsPlayer() or IsValid(entity:getNetVar("player"))) then
		if (entity == LocalPlayer() and !LocalPlayer():ShouldDrawLocalPlayer()) then
			return false
		end

		return true
	end

	return false
end

function GM:DrawEntityInfo(entity, alpha, position)
	if (entity.IsPlayer(entity)) then
		local localPlayer = LocalPlayer()
		local character = entity.getChar(entity)
		
		position = position or toScreen(entity.GetPos(entity) + (entity.Crouching(entity) and OFFSET_CROUCHING or OFFSET_NORMAL))

		if (character) then
			local x, y = position.x, position.y
			local ty = 0

			charInfo = {}
			charInfo[1] = {hookRun("GetDisplayedName", entity) or character.getName(character), teamGetColor(entity.Team(entity))}

			local description = character.getDesc(character)

			if (description != entity.fusionDescCache) then
				entity.fusionDescCache = description
				entity.fusionDescLines = Fusion.util.wrapText(description, ScrW() * 0.7, "TargetID")
			end

			for i = 1, #entity.fusionDescLines do
				charInfo[#charInfo + 1] = {entity.fusionDescLines[i]}
			end

			hookRun("DrawCharInfo", entity, character, charInfo)

			for i = 1, #charInfo do
				local info = charInfo[i]
				
				_, ty = drawText(info[1], x, y, colorAlpha(info[2] or color_white, alpha), 1, 1, "TargetID")
				y = y + ty
			end
		end
	end
end

function GM:PlayerBindPress(client, bind, pressed)
	bind = bind:lower()
	
	if (bind:find("gm_showhelp") and pressed) then
		return true
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

