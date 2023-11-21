HeroRecommend = {}

function HeroRecommend.setRecommendTag(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	HeroRecommend.DB.add_name = arg_1_3 or ""
	
	HeroRecommend.Tag:setRecommendTag(arg_1_1, arg_1_2)
end

function HeroRecommend.close(arg_2_0)
	HeroRecommend.DB:close()
end

HeroRecommend.Tag = {}
HeroRecommend.Tag.MAX_TAG_COUNT = 3

function HeroRecommend.Tag.setRecommendTag(arg_3_0, arg_3_1, arg_3_2)
	if not get_cocos_refid(arg_3_2) then
		return 
	end
	
	local var_3_0 = arg_3_0:getTagList(arg_3_1) or {}
	local var_3_1 = table.count(var_3_0)
	
	if var_3_1 == 0 then
		arg_3_2:setVisible(false)
		
		return 
	end
	
	for iter_3_0 = 1, arg_3_0.MAX_TAG_COUNT do
		local var_3_2 = arg_3_2:getChildByName("n_hero_tag" .. iter_3_0)
		
		if not get_cocos_refid(var_3_2) then
			break
		end
		
		var_3_2:setVisible(false)
		var_3_2:removeAllChildren()
	end
	
	for iter_3_1 = 1, var_3_1 do
		local var_3_3 = var_3_0[iter_3_1]
		local var_3_4 = arg_3_2:getChildByName("n_hero_tag" .. iter_3_1 + arg_3_0.MAX_TAG_COUNT - var_3_1)
		
		if not var_3_3 or not get_cocos_refid(var_3_4) then
			break
		end
		
		local var_3_5 = load_control("wnd/hero_tag_icon.csb")
		
		var_3_5:setAnchorPoint(0.5, 0.5)
		var_3_4:addChild(var_3_5)
		if_set_sprite(var_3_5, "icon_menu", var_3_3.icon)
		if_set_visible(var_3_5, "btn_tag", false)
		HeroRecommend.Tooltip:setupTooltip(arg_3_1, var_3_5)
		var_3_4:setVisible(true)
	end
	
	arg_3_2:setVisible(true)
end

function HeroRecommend.Tag.getTagList(arg_4_0, arg_4_1)
	local var_4_0 = HeroRecommend.DB:getTagList(arg_4_1)
	
	if not var_4_0 then
		return 
	end
	
	local var_4_1 = {}
	local var_4_2 = {}
	
	for iter_4_0, iter_4_1 in pairs(var_4_0) do
		local var_4_3 = DBT("hero_recommend_tag", iter_4_1, {
			"id",
			"tag_group",
			"icon"
		})
		
		if var_4_3 and var_4_3.tag_group and not var_4_2[var_4_3.tag_group] then
			var_4_2[var_4_3.tag_group] = true
			
			table.insert(var_4_1, var_4_3)
		end
		
		if table.count(var_4_1) >= arg_4_0.MAX_TAG_COUNT then
			break
		end
	end
	
	return var_4_1
end

HeroRecommend.Tooltip = {}
HeroRecommend.Tooltip.MAX_TAG_COUNT = 10

function HeroRecommend.Tooltip.setupTooltip(arg_5_0, arg_5_1, arg_5_2)
	if not arg_5_1 or not get_cocos_refid(arg_5_2) then
		return 
	end
	
	if get_cocos_refid(arg_5_2._TOUCH_LISTENER) then
		arg_5_2._TOUCH_LISTENER:removeFromParent()
	end
	
	arg_5_2._TOUCH_LISTENER = nil
	
	WidgetUtils:setupTooltip({
		delay = 100,
		control = arg_5_2,
		creator = function()
			return arg_5_0:create(arg_5_1)
		end
	})
end

function HeroRecommend.Tooltip.create(arg_7_0, arg_7_1)
	if not arg_7_1 then
		return 
	end
	
	local var_7_0 = load_control("wnd/tag_recom_tooltip.csb")
	
	arg_7_0:setUI(arg_7_1, var_7_0)
	
	return var_7_0
end

function HeroRecommend.Tooltip.setUI(arg_8_0, arg_8_1, arg_8_2)
	if not get_cocos_refid(arg_8_2) then
		return 
	end
	
	local function var_8_0(arg_9_0, arg_9_1)
		if not get_cocos_refid(arg_9_0) then
			return 
		end
		
		if_set(arg_9_0, "t_1", T(arg_9_1.title))
		if_set(arg_9_0, "t_2", T(arg_9_1.desc))
		if_set_sprite(arg_9_0, "icon_contents", arg_9_1.icon)
		
		local var_9_0 = arg_9_0:getChildByName("t_1")
		
		if get_cocos_refid(var_9_0) and not arg_9_1.desc then
			var_9_0:setPositionY(var_9_0:getPositionY() - 10)
		end
		
		arg_9_0:setVisible(true)
	end
	
	local var_8_1 = arg_8_0:getTagList(arg_8_1) or {}
	local var_8_2 = table.count(var_8_1)
	local var_8_3 = math.max(math.ceil(var_8_2 / 2), 2)
	local var_8_4 = {}
	
	if var_8_2 <= 2 then
		var_8_4[1] = arg_8_2:getChildByName("n_3")
		var_8_4[2] = arg_8_2:getChildByName("n_4")
	else
		for iter_8_0 = 1, var_8_2 do
			if iter_8_0 % 2 == 0 then
				var_8_4[iter_8_0] = arg_8_2:getChildByName("n_" .. (var_8_3 + 1) * 2 - iter_8_0)
			else
				var_8_4[iter_8_0] = arg_8_2:getChildByName("n_" .. var_8_3 * 2 - iter_8_0)
			end
		end
	end
	
	for iter_8_1 = 1, 10 do
		if_set_visible(arg_8_2, "n_" .. iter_8_1, false)
	end
	
	for iter_8_2, iter_8_3 in pairs(var_8_1) do
		var_8_0(var_8_4[iter_8_2], iter_8_3)
	end
	
	local var_8_5 = (5 - var_8_3) * 80
	local var_8_6 = arg_8_2:getChildByName("bg")
	
	if get_cocos_refid(var_8_6) then
		local var_8_7 = var_8_6:getContentSize()
		
		var_8_7.height = var_8_7.height - var_8_5
		
		var_8_6:setContentSize(var_8_7)
		arg_8_2:setContentSize(var_8_7)
	end
	
	local var_8_8 = arg_8_2:getChildByName("n_top")
	
	if get_cocos_refid(var_8_8) then
		var_8_8:setPositionY(var_8_8:getPositionY() - var_8_5)
	end
end

function HeroRecommend.Tooltip.getTagList(arg_10_0, arg_10_1)
	local var_10_0 = HeroRecommend.DB:getTagList(arg_10_1)
	
	if not var_10_0 then
		return 
	end
	
	local var_10_1 = {}
	
	for iter_10_0, iter_10_1 in pairs(var_10_0 or {}) do
		local var_10_2 = DBT("hero_recommend_tag", iter_10_1, {
			"id",
			"icon",
			"title",
			"desc"
		})
		
		if var_10_2 and var_10_2.id then
			table.insert(var_10_1, var_10_2)
		end
		
		if table.count(var_10_1) >= arg_10_0.MAX_TAG_COUNT then
			break
		end
	end
	
	return var_10_1
end

HeroRecommend.DB = {}

function HeroRecommend.DB.getTagList(arg_11_0, arg_11_1)
	if not arg_11_1 then
		return 
	end
	
	local var_11_0 = "hero_tag_map" .. arg_11_0.add_name
	
	if not arg_11_0[var_11_0] then
		arg_11_0[var_11_0] = arg_11_0:create()
	end
	
	local var_11_1 = arg_11_0[var_11_0][arg_11_1]
	
	if var_11_1 then
		table.sort(var_11_1, function(arg_12_0, arg_12_1)
			local var_12_0 = DB("hero_recommend_tag", arg_12_0, "sort")
			local var_12_1 = DB("hero_recommend_tag", arg_12_1, "sort")
			
			return to_n(var_12_0) < to_n(var_12_1)
		end)
	end
	
	return var_11_1
end

function HeroRecommend.DB.create(arg_13_0)
	local var_13_0 = {}
	
	local function var_13_1(arg_14_0)
		local var_14_0 = {
			day = arg_14_0 % 100,
			month = math.floor(arg_14_0 / 100) % 100,
			year = 2000 + math.floor(arg_14_0 / 10000)
		}
		
		return (Account:serverTimeDayLocalDetail(os.time(var_14_0)))
	end
	
	local var_13_2 = "hero_recommend" .. arg_13_0.add_name
	
	for iter_13_0 = 1, 9999 do
		local var_13_3, var_13_4, var_13_5, var_13_6 = DBN(var_13_2, iter_13_0, {
			"id",
			"date_id",
			"tag_id",
			"tag_hero"
		})
		
		if not var_13_3 then
			break
		end
		
		if var_13_5 then
			local var_13_7 = to_n(var_13_4)
			
			if (not var_13_0[var_13_5] or var_13_7 > var_13_0[var_13_5].date_id) and var_13_1(var_13_7) <= Account:serverTimeDayLocalDetail() then
				var_13_0[var_13_5] = {
					date_id = var_13_7,
					tag_id = var_13_5,
					tag_hero = var_13_6
				}
			end
		end
	end
	
	local var_13_8 = {}
	
	local function var_13_9(arg_15_0, arg_15_1)
		if not var_13_8[arg_15_0] then
			var_13_8[arg_15_0] = {}
		end
		
		table.insert(var_13_8[arg_15_0], arg_15_1)
	end
	
	for iter_13_1, iter_13_2 in pairs(var_13_0) do
		if iter_13_2.tag_hero then
			local var_13_10 = string.split(iter_13_2.tag_hero, ";")
			
			for iter_13_3, iter_13_4 in pairs(var_13_10 or {}) do
				var_13_9(iter_13_4, iter_13_2.tag_id)
			end
		end
	end
	
	return var_13_8
end

function HeroRecommend.DB.close(arg_16_0)
	arg_16_0.add_name = ""
	
	for iter_16_0, iter_16_1 in pairs(arg_16_0) do
		if type(iter_16_0) == "string" and string.starts(iter_16_0, "hero_tag_map") then
			arg_16_0[iter_16_0] = nil
		end
	end
end
