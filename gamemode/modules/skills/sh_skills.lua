
Fusion.skills = Fusion.skills or {}
Fusion.skills.list = Fusion.skills.list or {}

function Fusion.skills:Register(tblSkill)
	Fusion.skills.list[tblSkill.id] = tblSkill
end

function Fusion.skills:Load()

end