BackButtonManager = BackButtonManager or {}

local var_0_0 = "bbm"
local var_0_1 = {}
local var_0_2

function BackButtonManager.getBackFuncs(arg_1_0)
	return var_0_1
end

function BackButtonManager.getTop(arg_2_0)
	if not var_0_1 then
		return 0
	end
	
	return table.count(var_0_1)
end

function BackButtonManager.getTopInfo(arg_3_0)
	local var_3_0 = arg_3_0:getTop()
	
	if var_3_0 == 0 then
		return nil
	end
	
	return var_0_1[var_3_0]
end

function BackButtonManager.getId(arg_4_0, arg_4_1)
	if not arg_4_1 then
		return 
	end
	
	if tolua.type(arg_4_1) ~= "table" then
		return 
	end
	
	if arg_4_1.dlg then
		return get_cocos_refid(arg_4_1.dlg)
	end
	
	if arg_4_1.id then
		return arg_4_1.id
	end
end

function BackButtonManager.getIndex(arg_5_0, arg_5_1)
	if not var_0_1 then
		return 
	end
	
	local var_5_0 = arg_5_0:getId(arg_5_1)
	
	if var_5_0 == nil then
		return 
	end
	
	for iter_5_0, iter_5_1 in pairs(var_0_1) do
		if var_5_0 == arg_5_0:getId(iter_5_1) then
			return iter_5_0
		end
	end
end

function BackButtonManager.clear(arg_6_0, arg_6_1)
	arg_6_1 = arg_6_1 or ".*"
	
	for iter_6_0 = table.count(var_0_1), 1, -1 do
		if string.find(var_0_1[iter_6_0].check_id, arg_6_1) then
			table.remove(var_0_1, iter_6_0)
		end
	end
	
	BackButtonManager:status("----- clear [" .. arg_6_1 .. "] back button table -----")
end

function BackButtonManager.push(arg_7_0, arg_7_1)
	arg_7_1.check_id = arg_7_1.check_id or ""
	
	local var_7_0 = arg_7_0:getIndex(arg_7_1)
	
	if var_7_0 then
		Log.d("중복 id: " .. arg_7_0:getTableInfoText(var_7_0))
		
		return 
	end
	
	table.push(var_0_1, arg_7_1)
	BackButtonManager:status("PUSH >>>> " .. arg_7_0:getTableInfoText(var_7_0))
end

function BackButtonManager.pop(arg_8_0, arg_8_1)
	cc.Director:getInstance():getOpenGLView():setIMEKeyboardState(false)
	
	local var_8_0 = arg_8_0:getTop()
	
	if arg_8_1 and (arg_8_1.dlg or arg_8_1.id) then
		var_8_0 = arg_8_0:getIndex(arg_8_1)
		
		if var_8_0 == nil then
			return 
		end
	end
	
	if var_8_0 == 0 then
		Log.d("BackButtonManager", "#back_func_stack 이 0입니다.")
		
		return 
	end
	
	local var_8_1 = arg_8_0:getTableInfoText(var_8_0)
	
	table.remove(var_0_1, var_8_0)
	BackButtonManager:status((var_8_0 == arg_8_0:getTop() and "POP" or "REMOVE") .. " <<<<< " .. var_8_1)
end

function BackButtonManager.back(arg_9_0)
	arg_9_0.last_call_time = arg_9_0.last_call_time or 0
	
	local var_9_0 = LAST_UI_TICK
	
	if var_9_0 - arg_9_0.last_call_time <= 1 then
		return 
	end
	
	arg_9_0.last_call_time = var_9_0
	
	if NetWaiting:isWaiting() then
		print("통신중 백버튼 무시")
		
		return 
	end
	
	if UIAction:Find("block") then
		print("UIAction 실행중 백버튼 무시")
		
		return 
	end
	
	if Action:Find("book") then
		print("가차 연출중 백버튼 무시")
		
		return 
	end
	
	if TransitionScreen:isShow() then
		print("씬 전환 중일때 백버튼 무시")
		
		return 
	end
	
	if not Login.FSM:isCurrentState(LoginState.STANDBY) and not Login.FSM:isCurrentState(LoginState.STOVE_SELECT_WORLD) then
		return 
	end
	
	if SceneManager:getCurrentSceneName() == "battle" and UserNickName:isVisible() then
		print("닉네임 입력 중일때 백버튼 무시")
		
		return 
	end
	
	if SceneManager:getCurrentSceneName() == "battle" and BattleRepeat:isPlayingRepeatPlay() and BattleRepeat:get_isCounting() then
		print("반복전투 카운팅 중일때 무시")
		
		return 
	end
	
	if SceneManager:getCurrentSceneName() == "credits" then
		print("크레딧 씬 일때 백버튼 무시")
		
		return 
	end
	
	if DeviceSelector:isShow() and not DeviceInventory:isOpenDeviceInventory() then
		print("장치 선택중일때 무시")
		
		return 
	end
	
	if SceneManager:getCurrentSceneName() == "gacha_unit" and GachaUnit.vars and not get_cocos_refid(GachaUnit.vars.ui_wnd_top) and not Inventory:isShow() then
		print("가챠씬 일때 백버튼 무시")
		
		return 
	end
	
	if TutorialGuide:isPlayingTutorial() then
		if TutorialGuide:isSkipable() then
			TutorialGuide:skipGuide(true)
		elseif TutorialGuide:checkFinish() and TutorialGuide:getCurrentGuideType() == "summary" then
			TutorialGuide:procGuide()
		end
		
		return 
	end
	
	if PRODUCTION_MODE == false and SAVE:isTutorialFinished() == false and not Stove.enable and not is_enable_minimal() then
		clear_story()
		SceneManager:nextScene("lobby")
		
		return 
	end
	
	local var_9_1 = SceneManager:getCurrentSceneName()
	
	if var_9_1 == "lobby" then
		SceneManager:updateTouchEventTime()
	end
	
	if arg_9_0:getTop() == 0 then
		if var_9_1 == "title" then
			if get_cocos_refid(var_0_2) then
				terminated_process()
			end
			
			var_0_2 = balloon_message(T("msg_close_game"))
		elseif Prologue:isVisible() then
			if get_cocos_refid(var_0_2) then
				terminated_process()
			end
			
			var_0_2 = balloon_message(T("msg_close_game"), nil, nil, {
				layer = PatchGauge.fill_layer
			})
		elseif var_9_1 == "lobby" then
			if Login.FSM:isCurrentState(LoginState.STANDBY) and Login.FSM:getCmdQueueSize() == 0 and PLATFORM ~= "iphoneos" then
				SceneManager:updateTouchEventTime()
				
				local function var_9_2()
					Dialog:msgBox(T("msg_exit_game"), {
						yesno = true,
						handler = function()
							terminated_process()
						end
					})
				end
				
				if IS_PUBLISHER_ZLONG then
					Zlong:exitGame({
						callback = var_9_2
					})
				else
					var_9_2()
				end
			end
		elseif var_9_1 == "battle" then
			if is_playing_story() then
				if Battle.logic and Battle.logic:getMoonlightTheaterEpisodeID() then
					open_story_esc()
				elseif STORY_ACTION_MANAGER:canUseBackBtn() then
					print("스토리 연출 스킬연출중일때 사용불가")
					
					return 
				else
					stop_story()
				end
			elseif not TutorialGuide:isPlayingTutorial() then
				BattleTopBar:pause()
			end
		elseif var_9_1 == "mini_defence" then
			if not TutorialGuide:isPlayingTutorial() then
				MiniDefenceEsc:open()
			end
		elseif var_9_1 == "mini_volley_ball" and not TutorialGuide:isPlayingTutorial() then
			VolleyBallEsc:open()
		end
		
		return 
	end
	
	if var_9_1 == "battle" and is_playing_story() and arg_9_0:getTop() == 1 then
		if var_9_1 == "battle" and Battle.logic and Battle.logic:getMoonlightTheaterEpisodeID() then
			open_story_esc()
			
			return 
		end
	elseif var_9_1 == "moonlight_theater" and is_playing_story() and arg_9_0:getTop() == 3 then
		open_story_esc()
		
		return 
	end
	
	local var_9_3 = arg_9_0:getTop()
	local var_9_4 = var_0_1[var_9_3]
	
	if not var_9_4 then
		return 
	end
	
	if not var_9_4.back_func then
		return 
	end
	
	BackButtonManager:status("CALL==== " .. arg_9_0:getTableInfoText(var_9_3))
	var_9_4.back_func()
end

function getCommonParent(arg_12_0, arg_12_1)
	local var_12_0 = {}
	
	while arg_12_0 do
		table.insert(var_12_0, arg_12_0)
		
		arg_12_0 = arg_12_0:getParent()
	end
	
	while arg_12_1 do
		if table.find(var_12_0, arg_12_1) then
			return arg_12_1
		end
		
		arg_12_1 = arg_12_1:getParent()
	end
	
	return nil
end

function getFrontNode(arg_13_0, arg_13_1, arg_13_2)
	if arg_13_0 == arg_13_1 then
		return arg_13_2
	end
	
	if arg_13_0 == arg_13_2 then
		return arg_13_1
	end
	
	for iter_13_0, iter_13_1 in pairs(arg_13_0:getChildren()) do
		if iter_13_1 == arg_13_1 then
			return arg_13_2
		end
		
		if iter_13_1 == arg_13_2 then
			return arg_13_1
		end
		
		local var_13_0 = getFrontNode(iter_13_1, arg_13_1, arg_13_2)
		
		if var_13_0 then
			return var_13_0
		end
	end
end

function getFrontmostDialog(arg_14_0)
	if #arg_14_0 == 0 then
		return 
	end
	
	if #arg_14_0 == 1 then
		return arg_14_0[1]
	end
	
	local var_14_0 = table.remove(arg_14_0)
	local var_14_1 = getFrontmostDialog(arg_14_0)
	
	return (getFrontNode(getCommonParent(var_14_0, var_14_1), var_14_0, var_14_1))
end

function BackButtonManager.getFrontmostDialog()
	local var_15_0 = {}
	
	for iter_15_0, iter_15_1 in pairs(var_0_1) do
		if iter_15_1.dlg then
			table.insert(var_15_0, iter_15_1.dlg)
		end
	end
	
	return getFrontmostDialog(var_15_0)
end

local var_0_3 = false
local var_0_4 = false

function BackButtonManager.getTableInfoText(arg_16_0, arg_16_1)
	if PRODUCTION_MODE then
		return ""
	end
	
	if not var_0_3 then
		return ""
	end
	
	arg_16_1 = arg_16_1 or arg_16_0:getTop()
	
	if arg_16_1 == 0 then
		return ""
	end
	
	local var_16_0 = var_0_1[arg_16_1]
	
	if not var_16_0 then
		return "유효하지 않은 " .. arg_16_1 .. " 입니다."
	end
	
	local var_16_1 = "[" .. arg_16_1 .. "]: " .. (var_16_0.check_id or "")
	local var_16_2 = arg_16_0:getId(var_16_0)
	
	if var_16_2 then
		var_16_1 = var_16_1 .. ", id: " .. var_16_2
	elseif var_16_0.dlg then
		var_16_1 = var_16_1 .. ", pop 이전에 관련 다이얼로그가 nil 이 되었습니다."
	else
		var_16_1 = var_16_1 .. ", push 할 때 dlg를 추가해주세요."
	end
	
	return var_16_1
end

function BackButtonManager.status(arg_17_0, arg_17_1)
	if PRODUCTION_MODE then
		return 
	end
	
	if not var_0_3 then
		return 
	end
	
	Log.dd()
	
	local var_17_0 = arg_17_0:getTop()
	
	arg_17_1 = arg_17_1 or ""
	
	Log.d(var_0_0)
	Log.d(var_0_0, "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^" .. var_17_0)
	
	for iter_17_0 = 1, var_17_0 do
		Log.d(var_0_0, arg_17_0:getTableInfoText(iter_17_0))
	end
	
	Log.d(var_0_0, "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" .. var_17_0)
	Log.d(var_0_0, arg_17_1)
	
	if var_0_4 then
		Log.d(var_0_0, debug.traceback())
	end
end
