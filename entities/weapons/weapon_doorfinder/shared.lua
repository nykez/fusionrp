AddCSLuaFile()

SWEP.Author = "Reek"
SWEP.Base = "weapon_base"
SWEP.PrintName = "Door Tool"
SWEP.Instructions = "Left Click: Add door to list; Right Click: Print code (resets list); R: Reset list"

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.SetHoldType = "melee"

SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Ammo = "none"

if !SERVER then return end

function SWEP:Initialize()
    self.Doors = self.Doors or {}
end

function SWEP:PrimaryAttack()
    local ply = self.Owner
    local trace = ply:GetEyeTrace().Entity

    if !IsValid(ply) or !IsValid(trace) then return end

    if trace:GetClass() == "prop_door_rotating" or trace:GetClass() == "func_door" or trace:GetClass() == "func_door_rotating" then
        table.insert(self.Doors, trace)
    else
        self.Owner:Notify("That is not a door!")
    end
end

function SWEP:SecondaryAttack()
    self.Doors = self.Doors or {}

    self.Owner:ChatPrint("\nproperty.doors = {")
    for k, v in pairs(self.Doors) do
        if !IsValid(v) then continue end
        self.Owner:ChatPrint("\tVector(" .. v:GetPos().x .. ", " .. v:GetPos().y .. ", " .. v:GetPos().z .. "),")
    end
    self.Owner:ChatPrint("}")

    self.Doors = {}
end

function SWEP:Reload()
    self.Doors = {}
end
