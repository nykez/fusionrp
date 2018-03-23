Fusion.scoreboard = Fusion.scoreboard or {}

surface.CreateFont("Fusion_Scoreboard_Title", {
    font = "Bebas Neue",
    size = 70,
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
    self:SetZPos(400)
    self:SetMouseInputEnabled(true)

    self.panel = self:Add("DPanel")
    self.panel:SetSize(ScrW() * 0.5, ScrH() * 0.5)
    self.panel:SetPos(-self.panel:GetWide(), ScrH() / 2 - self.panel:GetTall() / 2)
    self.panel:TDLib():Background(Color(30, 30, 30)):Gradient(Color(38, 38, 38))

    self.title = self.panel:Add("DLabel")
    self.title:SetFont("Fusion_Scoreboard_Title")
    self.title:SetTextColor(color_white)
    self.title:SetText("Fusion Roleplay")
    self.title:Dock(TOP)
    self.title:DockMargin(0, 0, 0, 0)
    self.title:SizeToContents()
    self.title:Center()
    self.title:SetContentAlignment(2)

    self.sub_panel = self.panel:Add("DPanel")
    self.sub_panel:Dock(FILL)
    self.sub_panel:DockMargin(5, 5, 5, 5)
    self.sub_panel:TDLib():Background(Color(25, 25, 25))

    self.list = self.sub_panel:Add("DScrollPanel")
    self.list:Dock(FILL)
    self.list:DockMargin(8, 6, 8, 6)
    self.list:TDLib():HideVBar()

    self:Populate()

    self.panel:MoveTo(ScrW() / 2 - self.panel:GetWide() / 2, ScrH() / 2 - self.panel:GetTall() / 2, 0.4, 0, 0.2, function() end)
end

function PANEL:Populate()
    self.rows = {}
    self.players = player.GetAll()

	table.sort(self.players, function(a, b)
		return a:GetAccountLevel() > b:GetAccountLevel()
	end)

    for k, v in pairs(self.players) do
        self.rows[k] = self.list:Add("DPanel")
        self.rows[k]:SetWide(self.list:GetWide())
        self.rows[k]:SetTall(60)
        self.rows[k]:Dock(TOP)
        self.rows[k]:DockMargin(0, 4, 0, 0)
        self.rows[k]:TDLib():Background(Color(30, 30, 30))
        self.rows[k].player = v
        self.rows[k]:On("Think", function(s)
            if s.player == LocalPlayer() then
                s:Background(Color(36, 36, 36))
            end

            if s.player:IsStaff() then
                s:SideBlock(s.player:GetRankColor(), 4)
            end
        end)
        self.rows[k]:On("OnCursorEntered", function(s)
            s:SizeTo(-1, 75, 0.2, 0, 0.4, function() end)
            s:Background(Color(36, 36, 36))
        end)
        self.rows[k]:On("OnCursorExited", function(s)
            s:SizeTo(-1, 60, 0.2, 0, 0.4, function() end)
            s:Background(Color(30, 30, 30))
        end)

        local icon = self.rows[k]:Add("DPanel")
        icon:Dock(LEFT)
        icon:SetSize(46, 46)
        icon:DockMargin(14, 4, 4, 4)
        icon:TDLib():CircleAvatar():SetPlayer(v, 46)

        surface.SetFont("Fusion_Scoreboard_Name")
        local nX, nY = surface.GetTextSize(v:Nick())

        local name = self.rows[k]:Add("DLabel")
        name:Dock(LEFT)
        name:DockMargin(10, 4, 4, 4)
        name:SetWide(nX)
        name:SetText(v:Nick())
        name:SetFont("Fusion_Scoreboard_Name")
        name:SetTextColor(color_white)
    end
end

function PANEL:Clear()
    for k, v in pairs(self.rows) do
        v:Remove()
    end
end

function PANEL:Think()
    for k, v in pairs(self.rows) do
        if !IsValid(v.player) then
            self:Clear()
            self:Populate()
        end
    end

    if #self.rows != #player.GetAll() then
        self:Clear()
        self:Populate()
    end

    if input.IsMouseDown(MOUSE_RIGHT) then
        gui.EnableScreenClicker(true)
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
        gui.EnableScreenClicker(false)
    end
end
