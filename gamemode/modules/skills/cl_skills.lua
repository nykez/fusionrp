
local PANEL = {}

surface.CreateFont("Fusion_Skills", {
    font = "GeosansLight",
    size = ScreenScale(6),
    weight = 400,
    antialias = true
})

surface.CreateFont("Fusion_Skills2", {
    font = "GeosansLight",
    size = ScreenScale(10),
    weight = 400,
    antialias = true
})

function PANEL:Init()

	self:SetWide(ScrW() * 0.55)
	self:SetTall(ScrH() * 0.7)
	self:Center()
	self:MakePopup()

	self:TDLib():Background(Color(35, 35, 35)):Outline(Color(0, 0, 0))

	self.navbar = self:Add("DPanel")
	self.navbar:Dock(TOP)
	self.navbar:SetTall(self:GetTall() * 0.1)
	self.navbar:TDLib():Background(Color(26, 26, 26)):Gradient(Color(30, 30, 30))
	self.navbar:Text("Your Skills")

	-- self.exit = self:Add("DButton")
	-- self.exit:SetSize(32, 32)
	-- self.exit:SetPos(self:GetWide() - 38, 2)
	-- self.exit:SetText('X')
	-- self.exit:TDLib():Background(Color(231, 76, 60)):FadeHover()
	-- self.exit:SetTextColor(color_white)
	-- self.exit:On('DoClick', function()
	-- 	self:Remove()
	-- end)

	self.container = self:Add("DScrollPanel")
	self.container:Dock(FILL)

	local ourCats = Fusion.skills.cats

   local catlbl = {}

   for k,v in SortedPairs(ourCats) do
      local data = Fusion.skills:GetCat(k)

      local valueMax = 0 
      local currentValue = 0

      local clr = Color(math.random(0, 255), math.random(0, 255), math.random(0, 255))
      if !catlbl[k] then
         catlbl[k] = self.container:Add("FusionProgressBar")
         local pnl = catlbl[k]
         pnl:Dock(TOP)
         pnl:SetTall(40)
         pnl:DockMargin(6, 5, 6, 0)
        // pnl:TDLib():Background(Color(40, 40, 40)):Outline(Color(50, 50, 50))
         //:Text(k, "Fusion_Skills2", color_white)
        // :SideBlock(clr)

         // New bar //
         pnl:TDLib():Text(k, "Fusion_Skills2", color_white)
         pnl:SetColor(clr)
      end

      for i, skills in pairs(data) do

         local char = LocalPlayer():getChar()
         local max = char:GetRequiredXP(i)
         valueMax = valueMax + max
         currentValue = currentValue + char:GetSkillXP(i)
         local skill = self.container:Add("FusionProgressBar")
         skill:Dock(TOP)
         skill:SetTall(50)
         skill:DockMargin(5, 5, 5, 0)
         skill:SetMax(max)
         skill:SetValue(char:GetSkillXP(i))
         skill:TDLib():Outline(Color(25, 25, 25))



         local label = skill:Add("DLabel")
         label:SetText(i)
         label:Dock(LEFT)
         label:DockMargin(5, 0, 0, 0)
         label:SetFont("Fusion_Dealer_Button")

         label:SizeToContents()

         local level = skill:Add("DLabel")
         level:SetText(char:GetSkillLevel(i))
         level:Dock(LEFT)
         level:DockMargin(0, 0, 0, 0)
         level:SetFont("Fusion_Skills")
         
      end
      catlbl[k]:SetMax(valueMax)
      catlbl[k]:SetValue(currentValue)
   end
end

vgui.Register("FusionSkills", PANEL, "EditablePanel")


-- Version of DProgressBar I can mess around with

local PANEL = {}

AccessorFunc( PANEL, "m_iMin",  "Min" )
AccessorFunc( PANEL, "m_iMax",  "Max" )
AccessorFunc( PANEL, "m_iValue",    "Value" )
AccessorFunc( PANEL, "m_Color",     "Color" )

function PANEL:Init()
   self.Label = vgui.Create( "DLabel", self )
   self.Label:SetFont( "DefaultSmall" )
   self.Label:SetColor( Color(255, 255, 255 ) )
   
   self:SetMin( 0 )
   self:SetMax( 1000 )
   self:SetValue( 253 )
   self:SetColor( Color( 32, 32, 32, 255 ) )
end

function PANEL:LabelAsPercentage()
   self.m_bLabelAsPercentage = true
   self:UpdateText()
end

function PANEL:SetMin( i )
   self.m_iMin = i
   self:UpdateText()
end

function PANEL:SetMax( i )
   self.m_iMax = i
   self:UpdateText()
end

function PANEL:SetValue( i )
   self.m_iValue = i
   self:UpdateText()
end

function PANEL:UpdateText()
   if ( !self.m_iMax ) then return end
   if ( !self.m_iMin ) then return end
   if ( !self.m_iValue ) then return end
   
   local fDelta = 0;
   
   if ( self.m_iMax-self.m_iMin != 0 ) then
      fDelta = ( self.m_iValue - self.m_iMin ) / (self.m_iMax-self.m_iMin)
   end
   
   if ( self.m_bLabelAsPercentage ) then
      self.Label:SetText( Format( "%.2f%%", fDelta * 100 ) )
      return
   end
   
   if ( self.m_iMin == 0 ) then
      
      self.Label:SetText( Format( "%i / %i", self.m_iValue, self.m_iMax ) )
      
   else
   end
end

function PANEL:PerformLayout()
   self.Label:SizeToContents()
   self.Label:AlignRight( 5 )
   self.Label:CenterVertical()
end

function PANEL:Paint()

   local fDelta = 0;
   
   if ( self.m_iMax-self.m_iMin != 0 ) then
      fDelta = ( self.m_iValue - self.m_iMin ) / (self.m_iMax-self.m_iMin)
   end
   
   local Width = self:GetWide()

   surface.SetDrawColor( 50, 50, 50, 170 )
   surface.DrawRect( 0, 0, Width, self:GetTall() )
   
   surface.SetDrawColor( self.m_Color.r, self.m_Color.g, self.m_Color.b, self.m_Color.a * 0.5 )
   surface.DrawRect( 2, 2, Width - 4, self:GetTall() - 4 )
   surface.SetDrawColor( self.m_Color.r, self.m_Color.g, self.m_Color.b, self.m_Color.a )
   surface.DrawRect( 2, 2, Width * fDelta - 4, self:GetTall() - 4 )

end

vgui.Register( "FusionProgressBar", PANEL, "DPanel" )