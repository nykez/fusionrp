local PANEL = {}

surface.CreateFont("Fusion_Dialog_Title", {
    font = "Bebas Neue",
    size = ScreenScale(14),
    weight = 500,
    antialias = true
})

surface.CreateFont("Fusion_Dialog_Button", {
    font = "GeosansLight",
    size = ScreenScale(5),
    weight = 400,
    antialias = true
})

function PANEL:Init()
    self:SetSize(ScrW(), ScrH())
    self:TDLib():ClearPaint():Background(Color(35, 35, 35, 0)):Blur(10)
    self:MakePopup()
    self:ParentToHUD()

    self.buttons = {}

    self.title = self:Add("DPanel")
    self.title:TDLib():ClearPaint()
    self.title:Background(Color(20, 20, 20))
    self.title:SetSize(ScrW(), ScrH() * .048)

    self.options = self:Add("DPanel")
    self.options:TDLib():ClearPaint():Background(Color(30, 30, 30))
    self.options:SetSize(ScrW() * 0.3, ScrW() * 0.12)
    self.options:SetPos(ScrW() / 2 - (self.options:GetWide() / 2), ScrH() - self.options:GetTall() - 10)

    self.scroll = self.options:Add("DScrollPanel")
    self.scroll:TDLib():ClearPaint():HideVBar():Background(Color(20, 20, 20))
    self.scroll:DockMargin(5, 5, 5, 5)
    self.scroll:Dock(FILL)

    print(LocalPlayer():GetModel())

    
    self.leftModel = self:Add("DModelPanel")
    self.leftModel:SetSize(self:GetWide() * 0.33, self:GetTall() * 0.6)
    self.leftModel:SetPos(0, self:GetTall() - self.leftModel:GetTall())
    self.leftModel:SetModel(LocalPlayer():GetModel())
    local mn, mx = self.leftModel.Entity:GetRenderBounds()
    local size = 0
    size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
	size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
	size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

    function self.leftModel.LayoutEntity(ent)
        self.leftModel.Entity:ResetSequence(self.leftModel.Entity:LookupSequence("pose_standing_02"))
        self.leftModel:RunAnimation()
    end

    self.leftModel.Entity:SetAngles(Angle(-5, 90, 0))
    self.leftModel:SetFOV(20)
    self.leftModel:SetCamPos(Vector(size, size, size))
    self.leftModel:SetLookAt(( mn + mx ) * 0.8)

    local char = LocalPlayer():getChar()
    if char then

	    self.leftModel.Entity:SetSkin(char:getData('skin', 0))

	    for k,v in pairs(char:getData("bodygroups")) do
	    	self.leftModel.Entity:SetBodygroup(k, v)
	    	self.leftModel:SetBodygroup(k, v)
	    end
	end

    self.rightModel = self:Add("DModelPanel")
    self.rightModel:SetSize(self:GetWide() * 0.33, self:GetTall() * 0.6)
    self.rightModel:SetPos(self:GetWide() - self.rightModel:GetWide(), self:GetTall() - self.rightModel:GetTall())
    self.rightModel:SetModel("models/player/breen.mdl")
    local mn, mx = self.rightModel.Entity:GetRenderBounds()
    local size = 0
    size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
    size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
    size = math.max(size, math.abs(mn.z) + math.abs(mx.z))

    function self.rightModel.LayoutEntity(ent)
        self.rightModel.Entity:ResetSequence(self.rightModel.Entity:LookupSequence("pose_standing_02"))
        self.rightModel:RunAnimation()
    end

    self.rightModel.Entity:SetAngles(Angle(-5, 0, 0))
    self.rightModel:SetFOV(20)
    self.rightModel:SetCamPos(Vector(size, size, size))
    self.rightModel:SetLookAt((mn + mx) * 0.8)
end

function PANEL:SetTitle(str)
    if IsValid(self.title) then
        self.title:Text(str, "Fusion_Dialog_Title", Color(255, 255, 255), TEXT_ALIGN_CENTER)
    end
end

function PANEL:AddButton(strText, func)
    self.buttons[strText] = self.scroll:Add("DButton")
    self.buttons[strText]:SetText(strText)
    self.buttons[strText]:SetFont("Fusion_Dialog_Button")
    self.buttons[strText]:Dock(TOP)
    self.buttons[strText]:DockMargin(5, 4, 5, 0)
    self.buttons[strText]:SetTall(ScrH() * .024)
    self.buttons[strText]:TDLib():ClearPaint():Background(Color(30, 30, 30)):BarHover(Color(64, 160, 255, 255))
    self.buttons[strText]:SetTextColor(color_white)
    self.buttons[strText]:On("DoClick", function(s)
        self:ClearCanvas()
        func()
    end)
end

function PANEL:ClearCanvas()
    for k, v in pairs(self.buttons) do
        if IsValid(v) then v:Remove() end
    end

    self.buttons = {}
end

function PANEL:Think()
	if input.IsKeyDown(KEY_F1) then
		self:Hide()
	end
end

function PANEL:Show( )
	self:SetVisible(true)
	self:MakePopup()
    self:FadeIn(0.2)
end


function PANEL:Hide()
	self:SetVisible(false)
	self:ClearCanvas()
end

vgui.Register("FusionDialog", PANEL, "EditablePanel")
