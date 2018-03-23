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
function DrawHUD()
	if Fusion.property.panel then
        avatar:SetVisible(false)
        return
    end

    local bg = {}
    bg.w = 400
    bg.h = 200
    bg.x = ScrW() - bg.w - 10
    bg.y = ScrH() - bg.h - 10

    surface.SetDrawColor(30, 30, 30)
    surface.DrawRect(bg.x, bg.y, bg.w, bg.h)

    local rect = {}
    rect.w = 390
    rect.h = bg.h - 60
    rect.x = bg.x + 5
    rect.y = bg.y + 60 - 5

    surface.SetDrawColor(24, 24, 24)
    surface.DrawRect(rect.x, rect.y, rect.w, rect.h)

    if IsValid(LocalPlayer()) and !IsValid(avatar) then
        avatar = vgui.Create("DPanel")
        avatar:SetSize(48, 48)
        avatar:SetPos(bg.x + 5, bg.y + 5)
        avatar:TDLib():CircleAvatar():SetPlayer(LocalPlayer(), 45)
    end

    draw.SimpleText(LocalPlayer():GetRPName(), "Fusion_HUDFont", bg.x + bg.w - 10, bg.y + 4, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

    local hp = {}
    hp.w = rect.w - 10
    hp.h = (rect.h / 3) - 5
    hp.x = rect.x + 5
    hp.y = rect.y + 5

    surface.SetDrawColor(140, 25, 25)
    surface.DrawRect(hp.x, hp.y, hp.w, hp.h)

    local stam = {}
    stam.w = rect.w - 10
    stam.h = (rect.h / 3) - 5
    stam.x = rect.x + 5
    stam.y = hp.y + hp.h + 5

    surface.SetDrawColor(40, 180, 40)
    surface.DrawRect(stam.x, stam.y, stam.w, stam.h)

    local money = {}
    money.w = rect.w / 2 - 5
    money.h = (rect.h / 3) - 10
    money.x = rect.x + rect.w / 2
    money.y = stam.y + stam.h + 5

    draw.RoundedBox(6, money.x, money.y, money.w, money.h, Color(16, 16, 16))

    local ammo = {}
    ammo.w = rect.w / 2 - 10
    ammo.h = (rect.h / 3) - 10
    ammo.x = rect.x + 5
    ammo.y = stam.y + stam.h + 5

    draw.RoundedBox(6, ammo.x, ammo.y, ammo.w, ammo.h, Color(16, 16, 16))

    -- surface.SetDrawColor(255, 255, 255, 255)
    -- surface.SetMaterial(over)
    -- surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
end
hook.Add("HUDPaint", "Fusion.HUDPaint", DrawHUD)
