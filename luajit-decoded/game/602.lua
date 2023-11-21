CustomLobby = {}

function CustomLobby.getDefaultNodes(arg_1_0, arg_1_1)
	local var_1_0 = cc.Node:create()
	local var_1_1 = cc.Node:create()
	
	var_1_1:setName("n_lobby")
	var_1_1:setPositionX(640)
	
	local var_1_2 = cc.Node:create()
	
	var_1_2:setName("n_portrait")
	var_1_2:setPosition(0, 0)
	var_1_1:addChild(var_1_2)
	
	local var_1_3 = cc.LayerColor:create(cc.c3b(0, 0, 0))
	
	var_1_3:setContentSize(10000, 10000)
	var_1_3:setPositionX(-5000)
	var_1_3:setOpacity(0)
	var_1_3:setName("dim_layer")
	var_1_0:addChild(var_1_1)
	var_1_0:addChild(var_1_3)
	
	return var_1_0, var_1_2
end

function CustomLobby.setupZoom(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_1.pivot
	local var_2_1 = arg_2_1.target
	
	var_2_0:setPosition(arg_2_2.pivot.x, arg_2_2.pivot.y)
	
	if arg_2_3 then
	else
		var_2_0:setScale(arg_2_2.pivot.scale)
	end
	
	var_2_1:setPosition(arg_2_2.target.x, arg_2_2.target.y)
end

function CustomLobby.setAsIllustLobby(arg_3_0)
	SAVE:setKeep("custom_lobby.mode", "illust")
end

function CustomLobby.setAsHeroLobby(arg_4_0)
	SAVE:setKeep("custom_lobby.mode", "hero")
end

function CustomLobby.setAsDefaultLobby(arg_5_0)
	SAVE:setKeep("custom_lobby.mode", "default")
end

function CustomLobby.checkZoomCont(arg_6_0, arg_6_1)
	if not arg_6_1.zoom_cont then
		print("not zoom_cont")
		
		return false
	end
	
	local var_6_0 = arg_6_1.zoom_cont
	
	if not var_6_0.pivot then
		print("not zoom_cont pivot")
		
		return false
	end
	
	local var_6_1 = var_6_0.pivot
	
	if type(var_6_1.x) ~= "number" or type(var_6_1.y) ~= "number" or type(var_6_1.scale) ~= "number" then
		print("invalid pivot")
		
		return false
	end
	
	local var_6_2 = var_6_0.target
	
	if not var_6_2 then
		print("not exist zoom_cont target")
		
		return false
	end
	
	if type(var_6_2.x) ~= "number" or type(var_6_2.y) ~= "number" then
		print("invalid target")
		
		return false
	end
	
	return true
end

function CustomLobby.setAsDefaultOnNotExistSave(arg_7_0)
	if not SAVE:getKeep("custom_lobby.unit") or not CustomLobbyUnit:verifySave() then
		CustomLobbyUnit:setAsDefault()
	end
	
	if not SAVE:getKeep("custom_lobby.illust") or not CustomLobbyIllust:verifySave() then
		print("setAsDefaultOnNotExistSave")
		CustomLobbyIllust:setAsDefault()
	end
end

function MsgHandler.select_custom_lobby(arg_8_0)
	if arg_8_0.update_user_configs then
		Account:updateUserConfigs(arg_8_0.update_user_configs)
	end
	
	if not arg_8_0.just_save then
		local var_8_0 = SceneManager:getRunningScene()
		
		if var_8_0 then
			var_8_0:clearSceneArgs()
		end
		
		SceneManager:reload()
	end
end

function CustomLobby.sendSaveQuery(arg_9_0, arg_9_1)
	local var_9_0 = SAVE:getKeep("custom_lobby.illust")
	local var_9_1 = SAVE:getKeep("custom_lobby.unit")
	local var_9_2 = SAVE:getKeep("custom_lobby.mode") or "default"
	local var_9_3
	local var_9_4
	
	if var_9_0 then
		local var_9_5 = Base64.decode(var_9_0)
		
		if var_9_5 then
			var_9_3 = json.decode(var_9_5)
		end
	end
	
	if var_9_1 then
		local var_9_6 = Base64.decode(var_9_1)
		
		if var_9_6 then
			var_9_4 = json.decode(var_9_6)
		end
	end
	
	local function var_9_7(arg_10_0)
		local var_10_0 = arg_10_0.pivot or {}
		local var_10_1 = arg_10_0.target or {}
		
		var_10_0.x = math.floor(var_10_0.x or 0)
		var_10_0.y = math.floor(var_10_0.y or 0)
		
		local var_10_2 = var_10_0.scale or 1
		
		var_10_0.s = to_n(string.format("%.2f", var_10_2))
		var_10_0.scale = nil
		var_10_1.x = math.floor(var_10_1.x or 0)
		var_10_1.y = math.floor(var_10_1.y or 0)
	end
	
	if var_9_4 then
		if var_9_4.stickers then
			for iter_9_0, iter_9_1 in pairs(var_9_4.stickers) do
				local var_9_8 = iter_9_1.x or 0
				local var_9_9 = iter_9_1.y or 0
				local var_9_10 = iter_9_1.rotation or 0
				local var_9_11 = iter_9_1.scale_x or 1
				local var_9_12 = math.floor(var_9_8)
				local var_9_13 = math.floor(var_9_9)
				local var_9_14 = math.floor(var_9_10)
				local var_9_15 = to_n(string.format("%.2f", var_9_11))
				
				var_9_4.stickers[iter_9_0].x = var_9_12
				var_9_4.stickers[iter_9_0].y = var_9_13
				var_9_4.stickers[iter_9_0].r = var_9_14
				var_9_4.stickers[iter_9_0].s = var_9_15
				var_9_4.stickers[iter_9_0].rotation = nil
				var_9_4.stickers[iter_9_0].scale_x = nil
				var_9_4.stickers[iter_9_0].scale_y = nil
			end
		end
		
		if var_9_4.zoom_cont then
			var_9_7(var_9_4.zoom_cont)
		end
	end
	
	if var_9_3 and var_9_3.zoom_cont then
		var_9_7(var_9_3.zoom_cont)
	end
	
	local var_9_16 = {
		mode = var_9_2,
		illust = var_9_3,
		hero = var_9_4
	}
	local var_9_17 = json.encode(var_9_16)
	
	if arg_9_0.last_query_data == var_9_17 then
		if arg_9_1 then
			return 
		else
			local var_9_18 = SceneManager:getRunningScene()
			
			if var_9_18 then
				var_9_18:clearSceneArgs()
			end
			
			SceneManager:reload()
			
			return 
		end
	end
	
	query("select_custom_lobby", {
		data = var_9_17,
		just_save = arg_9_1
	})
	
	arg_9_0.last_save_tm = systick()
	arg_9_0.last_query_data = var_9_17
end

function CustomLobby.loadUserConfigData(arg_11_0)
	local var_11_0 = Account:getUserConfigs("custom_lobby")
	
	if var_11_0 then
		local var_11_1 = json.decode(var_11_0)
		
		if var_11_1.mode then
			SAVE:setKeep("custom_lobby.mode", var_11_1.mode)
		end
		
		local function var_11_2(arg_12_0)
			if not arg_12_0.pivot then
				return 
			end
			
			arg_12_0.pivot.scale = arg_12_0.pivot.s or arg_12_0.pivot.scale
		end
		
		if var_11_1.illust then
			if var_11_1.illust.zoom_cont then
				var_11_2(var_11_1.illust.zoom_cont)
			end
			
			SAVE:setKeep("custom_lobby.illust", Base64.encode(json.encode(var_11_1.illust)))
		end
		
		if var_11_1.hero then
			if var_11_1.hero.zoom_cont then
				var_11_2(var_11_1.hero.zoom_cont)
			end
			
			if var_11_1.hero.stickers then
				for iter_11_0, iter_11_1 in pairs(var_11_1.hero.stickers) do
					local var_11_3 = iter_11_1.x or 0
					local var_11_4 = iter_11_1.y or 0
					local var_11_5 = iter_11_1.r or iter_11_1.rotation or 0
					local var_11_6 = iter_11_1.s or iter_11_1.scale_x or 1
					local var_11_7 = math.floor(var_11_3)
					local var_11_8 = math.floor(var_11_4)
					local var_11_9 = math.floor(var_11_5)
					local var_11_10 = to_n(string.format("%.2f", var_11_6))
					
					var_11_1.hero.stickers[iter_11_0].x = var_11_7
					var_11_1.hero.stickers[iter_11_0].y = var_11_8
					var_11_1.hero.stickers[iter_11_0].rotation = var_11_9
					var_11_1.hero.stickers[iter_11_0].scale_x = var_11_10
					var_11_1.hero.stickers[iter_11_0].scale_y = var_11_10
				end
			end
			
			SAVE:setKeep("custom_lobby.unit", Base64.encode(json.encode(var_11_1.hero)))
		end
	end
end

local function var_0_0(arg_13_0)
	local var_13_0 = ""
	local var_13_1 = {
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
	
	return var_13_1[math.floor(arg_13_0 / 16) + 1] .. var_13_1[math.floor(arg_13_0 % 16) + 1]
end

function get_bg_ambient_color()
	local var_14_0 = CustomLobby:getColorAvg(SceneManager:getRunningNativeScene():getChildByName("n_lobby"))
	
	table.print(var_14_0)
	
	local var_14_1 = var_0_0(var_14_0.r)
	local var_14_2 = var_0_0(var_14_0.g)
	local var_14_3 = var_0_0(var_14_0.b)
	
	print("아래를 복사하세요! 현재 엠비언트")
	print("#" .. var_14_1 .. var_14_2 .. var_14_3)
end

function CustomLobby.getColorAvg(arg_15_0, arg_15_1)
	local var_15_0 = 8
	local var_15_1 = cc.RenderTexture:create(VIEW_WIDTH / var_15_0, VIEW_HEIGHT / var_15_0, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
	local var_15_2 = math.max(arg_15_1:getScale(), 0.1)
	local var_15_3 = arg_15_1:getPositionX()
	
	arg_15_1:setScale(var_15_2 / var_15_0)
	arg_15_1:setPositionX(98)
	
	local var_15_4 = false
	
	if var_15_4 then
		var_15_1:beginWithClear(255, 255, 255, 255)
	else
		var_15_1:begin()
	end
	
	arg_15_1:visit()
	var_15_1:endToLua()
	force_render()
	
	local var_15_5 = VIEW_HEIGHT / var_15_0
	local var_15_6 = VIEW_WIDTH / var_15_0
	local var_15_7 = math.ceil(110 / var_15_0)
	local var_15_8 = math.ceil(100 / var_15_0)
	local var_15_9 = math.ceil(150 / var_15_0)
	local var_15_10 = var_15_1:newImage()
	local var_15_11 = {
		g = 0,
		a = 0,
		b = 0,
		r = 0
	}
	local var_15_12 = 0
	
	for iter_15_0 = 0, var_15_5 do
		for iter_15_1 = 0, var_15_7 do
			var_15_12 = var_15_12 + 1
			
			local var_15_13, var_15_14, var_15_15, var_15_16 = get_pixel(var_15_10, iter_15_1, iter_15_0)
			
			var_15_11.r = var_15_11.r + var_15_13
			var_15_11.g = var_15_11.g + var_15_14
			var_15_11.b = var_15_11.b + var_15_15
			var_15_11.a = var_15_11.a + var_15_16
		end
	end
	
	for iter_15_2 = 0, var_15_5 do
		for iter_15_3 = var_15_6 - var_15_7, var_15_6 do
			var_15_12 = var_15_12 + 1
			
			local var_15_17, var_15_18, var_15_19, var_15_20 = get_pixel(var_15_10, iter_15_3, iter_15_2)
			
			var_15_11.r = var_15_11.r + var_15_17
			var_15_11.g = var_15_11.g + var_15_18
			var_15_11.b = var_15_11.b + var_15_19
			var_15_11.a = var_15_11.a + var_15_20
		end
	end
	
	for iter_15_4 = 0, var_15_8 do
		for iter_15_5 = var_15_7, var_15_6 - var_15_7 do
			var_15_12 = var_15_12 + 1
			
			local var_15_21, var_15_22, var_15_23, var_15_24 = get_pixel(var_15_10, iter_15_5, iter_15_4)
			
			var_15_11.r = var_15_11.r + var_15_21
			var_15_11.g = var_15_11.g + var_15_22
			var_15_11.b = var_15_11.b + var_15_23
			var_15_11.a = var_15_11.a + var_15_24
		end
	end
	
	for iter_15_6 = var_15_5 - var_15_9, var_15_5 do
		for iter_15_7 = var_15_7, var_15_6 - var_15_7 do
			var_15_12 = var_15_12 + 1
			
			local var_15_25, var_15_26, var_15_27, var_15_28 = get_pixel(var_15_10, iter_15_7, iter_15_6)
			
			var_15_11.r = var_15_11.r + var_15_25
			var_15_11.g = var_15_11.g + var_15_26
			var_15_11.b = var_15_11.b + var_15_27
			var_15_11.a = var_15_11.a + var_15_28
		end
	end
	
	local var_15_29 = {
		r = var_15_11.r / var_15_12,
		g = var_15_11.g / var_15_12,
		b = var_15_11.b / var_15_12
	}
	
	print("avg r : ", var_15_11.r / var_15_12)
	print("avg g : ", var_15_11.g / var_15_12)
	print("avg b : ", var_15_11.b / var_15_12)
	print("avg a : ", var_15_11.a / var_15_12)
	print("pixel_cnt", var_15_12)
	arg_15_1:setScale(var_15_2)
	arg_15_1:setPositionX(var_15_3)
	
	return var_15_29
end

function CustomLobby.findTintColor(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = {}
	local var_16_1 = false
	local var_16_2 = systick()
	
	if (arg_16_2 or SAVE:getKeep("custom_lobby.mode")) == "hero" then
		local var_16_3 = arg_16_1 or CustomLobbyUnit.Data:getUnitSettingData()
		local var_16_4 = DB("item_material_bgpack", var_16_3.background_id, "ambient_color")
		
		if not var_16_4 then
			var_16_1 = true
		else
			var_16_0 = tocolor("#" .. var_16_4)
		end
	else
		local var_16_5 = arg_16_1 or CustomLobbyIllust.Data:getIllustSettingData()
		local var_16_6 = CustomLobbyIllust.Data:getCurIllustId(var_16_5)
		
		var_16_0 = DB("illust_ambient_color", var_16_6, "ambient_color")
		
		if not var_16_0 and var_16_6 then
			Log.e("오류! " .. (var_16_6 or "") .. "의 illust_ambient_color가 생성되지 않았습니다. 익스포터에서 '-8 : dic_data_illust의 illust_ambient_color 생성하기' 를 확인해보세요.")
		end
		
		if var_16_0 and string.starts(var_16_0, "#") then
			var_16_0 = tocolor(var_16_0)
		else
			var_16_0 = nil
			var_16_1 = true
		end
	end
	
	if var_16_1 then
		return {
			keep_default = true,
			dim_color = tocolor("#000000")
		}
	else
		local var_16_7 = {
			pink_anchor = {
				anchor_color = tocolor("#D55CBA"),
				text_and_outline_color = tocolor("#512538"),
				dim_color = tocolor("#45212E")
			},
			sky_blue_anchor = {
				anchor_color = tocolor("#5CB7D5"),
				text_and_outline_color = tocolor("#1D2F45"),
				dim_color = tocolor("#182234")
			},
			green_anchor = {
				anchor_color = tocolor("#67D55C"),
				text_and_outline_color = tocolor("#192D19"),
				dim_color = tocolor("#1B2618")
			},
			yellow_anchor = {
				anchor_color = tocolor("#D5BD5C"),
				text_and_outline_color = tocolor("#361E0B"),
				dim_color = tocolor("#2A1608")
			},
			orange_anchor = {
				anchor_color = tocolor("#D57E5C"),
				text_and_outline_color = tocolor("#361E0B"),
				dim_color = tocolor("#2A1608")
			}
		}
		local var_16_8
		local var_16_9 = 999999
		
		local function var_16_10(arg_17_0)
			return (math.max(arg_17_0.r, math.max(arg_17_0.g, arg_17_0.b)))
		end
		
		local function var_16_11(arg_18_0)
			local var_18_0 = var_16_10(arg_18_0)
			
			return {
				r = arg_18_0.r / var_18_0,
				g = arg_18_0.g / var_18_0,
				b = arg_18_0.b / var_18_0
			}
		end
		
		for iter_16_0, iter_16_1 in pairs(var_16_7) do
			local var_16_12 = var_16_11(var_16_0)
			local var_16_13 = var_16_11(iter_16_1.anchor_color)
			local var_16_14 = math.abs(var_16_12.r - var_16_13.r) + math.abs(var_16_12.g - var_16_13.g) + math.abs(var_16_12.b - var_16_13.b)
			
			if var_16_14 < var_16_9 then
				var_16_8 = iter_16_0
				var_16_9 = var_16_14
			end
		end
		
		if var_16_9 > 100000 then
			Log.e("COLOR GAP을 찾는데 실패했습니다.")
			
			var_16_8 = "orange_anchor"
		end
		
		print("most_near_ambient_color: ", var_16_8)
		print("check_gap?", var_16_9)
		
		return var_16_7[var_16_8], var_16_9
	end
end

function Lobby.setupCustomLobby(arg_19_0, arg_19_1)
	CustomLobbyIllust.Util:removeAllScheduler()
	CustomLobby:setAsDefaultOnNotExistSave()
	
	local var_19_0 = SAVE:getKeep("custom_lobby.mode")
	
	if var_19_0 == "illust" then
		CustomLobbyIllust:load(arg_19_1)
	elseif var_19_0 == "hero" then
		CustomLobbyUnit:load(arg_19_1)
		CustomLobbyUnit:playUnitEnterSound()
	else
		Log.e("NOT A CUSTOM LOBBY")
	end
end

function Lobby.applyTintColor(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = CustomLobby:findTintColor()
	local var_20_1 = var_20_0.dim_color
	local var_20_2 = var_20_0.keep_default
	
	arg_20_0:setUITintColor(var_20_1, var_20_0.text_and_outline_color, arg_20_2, var_20_2)
end

function Lobby.setUITintColor(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	local function var_21_0(arg_22_0, arg_22_1)
		SpriteCache:resetSprite(arg_22_0, arg_22_1 or "img/_grow_white.png")
		arg_22_0:setColor(arg_21_1)
	end
	
	local var_21_1 = arg_21_3:findChildByName("lobby_ui")
	
	if not var_21_1 then
		return 
	end
	
	local var_21_2 = arg_21_3:findChildByName("topbarnew_layer")
	local var_21_3 = var_21_1:findChildByName("LEFT")
	local var_21_4 = var_21_1:findChildByName("RIGHT")
	local var_21_5 = var_21_1:findChildByName("TOP_LEFT")
	
	var_21_0(getChildByPath(var_21_1, "BUTTONS/LEFT/grow"))
	var_21_0(getChildByPath(var_21_1, "BUTTONS/LEFT/n_lobby/grow2"))
	var_21_0(getChildByPath(var_21_1, "BUTTONS/LEFT/n_lobby/grow"))
	var_21_0(getChildByPath(var_21_1, "BUTTONS/RIGHT/n_pvp/grow"))
	var_21_0(getChildByPath(var_21_1, "BUTTONS/RIGHT/grow2"))
	var_21_0(getChildByPath(var_21_1, "TOP_LEFT/grow"))
	
	local var_21_6 = getChildByPath(var_21_2, "top_bar/grow_s")
	
	var_21_0(var_21_6, "img/_grow_s_white.png")
	
	local var_21_7 = {
		"btn_shop",
		"btn_hero",
		"btn_gacha",
		"btn_achieve",
		"btn_pet",
		"btn_clan",
		"btn_sanctuary"
	}
	local var_21_8 = tocolor("#ffffff")
	local var_21_9 = arg_21_2
	local var_21_10 = arg_21_2
	
	if arg_21_4 then
		local var_21_11 = var_21_3:findChildByName("btn_shop")
		
		if get_cocos_refid(var_21_11) and not var_21_11._default_color then
			local var_21_12 = var_21_11:getChildByName("label")
			
			if var_21_12 then
				var_21_11._default_text_color = var_21_12:getTextColor()
				var_21_11._default_shadow_color = var_21_12:getShadowColor()
				var_21_11._default_outline_color = var_21_12:getEffectColor()
			end
			
			var_21_8 = var_21_11._default_text_color
			var_21_9 = var_21_11._default_shadow_color
			var_21_10 = var_21_11._default_outline_color
		end
	end
	
	local var_21_13 = {
		x = 2,
		y = -2
	}
	
	for iter_21_0, iter_21_1 in pairs(var_21_7) do
		local var_21_14 = var_21_3:findChildByName(iter_21_1)
		local var_21_15 = var_21_14:findChildByName("label") or var_21_14:findChildByName("t_title")
		
		if var_21_15 then
			var_21_15:setTextColor(var_21_8)
			
			if var_21_15.enableShadow then
				var_21_15:enableShadow(var_21_9, var_21_13)
			end
			
			var_21_15:enableOutline(var_21_10, 1)
		end
	end
	
	local var_21_16 = {
		"btn_battle",
		"btn_map",
		"btn_sub_story",
		"btn_gladiator"
	}
	
	for iter_21_2, iter_21_3 in pairs(var_21_16) do
		local var_21_17 = var_21_4:findChildByName(iter_21_3)
		local var_21_18 = var_21_17:findChildByName("label") or var_21_17:findChildByName("t_title")
		
		if var_21_18 then
			var_21_18:setTextColor(var_21_8)
			var_21_18:enableShadow(var_21_9, var_21_13)
			var_21_18:enableOutline(var_21_10, 1)
		end
	end
	
	local var_21_19 = {
		{
			"n_btn_Integrate",
			"txt_title"
		},
		{
			"n_moonlight_destiny",
			"t_title"
		},
		{
			"cm_icon_expedition",
			"t_title"
		},
		{
			"n_btn_season_pass",
			"t_title"
		}
	}
	
	for iter_21_4, iter_21_5 in pairs(var_21_19) do
		local var_21_20 = arg_21_3:findChildByName(iter_21_5[1]):findChildByName(iter_21_5[2])
		
		var_21_20:setTextColor(var_21_8)
		var_21_20:enableShadow(var_21_9, var_21_13)
		var_21_20:enableOutline(var_21_10, 1)
	end
end
