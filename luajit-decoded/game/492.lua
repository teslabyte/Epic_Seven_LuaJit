SanctuarySubTask = {}
SanctuaryMain.MODE_LIST.SubTask = SanctuarySubTask

function SanctuarySubTask.onEnter(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.vars = {}
	arg_1_0.vars.wnd = SubTask:show(arg_1_1)
	
	SoundEngine:play("event:/ui/sanctuary/enter_subtask")
end

function SanctuarySubTask.onLeave(arg_2_0, arg_2_1)
	TopBarNew:setCurrencies({
		"crystal",
		"gold",
		"stone"
	})
	arg_2_0.vars.wnd:removeFromParent()
	
	arg_2_0.vars = nil
end

function SanctuarySubTask.onPushBackButton(arg_3_0)
	if SubTask:onPushBackButton() then
		SanctuaryMain:setMode("Main")
	end
end

function SanctuarySubTask.CheckNotification(arg_4_0)
	if TutorialCondition:isEnable("system_069") then
		return true
	end
	
	if not UnlockSystem:isUnlockSystem(UNLOCK_ID.SANC_SUBTASK) then
		return false
	end
	
	local var_4_0, var_4_1 = SubTask:getConcurrentCount()
	
	if var_4_0 < var_4_1 then
		return true
	end
	
	return SanctuaryMain:GetTotalLevel("SubTask") < 9 and Account:getCurrency("stone") > 0
end

function SanctuarySubTask.onUpdateUpgrade(arg_5_0)
	SubTaskRight:refresh()
end
