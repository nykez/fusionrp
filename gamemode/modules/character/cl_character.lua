
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

	local fadeSpeed = 1

	local fadeSpeed = 0

	self:Dock(FILL)

	self:MakePopup()

	self:Center()

	self:ParentToHUD()

	self.background = self:Add("DPanel")
	self.background:TDLib():Background(Color(32, 32, 32, 255))
	self.background:Dock(FILL)

	self.title = self:Add("DLabel")
	self.title:SetContentAlignment(5)
	self.title:SetPos(0, 64)
	self.title:SetSize(ScrW(), 64)
	self.title:SetFont("Fusion_Title")
	self.title:SetText(" ")
	self.title:SizeToContentsY()
	self.title:SetTextColor(color_white)
	self.title:SetZPos(400)
	self.title:SetAlpha(255)

	self.title:SetExpensiveShadow(2, Color(0, 0, 0, 200))



	self:CreateModel()
	self:CreateModels(self.panel)

	self.model = nil
	self.data = {}

end

function PANEL:TextFade()
	self.title:AlphaTo(0, 1, 3 * 1, function()

	end)
end

function PANEL:StartText(strText)
	self.title:SetAlpha(255)
	self.title:SetText(strText)

	self:TextFade()

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

	self.modelpnl:SetAlpha(0)
end


function PANEL:CreateModels(parent)
	self.panel = self:Add("DPanel")
	self.panel:SetSize(ScrW()*0.2, ScrH()*0.5)
	self.panel:SetPos(ScrW() * 0.01, ScrH()*0.1)
	self.panel:TDLib():Background(Color(45, 45, 45))

	self.gender = self.panel:Add("DButton")
	self.gender:Dock(TOP)
	self.gender:DockMargin(5, 5, 5, 5)
	self.gender:SetText("Female")
	self.gender.DoClick = function(s)
		if s:GetText() == "Female" then
			s:SetText("Male")
			self:InvalidateModels("female")
			self.data.gender = "female"
		else
			s:SetText("Female")
			self:InvalidateModels("male")
			self.data.gender = "male"
		end
	end
	self.gender:TDLib():Background(Color(35, 35, 35))
	self.gender:SetTextColor(color_white)



	self.button = {}


	//self.panel:InvalidateModels("male")

	self.next = self.panel:Add('DButton')
	self.next:Dock(BOTTOM)
	self.next:DockMargin(5, 0, 10, 5)
	self.next:SetText("Next")
	self.nextFunc =  function() CreateOptions() end
	self.next:TDLib():Background(Color(35, 35, 35)):Text("Next", "Fusion_Char_Button")
	self.next.DoClick = function()
		if not self.data.model then
			self:StartText("NO MODEL SELECTED")
			return
		end
		self.panel:SizeTo(ScrW()*0.2, 25, 0.5, 0, 10, function()
			self.next:SetVisible(false)
			self.gender:Remove()

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

function PANEL:InvalidateModels(strGender)
		if self.container then
			self.container:Remove()
		end

		local strGender = tostring(strGender)

		self.container = self.panel:Add("DIconLayout")
		self.container:Dock(FILL)


		local selected = nil

		for k,v in pairs(Fusion.config.models[strGender]) do
			self.button[k] = self.container:Add("SpawnIcon")
			self.button[k]:SetModel(v)
			self.button[k].model = v
			self.button[k]:TDLib():On('Paint', function(s)
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
				self.data.model = self.button[k].model
				self.modelpnl:SetModel(self.button[k].model)
				self.modelpnl.Entity:SetAngles(Angle(0, 40, 0))
				self.modelpnl:SetAlpha(255)
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

	    	self.data.bodygroups = ourBodygroups

		end
	end

	self.next.DoClick = function()
		self.options:Remove()
		self.panel:SizeTo(ScrW()*0.2, 25, 0.5, 0, 10, function()
			self.next:SetVisible(false)
			self.panel:SizeTo(ScrW()*0.2, ScrH()*0.17, 0.5, 0, 10, function()
				self:CreateName()
				self.next:SetVisible(true)
			end)
		end)

	end
end

function PANEL:CreateName()
	self.options = self.panel:Add("DScrollPanel")
	self.options:Dock(FILL)
	self.options:DockMargin(0, 10, 0, 0)


	self.labelName = self.options:Add("DLabel")
	self.labelName:Dock(TOP)
	self.labelName:SetText("First Name")
	self.labelName:DockMargin(5, 5, 5, 0)

	self.fname = self.options:Add("DTextEntry")
	self.fname:Dock(TOP)
	self.fname:DockMargin(5, 5, 5, 0)
	self.fname:TDLib():Background(Color(50, 50, 50)):ReadyTextbox()
    :BarHover()
    self.fname:SetTextColor(color_white)
    self.fname.OnTextChanged = function(s)
    	local txt = s:GetValue()
    	local length = string.len(txt)

    	if length < 5 then
    		self.fname:SetTextColor(Color(255, 0, 0))
    		self.data.fname = txt
    	else
    		self.fname:SetTextColor(color_white)
    		self.data.fname = txt
    	end
    end

	self.labelName = self.options:Add("DLabel")
	self.labelName:Dock(TOP)
	self.labelName:SetText("Last Name")
	self.labelName:DockMargin(5, 5, 5, 0)



	self.lname = self.options:Add("DTextEntry")
	self.lname:Dock(TOP)
	self.lname:DockMargin(5, 5, 5, 5)
	self.lname:TDLib():Background(Color(50, 50, 50)):ReadyTextbox()
    :BarHover(Color(32, 32, 32))
    self.lname:SetTextColor(color_white)
    self.lname.OnTextChanged = function(s)
    	local txt = s:GetValue()
    	local length = string.len(txt)

    	if length < 5 then
    		self.lname:SetTextColor(Color(255, 0, 0))
    		self.data.lname = txt
    	else
    		self.lname:SetTextColor(color_white)
    		self.data.lname = txt
    	end
    end

	self.next:SetText("Finish")

	self.next.DoClick = function()
		if not self.data then return end

		if !self.data.lname or !self.data.fname then
			self:StartText("NO NAME SELECTED")
			return
		end

		if self.data.lname and string.len(self.data.lname) < 5 then
			self:StartText("LAST NAME MUST BE FIVE+ CHARS")
			return
		end

		if self.data.fname and string.len(self.data.fname) < 5 then
			self:StartText("FIRST NAME MUST BE FIVE+ CHARS")
			return
		end

		net.Start("Fusion.character.create")
			net.WriteTable(self.data)
		net.SendToServer()

		self:Remove()
	end


end


function PANEL:Think()
	if input.IsKeyDown(KEY_F1) then
		self:Remove()
	end
end

vgui.Register("FusionCharMenu", PANEL, "EditablePanel")

concommand.Add("newchar", function(player)
	if fusionchar then
		fusionchar:Remove()
	end

	fusionchar = vgui.Create("FusionCharMenu")
end)

net.Receive("Fusion.new.character", function()
	if fusionchar then
		fusionchar:Remove()
	end

	fusionchar = vgui.Create("FusionCharMenu")
end)
