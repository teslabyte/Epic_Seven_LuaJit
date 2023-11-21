CustomLobbySettingIllust = {}

local var_0_0 = 127

local function var_0_1()
	local var_1_0 = CustomLobbySettingPreview.Data:GetStaticPreviewSize()
	local var_1_1 = CustomLobbySettingPreview.Data:GetStaticPreviewMargin()
	
	var_1_0.width = var_1_0.width * 0.5
	var_1_0.height = var_1_0.height * 0.5
	
	return var_1_0, var_1_1
end

local function var_0_2(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_2.width - arg_2_2.width * (arg_2_1 % 2)
	local var_2_1 = arg_2_2.height - arg_2_2.height * math.floor((arg_2_1 - 1) / 2)
	
	arg_2_0.vars.layout:setPosition(22 + arg_2_3 / 2 + var_2_0, var_0_0 + var_2_1)
end

function CustomLobbySettingIllust.init(arg_3_0, arg_3_1)
	arg_3_0.Data:init()
	arg_3_0.UI:init(arg_3_1)
	
	arg_3_0.Layouts = {}
	
	local var_3_0, var_3_1 = var_0_1()
	
	for iter_3_0 = 1, 4 do
		local var_3_2 = CustomLobbySettingPreview.Layout:createInstance(arg_3_1, var_3_0, 0, true, function(arg_4_0, arg_4_1)
			print("NotchManager:addListener!!!!")
			
			local var_4_0, var_4_1 = var_0_1()
			
			var_0_2(arg_4_0, iter_3_0, var_4_0, var_4_1)
			arg_4_0:updateForceSize(var_4_0, var_4_1)
		end)
		
		var_0_2(var_3_2, iter_3_0, var_3_0, var_3_1)
		
		arg_3_0.Layouts[iter_3_0] = var_3_2
		
		var_3_2:setVisibleBG(false)
		var_3_2:createButtonAsLayoutSize(function(arg_5_0, arg_5_1)
			if arg_5_1 == 2 then
				arg_3_0:onRemoveIllust(iter_3_0)
			end
		end)
		var_3_2:onEmpty(true)
	end
end

function CustomLobbySettingIllust.show(arg_6_0, arg_6_1)
	arg_6_0.ListView:init(arg_6_1)
	arg_6_0:updateListView(arg_6_0.Data:getCurrentDataList())
end

function CustomLobbySettingIllust.close(arg_7_0)
	arg_7_0.Data:close()
end

function CustomLobbySettingIllust.updateListView(arg_8_0, arg_8_1)
	arg_8_0.Data:setViewDataList(arg_8_1)
	arg_8_0.ListView:setData(arg_8_1)
end

function CustomLobbySettingIllust.onSelectCategory(arg_9_0, arg_9_1)
	arg_9_0.Data:setCategoryId(arg_9_1)
	
	local var_9_0 = arg_9_0.Data:getCurrentDataList()
	
	arg_9_0:updateListView(var_9_0)
	CustomLobbySettingMain.Illust.UI:setVisibleNoData(table.count(var_9_0) == 0)
end

function CustomLobbySettingIllust.isExistIllust(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0.Data:getCurrentIllusts()
	
	for iter_10_0, iter_10_1 in pairs(var_10_0 or {}) do
		if iter_10_1 == arg_10_1 then
			return true
		end
	end
	
	return false
end

function CustomLobbySettingIllust.onRemoveIllustByData(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_1.db.id
	
	if arg_11_0:isExistIllust(var_11_0) then
		local var_11_1 = arg_11_0.Data:getIndexById(var_11_0)
		
		arg_11_0:onRemoveIllust(var_11_1)
	end
end

function CustomLobbySettingIllust.onRemoveIllust(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0.Data:getCurrentIllusts()
	
	if not var_12_0 then
		return 
	end
	
	if not var_12_0[arg_12_1] then
		return 
	end
	
	if #var_12_0 <= 1 then
		balloon_message_with_sound("msg_illust_lobby_least_one")
		
		return 
	end
	
	local var_12_1 = var_12_0[arg_12_1]
	
	arg_12_0.Data:removeIllust(arg_12_1)
	
	local var_12_2 = arg_12_0.Data:getCurrentIllusts()
	
	for iter_12_0 = arg_12_1, 4 do
		local var_12_3 = var_12_2[iter_12_0]
		
		arg_12_0.Layouts[iter_12_0]:clearIllust()
		
		if var_12_3 then
			arg_12_0.Layouts[iter_12_0]:onSelectIllust(var_12_3)
		end
		
		arg_12_0.Layouts[iter_12_0]:onEmpty(var_12_3 == nil)
	end
	
	arg_12_0.ListView:updateSelected(var_12_1)
end

function CustomLobbySettingIllust.onSelectIllust(arg_13_0, arg_13_1)
	if not arg_13_1.unlock then
		balloon_message_with_sound(arg_13_1.db.unlock_msg)
		
		return 
	end
	
	local var_13_0 = arg_13_1.db.id
	local var_13_1 = #arg_13_0.Data:getCurrentIllusts()
	
	if var_13_1 >= 4 then
		balloon_message_with_sound("msg_illust_lobby_max_four")
		
		return 
	else
		var_13_1 = var_13_1 + 1
	end
	
	arg_13_0.Layouts[var_13_1]:onSelectIllust(var_13_0)
	arg_13_0.Layouts[var_13_1]:onEmpty(false)
	arg_13_0.Data:setCurrentIllust(var_13_0, var_13_1)
	arg_13_0.ListView:updateSelected(var_13_0, nil)
end

function CustomLobbySettingIllust.loadIllustSettingData(arg_14_0, arg_14_1)
	arg_14_0.Data:setCurrentIllusts(arg_14_1.illust_id)
	
	local var_14_0 = string.split(arg_14_1.illust_id, ",")
	
	for iter_14_0, iter_14_1 in pairs(arg_14_0.Layouts) do
		local var_14_1 = var_14_0[iter_14_0]
		
		if var_14_1 then
			arg_14_0.ListView:updateSelected(var_14_1)
			iter_14_1:onSelectIllust(var_14_1)
		else
			iter_14_1:clearIllust()
		end
		
		iter_14_1:onEmpty(var_14_1 == nil)
	end
	
	local var_14_2 = arg_14_0.Data:getCategoryId(var_14_0[1])
	
	if var_14_2 then
		local var_14_3
		local var_14_4 = arg_14_0.Data:getCategories()
		
		for iter_14_2, iter_14_3 in pairs(var_14_4) do
			if iter_14_3.id == var_14_2 then
				var_14_3 = iter_14_3.sort
			end
		end
		
		if var_14_3 then
			local var_14_5 = CustomLobbySettingMain.Illust.UI:getCategoryNode(var_14_3)
			
			CustomLobbySettingMain.Illust:onSelectCategory(var_14_5)
			
			return true
		end
	end
	
	return false
end

CustomLobbySettingIllust.Data = {}

function CustomLobbySettingIllust.Data.init(arg_15_0)
	arg_15_0.vars = {}
	arg_15_0.vars.current_illusts = {}
	arg_15_0.vars.illust_db = CollectionDB:CreateIllustDB("lobby")
	
	local var_15_0 = {}
	
	for iter_15_0, iter_15_1 in pairs(arg_15_0.vars.illust_db.parent_DB) do
		local var_15_1 = DB("dic_ui", iter_15_0, "parent_id")
		
		if not var_15_1 then
			Log.e("CHK CHK CHK CHK CATEGORY WAS NIL.", var_15_1)
		end
		
		if not var_15_0[var_15_1] then
			var_15_0[var_15_1] = {}
		end
		
		var_15_0[var_15_1][iter_15_0] = iter_15_1
	end
	
	arg_15_0.vars.illust_db.category_db = var_15_0
	arg_15_0.vars.category_id = arg_15_0:getCategories()[1].id
	
	arg_15_0:setDefaultCurrentIllust()
end

function CustomLobbySettingIllust.Data.setCategoryId(arg_16_0, arg_16_1)
	arg_16_0.vars.category_id = arg_16_1
end

function CustomLobbySettingIllust.Data.getCurrentCategoryId(arg_17_0)
	return arg_17_0.vars.category_id
end

function CustomLobbySettingIllust.Data.setDefaultCurrentIllust(arg_18_0)
	local var_18_0 = arg_18_0:getCurrentDataList()
end

function CustomLobbySettingIllust.Data.getCurrentIllusts(arg_19_0)
	if not arg_19_0.vars then
		return 
	end
	
	return arg_19_0.vars.current_illusts or {}
end

function CustomLobbySettingIllust.Data.setCurrentIllusts(arg_20_0, arg_20_1)
	print("setCurrentIllusts?", arg_20_1)
	
	local var_20_0 = string.split(arg_20_1, ",")
	
	if not var_20_0 then
		Log.e("splits not exist : ", arg_20_1)
		
		return 
	end
	
	arg_20_0.vars.current_illusts = {}
	
	for iter_20_0, iter_20_1 in pairs(var_20_0) do
		arg_20_0.vars.current_illusts[iter_20_0] = iter_20_1
	end
end

function CustomLobbySettingIllust.Data.setCurrentIllust(arg_21_0, arg_21_1, arg_21_2)
	arg_21_0.vars.current_illusts[arg_21_2] = arg_21_1
end

function CustomLobbySettingIllust.Data.removeIllust(arg_22_0, arg_22_1)
	if not arg_22_0.vars.current_illusts[arg_22_1] then
		return false
	end
	
	table.remove(arg_22_0.vars.current_illusts, arg_22_1)
	
	return true
end

function CustomLobbySettingIllust.Data.getCategories(arg_23_0)
	return CollectionDB:GetCategories(arg_23_0.vars.illust_db.category_db)
end

function CustomLobbySettingIllust.Data.getCategoryId(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0.vars.illust_db.pure_DB[arg_24_1]
	
	if not var_24_0 then
		return 
	end
	
	local var_24_1 = var_24_0.parent_id
	
	for iter_24_0, iter_24_1 in pairs(arg_24_0.vars.illust_db.category_db) do
		for iter_24_2, iter_24_3 in pairs(iter_24_1) do
			if iter_24_2 == var_24_1 then
				return iter_24_0
			end
		end
	end
	
	return nil
end

function CustomLobbySettingIllust.Data.getIndexById(arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0:getCurrentIllusts()
	
	for iter_25_0, iter_25_1 in pairs(var_25_0 or {}) do
		if iter_25_1 == arg_25_1 then
			return iter_25_0
		end
	end
	
	return nil
end

function CustomLobbySettingIllust.Data.getCurrentDataList(arg_26_0)
	return CollectionDB:GetCategoryDataList(arg_26_0.vars.illust_db.category_db, arg_26_0.vars.category_id)
end

function CustomLobbySettingIllust.Data.setViewDataList(arg_27_0, arg_27_1)
	arg_27_0.vars.view_data_list = arg_27_1
end

function CustomLobbySettingIllust.Data.close(arg_28_0)
	arg_28_0.vars = nil
end

CustomLobbySettingIllust.UI = {}

function CustomLobbySettingIllust.UI.init(arg_29_0, arg_29_1)
	arg_29_0.vars = {}
end

CustomLobbySettingIllust.ListView = {}

function CustomLobbySettingIllust.ListView.init(arg_30_0, arg_30_1)
	arg_30_0.vars = {}
	arg_30_0.vars.listview = GroupListView:bindControl(arg_30_1)
	
	arg_30_0.vars.listview:setListViewCascadeOpacityEnabled(true)
	arg_30_0.vars.listview:setEnableMargin(true)
	
	local var_30_0 = load_control("wnd/lobby_custom_illust_header.csb")
	local var_30_1 = {
		onUpdate = function(arg_31_0, arg_31_1, arg_31_2)
			local var_31_0, var_31_1 = DB("dic_ui", arg_31_2, {
				"name",
				"desc"
			})
			
			if_set(arg_31_1, "txt_name", T(var_31_0))
			UIUserData:call(arg_31_1:getChildByName("txt_name"), "SINGLE_WSCALE(420)")
		end
	}
	local var_30_2 = load_control("wnd/profile_custom_illust_card.csb")
	local var_30_3 = {
		onUpdate = function(arg_32_0, arg_32_1, arg_32_2)
			arg_30_0:updateListViewItem(arg_32_1, arg_32_2)
		end
	}
	
	if arg_30_0.vars.listview.STRETCH_INFO then
		local var_30_4 = arg_30_0.vars.listview:getContentSize()
		
		resetControlPosAndSize(var_30_2, var_30_4.width, arg_30_0.vars.listview.STRETCH_INFO.width_prev)
	end
	
	arg_30_0.vars.listview:setRenderer(var_30_0, var_30_2, var_30_1, var_30_3)
	arg_30_0.vars.listview:clear()
end

function CustomLobbySettingIllust.ListView.updateListViewItem(arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = CollectionUtil:isIllustUnlock(arg_33_2) or false
	
	if_set_visible(arg_33_1, "img_nodata", not var_33_0)
	if_set_visible(arg_33_1, "n_illust", var_33_0)
	
	if var_33_0 and not arg_33_1:getChildByName("thumbnail_img") then
		local var_33_1 = arg_33_2.illust or ""
		local var_33_2 = arg_33_1:findChildByName("img")
		
		if var_33_2 then
			var_33_2:removeFromParent()
		end
		
		local var_33_3
		local var_33_4
		local var_33_5 = arg_33_1:findChildByName("n_illust")
		
		if arg_33_2.thumbnail then
			if string.starts(arg_33_2.thumbnail, "story/bg/") then
				local var_33_6 = UIUtil:getIllustPath("story/bg/", string.replace(arg_33_2.thumbnail, "story/bg/", ""))
				
				var_33_3 = SpriteCache:getSprite(var_33_6)
			else
				var_33_3 = cc.Sprite:create("item/art/" .. arg_33_2.thumbnail .. ".png")
			end
			
			var_33_3:setName("img")
			var_33_3:setPosition(109, 62)
		elseif string.find(var_33_1, ".cfx") then
			var_33_3 = CACHE:getEffect(var_33_1, "effect")
			var_33_4 = {
				effect = var_33_3,
				fn = var_33_1
			}
			var_33_4.x = 109
			var_33_4.y = 62
			var_33_4.scale = 0.23
		else
			local var_33_7 = UIUtil:getIllustPathWithCheckExist("story/bg/", var_33_1 .. "_th")
			local var_33_8 = true
			
			if not var_33_7 then
				if UIUtil:getIllustPathWithCheckExist("story/bg/", var_33_1) then
					Log.e("NOT EXIST IN WEBP thumbnail FILE in story/bg/", var_33_1)
				end
				
				var_33_7 = UIUtil:getIllustPath("story/bg/", var_33_1)
				var_33_8 = false
			end
			
			var_33_3 = SpriteCache:getSprite(var_33_7)
			
			if var_33_3 then
				var_33_3:setName("img")
				var_33_3:setLocalZOrder(99999)
				var_33_3:setPosition(109, 62)
				
				if not var_33_8 then
					var_33_3:setScale(0.23)
					var_33_3:setAnchorPoint(0.5, 0.5)
				elseif var_33_5 then
					local var_33_9 = var_33_3:getContentSize()
					local var_33_10 = var_33_5:getContentSize()
					
					var_33_3:setScale(math.max(var_33_10.width / var_33_9.width, var_33_10.height / var_33_9.height))
				end
			end
		end
		
		if var_33_5 then
			if var_33_4 then
				var_33_4.layer = var_33_5
				
				EffectManager:EffectPlay(var_33_4):setName("thumbnail_img")
			elseif not var_33_3 then
				Log.e("not exist image", arg_33_2.id)
			else
				var_33_5:addChild(var_33_3)
				var_33_3:setName("thumbnail_img")
			end
		end
	else
		if_set_color(arg_33_1, "n_illust_card", cc.c3b(136, 136, 136))
	end
	
	local var_33_11 = CustomLobbySettingIllust.Data:getCurrentIllusts()
	local var_33_12 = false
	
	for iter_33_0, iter_33_1 in pairs(var_33_11) do
		if iter_33_1 == arg_33_2.id then
			var_33_12 = iter_33_1
			
			break
		end
	end
	
	if_set_visible(arg_33_1, "n_select", var_33_12)
	if_set_visible(arg_33_1, "icon_check", var_33_12)
	
	if arg_33_1:getChildByName("btn_select") then
		arg_33_1:getChildByName("btn_select").data = {
			db = arg_33_2,
			unlock = var_33_0
		}
	end
end

function CustomLobbySettingIllust.ListView.setData(arg_34_0, arg_34_1)
	arg_34_0.vars.listview:clear()
	
	for iter_34_0, iter_34_1 in pairs(arg_34_1) do
		arg_34_0.vars.listview:addGroup(iter_34_1.id, iter_34_1.data)
	end
end

function CustomLobbySettingIllust.ListView.updateSelected(arg_35_0, arg_35_1, arg_35_2)
	arg_35_0.vars.listview:enumControls(function(arg_36_0, arg_36_1)
		if arg_36_1.id == arg_35_1 or arg_36_1.id == arg_35_2 then
			arg_35_0:updateListViewItem(arg_36_0, arg_36_1)
		end
	end)
end
