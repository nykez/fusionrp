surface.CreateFont("Fusion_HUDFont", {
    font = "Bebas Neue",
    size = 48,
    weight = 500,
    antialias = true
})

function hidehud(name)
	local tab = {
		"CHudHealth",
		"CHudBattery",
		"CHudCrosshair",
		"CHudAmmo",
		"CHudSecondaryAmmo",
		"CHudVoiceSelfStatus",
		"CHudVoiceStatus"
	}

	for k, v in pairs(tab) do
		if name == v then return false; end
	end

	if name == "CHudDamageIndicator" and !LocalPlayer():Alive() then
		return false
	end
end
hook.Add("HUDShouldDraw", "HideOldie", hidehud)

// Remove nasty default HUD
function GM:DrawDeathNotice(X, Y) return false; end
function GM:HUDItemPickedUp(Name) return false; end
function GM:HUDWeaponPickedUp(Name) return false; end
function GM:HUDDrawTargetID() return false; end
function GM:HUDAmmoPickedUp(Name) return false; end
function GM:HUDDrawPickupHistory() return false; end

local avatar

local over = Material("gui/vignette.png")
local function DrawHUD()
    //surface.SetDrawColor(255, 255, 255, 255)
    //surface.SetMaterial(over)
    //surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
end
hook.Add("HUDPaint", "Fusion.PaintHUD", DrawHUD)

local function DoorHUD()
	local trace = LocalPlayer():GetEyeTrace()

	if IsValid(trace.Entity) and trace.Entity:IsDoor() then
		local pos = trace.Entity:GetPos()
		local name = nil
		local id = nil
		local isValidDoor = false

        local cache = Fusion.property.cache

		for k, v in pairs(cache) do
			for _, dPos in pairs(v.doors) do
				if dPos == pos and !v.government then
					name = v.name
					id = v.id
					isValidDoor = true
				end
			end
		end

		if isValidDoor == true then
			local x = trace.Entity:LocalToWorld(trace.Entity:OBBCenter()):ToScreen().x
			local y = trace.Entity:LocalToWorld(trace.Entity:OBBCenter()):ToScreen().y

			local dist = LocalPlayer():GetPos():Distance(pos)
			local distM = dist / 40

			draw.SimpleTextOutlined(name, "Fusion_HUDFont", x, y, Color(179, 124, 255, (255 - distM * 12.75)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(20, 20, 20, (255 - distM * 12.75)))

			local ownText = "For Rent"
            local owners = Fusion.property.owners

			if owners[id] == nil then
				ownText = "For Rent"
			elseif (IsValid(owners[id]) and owners[id]:IsPlayer()) then
				if LocalPlayer():HasProperty(id) then
					ownText = "Rented by You"
				else
					ownText = "Rented"
				end
			else
				ownText = "Unknown"
			end

            if ownText == "For Rent" then
               draw.SimpleTextOutlined("Hold 'E' for more options", "Fusion_HUDFont", x, y + 30, Color(255, 251, 98, (255 - distM * 12.75)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(20, 20, 20, (255 - distM * 12.75)))
                if LocalPlayer():KeyDown(IN_USE) then
                   if inContext then return end
                    inContext = vgui.Create("FusionContext")
                elseif LocalPlayer():KeyReleased(IN_USE) then
                    if (inContext) then
                        inContext:Remove()
                        inContext = nil
                        print("context closed")
                    end
                    //
               end
            else
                draw.SimpleTextOutlined(ownText, "Fusion_HUDFont", x, y + 30, Color(255, 251, 98, (255 - distM * 12.75)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(20, 20, 20, (255 - distM * 12.75)))
            end

		end
	end
end
hook.Add("HUDPaint", "Fusion.PaintDoor", DoorHUD)
