<<<<<<< HEAD
local no = "no"
=======
function PLAYER:GetXP()
    if !IsValid(self) then return end

    return self:GetNW2Int("xp", 0)
end

function PLAYER:GetLevel()
    if !IsValid(self) then return end

    return self:GetNW2Int("level", 1)
end
>>>>>>> 4f3ab2c00b67aed2243d81aa77bbe60f2d8cad60
