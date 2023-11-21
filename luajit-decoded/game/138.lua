MoonlightTheaterCastBoard = MoonlightTheaterCastBoard or {}

function MsgHandler.moonlight_theater_cast_reward(arg_1_0)
	if arg_1_0.rewards then
		local var_1_0 = {
			title = T("theater_ticket_title"),
			desc = T("theater_board_reward_desc")
		}
		
		var_1_0.open_effect = true
		
		Account:addReward(arg_1_0.rewards, {
			play_reward_data = var_1_0
		})
	end
	
	if arg_1_0.change_cast_infos then
		for iter_1_0, iter_1_1 in pairs(arg_1_0.change_cast_infos) do
			Account:add_mlt_cast_data(iter_1_1)
		end
	end
	
	MoonlightTheaterCastBoard:res_reward(arg_1_0)
end

function HANDLER.story_theater_hero(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_reward" or arg_2_1 == "btn_select" then
		MoonlightTheaterCastBoard:req_reward()
	elseif arg_2_1 ~= "btn_hero_dic" and arg_2_1 == "btn_hero_dic2" then
	end
end

function MoonlightTheaterCastBoard.show(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	if not arg_3_2 or arg_3_0.vars and get_cocos_refid(arg_3_0.vars.wnd) then
		return 
	end
	
	local var_3_0 = arg_3_1 or SceneManager:getRunningPopupScene()
	
	arg_3_0.vars = {}
	arg_3_0.vars.id = arg_3_2
	arg_3_0.vars.bg_id = arg_3_3
	arg_3_0.vars.wnd = load_dlg("story_theater_hero", true, "wnd")
	
	arg_3_0:initData()
	arg_3_0:initUI()
	var_3_0:addChild(arg_3_0.vars.wnd)
	arg_3_0.vars.list_view:setVisible(false)
	arg_3_0.vars.wnd:setOpacity(0)
	UIAction:Add(SEQ(LOG(FADE_IN(300))), arg_3_0.vars.wnd, "block")
	UIAction:Add(SEQ(DELAY(150), CALL(function()
		MoonlightTheaterCastBoard.vars.list_view:setVisible(true)
	end)), arg_3_0.vars.wnd, "block")
	
	local var_3_1 = "infosubs_9"
	
	TopBarNew:createFromPopup(T("theater_title"), arg_3_0.vars.wnd, function()
		MoonlightTheaterCastBoard:close()
	end, nil, var_3_1)
	TopBarNew:setCurrencies({
		"crystal",
		"gold",
		"theaterticket"
	})
end

function MoonlightTheaterCastBoard.initData(arg_6_0)
	arg_6_0.vars.data = {}
	arg_6_0.vars.btn_bi = DB("ml_theater", arg_6_0.vars.id, {
		"btn_bi"
	})
	
	arg_6_0:updateData()
end

function MoonlightTheaterCastBoard.updateData(arg_7_0)
	arg_7_0.vars.can_req_reward = false
	arg_7_0.vars.total_cast_count = 0
	arg_7_0.vars.cur_cast_count = 0
	
	for iter_7_0 = 1, 999999999 do
		local var_7_0 = arg_7_0.vars.id .. "_slot" .. iter_7_0
		local var_7_1 = DBT("ml_theater_cast", var_7_0, {
			"id",
			"cast_char",
			"cast_reward",
			"cast_reward_val"
		})
		
		if not var_7_1 or not var_7_1.id then
			break
		end
		
		var_7_1.is_user_have = Account:getCollectionUnit(var_7_1.cast_char)
		var_7_1.is_rewarded = Account:is_received_casting_reward(var_7_1.id)
		
		if var_7_1.is_user_have then
			arg_7_0.vars.cur_cast_count = arg_7_0.vars.cur_cast_count + 1
		end
		
		if not arg_7_0.vars.can_req_reward and var_7_1.is_user_have and not var_7_1.is_rewarded then
			arg_7_0.vars.can_req_reward = true
		end
		
		table.insert(arg_7_0.vars.data, var_7_1)
	end
	
	arg_7_0.vars.total_cast_count = table.count(arg_7_0.vars.data)
end

function MoonlightTheaterCastBoard.initUI(arg_8_0)
	if_set_sprite(arg_8_0.vars.wnd, "Sprite_322", "banner/" .. arg_8_0.vars.btn_bi .. ".png")
	
	local var_8_0 = arg_8_0.vars.bg_id
	local var_8_1 = arg_8_0.vars.wnd:getChildByName("LEFT_BG")
	
	arg_8_0.vars.bg_node = cc.Sprite:create("banner/" .. var_8_0 .. ".png")
	
	if not arg_8_0.vars.bg_node then
		arg_8_0.vars.bg_node = cc.Sprite:create("banner/ss_vms01a_poster.png")
	end
	
	var_8_1:getChildByName("n_bg"):addChild(arg_8_0.vars.bg_node)
	arg_8_0.vars.bg_node:setAnchorPoint(0.095, 0.5)
	arg_8_0.vars.bg_node:setPosition(0, 0)
	arg_8_0.vars.bg_node:setScale(1)
	
	arg_8_0.vars.list_view = ItemListView:bindControl(arg_8_0.vars.wnd:getChildByName("ListView_hero"))
	
	local var_8_2 = {
		onUpdate = function(arg_9_0, arg_9_1, arg_9_2)
			local var_9_0 = UIUtil:getRewardIcon(tonumber(arg_9_2.cast_reward_val), arg_9_2.cast_reward, {
				tooltip_delay = 300,
				parent = arg_9_1:getChildByName("n_reward_item")
			})
			
			arg_9_1:getChildByName("n_reward_item"):bringToFront()
			if_set_sprite(arg_9_1, "img_hero", "theater/" .. arg_9_2.cast_char .. "_t.png")
			
			local var_9_1 = arg_9_2.is_user_have
			local var_9_2 = arg_9_2.is_rewarded
			local var_9_3 = DB("character", arg_9_2.cast_char, {
				"name"
			})
			
			if var_9_3 then
				if_set(arg_9_1, "txt_name", T(var_9_3))
			end
			
			local var_9_4 = arg_9_1:getChildByName("icon_check")
			
			if get_cocos_refid(var_9_4) then
				var_9_4:setVisible(var_9_2)
				var_9_4:bringToFront()
			end
			
			if_set_color(arg_9_1, "img_hero", not var_9_1 and tocolor("#525252 ") or tocolor("#FFFFFF"))
			if_set_color(var_9_0, nil, not (var_9_1 and not var_9_2) and tocolor("#525252 ") or tocolor("#FFFFFF"))
			
			local var_9_5 = arg_9_1:getChildByName("btn_hero_dic")
			local var_9_6 = arg_9_1:getChildByName("btn_hero_dic2")
			local var_9_7 = DB("character", arg_9_2.cast_char, {
				"grade"
			}) or 5
			
			WidgetUtils:setupPopup({
				control = var_9_5,
				creator = function()
					return UIUtil:getCharacterPopup({
						z = 6,
						use_basic_star = true,
						lv = 1,
						code = arg_9_2.cast_char,
						grade = var_9_7
					})
				end
			})
			WidgetUtils:setupPopup({
				control = var_9_6,
				creator = function()
					return UIUtil:getCharacterPopup({
						z = 6,
						use_basic_star = true,
						lv = 1,
						code = arg_9_2.cast_char,
						grade = var_9_7
					})
				end
			})
		end
	}
	
	arg_8_0.vars.list_view:setRenderer(load_control("wnd/story_theater_hero_item.csb"), var_8_2)
	arg_8_0.vars.list_view:setItems(arg_8_0.vars.data)
	arg_8_0:updateUI()
end

function MoonlightTheaterCastBoard.updateUI(arg_12_0)
	arg_12_0.vars.list_view:setItems(arg_12_0.vars.data)
	
	local var_12_0 = arg_12_0.vars.wnd:getChildByName("btn_reward")
	
	if_set_visible(var_12_0, "icon_noti", arg_12_0.vars.can_req_reward)
	if_set(arg_12_0.vars.wnd, "txt_casting_count", arg_12_0.vars.cur_cast_count .. "/" .. arg_12_0.vars.total_cast_count)
	if_set_opacity(arg_12_0.vars.wnd, "btn_reward", arg_12_0.vars.can_req_reward and 255 or 76.5)
end

function MoonlightTheaterCastBoard.req_reward(arg_13_0)
	if not arg_13_0.vars.can_req_reward then
		balloon_message_with_sound("theater_board_err")
		
		return 
	end
	
	query("moonlight_theater_cast_reward", {
		world_id = arg_13_0.vars.id
	})
end

function MoonlightTheaterCastBoard.res_reward(arg_14_0, arg_14_1)
	if not arg_14_1 then
		return 
	end
	
	arg_14_0.vars.can_req_reward = false
	
	arg_14_0:initData()
	arg_14_0:updateUI()
	SubStoryMoonlightTheater:updateCastingBtnNoti()
end

function MoonlightTheaterCastBoard.move_to_dict(arg_15_0, arg_15_1)
	if not arg_15_1 then
		return 
	end
	
	SceneManager:popScene()
	SceneManager:nextScene("collection", {
		mode = "unit",
		code = arg_15_1
	})
end

function MoonlightTheaterCastBoard.close(arg_16_0)
	arg_16_0.vars.list_view:setVisible(false)
	UIAction:Add(SEQ(LOG(FADE_OUT(300)), REMOVE(), CALL(function()
		arg_16_0.vars = nil
	end)), arg_16_0.vars.wnd, "block")
	TopBarNew:pop()
	BackButtonManager:pop("TopBarNew." .. T("theater_title"))
end
