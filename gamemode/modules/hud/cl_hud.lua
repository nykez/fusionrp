surface.CreateFont("Fusion_HUDFont", {
    font = "Bebas Neue",
    size = 32,
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

function DrawHUD()
	if property then return end 
	
    surface.SetDrawColor(0, 0, 0, 150)
    surface.DrawRect(0, ScrH() - 60, ScrW(), 60)

    draw.SimpleText("Money: " .. LocalPlayer():GetWallet(), "Fusion_HUDFont", 10, ScrH() - 60 / 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    draw.SimpleText("Bank: " .. LocalPlayer():GetBank(), "Fusion_HUDFont", 130, ScrH() - 60 / 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    draw.SimpleText("RP Name: " .. LocalPlayer():GetRPName(), "Fusion_HUDFont", 290, ScrH() - 60 / 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    draw.SimpleText("Level: " .. LocalPlayer():GetLevel(), "Fusion_HUDFont", 490, ScrH() - 60 / 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    draw.SimpleText("Account Lvl: " .. LocalPlayer():GetAccountLevel(), "Fusion_HUDFont", 590, ScrH() - 60 / 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end
hook.Add("HUDPaint", "Fusion.HUDPaint", DrawHUD)
