Volley_CharacterManager = {}
Volley_Character = {}

local var_0_0 = 500
local var_0_1 = {
	"sd_su_doublesword_ice",
	"sd_su_chermia",
	"sd_su_magicbook_ice",
	"sd_su_mui"
}
local var_0_2 = {
	"start",
	"toss",
	"spike",
	"out"
}

function Volley_CharacterManager.getCharacter(arg_1_0, arg_1_1, arg_1_2)
	if arg_1_1 then
		return arg_1_0.vars.characters.allys[arg_1_2]
	else
		return arg_1_0.vars.characters.enemies[arg_1_2]
	end
end

function Volley_CharacterManager.findCharacter(arg_2_0, arg_2_1)
end

function Volley_CharacterManager.updateJumpShadow(arg_3_0)
	if not arg_3_0.vars or not arg_3_0.vars.characters or PAUSED then
		return 
	end
	
	for iter_3_0, iter_3_1 in pairs(arg_3_0.vars.characters.allys) do
		iter_3_1:update_jump_shadow()
		iter_3_1:update_out_shadow()
	end
	
	for iter_3_2, iter_3_3 in pairs(arg_3_0.vars.characters.enemies) do
		iter_3_3:update_jump_shadow()
		iter_3_3:update_out_shadow()
	end
end

function Volley_CharacterManager.command(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	if not arg_4_1 or not arg_4_2 then
		return 
	end
	
	local var_4_0 = arg_4_3 or {}
	
	if arg_4_1 == "move" then
		arg_4_2:move()
	elseif arg_4_1 == "serve" then
		arg_4_2:setJumpServeAnimation(var_4_0.ball_speed, var_4_0.target_y, var_4_0.before_jump_delay)
	elseif arg_4_1 == "spike" then
		arg_4_2:setJumpSpikeAnimation(var_4_0.ball_speed, var_4_0.target_y, var_4_0.before_jump_delay)
	elseif arg_4_1 == "spike_cutin" then
		arg_4_2:setJumpSpikeAnimationAndCutIn(var_4_0.ball_speed, var_4_0.target_y)
	elseif arg_4_1 == "toss" or arg_4_1 == "toss_to_spike" then
		arg_4_2:tossAnimation()
	elseif arg_4_1 == "receive_spike_toss" then
		arg_4_2:receiveSpike_tossAnimation(var_4_0.spike_speed)
	elseif arg_4_1 == "hit" then
		arg_4_2:hitAnimation()
	elseif arg_4_1 == "idle_long" then
		arg_4_2:idle_long_Animation()
	elseif arg_4_1 == "out" then
		arg_4_2:outAnimation(var_4_0.spike_speed)
	end
end

function Volley_CharacterManager.setIdleLongAll(arg_5_0, arg_5_1)
	for iter_5_0, iter_5_1 in pairs(arg_5_0.vars.characters) do
		for iter_5_2, iter_5_3 in pairs(iter_5_1) do
			if iter_5_3 ~= arg_5_1 then
				local var_5_0 = iter_5_3:getModel()
				local var_5_1, var_5_2 = iter_5_3:getModelData():getBonePosition("top")
				local var_5_3 = iter_5_3:isAlly()
				local var_5_4 = var_5_3 and 30 or -30
				
				local function var_5_5()
					local var_6_0 = "ui_camping_note" .. math.random(1, 3) + (var_5_3 and 3 or 0) .. ".cfx"
					
					EffectManager:Play({
						fn = var_6_0,
						layer = var_5_0,
						x = var_5_1,
						y = var_5_2
					})
				end
				
				if arg_5_1:isAlly() == iter_5_3:isAlly() then
					EffectManager:Play({
						fn = "ui_camping_boring.cfx",
						layer = var_5_0,
						x = var_5_1 + var_5_4,
						y = var_5_2,
						flip_x = not var_5_3
					})
				else
					var_5_5()
				end
			end
		end
	end
end

function Volley_CharacterManager.showWinLoseTalk(arg_7_0, arg_7_1)
	local var_7_0
	local var_7_1
	local var_7_2
	
	if arg_7_1 then
		var_7_0 = "win"
		var_7_2 = "lose"
	else
		var_7_0 = "lose"
		var_7_2 = "win"
	end
	
	for iter_7_0, iter_7_1 in pairs(arg_7_0.vars.characters) do
		for iter_7_2, iter_7_3 in pairs(iter_7_1) do
			local var_7_3 = math.random(1, 3) * 50
			
			if iter_7_3:isAlly() then
				BattleAction:Add(SEQ(DELAY(var_7_3), CALL(function()
					iter_7_3:showBalloonMsg(var_7_0)
				end)), VolleyBallMain:getUIWnd(), "score_talk")
			else
				BattleAction:Add(SEQ(DELAY(var_7_3), CALL(function()
					iter_7_3:showBalloonMsg(var_7_2)
				end)), VolleyBallMain:getUIWnd(), "score_talk")
			end
		end
	end
end

function Volley_CharacterManager.showStartTalk(arg_10_0)
	local var_10_0 = "start"
	
	for iter_10_0, iter_10_1 in pairs(arg_10_0.vars.characters) do
		for iter_10_2, iter_10_3 in pairs(iter_10_1) do
			local var_10_1 = math.random(1, 3) * 50
			
			BattleAction:Add(SEQ(DELAY(var_10_1), CALL(function()
				iter_10_3:showBalloonMsg(var_10_0)
			end)), VolleyBallMain:getUIWnd(), "start_talk")
		end
	end
end

function Volley_CharacterManager.moveCharacterAll(arg_12_0)
	if not arg_12_0.vars or not arg_12_0.vars.characters then
		return 
	end
	
	local var_12_0 = VolleyBallUtil:getRndPosX_list()
	local var_12_1 = VolleyBallUtil:getRndPosY_list()
	
	for iter_12_0, iter_12_1 in pairs(arg_12_0.vars.characters) do
		for iter_12_2, iter_12_3 in pairs(iter_12_1) do
			local var_12_2 = 0
			local var_12_3 = iter_12_3:getSpeed()
			local var_12_4 = VolleyBallUtil:getRndPosX_gap()
			local var_12_5 = VolleyBallUtil:getRndPosY_gap()
			
			if not var_12_0[tonumber(math.random(1, var_12_4))] then
				local var_12_6 = 0
			end
			
			if not var_12_1[tonumber(math.random(1, var_12_5))] then
				local var_12_7 = 0
			end
			
			local var_12_8 = iter_12_3:getModel()
			local var_12_9, var_12_10 = var_12_8:getPosition()
			local var_12_11, var_12_12 = iter_12_3:getInitPosition()
			
			iter_12_3:setFuturePos(var_12_11, var_12_12)
			BattleAction:Add(SEQ(DELAY(var_12_2), MOVE_TO(var_12_3, var_12_11, var_12_12), CALL(function()
			end)), var_12_8, "rnd_move")
		end
	end
end

function Volley_CharacterManager.reset(arg_14_0)
	for iter_14_0, iter_14_1 in pairs(arg_14_0.vars.characters) do
		for iter_14_2, iter_14_3 in pairs(iter_14_1) do
			local var_14_0 = iter_14_3:isAlly()
			local var_14_1 = VolleyBallMain:isPlayerServe()
			local var_14_2 = iter_14_3:isServeCharacter()
			local var_14_3 = false
			
			if var_14_2 then
				if var_14_1 and var_14_0 then
					var_14_3 = true
				elseif not var_14_1 and not var_14_0 then
					var_14_3 = true
				end
			end
			
			if var_14_3 then
				iter_14_3:move_to_serve_pos()
			else
				local var_14_4 = iter_14_3:getSpeed()
				local var_14_5 = iter_14_3:getModel()
				local var_14_6, var_14_7 = iter_14_3:getInitPosition()
				
				iter_14_3:setFuturePos(var_14_6, var_14_7)
				BattleAction:Add(SEQ(CALL(function()
					iter_14_3:setAnimation(0, "move", true)
				end), MOVE_TO(var_14_4, var_14_6, var_14_7), CALL(function()
					iter_14_3:setAnimation(0, "idle", true)
				end)), var_14_5, "c_move_reset" .. iter_14_2 .. "_" .. iter_14_0)
			end
		end
	end
	
	arg_14_0:showWinLoseTalk(VolleyBallMain:isPlayerServe())
end

function Volley_CharacterManager.updateServeCharacter(arg_17_0)
	if not arg_17_0.vars or not arg_17_0.vars.characters then
		return 
	end
	
	local var_17_0 = VolleyBallMain:isPlayerServe()
	local var_17_1 = VolleyBallMain:getServeIdx(var_17_0)
	
	for iter_17_0, iter_17_1 in pairs(arg_17_0.vars.characters) do
		if var_17_0 and iter_17_0 == "allys" then
			for iter_17_2, iter_17_3 in pairs(iter_17_1) do
				iter_17_3:setServeCharacter(iter_17_2 == var_17_1)
			end
		else
			for iter_17_4, iter_17_5 in pairs(iter_17_1) do
				iter_17_5:setServeCharacter(iter_17_4 == var_17_1)
			end
		end
	end
end

function Volley_Character.create(arg_18_0, arg_18_1, arg_18_2)
	arg_18_1.vars = {}
	
	local var_18_0 = cc.Node:create()
	local var_18_1
	local var_18_2
	local var_18_3
	local var_18_4 = VolleyBallMain:getCharacterDataByIndex(arg_18_2)
	local var_18_5 = var_18_4.spine
	local var_18_6 = CACHE:getModel(var_18_5, var_18_1, nil, var_18_2, var_18_3)
	
	var_18_6:setName("model." .. tostring(arg_18_2))
	
	if var_18_0 and var_18_6 and not var_18_0:getChildByName("model." .. tostring(arg_18_2)) then
		var_18_6:setName("rank.team." .. tostring(arg_18_2))
		var_18_6:setScale(1.7)
		var_18_6:setTimeScale(1.2)
		var_18_0:addChild(var_18_6)
		
		arg_18_1.vars.model_data = var_18_6
	end
	
	arg_18_1.vars.name = var_18_5
	arg_18_1.vars.model = var_18_0
	arg_18_1.vars.info = var_18_4
	arg_18_1.vars.state = "idle"
	arg_18_1.vars.speed = var_0_0
	
	local var_18_7 = {
		1,
		2,
		1,
		2
	}
	
	arg_18_1.vars.idx = tonumber(var_18_7[arg_18_2])
	
	copy_functions(Volley_Character, arg_18_1)
	
	return arg_18_1
end

function Volley_Character.createBalloonNode(arg_19_0)
	if not arg_19_0.vars or get_cocos_refid(arg_19_0.vars.balloon_node) or not get_cocos_refid(arg_19_0.vars.model) then
		return 
	end
	
	arg_19_0.vars.balloon_node = load_dlg("volleyball_battle_ballon", true, "wnd")
	
	arg_19_0.vars.model:addChild(arg_19_0.vars.balloon_node)
	if_set_visible(arg_19_0.vars.balloon_node, "n_team", true)
	if_set_visible(arg_19_0.vars.balloon_node, "n_npc", false)
	
	local var_19_0
	
	if arg_19_0.vars.isAlly then
		local var_19_1 = arg_19_0.vars.balloon_node:getChildByName("n_team")
		
		arg_19_0.vars.txt_talk = var_19_1:getChildByName("txt_talk")
		
		arg_19_0.vars.balloon_node:setPosition(10, 150)
	else
		arg_19_0.vars.balloon_node:setScaleX(-1)
		
		local var_19_2 = arg_19_0.vars.balloon_node:getChildByName("n_team")
		
		arg_19_0.vars.txt_talk = var_19_2:getChildByName("txt_talk")
		
		arg_19_0.vars.txt_talk:setScaleX(0.78)
		arg_19_0.vars.balloon_node:setPosition(10, 150)
		arg_19_0.vars.txt_talk:setPositionX(arg_19_0.vars.txt_talk:getPositionX() - 450)
	end
	
	if_set(arg_19_0.vars.txt_talk, nil, T("volleyball_lucy_special_1"))
	arg_19_0.vars.balloon_node:setVisible(false)
end

function Volley_Character.showBalloonMsg(arg_20_0, arg_20_1)
	if not arg_20_0.vars or not get_cocos_refid(arg_20_0.vars.balloon_node) or not arg_20_1 then
		return 
	end
	
	if arg_20_1 == "spike_ult" then
		return 
	end
	
	local var_20_0 = 1000
	local var_20_1
	local var_20_2 = arg_20_0:getInfo()
	
	if arg_20_1 == "toss_to_start" then
		var_20_1 = var_20_2.talk_serve
	elseif arg_20_1 == "toss" or arg_20_1 == "toss_spike" then
		var_20_1 = var_20_2.talk_toss
	elseif arg_20_1 == "toss_to_spike" or arg_20_1 == "toss_to_spike_ult" then
		var_20_1 = var_20_2.talk_toss
	elseif arg_20_1 == "spike" or arg_20_1 == "spike_ult" then
		var_20_1 = var_20_2.talk_spike
	elseif arg_20_1 == "start" then
		var_20_1 = var_20_2.talk_start
	elseif arg_20_1 == "win" then
		var_20_1 = var_20_2.talk_win
	elseif arg_20_1 == "lose" then
		var_20_1 = var_20_2.talk_lose
	elseif string.find(arg_20_1, "out") then
		var_20_1 = var_20_2.talk_hit
	end
	
	if not var_20_1 then
		return 
	end
	
	local var_20_3 = string.split(var_20_1, ",")
	local var_20_4 = var_20_3[math.random(1, table.count(var_20_3))]
	
	if_set(arg_20_0.vars.txt_talk, nil, T(var_20_4))
	BattleAction:Add(SEQ(SHOW(true), DELAY(var_20_0), SHOW(false)), arg_20_0.vars.balloon_node, "msg_show")
	
	if not arg_20_0.vars.isAlly then
		UIUserData:call(arg_20_0.vars.txt_talk, string.format("RELATIVE_X_POS(.., 0, 25)"))
		
		local var_20_5 = arg_20_0.vars.balloon_node:getScaleX()
		
		if var_20_5 < 0 then
			arg_20_0.vars.balloon_node:setScaleX(var_20_5 * -1)
			arg_20_0.vars.txt_talk:setFlippedX(true)
		end
		
		arg_20_0.vars.txt_talk:setPositionX(arg_20_0.vars.balloon_node:getPositionX() + arg_20_0.vars.txt_talk:getContentSize().width * arg_20_0.vars.txt_talk:getScaleX() + 15)
	else
		UIUserData:call(arg_20_0.vars.txt_talk, string.format("RELATIVE_X_POS(.., 0, 25)"))
	end
end

function Volley_Character.getInfo(arg_21_0)
	return arg_21_0.vars.info or {}
end

function Volley_Character.getInitPosition(arg_22_0)
	return arg_22_0.vars.initPos_x, arg_22_0.vars.initPos_y
end

function Volley_Character.setServeCharacter(arg_23_0, arg_23_1)
	arg_23_0.vars.serve_turn = arg_23_1
end

function Volley_Character.isServeCharacter(arg_24_0)
	return arg_24_0.vars.serve_turn
end

function Volley_Character.setInitPosition(arg_25_0, arg_25_1, arg_25_2)
	arg_25_0.vars.initPos_x = arg_25_1
	arg_25_0.vars.initPos_y = arg_25_2
end

function Volley_Character.move_to_serve_pos(arg_26_0)
	if not arg_26_0.vars.serve_pos_x or not arg_26_0.vars.serve_pos_y then
		return 
	end
	
	BattleAction:Add(SEQ(CALL(function()
		arg_26_0:setAnimation(0, "move", true)
	end), MOVE_TO(arg_26_0:getSpeed(), arg_26_0.vars.serve_pos_x, arg_26_0.vars.serve_pos_y), CALL(function()
		arg_26_0:setAnimation(0, "idle", true)
	end)), arg_26_0.vars.model, "c_move")
	arg_26_0:setFuturePos(arg_26_0.vars.serve_pos_x, arg_26_0.vars.serve_pos_y)
end

function Volley_Character.move_to_init_pos(arg_29_0)
	if not arg_29_0.vars.initPos_x or not arg_29_0.vars.initPos_y then
		return 
	end
	
	BattleAction:Add(SEQ(CALL(function()
		arg_29_0:setAnimation(0, "move", true)
	end), MOVE_TO(arg_29_0:getSpeed(), arg_29_0.vars.initPos_x, arg_29_0.vars.initPos_y), CALL(function()
		arg_29_0:setAnimation(0, "idle", true)
	end)), arg_29_0.vars.model, "c_move")
	arg_29_0:setFuturePos(arg_29_0.vars.initPos_x, arg_29_0.vars.initPos_y)
end

function Volley_Character.setSeverPosition(arg_32_0, arg_32_1)
	arg_32_0.vars.serve_pos_x = arg_32_1.x
	arg_32_0.vars.serve_pos_y = arg_32_1.y
end

function Volley_Character.getSeverPosition(arg_33_0)
	return arg_33_0.vars.serve_pos_x, arg_33_0.vars.serve_pos_y
end

function Volley_Character.getIdx(arg_34_0)
	return arg_34_0.vars.idx
end

local function var_0_3(arg_35_0)
	local var_35_0 = cc.Sprite:create(get_texture_filename("model/default/shadow.png"))
	
	var_35_0:setAnchorPoint(0.5, 0.5)
	var_35_0:setGlobalZOrder(-100000000)
	
	local var_35_1 = arg_35_0.body:getBoneNode("shadow")
	
	if var_35_1 then
		local function var_35_2()
			var_35_0:setScale(var_35_1:getSlotScaleX() * var_35_1:getAttachmentScaleX(), var_35_1:getSlotScaleY() * var_35_1:getAttachmentScaleY())
			
			local var_36_0 = var_35_1:getSlotColor()
			
			var_35_0:setColor(cc.c3b(var_36_0.r * 255, var_36_0.g * 255, var_36_0.b * 255))
			var_35_0:setOpacity(var_36_0.a * (arg_35_0:getOpacity() / 255) * 255)
			var_35_0:setPositionX(var_35_1:getPositionX())
			var_35_0:setPositionY(var_35_1:getPositionY())
			var_35_0:setVisible(var_35_1:isVisible())
		end
		
		arg_35_0.shadow = var_35_0
		
		arg_35_0:addChild(var_35_0)
		var_35_2()
		var_35_0:registerUpdateLuaHandler(var_35_2)
		var_35_0:registerScriptHandler(function(arg_37_0)
			if arg_37_0 == "enter" then
				var_35_0:scheduleUpdate()
			end
		end)
		var_35_0:scheduleUpdate()
		var_35_0:setVisible(false)
	end
	
	return var_35_0
end

function Volley_Character.after_work(arg_38_0)
	arg_38_0.vars.model_data:loadTexture()
	
	local var_38_0 = var_0_3(arg_38_0.vars.model_data)
	
	var_38_0:setGlobalZOrder(0)
	var_38_0:setLocalZOrder(-10)
end

function Volley_Character.move(arg_39_0)
	local var_39_0 = 0
	local var_39_1 = arg_39_0:getSpeed()
	local var_39_2 = VolleyBallUtil:getRndPosX_list()
	local var_39_3 = VolleyBallUtil:getRndPosY_list()
	
	local function var_39_4(arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4, arg_40_5, arg_40_6, arg_40_7)
		local var_40_0 = arg_40_2 + arg_40_4
		local var_40_1 = arg_40_3 + arg_40_5
		local var_40_2 = 290
		local var_40_3 = 1020
		local var_40_4 = 580
		local var_40_5 = 720
		local var_40_6 = 320
		local var_40_7 = 470
		local var_40_8 = 140
		local var_40_9 = false
		local var_40_10 = false
		
		if arg_40_0 then
			if var_40_0 <= var_40_2 then
				arg_40_4 = var_40_2 - var_40_0 + 5
				
				local var_40_11 = true
			elseif var_40_3 <= var_40_0 then
				arg_40_4 = (var_40_0 - var_40_3) * -1 - 5
				
				local var_40_12 = true
			end
		elseif var_40_3 <= var_40_0 then
			arg_40_4 = (var_40_0 - var_40_3) * -1 - 5
			
			local var_40_13 = true
		elseif var_40_0 <= var_40_5 then
			arg_40_4 = var_40_5 - var_40_0 + 5
			
			local var_40_14 = true
		end
		
		if arg_40_1 then
			if var_40_7 <= var_40_1 then
				arg_40_5 = (var_40_1 - var_40_7) * -1 - 5
				
				local var_40_15 = true
			elseif var_40_1 <= var_40_6 then
				arg_40_5 = var_40_6 - var_40_1 + 5
				
				local var_40_16 = true
			end
		elseif var_40_1 <= var_40_8 then
			arg_40_5 = var_40_8 - var_40_1 + 5
			
			local var_40_17 = true
		elseif var_40_6 <= var_40_1 then
			arg_40_5 = (var_40_6 - var_40_1) * -1 - 5
			
			local var_40_18 = true
		end
		
		local var_40_19 = arg_40_2 + arg_40_4
		local var_40_20 = arg_40_3 + arg_40_5
		
		if math.sqrt(math.pow(var_40_19 - arg_40_6, 2) + math.pow(var_40_20 - arg_40_7, 2)) <= 170 then
			local var_40_21, var_40_22 = arg_39_0:getInitPosition()
			
			if var_40_19 < var_40_21 then
				arg_40_4 = math.max(arg_40_4, arg_40_4 * -1)
			else
				arg_40_4 = math.min(arg_40_4, arg_40_4 * -1)
			end
			
			if var_40_20 < var_40_22 then
				arg_40_5 = math.max(arg_40_5, arg_40_5 * -1)
			else
				arg_40_5 = math.min(arg_40_5, arg_40_5 * -1)
			end
		end
		
		return arg_40_4, arg_40_5
	end
	
	local var_39_5 = VolleyBallUtil:getRndPosX_gap()
	local var_39_6 = VolleyBallUtil:getRndPosY_gap()
	local var_39_7 = var_39_2[tonumber(math.random(1, var_39_5))] or 0
	local var_39_8 = var_39_3[tonumber(math.random(1, var_39_6))] or 0
	local var_39_9 = arg_39_0:getModel()
	local var_39_10, var_39_11 = var_39_9:getPosition()
	local var_39_12 = arg_39_0:getIdx()
	local var_39_13 = arg_39_0:isLeft()
	local var_39_14 = 1
	
	if var_39_12 == 1 then
		var_39_14 = 2
	end
	
	local var_39_15, var_39_16 = Volley_CharacterManager:getCharacter(arg_39_0:isAlly(), var_39_14):getModel():getPosition()
	local var_39_17 = arg_39_0:isUp()
	local var_39_18, var_39_19 = var_39_4(var_39_13, var_39_17, var_39_10, var_39_11, var_39_7, var_39_8, var_39_15, var_39_16)
	local var_39_20 = var_39_19
	local var_39_21 = var_39_18 + var_39_10
	local var_39_22 = var_39_20 + var_39_11
	
	arg_39_0:setFuturePos(var_39_21, var_39_22)
	
	if var_39_12 ~= 1 or (not (var_39_22 <= 140) or true) and var_39_13 and (not (var_39_21 <= 290) or true) then
	elseif var_39_21 >= 1020 then
	end
	
	BattleAction:Add(SEQ(CALL(function()
		arg_39_0:setAnimation(0, "move", true)
	end), MOVE_TO(var_39_1, var_39_21, var_39_22), CALL(function()
		arg_39_0:setAnimation(0, "idle", true)
	end)), var_39_9, "c_move")
end

function Volley_Character.setJumpServeAnimation(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	if BattleAction:Find("c_move") then
		BattleAction:Remove("c_move")
	end
	
	local var_43_0 = arg_43_3 or 600
	local var_43_1 = 160
	
	arg_43_0.vars.landing_y = arg_43_0.vars.model:getPositionY()
	
	local var_43_2 = 100
	local var_43_3 = arg_43_1 - var_43_0 - 200
	
	BattleAction:Add(SEQ(DELAY(var_43_0), CALL(function()
		arg_43_0:setAnimation(0, "jump", false)
		arg_43_0:add_jump_shadow()
	end), DELAY(90), MOVE_TO(var_43_3 - 90, nil, arg_43_2), CALL(function()
		VolleySoundManager:play("ui/Summer_spike")
		arg_43_0:setAnimation(0, "spike", false)
	end), DELAY(var_43_2), MOVE_TO(var_43_1, nil, arg_43_0.vars.landing_y), DELAY(var_43_1 - 60), CALL(function()
		arg_43_0:play_dust_effect()
		VolleySoundManager:play("ui/summer_landing")
	end), DELAY(260), CALL(function()
		arg_43_0:setAnimation(0, "idle", true)
		arg_43_0:remove_jump_shadow()
		arg_43_0:move_to_init_pos()
	end)), arg_43_0.vars.model, "c_jump")
end

TEST_BEFORE_JUMP_DELAY = 900

function Volley_Character.setJumpSpikeAnimation(arg_48_0, arg_48_1, arg_48_2, arg_48_3)
	if BattleAction:Find("c_move") then
		BattleAction:Remove("c_move")
	end
	
	local var_48_0 = arg_48_3 or TEST_BEFORE_JUMP_DELAY
	local var_48_1 = 160
	
	arg_48_0.vars.landing_y = arg_48_0.vars.model:getPositionY()
	
	local var_48_2 = 100
	local var_48_3 = arg_48_1 - var_48_0
	
	BattleAction:Add(SEQ(DELAY(var_48_0), CALL(function()
		arg_48_0:setAnimation(0, "jump", false)
		arg_48_0:add_jump_shadow()
	end), DELAY(90), MOVE_TO(var_48_3 - 90, nil, arg_48_2), CALL(function()
		VolleySoundManager:play("ui/Summer_spike")
		arg_48_0:setAnimation(0, "spike", false)
	end), DELAY(var_48_2), MOVE_TO(var_48_1, nil, arg_48_0.vars.landing_y), DELAY(var_48_1 - 60), CALL(function()
		arg_48_0:play_dust_effect()
		VolleySoundManager:play("ui/summer_landing")
	end), DELAY(260), CALL(function()
		arg_48_0:setAnimation(0, "idle", true)
		arg_48_0:remove_jump_shadow()
	end)), arg_48_0.vars.model, "c_jump")
end

function Volley_Character.startChargeEff(arg_53_0)
	local var_53_0 = arg_53_0:getModelData():getBoneNode("center")
	
	arg_53_0.vars.charge_eff = EffectManager:Play({
		pivot_x = 0,
		fn = "ui_volleyball_special.cfx",
		pivot_y = 0,
		pivot_z = 9999999,
		scale = 0.8,
		layer = var_53_0
	})
end

function Volley_Character.stopChargeEff(arg_54_0)
	if get_cocos_refid(arg_54_0.vars.charge_eff) then
		arg_54_0.vars.charge_eff:stop()
	end
end

function Volley_Character.setJumpSpikeAnimationAndCutIn(arg_55_0, arg_55_1, arg_55_2, arg_55_3)
	if BattleAction:Find("c_move") then
		BattleAction:Remove("c_move")
	end
	
	local var_55_0 = arg_55_3 or TEST_BEFORE_JUMP_DELAY
	local var_55_1 = 160
	
	arg_55_0.vars.landing_y = arg_55_0.vars.model:getPositionY()
	
	local var_55_2 = arg_55_1 - var_55_0
	local var_55_3 = 400
	
	BattleAction:Add(SEQ(DELAY(var_55_0), CALL(function()
		arg_55_0:setAnimation(0, "jump", false)
		arg_55_0:add_jump_shadow()
	end), DELAY(90), MOVE_TO(var_55_2, nil, arg_55_2), CALL(function()
		arg_55_0:setAnimation(0, "spike", false, true, true)
	end), DELAY(50), CALL(function()
		arg_55_0:startChargeEff()
		VolleySoundManager:play("ui/summer_special_ready")
		arg_55_0:pauseAnimation()
		VolleyCutInManager:showCutIn(arg_55_0:getInfo(), arg_55_0:isAlly())
	end), DELAY(VolleyCutInManager:getCutInTime()), CALL(function()
		arg_55_0:resumeAnimation()
		arg_55_0:addEffect("spike")
		arg_55_0:stopChargeEff()
		VolleySoundManager:play("ui/Summer_spike")
	end), MOVE_TO(var_55_1, nil, arg_55_0.vars.landing_y), DELAY(var_55_1 - 60), CALL(function()
		arg_55_0:play_dust_effect()
		VolleySoundManager:play("ui/summer_landing")
	end), DELAY(260), CALL(function()
		arg_55_0:setAnimation(0, "idle", true)
		arg_55_0:remove_jump_shadow()
	end)), arg_55_0.vars.model, "c_jump")
end

function Volley_Character.tossAnimation(arg_62_0)
	local var_62_0 = 500
	
	BattleAction:Add(SEQ(CALL(function()
		arg_62_0:setAnimation(0, "toss", false)
	end), DELAY(var_62_0), CALL(function()
		arg_62_0:setAnimation(0, "idle", true)
	end)), arg_62_0:getModel(), "c_ball_toss")
end

function Volley_Character.receiveSpike_tossAnimation(arg_65_0, arg_65_1)
	local var_65_0 = arg_65_0:getModel():getPositionX()
	local var_65_1 = arg_65_0:getModel():getPositionY()
	local var_65_2 = arg_65_0:isLeft()
	local var_65_3 = 30
	
	if var_65_2 then
		var_65_3 = -30
	end
	
	local var_65_4 = var_65_0 + var_65_3
	
	if var_65_2 then
		if var_65_4 <= 290 then
			var_65_4 = 300
		end
	elseif var_65_4 >= 1020 then
		var_65_4 = 1010
	end
	
	BattleAction:Add(SEQ(DELAY(arg_65_1), CALL(function()
		arg_65_0:setAnimation(0, "toss", false)
	end), CALL(function()
		arg_65_0:play_dust_effect(true)
	end), MOVE(400, var_65_0, var_65_1, var_65_4, var_65_1), arg_65_0:setAnimation(0, "idle", true)), arg_65_0:getModel(), "c_ball_spike")
end

function Volley_Character.idle_long_Animation(arg_68_0)
	BattleAction:Add(SEQ(CALL(function()
		arg_68_0:setAnimation(0, "idle_long", true)
	end)), arg_68_0:getModel(), "c_ount")
end

function Volley_Character.hitAnimation(arg_70_0)
	BattleAction:Add(SEQ(CALL(function()
		arg_70_0:setAnimation(0, "hit", false)
	end)), arg_70_0:getModel(), "c_ount")
end

function Volley_Character.outAnimation(arg_72_0, arg_72_1)
	arg_72_0:add_out_shadow()
	
	if arg_72_0:isAlly() then
		BattleAction:Add(SEQ(JUMP_TO(arg_72_1 / 2, arg_72_0:getModel():getPositionX() - 180, arg_72_0:getModel():getPositionY()), CALL(function()
			arg_72_0:play_dust_effect()
		end)), arg_72_0:getModel(), "c_out_move")
	else
		BattleAction:Remove("c_ball_spike")
		BattleAction:Remove("c_move")
		BattleAction:Add(SEQ(JUMP_TO(arg_72_1 / 2, arg_72_0:getModel():getPositionX() + 180, arg_72_0:getModel():getPositionY()), CALL(function()
			arg_72_0:play_dust_effect()
		end)), arg_72_0:getModel(), "c_out_move")
	end
end

function Volley_Character.setAnimation(arg_75_0, arg_75_1, arg_75_2, arg_75_3, arg_75_4, arg_75_5)
	local var_75_0 = arg_75_0:getModelData()
	local var_75_1 = arg_75_0:getModel()
	
	if var_75_0 and var_75_0.setAnimation then
		var_75_0:setAnimation(arg_75_1, arg_75_2, arg_75_3)
	end
	
	if not arg_75_4 then
		arg_75_0:addEffect(arg_75_2)
	end
	
	if arg_75_2 == "hit" then
		VolleySoundManager:play("ui/Summer_hit")
	end
	
	if arg_75_2 ~= "hit" then
		arg_75_0:remove_out_shadow()
	end
	
	if arg_75_2 == "toss" then
		VolleySoundManager:play("ui/Summer_receive")
	end
	
	if arg_75_2 == "spike" and arg_75_0.vars.info then
		if arg_75_5 and arg_75_0.vars.info.special_voice then
			SoundEngine:play("event:/" .. arg_75_0.vars.info.special_voice)
		elseif arg_75_0.vars.info.spike_voice then
			SoundEngine:play("event:/" .. arg_75_0.vars.info.spike_voice)
		end
	end
end

function Volley_Character.addEffect(arg_76_0, arg_76_1)
	local var_76_0 = arg_76_0:getModelData()
	local var_76_1 = arg_76_0:getModel()
	
	if arg_76_1 == "spike" then
		local var_76_2 = var_76_0:getBoneNode("root")
		
		EffectManager:Play({
			pivot_x = 0,
			fn = "ui_volleyball_spike.cfx",
			pivot_y = 0,
			pivot_z = 99999,
			scale = 1,
			layer = var_76_2
		})
	elseif arg_76_1 == "toss" then
		EffectManager:Play({
			pivot_x = 0,
			fn = "ui_volleyball_pass.cfx",
			pivot_y = 0,
			pivot_z = 99999,
			scale = 0.5,
			layer = arg_76_0.vars.model
		})
	end
end

function Volley_Character.pauseAnimation(arg_77_0)
	local var_77_0 = arg_77_0:getModelData()
	
	if var_77_0 and var_77_0.pauseAnimation then
		var_77_0:pauseAnimation()
	end
end

function Volley_Character.resumeAnimation(arg_78_0)
	local var_78_0 = arg_78_0:getModelData()
	
	if var_78_0 and var_78_0.resumeAnimation then
		var_78_0:resumeAnimation()
	end
end

function Volley_Character.isUp(arg_79_0)
	local var_79_0 = arg_79_0:getIdx()
	
	return tonumber(var_79_0) == 2
end

function Volley_Character.isLeft(arg_80_0)
	return arg_80_0.vars.isLeft
end

function Volley_Character.getSpeed(arg_81_0)
	return arg_81_0.vars.speed
end

function Volley_Character.setFuturePos(arg_82_0, arg_82_1, arg_82_2)
	arg_82_0.vars.future_x = arg_82_1
	arg_82_0.vars.future_y = arg_82_2
end

function Volley_Character.getFuturePos(arg_83_0)
	if not arg_83_0.vars.future_x or not arg_83_0.vars.future_y then
		return arg_83_0:getBallPosX(), arg_83_0:getBallPosY()
	end
	
	return arg_83_0.vars.future_x, arg_83_0.vars.future_y + 60
end

function Volley_Character.getFutureBallPos(arg_84_0)
	local var_84_0 = arg_84_0:isLeft()
	local var_84_1 = -17
	
	if var_84_0 then
		var_84_1 = 17
	end
	
	if not arg_84_0.vars.future_x or not arg_84_0.vars.future_y then
		return arg_84_0:getBallPosX() + var_84_1, arg_84_0:getBallPosY()
	end
	
	return arg_84_0.vars.future_x + var_84_1, arg_84_0.vars.future_y + 60
end

function Volley_Character.add_jump_shadow(arg_85_0)
	if arg_85_0.vars.jump_shadow then
		arg_85_0:remove_jump_shadow()
	end
	
	local var_85_0 = arg_85_0:getModel()
	local var_85_1 = arg_85_0:getModelData().body:getBoneNode("shadow")
	
	arg_85_0.vars.jump_shadow = cc.Sprite:create(get_texture_filename("model/default/shadow.png"))
	
	arg_85_0.vars.jump_shadow:setAnchorPoint(0.5, 0.5)
	arg_85_0.vars.jump_shadow:setGlobalZOrder(-100000000)
	
	local function var_85_2()
		local var_86_0 = var_85_1:getSlotColor()
		
		arg_85_0.vars.jump_shadow:setColor(cc.c3b(var_86_0.r * 255, var_86_0.g * 255, var_86_0.b * 255))
		arg_85_0.vars.jump_shadow:setOpacity(255)
		arg_85_0.vars.jump_shadow:setPositionX(var_85_0:getPositionX())
		arg_85_0.vars.jump_shadow:setPositionY(var_85_0:getPositionY())
		arg_85_0.vars.jump_shadow:setVisible(false)
	end
	
	arg_85_0.vars.jump_shadow:setScaleFactor(1)
	VolleyBallMain:getParentLayer():addChild(arg_85_0.vars.jump_shadow)
	var_85_2()
	
	arg_85_0.vars.jump_shadow.origin_scale = 1.66
	
	arg_85_0.vars.jump_shadow:setScale(arg_85_0.vars.jump_shadow.origin_scale)
	
	arg_85_0.vars.jump_shadow.origin_y = var_85_0:getPositionY()
	
	arg_85_0.vars.jump_shadow:setGlobalZOrder(0)
	arg_85_0.vars.jump_shadow:setLocalZOrder(10)
	arg_85_0:setShadowBone(false)
end

function Volley_Character.update_jump_shadow(arg_87_0)
	if not arg_87_0.vars or not get_cocos_refid(arg_87_0.vars.jump_shadow) then
		return 
	end
	
	local var_87_0 = arg_87_0:getModel()
	local var_87_1 = arg_87_0:getModelData().body:getBoneNode("shadow")
	local var_87_2 = var_87_1:isVisible()
	
	arg_87_0.vars.jump_shadow:setVisible(not var_87_1:isVisible())
	
	local var_87_3 = math.max(1, arg_87_0.vars.jump_shadow.origin_scale - (var_87_0:getPositionY() - arg_87_0.vars.jump_shadow.origin_y) / 200)
	local var_87_4 = math.min(arg_87_0.vars.jump_shadow.origin_scale, var_87_3)
	
	arg_87_0.vars.jump_shadow:setScale(var_87_4)
end

function Volley_Character.setShadowBone(arg_88_0, arg_88_1)
	arg_88_0:getModelData().body:getBoneNode("shadow"):setVisible(arg_88_1)
end

function Volley_Character.remove_jump_shadow(arg_89_0)
	if not arg_89_0.vars.jump_shadow then
		return 
	end
	
	arg_89_0.vars.jump_shadow:removeFromParent()
	
	arg_89_0.vars.jump_shadow = nil
	
	arg_89_0:setShadowBone(true)
end

function Volley_Character.add_out_shadow(arg_90_0)
	if arg_90_0.vars.out_shadow then
		arg_90_0:remove_out_shadow()
	end
	
	local var_90_0 = arg_90_0:getModel()
	local var_90_1 = arg_90_0:getModelData().body:getBoneNode("shadow")
	
	arg_90_0.vars.out_shadow = cc.Sprite:create(get_texture_filename("model/default/shadow.png"))
	
	arg_90_0.vars.out_shadow:setAnchorPoint(0.5, 0.5)
	arg_90_0.vars.out_shadow:setGlobalZOrder(-100000000)
	
	local function var_90_2()
		local var_91_0 = var_90_1:getSlotColor()
		
		arg_90_0.vars.out_shadow:setColor(cc.c3b(var_91_0.r * 255, var_91_0.g * 255, var_91_0.b * 255))
		arg_90_0.vars.out_shadow:setOpacity(255)
		arg_90_0.vars.out_shadow:setPositionX(var_90_0:getPositionX())
		arg_90_0.vars.out_shadow:setPositionY(var_90_0:getPositionY())
		arg_90_0.vars.out_shadow:setVisible(false)
	end
	
	arg_90_0.vars.out_shadow:setScaleFactor(1)
	VolleyBallMain:getParentLayer():addChild(arg_90_0.vars.out_shadow)
	var_90_2()
	
	arg_90_0.vars.out_shadow.origin_scale = 1.66
	
	arg_90_0.vars.out_shadow:setScale(arg_90_0.vars.out_shadow.origin_scale)
	
	arg_90_0.vars.out_shadow.origin_y = var_90_0:getPositionY()
	
	arg_90_0.vars.out_shadow:setGlobalZOrder(0)
	arg_90_0.vars.out_shadow:setLocalZOrder(10)
	arg_90_0:setShadowBone(false)
end

function Volley_Character.update_out_shadow(arg_92_0)
	if not arg_92_0.vars or not get_cocos_refid(arg_92_0.vars.out_shadow) then
		return 
	end
	
	local var_92_0 = arg_92_0:getModel()
	local var_92_1 = arg_92_0:getModelData().body:getBoneNode("shadow")
	local var_92_2 = var_92_1:isVisible()
	
	arg_92_0.vars.out_shadow:setVisible(not var_92_1:isVisible())
	
	local var_92_3 = math.max(1, arg_92_0.vars.out_shadow.origin_scale - (var_92_0:getPositionY() - arg_92_0.vars.out_shadow.origin_y) / 200)
	local var_92_4 = math.min(arg_92_0.vars.out_shadow.origin_scale, var_92_3)
	
	arg_92_0.vars.out_shadow:setScale(var_92_4)
	arg_92_0.vars.out_shadow:setPositionX(var_92_0:getPositionX())
end

function Volley_Character.remove_out_shadow(arg_93_0)
	if not arg_93_0.vars.out_shadow then
		return 
	end
	
	arg_93_0.vars.out_shadow:removeFromParent()
	
	arg_93_0.vars.out_shadow = nil
	
	arg_93_0:setShadowBone(true)
end

function Volley_Character.play_dust_effect(arg_94_0, arg_94_1)
	local var_94_0 = arg_94_0:getModel()
	local var_94_1, var_94_2 = arg_94_0:getModelData():getBonePosition("root")
	local var_94_3 = CACHE:getEffect("dust_landing")
	
	var_94_3:setPosition(var_94_1, var_94_2)
	var_94_3:setLocalZOrder(var_94_0:getLocalZOrder())
	
	if arg_94_1 then
		var_94_3:setScale(0.5)
		var_94_0:addChild(var_94_3)
	else
		VolleyBallMain:getParentLayer():addChild(var_94_3)
		
		local var_94_4, var_94_5 = var_94_0:getPosition()
		
		var_94_3:setPosition(var_94_4, var_94_5)
	end
	
	BattleAction:Add(SEQ(DMOTION("animation"), REMOVE()), var_94_3, "voll_jump_dust")
end

function Volley_Character.getModel(arg_95_0)
	return arg_95_0.vars.model
end

function Volley_Character.getModelData(arg_96_0)
	return arg_96_0.vars.model_data
end

function Volley_Character.getBallPosX(arg_97_0)
	return arg_97_0.vars.model:getPositionX()
end

function Volley_Character.getBallPosY(arg_98_0)
	return arg_98_0.vars.model:getPositionY() + 60
end

function Volley_Character.isAlly(arg_99_0)
	return arg_99_0.vars.isAlly
end
