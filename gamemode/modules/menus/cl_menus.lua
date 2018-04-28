Fusion.menus = Fusion.menus or {}
Fusion.menus.cache = Fusion.menus.cache or {}

function Fusion.menus:Create(str)
    if IsValid(self.cache[str]) then return end

    local panel = vgui.Create(str)
    if !IsValid(panel) then return end

    self.cache[str] = panel

    return panel
end

function Fusion.menus:Get(str)
    if !IsValid(self.cache[str]) then
        LocalPlayer():ChatPrint("No menu '" .. str .. "' currently open.")
        return
    end

    return self.cache[str]
end

function Fusion.menus:Remove(str)
    if !IsValid(self.cache[str]) then return end
    self.cache[str]:Remove()
    self.cache[str] = nil

    gui.EnableScreenClicker(false)
end
