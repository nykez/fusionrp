
local PANEL = {}

surface.CreateFont( "Fusion_Title", {
	font = "Bebas Neue", 
	extended = true,
	size = 100,
	weight = 0,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "Fusion_Char_Button", {
	font = "Bebas Neue", 
	extended = false,
	size = 24,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

function PANEL:Init()

	local fadeSpeed = 0

	self:Dock(FILL)

	self:MakePopup()

	self:Center()

	self:ParentToHUD()

	self.background = self:Add("DPanel")
	self.background:TDLib():Background(Color(32, 32, 32, 255))
	self.background:Dock(FILL)


	
	self:CreateModel()
	self:CreateModels(self.panel)

	self.model = nil
	self.data = {}

end



function PANEL:CreateModel()
	self.modelpnl = self:Add("DModelPanel")
	self.modelpnl:Dock(FILL)
	self.modelpnl:SetModel("models/player/gman_high.mdl")
	//self.modelpnl:SetAlpha(0)
	local mn, mx = self.modelpnl.Entity:GetRenderBounds()
	local size = 0
	size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
	size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
	size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

	function self.modelpnl.LayoutEntity( ent )
		self.modelpnl.Entity:SetSequence( "idle_all_02" )
		self.modelpnl:RunAnimation()
		return
	end

	self.modelpnl.Entity:SetAngles(Angle(0, 40, 0))
	self.modelpnl:SetFOV( 70 )
	self.modelpnl:SetCamPos( Vector( size, size, size ) )
	self.modelpnl:SetLookAt( ( mn + mx ) * 0.5 )

end


local tbl = {
	"models/player/zelpa/male_01_extended.mdl",
	"models/player/zelpa/male_02_extended.mdl",
	"models/player/zelpa/male_03_extended.mdl",
	"models/player/zelpa/male_04_extended.mdl",
	"models/player/zelpa/male_06_extended.mdl",
	"models/player/zelpa/male_08_extended.mdl",
	"models/player/zelpa/male_09_extended.mdl",
	"models/player/zelpa/male_10_extended.mdl",
}

function PANEL:CreateModels(parent)
	self.panel = self:Add("DPanel")
	self.panel:SetSize(ScrW()*0.2, ScrH()*0.5)
	self.panel:SetPos(ScrW() * 0.01, ScrH()*0.1)
	self.panel:TDLib():Background(Color(45, 45, 45))

	self.container = self.panel:Add("DIconLayout")
	self.container:Dock(FILL)

	self.button = {}
	local selected = nil
	for k,v in pairs(tbl) do
		self.button[k] = self.container:Add("SpawnIcon")
		self.button[k]:SetModel(v)
		self.button[k].model = v
		self.button[k]:On('Paint', function(s)
			if selected == s then
				surface.SetDrawColor(Color(20, 20, 20))
				surface.DrawRect(0, 0, s:GetWide(), s:GetTall())
			end
		end)
		self.button[k]:On('DoClick', function(s)
			if self.model == self.button[k].model then
				return
			end
			selected = s
			self.model = self.button[k].model
			self.modelpnl:SetModel(self.button[k].model)
			self.modelpnl.Entity:SetAngles(Angle(0, 40, 0))
		end)
	end

	self.next = self.panel:Add('DButton')
	self.next:Dock(BOTTOM)
	self.next:DockMargin(5, 0, 10, 5)
	self.next:SetText("Next")
	self.nextFunc =  function() CreateOptions() end
	self.next:TDLib():Background(Color(35, 35, 35)):Text("Next", "Fusion_Char_Button")
	self.next.DoClick = function()
		self.panel:SizeTo(ScrW()*0.2, 25, 0.5, 0, 10, function()
			self.next:SetVisible(false)

			for k,v in pairs(self.button) do
				v:Remove()
			end

			self.container:Remove()

			self.panel:SizeTo(ScrW()*0.2, ScrH()*0.5, 0.5, 0, 10, function()
				self.next:SetVisible(true)
				self:CreateOptions()
			end)
		end)

	end

end

function PANEL:CreateOptions()
	self.options = self.panel:Add("DScrollPanel")
	self.options:Dock(FILL)
	self.options:DockMargin(0, 10, 0, 0)

	local bodygroups = self.modelpnl.Entity:GetBodyGroups()

	self.bodygroup_btn = {}

	for k, v in pairs(bodygroups) do
		if ( v.num <= 1 ) then continue end

		self.bodygroup_btn[k] = self.options:Add("DComboBox")
		local pnl = self.bodygroup_btn[k]
		pnl:Dock(TOP)
		pnl:DockMargin(10, 5, 10, 0)
		pnl:SetValue(v.name)
		pnl:AddChoice("Default");
		pnl.Bodygroup = v.id
		for a, b in pairs (v.submodels) do			
			pnl:AddChoice(b);
		end
		pnl.OnSelect = function(panel, index, value)
			pnl.SelectedLine = index-2

			local ourBodygroups = {}

	    	for k,v in pairs(self.bodygroup_btn) do
	    		if (!v.SelectedLine || !v.Bodygroup) then continue; end

	    		ourBodygroups[v.Bodygroup] = v.SelectedLine
	    	end

	    	print('--bodygroups--')
	    	PrintTable(ourBodygroups)
	    	for k,v in pairs(ourBodygroups) do
	    		self.modelpnl.Entity:SetBodygroup(k, v)
	    	end

	    	self.data.bodygroups = {
	    		ourBodygroups
	    	}
		end
	end

	self.skinsel = self.options:Add("DNumSlider")
	self.skinsel:Dock(TOP)
	self.skinsel:SetDecimals(0)
	self.skinsel:SetMin(0)
	self.skinsel:SetMax(self.modelpnl.Entity:SkinCount())
	self.skinsel:DockMargin(5, 10, 5, 0)
	self.skinsel:SetText("Skin")
	function self.skinsel.OnValueChanged()
		self.modelpnl:SetSkin(self.skinsel:GetValue())
		self.modelpnl.Entity:SetSkin(self.skinsel:GetValue())
		self.data.skin = self.skinsel:GetValue()
	end


	self.next.DoClick = function()
		self.options:Remove()
	end
end



function PANEL:Think()
	if input.IsKeyDown(KEY_F1) then
		self:Remove()
	end
end

vgui.Register("FusionCharMenu", PANEL, "EditablePanel")

concommand.Add("char", function()
	if fusionchar then
		fusionchar:Remove()
	end

	fusionchar = vgui.Create("FusionCharMenu")

end)



