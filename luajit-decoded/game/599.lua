CustomLobbyUnit = {}

function CustomLobbyUnit.setupZoom(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = CustomLobbyUnit.Util:createZoomController(arg_1_1)
	
	CustomLobby:setupZoom(var_1_0, arg_1_2)
end

function CustomLobbyUnit.getPortraitPosesContentSz(arg_2_0)
	return {
		width = 788,
		height = 442
	}
end

function CustomLobbyUnit.load(arg_3_0, arg_3_1)
	local var_3_0, var_3_1 = CustomLobby:getDefaultNodes("hero")
	
	arg_3_1:addChild(var_3_0)
	
	local var_3_2 = arg_3_0.Data:getUnitSettingData()
	
	arg_3_0:setupZoom(var_3_1, var_3_2.zoom_cont)
	arg_3_0:createBg(var_3_0:getChildByName("n_lobby"), var_3_2)
	arg_3_0:createUnit(var_3_1, var_3_2)
	arg_3_0:createSticker(var_3_0:getChildByName("n_lobby"), var_3_2)
end

function CustomLobbyUnit.isActive(arg_4_0)
	local var_4_0 = Lobby:getBarLayer()
	
	if not get_cocos_refid(var_4_0) then
		return 
	end
	
	return get_cocos_refid(var_4_0:getChildByName("n_lobby")) ~= false and SAVE:getKeep("custom_lobby.mode") == "hero"
end

function CustomLobbyUnit.reload(arg_5_0)
	local var_5_0 = Lobby:getBarLayer()
	local var_5_1 = var_5_0:getChildByName("n_lobby")
	
	if get_cocos_refid(var_5_1) then
		var_5_1:removeFromParent()
	end
	
	arg_5_0:load(var_5_0)
end

function CustomLobbyUnit.createUnit(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0, var_6_1 = UIUtil:getPortraitAni(arg_6_2.face_id)
	
	CustomLobbyUnit.Util:setPortraitPoses(var_6_0, CustomLobbyUnit:getPortraitPosesContentSz(), var_6_1)
	
	if var_6_0 and var_6_0.setSkin and arg_6_2.emotion_id then
		var_6_0:setSkin(arg_6_2.emotion_id)
	end
	
	arg_6_1:addChild(var_6_0)
end

function CustomLobbyUnit.createBg(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0.Util:setupBG(arg_7_1, arg_7_2.background_id):setName("bg")
end

function CustomLobbyUnit.getSortedStickerList(arg_8_0, arg_8_1)
	arg_8_1 = arg_8_1 or {}
	
	local var_8_0 = {}
	
	for iter_8_0, iter_8_1 in pairs(arg_8_1) do
		table.insert(var_8_0, iter_8_1)
	end
	
	if var_8_0[1] and var_8_0[1].uid then
		table.sort(var_8_0, function(arg_9_0, arg_9_1)
			return to_n(arg_9_0.uid) < to_n(arg_9_1.uid)
		end)
	end
	
	return var_8_0
end

function CustomLobbyUnit.createSticker(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0.Sticker:setStickerLayer(arg_10_1)
	local var_10_1 = arg_10_2.stickers
	local var_10_2 = arg_10_0:getSortedStickerList(var_10_1)
	
	for iter_10_0 = 1, #var_10_2 do
		local var_10_3 = var_10_2[iter_10_0]
		
		var_10_3.uid = iter_10_0
		
		local var_10_4 = CustomLobbyUnit.Sticker:getStickerRenderObject(var_10_3)
		
		var_10_0:addChild(var_10_4)
	end
end

function CustomLobbyUnit.verifySave(arg_11_0)
	local var_11_0 = arg_11_0.Data:loadUnitSettingData()
	
	if not var_11_0 then
		return false
	end
	
	if not DB("character", var_11_0.unit_id, "id") then
		print("not exist character")
		
		return false
	end
	
	if var_11_0.face_id and not DB("character", var_11_0.face_id, "id") then
		print("not face id")
		
		return false
	end
	
	if not var_11_0.background_id or not DB("item_material_bgpack", var_11_0.background_id, "id") then
		print("not background id")
		
		return false
	end
	
	if not CustomLobby:checkZoomCont(var_11_0) then
		return false
	end
	
	if not var_11_0.stickers or type(var_11_0.stickers) ~= "table" then
		print("invalid stickers")
		
		return false
	end
	
	return true
end

function CustomLobbyUnit.setAsDefault(arg_12_0)
	local var_12_0 = CustomLobbyUnit.Data:getDefaultSettingData()
	
	CustomLobbyUnit.Data:saveUnitSettingDataWithTable(var_12_0)
end

function CustomLobbyUnit.playUnitEnterSound(arg_13_0)
	local var_13_0 = arg_13_0.Data:getUnitSettingData()
	local var_13_1 = SAVE:getKeep("custom_lobby.unit.enter_sound")
	local var_13_2 = var_13_0.face_id or var_13_0.unit_id
	
	if var_13_1 then
		if DB("character", var_13_0.unit_id, "face_id") == var_13_2 then
			var_13_2 = var_13_0.unit_id
		end
		
		local var_13_3 = DB("character", var_13_2, "model_id")
		
		if get_cocos_refid(arg_13_0._voice) then
			arg_13_0._voice:stop()
			
			arg_13_0._voice = nil
		end
		
		arg_13_0._voice = SoundEngine:play(string.format("event:/voc/character/%s/evt/get", var_13_3))
		
		SAVE:setKeep("custom_lobby.unit.enter_sound", nil)
	end
end

CustomLobbyUnit.Util = {}

function CustomLobbyUnit.Util.setPortraitPoses(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = arg_14_2.width
	local var_14_1 = arg_14_2.height
	local var_14_2 = 0
	local var_14_3 = {
		x = 0,
		y = 0
	}
	local var_14_4 = var_14_3.x
	local var_14_5 = var_14_3.y
	local var_14_6 = arg_14_0:getPortraitDefaultPosition(var_14_0, var_14_1)
	
	arg_14_1:setPosition(var_14_6.x + var_14_4, var_14_6.y + var_14_5)
	arg_14_1:setScale(var_14_2 + arg_14_0:getPortraitDefaultScale())
	
	if not arg_14_3 then
		arg_14_1:setPositionY(0)
	end
end

function CustomLobbyUnit.Util.getPortraitDefaultPosition(arg_15_0, arg_15_1, arg_15_2)
	return {
		x = arg_15_1 * 0,
		y = -arg_15_2 * 1.5
	}
end

function CustomLobbyUnit.Util.createZoomController(arg_16_0, arg_16_1)
	return (ZoomController({
		max_scale = 1.2,
		min_scale = 0.8,
		head_line_check = true,
		max_y = 300,
		min_y = -100,
		scale = 1,
		layer = arg_16_1,
		min_x = -VIEW_WIDTH / 2,
		max_x = VIEW_WIDTH / 2,
		sz = {
			width = VIEW_WIDTH,
			height = VIEW_HEIGHT
		}
	}))
end

function CustomLobbyUnit.Util.setupBG(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = CustomLobbyUnit.Data:getBGData(arg_17_2)
	local var_17_1 = var_17_0.background_id
	
	if not var_17_1 then
		local var_17_2 = CustomLobbyUnit.Data:getDefaultSettingData()
		
		var_17_0 = CustomLobbyUnit.Data:getBGData(var_17_2.background_id)
		var_17_1 = var_17_0.background_id
	end
	
	if not string.find(var_17_1, ".png") then
		local var_17_3, var_17_4 = FIELD_NEW:create(var_17_1, DESIGN_WIDTH * 2)
		local var_17_5 = var_17_3
		local var_17_6 = cc.Node:create()
		
		var_17_6:setPosition(0, 0)
		
		local var_17_7 = var_17_5:findChildByName("@field_game_layer")
		
		var_17_7:setAnchorPoint(0.5, 0.5)
		var_17_7:setPosition(var_17_0.x - 640, var_17_0.y)
		var_17_7:setScale(var_17_0.bg_scale)
		var_17_4:lockViewPortRange({
			minRangeX = -DESIGN_WIDTH * 2,
			maxRangeX = DESIGN_WIDTH * 2
		})
		var_17_4:setViewPortPosition(var_17_0.vp or VIEW_WIDTH / 2)
		var_17_4:updateViewport()
		var_17_6:setLocalZOrder(-1)
		var_17_6:addChild(var_17_5)
		arg_17_1:addChild(var_17_6)
		
		return var_17_3, var_17_4
	else
		var_17_1 = var_17_1 or "(NO EXIST)"
		
		local var_17_8 = SpriteCache:getSprite(var_17_1)
		
		if not var_17_8 then
			Log.e("BG PATH " .. var_17_1 .. " not exist.")
			
			var_17_8 = cc.LayerColor:create(cc.c3b(255, 221, 27))
			
			arg_17_1:addChild(var_17_8)
			
			return var_17_8
		end
		
		arg_17_1:addChild(var_17_8)
		var_17_8:setLocalZOrder(-1)
		var_17_8:setPositionY(DESIGN_HEIGHT / 2)
		
		return var_17_8
	end
end

function CustomLobbyUnit.Util.getPortraitDefaultScale(arg_18_0)
	return 1.4
end

CustomLobbyUnit.Sticker = {}

function CustomLobbyUnit.Sticker.stickerImgPathToRealPath(arg_19_0, arg_19_1)
	if not arg_19_1 then
		Log.e("NOT EXIST sticker_img.")
	end
	
	return "item/sticker/" .. (arg_19_1 or "") .. ".png"
end

function CustomLobbyUnit.Sticker.getSpritePath(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0:getStickerData(arg_20_1)
	
	if not var_20_0 then
		return 
	end
	
	return arg_20_0:stickerImgPathToRealPath(var_20_0.sticker_img)
end

function CustomLobbyUnit.Sticker.getStickerData(arg_21_0, arg_21_1)
	local var_21_0, var_21_1, var_21_2 = DB("item_material", arg_21_1, {
		"ma_type",
		"ma_type2",
		"sticker_img"
	})
	
	return {
		id = arg_21_1,
		ma_type = var_21_0,
		ma_type2 = var_21_1,
		sticker_img = var_21_2
	}
end

function CustomLobbyUnit.Sticker.getStickerDefaultSize(arg_22_0)
	return 84
end

function CustomLobbyUnit.Sticker.getStickerBtnAdditionalWidth(arg_23_0)
	return 56
end

function CustomLobbyUnit.Sticker.getDragPointDefaultRadius(arg_24_0, arg_24_1)
	return arg_24_0:getStickerDefaultSize() / 4
end

function CustomLobbyUnit.Sticker.updatePreviewArea(arg_25_0, arg_25_1, arg_25_2)
	arg_25_1:clear()
	arg_25_1:drawRect(cc.p(0, 0), cc.p(arg_25_2, arg_25_2), cc.c4f(1, 1, 1, 1))
	
	local var_25_0 = arg_25_0:getDragPointDefaultRadius(arg_25_2)
	
	arg_25_1:drawSolidCircle(cc.p(0, 0), var_25_0, 0, 32, 1, 1, cc.c4f(1, 1, 1, 1))
	arg_25_1:drawSolidCircle(cc.p(arg_25_2, 0), var_25_0, 0, 32, 1, 1, cc.c4f(1, 1, 1, 1))
	arg_25_1:drawSolidCircle(cc.p(0, arg_25_2), var_25_0, 0, 32, 1, 1, cc.c4f(1, 1, 1, 1))
	arg_25_1:drawSolidCircle(cc.p(arg_25_2, arg_25_2), var_25_0, 0, 32, 1, 1, cc.c4f(1, 1, 1, 1))
end

function CustomLobbyUnit.Sticker.getStickerRenderObject(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	local var_26_0 = load_control("wnd/lobby_custom_sticker.csb")
	local var_26_1 = cc.Node:create()
	
	var_26_1:addChild(var_26_0)
	var_26_1:setName("custom_lobby_sticker:" .. arg_26_1.uid)
	var_26_1:setPosition(arg_26_1.x, arg_26_1.y)
	
	if arg_26_1.uid then
		var_26_1:setLocalZOrder(arg_26_1.uid)
	end
	
	var_26_0:setRotation(arg_26_1.rotation)
	
	local var_26_2 = arg_26_0:getSpritePath(arg_26_1.id)
	
	if_set_sprite(var_26_0, "sticker", var_26_2)
	
	local var_26_3 = var_26_0:getChildByName("btn")
	
	if not arg_26_3 then
		var_26_3:setVisible(false)
	else
		var_26_3:setVisible(true)
		var_26_3:addTouchEventListener(function(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
			arg_26_3(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
		end)
	end
	
	local var_26_4 = arg_26_0:getStickerDefaultSize() * arg_26_1.scale_x
	
	var_26_0:setContentSize({
		width = var_26_4,
		height = var_26_4
	})
	var_26_0:getChildByName("sticker"):setContentSize({
		width = var_26_4,
		height = var_26_4
	})
	
	local var_26_5 = arg_26_0:getStickerBtnAdditionalWidth()
	local var_26_6 = var_26_0:getChildByName("btn")
	
	var_26_6:setContentSize({
		width = var_26_4 + var_26_5,
		height = var_26_4 + var_26_5
	})
	var_26_6:setPosition(var_26_4 / 2, var_26_4 / 2)
	var_26_6:setAnchorPoint(0.5, 0.5)
	
	var_26_6.uid = arg_26_1.uid
	
	if arg_26_2 then
		local var_26_7 = cc.DrawNode:create(1)
		
		arg_26_0:updatePreviewArea(var_26_7, var_26_4)
		var_26_7:setName("preview_area_draw_node")
		var_26_7:setVisible(false)
		var_26_0:addChild(var_26_7)
		
		local var_26_8 = load_control("wnd/lobby_custom_sticker_x.csb")
		
		var_26_8:setScale(0.5)
		var_26_8:setPosition(var_26_4, var_26_4)
		
		local var_26_9 = var_26_8:getChildByName("btn")
		
		if get_cocos_refid(var_26_9) then
			var_26_9:setTouchEnabled(false)
		end
		
		var_26_7:addChild(var_26_8)
	end
	
	var_26_0:setAnchorPoint(0.5, 0.5)
	
	return var_26_1
end

function CustomLobbyUnit.Sticker.setStickerLayer(arg_28_0, arg_28_1)
	local var_28_0 = cc.Node:create()
	
	var_28_0:setName("sticker_layer")
	var_28_0:setLocalZOrder(2)
	arg_28_1:addChild(var_28_0)
	
	return var_28_0
end

CustomLobbyUnit.Data = {}

function CustomLobbyUnit.Data.loadUnitSettingData(arg_29_0, arg_29_1)
	local var_29_0
	local var_29_1 = arg_29_0:getDefaultSettingData()
	local var_29_2 = SAVE:getKeep("custom_lobby.unit")
	
	if var_29_2 == nil and arg_29_1 then
		return nil
	end
	
	if var_29_2 == nil and not DEBUG.TEST_UNIT_LOBBY then
		Log.e("NOT EXIST SETTING FILE! BUT TRY UNIT SETTING!!!")
		
		return var_29_1
	end
	
	if DEBUG.TEST_UNIT_LOBBY == true then
		var_29_0 = var_29_1
	else
		local var_29_3 = Base64.decode(var_29_2)
		
		if not var_29_3 then
			return 
		end
		
		var_29_0 = json.decode(var_29_3)
	end
	
	if not var_29_0 then
		return 
	end
	
	if not var_29_0.stickers then
		var_29_0.stickers = {}
	end
	
	return var_29_0
end

function CustomLobbyUnit.Data.getUnitSettingData(arg_30_0)
	return arg_30_0:loadUnitSettingData()
end

function CustomLobbyUnit.Data.getBGData(arg_31_0, arg_31_1)
	local var_31_0 = DBT("item_material_bgpack", arg_31_1, {
		"id",
		"background_id",
		"bg_scale_hero",
		"bg_position_hero"
	})
	local var_31_1 = 0
	local var_31_2 = 0
	local var_31_3 = 0
	
	if var_31_0.bg_position_hero then
		local var_31_4 = string.split(var_31_0.bg_position_hero, ",")
		
		var_31_1 = var_31_4[1]
		var_31_2 = var_31_4[2]
		var_31_3 = var_31_4[3]
		var_31_3 = var_31_3 and to_n(var_31_3)
	end
	
	return {
		id = var_31_0.id,
		bg_scale = to_n(var_31_0.bg_scale_hero or 1.2),
		x = var_31_1,
		y = var_31_2,
		vp = var_31_3,
		background_id = var_31_0.background_id
	}
end

function CustomLobbyUnit.Data.getDefaultSettingData(arg_32_0)
	local var_32_0 = Account:getMainUnit()
	local var_32_1 = "c1001"
	local var_32_2
	
	if var_32_0 then
		var_32_1 = var_32_0.db.code
		
		local var_32_3 = var_32_0.db.face_id
	end
	
	local var_32_4 = get_material_bgpack_data(true, "CustomLobby") or {}
	
	table.sort(var_32_4, function(arg_33_0, arg_33_1)
		return arg_33_0.sort < arg_33_1.sort
	end)
	
	local var_32_5
	local var_32_6 = not (var_32_4 and var_32_4[1] and var_32_4[1].id and DB("item_material_bgpack", var_32_4[1].id, "background_id")) and "ma_bg_lobby1" or var_32_4[1].id
	
	return {
		unit_id = var_32_1,
		face_id = var_32_1,
		background_id = var_32_6,
		zoom_cont = {
			pivot = {
				scale = 1,
				x = 0,
				y = 244
			},
			target = {
				x = 0,
				y = 0
			}
		},
		stickers = {}
	}
end

function clu_save_clear()
	SAVE:setKeep("custom_lobby.unit", nil)
	SAVE:setKeep("custom_lobby.unit.enter_sound", nil)
end

function CustomLobbyUnit.Data.saveUnitSettingDataWithTable(arg_35_0, arg_35_1)
	local var_35_0 = Base64.encode(json.encode(arg_35_1))
	
	if var_35_0 == SAVE:getKeep("custom_lobby.unit") then
		return false
	end
	
	SAVE:setKeep("custom_lobby.unit", var_35_0)
	
	return true
end

function CustomLobbyUnit.Data.saveUnitSettingData(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5, arg_36_6, arg_36_7, arg_36_8, arg_36_9, arg_36_10)
	local var_36_0 = {
		unit_id = arg_36_1,
		face_id = arg_36_2,
		emotion_id = arg_36_3,
		background_id = arg_36_4,
		zoom_cont = {
			pivot = {
				x = arg_36_5,
				y = arg_36_6,
				scale = arg_36_7
			},
			target = {
				x = arg_36_8,
				y = arg_36_9
			}
		},
		stickers = arg_36_10 or {}
	}
	
	return arg_36_0:saveUnitSettingDataWithTable(var_36_0)
end
