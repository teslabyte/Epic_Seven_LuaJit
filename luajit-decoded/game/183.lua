BattleDropManager = {}

function BattleDropManager.restore(arg_1_0, arg_1_1)
	arg_1_1 = arg_1_1 or {}
	
	local var_1_0 = #(arg_1_1.equip or {}) + #(arg_1_1.items or {}) + #(arg_1_1.character or {}) + #(arg_1_1.tokens or {})
	
	arg_1_0:setBoxCount(var_1_0)
end

function BattleDropManager.setBoxCount(arg_2_0, arg_2_1)
	if arg_2_0.box_count == arg_2_1 then
		return 
	end
	
	arg_2_0.box_count = arg_2_1
	
	BattleTopBar:updateNotifications()
	BattleMapManager:updateInvenCounts()
end

function BattleDropManager.clear(arg_3_0)
	arg_3_0.drop_golds = nil
	arg_3_0.items = nil
	arg_3_0.box_count = nil
end

function BattleDropManager.getItemSprite(arg_4_0, arg_4_1)
	local var_4_0
	local var_4_1 = 1
	local var_4_2 = string.split(arg_4_1.code, "_")[1]
	
	if var_4_2 == "ma" then
		local var_4_3, var_4_4, var_4_5 = DB("item_material", arg_4_1.code, {
			"drop_icon",
			"ma_type",
			"ma_type2"
		})
		
		var_4_0 = SpriteCache:getSprite("item/" .. (var_4_3 or "") .. ".png")
	elseif string.starts(arg_4_1.code, "e") then
		local var_4_6, var_4_7 = DB("equip_item", arg_4_1.code, {
			"type",
			"icon"
		})
		local var_4_8 = "item"
		
		if var_4_6 == "artifact" then
			var_4_1 = 0.7
			var_4_8 = "item_arti"
		end
		
		local var_4_9 = var_4_7 and var_4_8 .. "/" .. var_4_7 or "booty_" .. (var_4_6 or "")
		
		var_4_0 = SpriteCache:getSprite(var_4_9 .. ".png")
	elseif var_4_2 == "to" then
		local var_4_10 = DB("item_token", arg_4_1.code, "icon") or ""
		
		var_4_0 = SpriteCache:getSprite("item/" .. var_4_10 .. ".png")
	elseif DB("character", arg_4_1.code, "name") then
		var_4_0 = SpriteCache:getSprite("booty_character.png")
	else
		var_4_0 = SpriteCache:getSprite()
	end
	
	return var_4_0, var_4_1
end

function BattleDropManager.dropItem(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0, var_5_1 = arg_5_0:getItemSprite(arg_5_4)
	
	if var_5_0 == nil then
		var_5_0 = cc.Sprite:create("item/sp_randombox_1.png")
	end
	
	var_5_0:setScale(WIDGET_SCALE_FACTOR * (var_5_1 or 1))
	var_5_0:setLocalZOrder(arg_5_3 + 5)
	var_5_0:setPosition(arg_5_1, arg_5_2)
	arg_5_0:procDrop(nil, var_5_0, arg_5_4)
end

function BattleDropManager.dropGoldItem(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	if not arg_6_0.drop_golds then
		arg_6_0.drop_golds = {}
	end
	
	local var_6_0
	
	if BGI then
		var_6_0 = BGI.main.layer
	else
		var_6_0 = SceneManager:getRunningNativeScene()
	end
	
	local var_6_1 = CACHE:getModel("effect/golddrop.scsp", nil, "start")
	
	var_6_1:setPosition(arg_6_1, arg_6_2)
	var_6_1:setLocalZOrder(arg_6_3)
	var_6_1:setVisible(false)
	var_6_1:setScale(1.5)
	var_6_0:addChild(var_6_1)
	
	local var_6_2 = arg_6_4.g
	local var_6_3 = arg_6_4.c or arg_6_4.count
	
	table.insert(arg_6_0.drop_golds, {
		code = arg_6_4.code,
		model = var_6_1,
		grade = var_6_2,
		count = var_6_3,
		make_tick = systick()
	})
	
	local function var_6_4(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
		local var_7_0 = CACHE:getEffect(arg_7_0 .. ".particle", "effect")
		
		arg_7_1:addChild(var_7_0)
		var_7_0:setPosition(arg_7_2, arg_7_3)
		var_7_0:setLocalZOrder(arg_7_4)
		var_7_0:setVisible(true)
		var_7_0:start()
	end
	
	BattleUIAction:Add(SEQ(CALL(var_6_4, "gold_drop_intro_pati", var_6_1, 0, 270, arg_6_3 + 1), DELAY(100), SHOW(true), DMOTION("start"), CALL(var_6_4, "gold_drop_loop_pati", var_6_1, 0, 50, arg_6_3 + 1), MOTION("idle"), COND_LOOP(SEQ(DELAY(100)), function()
		if Battle.logic:getLastRoadEventState() == "finished" and not is_playing_story() then
			return true
		end
	end), CALL(BattleDropManager.collectDropItem, BattleDropManager)), var_6_1, "battle.drop.fade_end")
end

function BattleDropManager.updateDrops(arg_9_0, arg_9_1)
	arg_9_0:updateGoldItem(arg_9_1)
end

function BattleDropManager.updateItem(arg_10_0, arg_10_1)
	if not arg_10_0.items then
		arg_10_0.items = {}
	end
	
	for iter_10_0, iter_10_1 in pairs(arg_10_0.items) do
		local var_10_0 = iter_10_1.spr
		
		if get_cocos_refid(var_10_0) then
			local var_10_1 = var_10_0:getPositionX()
			
			var_10_0:setPositionX(var_10_1 + arg_10_1)
		end
	end
end

function BattleDropManager.updateGoldItem(arg_11_0, arg_11_1)
	if not arg_11_0.drop_golds then
		arg_11_0.drop_golds = {}
	end
	
	for iter_11_0, iter_11_1 in pairs(arg_11_0.drop_golds) do
		local var_11_0 = iter_11_1.model
		
		if get_cocos_refid(var_11_0) then
			local var_11_1 = var_11_0:getPositionX()
			
			var_11_0:setPositionX(var_11_1 + arg_11_1)
		end
	end
end

function BattleDropManager.collectGoldItem(arg_12_0, arg_12_1)
	local var_12_0 = 0
	
	for iter_12_0, iter_12_1 in pairs(arg_12_0.drop_golds or {}) do
		local var_12_1 = iter_12_1.c or iter_12_1.count
		local var_12_2 = iter_12_1.model
		
		if get_cocos_refid(var_12_2) then
			var_12_0 = var_12_0 + 1
			
			local var_12_3, var_12_4 = var_12_2:getPosition()
			local var_12_5 = var_12_2:getLocalZOrder()
			
			for iter_12_2, iter_12_3 in pairs(var_12_2:getChildren()) do
				if iter_12_3.stop then
					iter_12_3:stop()
				end
			end
			
			local var_12_6 = ccui.Text:create()
			
			var_12_6:setFontName("font/daum.ttf")
			var_12_6:setColor(cc.c3b(244, 207, 34))
			var_12_6:enableOutline(cc.c3b(0, 0, 0), 1)
			var_12_6:setScale(2)
			var_12_6:setFontSize(24)
			var_12_6:setLocalZOrder(999)
			var_12_6:setAnchorPoint(0.5, 0)
			var_12_6:setPosition(0, 60)
			var_12_6:setVisible(false)
			var_12_6:setString("+" .. var_12_1)
			var_12_6:setName("nametag")
			var_12_2:addChild(var_12_6)
			
			local function var_12_7(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
				local var_13_0 = CACHE:getEffect(arg_13_0 .. ".particle", "effect")
				
				arg_13_1:addChild(var_13_0)
				var_13_0:setPosition(arg_13_2, arg_13_3)
				var_13_0:setLocalZOrder(arg_13_4)
				var_13_0:setVisible(true)
				var_13_0:start()
			end
			
			local function var_12_8(arg_14_0)
				arg_14_0.drop_golds[iter_12_0] = nil
			end
			
			BattleUIAction:Add(SEQ(DELAY(arg_12_1 and 0 or 200 * var_12_0), DELAY(400), CALL(var_12_7, "gold_drop_end_pati", var_12_2, 0, 50, var_12_5 + 1), DMOTION("end"), OPACITY(0, 0, 0), DELAY(600), REMOVE(), CALL(var_12_8, arg_12_0)), var_12_2, "battle.drop.collect")
			BattleUIAction:Add(SEQ(DELAY(arg_12_1 and 0 or 200 * var_12_0), DELAY(400), SHOW(true), SPAWN(CALL(BattleDropManager.restore, arg_12_0, Battle:forecastReward(Battle.logic)), MOVE_BY(800, 0, 40), SEQ(DELAY(300), OPACITY(600, 1, 0))), REMOVE()), var_12_6, "battle.drop.collect")
		end
	end
end

function BattleDropManager.procDrop(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	if arg_15_1 == nil then
		if BGI then
			arg_15_1 = BGI.main.layer
		else
			arg_15_1 = SceneManager:getRunningNativeScene()
		end
	end
	
	local var_15_0, var_15_1 = arg_15_2:getPosition()
	local var_15_2 = SpriteCache:getSprite("item_shadow.png")
	
	var_15_2:setPosition(var_15_0, var_15_1)
	var_15_2:setLocalZOrder(-2)
	var_15_2:setScale(4)
	var_15_2:setAnchorPoint(0.5, 1)
	arg_15_1:addChild(var_15_2)
	arg_15_2:setPositionY(var_15_1)
	
	local var_15_3 = arg_15_2:getScale()
	
	arg_15_2:setAnchorPoint(0.5, 0)
	arg_15_2:setLocalZOrder(2)
	arg_15_1:addChild(arg_15_2)
	
	local function var_15_4(arg_16_0)
		return SEQ(LOG(MOVE_BY(100, 0, 25 * arg_16_0)), DELAY(80), RLOG(MOVE_BY(100, 0, -40)))
	end
	
	local var_15_5 = arg_15_2:getScale()
	local var_15_6 = arg_15_2:getPositionX()
	local var_15_7 = arg_15_2:getPositionY()
	local var_15_8 = {
		[2] = {
			intro_name = "grade_uncommon_in"
		},
		[3] = {
			intro_name = "grade_rare_in",
			loop_name = "grade_rare_back"
		},
		[4] = {
			intro_name = "grade_hero_in",
			add_shake = true,
			loop_name = "grade_hero_back",
			sound_path = "effect/item_drop_legend",
			particle_name = "drop_hero_pati"
		},
		[5] = {
			intro_name = "grade_legend_in",
			add_shake = true,
			loop_name = "grade_legend_back",
			sound_path = "effect/item_drop_legend",
			particle_name = "drop_legend_pati"
		}
	}
	local var_15_9
	local var_15_10
	local var_15_11
	local var_15_12
	local var_15_13
	local var_15_14 = arg_15_3.g or arg_15_3.grade
	local var_15_15
	local var_15_16 = {
		"ma_wyvern_reforge",
		"ma_golem_reforge",
		"ma_banshee_reforge",
		"ma_azimanak_reforge",
		"ma_demon_reforge",
		"ma_alchemy_reforge"
	}
	
	if table.isInclude(var_15_16, arg_15_3.code) and (arg_15_3.count or arg_15_3.c) >= 50 then
		var_15_15 = var_15_8[5]
	end
	
	if var_15_15 or var_15_14 and var_15_8[var_15_14] then
		local var_15_17 = var_15_15 or var_15_8[var_15_14]
		
		if var_15_17.intro_name then
			var_15_9 = CACHE:getEffect(var_15_17.intro_name .. ".scsp")
			
			var_15_9:setLocalZOrder(arg_15_2:getLocalZOrder() + 1)
			var_15_9:setPosition(arg_15_2:getPosition())
			var_15_9:setVisible(false)
			var_15_9:setOpacity(0)
			arg_15_1:addChild(var_15_9)
		end
		
		if var_15_17.loop_name then
			var_15_10 = CACHE:getEffect(var_15_17.loop_name .. ".scsp")
			
			var_15_10:setLocalZOrder(arg_15_2:getLocalZOrder() - 1)
			var_15_10:setPosition(arg_15_2:getPosition())
			var_15_10:setVisible(false)
			var_15_10:setOpacity(0)
			arg_15_1:addChild(var_15_10)
		end
		
		if var_15_17.particle_name then
			var_15_11 = CACHE:getEffect(var_15_17.particle_name .. ".particle")
			
			var_15_11:setLocalZOrder(arg_15_2:getLocalZOrder() + 2)
			var_15_11:setPosition(arg_15_2:getPosition())
			var_15_11:setVisible(false)
			arg_15_1:addChild(var_15_11)
		end
		
		var_15_12 = var_15_17.sound_path
		var_15_13 = var_15_17.add_shake
	end
	
	local function var_15_18(arg_17_0)
		if not arg_17_0 then
			return NONE()
		end
		
		if string.ends(tolua.type(arg_17_0), "ParticleEffect2D") then
			return TARGET(arg_17_0, SEQ(MOVE_TO(0, var_15_6, var_15_7 - 40), SHOW(true), CALL(function()
				arg_17_0:start()
			end)))
		end
		
		return TARGET(arg_17_0, SEQ(MOVE_TO(0, var_15_6, var_15_7 - 40), SHOW(true), OPACITY(0, 0, 1), DMOTION("intro"), MOTION("loop", true)))
	end
	
	local function var_15_19(arg_19_0)
		if not arg_19_0 then
			return NONE()
		end
	end
	
	local function var_15_20(arg_20_0)
		if not arg_20_0 then
			return NONE()
		end
		
		return TARGET(arg_20_0, SEQ(DELAY(1000), OPACITY(500, 1, 0.5)))
	end
	
	local function var_15_21(arg_21_0)
		if arg_21_0 then
			return SEQ(DELAY(100), CALL(SoundEngine.play, SoundEngine, "event:/" .. arg_21_0))
		end
		
		return NONE()
	end
	
	local function var_15_22(arg_22_0)
		if arg_22_0 then
			return SEQ(DELAY(100), SHAKE_UI(400, 24, true, {
				only_x = true
			}))
		end
		
		return NONE()
	end
	
	BattleUIAction:Add(SEQ(SPAWN(FADE_IN(150), var_15_4(1, arg_15_2)), var_15_4(0.2, arg_15_2), SPAWN(var_15_18(var_15_9), var_15_18(var_15_10), var_15_18(var_15_11), var_15_21(var_15_12)), var_15_22(var_15_13), COND_LOOP(SEQ(DELAY(100)), function()
		if Battle.logic and Battle.logic:getLastRoadEventState() == "finished" and not is_playing_story() then
			return true
		end
	end), SPAWN(var_15_20(var_15_9), var_15_20(var_15_10), CALL(function()
		stop_or_remove(var_15_11, 1000)
	end)), COND_LOOP(SEQ(DELAY(100)), function()
		if not is_playing_story() then
			return true
		end
	end), CALL(BattleDropManager.collectDropItem, BattleDropManager)), arg_15_2, "battle.drop.intro")
	
	if not arg_15_0.items then
		arg_15_0.items = {}
	end
	
	local var_15_23 = arg_15_3.c or arg_15_3.count
	
	table.insert(arg_15_0.items, {
		code = arg_15_3.code,
		spr = arg_15_2,
		shadow = var_15_2,
		grade = var_15_14,
		count = var_15_23,
		intro_fx = var_15_9,
		loop_fx = var_15_10,
		origin_scale = arg_15_2:getScale(),
		make_tick = systick()
	})
end

function BattleDropManager.calcDroppedTime(arg_26_0)
	if not arg_26_0.items then
		arg_26_0.items = {}
	end
	
	local var_26_0 = LAST_TICK
	local var_26_1 = 0
	local var_26_2 = 3000
	
	for iter_26_0, iter_26_1 in pairs(arg_26_0.items) do
		local var_26_3 = var_26_2 - (var_26_0 - iter_26_1.make_tick)
		
		if var_26_1 < var_26_3 then
			var_26_1 = var_26_3
		end
	end
	
	for iter_26_2, iter_26_3 in pairs(arg_26_0.drop_golds or {}) do
		local var_26_4 = var_26_2 - (var_26_0 - iter_26_3.make_tick)
		
		if var_26_1 < var_26_4 then
			var_26_1 = var_26_4
		end
	end
	
	return var_26_1
end

function BattleDropManager.getPickupGoal(arg_27_0)
	local var_27_0 = BattleTopBar:getControl("icon_bag"):convertToWorldSpace({
		x = 0,
		y = 0
	})
	
	return var_27_0.x, var_27_0.y
end

function BattleDropManager.collectDropItem(arg_28_0, arg_28_1)
	if not arg_28_0.items then
		arg_28_0.items = {}
	end
	
	if not arg_28_1 and Battle.logic and Battle.logic:isEnded() then
		local var_28_0 = Battle.logic:getFinalResult()
		
		if var_28_0 and var_28_0 == "lose" then
			return 
		end
	end
	
	local function var_28_1(arg_29_0, arg_29_1, arg_29_2)
		SoundEngine:play("event:/battle/item_throw")
		
		if get_cocos_refid(arg_29_1.spr) then
			arg_29_1.spr:setScale(arg_29_1.origin_scale)
			arg_29_1.spr:setOpacity(255)
			
			local var_29_0 = DESIGN_HEIGHT * 0.9
			local var_29_1, var_29_2 = arg_29_1.spr:getPosition()
			
			BattleUIAction:Add(SEQ(SPAWN(RLOG(MOVE_TO(700, arg_29_1.spr:getPositionX(), var_29_0)), SEQ(DELAY(300), FADE_OUT(400), CALL(arg_29_0.addDropItem, arg_29_0, arg_29_1, arg_29_2), REMOVE()))), arg_29_1.spr, "battle.drop.collect")
			
			local var_29_3 = arg_29_1.shadow:getPositionY()
			
			BattleUIAction:Add(SEQ(SPAWN(RLOG(MOVE_TO(700, var_29_1, var_29_3)), FADE_OUT(700)), REMOVE()), arg_29_1.shadow, "battle.drop.collect")
			
			local var_29_4 = var_29_2 + arg_29_1.spr:getContentSize().height / 2
			local var_29_5 = arg_29_1.spr:getLocalZOrder()
			local var_29_6
			local var_29_7 = arg_29_1.g
			
			if var_29_7 and arg_29_0:getDropTrailName(var_29_7) then
				local var_29_8 = CACHE:getEffect(arg_29_0:getDropTrailName(var_29_7) .. ".particle")
				
				arg_29_1.spr:addChild(var_29_8)
				var_29_8:setAncestor(arg_29_1.spr:getParent())
				
				local var_29_9 = arg_29_1.spr:getContentSize()
				
				var_29_8:setPosition(var_29_9.width / 2, var_29_9.height / 2)
				var_29_8:setLocalZOrder(var_29_5 - 1)
				
				local function var_29_10(arg_30_0)
					arg_30_0:start()
					arg_30_0:setAutoRemoveOnFinish(true)
				end
				
				local function var_29_11(arg_31_0)
					arg_31_0:stop()
				end
				
				BattleUIAction:Add(SEQ(CALL(var_29_10, var_29_8), DELAY(700), CALL(var_29_11, var_29_8)), var_29_8, "battle.drop.collect")
			end
		end
	end
	
	local function var_28_2(arg_32_0, arg_32_1)
		if not arg_32_0 then
			return NONE()
		end
		
		return TARGET(arg_32_0, SEQ(OPACITY(arg_32_1, 0.5, 0), REMOVE()))
	end
	
	BattleUIAction:Remove("battle.drop.intro")
	
	local function var_28_3(arg_33_0, arg_33_1, arg_33_2)
		local var_33_0
		
		return CALL(var_28_1, arg_33_0, arg_33_1, arg_33_2) or NONE()
	end
	
	local var_28_4
	
	if arg_28_1 then
		if BattleUIAction:Find("battle.drop.fade_end") then
			BattleUIAction:Remove("battle.drop.fade_end")
		end
		
		for iter_28_0, iter_28_1 in pairs(arg_28_0.items) do
			if get_cocos_refid(iter_28_1.spr) then
				BattleUIAction:Add(SEQ(SPAWN(var_28_2(iter_28_1.intro_fx, 50), var_28_2(iter_28_1.loop_fx, 50)), var_28_3(arg_28_0, iter_28_1, iter_28_0)), iter_28_1.spr, "battle.drop.collect")
			end
		end
	else
		var_28_4 = 0
		
		for iter_28_2, iter_28_3 in pairs(arg_28_0.items) do
			var_28_4 = var_28_4 + 1
			
			if get_cocos_refid(iter_28_3.spr) then
				iter_28_3.spr:setScale(iter_28_3.origin_scale)
				BattleUIAction:Add(SEQ(DELAY(200 * var_28_4), SPAWN(var_28_2(iter_28_3.intro_fx, 500), var_28_2(iter_28_3.loop_fx, 500)), var_28_3(arg_28_0, iter_28_3, iter_28_2)), iter_28_3.spr, "battle.drop.fade_end")
			end
		end
	end
	
	arg_28_0:collectGoldItem(arg_28_1)
end

function BattleDropManager.getDropedCount(arg_34_0)
	return arg_34_0.box_count or 0
end

function BattleDropManager.addDropItem(arg_35_0, arg_35_1, arg_35_2)
	if arg_35_2 then
		arg_35_0.items[arg_35_2] = nil
	end
	
	SoundEngine:play("event:/battle/item_get")
	BattleTopBar:shakeBackpack(arg_35_1)
	arg_35_0:restore(Battle:forecastReward(Battle.logic))
	BattleTopBar:updateNotifications()
	BattleMapManager:updateInvenCounts()
	Dialog:ShowRareDrop(arg_35_1)
	BattleMapManager:reloadInventory()
end

function BattleDropManager.setVisible(arg_36_0, arg_36_1)
	if not arg_36_0.items then
		arg_36_0.items = {}
	end
	
	if not arg_36_0.drop_golds then
		arg_36_0.drop_golds = {}
	end
	
	for iter_36_0, iter_36_1 in pairs(arg_36_0.items) do
		if get_cocos_refid(iter_36_1.spr) then
			iter_36_1.spr:setVisible(arg_36_1)
		end
		
		if get_cocos_refid(iter_36_1.intro_fx) then
			iter_36_1.intro_fx:setVisible(arg_36_1)
		end
		
		if get_cocos_refid(iter_36_1.loop_fx) then
			iter_36_1.loop_fx:setVisible(arg_36_1)
		end
		
		if get_cocos_refid(iter_36_1.shadow) then
			iter_36_1.shadow:setVisible(arg_36_1)
		end
	end
	
	for iter_36_2, iter_36_3 in pairs(arg_36_0.drop_golds) do
		if get_cocos_refid(iter_36_3.model) then
			iter_36_3.model:setVisible(arg_36_1)
		end
	end
end

function BattleDropManager.getDropTrailName(arg_37_0, arg_37_1)
	if not arg_37_1 then
		return 
	end
	
	return ({
		"grade_common_trail",
		"grade_uncommon_trail",
		"grade_rare_trail",
		"grade_hero_trail",
		"grade_legend_trail",
		to_crystal = "crystal_trail"
	})[arg_37_1]
end

function BattleDropManager.getBoxTrailName(arg_38_0, arg_38_1)
	if not arg_38_1 then
		return 
	end
	
	return ({
		[0] = "grade_box_magic",
		"grade_common",
		"grade_box_uncommon",
		"grade_box_rare",
		"grade_box_hero",
		"grade_box_legend",
		to_crystal = "crystal"
	})[arg_38_1]
end

function BattleDropManager.similarDropItem(arg_39_0, arg_39_1, arg_39_2)
	if not arg_39_2 then
		return 
	end
	
	local var_39_0, var_39_1 = arg_39_0:getItemSprite(arg_39_2)
	local var_39_2, var_39_3 = arg_39_1:getPosition()
	
	var_39_0:setScale(WIDGET_SCALE_FACTOR * (var_39_1 or 1))
	var_39_0:setPosition(var_39_2, var_39_3)
	arg_39_1:getParent():addChild(var_39_0)
	
	local var_39_4 = arg_39_2.g
	local var_39_5 = arg_39_0:getBoxTrailName(var_39_4 or 0)
	
	if not var_39_5 or arg_39_2.code == "to_crystal" then
		var_39_5 = arg_39_0:getBoxTrailName(arg_39_2.code)
	end
	
	local var_39_6 = var_39_0:getContentSize()
	local var_39_7
	
	if var_39_5 then
		var_39_7 = CACHE:getEffect(var_39_5 .. "_trail.particle")
		
		if var_39_7 then
			var_39_0:addChild(var_39_7)
			var_39_7:setPosition(var_39_6.width / 2, var_39_6.height / 2)
			var_39_7:setLocalZOrder(var_39_0:getLocalZOrder() + 1)
			var_39_7:setAncestor(var_39_0:getParent())
		end
	end
	
	local var_39_8
	
	if var_39_5 then
		var_39_8 = CACHE:getEffect(var_39_5 .. "_back.particle")
		
		if var_39_8 then
			var_39_0:addChild(var_39_8)
			var_39_8:setPosition(var_39_6.width / 2, var_39_6.height / 2)
			var_39_8:setLocalZOrder(var_39_0:getLocalZOrder() - 1)
			var_39_8:setAncestor(var_39_0:getParent())
		end
	end
	
	local function var_39_9(arg_40_0)
		if not arg_40_0 then
			return 
		end
		
		arg_40_0:start()
		arg_40_0:setAutoRemoveOnFinish(true)
	end
	
	local function var_39_10(arg_41_0)
		if not arg_41_0 then
			return 
		end
		
		arg_41_0:stop()
	end
	
	var_39_0:setOpacity(0)
	BattleUIAction:Add(SEQ(CALL(var_39_9, var_39_7), CALL(var_39_9, var_39_8), SPAWN(LOG(MOVE_TO(600, var_39_2, DESIGN_HEIGHT * 0.62)), LOG(FADE_IN(100))), MOVE_TO(900, var_39_2, DESIGN_HEIGHT * 0.56), SPAWN(RLOG(MOVE_TO(800, var_39_2, DESIGN_HEIGHT * 0.9)), RLOG(FADE_OUT(800))), CALL(arg_39_0.addDropItem, arg_39_0, arg_39_2), CALL(var_39_10, var_39_7), CALL(var_39_10, var_39_8), DELAY(2600), REMOVE()), var_39_0, "battle.similardrop")
end

function BattleDropManager.dropReward(arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4)
	for iter_42_0, iter_42_1 in pairs(arg_42_4) do
		if type(iter_42_1) == "table" then
			for iter_42_2, iter_42_3 in pairs(iter_42_1) do
				if iter_42_3.code == "to_gold" then
					arg_42_0:dropGoldItem(arg_42_1, arg_42_2, arg_42_3, iter_42_3)
					SoundEngine:play("event:/ui/gold")
				else
					arg_42_0:dropItem(arg_42_1, arg_42_2, arg_42_3, iter_42_3)
					SoundEngine:play("event:/battle/item_drop")
				end
			end
		end
	end
end

function BattleDropManager.takeReward(arg_43_0, arg_43_1, arg_43_2)
	for iter_43_0, iter_43_1 in pairs(arg_43_2) do
		if type(iter_43_1) == "table" then
			for iter_43_2, iter_43_3 in pairs(iter_43_1) do
				arg_43_0:similarDropItem(arg_43_1, iter_43_3)
			end
		end
	end
end

function BattleDropManager.showBaseDrops(arg_44_0, arg_44_1)
	if not arg_44_1 or #arg_44_1 < 1 then
		return 
	end
	
	if not get_cocos_refid(BGI.ui_layer) then
		return 
	end
	
	local var_44_0 = load_control("wnd/get_item_eff.csb")
	
	BGI.ui_layer:addChild(var_44_0)
	
	local var_44_1 = #arg_44_1
	local var_44_2 = var_44_1 % 2 == 1
	
	if_set_visible(var_44_0, "n_odd", var_44_2)
	if_set_visible(var_44_0, "n_even", not var_44_2)
	
	local var_44_3 = var_44_2 and "n_odd" or "n_even"
	local var_44_4 = var_44_0:getChildByName(var_44_3)
	
	if get_cocos_refid(var_44_4) then
		for iter_44_0 = 1, 5 do
			local var_44_5 = arg_44_1[iter_44_0]
			local var_44_6 = var_44_4:getChildByName(tostring(iter_44_0))
			
			if get_cocos_refid(var_44_6) then
				if iter_44_0 <= var_44_1 and var_44_5 then
					var_44_6:setVisible(true)
					
					local var_44_7 = var_44_5.code
					local var_44_8 = var_44_5.count
					local var_44_9 = var_44_6:getChildByName("icon") or var_44_6
					
					UIUtil:getRewardIcon(var_44_8, var_44_7, {
						no_count = true,
						no_frame = true,
						no_tooltip = true,
						parent = var_44_9
					})
					if_set(var_44_6, "txt_count", string.format("+%d", to_n(var_44_8)))
				else
					var_44_6:setVisible(false)
				end
			end
		end
	end
	
	var_44_0:setOpacity(0)
	BattleUIAction:Add(SEQ(FADE_IN(300), DELAY(800), FADE_OUT(300), REMOVE()), var_44_0, "battle.base_drops")
end
