MoonlightDestinyUI = MoonlightDestinyUI or {}
MoonlightDestinyUI.vars = {}

function MoonlightDestinyUI.onUnload(arg_1_0)
	if MoonlightDestiny:isSelect() then
		MoonlightDestinyQuest:onUnload()
	else
		MoonlightDestinyHero:onUnload()
	end
end

function MoonlightDestinyUI.open(arg_2_0, arg_2_1)
	if MoonlightDestiny:isSelect() then
		MoonlightDestinyQuest:open(arg_2_1)
	else
		MoonlightDestinyHero:open(arg_2_1)
	end
end

function MoonlightDestinyUI.getSceneState(arg_3_0)
	if MoonlightDestiny:isSelect() then
		return MoonlightDestinyQuest:getSceneState()
	end
	
	return MoonlightDestinyHero:getSceneState()
end
