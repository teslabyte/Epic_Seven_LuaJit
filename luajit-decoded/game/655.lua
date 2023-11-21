LotaUtil = {}
LotaUtil.MovablePaths = {
	{
		x = 1,
		y = 1
	},
	{
		x = 2,
		y = 0
	},
	{
		x = 1,
		y = -1
	},
	{
		x = -1,
		y = 1
	},
	{
		x = -2,
		y = 0
	},
	{
		x = -1,
		y = -1
	}
}
LotaUtil.InverseMovablePathIndex = {
	6,
	5,
	4,
	3,
	2,
	1
}

function LotaUtil.getMultiplyPosition(arg_1_0, arg_1_1, arg_1_2)
	return {
		x = arg_1_1.x * arg_1_2,
		y = arg_1_1.y * arg_1_2
	}
end

function LotaUtil.getAddedPosition(arg_2_0, arg_2_1, arg_2_2)
	return {
		x = arg_2_1.x + arg_2_2.x,
		y = arg_2_1.y + arg_2_2.y
	}
end

function LotaUtil.getDecedPosition(arg_3_0, arg_3_1, arg_3_2)
	return {
		x = arg_3_1.x - arg_3_2.x,
		y = arg_3_1.y - arg_3_2.y
	}
end

function LotaUtil.getAbsPosition(arg_4_0, arg_4_1)
	return {
		x = math.abs(arg_4_1.x),
		y = math.abs(arg_4_1.y)
	}
end

function LotaUtil.getNormalVector(arg_5_0, arg_5_1)
	local var_5_0 = math.sqrt(math.pow(arg_5_1.x, 2) + math.pow(arg_5_1.y, 2))
	
	return {
		x = arg_5_1.x / var_5_0,
		y = arg_5_1.y / var_5_0
	}
end

function LotaUtil.isSamePosition(arg_6_0, arg_6_1, arg_6_2)
	if not arg_6_1 or not arg_6_2 then
		return false
	end
	
	return arg_6_1.x == arg_6_2.x and arg_6_1.y == arg_6_2.y
end

function LotaUtil.calcTilePosToWorldPos(arg_7_0, arg_7_1)
	local var_7_0 = LotaWhiteboard:get("tile_width")
	local var_7_1 = LotaWhiteboard:get("tile_height")
	local var_7_2 = var_7_0 / 2
	local var_7_3 = var_7_1 / 2
	
	return {
		x = arg_7_1.x * var_7_2,
		y = var_7_3 * arg_7_1.y
	}
end

function LotaUtil.getPosToHashKey(arg_8_0, arg_8_1)
	return arg_8_1.x .. "/" .. arg_8_1.y
end

function LotaUtil.getTileCost(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0:getDecedPosition(arg_9_2, arg_9_1)
	local var_9_1 = arg_9_0:getAbsPosition(var_9_0)
	local var_9_2 = math.min(var_9_1.x, var_9_1.y)
	local var_9_3 = var_9_2
	local var_9_4 = var_9_1.x - var_9_2
	
	if var_9_4 > 0 then
		var_9_3 = var_9_3 + math.floor(var_9_4 / 2)
	end
	
	local var_9_5 = var_9_1.y - var_9_2
	
	if var_9_5 > 0 then
		var_9_3 = var_9_3 + var_9_5
	end
	
	return var_9_3
end

function LotaUtil.getTileRect(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = {}
	
	for iter_10_0 = 0, arg_10_3 - 1 do
		local var_10_1 = arg_10_1.y + (iter_10_0 - math.floor(arg_10_3 / 2))
		local var_10_2 = arg_10_1.x + -(arg_10_2 / 2)
		local var_10_3 = arg_10_2 / 2 - 1
		
		if math.abs(var_10_1 % 2) ~= math.abs(arg_10_1.y % 2) then
			if math.abs(var_10_2 % 2) == math.abs(arg_10_1.x % 2) then
				var_10_2 = var_10_2 - 1
			end
			
			var_10_3 = var_10_3 + 1
		elseif math.abs(var_10_2 % 2) ~= math.abs(arg_10_1.x % 2) then
			var_10_2 = var_10_2 + 1
		end
		
		for iter_10_1 = 0, var_10_3 do
			local var_10_4 = iter_10_1 * 2 + var_10_2
			
			table.insert(var_10_0, {
				x = var_10_4,
				y = var_10_1
			})
		end
	end
	
	return var_10_0
end

LOTA_FORCE_NOT_USE_IMAGE_PRELOAD = false

function LotaUtil.isUsePreload(arg_11_0)
	return LOTA_FORCE_NOT_USE_IMAGE_PRELOAD
end

function LotaUtil.getDiscoverRange(arg_12_0, arg_12_1, arg_12_2)
	if arg_12_2 == 0 then
		return {
			arg_12_1
		}
	end
	
	local var_12_0 = {}
	
	for iter_12_0 = 1, 6 do
		var_12_0[iter_12_0] = arg_12_0:getMultiplyPosition(arg_12_0.MovablePaths[iter_12_0], arg_12_2)
	end
	
	local var_12_1 = arg_12_0:getAddedPosition(var_12_0[4], arg_12_1)
	local var_12_2 = arg_12_0:getAddedPosition(var_12_0[1], arg_12_1)
	local var_12_3 = arg_12_0:getAddedPosition(var_12_0[5], arg_12_1)
	local var_12_4 = arg_12_0:getAddedPosition(var_12_0[2], arg_12_1)
	local var_12_5 = arg_12_0:getAddedPosition(var_12_0[6], arg_12_1)
	local var_12_6 = arg_12_0:getAddedPosition(var_12_0[3], arg_12_1)
	local var_12_7 = var_12_2.x - var_12_1.x
	local var_12_8 = var_12_4.x - var_12_3.x
	local var_12_9 = {}
	
	for iter_12_1 = var_12_7, var_12_8, 2 do
		local var_12_10 = (iter_12_1 - var_12_7) / 2
		local var_12_11 = var_12_1.x - var_12_10
		local var_12_12 = var_12_1.y - var_12_10
		local var_12_13 = var_12_5.x - var_12_10
		local var_12_14 = var_12_5.y + var_12_10
		
		for iter_12_2 = 0, iter_12_1, 2 do
			table.insert(var_12_9, {
				x = var_12_11 + iter_12_2,
				y = var_12_12
			})
			table.insert(var_12_9, {
				x = var_12_13 + iter_12_2,
				y = var_12_14
			})
		end
	end
	
	for iter_12_3 = 0, var_12_8, 2 do
		table.insert(var_12_9, {
			x = var_12_3.x + iter_12_3,
			y = var_12_3.y
		})
	end
	
	return var_12_9
end

function LotaUtil.createDebugLabel(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6)
	local var_13_0 = create_label(arg_13_2)
	
	arg_13_4 = arg_13_4 or cc.c4b(0, 0, 0, 150)
	
	local var_13_1 = arg_13_1 .. "_label"
	
	if arg_13_5 then
		var_13_1 = "label"
	end
	
	local var_13_2 = cc.LayerColor:create(arg_13_4)
	
	var_13_0:setName(var_13_1)
	var_13_2:setContentSize(arg_13_3)
	var_13_2:addChild(var_13_0)
	var_13_2:setName(arg_13_1)
	var_13_2:setCascadeOpacityEnabled(arg_13_6 or false)
	var_13_0:setPosition(arg_13_3.width / 2, arg_13_3.height / 2)
	
	return var_13_2
end

function LotaUtil.getLegacyIcon(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = arg_14_1:getID()
	
	if get_cocos_refid(arg_14_2) and arg_14_2.legacy_id ~= var_14_0 then
		arg_14_2:removeFromParent()
		
		arg_14_2 = nil
	end
	
	arg_14_2 = arg_14_2 or arg_14_0:getUIControl("clan_heritage_legacy_icon")
	
	local var_14_1 = "legacy_frame_0"
	local var_14_2 = arg_14_1:getGrade() or 1
	local var_14_3 = "legacy/" .. var_14_1 .. var_14_2 .. ".png"
	
	if_set_sprite(arg_14_2, "frame", var_14_3)
	
	local var_14_4 = "legacy/" .. arg_14_1:getIcon() .. ".png"
	
	if_set_sprite(arg_14_2, "legacy_icon", var_14_4)
	
	local var_14_5 = arg_14_1:getDuration()
	
	if arg_14_2 and var_14_5 then
		local var_14_6 = arg_14_1:getUseCount()
		local var_14_7 = arg_14_2:findChildByName("n_duration")
		
		if_set_visible(var_14_7, nil, true)
		if_set(var_14_7, "t_duration", tostring(arg_14_1:getRemainCount()))
		
		if arg_14_3 then
			local var_14_8 = arg_14_2:findChildByName("n_duration_s")
			
			var_14_7:setScale(var_14_8:getScale())
			var_14_7:setPosition(var_14_8:getPosition())
		end
	end
	
	if arg_14_3 then
		WidgetUtils:setupTooltip({
			req_stop_propagation = true,
			control = arg_14_2,
			creator = function()
				local var_15_0 = arg_14_0:getLegacyTooltip(arg_14_1)
				
				var_15_0:setName("popup_legacy_tooltip")
				
				return var_15_0
			end,
			call_by_show = function(arg_16_0, arg_16_1, arg_16_2)
				local var_16_0 = LotaUserData:getArtifactItemById(arg_16_1.legacy_id)
				
				if var_16_0 and var_16_0:getDuration() then
					local var_16_1 = arg_16_0:findChildByName("n_duration")
					
					if_set_visible(var_16_1, nil, true)
					if_set(var_16_1, "t_duration", tostring(var_16_0:getRemainCount()))
				end
			end
		})
	end
	
	arg_14_2.legacy_id = var_14_0
	
	return arg_14_2
end

function LotaUtil.updateLegacyTooltip(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	arg_17_3 = arg_17_3 or {}
	
	local var_17_0 = arg_17_3.n_detail_name or "n_detail"
	local var_17_1 = arg_17_1:findChildByName(var_17_0)
	local var_17_2 = arg_17_1:findChildByName("frame")
	
	if not get_cocos_refid(var_17_2) or not get_cocos_refid(var_17_1) then
		return 
	end
	
	local var_17_3 = 222
	local var_17_4 = var_17_2:getScaleY()
	
	if not arg_17_3.dont_pos and not var_17_2.org_h then
		var_17_2.org_h = var_17_2:getContentSize().height * var_17_4
	end
	
	local var_17_5 = var_17_1:findChildByName("n_head")
	local var_17_6 = arg_17_2:getGrade()
	local var_17_7 = ({
		"#888888",
		"#387A14",
		"#3B7BEF",
		"#CA37D3",
		"#FF301A"
	})[var_17_6]
	local var_17_8 = EQUIP.getGradeText(nil, var_17_6)
	local var_17_9 = var_17_1:findChildByName("n_grade")
	
	var_17_9:removeAllChildren()
	
	local var_17_10 = {
		"_itembg_legacy_1.png",
		"_itembg_legacy_2.png",
		"_itembg_legacy_3.png",
		"_itembg_legacy_4.png",
		"_itembg_legacy_5.png"
	}
	
	var_17_9:addChild(SpriteCache:getSprite("img/" .. var_17_10[var_17_6]))
	if_set(var_17_5, "txt_grade", var_17_8)
	if_set_color(var_17_5, "txt_grade", tocolor(var_17_7))
	
	local var_17_11 = var_17_5:findChildByName("n_legacy_icon")
	
	var_17_11:removeAllChildren()
	
	local var_17_12 = arg_17_0:getLegacyIcon(arg_17_2)
	
	var_17_12:setAnchorPoint(0.5, 0.5)
	var_17_11:addChild(var_17_12)
	
	local var_17_13 = var_17_5:findChildByName("txt_name")
	
	if get_cocos_refid(var_17_13) then
		if_set(var_17_13, nil, T(arg_17_2:getName()))
		
		var_17_3 = var_17_3 + var_17_13:getTextBoxSize().height * var_17_13:getScaleY() + 17
	end
	
	local var_17_14 = var_17_1:findChildByName("n_disc")
	
	if get_cocos_refid(var_17_14) then
		if not arg_17_3.dont_pos then
			var_17_14:setPositionY(var_17_2.org_h - var_17_3 * var_17_4)
		end
		
		local var_17_15 = var_17_14:findChildByName("txt_legacy_info")
		
		if get_cocos_refid(var_17_15) then
			if_set(var_17_15, nil, T(arg_17_2:getDesc()))
			
			var_17_3 = var_17_3 + var_17_15:getTextBoxSize().height * var_17_15:getScaleY() + 60
		end
	end
	
	if not arg_17_3.dont_pos and not arg_17_3.dont_size then
		var_17_2:setAnchorPoint(0, 1)
		var_17_2:setPosition(0, var_17_2.org_h)
		var_17_2:setContentSize(var_17_2:getContentSize().width, var_17_3)
	end
end

function HANDLER.clan_heritage_battle_ready_reward_info(arg_18_0, arg_18_1)
	if arg_18_1 == "btn_close" then
		LotaUtil:closeRewardPreviewDlg()
	end
end

function LotaUtil.closeRewardPreviewDlg(arg_19_0)
	local var_19_0 = SceneManager:getRunningNativeScene():findChildByName("clan_heritage_battle_ready_reward_info")
	
	if not var_19_0 then
		return 
	end
	
	BackButtonManager:pop("lota_reward_preview_dlg")
	var_19_0:removeFromParent()
end

function LotaUtil.openRewardPreviewDlg(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_0:getUIDlg("clan_heritage_battle_ready_reward_info")
	
	BackButtonManager:push({
		check_id = "lota_reward_preview_dlg",
		back_func = function()
			LotaUtil:closeRewardPreviewDlg()
		end
	})
	
	local var_20_1
	
	if arg_20_1 then
		var_20_1 = LotaUtil:getRewardData(arg_20_1, arg_20_2)
		
		for iter_20_0 = 1, 10 do
			local var_20_2 = var_20_1[iter_20_0]
			local var_20_3 = var_20_0:findChildByName("n_item" .. tostring(iter_20_0))
			
			if var_20_2 then
				local var_20_4 = {
					dlg_name = "battle_ready",
					scale = 1,
					grade_max = true,
					set_drop = var_20_2.set_rate,
					grade_rate = var_20_2.grade_rate
				}
				
				if string.starts(var_20_2.item_id, "e") and DB("equip_item", var_20_2.item_id, "type") == "artifact" then
					var_20_4.scale = 0.78
				end
				
				local var_20_5 = UIUtil:getRewardIcon(var_20_2.count, var_20_2.item_id, var_20_4)
				
				var_20_3:addChild(var_20_5)
			end
		end
	end
	
	SceneManager:getRunningNativeScene():addChild(var_20_0)
end

function LotaUtil.getLevelupRequirePoint(arg_22_0, arg_22_1)
	if not arg_22_1 then
		return 
	end
	
	local var_22_0 = LotaUserData:getRoleLevelWithoutArtifactByRole(arg_22_1) + 1
	local var_22_1 = LotaUtil:getRoleStatId(arg_22_1, var_22_0)
	
	return (DB("clan_heritage_role_stat_data", var_22_1, "need_point"))
end

function LotaUtil.getLegacyTooltip(arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0:getUIControl("clan_heritage_legacy_tooltip")
	
	arg_23_0:updateLegacyTooltip(var_23_0, arg_23_1)
	
	return var_23_0
end

function LotaUtil.replaceBackgroundByJobLevel(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_1:findChildByName("bg")
	local var_24_1
	
	if arg_24_2 then
		if arg_24_2 >= 13 then
			var_24_1 = "heritage_slot5.png"
		elseif arg_24_2 >= 10 then
			var_24_1 = "heritage_slot4.png"
		elseif arg_24_2 >= 7 then
			var_24_1 = "heritage_slot3.png"
		elseif arg_24_2 >= 4 then
			var_24_1 = "heritage_slot2.png"
		end
	end
	
	if var_24_1 and get_cocos_refid(var_24_0) then
		local var_24_2 = "img/" .. var_24_1
		
		SpriteCache:resetSprite(var_24_0, var_24_2)
	end
end

function LotaUtil.makeVignetting(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = cc.Node:create()
	
	var_25_0:setPosition(arg_25_1, arg_25_2)
	var_25_0:setCascadeOpacityEnabled(true)
	var_25_0:setOpacity(0)
	var_25_0:setLocalZOrder(-1)
	
	local var_25_1 = cc.Sprite:create("img/vignetting3.png")
	
	var_25_1:setScale(4)
	var_25_1:setColor(cc.c3b(0, 0, 0))
	var_25_0:addChild(var_25_1)
	
	local var_25_2 = var_25_1:getContentSize()
	local var_25_3 = var_25_2.width * var_25_1:getScale()
	local var_25_4 = var_25_2.height * var_25_1:getScale()
	local var_25_5 = var_25_3 / 2
	local var_25_6 = var_25_4 / 2
	local var_25_7 = 2000
	local var_25_8 = 2000
	local var_25_9 = {
		{
			dir = "left",
			ay = 0,
			ax = 1,
			w = var_25_7,
			h = var_25_4 + var_25_8,
			x = -var_25_5,
			y = -var_25_6,
			c = cc.c3b(0, 0, 0)
		},
		{
			dir = "top",
			ay = 0,
			ax = 0,
			w = var_25_7 + var_25_3,
			h = var_25_8,
			x = -var_25_5,
			y = var_25_6,
			c = cc.c3b(0, 0, 0)
		},
		{
			dir = "bot",
			ay = 1,
			ax = 1,
			w = var_25_7 + var_25_3,
			h = var_25_8,
			x = var_25_5,
			y = -var_25_6,
			c = cc.c3b(0, 0, 0)
		},
		{
			dir = "right",
			ay = 1,
			ax = 0,
			w = var_25_7,
			h = var_25_4 + var_25_8,
			x = var_25_5,
			y = var_25_6,
			c = cc.c3b(0, 0, 0)
		}
	}
	
	for iter_25_0, iter_25_1 in pairs(var_25_9) do
		local var_25_10 = cc.LayerColor:create(iter_25_1.c)
		
		var_25_10:setScale(1)
		var_25_10:setContentSize(iter_25_1.w, iter_25_1.h)
		var_25_10:setPosition(iter_25_1.x, iter_25_1.y)
		var_25_10:setAnchorPoint(iter_25_1.ax, iter_25_1.ay)
		var_25_10:ignoreAnchorPointForPosition(false)
		var_25_0:addChild(var_25_10)
	end
	
	return var_25_0
end

function LotaUtil.makeCompleteDlg(arg_26_0, arg_26_1)
	local var_26_0 = LotaUtil:getUIDlg("clan_heritage_enhancement_complete")
	local var_26_1 = var_26_0:findChildByName("ext")
	
	arg_26_0:settingStatNames(var_26_1)
	
	local var_26_2 = LotaUserData:getRoleLevelWithoutArtifactByRole(arg_26_1)
	
	arg_26_0:settingStats(var_26_1:findChildByName("n_stats"), arg_26_1, var_26_2, var_26_2 - 1)
	
	local var_26_3 = var_26_0:findChildByName("n_lv")
	local var_26_4 = var_26_0:findChildByName("job_icon")
	local var_26_5 = "img/" .. CollectionUtil.ROLE_COMP_TO_KEY_DATA_ICON[arg_26_1]
	
	SpriteCache:resetSprite(var_26_4, var_26_5)
	arg_26_0:replaceBackgroundByJobLevel(var_26_0, var_26_2)
	
	local var_26_6, var_26_7 = UIUtil:setLevel(var_26_3, var_26_2, 15, 2)
	
	if var_26_7 then
		if_set_position_x(var_26_3, "tag_lv", 22)
		if_set_position_x(var_26_3, "max", 81)
	else
		if_set_position_x(var_26_3, "tag_lv", var_26_6 < 2 and 57 or 43)
	end
	
	EffectManager:Play({
		fn = "ui_reward_popup_eff.cfx",
		delay = 0,
		pivot_z = 99998,
		layer = var_26_0,
		pivot_x = VIEW_WIDTH / 2 + VIEW_BASE_LEFT,
		pivot_y = VIEW_HEIGHT / 2 + 200
	})
	
	return var_26_0
end

function LotaUtil.makeMsgRewardsParam(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	local var_27_0
	local var_27_1 = {
		title = T(arg_27_2),
		desc = T(arg_27_3)
	}
	local var_27_2 = arg_27_1.artifact_effects
	local var_27_3 = false
	local var_27_4, var_27_5 = LotaUtil:getPrvAndNewLv(arg_27_1.exp)
	
	if arg_27_1.exp then
		var_27_3 = LotaUserData:isLevelUpExp(arg_27_1.exp)
	end
	
	if arg_27_1.rewards then
		local var_27_6 = Account:addReward(arg_27_1.rewards, {
			is_no_reward_popup = true,
			play_reward_data = var_27_1
		})
		
		ConditionContentsManager:queryUpdateConditions("h:lota_production")
		
		local var_27_7 = var_27_6.data_for_rewards_dlg or {
			title = var_27_1.title,
			desc = var_27_1.desc,
			rewards = {}
		}
		
		if arg_27_1.exp then
			LotaUtil:addExpToRewards(arg_27_1.exp, var_27_7.rewards, nil, arg_27_1.artifact_effects, "object")
			
			if arg_27_4 then
				LotaUserData:updateExp(arg_27_1.exp, true)
			end
		end
		
		if var_27_2 and to_n(var_27_2.use_treasure_box_add_coin) > 0 then
			for iter_27_0, iter_27_1 in pairs(var_27_7.rewards) do
				if iter_27_1.token == "clanheritagecoin" then
					iter_27_1.lota_arti_bonus = to_n(var_27_2.use_treasure_box_add_coin)
				end
			end
		end
		
		if table.count(var_27_7.rewards) > 0 then
			var_27_0 = var_27_7
		end
	elseif arg_27_1.exp then
		local var_27_8 = {
			title = var_27_1.title,
			desc = var_27_1.desc,
			rewards = {}
		}
		
		LotaUtil:addExpToRewards(arg_27_1.exp, var_27_8.rewards, nil, arg_27_1.artifact_effects, "object")
		
		if arg_27_4 then
			LotaUserData:updateExp(arg_27_1.exp, true)
		end
		
		if table.count(var_27_8.rewards) > 0 then
			var_27_0 = var_27_8
		end
	end
	
	if arg_27_1.action_point then
		local var_27_9 = var_27_0 or {
			title = var_27_1.title,
			desc = var_27_1.desc,
			rewards = {}
		}
		
		LotaUtil:addActionPointToRewards(arg_27_1.action_point, var_27_4, var_27_5, var_27_9.rewards)
		
		if not table.empty(var_27_9.rewards) then
			var_27_0 = var_27_9
		end
	end
	
	if LotaUserData:getRolePointDiffValue() > 0 then
		local var_27_10 = LotaUserData:getRolePointDiffValue()
		
		if var_27_3 then
			var_27_10 = var_27_10 - LotaUserData:getBenefitMatPoint(arg_27_1.exp)
		end
		
		if var_27_10 > 0 then
			local var_27_11 = var_27_0 or {
				title = var_27_1.title,
				desc = var_27_1.desc,
				rewards = {}
			}
			
			LotaUtil:addRolePointToRewards(var_27_11.rewards)
			
			if not table.empty(var_27_11.rewards) then
				var_27_0 = var_27_11
			end
			
			if var_27_2 and to_n(var_27_2.use_event_add_roleup_point) > 0 then
				for iter_27_2, iter_27_3 in pairs(var_27_0.rewards) do
					if iter_27_3.item and iter_27_3.item.code == "ma_heritage_job" then
						iter_27_3.lota_arti_bonus = to_n(var_27_2.use_event_add_roleup_point)
					end
				end
			end
		end
	end
	
	return var_27_0, var_27_1
end

function LotaUtil.makeMsgRewards(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	function arg_28_1.handler(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
		if arg_28_3.exp then
			LotaUserData:procLevelUp()
		end
	end
	
	local var_28_0 = Dialog:msgRewards(arg_28_1.desc, arg_28_1)
	
	if_set(var_28_0, "txt_title", arg_28_2.title)
	
	return var_28_0
end

function LotaUtil.addActionPointToRewardsByCount(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	if arg_30_2 > 0 then
		if arg_30_3 then
			table.insert(arg_30_1, {
				code = "clanheritage",
				count = arg_30_2
			})
		else
			table.insert(arg_30_1, {
				token = "to_clanheritage",
				count = arg_30_2
			})
		end
	end
end

function LotaUtil.getPrvAndNewLv(arg_31_0, arg_31_1)
	local var_31_0 = LotaUserData:getUserLevel()
	local var_31_1 = var_31_0
	
	arg_31_1 = to_n(arg_31_1)
	
	if arg_31_1 ~= 0 then
		var_31_1 = LotaUtil:getUserLevel(arg_31_1)
	end
	
	return var_31_0, var_31_1
end

function LotaUtil.getRechargeToken(arg_32_0, arg_32_1, arg_32_2)
	local var_32_0 = to_n(arg_32_2) - to_n(arg_32_1)
	local var_32_1 = 0
	
	for iter_32_0 = 1, var_32_0 do
		local var_32_2 = arg_32_1 + iter_32_0
		
		var_32_1 = var_32_1 + DB("clan_heritage_rank_data", tostring(var_32_2), "recharge_token")
	end
	
	return var_32_1
end

function LotaUtil.getDiffActionPoint(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
	local var_33_0 = arg_33_0:getRechargeToken(arg_33_3, arg_33_4)
	
	return tonumber(arg_33_1) - tonumber(arg_33_2) - var_33_0
end

function LotaUtil.addActionPointToRewards(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5)
	if arg_34_1 then
		local var_34_0 = arg_34_0:getDiffActionPoint(arg_34_1, LotaUserData:getActionPoint(), arg_34_2, arg_34_3)
		
		arg_34_0:addActionPointToRewardsByCount(arg_34_4, var_34_0, arg_34_5)
	end
end

function LotaUtil.addRolePointToRewards(arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
	arg_35_2 = arg_35_2 or LotaUserData:getRolePointDiffValue()
	
	if arg_35_3 and LotaUserData:isLevelUpExp(arg_35_3) then
		arg_35_2 = arg_35_2 - LotaUserData:getBenefitMatPoint(arg_35_3)
	end
	
	if arg_35_2 > 0 then
		if arg_35_4 then
			table.insert(arg_35_1, {
				code = "ma_heritage_job",
				count = arg_35_2
			})
		else
			table.insert(arg_35_1, {
				item = {
					code = "ma_heritage_job",
					diff = arg_35_2
				},
				count = arg_35_2
			})
		end
	end
end

function LotaUtil.getJobLevelDiff(arg_36_0, arg_36_1, arg_36_2, arg_36_3)
	local var_36_0 = arg_36_2
	local var_36_1 = table.clone(arg_36_1 or {})
	
	for iter_36_0, iter_36_1 in pairs(var_36_1) do
		if var_36_0[iter_36_0] ~= iter_36_1 and iter_36_0 ~= "mat" then
			if arg_36_3 and arg_36_3(iter_36_1 or 1, var_36_0[iter_36_0] or 1) then
				return iter_36_0, iter_36_1 or 1
			elseif not arg_36_3 then
				return iter_36_0, iter_36_1 or 1
			end
		end
	end
end

function LotaUtil.getEventRewardInfo(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
	local var_37_0 = {}
	local var_37_1, var_37_2 = arg_37_0:getJobLevelDiff(arg_37_3.job_levels, arg_37_2.job_levels, function(arg_38_0, arg_38_1)
		return arg_38_1 < arg_38_0
	end)
	
	if var_37_1 then
		local var_37_3 = arg_37_2.job_levels[var_37_1]
		
		if not var_37_3 or var_37_3 < var_37_2 then
			var_37_0.job_levels = {
				role = var_37_1,
				lv = var_37_2
			}
		end
	end
	
	if arg_37_1 then
		var_37_0.rewards = arg_37_1
	end
	
	if arg_37_2.exp and LotaUserData:getExp() > arg_37_2.exp then
		var_37_0.exp = LotaUserData:getExp()
	end
	
	if table.empty(var_37_0) then
		return 
	end
	
	return var_37_0
end

function LotaUtil.getEventPenaltyInfo(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
	local var_39_0 = {}
	
	if arg_39_1.penalty_condition == "battle_clan_object" then
	elseif arg_39_1.penalty_condition == "hero_disable_count" then
		local var_39_1 = arg_39_3.user_registration_data
		local var_39_2 = arg_39_2.user_registration_data
		
		if not var_39_1 then
			var_39_0.hero_disable_count = {
				data = "no_data"
			}
		else
			local var_39_3 = {}
			
			for iter_39_0, iter_39_1 in pairs(var_39_1) do
				if var_39_2[iter_39_0] and var_39_2[iter_39_0] ~= iter_39_1 then
					table.insert(var_39_3, iter_39_0)
				end
			end
			
			if table.count(var_39_3) > 0 then
				var_39_0.hero_disable_count = {
					data = var_39_3
				}
			else
				var_39_0.hero_disable_count = {
					data = "not_disable_exist"
				}
			end
		end
	elseif arg_39_1.penalty_condition == "add_consumption_token" then
		local var_39_4, var_39_5 = LotaUtil:getPrvAndNewLv(arg_39_3.exp)
		local var_39_6 = LotaUtil:getRechargeToken(var_39_4, var_39_5)
		local var_39_7 = arg_39_3.action_point
		local var_39_8 = arg_39_2.action_point
		local var_39_9 = arg_39_1.need_token
		local var_39_10 = arg_39_1.penalty_value
		local var_39_11 = totable(var_39_10)
		
		var_39_0.add_consumption_token = {
			data = var_39_11.value
		}
	elseif arg_39_1.penalty_condition == "decrease_role_level" or arg_39_1.penalty_condition == "decrease_random_role_level" then
		local var_39_12 = arg_39_2.job_levels
		local var_39_13, var_39_14 = arg_39_0:getJobLevelDiff(arg_39_3.job_levels, arg_39_2.job_levels, function(arg_40_0, arg_40_1)
			return arg_40_0 < arg_40_1
		end)
		local var_39_15 = tonumber(var_39_12[var_39_13]) or 1
		
		if var_39_13 and var_39_15 and var_39_14 < var_39_15 then
			var_39_0[arg_39_1.penalty_condition] = {
				role = var_39_13,
				diff = var_39_15 - var_39_14
			}
		else
			local var_39_16 = LotaEventSystem:stringToHashData(arg_39_1.penalty_value)
			
			var_39_0[arg_39_1.penalty_condition] = {
				data = "not_changed",
				role = arg_39_3.try_down_role or var_39_16.role
			}
		end
	end
	
	if arg_39_1.penalty_type ~= "none" and arg_39_3.is_penalty_proc == false then
		var_39_0.goddess = {
			data = true
		}
	end
	
	if table.empty(var_39_0) then
		return 
	end
	
	return var_39_0
end

function LotaUtil.getObjectIdFromInfo(arg_41_0, arg_41_1)
	return arg_41_1.object or arg_41_1.object_id
end

function LotaUtil.addExpToRewards(arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5)
	arg_42_4 = arg_42_4 or {}
	
	if arg_42_1 then
		local var_42_0 = tonumber(arg_42_1) - tonumber(LotaUserData:getExp())
		
		if var_42_0 > 0 then
			local var_42_1 = 0
			
			if arg_42_4.object_use_add_exp then
				var_42_1 = var_42_1 + arg_42_4.object_use_add_exp
			end
			
			if arg_42_4.object_use_exp then
				var_42_1 = var_42_1 + arg_42_4.object_use_exp
			end
			
			if arg_42_4.battle_win_add_exp then
				var_42_1 = var_42_1 + arg_42_4.battle_win_add_exp
			end
			
			if arg_42_4.battle_win_exp then
				var_42_1 = var_42_1 + arg_42_4.battle_win_exp
			end
			
			if arg_42_3 then
				table.insert(arg_42_2, {
					code = "ma_heritage_exp",
					count = var_42_0,
					lota_arti_bonus = var_42_1
				})
			else
				table.insert(arg_42_2, {
					item = {
						code = "ma_heritage_exp",
						diff = var_42_0
					},
					count = var_42_0,
					lota_arti_bonus = var_42_1
				})
			end
		end
	end
end

function LotaUtil.createUserInfo(arg_43_0, arg_43_1)
	arg_43_1 = arg_43_1 or {}
	
	return {
		name = arg_43_1.name or "NOT_SETED",
		leader_code = arg_43_1.leader_code or "m",
		border_code = arg_43_1.border_code or "ma_border1",
		exp = arg_43_1.exp or -1,
		job_levels = arg_43_1.job_levels or {
			-1,
			-1,
			-1,
			-1,
			-1,
			-1
		},
		artifact_items = arg_43_1.artifact_items or {},
		enhance_material_count = arg_43_1.enhance_material_count or -1,
		hero_register_list = arg_43_1.hero_register_list or {}
	}
end

function LotaUtil.getMyUserInfo(arg_44_0)
	local var_44_0 = Account:getMainUnit()
	local var_44_1 = {
		name = AccountData.name,
		leader_code = var_44_0,
		border_code = Account:getBorderCode(),
		exp = LotaUserData:getExp(),
		job_levels = LotaUserData:getJobLevels(),
		artifact_items = LotaUserData:getArtifactItems(),
		enhance_material_count = LotaUserData:getEnhanceMaterialCount(),
		hero_register_list = LotaUserData:getRegistrationList()
	}
	
	return (arg_44_0:createUserInfo(var_44_1))
end

function LotaUtil.getUserLevel(arg_45_0, arg_45_1)
	local var_45_0
	
	for iter_45_0 = 1, 99 do
		local var_45_1, var_45_2 = DB("clan_heritage_rank_data", tostring(iter_45_0), {
			"id",
			"need_exp"
		})
		
		if not var_45_1 then
			break
		end
		
		if arg_45_1 < var_45_2 then
			break
		end
		
		var_45_0 = var_45_1
	end
	
	return var_45_0
end

function LotaUtil.isTileHaveAddSelect(arg_46_0, arg_46_1)
	local var_46_0 = arg_46_1:getTileId()
	local var_46_1 = LotaObjectSystem:getObject(var_46_0)
	
	if not var_46_1 then
		return false
	end
	
	local var_46_2 = not table.empty(var_46_1:getChildTileList())
	
	if var_46_1:isMonsterType() then
		return var_46_2 and var_46_1:isActive()
	end
	
	return var_46_2
end

function LotaUtil.isDiscoverAllowType(arg_47_0, arg_47_1, arg_47_2)
	return arg_47_1 == "overlap_object" or arg_47_2 == "keeper_monster" or arg_47_2 == "boss_monster" or arg_47_2 == "portal"
end

function LotaUtil.isAvailableEnter(arg_48_0, arg_48_1, arg_48_2)
	if not arg_48_1 then
		return 
	end
	
	local var_48_0 = Clan:getClanInfo()
	
	if not var_48_0 then
		return 
	end
	
	local var_48_1 = var_48_0.member_count
	local var_48_2, var_48_3 = arg_48_0:getRequireEnterCondition()
	
	if not arg_48_2 and var_48_1 < var_48_2 then
		return false, "req_more_member"
	elseif var_48_3 > Account:getLevel() then
		return false, "req_more_level"
	end
	
	local var_48_4 = arg_48_0:getCurrentScheduleData(arg_48_1)
	
	if not var_48_4 then
		return false, "no_data"
	end
	
	if var_48_4.start_time > os.time() then
		return false, "not_open"
	end
	
	return true
end

function LotaUtil.isCurrentOpen(arg_49_0, arg_49_1)
	local var_49_0 = arg_49_0:getCurrentScheduleData(arg_49_1)
	
	if not var_49_0 then
		return false
	end
	
	local var_49_1 = os.time()
	
	return var_49_1 >= var_49_0.start_time and var_49_1 < var_49_0.end_time
end

function LotaUtil.isShopEnable(arg_50_0, arg_50_1)
	local var_50_0 = arg_50_0:getLatestScheduleData(arg_50_1)
	
	if not var_50_0 then
		return false
	end
	
	local var_50_1 = os.time()
	local var_50_2 = 604800
	
	return var_50_1 >= var_50_0.start_time and var_50_1 < var_50_0.end_time + var_50_2
end

function LotaUtil.getMaxFloor(arg_51_0, arg_51_1)
	local var_51_0 = DB("clan_heritage_season", arg_51_1, "world_id")
	local var_51_1 = 0
	
	for iter_51_0 = 1, 99 do
		local var_51_2, var_51_3 = DBN("clan_heritage_world", iter_51_0, {
			"floor",
			"world_id"
		})
		
		if var_51_0 == var_51_3 then
			if not var_51_2 then
				break
			end
			
			var_51_1 = math.max(var_51_1, tonumber(var_51_2))
		end
	end
	
	return var_51_1
end

function LotaUtil.getLatestScheduleData(arg_52_0, arg_52_1)
	if not arg_52_1 or table.empty(arg_52_1) then
		return 
	end
	
	local var_52_0
	local var_52_1 = os.time()
	local var_52_2 = 0
	
	for iter_52_0, iter_52_1 in pairs(arg_52_1) do
		if var_52_1 >= iter_52_1.start_time and var_52_2 < iter_52_1.end_time then
			var_52_0 = iter_52_1
			var_52_2 = iter_52_1.end_time
		end
	end
	
	return var_52_0
end

function LotaUtil.getCurrentScheduleData(arg_53_0, arg_53_1)
	if not arg_53_1 or table.empty(arg_53_1) then
		return 
	end
	
	local var_53_0
	local var_53_1 = os.time()
	local var_53_2 = 99999999999
	
	for iter_53_0, iter_53_1 in pairs(arg_53_1) do
		if var_53_2 > iter_53_1.end_time and var_53_1 < iter_53_1.end_time then
			var_53_0 = iter_53_1
			var_53_2 = iter_53_1.end_time
		end
	end
	
	return var_53_0
end

function LotaUtil.getRequireEnterCondition(arg_54_0)
	local var_54_0 = DB("clan_heritage_config", "clan_member_rank", "client_value")
	
	return DB("clan_heritage_config", "clan_member_number", "client_value"), var_54_0
end

function LotaUtil.openUserLevelUpPopup(arg_55_0, arg_55_1)
	local var_55_0 = arg_55_0:getUIDlg("clan_heritage_level_up")
	
	arg_55_0:updateBenefitLevelupPopup(var_55_0, arg_55_1)
	arg_55_0:updateLevelIconWithLv(var_55_0, arg_55_1, {
		n_expedition_level_name = "n_contents"
	})
	
	local var_55_1 = cc.Node:create()
	
	var_55_1:setName("n_eff")
	var_55_1:setPosition(VIEW_WIDTH / 2 + VIEW_BASE_LEFT, VIEW_HEIGHT / 2 + 200)
	var_55_0:addChild(var_55_1)
	Dialog:msgBox(nil, {
		dlg = var_55_0,
		handler = function(arg_56_0, arg_56_1)
			if arg_56_1 == "btn_go_enhancement " then
				LotaRoleEnhancementUI:open(LotaSystem:getUIPopupLayer())
			end
		end
	})
end

function LotaUtil.getMaxHeroCount(arg_57_0, arg_57_1)
	local var_57_0 = arg_57_0:getUserLevel(arg_57_1)
	
	return (DB("clan_heritage_rank_data", tostring(var_57_0), "max_hero"))
end

function LotaUtil.getLegacyInventoryMax(arg_58_0, arg_58_1)
	local var_58_0 = arg_58_0:getUserLevel(arg_58_1)
	
	return (DB("clan_heritage_rank_data", tostring(var_58_0), "max_skill"))
end

function LotaUtil.onDeselectAnimation(arg_59_0, arg_59_1, arg_59_2)
	UIAction:Remove(arg_59_2 .. "_legacy_select_ani1")
	UIAction:Remove(arg_59_2 .. "_legacy_select_ani2")
	if_set_visible(arg_59_1, nil, false)
end

function LotaUtil.onSelectAnimation(arg_60_0, arg_60_1, arg_60_2)
	local var_60_0 = arg_60_1:findChildByName("img_in")
	local var_60_1 = arg_60_1:findChildByName("img_out")
	
	UIAction:Add(LOOP(ROTATE(10000, 0, 360)), var_60_0, arg_60_2 .. "_legacy_select_ani1")
	UIAction:Add(LOOP(ROTATE(10000, 0, -360)), var_60_1, arg_60_2 .. "_legacy_select_ani2")
	if_set_visible(arg_60_1, nil, true)
end

function LotaUtil.getUnlockLegacyLvList(arg_61_0)
	local var_61_0 = {}
	
	for iter_61_0 = 1, 15 do
		local var_61_1 = DB("clan_heritage_rank_data", tostring(iter_61_0), "max_skill")
		
		if not var_61_1 then
			break
		end
		
		if not var_61_0[var_61_1] then
			var_61_0[var_61_1] = iter_61_0
		end
	end
	
	if not var_61_0[1] then
		var_61_0[1] = 1
	end
	
	return var_61_0
end

function LotaUtil.getPrvNeedExp(arg_62_0, arg_62_1)
	local var_62_0 = arg_62_0:getUserLevel(arg_62_1)
	local var_62_1 = DB("clan_heritage_rank_data", tostring(var_62_0), "need_exp")
	
	if not var_62_1 then
		return 727272727272
	end
	
	return var_62_1
end

function LotaUtil.getNeedExp(arg_63_0, arg_63_1)
	local var_63_0 = arg_63_0:getUserLevel(arg_63_1)
	local var_63_1 = DB("clan_heritage_rank_data", tostring(var_63_0 + 1), "need_exp")
	
	if not var_63_1 then
		return 9999999
	end
	
	return var_63_1
end

function LotaUtil.updateLegacySlots(arg_64_0, arg_64_1, arg_64_2, arg_64_3, arg_64_4)
	arg_64_2 = arg_64_2 or {}
	
	local var_64_0 = arg_64_0:getUnlockLegacyLvList()
	
	for iter_64_0 = 1, 6 do
		local var_64_1 = arg_64_1:findChildByName("n_slot" .. iter_64_0)
		local var_64_2 = arg_64_2[iter_64_0]
		local var_64_3 = arg_64_3 < iter_64_0
		
		if not get_cocos_refid(var_64_1) then
			Log.e("MUST BE REF NODE")
			
			return 
		end
		
		local var_64_4 = var_64_1:findChildByName("n_locked")
		
		if var_64_3 then
			local var_64_5 = var_64_0[iter_64_0]
			
			arg_64_0:updateLevelIconWithLv(var_64_4, var_64_5, {
				level_bg_name = "bg"
			})
		end
		
		if_set_visible(var_64_4, nil, var_64_3)
		
		if var_64_2 and not var_64_3 then
			local var_64_6 = var_64_1:findChildByName("n_legacy_icon")
			local var_64_7 = arg_64_0:getLegacyIcon(var_64_2)
			
			var_64_7:setAnchorPoint(0.5, 0.5)
			var_64_6:addChild(var_64_7)
		end
	end
end

function LotaUtil.updateLegacySlotsInMainUI(arg_65_0, arg_65_1, arg_65_2)
	arg_65_2 = arg_65_2 or {}
	
	for iter_65_0 = 1, 6 do
		local var_65_0 = arg_65_1:findChildByName("n_" .. iter_65_0)
		local var_65_1 = arg_65_2[iter_65_0]
		
		if var_65_0 then
			local var_65_2 = var_65_0:findChildByName("n_legacy_icon")
			
			if not var_65_1 then
				if_set_visible(var_65_2, nil, false)
			else
				if_set_visible(var_65_2, nil, true)
				
				local var_65_3 = var_65_2:findChildByName("legacy_icon")
				
				if not var_65_3 then
					local var_65_4 = arg_65_0:getLegacyIcon(var_65_1, nil, true)
					
					var_65_4:setAnchorPoint(0.5, 0.5)
					var_65_4:setName("legacy_icon")
					var_65_2:addChild(var_65_4)
				else
					arg_65_0:getLegacyIcon(var_65_1, var_65_3, true)
				end
				
				if_set_visible(var_65_0, "n_duration", var_65_1:isExistDuration())
				
				if var_65_1:isExistDuration() then
					if_set(var_65_0, "t_duration", var_65_1:getRemainCount())
				end
			end
		end
	end
end

function LotaUtil.createBossSkillList(arg_66_0, arg_66_1, arg_66_2, arg_66_3)
	arg_66_3 = arg_66_3 or {}
	
	local var_66_0 = ItemListView_v2:bindControl(arg_66_1)
	
	var_66_0:setListViewCascadeEnabled(true)
	
	local var_66_1 = load_control("wnd/clan_heritage_battle_ready_skill_item.csb")
	local var_66_2 = {
		onUpdate = function(arg_67_0, arg_67_1, arg_67_2, arg_67_3)
			local var_67_0 = UIUtil:getSkillIcon(nil, arg_67_3, {
				skill_id = arg_67_3,
				tooltip_opts = {
					show_effs = "right",
					skill_id = arg_67_3
				}
			})
			local var_67_1, var_67_2 = DB("skill", arg_67_3, {
				"name",
				"sk_icon"
			})
			
			if_set(arg_67_1, "txt_name", T(var_67_1))
			
			if var_67_0 then
				arg_67_1:findChildByName("n_skill_icon"):addChild(var_67_0)
			end
		end
	}
	
	var_66_0:setRenderer(var_66_1, var_66_2)
	var_66_0:setDataSource(arg_66_2)
	
	return var_66_0
end

function LotaUtil.updateLevelIcon(arg_68_0, arg_68_1, arg_68_2, arg_68_3)
	local var_68_0 = LotaUtil:getUserLevel(arg_68_2)
	
	arg_68_0:updateLevelIconWithLv(arg_68_1, var_68_0, arg_68_3)
end

function LotaUtil.updateLevelIconWithLv(arg_69_0, arg_69_1, arg_69_2, arg_69_3)
	arg_69_3 = arg_69_3 or {}
	
	local var_69_0 = arg_69_3.n_expedition_level_name or "n_expedition_level"
	local var_69_1 = arg_69_3.t_level_name or "t_level"
	local var_69_2 = arg_69_1:findChildByName(var_69_0)
	
	if_set(var_69_2, var_69_1, arg_69_2)
end

function LotaUtil.updateUserInfoUI(arg_70_0, arg_70_1, arg_70_2, arg_70_3)
	arg_70_3 = arg_70_3 or {}
	arg_70_2 = arg_70_2 or {}
	
	if_set(arg_70_1, "t_name", arg_70_2.name)
	UIUtil:getUserIcon(arg_70_2.leader_code, {
		no_popup = true,
		no_lv = true,
		no_role = true,
		no_grade = true,
		parent = arg_70_1:getChildByName("n_face"),
		border_code = arg_70_2.border_code
	})
	
	local var_70_0 = arg_70_1:findChildByName(arg_70_3.n_expedition_level_name or "n_expedition_level")
	local var_70_1 = arg_70_2.exp
	
	arg_70_0:updateLevelIcon(arg_70_1, var_70_1, arg_70_3)
	
	local var_70_2 = LotaUtil:getNeedExp(var_70_1)
	local var_70_3 = LotaUtil:getPrvNeedExp(var_70_1)
	local var_70_4 = var_70_1 - var_70_3
	local var_70_5 = var_70_2 - var_70_3
	
	if_set(var_70_0, "t_percent", var_70_4 .. "/" .. var_70_5)
	if_set_percent(var_70_0, "progress_bar", var_70_4 / var_70_5)
end

function LotaUtil.isBossActive(arg_71_0)
	return LotaClanInfo:getKeeperDeadCount(LotaUserData:getFloor()) >= LotaClanInfo:getRequireKeeperDeadCount(LotaUserData:getFloor())
end

function LotaUtil.isBossDead(arg_72_0)
	return LotaClanInfo:getBossDeadCount(LotaUserData:getFloor()) > 0
end

local function var_0_0(arg_73_0)
	local var_73_0 = ""
	local var_73_1 = {
		"0",
		"1",
		"2",
		"3",
		"4",
		"5",
		"6",
		"7",
		"8",
		"9",
		"a",
		"b",
		"c",
		"d",
		"e",
		"f"
	}
	
	return var_73_1[math.floor(arg_73_0 / 16) + 1] .. var_73_1[arg_73_0 % 16 + 1]
end

local function var_0_1(arg_74_0)
	local var_74_0 = var_0_0(arg_74_0.r)
	local var_74_1 = var_0_0(arg_74_0.g)
	local var_74_2 = var_0_0(arg_74_0.b)
	
	return "<#" .. var_74_0 .. var_74_1 .. var_74_2 .. ">"
end

function LotaUtil.getBenefitInfo(arg_75_0, arg_75_1)
	local var_75_0, var_75_1, var_75_2, var_75_3, var_75_4, var_75_5, var_75_6 = DB("clan_heritage_rank_data", tostring(arg_75_1), {
		"max_skill",
		"max_charge_token",
		"legacy_rate_id",
		"high_legacy_rate_id",
		"item_value",
		"max_hero",
		"recharge_token"
	})
	local var_75_7 = DBT("clan_legacy_skill_rate", var_75_2, {
		"grade_1",
		"grade_2",
		"grade_3",
		"grade_4",
		"grade_5"
	})
	local var_75_8
	local var_75_9
	
	for iter_75_0 = 1, 5 do
		if var_75_7["grade_" .. iter_75_0] then
			var_75_8 = var_75_8 or iter_75_0
			var_75_9 = iter_75_0
		end
	end
	
	return {
		legacy = {
			max_skill = var_75_0,
			grade_min = var_75_8,
			grade_max = var_75_9
		},
		hero = {
			max_hero = var_75_5
		},
		token = {
			max_charge_token = var_75_1,
			recharge_token = var_75_6
		},
		enhance_material = {
			count = var_75_4
		}
	}
end

function LotaUtil.getBenefitInfoDiff(arg_76_0, arg_76_1, arg_76_2)
	return {
		token = {
			max_charge_token = arg_76_1.token.max_charge_token - arg_76_2.token.max_charge_token,
			recharge_token = arg_76_1.token.recharge_token - arg_76_2.token.recharge_token
		},
		legacy = {
			max_skill = arg_76_1.legacy.max_skill - arg_76_2.legacy.max_skill
		},
		hero = {
			max_hero = arg_76_1.hero.max_hero - arg_76_2.hero.max_hero
		}
	}
end

function LotaUtil.updateBenefitLevelupPopup(arg_77_0, arg_77_1, arg_77_2)
	local var_77_0 = arg_77_1:findChildByName("n_expedition_benefit")
	local var_77_1 = var_77_0:findChildByName("n_token")
	local var_77_2 = var_77_0:findChildByName("n_legacy")
	local var_77_3 = var_77_0:findChildByName("n_hero")
	local var_77_4 = var_77_0:findChildByName("n_provisions")
	
	if_set_visible(var_77_1, nil, false)
	if_set_visible(var_77_2, nil, false)
	if_set_visible(var_77_3, nil, false)
	if_set_visible(var_77_4, nil, false)
	
	local var_77_5 = arg_77_0:getBenefitInfo(arg_77_2)
	local var_77_6 = arg_77_0:getBenefitInfo(arg_77_2 - 1)
	local var_77_7 = arg_77_0:getBenefitInfoDiff(var_77_5, var_77_6)
	local var_77_8 = {}
	
	if var_77_5.enhance_material then
		if_set(var_77_1, "t_1_reward", var_77_5.enhance_material.count)
		if_set_visible(var_77_1, nil, true)
		table.insert(var_77_8, var_77_1)
	end
	
	if var_77_7.legacy.max_skill > 0 then
		if_set(var_77_2, "t_2_reward", var_77_5.legacy.max_skill)
		if_set(var_77_2, "t_2_before", var_77_6.legacy.max_skill)
		if_set_visible(var_77_2, nil, true)
		table.insert(var_77_8, var_77_2)
	end
	
	if var_77_7.hero.max_hero > 0 then
		if_set(var_77_3, "t_3_reward", var_77_5.hero.max_hero)
		if_set(var_77_3, "t_3_before", var_77_6.hero.max_hero)
		if_set_visible(var_77_3, nil, true)
		table.insert(var_77_8, var_77_3)
	end
	
	if var_77_5.token.recharge_token then
		if_set(var_77_4, "t_4_reward", var_77_5.token.recharge_token)
		if_set_visible(var_77_4, nil, true)
		table.insert(var_77_8, var_77_4)
	end
	
	local var_77_9 = "even"
	local var_77_10 = table.count(var_77_8)
	
	if var_77_10 % 2 == 1 then
		var_77_9 = "odd"
	end
	
	if var_77_10 == 2 then
		local var_77_11 = var_77_8[1]
		local var_77_12 = var_77_0:findChildByName("n_2/even")
		
		var_77_11:setPosition(var_77_12:getPosition())
		
		local var_77_13 = var_77_8[2]
		local var_77_14 = var_77_0:findChildByName("n_3/even")
		
		var_77_13:setPosition(var_77_14:getPosition())
	elseif var_77_10 > 1 then
		for iter_77_0 = 1, var_77_10 do
			local var_77_15 = var_77_8[iter_77_0]
			local var_77_16 = var_77_0:findChildByName("n_" .. iter_77_0 .. "/" .. var_77_9)
			
			var_77_15:setPosition(var_77_16:getPosition())
		end
	else
		var_77_8[1]:setPosition(var_77_0:findChildByName("n_2/odd"):getPosition())
	end
end

function LotaUtil.updateBossCondition(arg_78_0, arg_78_1, arg_78_2)
	local var_78_0 = 0
	local var_78_1 = 0
	
	if arg_78_2 then
		var_78_0, var_78_1 = arg_78_2:getHPStatus()
	end
	
	local var_78_2 = 1
	local var_78_3 = var_78_1 == 0 and 1 or var_78_0 / var_78_1
	local var_78_4 = ""
	local var_78_5 = ""
	local var_78_6
	
	if var_78_3 > 0.75 then
		var_78_4 = "ui_heritage_hp_100"
		var_78_6 = "#6bc11b"
	elseif var_78_3 > 0.5 then
		var_78_4 = "ui_heritage_hp_74"
		var_78_6 = "#e1d400"
	elseif var_78_3 > 0.25 then
		var_78_4 = "ui_heritage_hp_49"
		var_78_6 = "#ff0000"
	else
		var_78_4 = "ui_heritage_hp_24"
		var_78_6 = "#9700ee"
	end
	
	if_set(arg_78_1, "txt_state", T(var_78_4))
	if_set_color(arg_78_1, "bg", tocolor(var_78_6))
end

function LotaUtil.updateBenefit(arg_79_0, arg_79_1, arg_79_2)
	local var_79_0 = arg_79_1:findChildByName("n_expedition_benefit")
	local var_79_1 = arg_79_2.exp
	local var_79_2 = arg_79_2.lv or LotaUtil:getUserLevel(var_79_1)
	local var_79_3 = arg_79_0:getBenefitInfo(var_79_2)
	local var_79_4 = LotaUserData:getRegistrationList()
	local var_79_5 = table.count(var_79_4)
	
	if_set(var_79_0, "t_1_reward", var_79_3.token.max_charge_token)
	if_set(var_79_0, "t_2_reward", var_79_3.legacy.max_skill)
	if_set(var_79_0, "t_3_reward", var_79_5 .. "/" .. var_79_3.hero.max_hero)
end

function LotaUtil.updateBossInfoUI(arg_80_0, arg_80_1, arg_80_2, arg_80_3, arg_80_4)
	arg_80_4 = arg_80_4 or {}
	
	local var_80_0 = arg_80_4.n_boss_name or "n_boss"
	local var_80_1 = arg_80_2.boss_info
	local var_80_2 = T(DB("character", var_80_1.character_id, "name"))
	local var_80_3 = arg_80_1:findChildByName(var_80_0)
	local var_80_4 = var_80_3:findChildByName("mob_icon")
	
	if var_80_4 and not var_80_4:findChildByName("boss_icon") then
		local var_80_5 = arg_80_4.no_popup
		
		if var_80_5 == nil then
			var_80_5 = true
		end
		
		UIUtil:getRewardIcon(nil, arg_80_2.object_id or var_80_1.character_id, {
			is_enemy = true,
			scale = 1,
			no_grade = true,
			parent = var_80_4,
			no_popup = var_80_5,
			lv = arg_80_4.lv
		}):setName("boss_icon")
	end
	
	if_set(var_80_3, "t_name", var_80_2)
	
	local var_80_6 = CoopUtil:getBossHpRate(var_80_1.max_hp, arg_80_2.last_hp)
	local var_80_7 = var_80_3:findChildByName("n_gauge")
	local var_80_8 = var_80_7:findChildByName("hp")
	local var_80_9 = var_80_7:findChildByName("hp_red")
	
	var_80_8:setScaleX(var_80_6)
	
	if arg_80_3 and arg_80_3 ~= var_80_6 then
		UIAction:Add(SEQ(LOG(SCALE_TO_X(1000, var_80_6))), var_80_9, "block")
	else
		var_80_9:setScaleX(var_80_6)
	end
end

function LotaUtil.getCharacterId(arg_81_0, arg_81_1)
	if not arg_81_1 then
		return 
	end
	
	local var_81_0 = DB("clan_heritage_object_data", arg_81_1, "coop_info")
	local var_81_1 = string.split(var_81_0, ",")
	local var_81_2 = {}
	
	for iter_81_0, iter_81_1 in pairs(var_81_1) do
		local var_81_3 = string.split(iter_81_1, "=")
		
		var_81_2[var_81_3[1]] = var_81_3[2]
	end
	
	return var_81_2.character_id
end

function LotaUtil.makeMemberArray(arg_82_0, arg_82_1)
	local var_82_0 = {}
	
	for iter_82_0, iter_82_1 in pairs(arg_82_1 or {}) do
		iter_82_1.uid = to_n(iter_82_0)
		
		table.insert(var_82_0, iter_82_1)
	end
	
	return var_82_0
end

function LotaUtil.createMembersList(arg_83_0, arg_83_1, arg_83_2, arg_83_3)
	arg_83_3 = arg_83_3 or {}
	
	local var_83_0 = arg_83_3.scroll_view_name or "ScrollView"
	local var_83_1 = arg_83_0:makeMemberArray(arg_83_2)
	local var_83_2 = CoopUtil:getRankList(var_83_1)
	
	if_set(arg_83_1, "txt_count", #var_83_2)
	
	return (CoopUtil:makeRankingListView(arg_83_1:findChildByName(var_83_0), var_83_2, {
		ignore_max_count = true
	}))
end

function LotaUtil.updateMembersList(arg_84_0, arg_84_1, arg_84_2, arg_84_3, arg_84_4)
	local var_84_0 = arg_84_0:makeMemberArray(arg_84_3)
	local var_84_1 = CoopUtil:getRankList(var_84_0)
	
	if_set(arg_84_2, "txt_count", #var_84_1)
	arg_84_1:setDataSource(var_84_1)
end

function LotaUtil.sendText(arg_85_0, arg_85_1)
	print("HEY! TEXT!", arg_85_1)
	balloon_message_with_sound("[WIP TEXT]" .. arg_85_1)
end

function LotaUtil.sendWIPText(arg_86_0, arg_86_1)
	print("HEY, WIP!", arg_86_1)
	balloon_message_with_sound("[WIP TEXT]" .. arg_86_1)
end

function LotaUtil.sendERROR(arg_87_0, arg_87_1)
	Log.e(arg_87_1)
	
	arg_87_0._ERROR_CNT = arg_87_0._ERROR_CNT or 0
	
	if not PRODUCTION_MODE then
		local var_87_0 = LotaUtil:createDebugLabel("test", arg_87_1, {
			width = 200,
			height = 24
		})
		
		var_87_0:setColor(cc.c3b(244, 12, 24))
		var_87_0:setPositionX(380)
		var_87_0:setPositionY(VIEW_HEIGHT + arg_87_0._ERROR_CNT * 24 - 48)
		var_87_0:setLocalZOrder(99999 + arg_87_0._ERROR_CNT)
		
		arg_87_0._ERROR_CNT = arg_87_0._ERROR_CNT + 1
		
		SceneManager:getRunningPopupScene():addChild(var_87_0)
	end
end

function LotaUtil.getUIDlg(arg_88_0, arg_88_1, arg_88_2)
	if arg_88_2 == nil then
		arg_88_2 = true
	end
	
	return load_dlg(arg_88_1, arg_88_2, "wnd")
end

function LotaUtil.getUIControl(arg_89_0, arg_89_1)
	return load_control("wnd/" .. arg_89_1 .. ".csb")
end

function LotaUtil.getRewardData(arg_90_0, arg_90_1, arg_90_2)
	local var_90_0 = {}
	local var_90_1 = {}
	local var_90_2
	local var_90_3 = 0
	local var_90_4 = 0
	
	for iter_90_0 = 1, 10 do
		local var_90_5 = DB("clan_heritage_reward_data", arg_90_1 .. "_" .. iter_90_0, "id")
		
		if not var_90_5 then
			break
		end
		
		if var_90_3 <= 0 then
			local var_90_6 = DB("clan_heritage_reward_data", var_90_5, "action_point")
			
			if var_90_6 then
				var_90_3 = var_90_6
			end
		end
		
		if var_90_4 <= 0 then
			local var_90_7 = DB("clan_heritage_reward_data", var_90_5, "role_point")
			
			if var_90_7 then
				var_90_4 = var_90_7
			end
		end
		
		local var_90_8 = DB("clan_heritage_reward_data", var_90_5, "exp")
		
		if iter_90_0 == 1 and var_90_2 == nil and to_n(var_90_8) > 0 then
			var_90_2 = to_n(var_90_8)
		elseif to_n(var_90_8) ~= to_n(var_90_2) and iter_90_0 ~= 1 then
			print("REWARD EXP IS NOT SAME. IS RANGE VALUE. CAN'T ADD IN REWARD DATA.", var_90_5)
			
			var_90_2 = nil
		end
		
		for iter_90_1 = 1, 40 do
			local var_90_9, var_90_10, var_90_11, var_90_12, var_90_13 = DB("clan_heritage_reward_data", var_90_5, {
				"id",
				"item_id_" .. iter_90_1,
				"grade_rate_" .. iter_90_1,
				"set_rate_" .. iter_90_1,
				"item_count_" .. iter_90_1
			})
			
			if not var_90_9 then
				break
			end
			
			if var_90_10 and not var_90_1[var_90_10] then
				var_90_1[var_90_10] = true
				
				table.insert(var_90_0, {
					item_id = var_90_10,
					grade_rate = var_90_11,
					set_rate = var_90_12,
					count = var_90_13
				})
			end
		end
	end
	
	if var_90_2 and var_90_2 > 0 then
		table.insert(var_90_0, {
			item_id = "ma_heritage_exp",
			count = var_90_2
		})
	elseif arg_90_2 then
		local var_90_14, var_90_15 = DB("clan_heritage_object_data", arg_90_2, {
			"exp",
			"reward_type"
		})
		
		if var_90_15 == "elite_monster" or var_90_15 == "boss_monster" then
			var_90_14 = nil
		end
		
		if var_90_14 and var_90_14 > 0 then
			table.insert(var_90_0, {
				item_id = "ma_heritage_exp",
				count = var_90_14
			})
		end
	end
	
	if var_90_3 > 0 then
		table.insert(var_90_0, {
			item_id = "to_clanheritage",
			count = var_90_3
		})
	end
	
	if var_90_4 > 0 then
		table.insert(var_90_0, {
			item_id = "ma_heritage_job",
			count = var_90_4
		})
	end
	
	return var_90_0
end

function LotaUtil.getListRoles(arg_91_0)
	return {
		"knight",
		"ranger",
		"mage",
		"assassin",
		"warrior",
		"manauser"
	}
end

function LotaUtil.getRoleToIndex(arg_92_0, arg_92_1)
	local var_92_0 = arg_92_0:getListRoles()
	
	for iter_92_0, iter_92_1 in pairs(var_92_0) do
		if iter_92_1 == arg_92_1 then
			return iter_92_0
		end
	end
end

function LotaUtil.getMonsterTypeNameHashMap(arg_93_0)
	return {
		elite_monster = "cm_icon_mob_elite.png",
		boss_monster = "cm_icon_mob_boss.png",
		keeper_monster = "cm_icon_mob_guardian.png",
		normal_monster = "cm_icon_mob_normal.png"
	}
end

function LotaUtil.getRoleLevelByLegacyEffectValue(arg_94_0, arg_94_1)
	return ({
		enhance_warrior_role_level = "warrior",
		enhance_mage_role_level = "mage",
		enhance_knight_role_level = "knight",
		enhance_assassin_role_level = "assassin",
		enhance_ranger_role_level = "ranger",
		enhance_manauser_role_level = "manauser"
	})[arg_94_1]
end

function LotaUtil.updateJobLevelUIElement(arg_95_0, arg_95_1, arg_95_2, arg_95_3, arg_95_4, arg_95_5, arg_95_6, arg_95_7, arg_95_8)
	local var_95_0 = math.min(arg_95_3, arg_95_4)
	local var_95_1 = UIUtil:numberDigitToCharOffset(var_95_0, 1, 19)
	local var_95_2, var_95_3 = UIUtil:setLevel(arg_95_1, var_95_0, 15, 2, nil, nil, var_95_1)
	
	arg_95_0:replaceBackgroundByJobLevel(arg_95_1, var_95_0)
	
	local var_95_4 = 0
	
	if arg_95_4 <= arg_95_3 then
		var_95_4 = arg_95_5 + arg_95_6 - arg_95_4
	end
	
	local var_95_5
	
	if arg_95_4 <= var_95_0 then
		var_95_5 = arg_95_1:findChildByName("max")
	elseif var_95_0 > 10 then
		var_95_5 = arg_95_1:findChildByName("l1")
	else
		var_95_5 = arg_95_1:findChildByName("l1")
	end
	
	local var_95_6 = arg_95_6 > 0 and arg_95_5 < arg_95_4
	local var_95_7 = var_95_6 and var_95_5:findChildByName("txt_add_level")
	
	if not var_95_7 then
		var_95_5 = arg_95_1
	end
	
	if_set(var_95_5, "txt_add_level", "(+" .. tostring(arg_95_6 - var_95_4) .. ")")
	if_set_visible(var_95_5, "txt_add_level", var_95_6)
	
	local var_95_8 = arg_95_1:findChildByName("n_lv")
	local var_95_9 = arg_95_1:findChildByName("bg")
	local var_95_10 = var_95_9 and var_95_9:getPositionX() or 0
	
	if get_cocos_refid(var_95_8) then
		local var_95_11 = var_95_8:getScaleX()
		local var_95_12 = (var_95_3 and -50 or -28 - var_95_2 * 7 + var_95_10) - (var_95_7 and 20 or 0)
		
		if_set_position_x(var_95_8, nil, var_95_12 * var_95_11)
	end
	
	local var_95_13 = arg_95_1:findChildByName("n_up")
	
	if var_95_13 then
		if_set_visible(var_95_13, nil, arg_95_5 < LotaUserData:getMaxRoleLevel() and not arg_95_8)
		
		if arg_95_5 < LotaUserData:getMaxRoleLevel() then
			local var_95_14 = arg_95_0:getLevelupRequirePoint(arg_95_2)
			
			if_set(var_95_13, "txt_token_count", var_95_14)
			if_set_visible(var_95_13, "icon_up", var_95_14 <= arg_95_7)
			
			local var_95_15 = "#ffffff"
			local var_95_16 = "#ffffff"
			
			if arg_95_7 < var_95_14 then
				var_95_16 = "#ff3e3e"
				var_95_15 = "#888888"
			end
			
			if_set_color(var_95_13, "txt_token_count", tocolor(var_95_16))
			if_set_color(var_95_13, nil, tocolor(var_95_15))
		end
	end
end

function LotaUtil.setJobLevelUI(arg_96_0, arg_96_1, arg_96_2)
	local var_96_0 = LotaUtil:getListRoles()
	
	if_set_visible(arg_96_1, "n_enhancement_meterial", true)
	
	local var_96_1 = LotaUserData:getEnhanceMaterialCount()
	
	if_set(arg_96_1, "txt_enhancement_meterial", T("ui_clanheritage_status_roleup_item", {
		count = var_96_1
	}))
	
	for iter_96_0, iter_96_1 in pairs(var_96_0) do
		local var_96_2 = arg_96_1:findChildByName("n_" .. iter_96_1)
		local var_96_3 = LotaUserData:getRoleLevelByRole(iter_96_1)
		local var_96_4 = LotaUserData:getMaxRoleLevel()
		local var_96_5 = LotaUserData:getRoleLevelWithoutArtifactByRole(iter_96_1)
		local var_96_6 = LotaUserData:getEffectArtifactRoleLevel(iter_96_1)
		
		LotaUtil:updateJobLevelUIElement(var_96_2, iter_96_1, var_96_3, var_96_4, var_96_5, var_96_6, var_96_1, arg_96_2)
	end
end

function LotaUtil.createBattleData(arg_97_0, arg_97_1)
	local var_97_0 = table.clone(LotaBattleDataInterface)
	
	var_97_0.battle_id = arg_97_1.room.battle_id
	var_97_0.tile_id = arg_97_1.room.tile_id
	var_97_0.room = arg_97_1.room
	var_97_0.user = arg_97_1.user
	
	return (LotaBattleData(var_97_0))
end

function LotaUtil.getBattleId(arg_98_0, arg_98_1)
	local var_98_0 = LotaUserData:getFloor()
	local var_98_1 = arg_98_1
	local var_98_2 = LotaObjectSystem:getObject(var_98_1)
	
	if var_98_2 and var_98_2:isExistAfterMonster() then
		return string.format("%d:%s:%s", var_98_0, var_98_1, var_98_2:getDBId())
	end
	
	return string.format("%d:%s", var_98_0, var_98_1)
end

function LotaUtil.settingStatNames(arg_99_0, arg_99_1)
	if_set(arg_99_1, "txt_name_stat01", getStatName("att"))
	if_set(arg_99_1, "txt_name_stat02", getStatName("acc"))
	if_set(arg_99_1, "txt_name_stat03", getStatName("cri"))
	if_set(arg_99_1, "txt_name_stat04", getStatName("cri_dmg"))
	if_set(arg_99_1, "txt_name_stat05", getStatName("max_hp"))
	if_set(arg_99_1, "txt_name_stat06", getStatName("def"))
	if_set(arg_99_1, "txt_name_stat07", getStatName("speed"))
	if_set(arg_99_1, "txt_name_stat08", getStatName("res"))
	if_set(arg_99_1, "txt_name_stat09", getStatName("coop"))
end

function LotaUtil.getRoleStatId(arg_100_0, arg_100_1, arg_100_2)
	local var_100_0
	
	for iter_100_0 = 1, 200 do
		local var_100_1, var_100_2, var_100_3 = DBN("clan_heritage_role_stat_data", iter_100_0, {
			"id",
			"level",
			"role"
		})
		
		if not var_100_1 then
			break
		end
		
		if var_100_3 == arg_100_1 and var_100_2 == arg_100_2 then
			var_100_0 = var_100_1
			
			break
		end
	end
	
	return var_100_0
end

function LotaUtil.genResponse(arg_101_0, arg_101_1)
	return {
		expedition_info = {
			boss_info = {
				character_id = arg_101_1.character_id,
				max_hp = arg_101_1.max_hp
			},
			last_hp = arg_101_1.max_hp
		},
		user_info = {}
	}
end

function LotaUtil.getBossInfo(arg_102_0, arg_102_1)
	local var_102_0 = DB("clan_heritage_object_data", arg_102_1, "coop_info")
	local var_102_1 = string.split(var_102_0, ",")
	local var_102_2 = {}
	
	for iter_102_0, iter_102_1 in pairs(var_102_1) do
		local var_102_3 = string.split(iter_102_1, "=")
		
		var_102_2[var_102_3[1]] = var_102_3[2]
	end
	
	return var_102_2
end

function LotaUtil.getSkillSequencer(arg_103_0, arg_103_1)
	local var_103_0 = {}
	local var_103_1 = DB("character", arg_103_1, "use_in_order")
	local var_103_2 = string.split(var_103_1, ",")
	local var_103_3 = DBT("character", arg_103_1, {
		"skill1",
		"skill2",
		"skill3",
		"skill4",
		"skill5",
		"skill6",
		"skill7",
		"skill8",
		"skill9"
	})
	
	for iter_103_0 = 1, #var_103_2 do
		local var_103_4 = var_103_2[iter_103_0]
		
		table.insert(var_103_0, var_103_3["skill" .. tostring(var_103_4)])
	end
	
	return var_103_0
end

function LotaUtil.getSkillList(arg_104_0, arg_104_1)
	local var_104_0 = {}
	local var_104_1 = DBT("character", arg_104_1, {
		"skill1",
		"skill2",
		"skill3",
		"skill4",
		"skill5"
	})
	
	for iter_104_0 = 1, 5 do
		local var_104_2 = var_104_1["skill" .. tostring(iter_104_0)]
		
		if var_104_2 then
			table.insert(var_104_0, var_104_2)
		end
	end
	
	return var_104_0
end

function LotaUtil.getLotaMonsterLvImagePath(arg_105_0, arg_105_1, arg_105_2)
	local var_105_0 = "img/hero_lv_"
	local var_105_1 = "img/hero_lv.png"
	
	if arg_105_2 >= arg_105_1 + 2 then
		var_105_0 = "img/hero_lv_red_"
		var_105_1 = "img/hero_lv_red.png"
	elseif arg_105_2 <= arg_105_1 - 2 then
		var_105_0 = "img/hero_lv_green_"
		var_105_1 = "img/hero_lv_green.png"
	end
	
	return var_105_0, var_105_1
end

function LotaUtil.isTooltipRewardPreviewType(arg_106_0, arg_106_1)
	local var_106_0 = arg_106_1:getTypeDetail()
	
	return ({
		elite_monster = true,
		treasure_box = true,
		production = true,
		normal_monster = true
	})[var_106_0]
end

function LotaUtil.getPreviewItemIcon(arg_107_0, arg_107_1)
	local var_107_0 = {
		dlg_name = "battle_ready",
		no_detail_popup = true,
		scale = 0.85,
		grade_max = true,
		set_drop = arg_107_1.set_rate,
		grade_rate = arg_107_1.grade_rate,
		count = arg_107_1.count
	}
	
	if string.starts(arg_107_1.item_id, "e") and DB("equip_item", arg_107_1.item_id, "type") == "artifact" then
		var_107_0.scale = 0.66
	end
	
	return UIUtil:getRewardIcon(arg_107_1.count, arg_107_1.item_id, var_107_0)
end

function LotaUtil.updateMonsterInfoUI(arg_108_0, arg_108_1, arg_108_2, arg_108_3)
	local var_108_0, var_108_1 = DB("clan_heritage_object_data", arg_108_2, {
		"type_2",
		"monster_level"
	})
	local var_108_2 = arg_108_0:getMonsterTypeNameHashMap()[var_108_0]
	
	arg_108_1:setCascadeOpacityEnabled(true)
	
	if var_108_0 ~= "normal_monster" then
		SpriteCache:resetSprite(arg_108_1:findChildByName("grade_icon"), "img/" .. var_108_2)
	end
	
	local var_108_3 = arg_108_1:findChildByName("lv")
	local var_108_4 = UIUtil:numberDigitToCharOffset(var_108_1, 1, 19)
	
	UIUtil:setLevel(var_108_3, var_108_1, 99, 2, nil, nil, var_108_4)
	var_108_3:setCascadeOpacityEnabled(true)
	
	local var_108_5 = LotaObjectSystem:getObject(arg_108_3)
	
	if not var_108_5 then
		return 
	end
	
	if_set_visible(arg_108_1, "grade_icon", var_108_5:getTypeDetail() ~= "normal_monster")
	
	if var_108_0 == "normal_monster" then
		var_108_3:setPosition(arg_108_1:findChildByName("lv_normal_move"):getPosition())
	else
		var_108_3:setPosition(5, 0)
	end
	
	if_set_visible(arg_108_1, "n_count", var_108_0 == "normal_monster")
	
	if var_108_0 ~= "normal_monster" then
		return 
	end
	
	local var_108_6 = var_108_5:getMaxUse()
	local var_108_7 = arg_108_1:findChildByName("n_count")
	local var_108_8 = var_108_5:getClanObjectUseCount()
	
	for iter_108_0 = 1, 5 do
		if var_108_6 < iter_108_0 then
			if_set_visible(var_108_7, "icon_clear" .. iter_108_0, false)
			if_set_visible(var_108_7, "icon_off" .. iter_108_0, false)
		else
			if_set_visible(var_108_7, "icon_clear" .. iter_108_0, var_108_8 < iter_108_0)
			if_set_visible(var_108_7, "icon_off" .. iter_108_0, iter_108_0 <= var_108_8)
		end
	end
	
	local var_108_9 = 5 - var_108_6
	local var_108_10 = 10
	
	if not var_108_7._origin_pos_x then
		var_108_7._origin_pos_x = var_108_7:getPositionX()
	end
	
	var_108_7:setPositionX(var_108_7._origin_pos_x - var_108_10 * var_108_9)
	
	local var_108_11 = LotaBattleSlotSystem:getSlotData(LotaUserData:getFloor(), arg_108_3)
	
	if var_108_11 and var_108_11:getSlotUserCount() > 0 then
		if not arg_108_1.slot then
			local var_108_12 = load_control("wnd/clan_heritage_mob_battle.csb")
			
			arg_108_1:addChild(var_108_12)
			
			arg_108_1.slot = var_108_12
			
			arg_108_1.slot:setPositionY(-80)
		end
		
		local var_108_13 = arg_108_1.slot
		
		if_set_visible(var_108_13, nil, true)
		if_set(var_108_13, "count_battle", tostring(var_108_11:getSlotUserCount()))
	else
		if_set_visible(arg_108_1.slot, nil, false)
	end
end

function LotaUtil.updateMovableInfoUI(arg_109_0, arg_109_1, arg_109_2, arg_109_3)
	local var_109_0 = arg_109_1:findChildByName("t_lv")
	
	if_set(var_109_0, nil, arg_109_2:getLevel())
	
	if not arg_109_3 then
		local var_109_1 = arg_109_1:findChildByName("t_name")
		
		if_set(var_109_1, nil, arg_109_2:getName())
	end
end

function LotaUtil.settingStats(arg_110_0, arg_110_1, arg_110_2, arg_110_3, arg_110_4)
	local var_110_0 = {
		"att",
		"acc",
		"cri",
		"cri_dmg",
		"max_hp",
		"def",
		"speed",
		"res",
		"coop"
	}
	local var_110_1 = arg_110_0:getRoleStatId(arg_110_2, arg_110_3)
	local var_110_2
	
	if arg_110_4 then
		var_110_2 = arg_110_0:getRoleStatId(arg_110_2, arg_110_4)
	end
	
	if var_110_1 == nil then
		Log.e("clan_heritage_role_stat_data! RANKSTATID NIL")
		
		return 
	end
	
	local var_110_3 = DBT("clan_heritage_role_stat_data", var_110_1, {
		"att",
		"def",
		"max_hp",
		"speed",
		"cri",
		"cri_dmg",
		"coop",
		"acc",
		"res"
	})
	
	if not var_110_3 then
		Log.e("ERR ERR ERR stat_value_result!")
	end
	
	local var_110_4 = {}
	
	if var_110_2 then
		local var_110_5 = DBT("clan_heritage_role_stat_data", var_110_2, {
			"att",
			"def",
			"max_hp",
			"speed",
			"cri",
			"cri_dmg",
			"coop",
			"acc",
			"res"
		})
		
		for iter_110_0, iter_110_1 in pairs(var_110_5) do
			if var_110_3[iter_110_0] ~= iter_110_1 then
				var_110_4[iter_110_0] = true
			end
		end
	end
	
	local var_110_6 = {
		coop = true,
		res = true,
		cri = true,
		cri_dmg = true,
		acc = true
	}
	
	for iter_110_2, iter_110_3 in pairs(var_110_0) do
		local var_110_7 = var_110_3[iter_110_3] or 999
		
		if iter_110_3 ~= "speed" then
			if_set(arg_110_1, "txt_stat0" .. iter_110_2, var_110_7, false, "ratioExpand")
		else
			if_set(arg_110_1, "txt_stat0" .. iter_110_2, var_110_7)
		end
		
		local var_110_8 = arg_110_1:findChildByName("txt_stat0" .. iter_110_2)
		
		if not var_110_8._default_color then
			var_110_8._default_color = var_110_8:getTextColor()
		end
		
		if var_110_4[iter_110_3] then
			var_110_8:setTextColor(cc.c3b(255, 120, 0))
		else
			var_110_8:setTextColor(var_110_8._default_color)
		end
	end
end

function LotaUtil.getLotaUnits(arg_111_0)
	local var_111_0 = {}
	
	for iter_111_0, iter_111_1 in pairs(Account.units) do
		if LotaUserData:isRegistration(iter_111_1) then
			local var_111_1 = iter_111_1:clone()
			
			var_111_1.ui_vars.lota_mode = true
			
			var_111_1:addContentEnhance()
			var_111_1:calc()
			table.insert(var_111_0, var_111_1)
		end
	end
	
	return var_111_0
end

function LotaUtil.isSlotHaveRemainEnterCount(arg_112_0, arg_112_1)
	local var_112_0 = LotaBattleSlotSystem:getSlotData(LotaUserData:getFloor(), arg_112_1)
	
	if not var_112_0 then
		return true
	end
	
	local var_112_1 = LotaObjectSystem:getObject(arg_112_1)
	
	if not var_112_1 then
		Log.e("CHK CHK object NIL : " .. arg_112_1)
		
		return 
	end
	
	local var_112_2 = math.min(var_112_1:getMonsterHP(), var_112_0:getSlotMaxCount())
	
	return var_112_0:isAvailableEnter(var_112_2)
end

function LotaUtil.getChildIdList(arg_113_0, arg_113_1, arg_113_2)
	if not arg_113_2 then
		return 
	end
	
	local var_113_0 = string.split(arg_113_2, ";")
	local var_113_1 = LotaTileMapSystem:getPosById(arg_113_1)
	local var_113_2 = {}
	
	for iter_113_0, iter_113_1 in pairs(var_113_0) do
		local var_113_3 = string.split(iter_113_1, ",")
		local var_113_4 = to_n(var_113_3[1])
		local var_113_5 = to_n(var_113_3[2])
		local var_113_6 = LotaUtil:getAddedPosition(var_113_1, {
			x = var_113_4,
			y = var_113_5
		})
		local var_113_7 = LotaTileMapSystem:getTileIdByPos(var_113_6)
		
		table.insert(var_113_2, var_113_7)
	end
	
	return var_113_2
end

function LotaUtil.createChildIdListToObjectInfo(arg_114_0, arg_114_1)
	if not arg_114_1 then
		return 
	end
	
	if arg_114_1.child_id and not table.empty(arg_114_1.child_id) then
		return 
	end
	
	local var_114_0 = arg_114_1.object_id
	local var_114_1 = DB("clan_heritage_object_data", var_114_0, "add_select")
	
	if not var_114_1 then
		return 
	end
	
	arg_114_1.child_id = LotaUtil:getChildIdList(arg_114_1.tile_id, var_114_1)
end

function LotaUtil.get5GradeLegacyIndex(arg_115_0)
	for iter_115_0, iter_115_1 in pairs(LotaUserData:getArtifacts() or {}) do
		if iter_115_1:getGrade() == 5 then
			return iter_115_0
		end
	end
end

function LotaUtil.getSameEffectLegacyIndex(arg_116_0, arg_116_1)
	for iter_116_0, iter_116_1 in pairs(LotaUserData:getArtifacts() or {}) do
		if iter_116_1:getSkillEffect() == arg_116_1:getSkillEffect() then
			return iter_116_0
		end
	end
end

function LotaUtil.isRequireArtifactChange(arg_117_0, arg_117_1)
	if arg_117_0:get5GradeLegacyIndex() ~= nil and arg_117_1:getGrade() == 5 then
		return true
	end
	
	if arg_117_0:getSameEffectLegacyIndex(arg_117_1) ~= nil then
		return true
	end
	
	return false
end

function LotaUtil.isOutsideScreen(arg_118_0, arg_118_1)
	local var_118_0 = arg_118_1:getContentSize()
	local var_118_1 = SceneManager:convertToSceneSpace(arg_118_1, {
		x = 0,
		y = 0
	})
	local var_118_2 = var_118_0.width
	local var_118_3 = var_118_0.height
	
	if var_118_1.x < 0 or var_118_1.x + var_118_2 > VIEW_WIDTH or var_118_1.y < 0 or var_118_1.y + var_118_3 > VIEW_HEIGHT then
		return true
	end
	
	return false
end

function LotaUtil.getMemoTile(arg_119_0, arg_119_1)
	local var_119_0 = arg_119_1:getTileId()
	local var_119_3
	
	if LotaUtil:isTileHaveAddSelect(arg_119_1) then
		local var_119_1 = LotaObjectSystem:getObject(arg_119_1:getTileId())
		local var_119_2 = table.clone(var_119_1:getChildTileList())
		
		table.insert(var_119_2, var_119_1:getUID())
		
		var_119_3 = 0
		
		for iter_119_0, iter_119_1 in pairs(var_119_2) do
			local var_119_4 = LotaTileMapSystem:getTileById(iter_119_1)
			local var_119_5 = var_119_4:getPos().x
			
			if var_119_3 < var_119_5 then
				var_119_3 = var_119_5
				var_119_0 = var_119_4:getTileId()
			end
		end
	end
	
	return LotaTileMapSystem:getTileById(var_119_0)
end

function LotaUtil.getNearScreenPoint(arg_120_0, arg_120_1)
	local var_120_0 = SceneManager:convertToSceneSpace(arg_120_1, {
		x = 0,
		y = 0
	})
	
	return math.abs(VIEW_WIDTH / 2 - var_120_0.x) + math.abs(VIEW_HEIGHT / 2 - var_120_0.y)
end

function LotaUtil.getMapMinMaxPos(arg_121_0)
	local var_121_0 = LotaWhiteboard:get("map_min_x")
	local var_121_1 = LotaWhiteboard:get("map_min_y")
	local var_121_2 = LotaWhiteboard:get("map_max_x")
	local var_121_3 = LotaWhiteboard:get("map_max_y")
	
	return {
		x = var_121_0,
		y = var_121_1
	}, {
		x = var_121_2,
		y = var_121_3
	}
end

function LotaUtil.getWorldMinMaxPos(arg_122_0)
	local var_122_0, var_122_1 = arg_122_0:getMapMinMaxPos()
	local var_122_2 = LotaUtil:calcTilePosToWorldPos(var_122_0)
	local var_122_3 = LotaUtil:calcTilePosToWorldPos(var_122_1)
	
	return var_122_2, var_122_3
end
