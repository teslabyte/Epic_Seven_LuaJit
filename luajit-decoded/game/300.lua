HelpGuide = {}
HELP_CATEGORY = {}
HELP_GROUP = {}
HELP_BOSS_GUIDE = {}

local var_0_0 = "guide"
local var_0_1 = "contents"
local var_0_2 = 2
local var_0_3 = 1

function HANDLER.help_base(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close2" or arg_1_1 == "btn_close" then
		HelpGuide:close()
	elseif arg_1_1 == "btn_next" then
		if HelpGuide.vars.cur_page_idx then
			HelpGuide:_setPage(HelpGuide.vars.cur_page_idx + 1)
		end
	elseif arg_1_1 == "btn_prev" then
		if HelpGuide.vars.cur_page_idx then
			HelpGuide:_setPage(HelpGuide.vars.cur_page_idx - 1)
		end
	elseif arg_1_1 == "btn_move" and arg_1_0.move_path then
		SceneManager:resetSceneFlow()
		
		if arg_1_0.unlock_id then
			UnlockSystem:isUnlockSystemAndMsg({
				exclude_story = true,
				id = arg_1_0.unlock_id
			}, function()
				movetoPath(arg_1_0.move_path)
			end)
		else
			movetoPath(arg_1_0.move_path)
		end
	end
end

function HelpGuide.getAutoContentsId(arg_3_0)
end

copy_functions(ScrollView, HELP_CATEGORY)
copy_functions(ScrollView, HELP_GROUP)
copy_functions(ScrollView, HELP_BOSS_GUIDE)

function HELP_CATEGORY.getScrollViewItem(arg_4_0, arg_4_1)
	local var_4_0 = cc.CSLoader:createNode("wnd/help_card2.csb")
	
	if_set_visible(var_4_0, "txt_index", arg_4_1.is_menu_title)
	if_set_visible(var_4_0, "n_category", not arg_4_1.is_menu_title)
	
	if arg_4_1.is_menu_title then
		local var_4_1 = var_4_0:getContentSize()
		
		if_set(var_4_0, "txt_index", T(arg_4_1.name))
		UIUserData:call(var_4_0:getChildByName("txt_index"), "SINGLE_WSCALE(200)")
	end
	
	if_set(var_4_0, "txt_contents", T(arg_4_1.name))
	UIUserData:call(var_4_0:getChildByName("txt_contents"), "MULTI_SCALE_LONG_WORD()")
	if_set_visible(var_4_0, "img_select", false)
	if_set_visible(var_4_0, "btn_category", false)
	
	return var_4_0
end

function HELP_CATEGORY.onSelectScrollViewItem(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_2 or {}
	
	if var_5_0.item and var_5_0.item.is_menu_title then
		return 
	end
	
	if HelpGuide.vars.cur_category_idx ~= arg_5_1 then
		HelpGuide:_setCategory(arg_5_1, 1)
	end
end

function HELP_GROUP.getScrollViewItem(arg_6_0, arg_6_1)
	local var_6_0 = cc.CSLoader:createNode("wnd/help_card.csb")
	
	if_set(var_6_0, "txt", T(arg_6_1.name))
	UIUserData:call(var_6_0:getChildByName("txt"), "SINGLE_WSCALE(195)")
	if_set_visible(var_6_0, "bg", HelpGuide.vars.cur_group_id == arg_6_1.id)
	
	return var_6_0
end

function HELP_GROUP.onSelectScrollViewItem(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_2.item.id
	local var_7_1 = arg_7_2.item.type
	
	if HelpGuide.vars.cur_group_id ~= var_7_0 then
		HelpGuide:_setGroup(var_7_0, var_0_2, var_0_3)
	end
end

function HELP_BOSS_GUIDE.getScrollViewItem(arg_8_0, arg_8_1)
	local var_8_0 = load_dlg(BOSS_GUIDE_ITEM, true, "wnd")
	
	BossGuideUtil:setBossInfo(var_8_0, arg_8_1[1])
	BossGuideUtil:setCorpsInfo(var_8_0, arg_8_1[2])
	BossGuideUtil:setDropsInfo(var_8_0, arg_8_1[3])
	BossGuideUtil:setAdditionInfo(var_8_0, arg_8_1[4])
	
	return var_8_0
end

function HelpGuide.open(arg_9_0, arg_9_1)
	if arg_9_0.vars and get_cocos_refid(arg_9_0.vars.wnd) then
		arg_9_0.vars.wnd:removeFromParent()
	end
	
	arg_9_1 = arg_9_1 or {}
	
	if arg_9_1.auto then
		arg_9_1.contents_id = arg_9_0:getAutoContentsId()
	end
	
	local var_9_0
	local var_9_1
	
	if arg_9_1.contents_id then
		var_9_0 = arg_9_1.contents_id
	elseif arg_9_1.menu then
		var_9_0 = arg_9_1.menu
	end
	
	if var_9_0 and not string.find(var_9_0, "_") then
		var_9_0 = var_9_0 .. "_1"
	end
	
	if var_9_0 then
		local var_9_2 = DB("help_0_shortcut", var_9_0, {
			"help_category_id"
		})
		
		if var_9_2 then
			print("change_help_id by help_0_shortcut.db")
			
			arg_9_1.contents_id = var_9_2
		end
	end
	
	if arg_9_1.contents_id then
		local var_9_3 = string.split(arg_9_1.contents_id, "_")
		
		if #var_9_3 > 3 then
			Log.e("HelpGuide.createUI Worng contents_id ", arg_9_1.contents_id)
			
			return 
		end
		
		arg_9_1.menu = var_9_3[1]
		arg_9_1.category_idx = tonumber(var_9_3[2])
		arg_9_1.page_idx = tonumber(var_9_3[3])
	end
	
	arg_9_0.vars = {}
	
	if arg_9_1.is_coop then
		arg_9_0.vars.is_coop = true
	end
	
	if arg_9_1.contents_id and string.starts(arg_9_1.contents_id, "heritage") then
		arg_9_0.vars.is_lota = true
	end
	
	if arg_9_1.contents_id and string.starts(arg_9_1.contents_id, "rumble") then
		arg_9_0.vars.is_rumble = true
	end
	
	arg_9_0.vars.show_move_btn = arg_9_1.show_move_btn or false
	arg_9_0.vars.map_id = arg_9_1.map_id
	arg_9_0.vars.contents_id = arg_9_1.contents_id or " "
	
	arg_9_0:loadData(arg_9_1)
	arg_9_0:createUI(arg_9_1)
	
	if arg_9_1.close_callback then
		arg_9_0.vars.close_callback = arg_9_1.close_callback
	end
	
	SoundEngine:play("event:/ui/tip/open")
	
	arg_9_0.vars.cur_group_id = arg_9_0:_findGroupID(arg_9_1.menu) or var_0_0
	arg_9_0.vars.cur_menu_id = arg_9_1.menu or var_0_1
	arg_9_0.vars.cur_category_idx = arg_9_1.category_idx or 1
	arg_9_0.vars.cur_page_idx = arg_9_1.page_idx or var_0_3
	
	local var_9_4 = true
	
	if arg_9_1.getByMenu == false then
		var_9_4 = false
	end
	
	arg_9_0:_setGroup(arg_9_0.vars.cur_group_id, arg_9_0.vars.cur_category_idx, arg_9_0.vars.cur_page_idx, var_9_4)
	HELP_GROUP.scrollview:forceDoLayout()
	
	local var_9_5 = 1
	local var_9_6 = table.count(arg_9_0.vars.help_data)
	
	for iter_9_0, iter_9_1 in pairs(arg_9_0.vars.help_data) do
		if iter_9_1.id and iter_9_1.id == arg_9_0.vars.cur_group_id then
			var_9_5 = iter_9_0
			
			break
		end
	end
	
	local var_9_7 = arg_9_0.vars.wnd:getChildByName("n_categories"):getChildByName("scrollview"):getContentSize().height
	local var_9_8 = 57
	
	if HELP_GROUP.nodes and HELP_GROUP.nodes[1] then
		var_9_8 = HELP_GROUP.nodes[1]:getContentSize().height
	end
	
	if var_9_5 > (math.floor(var_9_7 / var_9_8) or 10) then
		local var_9_9 = math.min(var_9_6, var_9_5) / var_9_6
		
		HELP_GROUP.scrollview:scrollToPercentVertical(var_9_9 * 100, 0.01, false)
	else
		HELP_GROUP.scrollview:scrollToTop(0.01, false)
	end
	
	if arg_9_0.vars.cur_group_id ~= "bossguide" then
		for iter_9_2, iter_9_3 in pairs(HELP_CATEGORY.ScrollViewItems) do
			if_set_visible(iter_9_3.control, "img_select", iter_9_2 == arg_9_0.vars.cur_category_idx)
		end
	end
	
	if arg_9_0.vars.cur_group_id ~= "bossguide" then
		for iter_9_4, iter_9_5 in pairs(HELP_CATEGORY.ScrollViewItems) do
			if iter_9_4 == arg_9_0.vars.cur_category_idx then
				local var_9_10 = iter_9_5.item.menu_name
				
				if var_9_10 then
					if_set(arg_9_0.vars.wnd, "t_sub", T(var_9_10))
				end
			end
		end
	end
end

function HelpGuide._findGroupID(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1 or ""
	
	if var_10_0 == "bossguide" then
		return var_10_0
	end
	
	if var_10_0 == "clanheritage" then
		return "heritage"
	end
	
	return DB("help_1_menu", var_10_0, {
		"group_id"
	}) or var_0_0
end

function HelpGuide.open_in_battle(arg_11_0)
	local var_11_0 = BattleRepeat:isPlayingRepeatPlay()
	
	if not arg_11_0.vars or table.empty(arg_11_0.vars) or not var_11_0 then
		local var_11_1 = "bossguide"
		
		if not BossGuide:hasGuide(Battle.logic.map.enter) then
			var_11_1 = var_0_1 .. "_1_1"
		end
		
		HelpGuide:open({
			contents_id = var_11_1,
			parent = SceneManager:getRunningNativeScene(),
			map_id = Battle.logic.map.enter
		})
		
		return 
	end
	
	if SceneManager:getCurrentSceneName() ~= "battle" or not arg_11_0.vars.map_id then
		return 
	end
	
	if not arg_11_0.vars.cur_group_id or not arg_11_0.vars.cur_menu_id or not arg_11_0.vars.cur_category_idx or not arg_11_0.vars.cur_page_idx then
		return 
	end
	
	if arg_11_0.vars.cur_group_id == "bossguide" then
		arg_11_0.vars.cur_menu_id = "bossguide"
	end
	
	local var_11_2 = arg_11_0.vars.cur_menu_id .. "_" .. arg_11_0.vars.cur_category_idx .. "_" .. arg_11_0.vars.cur_page_idx
	local var_11_3 = false
	
	if arg_11_0.vars.cur_group_id == "bossguide" and not BossGuide:hasGuide(Battle.logic.map.enter) then
		var_11_2 = var_0_1 .. "_1_1"
		var_11_3 = true
	end
	
	if BossGuide:hasGuide(Battle.logic.map.enter) and TutorialGuide:isPlayingTutorial("boss_guide") then
		var_11_2 = "bossguide_1_1"
	end
	
	arg_11_0.vars = {}
	
	HelpGuide:open({
		contents_id = var_11_2,
		parent = SceneManager:getRunningNativeScene(),
		map_id = Battle.logic.map.enter,
		getByMenu = var_11_3
	})
end

function HelpGuide.loadData(arg_12_0, arg_12_1)
	local function var_12_0(arg_13_0)
		if not IS_PUBLISHER_ZLONG then
			return true
		end
		
		if arg_13_0 == "inforta_8" or arg_13_0 == "inforta_9" or arg_13_0 == "inforta_10" then
			return false
		end
		
		return true
	end
	
	if not arg_12_0.vars then
		arg_12_0.vars = {}
	end
	
	arg_12_0.vars.help_data = {}
	arg_12_1 = arg_12_1 or {}
	
	for iter_12_0 = 1, 99 do
		local var_12_1 = {
			menu = {}
		}
		
		var_12_1.id, var_12_1.type, var_12_1.sort, var_12_1.name = DBN("help_0_group", iter_12_0, {
			"id",
			"type",
			"sort",
			"name"
		})
		
		if not var_12_1.id then
			break
		end
		
		local var_12_2 = false
		
		if arg_12_0.vars.is_lota then
			var_12_2 = var_12_1.type == "clanheritage"
		elseif arg_12_0.vars.is_rumble then
			var_12_2 = var_12_1.type == "rumble"
		elseif var_12_1.type == "all" then
			var_12_2 = true
		elseif var_12_1.type == "battle" and SceneManager:getCurrentSceneName() == "battle" then
			var_12_2 = true
		else
			local var_12_3 = string.split(var_12_1.type)
			
			for iter_12_1, iter_12_2 in pairs(var_12_3) do
				if iter_12_2 == arg_12_0.vars.contents_id then
					var_12_2 = true
					
					break
				end
			end
		end
		
		if var_12_2 then
			table.insert(arg_12_0.vars.help_data, var_12_1)
			
			for iter_12_3 = 1, 99 do
				local var_12_4 = {
					category = {}
				}
				
				var_12_4.id, var_12_4.name, var_12_4.image, var_12_4.type, var_12_4.sub_type, var_12_4.sub_icon, var_12_4.group_id = DBN("help_1_menu", iter_12_3, {
					"id",
					"name",
					"image",
					"type",
					"sub_type",
					"sub_icon",
					"group_id"
				})
				
				if not var_12_4.id then
					break
				end
				
				local var_12_5 = false
				
				if var_12_4.group_id and var_12_1.id == var_12_4.group_id then
					table.insert(var_12_1.menu, var_12_4)
					
					for iter_12_4 = 1, 99 do
						local var_12_6 = string.format("%s_%d", var_12_4.id, iter_12_4)
						local var_12_7 = DBT("help_2_category", var_12_6, {
							"id",
							"name"
						})
						
						if var_12_0(var_12_6) and var_12_7 and not table.empty(var_12_7) then
							table.insert(var_12_4.category, var_12_7)
							
							var_12_7.pages = {}
							
							for iter_12_5 = 1, 999 do
								local var_12_8 = string.format("%s_%d_%d", var_12_4.id, iter_12_4, iter_12_5)
								local var_12_9 = DBT("help_3_contents", var_12_8, {
									"id",
									"name",
									"image",
									"desc",
									"move",
									"system_lock"
								})
								
								if not var_12_9 or table.count(var_12_9) == 0 then
									break
								end
								
								table.insert(var_12_7.pages, var_12_9)
							end
						end
					end
				elseif var_12_4.group_id == nil then
				end
			end
		end
	end
	
	local var_12_10 = arg_12_0:loadBossGuideData()
	
	if var_12_10 and not table.empty(var_12_10) then
		local var_12_11 = {
			id = "bossguide",
			name = "level_guide_title",
			sort = -1
		}
		
		table.insert(arg_12_0.vars.help_data, var_12_11)
		
		arg_12_0.vars.boss_guide_data = var_12_10
	end
	
	table.sort(arg_12_0.vars.help_data, function(arg_14_0, arg_14_1)
		return arg_14_0.sort < arg_14_1.sort
	end)
end

function HelpGuide.loadBossGuideData(arg_15_0)
	if not arg_15_0:canOpenBossGuidePage() then
		return 
	end
	
	local var_15_0 = {}
	local var_15_1 = arg_15_0.vars.map_id
	
	arg_15_0.vars.clearData = Account:getClearEvent(var_15_1) or {}
	arg_15_0.vars.isExpired = Account:isExpiredStage(var_15_1)
	
	local function var_15_2(arg_16_0)
		if arg_15_0.vars.isExpired then
			return false
		end
		
		if not table.find(arg_15_0.vars.clearData, function(arg_17_0, arg_17_1)
			if DB("level_enter", var_15_1, "contents_type") == "raid" then
				arg_17_0 = string.gsub(arg_17_0, "#", "_")
			end
			
			return arg_17_0 == arg_16_0 and arg_17_1 == true
		end) then
			return false
		end
		
		return true
	end
	
	for iter_15_0 = 1, 999 do
		local var_15_3 = var_15_1 .. "_" .. tostring(iter_15_0)
		local var_15_4, var_15_5 = DB("level_guide_ext", var_15_3, {
			"id",
			"stage_data_id"
		})
		
		if var_15_4 == nil then
			break
		end
		
		local var_15_6 = {}
		
		table.insert(var_15_6, BossGuideUtil:createBossInfo(var_15_3))
		table.insert(var_15_6, BossGuideUtil:createCorpsInfo(var_15_3))
		table.insert(var_15_6, BossGuideUtil:createDropsInfo(var_15_3, var_15_1))
		table.insert(var_15_6, {
			id = var_15_4,
			stage_id = var_15_5,
			is_clear = var_15_2(var_15_5)
		})
		table.push(var_15_0, var_15_6)
	end
	
	return var_15_0
end

function HelpGuide.createUI(arg_18_0, arg_18_1)
	arg_18_1 = arg_18_1 or {}
	arg_18_0.vars.wnd = Dialog:open("wnd/help_base", arg_18_0, {
		back_func = function()
			arg_18_0:close()
		end
	})
	
	;(arg_18_1.parent or SceneManager:getRunningPopupScene()):addChild(arg_18_0.vars.wnd)
	arg_18_0.vars.wnd:bringToFront()
	
	local var_18_0 = arg_18_0.vars.wnd:getChildByName("n_categories")
	
	HELP_GROUP:initScrollView(var_18_0:getChildByName("scrollview"), 240, 57)
	HELP_GROUP:createScrollViewItems(arg_18_0.vars.help_data)
	
	local var_18_1 = var_18_0:getChildByName("scrollview"):getContentSize().height
	local var_18_2 = 14
	local var_18_3 = 24
	
	HELP_GROUP.nodes = {}
	
	local var_18_4 = 0
	
	for iter_18_0, iter_18_1 in pairs(HELP_GROUP.ScrollViewItems) do
		var_18_4 = var_18_4 + iter_18_1.control:getContentSize().height
		
		table.insert(HELP_GROUP.nodes, iter_18_1.control)
	end
	
	local var_18_5 = HELP_GROUP.scrollview:getInnerContainerSize()
	
	var_18_5.height = var_18_4 + var_18_2
	
	HELP_GROUP.scrollview:setInnerContainerSize(var_18_5)
	
	local var_18_6 = var_18_1 - var_18_2 - var_18_3
	
	if var_18_1 < var_18_4 then
		var_18_6 = var_18_4 - var_18_3
	end
	
	for iter_18_2, iter_18_3 in pairs(HELP_GROUP.nodes) do
		iter_18_3:setPositionY(var_18_6)
		
		var_18_6 = var_18_6 - iter_18_3:getContentSize().height
	end
	
	local var_18_7 = arg_18_0.vars.wnd:getChildByName("n_category")
	
	arg_18_0.vars.n_scrollview = var_18_7:getChildByName("scrollview2")
	arg_18_0.vars.n_contents_scrollview = arg_18_0.vars.wnd:getChildByName("contents_scroll")
	
	if PAUSED and get_cocos_refid(arg_18_0.vars.n_scrollview) then
		arg_18_0.vars.scrollviewBar = arg_18_0.vars.n_scrollview:getVerticalScrollBar()
		arg_18_0.vars.contents_scrollviewBar = arg_18_0.vars.n_contents_scrollview:getVerticalScrollBar()
		
		Scheduler:add(arg_18_0.vars.n_scrollview, arg_18_0.forced_scrollviewUpdate, arg_18_0)
	end
end

function HelpGuide.forced_scrollviewUpdate(arg_20_0)
	if arg_20_0.vars and get_cocos_refid(arg_20_0.vars.n_scrollview) then
		local var_20_0 = cc.Director:getInstance():getDeltaTime() or 0.1
		
		arg_20_0.vars.n_scrollview:update(var_20_0)
		arg_20_0.vars.n_contents_scrollview:update(var_20_0)
		
		if arg_20_0.vars.scrollviewBar and arg_20_0.vars.contents_scrollviewBar then
			arg_20_0.vars.scrollviewBar:update(var_20_0)
			arg_20_0.vars.contents_scrollviewBar:update(var_20_0)
		end
	end
end

function HelpGuide._setSelectGroup(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	if not arg_21_0.vars.wnd then
		return 
	end
	
	local var_21_0 = arg_21_2 or var_0_2
	local var_21_1 = arg_21_3 or var_0_3
	
	arg_21_0.vars.cur_group = arg_21_1
	arg_21_0.vars.cur_list = {}
	
	local var_21_2 = {}
	
	for iter_21_0, iter_21_1 in pairs(arg_21_0.vars.help_data) do
		if iter_21_1.id == arg_21_1 then
			for iter_21_2, iter_21_3 in pairs(iter_21_1.menu) do
				if iter_21_3.group_id == arg_21_1 then
					local var_21_3 = {
						is_menu_title = true,
						id = iter_21_3.id,
						name = iter_21_3.name,
						type = iter_21_3.type
					}
					
					table.insert(var_21_2, var_21_3)
					table.insert(arg_21_0.vars.cur_list, var_21_2)
					
					for iter_21_4, iter_21_5 in pairs(iter_21_3.category) do
						iter_21_5.menu_id = iter_21_3.id
						iter_21_5.menu_name = iter_21_3.name
						
						table.insert(var_21_2, iter_21_5)
						table.insert(arg_21_0.vars.cur_list, iter_21_5)
					end
				end
			end
		end
	end
	
	local var_21_4 = arg_21_0.vars.wnd:getChildByName("n_category")
	
	HELP_CATEGORY:initScrollView(var_21_4:getChildByName("scrollview2"), 206, 56)
	
	local var_21_5 = var_21_4:getChildByName("scrollview2"):getContentSize()
	local var_21_6 = var_21_5.height
	local var_21_7 = 21
	local var_21_8 = 14
	
	HELP_CATEGORY:createScrollViewItems(var_21_2)
	
	HELP_CATEGORY.nodes = {}
	
	local var_21_9 = 0
	
	for iter_21_6, iter_21_7 in pairs(HELP_CATEGORY.ScrollViewItems) do
		local var_21_10 = iter_21_7.control
		local var_21_11 = var_21_10:getChildByName("txt_contents"):getStringNumLines() - 1
		
		if var_21_11 < 0 then
			var_21_11 = 0
		end
		
		local var_21_12 = 20 * var_21_11
		local var_21_13 = var_21_10:getContentSize()
		
		var_21_9 = var_21_9 + var_21_13.height + var_21_12
		
		var_21_10:setContentSize(var_21_13.width, var_21_13.height + var_21_12)
		
		if var_21_11 > 0 then
			local var_21_14 = var_21_10:getChildByName("txt_contents")
			
			var_21_14:setPositionY(var_21_14:getPositionY() + var_21_12 / 2)
		end
		
		local var_21_15 = var_21_10:getChildByName("img_select")
		local var_21_16 = var_21_15:getContentSize()
		
		var_21_15:setContentSize(var_21_16.width, var_21_16.height + var_21_12)
		
		if var_21_11 > 0 then
			var_21_15:setPositionY(var_21_15:getPositionY() + var_21_12 / 2)
		end
		
		iter_21_7.control.string_line = var_21_11
		
		table.insert(HELP_CATEGORY.nodes, iter_21_7.control)
	end
	
	local var_21_17 = HELP_CATEGORY.scrollview:getInnerContainerSize()
	
	var_21_17.height = var_21_9 + var_21_7
	
	HELP_CATEGORY.scrollview:setInnerContainerSize(var_21_17)
	
	local var_21_18 = var_21_6 - (var_21_7 + var_21_8)
	
	if var_21_6 < var_21_9 then
		var_21_18 = var_21_9 - var_21_8
	end
	
	local var_21_19 = 0
	local var_21_20 = 0
	
	for iter_21_8, iter_21_9 in pairs(HELP_CATEGORY.nodes) do
		iter_21_9:setPositionY(var_21_18)
		
		local var_21_21 = iter_21_9:getContentSize()
		
		var_21_18 = var_21_18 - var_21_21.height
		var_21_19 = var_21_19 + var_21_21.height
		
		if var_21_20 == 0 and var_21_19 > var_21_5.height then
			var_21_20 = iter_21_8
		end
	end
	
	arg_21_0:_setCategory(var_21_0, var_21_1, arg_21_4)
	HELP_CATEGORY.scrollview:forceDoLayout()
	
	local var_21_22 = table.count(HELP_CATEGORY.nodes)
	local var_21_23 = arg_21_0.vars.cur_category_idx or 0
	
	if var_21_23 and var_21_20 > 0 and var_21_20 <= var_21_23 then
		local var_21_24 = math.min(var_21_22, var_21_23) / var_21_22
		
		HELP_CATEGORY.scrollview:scrollToPercentVertical(var_21_24 * 100, 0.01, false)
	else
		HELP_CATEGORY.scrollview:scrollToTop(0.01, false)
	end
end

function HelpGuide._setGroup(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	local var_22_0 = arg_22_1 or var_0_0
	local var_22_1 = arg_22_2 or var_0_2
	local var_22_2 = arg_22_3 or var_0_3
	
	arg_22_0.vars.cur_group_id = var_22_0
	
	for iter_22_0, iter_22_1 in pairs(HELP_GROUP.ScrollViewItems) do
		if_set_visible(iter_22_1.control, "bg", iter_22_1.item.id == var_22_0)
	end
	
	if var_22_0 == "bossguide" then
		HelpGuide:_showBossGuidePage()
	else
		arg_22_0:_hideBossGuidePage()
		arg_22_0:_setSelectGroup(var_22_0, var_22_1, var_22_2, arg_22_4)
	end
end

function HelpGuide._setCategory(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	arg_23_0.vars.cur_category_idx = arg_23_1
	
	for iter_23_0, iter_23_1 in pairs(HELP_CATEGORY.ScrollViewItems) do
		if_set_visible(iter_23_1.control, "img_select", iter_23_0 == arg_23_1)
		
		if iter_23_0 == arg_23_1 then
			local var_23_0 = iter_23_1.item.menu_name
			
			if var_23_0 then
				if_set(arg_23_0.vars.wnd, "t_sub", T(var_23_0))
			end
		end
	end
	
	arg_23_0:_setPage(arg_23_2, arg_23_3)
end

function HelpGuide._getPagesData(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_1 .. "_" .. arg_24_2
	
	for iter_24_0, iter_24_1 in pairs(arg_24_0.vars.cur_list) do
		if iter_24_1.id and iter_24_1.id == var_24_0 then
			return iter_24_1.pages, iter_24_0
		end
	end
	
	Log.e("wrong_help_1_menu_data:", var_24_0)
	
	return arg_24_0.vars.cur_list[2].pages, 2
end

function HelpGuide._setPage(arg_25_0, arg_25_1, arg_25_2)
	if not arg_25_0.vars.wnd then
		return 
	end
	
	local var_25_0 = {}
	
	if arg_25_2 and arg_25_0.vars.cur_menu_id then
		var_25_0, arg_25_0.vars.cur_category_idx = arg_25_0:_getPagesData(arg_25_0.vars.cur_menu_id, arg_25_0.vars.cur_category_idx)
	else
		var_25_0 = arg_25_0.vars.cur_list[arg_25_0.vars.cur_category_idx].pages
		arg_25_0.vars.cur_menu_id = arg_25_0.vars.cur_list[arg_25_0.vars.cur_category_idx].menu_id
	end
	
	if table.count(var_25_0) == 1 then
		if_set_opacity(arg_25_0.vars.wnd, "n_btn_next", 76.5)
		if_set_opacity(arg_25_0.vars.wnd, "n_btn_prev", 76.5)
	elseif table.count(var_25_0) > 1 then
		if arg_25_1 <= 1 then
			if_set_opacity(arg_25_0.vars.wnd, "n_btn_prev", 76.5)
		else
			if_set_opacity(arg_25_0.vars.wnd, "n_btn_prev", 255)
		end
		
		if arg_25_1 >= table.count(var_25_0) then
			if_set_opacity(arg_25_0.vars.wnd, "n_btn_next", 76.5)
		else
			if_set_opacity(arg_25_0.vars.wnd, "n_btn_next", 255)
		end
	end
	
	if arg_25_1 < 1 or arg_25_1 > #var_25_0 then
		return 
	end
	
	arg_25_0.vars.cur_page_idx = arg_25_1
	arg_25_0.vars.cur_page_data = var_25_0[arg_25_1]
	
	local var_25_1 = arg_25_0.vars.wnd.c.n_contents
	local var_25_2 = false
	
	if_set(var_25_1, "contents_title", T(arg_25_0.vars.cur_page_data.name))
	
	local var_25_3 = arg_25_0.vars.wnd:getChildByName("contents_scroll")
	
	var_25_3:removeAllChildren()
	UIUtil:setScrollViewText(var_25_3, T(arg_25_0.vars.cur_page_data.desc), {
		opacity = 102,
		outline_size = 1,
		line_spacing = 5,
		outline_color = cc.c3b(26, 26, 26)
	})
	if_set_sprite(var_25_1, "contents_image", "tutorial/" .. arg_25_0.vars.cur_page_data.image)
	
	local var_25_4 = arg_25_0.vars.wnd.c.n_btn_move
	
	var_25_4:getChildByName("btn_move").move_path = arg_25_0.vars.cur_page_data.move
	var_25_4:getChildByName("btn_move").unlock_id = arg_25_0.vars.cur_page_data.system_lock
	
	if arg_25_0.vars.cur_page_data.move then
		local var_25_5 = false
		
		if arg_25_0.vars.cur_page_data.system_lock then
			var_25_5 = not UnlockSystem:isUnlockSystem(arg_25_0.vars.cur_page_data.system_lock)
		end
		
		if_set_visible(var_25_4, "move_icon_lock", var_25_5)
		var_25_4:setVisible(true)
		
		var_25_2 = true
	else
		var_25_4:setVisible(false)
	end
	
	local var_25_6 = arg_25_0.vars.show_move_btn and var_25_2
	
	var_25_4:setVisible(var_25_6)
	arg_25_0.vars.wnd.c.t_pagenow:setString(T("page_text", {
		page = string.format("%d/%d", arg_25_0.vars.cur_page_idx, #var_25_0)
	}))
end

function HelpGuide.canOpenBossGuidePage(arg_26_0)
	if not arg_26_0.vars or SceneManager:getCurrentSceneName() ~= "battle" or not arg_26_0.vars.map_id and not BossGuide:hasGuide(arg_26_0.vars.map_id) then
		return 
	end
	
	return true
end

function HelpGuide._showBossGuidePage(arg_27_0)
	if not arg_27_0:canOpenBossGuidePage() then
		return 
	end
	
	arg_27_0:_setBossGuidePage(true)
	
	local var_27_0 = arg_27_0.vars.wnd:getChildByName("n_boss_guide")
	
	if not arg_27_0.vars.is_init_bossGuide_wnd then
		HELP_BOSS_GUIDE:initScrollView(var_27_0:getChildByName("scrollview"), 740, 420)
		HELP_BOSS_GUIDE:createScrollViewItems(arg_27_0.vars.boss_guide_data)
		
		arg_27_0.vars.is_init_bossGuide_wnd = true
		
		if arg_27_0.vars.map_id then
			local var_27_1 = T("guide_desc_" .. tostring(arg_27_0.vars.map_id))
			
			if_set(var_27_0, "desc", var_27_1)
		end
	end
	
	if_set(arg_27_0.vars.wnd, "t_sub", T("level_guide_title"))
end

function HelpGuide._hideBossGuidePage(arg_28_0)
	arg_28_0:_setBossGuidePage(false)
end

function HelpGuide._setBossGuidePage(arg_29_0, arg_29_1)
	if not arg_29_0:canOpenBossGuidePage() then
		return 
	end
	
	if_set_visible(arg_29_0.vars.wnd, "n_boss_guide", arg_29_1)
	if_set_visible(arg_29_0.vars.wnd, "n_category", not arg_29_1)
	if_set_visible(arg_29_0.vars.wnd, "n_contents", not arg_29_1)
	if_set_visible(arg_29_0.vars.wnd, "n_btns", not arg_29_1)
	if_set_visible(arg_29_0.vars.wnd, "t_pagenow", not arg_29_1)
end

function HelpGuide.close(arg_30_0)
	if not arg_30_0.vars or not get_cocos_refid(arg_30_0.vars.wnd) then
		return 
	end
	
	BackButtonManager:pop("help_base")
	Dialog:closeInBackFunc("help_base")
	Battle:setTouckBlockOnce()
	
	if PAUSED then
		Scheduler:remove(arg_30_0.forced_scrollviewUpdate)
	end
	
	if arg_30_0.vars.is_lota and LotaSystem:isActive() then
		LotaSystem:setBlockCoolTime()
	end
	
	if arg_30_0.vars.close_callback then
		arg_30_0.vars.close_callback()
	end
	
	if PAUSED and SceneManager:getCurrentSceneName() == "mini_volley_ball" then
		resume()
	end
	
	if not arg_30_0:canOpenBossGuidePage() then
		arg_30_0.vars = {}
	end
end

function HelpGuide.isShow(arg_31_0)
	if not arg_31_0.vars or not get_cocos_refid(arg_31_0.vars.wnd) then
		return 
	end
	
	return arg_31_0.vars.wnd:isVisible()
end
