
Fusion.gui = Fusion.gui or {}

local PANEL = {}


function PANEL:Init()
	print("opening character menu")
	self:SetWide(ScrW())
	self:SetTall(ScrH())

	self:MakePopup()

	//self:TDLib():FadeIn():Background(Color(30, 30, 30, 255)):Gradient(Color(26, 26, 26))

	self.characters = self:Add("DScrollPanel")
	self.characters:Dock(LEFT)
	self.characters:SetWide(self:GetWide() * 0.2)
	-- self.characters:DockMargin(5, 5, 5, 0)
	self.characters:TDLib():FadeIn():Background(Color(30, 30, 30, 255)):Gradient(Color(26, 26, 26)):Outline(Color(64, 64, 64))

	self:BuildCharacters()

	local createnew = self.characters:Add('DButton')
	createnew:Dock(TOP)
	createnew:DockMargin(2, 30, 2, 0)
	createnew:TDLib():Background(Color(46, 204, 113)):Text("Create Character", "TargetID", color_white)
	createnew:On('DoClick', function()
		self:Remove()
		vgui.Create("FusionCharMenu")
	end)

	self.docker = self:Add("DPanel")
	self.docker:Dock(FILL)
	self.docker:TDLib():FadeIn():Background(Color(35, 35, 35)):Gradient(Color(30, 30, 30))

	self.info = self.docker:Add("DPanel")
	self.info:SetSize(self:GetWide()*0.3, self:GetTall()*0.3)
	self.info:SetPos(self:GetWide()*0.2, self:GetTall()*0.1)
	self.info.Paint = function() end

	self.name = self.info:Add("DLabel")
	self.name:SetText("")
	self.name:SetTall(40)
end

function PANEL:BuildCharacters()
	if not Fusion.characters then return end 

	for k,v in pairs(Fusion.characters) do
		local character = Fusion.character.loaded[v]
		
		if (character) then
			local char = self.characters:Add('DButton')
			char:Dock(TOP)
			char:DockMargin(5, 5, 5, 0)
			char:SetTall(40)
			char:SetText(character:getName())

			char:TDLib():Background(Color(50, 50, 50)):Outline(Color(64, 64, 64)):FadeHover()
			:Text(character:getName(), "TargetID", color_white)
			char.DoClick = function()
				Derma_Query("Are you sure you want to load this character?","Character Selection", 'Yes',
					function()
						netstream.Start("fusion_spawnChar", v)
						self:Remove()
					end,
					"No"
				)
			end
		end
	end

end

function PANEL:Think()
	if input.IsKeyDown(KEY_F2) then
		self:Remove()
		Fusion.gui.main = nil
	end
end

vgui.Register("CharacterMainMenu", PANEL, "EditablePanel")

concommand.Add("main", function()
	Fusion.gui.main = vgui.Create("CharacterMainMenu")
end)