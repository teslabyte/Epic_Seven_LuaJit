UIResultStatItem = ClassDef()

function UIResultStatItem.constructor(arg_1_0, arg_1_1)
	arg_1_0.info = arg_1_1
	
	local var_1_0 = arg_1_1.ratio == 1
	local var_1_1 = arg_1_1.party == 4
	
	arg_1_0.cont = cc.CSLoader:createNode("wnd/clan_worldboss_result_stat_item.csb")
	
	if not get_cocos_refid(arg_1_0.cont) then
		return 
	end
	
	arg_1_0.cont.bar = arg_1_0.cont:findChildByName("bar")
	
	if not get_cocos_refid(arg_1_0.cont.bar) then
		return 
	end
	
	local var_1_2 = arg_1_0.cont.bar:getContentSize()
	
	if not arg_1_0.cont.bar.width then
		arg_1_0.cont.bar.width = var_1_2.width
	end
	
	if not arg_1_0.cont.bar.height then
		arg_1_0.cont.bar.height = var_1_2.height
	end
	
	arg_1_0.cont.bar:setContentSize({
		width = 0,
		height = var_1_2.height
	})
	if_set_sprite(arg_1_0.cont, "face", "face/" .. arg_1_1.unit.db.face_id .. "_s.png")
	if_set_color(arg_1_0.cont, "frame", var_1_1 and cc.c3b(17, 146, 237) or cc.c3b(255, 255, 255))
	if_set_visible(arg_1_0.cont, "n_mvp", var_1_0)
	
	arg_1_0.cont.score_txt = arg_1_0.cont:findChildByName("t_count")
	
	if not get_cocos_refid(arg_1_0.cont.score_txt) then
		return 
	end
	
	arg_1_0.cont.score_txt:setString("")
	arg_1_0.cont.score_txt:setPositionX(0)
	arg_1_0.cont.score_txt:setColor(var_1_0 and cc.c3b(255, 255, 255) or cc.c3b(68, 157, 249))
	
	arg_1_0.cont.perc_txt = arg_1_0.cont:findChildByName("t_percent")
	
	if not get_cocos_refid(arg_1_0.cont.perc_txt) then
		return 
	end
	
	arg_1_0.cont.perc_txt:setString(arg_1_1.perc .. "%")
end

function UIResultStatItem.playUIAction(arg_2_0)
	local var_2_0 = arg_2_0.info.ratio
	local var_2_1 = 200 + 300 * var_2_0
	
	if var_2_0 == 1 then
		var_2_1 = var_2_1 + 200
	end
	
	local var_2_2 = arg_2_0.cont.bar.width * var_2_0
	local var_2_3 = NONE()
	
	if arg_2_0.info.power > 0 then
		var_2_3 = TARGET(arg_2_0.cont.score_txt, SPAWN(INC_NUMBER(var_2_1, arg_2_0.info.power), MOVE_TO(var_2_1, 6 + var_2_2)))
	end
	
	UIAction:Add(SEQ(LOG(SPAWN(var_2_3, CONTENT_SIZE(var_2_1, var_2_2, arg_2_0.cont.bar.height)), 250)), arg_2_0.cont.bar, "block")
end

WorldBossBattleResultStat = WorldBossBattleResultStat or {}

function HANDLER.clan_worldboss_result_stat(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_close" then
		WorldBossBattleResultStat:hide()
	end
end

function WorldBossBattleResultStat.show(arg_4_0, arg_4_1)
	arg_4_0.wnd = load_dlg("clan_worldboss_result_stat", true, "wnd", function()
		arg_4_0:hide()
	end)
	
	if not get_cocos_refid(arg_4_0.wnd) then
		return 
	end
	
	arg_4_0.wnd:setOpacity(0)
	UIAction:Add(FADE_IN(200), arg_4_0.wnd, "block")
	;(arg_4_1.layer or SceneManager:getRunningNativeScene()):addChild(arg_4_0.wnd)
	
	local var_4_0 = arg_4_1
	
	if not var_4_0 or table.count(var_4_0) < 1 then
		return 
	end
	
	local var_4_1 = arg_4_0.wnd:findChildByName("clip")
	
	if not get_cocos_refid(var_4_1) then
		return 
	end
	
	local var_4_2 = var_4_1:getContentSize()
	local var_4_3 = arg_4_0.wnd:findChildByName("n_list")
	
	if not get_cocos_refid(var_4_3) then
		return 
	end
	
	local var_4_4, var_4_5 = var_4_3:getPosition()
	
	BackButtonManager:push({
		check_id = "WorldBossBattleResultStat.backButton",
		back_func = function()
			arg_4_0:hide()
		end
	})
	table.sort(var_4_0, function(arg_7_0, arg_7_1)
		return arg_7_0.power > arg_7_1.power
	end)
	
	local var_4_6 = var_4_0[1]
	local var_4_7 = var_4_0[table.count(var_4_0)]
	local var_4_8 = 0
	
	for iter_4_0, iter_4_1 in pairs(var_4_0) do
		var_4_8 = var_4_8 + iter_4_1.power
	end
	
	local var_4_9 = 0
	
	for iter_4_2, iter_4_3 in pairs(var_4_0) do
		local var_4_10 = math.max(0, round(iter_4_3.power / var_4_8 * 100))
		
		var_4_9 = var_4_9 + var_4_10
		iter_4_3.perc = var_4_10
		iter_4_3.ratio = iter_4_3.power / var_4_6.power
	end
	
	local var_4_11 = 100 - var_4_9
	
	if var_4_11 > 0 then
		var_4_6.perc = math.max(0, var_4_6.perc + var_4_11)
	else
		var_4_7.perc = math.max(0, var_4_7.perc + var_4_11)
	end
	
	for iter_4_4, iter_4_5 in pairs(var_4_0) do
		local var_4_12 = UIResultStatItem(iter_4_5)
		local var_4_13 = var_4_12.cont
		
		if get_cocos_refid(var_4_13) then
			var_4_3:addChild(var_4_13)
			var_4_13:setOpacity(0)
			var_4_13:setPosition(-var_4_4, 0)
			
			local var_4_14 = var_4_2.width / table.count(var_4_0)
			local var_4_15 = var_4_14 / 2 + var_4_14 * (iter_4_4 - 1) - var_4_4
			local var_4_16 = iter_4_4 * 40 + 200
			
			UIAction:Add(SEQ(DELAY(var_4_16), SPAWN(FADE_IN(100), LOG(MOVE_TO(180, var_4_15), 200))), var_4_13, "block")
			UIAction:Add(SEQ(DELAY(200 + var_4_16), CALL(function()
				var_4_12:playUIAction()
			end)), var_4_13, "block")
		end
	end
end

function WorldBossBattleResultStat.hide(arg_9_0)
	BackButtonManager:pop("WorldBossBattleResultStat.backButton")
	
	if get_cocos_refid(arg_9_0.wnd) then
		UIAction:Add(SEQ(FADE_OUT(200), REMOVE()), arg_9_0.wnd, "block")
	end
end
