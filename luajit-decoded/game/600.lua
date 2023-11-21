CustomLobbyIllust = {}
DEBUG.USE_TL_DATABASE = false
DEBUG.USE_FORCE_SUB_GROUP = false
DEBUG.SHOW_ILLUST_COLLECTION = false

function force_sub_group(arg_1_0)
	DEBUG.USE_FORCE_SUB_GROUP = arg_1_0
	
	CustomLobbyIllust:reload()
end

function CustomLobbyIllust.setupZoom(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = CustomLobbyUnit.Util:createZoomController(arg_2_1)
	
	CustomLobby:setupZoom(var_2_0, arg_2_2, true)
end

function CustomLobbyIllust.load(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0, var_3_1 = CustomLobby:getDefaultNodes("illust")
	
	arg_3_1:addChild(var_3_0)
	
	local var_3_2 = arg_3_0.Data:getIllustSettingData()
	
	arg_3_0.Data:randRollIllustIdx(var_3_2)
	
	local var_3_3 = arg_3_0:setupZoom(var_3_1, var_3_2.zoom_cont)
	
	arg_3_0:setupIllust(var_3_1, var_3_3, var_3_2, arg_3_2)
end

function CustomLobbyIllust.isActive(arg_4_0)
	local var_4_0 = Lobby:getBarLayer()
	
	if not get_cocos_refid(var_4_0) then
		return 
	end
	
	return get_cocos_refid(var_4_0:getChildByName("n_lobby")) ~= false and SAVE:getKeep("custom_lobby.mode") == "illust"
end

function CustomLobbyIllust.reload(arg_5_0)
	local var_5_0 = Lobby:getBarLayer()
	local var_5_1 = var_5_0:getChildByName("n_lobby")
	
	if get_cocos_refid(var_5_1) then
		var_5_1:removeFromParent()
	end
	
	arg_5_0:load(var_5_0, true)
end

function CustomLobbyIllust.setupZoom(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = CustomLobbyIllust.Util:createZoomController(arg_6_1)
	
	if arg_6_2 and arg_6_2.pivot and arg_6_2.pivot.scale then
		arg_6_2.pivot.scale = arg_6_2.pivot.scale + 0.02
	end
	
	CustomLobby:setupZoom(var_6_0, arg_6_2)
	
	return var_6_0
end

function CustomLobbyIllust.setupIllust(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	local var_7_0 = arg_7_1
	local var_7_1
	local var_7_2
	local var_7_3
	local var_7_4
	local var_7_5 = arg_7_3.illust_id
	
	if arg_7_5 then
		var_7_5 = string.split(arg_7_3.illust_id, ",")[arg_7_5]
	else
		var_7_5 = arg_7_0.Data:getCurIllustId(arg_7_3)
	end
	
	print("illust_id?", var_7_5)
	
	local var_7_6 = DB("dic_data_illust", var_7_5, "illust")
	
	if string.starts(var_7_6, "theme:") then
		CustomLobbyIllust.Util:createThemeIllust(var_7_6, var_7_0, "lobby")
		
		var_7_4 = true
	else
		var_7_1, var_7_2, var_7_3 = CustomLobbyIllust.Util:createIllust(var_7_5, "lobby", arg_7_4)
	end
	
	if not var_7_1 then
		return 
	end
	
	if var_7_4 then
	elseif var_7_2 then
		var_7_0:addChild(var_7_1)
		EffectManager:EffectPlay(var_7_3)
	else
		var_7_0:addChild(var_7_1)
	end
	
	CustomLobbyIllust.Util:resetZoomController(arg_7_2, var_7_1)
	CustomLobby:setupZoom(arg_7_2, arg_7_3.zoom_cont, true)
	NotchManager:addListener(var_7_1, nil, function(arg_8_0, arg_8_1, arg_8_2)
		CustomLobbyIllust.Util:resetZoomController(arg_7_2, arg_8_0)
	end)
end

function CustomLobbyIllust.verifySave(arg_9_0)
	local var_9_0 = arg_9_0.Data:loadIllustSettingData()
	
	if not var_9_0 then
		return false
	end
	
	if not var_9_0.illust_id then
		return 
	end
	
	local var_9_1 = string.split(var_9_0.illust_id, ",")
	
	if type(var_9_1) ~= "table" or table.empty(var_9_1) then
		return false
	end
	
	for iter_9_0, iter_9_1 in pairs(var_9_1) do
		if not DB("dic_data_illust", iter_9_1, "id") then
			return false
		end
	end
	
	if not CustomLobby:checkZoomCont(var_9_0) then
		return false
	end
	
	return true
end

function CustomLobbyIllust.setAsDefault(arg_10_0)
	local var_10_0 = CustomLobbyIllust.Data:getDefaultSettingData()
	
	CustomLobbyIllust.Data:saveIllustSettingDataWithTable(var_10_0)
end

CustomLobbyIllust.Data = {}
DEBUG.TEST_ILLUST = nil

function CustomLobbyIllust.Data.loadIllustSettingData(arg_11_0, arg_11_1)
	local var_11_0
	local var_11_1 = {
		illust_id = "sub_valena_4",
		zoom_cont = {
			pivot = {
				scale = 1.5,
				x = 0,
				y = VIEW_HEIGHT / 2
			},
			target = {
				x = 0,
				y = 0
			}
		}
	}
	local var_11_2 = SAVE:getKeep("custom_lobby.illust")
	
	if var_11_2 == nil and arg_11_1 then
		return nil
	end
	
	if var_11_2 == nil and not DEBUG.TEST_ILLUST then
		Log.e("NOT EXIST SETTING FILE! BUT TRY ILLUST SETTING!!!")
		
		return var_11_1
	end
	
	local var_11_3 = Base64.decode(var_11_2)
	
	if not var_11_3 then
		return 
	end
	
	local var_11_4 = json.decode(var_11_3)
	
	if DEBUG.TEST_ILLUST ~= nil then
		var_11_4 = var_11_1
	end
	
	return var_11_4
end

function CustomLobbyIllust.Data.getIllustSettingData(arg_12_0)
	return arg_12_0:loadIllustSettingData()
end

function CustomLobbyIllust.Data.getDefaultSettingData(arg_13_0)
	local var_13_0 = CollectionDB:CreateIllustDB("lobby")
	local var_13_1 = CollectionDB:CreateCategoryDB(var_13_0.parent_DB)
	local var_13_2 = CollectionDB:GetCategories(var_13_1)[1]
	local var_13_3 = CollectionDB:GetCategoryDataList(var_13_1, var_13_2.id)
	local var_13_4 = var_13_3[#var_13_3]
	local var_13_5 = var_13_4.data[#var_13_4.data]
	
	print("getDefaultSettingData?")
	
	return {
		illust_id = var_13_5.id,
		zoom_cont = {
			pivot = {
				scale = 2,
				x = 0,
				y = 244
			},
			target = {
				x = 0,
				y = 0
			}
		}
	}
end

function cli_save_clear()
	SAVE:setKeep("custom_lobby.illust", nil)
end

function cli_test_save()
	SAVE:setKeep("custom_lobby.illust", json.encode({
		illust_id = "episode_1_2,episode_1_3,episode_1_10,episode_2_10",
		zoom_cont = {
			pivot = {
				scale = 2,
				x = 0,
				y = 244
			},
			target = {
				x = 0,
				y = 0
			}
		}
	}))
end

function CustomLobbyIllust.Data.saveIllustSettingDataWithTable(arg_16_0, arg_16_1)
	local var_16_0 = Base64.encode(json.encode(arg_16_1))
	
	if var_16_0 == SAVE:getKeep("custom_lobby.illust") then
		return false
	end
	
	SAVE:setKeep("custom_lobby.illust", var_16_0)
	
	return true
end

function CustomLobbyIllust.Data.saveIllustSettingData(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6)
	local var_17_0 = {
		illust_id = arg_17_1,
		zoom_cont = {
			pivot = {
				x = arg_17_2 or 0,
				y = arg_17_3 or 360,
				scale = arg_17_4 or 1
			},
			target = {
				x = arg_17_5 or 0,
				y = arg_17_6 or 0
			}
		}
	}
	
	return arg_17_0:saveIllustSettingDataWithTable(var_17_0)
end

function CustomLobbyIllust.Data.randRollIllustIdx(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_1.illust_id
	
	if not var_18_0 then
		print("rand roll failed. not exist illust_id?", table.tostring(arg_18_1))
		
		return 
	end
	
	local var_18_1 = string.split(var_18_0, ",")
	
	arg_18_0._illust_rand_idx = math.random(1, #var_18_1)
end

function CustomLobbyIllust.Data.getCurIllustId(arg_19_0, arg_19_1)
	if not arg_19_1 then
		return 
	end
	
	local var_19_0 = string.split(arg_19_1.illust_id, ",")
	
	if type(var_19_0) ~= "table" or table.empty(var_19_0) then
		if arg_19_1.illust_id then
			return arg_19_1.illust_id
		else
			return 
		end
	end
	
	return var_19_0[arg_19_0._illust_rand_idx]
end

CustomLobbyIllust.Util = {}

function CustomLobbyIllust.Util.createZoomController(arg_20_0, arg_20_1)
	return ZoomController({
		max_scale = 2.8,
		layer = arg_20_1,
		sz = {
			width = VIEW_WIDTH,
			height = VIEW_HEIGHT
		}
	})
end

function CustomLobbyIllust.Util.resetZoomController(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_2:getContentSize()
	local var_21_1 = math.max(VIEW_WIDTH / var_21_0.width, VIEW_HEIGHT / var_21_0.height)
	
	arg_21_1:resetLayer(arg_21_2, {
		width = VIEW_WIDTH * (1 / var_21_1),
		height = VIEW_HEIGHT * (1 / var_21_1)
	}, 0, VIEW_HEIGHT / 2, var_21_1)
end

function CustomLobbyIllust.Util.getSchedulerName(arg_22_0, arg_22_1)
	return "idle_balloon_" .. (arg_22_1 or "unknown")
end

function CustomLobbyIllust.Util.safeReleaseScheudler(arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0:getSchedulerName(arg_23_1)
	
	if Scheduler:findByName(var_23_0) then
		Scheduler:removeByName(var_23_0)
	end
end

function CustomLobbyIllust.Util.getIllustIdToTable(arg_24_0, arg_24_1)
	return (string.split(arg_24_1.illust_id, ","))
end

function CustomLobbyIllust.Util.isUseSound(arg_25_0, arg_25_1)
	local var_25_0 = false
	
	if string.find(arg_25_1, "lobby") then
		var_25_0 = true
	end
	
	return var_25_0
end

local function var_0_0(arg_26_0)
	CustomLobbyIllust.Util:onSoundCallback(arg_26_0)
end

function CustomLobbyIllust.Util.createThemeIllust(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	local var_27_0 = string.split(arg_27_1, ":")[2]
	local var_27_1 = ccui.Layout:create()
	
	var_27_1:setContentSize(1580, 720)
	var_27_1:setAnchorPoint(0.5, 0.5)
	var_27_1:setClippingEnabled(true)
	
	local var_27_2 = var_27_1
	
	arg_27_2:addChild(var_27_1)
	
	local var_27_3
	local var_27_4
	
	arg_27_1, var_27_4 = TLDatabase:createThemeIllustByRandomList(var_27_0, arg_27_3 == "lobby", DEBUG.USE_FORCE_SUB_GROUP, var_27_1)
	
	var_27_2:setCascadeOpacityEnabled(true)
	
	return var_27_2
end

function CustomLobbyIllust.Util.createIllust(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	local var_28_0 = DB("dic_data_illust", arg_28_1, "illust")
	local var_28_1
	local var_28_2 = string.find(var_28_0, ".cfx") ~= nil
	local var_28_3
	
	if var_28_2 then
		local var_28_4 = ccui.Layout:create()
		
		var_28_4:setContentSize(1580, 720)
		var_28_4:setAnchorPoint(0.5, 0.5)
		var_28_4:setClippingEnabled(true)
		
		var_28_1 = var_28_4
		
		local var_28_5 = CACHE:getEffect(var_28_0, "effect")
		
		var_28_3 = {
			effect = var_28_5,
			layer = var_28_4,
			fn = var_28_0
		}
		
		local var_28_6 = 1580
		local var_28_7 = 720
		
		var_28_3.x = var_28_6 / 2
		var_28_3.y = var_28_7 / 2
	elseif string.starts(var_28_0, "special:") then
		local var_28_8 = ccui.Layout:create()
		
		var_28_8:setContentSize(1580, 720)
		var_28_8:setAnchorPoint(0.5, 0.5)
		var_28_8:setClippingEnabled(true)
		
		var_28_1 = var_28_8
		
		local var_28_9 = string.split(var_28_0, ":")[2]
		
		var_28_0, var_28_3 = UIUtil:getSpecialIllust(var_28_9)
		var_28_3.layer = var_28_8
		var_28_3.x = 790
		var_28_3.y = 360
		var_28_2 = true
	else
		var_28_1 = cc.Sprite:create(UIUtil:getIllustPath("story/bg/", var_28_0))
	end
	
	if not var_28_1 then
		return 
	end
	
	var_28_1:setCascadeOpacityEnabled(true)
	var_28_1:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	
	local var_28_10, var_28_11, var_28_12, var_28_13, var_28_14 = DB("dic_data_illust", arg_28_1, {
		"balloon_enter",
		"balloon_idle",
		"balloon_touch",
		"balloon_type",
		"balloon_position"
	})
	
	if var_28_10 or var_28_11 or var_28_12 then
		local var_28_15 = load_dlg("balloon_lobby", true, "wnd")
		
		var_28_15:setName("balloon_lobby")
		
		var_28_15.balloon_type = var_28_13
		
		var_28_1:addChild(var_28_15)
		if_set_visible(var_28_1, "balloon_right_bottom", false)
		if_set_visible(var_28_1, "balloon_left_bottom", false)
		if_set_visible(var_28_1, "balloon_left_top", false)
		if_set_visible(var_28_1, var_28_13, true)
		
		local var_28_16 = var_28_15:findChildByName(var_28_13)
		local var_28_17 = string.split(var_28_14, ",")
		
		if var_28_17 then
			local var_28_18 = tonumber(var_28_17[1])
			local var_28_19 = tonumber(var_28_17[2])
			
			var_28_16:setPosition(640 - var_28_18 + 100, 680 - var_28_19)
		end
		
		local var_28_20 = arg_28_0:getSchedulerName(arg_28_2)
		
		if Scheduler:findByName(var_28_20) then
			Scheduler:removeByName(var_28_20)
		end
		
		local var_28_21 = arg_28_0:isUseSound(var_28_20)
		
		if arg_28_3 then
			var_28_21 = false
		end
		
		arg_28_0:ifSoundThenStop()
		
		if var_28_10 then
			UIUtil:showBalloonInSpineIllust(var_28_16, var_28_10, "enter_balloon", 600, 0, var_28_21, var_0_0)
		else
			var_28_16:setOpacity(0)
		end
		
		var_28_15:setLocalZOrder(999)
		
		local var_28_22 = ccui.Button:create()
		
		var_28_22:setTouchEnabled(true)
		var_28_22:ignoreContentAdaptWithSize(false)
		var_28_22:setContentSize(VIEW_WIDTH * 2, VIEW_HEIGHT * 2)
		var_28_22:setPosition(0, 360)
		var_28_22:setName("btn_center")
		var_28_15:addChild(var_28_22)
		
		if not arg_28_0._last_balloon_tm then
			arg_28_0._last_balloon_tm = {}
		end
		
		arg_28_0._last_balloon_tm[var_28_20] = uitick()
		
		var_28_15:findChildByName("btn_center"):addTouchEventListener(function(arg_29_0, arg_29_1)
			SceneManager:updateTouchEventTime()
			
			if arg_29_1 == ccui.TouchEventType.began then
				print("touchBalloon?", arg_28_1)
				arg_28_0:touchBalloon(arg_28_1, var_28_1, var_28_20)
			end
		end)
		
		if var_28_11 then
			Scheduler:addInterval(var_28_1, 1000, function(arg_30_0, arg_30_1, arg_30_2)
				if not get_cocos_refid(arg_30_2) then
					return 
				end
				
				local var_30_0 = arg_30_2:getParent()
				
				if not get_cocos_refid(var_30_0) then
					print("parent?")
					Scheduler:removeByName(var_28_20)
					
					return 
				end
				
				local var_30_1 = var_30_0:getParent()
				
				if not get_cocos_refid(var_30_1) then
					print("grand_parent?")
					Scheduler:removeByName(var_28_20)
					
					return 
				end
				
				local var_30_2 = "idle_balloon_setting"
				local var_30_3 = "idle_balloon_lobby"
				local var_30_4 = "idle_balloon_choose"
				
				if var_28_20 == var_30_3 and (Scheduler:findByName(var_30_2) or Scheduler:findByName(var_30_4)) then
					return 
				end
				
				if var_28_20 == var_30_4 and Scheduler:findByName(var_30_2) then
					return 
				end
				
				if var_28_20 == var_30_3 and not Lobby:isHideAllUINodeStatus() then
					return 
				end
				
				arg_30_0:showIdleBalloon(arg_30_1, arg_30_2, var_28_20)
			end, arg_28_0, arg_28_1, var_28_1):setName(var_28_20)
		end
	end
	
	return var_28_1, var_28_2, var_28_3
end

local var_0_1 = 24000

function CustomLobbyIllust.Util.removeAllScheduler(arg_31_0)
	local var_31_0 = {
		"idle_balloon_setting",
		"idle_balloon_lobby",
		"idle_balloon_choose"
	}
	
	for iter_31_0, iter_31_1 in pairs(var_31_0) do
		if Scheduler:findByName(iter_31_1) then
			Scheduler:removeByName(iter_31_1)
		end
	end
end

function CustomLobbyIllust.Util.onSoundCallback(arg_32_0, arg_32_1)
	if arg_32_1 then
		arg_32_0._balloon_sound = arg_32_1
	end
end

function CustomLobbyIllust.Util.ifSoundThenStop(arg_33_0)
	if arg_33_0._balloon_sound and get_cocos_refid(arg_33_0._balloon_sound) then
		arg_33_0._balloon_sound:stop()
		
		arg_33_0._balloon_sound = nil
	end
end

function CustomLobbyIllust.Util.touchBalloon(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	if not arg_34_2 or not get_cocos_refid(arg_34_2) then
		return 
	end
	
	if UIAction:Find("touch_balloon") or UIAction:Find("enter_balloon") then
		return 
	end
	
	local var_34_0 = uitick()
	
	arg_34_0._last_balloon_tm[arg_34_3] = var_34_0
	
	arg_34_0:ifSoundThenStop()
	UIAction:Remove("enter_balloon")
	UIAction:Remove("idle_balloon")
	UIAction:Remove("touch_balloon")
	UIAction:Remove("shop_balloon")
	
	local var_34_1, var_34_2, var_34_3, var_34_4, var_34_5 = DB("dic_data_illust", arg_34_1, {
		"balloon_enter",
		"balloon_idle",
		"balloon_touch",
		"balloon_type",
		"balloon_position"
	})
	local var_34_6 = arg_34_2:getChildByName("balloon_lobby")
	local var_34_7 = var_34_6:findChildByName(var_34_6.balloon_type or "balloon_left_bottom")
	local var_34_8 = arg_34_0:isUseSound(arg_34_3)
	
	UIUtil:showBalloonInSpineIllust(var_34_7, var_34_3, "touch_balloon", 600, 0, var_34_8, var_0_0)
end

function CustomLobbyIllust.Util.showIdleBalloon(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	if UIAction:Find("enter_balloon") or UIAction:Find("idle_balloon") or UIAction:Find("touch_balloon") or UIAction:Find("shop_balloon") then
		return 
	end
	
	local var_35_0 = uitick()
	
	if var_35_0 - arg_35_0._last_balloon_tm[arg_35_3] < var_0_1 then
		return 
	end
	
	arg_35_0._last_balloon_tm[arg_35_3] = var_35_0
	
	arg_35_0:ifSoundThenStop()
	
	local var_35_1, var_35_2, var_35_3, var_35_4, var_35_5 = DB("dic_data_illust", arg_35_1, {
		"balloon_enter",
		"balloon_idle",
		"balloon_touch",
		"balloon_type",
		"balloon_position"
	})
	
	if var_35_2 then
		local var_35_6 = arg_35_2:getChildByName("balloon_lobby")
		local var_35_7 = var_35_6:findChildByName(var_35_6.balloon_type or "balloon_left_bottom")
		local var_35_8 = arg_35_0:isUseSound(arg_35_3)
		
		UIUtil:showBalloonInSpineIllust(var_35_7, var_35_2, "idle_balloon", 0, 0, var_35_8, var_0_0)
	end
end
