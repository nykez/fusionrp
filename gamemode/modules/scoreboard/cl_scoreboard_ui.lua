Fusion.scoreboard = Fusion.scoreboard or {}

surface.CreateFont("Fusion_Scoreboard_Title", {
    font = "Bebas Neue",
    size = ScreenScale(32),
    weight = 500,
    antialias = true
})

surface.CreateFont("Fusion_Scoreboard_Name", {
    font = "Bebas Neue",
    size = 48,
    weight = 500,
    antialias = true
})

local PANEL = {}

function PANEL:Init()
    self:SetSize(ScrW(), ScrH())
    self:Center()
    self:ParentToHUD()

    self.panel = self:Add("DPanel")
    self.panel:SetSize(ScrW() * 0.5, ScrH() * 0.5)
    self.panel:SetPos(-self.panel:GetWide(), ScrH() / 2 - self.panel:GetTall() / 2)
    self.panel:TDLib():Background(Color(24, 24, 24)):Gradient(Color(38, 38, 38))

    self.list = self.panel:Add("DScrollPanel")
    self.list:Dock(FILL)
    self.list:DockMargin(6, 6, 6, 6)
    self.list:TDLib():HideVBar()

    self:Populate()

    self.panel:MoveTo(ScrW() / 2 - self.panel:GetWide() / 2, ScrH() / 2 - self.panel:GetTall() / 2, 0.4, 0, 0.2, function() end)
end

function PANEL:Populate()
    self.rows = {}

    for k, v in pairs(player.GetAll()) do
        self.rows[k] = self.list:Add("DPanel")
        self.rows[k]:SetWide(self.list:GetWide())
        self.rows[k]:SetTall(60)
        self.rows[k]:Dock(TOP)
        self.rows[k]:DockMargin(0, 4, 0, 0)
        self.rows[k]:TDLib():Background(Color(14, 14, 14)):FadeHover(Color(20, 20, 20))

        local icon = self.rows[k]:Add("DPanel")
        icon:Dock(LEFT)
        icon:SetSize(46, 46)
        icon:DockMargin(10, 4, 4, 4)
        icon:TDLib():CircleAvatar():SetPlayer(v, 46)

        local name = self.rows[k]:Add("DLabel")
        name:Dock(LEFT)
        name:DockMargin(10, 4, 4, 4)
        name:SetText(v:Nick())
        name:SetFont("Fusion_Scoreboard_Name")
        name:SetTextColor(color_white)
    end
end

vgui.Register("FusionScoreboard", PANEL, "EditablePanel")

function GM:ScoreboardShow()
    if Fusion.scoreboard.panel then
        Fusion.scoreboard.panel:Remove()
        Fusion.scoreboard.panel = nil
    end

    Fusion.scoreboard.panel = vgui.Create("FusionScoreboard")
end

function GM:ScoreboardHide()
    if Fusion.scoreboard.panel then
        Fusion.scoreboard.panel:Remove()
        Fusion.scoreboard.panel = nil
    end
end
