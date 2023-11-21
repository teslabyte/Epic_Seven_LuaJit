RumbleCollection = {}

function HANDLER.rumble_info(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		RumbleCollection:close()
	elseif arg_1_1 == "btn1" then
		RumbleCollection:setMode("hero")
	elseif arg_1_1 == "btn2" then
		RumbleCollection:setMode("synergy")
	elseif arg_1_1 == "btn_synergy" then
		RumbleSynergyPopup:open({
			id = arg_1_0.id
		})
	end
end

function RumbleCollection.show(arg_2_0, arg_2_1)
	if arg_2_0.vars and get_cocos_refid(arg_2_0.vars.wnd) then
		return 
	end
	
	arg_2_1 = arg_2_1 or {}
	
	local var_2_0 = arg_2_1.layer or SceneManager:getRunningPopupScene()
	
	if not get_cocos_refid(var_2_0) then
		return 
	end
	
	arg_2_0.vars = {}
	arg_2_0.vars.wnd = load_dlg("rumble_info", true, "wnd", function()
		arg_2_0:close()
	end)
	
	var_2_0:addChild(arg_2_0.vars.wnd)
	arg_2_0:cache()
	arg_2_0:initHeroList()
	arg_2_0:initSynergyList()
	arg_2_0:setMode("hero")
end

function RumbleCollection.setMode(arg_4_0, arg_4_1)
	if not arg_4_0.vars then
		return 
	end
	
	if arg_4_1 == "hero" then
		if_set_visible(arg_4_0.vars.tab_hero, "bg", true)
		if_set_visible(arg_4_0.vars.tab_synergy, "bg", false)
		if_set_visible(arg_4_0.vars.n_hero, nil, true)
		if_set_visible(arg_4_0.vars.n_synergy, nil, false)
	else
		if_set_visible(arg_4_0.vars.tab_hero, "bg", false)
		if_set_visible(arg_4_0.vars.tab_synergy, "bg", true)
		if_set_visible(arg_4_0.vars.n_hero, nil, false)
		if_set_visible(arg_4_0.vars.n_synergy, nil, true)
	end
end

function RumbleCollection.initHeroList(arg_5_0)
	if not arg_5_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_5_0.vars.n_hero) then
		return 
	end
	
	local var_5_0 = RumbleUtil:getUnitList()
	local var_5_1 = {
		[3] = arg_5_0.vars.n_hero:getChildByName("n_a"),
		[4] = arg_5_0.vars.n_hero:getChildByName("n_b"),
		[5] = arg_5_0.vars.n_hero:getChildByName("n_c")
	}
	local var_5_2 = {
		0,
		0,
		0,
		0,
		0
	}
	
	for iter_5_0, iter_5_1 in pairs(var_5_0) do
		local var_5_3 = RumbleUtil:getUnitInfo(iter_5_1)
		
		if var_5_3 then
			local var_5_4 = RumbleUtil:getHeroIcon(iter_5_1, {
				show_synergy = true,
				no_star = true,
				popup = true
			})
			
			if var_5_4 then
				local var_5_5 = var_5_3.grade or 1
				
				var_5_2[var_5_5] = var_5_2[var_5_5] + 1
				
				if get_cocos_refid(var_5_1[var_5_5]) then
					local var_5_6 = var_5_1[var_5_5]:getChildByName("n_" .. var_5_2[var_5_5])
					
					if get_cocos_refid(var_5_6) then
						var_5_6:addChild(var_5_4)
						var_5_6:setVisible(true)
					end
				end
			end
		end
	end
end

function RumbleCollection.initSynergyList(arg_6_0)
	if not arg_6_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_6_0.vars.n_synergy) then
		return 
	end
	
	arg_6_0.vars.list_synergy = ItemListView_v2:bindControl(arg_6_0.vars.n_synergy)
	
	local var_6_0 = {
		onUpdate = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
			local var_7_0 = arg_7_3.id
			local var_7_1 = RumbleSynergy:getSynergyName(var_7_0)
			local var_7_2 = RumbleSynergy:getSynergyIcon(var_7_0)
			
			if_set_sprite(arg_7_1, "n_icon", var_7_2)
			if_set(arg_7_1, "txt_synergy", T(var_7_1))
			
			for iter_7_0 = 1, 7 do
				local var_7_3 = arg_7_3[iter_7_0] and arg_7_3[iter_7_0].id
				
				if var_7_3 then
					local var_7_4 = RumbleUtil:getHeroIcon(var_7_3, {
						popup = true
					})
					
					if var_7_4 then
						local var_7_5 = arg_7_1:getChildByName("n_icon" .. iter_7_0)
						
						if get_cocos_refid(var_7_5) then
							var_7_5:addChild(var_7_4)
						end
					end
				end
			end
			
			local var_7_6 = arg_7_1:getChildByName("btn_synergy")
			
			if get_cocos_refid(var_7_6) then
				var_7_6.id = var_7_0
			end
			
			return arg_7_2
		end
	}
	local var_6_1 = load_control("wnd/rumble_info_card.csb")
	
	arg_6_0.vars.list_synergy:setRenderer(var_6_1, var_6_0)
	
	local var_6_2 = RumbleUtil:getSynergyList()
	
	arg_6_0.vars.list_synergy:removeAllChildren()
	arg_6_0.vars.list_synergy:setDataSource(var_6_2)
	arg_6_0.vars.list_synergy:jumpToTop()
end

function RumbleCollection.cache(arg_8_0)
	if not arg_8_0.vars then
		return 
	end
	
	arg_8_0.vars.tab_hero = arg_8_0.vars.wnd:getChildByName("tab1")
	arg_8_0.vars.tab_synergy = arg_8_0.vars.wnd:getChildByName("tab2")
	arg_8_0.vars.n_hero = arg_8_0.vars.wnd:getChildByName("n_hero")
	arg_8_0.vars.n_synergy = arg_8_0.vars.wnd:getChildByName("list_synergy")
end

function RumbleCollection.close(arg_9_0)
	if not arg_9_0.vars or not get_cocos_refid(arg_9_0.vars.wnd) then
		return 
	end
	
	BackButtonManager:pop("rumble_info")
	arg_9_0.vars.wnd:removeFromParent()
	
	arg_9_0.vars = nil
	arg_9_0.db = nil
end
