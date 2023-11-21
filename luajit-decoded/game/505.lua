CustomProfileCardText = {}

function HANDLER.text_color_plate(arg_1_0, arg_1_1)
	if string.starts(arg_1_1, "btn_") then
		local var_1_0 = string.len("btn_")
		local var_1_1 = string.sub(arg_1_1, var_1_0 + 1, -1)
		
		CustomProfileCardText:setTextColor(var_1_1)
	end
end

function CustomProfileCardText.create(arg_2_0, arg_2_1)
	arg_2_1 = arg_2_1 or {}
	arg_2_0.vars = {}
	arg_2_0.vars.text_tab = arg_2_1.n_tab
	arg_2_0.vars.text_wnd = arg_2_1.category_wnd
	arg_2_0.vars.text_plate = load_control("wnd/profile_custom_color_plate.csb")
	
	arg_2_0.vars.text_plate:setName("text_color_plate")
	arg_2_0:initDB()
	arg_2_0:initUI()
end

function CustomProfileCardText.release(arg_3_0)
	if not arg_3_0.vars or not get_cocos_refid(arg_3_0.vars.text_tab) or not get_cocos_refid(arg_3_0.vars.text_wnd) or not get_cocos_refid(arg_3_0.vars.text_plate) then
		return 
	end
	
	arg_3_0.vars.text_tab = nil
	arg_3_0.vars.text_wnd = nil
	
	arg_3_0.vars.text_plate:removeFromParent()
	
	arg_3_0.vars.text_plate = nil
	arg_3_0.vars = nil
end

function CustomProfileCardText.initDB(arg_4_0)
	if not arg_4_0.vars or not get_cocos_refid(arg_4_0.vars.text_plate) then
		return 
	end
	
	arg_4_0.vars.min_font_size = ProfileCardConfigData.min_text_size or 20
	arg_4_0.vars.max_font_size = ProfileCardConfigData.max_text_size or 80
	arg_4_0.vars.text_color_list = {}
	
	local var_4_0 = arg_4_0.vars.text_plate:getChildByName("n_plate")
	local var_4_1
	
	if get_cocos_refid(var_4_0) then
		var_4_1 = 1
		
		for iter_4_0, iter_4_1 in pairs(var_4_0:getChildren()) do
			if get_cocos_refid(iter_4_1) then
				local var_4_2 = iter_4_1:getChildByName("n_color_" .. var_4_1)
				
				if get_cocos_refid(iter_4_1) then
					local var_4_3 = var_4_2:getColor()
					
					table.insert(arg_4_0.vars.text_color_list, var_4_3)
					
					var_4_1 = var_4_1 + 1
				end
			end
		end
	end
	
	arg_4_0.vars.pre_data = {}
	arg_4_0.vars.pre_data.text_color = cc.c3b(88, 106, 139)
	arg_4_0.vars.pre_data.font_size = (arg_4_0.vars.min_font_size + arg_4_0.vars.max_font_size) * 0.5
	arg_4_0.vars.pre_data.text_opacity_rate = 100
	arg_4_0.vars.pre_data.is_bold = false
end

function CustomProfileCardText.initUI(arg_5_0)
	if not arg_5_0.vars or not get_cocos_refid(arg_5_0.vars.text_tab) or not get_cocos_refid(arg_5_0.vars.text_wnd) or not get_cocos_refid(arg_5_0.vars.text_plate) then
		return 
	end
	
	local var_5_0 = arg_5_0.vars.text_wnd:getChildByName("btn_message")
	
	if get_cocos_refid(var_5_0) then
		var_5_0:addTouchEventListener(function(arg_6_0, arg_6_1)
			if not get_cocos_refid(arg_6_0) then
				return 
			end
			
			if arg_6_1 == 0 or arg_6_1 == 1 then
				return 
			end
			
			arg_5_0:openTextInputPopup()
		end)
	end
	
	arg_5_0:setTextMessage("")
	
	local var_5_1 = arg_5_0.vars.text_wnd:getChildByName("n_plate")
	
	if get_cocos_refid(var_5_1) then
		var_5_1:addChild(arg_5_0.vars.text_plate)
		
		local var_5_2 = arg_5_0.vars.text_plate:getChildByName("n_plate")
		
		if get_cocos_refid(var_5_2) then
			for iter_5_0, iter_5_1 in pairs(var_5_2:getChildren()) do
				if get_cocos_refid(iter_5_1) then
					if_set_visible(iter_5_1, "n_select", false)
				end
			end
		end
	end
	
	arg_5_0.vars.font_size_slider = arg_5_0.vars.text_wnd:getChildByName("n_slider_1")
	
	local var_5_3 = arg_5_0.vars.font_size_slider:getChildByName("slider")
	
	if get_cocos_refid(var_5_3) then
		var_5_3:setTouchEnabled(true)
		var_5_3:addEventListener(Dialog.defaultSliderEventHandler)
		var_5_3:setPercent((arg_5_0.vars.max_font_size - arg_5_0.vars.min_font_size) * 0.5)
		var_5_3:setMaxPercent(arg_5_0.vars.max_font_size - arg_5_0.vars.min_font_size)
		
		var_5_3.min = 0
		var_5_3.max = arg_5_0.vars.max_font_size - arg_5_0.vars.min_font_size
		
		function var_5_3.handler(arg_7_0, arg_7_1, arg_7_2)
			if CustomProfileCardEditor:getCurrnetCatrgory() ~= "text" then
				return 
			end
			
			local var_7_0 = arg_7_1 + arg_5_0.vars.min_font_size
			local var_7_1 = CustomProfileCardEditor:getFocusLayer()
			
			if var_7_1 and var_7_1:getType() == "text" then
				if arg_7_2 == 0 then
					if not var_5_3.before then
						var_5_3.before = var_7_1:getFontSize()
					end
					
					if var_7_1:getFontSize() ~= var_7_0 then
						var_7_1:setFontSize(var_7_0)
					end
				elseif arg_7_2 == 1 then
					if not var_5_3.before then
						var_5_3.before = var_7_1:getFontSize()
					end
				else
					local var_7_2 = var_5_3.before
					local var_7_3 = var_7_0
					
					CustomProfileCardEditor:getLayerCommand():pushUndo({
						layer = var_7_1,
						undo_func = bind_func(var_7_1.setFontSize, var_7_1, var_7_2),
						redo_func = bind_func(var_7_1.setFontSize, var_7_1, var_7_3)
					}, true)
					
					var_5_3.before = nil
				end
			elseif arg_5_0.vars.pre_data then
				arg_5_0.vars.pre_data.font_size = var_7_0
			end
			
			if_set(arg_5_0.vars.font_size_slider, "txt_result", var_7_0)
		end
		
		if_set(arg_5_0.vars.font_size_slider, "txt_result", (arg_5_0.vars.max_font_size + arg_5_0.vars.min_font_size) * 0.5)
	end
	
	arg_5_0.vars.text_opacity_slider = arg_5_0.vars.text_wnd:getChildByName("n_slider_2")
	var_5_3 = arg_5_0.vars.text_opacity_slider:getChildByName("slider")
	
	if get_cocos_refid(var_5_3) then
		var_5_3:addEventListener(Dialog.defaultSliderEventHandler)
		var_5_3:setPercent(100)
		var_5_3:setMaxPercent(100)
		
		var_5_3.min = 0
		var_5_3.max = 100
		
		function var_5_3.handler(arg_8_0, arg_8_1, arg_8_2)
			if CustomProfileCardEditor:getCurrnetCatrgory() ~= "text" then
				return 
			end
			
			local var_8_0 = CustomProfileCardEditor:getFocusLayer()
			
			if var_8_0 and var_8_0:getType() == "text" then
				if arg_8_2 == 0 then
					if not var_5_3.before then
						var_5_3.before = var_8_0:getOpacityRate()
					end
					
					if var_8_0:getOpacityRate() ~= arg_8_1 then
						var_8_0:setOpacityRate(arg_8_1)
					end
				elseif arg_8_2 == 1 then
					if not var_5_3.before then
						var_5_3.before = var_8_0:getOpacityRate()
					end
				else
					local var_8_1 = var_5_3.before
					local var_8_2 = arg_8_1
					
					CustomProfileCardEditor:getLayerCommand():pushUndo({
						layer = var_8_0,
						undo_func = bind_func(var_8_0.setOpacityRate, var_8_0, var_8_1),
						redo_func = bind_func(var_8_0.setOpacityRate, var_8_0, var_8_2)
					}, true)
					
					var_5_3.before = nil
				end
			elseif arg_5_0.vars.pre_data then
				arg_5_0.vars.pre_data.text_opacity_rate = arg_8_1
			end
			
			if_set(arg_5_0.vars.text_opacity_slider, "txt_result", arg_8_1)
		end
		
		if_set(arg_5_0.vars.text_opacity_slider, "txt_result", 100)
	end
	
	local var_5_4 = arg_5_0.vars.text_wnd:getChildByName("n_bold")
	
	if get_cocos_refid(var_5_4) then
		for iter_5_2, iter_5_3 in pairs(var_5_4:getChildren()) do
			if get_cocos_refid(iter_5_3) and tolua.type(iter_5_3) == "ccui.Button" then
				iter_5_3:addTouchEventListener(function(arg_9_0, arg_9_1)
					if not get_cocos_refid(arg_9_0) then
						return 
					end
					
					if arg_9_1 == 0 or arg_9_1 == 1 then
						return 
					end
					
					local var_9_0 = arg_9_0:getName()
					local var_9_1 = string.len("btn_toggle_box")
					local var_9_2 = string.sub(var_9_0, var_9_1 + 1, -1)
					local var_9_3 = true
					
					if var_9_2 == "_active" then
						var_9_3 = false
					end
					
					arg_5_0:setBold(var_9_3)
				end)
			end
		end
		
		if_set_visible(var_5_4, "btn_toggle_box", true)
		if_set_visible(var_5_4, "btn_toggle_box_active", false)
	end
end

function CustomProfileCardText.resetPreData(arg_10_0)
	if not arg_10_0.vars or not arg_10_0.vars.pre_data then
		return 
	end
	
	arg_10_0.vars.pre_data.text_color = cc.c3b(88, 106, 139)
	arg_10_0.vars.pre_data.font_size = (arg_10_0.vars.min_font_size + arg_10_0.vars.max_font_size) * 0.5
	arg_10_0.vars.pre_data.text_opacity_rate = 100
	arg_10_0.vars.pre_data.is_bold = false
end

function CustomProfileCardText.resetUI(arg_11_0)
	if not arg_11_0.vars or not get_cocos_refid(arg_11_0.vars.text_tab) or not get_cocos_refid(arg_11_0.vars.text_wnd) or not get_cocos_refid(arg_11_0.vars.text_plate) then
		return 
	end
	
	if not get_cocos_refid(arg_11_0.vars.font_size_slider) or not get_cocos_refid(arg_11_0.vars.text_opacity_slider) then
		return 
	end
	
	if_set_visible(arg_11_0.vars.text_tab, "bg_tab", false)
	if_set_visible(arg_11_0.vars.text_wnd, nil, false)
	arg_11_0:resetPreData()
	arg_11_0:setTextMessage("")
	
	local var_11_0 = arg_11_0.vars.text_plate:getChildByName("n_plate")
	
	if get_cocos_refid(var_11_0) then
		for iter_11_0, iter_11_1 in pairs(var_11_0:getChildren()) do
			if get_cocos_refid(iter_11_1) then
				if_set_visible(iter_11_1, "n_select", false)
			end
		end
	end
	
	local var_11_1 = arg_11_0.vars.font_size_slider:getChildByName("slider")
	
	if get_cocos_refid(var_11_1) then
		var_11_1:addEventListener(function()
		end)
		var_11_1:setPercent((arg_11_0.vars.max_font_size - arg_11_0.vars.min_font_size) * 0.5)
		
		var_11_1.before = nil
		
		if_set(arg_11_0.vars.font_size_slider, "txt_result", (arg_11_0.vars.max_font_size + arg_11_0.vars.min_font_size) * 0.5)
	end
	
	local var_11_2 = arg_11_0.vars.text_opacity_slider:getChildByName("slider")
	
	if get_cocos_refid(var_11_2) then
		var_11_2:addEventListener(function()
		end)
		var_11_2:setPercent(100)
		
		var_11_2.before = nil
		
		if_set(arg_11_0.vars.text_opacity_slider, "txt_result", 100)
	end
	
	local var_11_3 = arg_11_0.vars.text_wnd:getChildByName("n_bold")
	
	if get_cocos_refid(var_11_3) then
		if_set_visible(var_11_3, "btn_toggle_box", true)
		if_set_visible(var_11_3, "btn_toggle_box_active", false)
	end
	
	if_set_opacity(arg_11_0.vars.text_wnd, "btn_copy", 76.5)
end

function CustomProfileCardText.setUI(arg_14_0)
	if not arg_14_0.vars or not get_cocos_refid(arg_14_0.vars.text_tab) or not get_cocos_refid(arg_14_0.vars.text_wnd) or not get_cocos_refid(arg_14_0.vars.text_plate) then
		return 
	end
	
	if not get_cocos_refid(arg_14_0.vars.font_size_slider) or not get_cocos_refid(arg_14_0.vars.text_opacity_slider) then
		return 
	end
	
	if_set_visible(arg_14_0.vars.text_tab, "bg_tab", true)
	if_set_visible(arg_14_0.vars.text_wnd, nil, true)
	
	local var_14_0 = CustomProfileCardEditor:getFocusLayer()
	
	if var_14_0 and var_14_0:getType() == "text" then
		local var_14_1 = var_14_0:getText()
		
		arg_14_0:setTextMessage(var_14_1)
		
		local var_14_2 = var_14_0:getFontColor()
		local var_14_3 = arg_14_0:getColorID(var_14_2)
		
		if var_14_3 ~= nil then
			local var_14_4 = arg_14_0.vars.text_plate:getChildByName("n_plate")
			
			if get_cocos_refid(var_14_4) then
				local var_14_5 = var_14_4:getChildByName("n_" .. var_14_3)
				
				if get_cocos_refid(var_14_5) then
					if_set_visible(var_14_5, "n_select", true)
				end
			end
		end
		
		local var_14_6 = var_14_0:getFontSize()
		
		if var_14_6 then
			if_set(arg_14_0.vars.font_size_slider, "txt_result", var_14_6)
			
			var_14_6 = var_14_6 - arg_14_0.vars.min_font_size
		end
		
		local var_14_7 = arg_14_0.vars.font_size_slider:getChildByName("slider")
		
		if get_cocos_refid(var_14_7) then
			var_14_7:setPercent(var_14_6)
			var_14_7:addEventListener(Dialog.defaultSliderEventHandler)
		end
		
		local var_14_8 = var_14_0:getOpacityRate()
		local var_14_9 = arg_14_0.vars.text_opacity_slider:getChildByName("slider")
		
		if get_cocos_refid(var_14_9) then
			var_14_9:setPercent(var_14_8)
			var_14_9:addEventListener(Dialog.defaultSliderEventHandler)
			if_set(arg_14_0.vars.text_opacity_slider, "txt_result", var_14_8)
		end
		
		local var_14_10 = var_14_0:isBlod()
		
		if var_14_10 ~= nil then
			local var_14_11 = arg_14_0.vars.text_wnd:getChildByName("n_bold")
			
			if get_cocos_refid(var_14_11) then
				if_set_visible(var_14_11, "btn_toggle_box", not var_14_10)
				if_set_visible(var_14_11, "btn_toggle_box_active", var_14_10)
			end
		end
		
		if_set_opacity(arg_14_0.vars.text_wnd, "btn_copy", 255)
	else
		arg_14_0:setTextMessage("")
		
		local var_14_12 = arg_14_0:getColorID(cc.c3b(88, 106, 139))
		
		if var_14_12 ~= nil then
			local var_14_13 = arg_14_0.vars.text_plate:getChildByName("n_plate")
			
			if get_cocos_refid(var_14_13) then
				local var_14_14 = var_14_13:getChildByName("n_" .. var_14_12)
				
				if get_cocos_refid(var_14_14) then
					if_set_visible(var_14_14, "n_select", true)
				end
			end
		end
		
		local var_14_15 = arg_14_0.vars.font_size_slider:getChildByName("slider")
		
		if get_cocos_refid(var_14_15) then
			var_14_15:setPercent((arg_14_0.vars.max_font_size - arg_14_0.vars.min_font_size) * 0.5)
			var_14_15:addEventListener(Dialog.defaultSliderEventHandler)
			if_set(arg_14_0.vars.font_size_slider, "txt_result", (arg_14_0.vars.max_font_size + arg_14_0.vars.min_font_size) * 0.5)
		end
		
		local var_14_16 = arg_14_0.vars.text_opacity_slider:getChildByName("slider")
		
		if get_cocos_refid(var_14_16) then
			var_14_16:setPercent(100)
			var_14_16:addEventListener(Dialog.defaultSliderEventHandler)
			if_set(arg_14_0.vars.text_opacity_slider, "txt_result", 100)
		end
		
		local var_14_17 = arg_14_0.vars.text_wnd:getChildByName("n_bold")
		
		if get_cocos_refid(var_14_17) then
			if_set_visible(var_14_17, "btn_toggle_box", true)
			if_set_visible(var_14_17, "btn_toggle_box_active", false)
		end
		
		if_set_opacity(arg_14_0.vars.text_wnd, "btn_copy", 76.5)
	end
end

function CustomProfileCardText.openTextInputPopup(arg_15_0)
	if not arg_15_0.vars or not get_cocos_refid(arg_15_0.vars.text_wnd) or not arg_15_0.vars.text_wnd:isVisible() then
		return 
	end
	
	local function var_15_0()
		local var_16_0 = arg_15_0.vars.text_info.text
		local var_16_1 = string.trim(var_16_0)
		
		if var_16_1 == nil or utf8len(var_16_1) < 1 then
			balloon_message_with_sound("msg_profile_card_text_need_word")
			
			return 
		end
		
		if check_abuse_filter(var_16_1, ABUSE_FILTER.CHAT) or check_abuse_filter(var_16_1, ABUSE_FILTER.NAME) then
			balloon_message_with_sound("invalid_input_word")
			
			return 
		end
		
		local var_16_2 = CustomProfileCardEditor:getFocusLayer()
		
		if var_16_2 and var_16_2:getType() == "text" then
			var_16_2:setText(var_16_1)
			
			if var_16_2.sync_layer_view_callback and type(var_16_2.sync_layer_view_callback) == "function" then
				var_16_2:sync_layer_view_callback()
			end
		elseif arg_15_0.vars.pre_data then
			CustomProfileCardEditor:createLayer({
				type = "text",
				text = var_16_1,
				text_color = arg_15_0.vars.pre_data.text_color,
				font_size = arg_15_0.vars.pre_data.font_size,
				text_opacity_rate = arg_15_0.vars.pre_data.text_opacity_rate,
				is_bold = arg_15_0.vars.pre_data.is_bold
			})
		end
		
		arg_15_0:setTextMessage(var_16_1)
		
		arg_15_0.vars.text_info = {}
	end
	
	arg_15_0.vars.text_info = {}
	arg_15_0.vars.text_info.prev_text = ""
	
	local var_15_1 = CustomProfileCardEditor:getFocusLayer()
	
	if var_15_1 and var_15_1:getType() == "text" then
		arg_15_0.vars.text_info.prev_text = var_15_1:getText()
	end
	
	local var_15_2 = Dialog:openInputBox(arg_15_0, var_15_0, {
		max_limit = 15,
		title = T("ui_profile_text_input"),
		info = arg_15_0.vars.text_info
	})
	local var_15_3 = var_15_2:getChildByName("btn_yes")
	
	if_set(var_15_3, "label", T("ui_msgbox_ok"))
	
	local var_15_4 = CustomProfileCardEditor:getWnd()
	
	if get_cocos_refid(var_15_4) then
		var_15_4:addChild(var_15_2)
	end
end

function CustomProfileCardText.setTextMessage(arg_17_0, arg_17_1)
	if not arg_17_0.vars or not get_cocos_refid(arg_17_0.vars.text_wnd) then
		return 
	end
	
	local var_17_0 = arg_17_0.vars.text_wnd:getChildByName("btn_message")
	
	if get_cocos_refid(var_17_0) then
		local var_17_1 = var_17_0:getChildByName("txt_message")
		
		if get_cocos_refid(var_17_1) then
			if_set(var_17_1, nil, arg_17_1)
			UIUtil:updateTextWrapMode(var_17_1, arg_17_1, 20)
		end
	end
end

function CustomProfileCardText.setFontSizeSlider(arg_18_0, arg_18_1)
	if not arg_18_0.vars or not get_cocos_refid(arg_18_0.vars.font_size_slider) then
		return 
	end
	
	if not arg_18_1 or type(arg_18_1) ~= "number" then
		return 
	end
	
	local var_18_0 = arg_18_0.vars.font_size_slider:getChildByName("slider")
	
	if get_cocos_refid(var_18_0) then
		arg_18_1 = arg_18_1 - arg_18_0.vars.min_font_size
		
		var_18_0:setPercent(arg_18_1)
	end
end

function CustomProfileCardText.getColorID(arg_19_0, arg_19_1)
	if not arg_19_0.vars or not get_cocos_refid(arg_19_0.vars.text_plate) or table.empty(arg_19_0.vars.text_color_list) or table.empty(arg_19_1) then
		return nil
	end
	
	for iter_19_0, iter_19_1 in pairs(arg_19_0.vars.text_color_list) do
		local var_19_0 = true
		
		if arg_19_1.r and iter_19_1.r and arg_19_1.r ~= iter_19_1.r then
			var_19_0 = false
		end
		
		if arg_19_1.g and iter_19_1.g and arg_19_1.g ~= iter_19_1.g then
			var_19_0 = false
		end
		
		if arg_19_1.b and iter_19_1.b and arg_19_1.b ~= iter_19_1.b then
			var_19_0 = false
		end
		
		if var_19_0 then
			return iter_19_0
		end
	end
	
	return nil
end

function CustomProfileCardText.setTextColor(arg_20_0, arg_20_1)
	if not arg_20_0.vars or not get_cocos_refid(arg_20_0.vars.text_plate) then
		return 
	end
	
	if table.empty(arg_20_0.vars.text_color_list) or not arg_20_1 then
		return 
	end
	
	local var_20_0 = arg_20_0.vars.text_color_list[tonumber(arg_20_1)]
	
	if table.empty(var_20_0) then
		return 
	end
	
	local var_20_1 = CustomProfileCardEditor:getFocusLayer()
	
	if var_20_1 and var_20_1:getType() == "text" then
		var_20_1:setColor(var_20_0)
		
		if var_20_1.sync_layer_view_callback and type(var_20_1.sync_layer_view_callback) == "function" then
			var_20_1:sync_layer_view_callback()
		end
	elseif arg_20_0.vars.pre_data then
		arg_20_0.vars.pre_data.text_color = var_20_0
	end
	
	local var_20_2 = arg_20_0.vars.text_plate:getChildByName("n_plate")
	
	if get_cocos_refid(var_20_2) then
		for iter_20_0, iter_20_1 in pairs(var_20_2:getChildren()) do
			if get_cocos_refid(iter_20_1) then
				if_set_visible(iter_20_1, "n_select", false)
			end
		end
	end
	
	local var_20_3 = var_20_2:getChildByName("n_" .. arg_20_1)
	
	if get_cocos_refid(var_20_3) then
		if_set_visible(var_20_3, "n_select", true)
	end
end

function CustomProfileCardText.setBold(arg_21_0, arg_21_1)
	if not arg_21_0.vars or not get_cocos_refid(arg_21_0.vars.text_wnd) then
		return 
	end
	
	local var_21_0 = CustomProfileCardEditor:getFocusLayer()
	
	if var_21_0 and var_21_0:getType() == "text" then
		var_21_0:setBold(arg_21_1)
		
		if var_21_0.sync_layer_view_callback and type(var_21_0.sync_layer_view_callback) == "function" then
			var_21_0:sync_layer_view_callback()
		end
	elseif arg_21_0.vars.pre_data then
		arg_21_0.vars.pre_data.is_bold = arg_21_1
	end
	
	local var_21_1 = arg_21_0.vars.text_wnd:getChildByName("n_bold")
	
	if get_cocos_refid(var_21_1) then
		if_set_visible(var_21_1, "btn_toggle_box", not arg_21_1)
		if_set_visible(var_21_1, "btn_toggle_box_active", arg_21_1)
	end
end
