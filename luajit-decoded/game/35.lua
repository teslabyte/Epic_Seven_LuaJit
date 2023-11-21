Dialog = {}
Dialog.List = {}
Dialog.Hash = {}
Dialog.MsgBoxHandlers = {}

local var_0_0 = 105

function Dialog.defaultSliderEventHandler(arg_1_0, arg_1_1)
	if arg_1_0.min and arg_1_0:getPercent() < arg_1_0.min then
		arg_1_0:setPercent(arg_1_0.min)
	end
	
	if arg_1_0.max and arg_1_0:getPercent() > arg_1_0.max then
		arg_1_0:setPercent(arg_1_0.max)
	end
	
	if arg_1_0.handler then
		set_high_fps_tick()
		arg_1_0.handler(arg_1_0.parent or getParentWindow(arg_1_0), arg_1_0:getPercent(), arg_1_1)
	end
end

function Dialog.load(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	local var_2_0 = load_dlg(arg_2_1, true, arg_2_4)
	
	if arg_2_2 then
		var_2_0:setScale(arg_2_2)
	else
		var_2_0:setScale(WIDGET_SCALE_FACTOR)
	end
	
	return var_2_0
end

function Dialog.setModal(arg_3_0, arg_3_1)
	local var_3_0 = ccui.Button:create()
	local var_3_1 = arg_3_1:getContentSize()
	
	var_3_0:setTouchEnabled(true)
	var_3_0:ignoreContentAdaptWithSize(false)
	var_3_0:setContentSize(4096, 3072)
	var_3_0:setPosition(var_3_1.width / 2, var_3_1.height / 2)
	var_3_0:setLocalZOrder(-1)
	arg_3_1:addChild(var_3_0)
	arg_3_1:sortAllChildren()
end

function Dialog.setBack(arg_4_0, arg_4_1)
	local var_4_0 = cc.LayerColor:create(cc.c4b(0, 0, 0, 180))
	
	var_4_0:setScale(4)
	var_4_0:setLocalZOrder(-1)
	arg_4_1:addChild(var_4_0)
	arg_4_1:sortAllChildren()
end

function Dialog.addButton(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = ccui.Button:create()
	
	var_5_0:setTouchEnabled(true)
	var_5_0:ignoreContentAdaptWithSize(false)
	var_5_0:setContentSize(arg_5_2.width, arg_5_2.height)
	var_5_0:setPosition(arg_5_2.x, arg_5_2.y)
	var_5_0:setName(arg_5_3)
	onCreateNode(var_5_0)
	arg_5_1:addChild(var_5_0)
end

function Dialog.find(arg_6_0, arg_6_1)
	for iter_6_0, iter_6_1 in pairs(arg_6_0.List) do
		if iter_6_1.name == arg_6_1 then
			return iter_6_1
		end
	end
end

function Dialog.open(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = arg_7_3
	
	if type(var_7_0) ~= "table" then
		var_7_0 = {
			modal = arg_7_3,
			sub = arg_7_4
		}
	end
	
	local var_7_1
	
	if type(arg_7_1) == "string" and string.find(arg_7_1, "/") then
		local var_7_2 = string.split(arg_7_1, "/")
		
		var_7_1 = var_7_2[1]
		arg_7_1 = var_7_2[2]
	end
	
	local var_7_3 = arg_7_1
	local var_7_4 = arg_7_1
	
	if type(arg_7_1) == "table" then
		var_7_3 = arg_7_1[1]
		var_7_4 = arg_7_1[2]
	end
	
	local var_7_5 = arg_7_0:load(var_7_3, var_7_0.scale, var_7_0.sub, var_7_1)
	
	if var_7_0.use_backbutton == nil then
		var_7_0.use_backbutton = true
	end
	
	if var_7_0.back_func then
		var_7_0.use_backbutton = true
		var_7_5.back_func = var_7_0.back_func
	end
	
	if var_7_0.use_backbutton then
		var_7_5.use_backbutton = true
		
		local var_7_6 = var_7_5.back_func and var_7_5.back_func or function()
			Dialog:close(var_7_4)
		end
		
		BackButtonManager:push({
			back_func = var_7_6,
			dlg = var_7_5,
			check_id = "Dialog." .. var_7_4
		})
	end
	
	if var_7_0.modal then
		arg_7_0:setModal(var_7_5)
	end
	
	if var_7_0.back then
		arg_7_0:setBack(var_7_5)
	end
	
	local var_7_7 = {
		dlg = var_7_5,
		name = var_7_4,
		handler = arg_7_2,
		modal = var_7_0.modal,
		sub = var_7_0.sub,
		full = var_7_0.full
	}
	
	if not var_7_0.sub then
		table.insert(arg_7_0.List, var_7_7)
	end
	
	arg_7_0.Hash[var_7_4] = var_7_7
	
	if var_7_0.full and #arg_7_0.List > 1 and arg_7_0.List[#arg_7_0.List - 1] then
		arg_7_0.List[#arg_7_0.List - 1].dlg:setVisible(false)
	end
	
	if var_7_4 ~= var_7_3 then
		var_7_5:setName(var_7_4)
	end
	
	return var_7_5
end

function Dialog.getCurrentDialogHandler(arg_9_0)
	for iter_9_0 = #arg_9_0.List, 1, -1 do
		if arg_9_0.List[iter_9_0].handler and arg_9_0.List[iter_9_0].dlg:isVisible() then
			return arg_9_0.List[iter_9_0].handler
		end
	end
	
	return nil
end

function Dialog.closeAll(arg_10_0)
	local var_10_0 = {}
	
	for iter_10_0 = #arg_10_0.List, 1, -1 do
		var_10_0[#var_10_0 + 1] = arg_10_0.List[iter_10_0].name
	end
	
	for iter_10_1, iter_10_2 in pairs(var_10_0) do
		arg_10_0:close(iter_10_2)
	end
	
	for iter_10_3, iter_10_4 in pairs(Dialog.MsgBoxHandlers) do
		if get_cocos_refid(iter_10_3) then
			local var_10_1
			local var_10_2 = arg_10_0.MsgBoxHandlers[iter_10_3] and type(arg_10_0.MsgBoxHandlers[iter_10_3].cancel_handler) == "function" and "btn_cancel" or "btn_default"
			
			xpcall(arg_10_0.msgBoxUIHandler, __G__TRACKBACK__, arg_10_0, iter_10_3, var_10_2)
		end
		
		if get_cocos_refid(iter_10_3) then
			iter_10_3:removeFromParent()
		end
	end
	
	BackButtonManager:clear("^Dialog.*")
	
	Dialog.MsgBoxHandlers = {}
end

function Dialog.removeCurrentDialog(arg_11_0, arg_11_1)
	for iter_11_0 = #arg_11_0.List, 1, -1 do
		local var_11_0 = arg_11_0.List[iter_11_0]
		
		if arg_11_1 == true or var_11_0.name == arg_11_1 or var_11_0.dlg == arg_11_1 then
			if iter_11_0 > 1 and get_cocos_refid(arg_11_0.List[iter_11_0 - 1].dlg) then
				arg_11_0.List[iter_11_0 - 1].dlg:setVisible(true)
			end
			
			table.remove(arg_11_0.List, iter_11_0)
			
			break
		end
	end
end

function Dialog.closeInBackFunc(arg_12_0, arg_12_1)
	set_high_fps_tick()
	arg_12_0:removeCurrentDialog(arg_12_1)
	
	local var_12_0 = arg_12_0.Hash[arg_12_1]
	
	if not var_12_0 then
		return 
	end
	
	arg_12_0.Hash[arg_12_1] = nil
	
	if get_cocos_refid(var_12_0.dlg) then
		var_12_0.dlg:removeFromParent()
	end
end

function Dialog.close(arg_13_0, arg_13_1, arg_13_2)
	set_high_fps_tick()
	arg_13_0:removeCurrentDialog(arg_13_1)
	
	local var_13_0 = arg_13_0.Hash[arg_13_1]
	
	if not var_13_0 then
		return 
	end
	
	arg_13_0.Hash[arg_13_1] = nil
	
	if var_13_0.handler and var_13_0.handler.onCloseChildDialog then
		var_13_0.handler:onCloseChildDialog(var_13_0.name, var_13_0.dlg)
	end
	
	if var_13_0.dlg.use_backbutton then
		if var_13_0.dlg.back_func then
			var_13_0.dlg.back_func()
			
			var_13_0.dlg.back_func = nil
		else
			BackButtonManager:pop({
				check_id = "Dialog." .. arg_13_1,
				dlg = var_13_0.dlg
			})
		end
	end
	
	if arg_13_2 then
		close_dlg(var_13_0.dlg)
	elseif get_cocos_refid(var_13_0.dlg) then
		var_13_0.dlg:removeFromParent()
	end
end

function Dialog.onTouchDown(arg_14_0, arg_14_1, arg_14_2)
	set_high_fps_tick()
	
	if UIAction:Find("block") then
		return false
	end
	
	for iter_14_0 = #arg_14_0.List, 1, -1 do
		local var_14_0 = arg_14_0.List[iter_14_0]
		
		if var_14_0.dlg:isVisible() and (containsPoint(var_14_0.dlg:getBoundingBox(), arg_14_1, arg_14_2) or var_14_0.modal) then
			arg_14_0.touched = true
			arg_14_0.touchedDialog = var_14_0
			
			if var_14_0.handler and var_14_0.handler.onDialogTouchDown then
				var_14_0.handler:onDialogTouchDown(var_14_0.name, arg_14_1, arg_14_2)
			end
			
			return true
		end
	end
end

function Dialog.onTouchUp(arg_15_0, arg_15_1, arg_15_2)
	if UIAction:Find("block") then
		return false
	end
	
	if not arg_15_0.touched then
		return false
	end
	
	local var_15_0 = arg_15_0.touchedDialog
	
	if var_15_0 and var_15_0.handler and var_15_0.handler.onDialogTouchUp then
		var_15_0.handler:onDialogTouchUp(arg_15_1, arg_15_2)
	end
	
	arg_15_0.touched = false
	
	return true
end

function Dialog.onTouchMove(arg_16_0, arg_16_1, arg_16_2)
	if UIAction:Find("block") then
		return false
	end
	
	if not arg_16_0.touched then
		return false
	end
	
	for iter_16_0 = #arg_16_0.List, 1, -1 do
		local var_16_0 = arg_16_0.List[iter_16_0]
		
		if var_16_0.dlg:isVisible() and (containsPoint(var_16_0.dlg:getBoundingBox(), arg_16_1, arg_16_2) or var_16_0.modal) then
			arg_16_0.touched = true
			arg_16_0.touchedDialog = var_16_0
			
			if var_16_0.handler and var_16_0.handler.onDialogTouchMove then
				var_16_0.handler:onDialogTouchMove(var_16_0.name, arg_16_1, arg_16_2)
			end
			
			return true
		end
	end
	
	return true
end

function HANDLER.msgbox(arg_17_0, arg_17_1, arg_17_2)
	set_high_fps_tick()
	
	local var_17_0 = getParentWindow(arg_17_0)
	
	Dialog:msgBoxUIHandler(var_17_0, arg_17_1, arg_17_0)
end

function Dialog.getMsgBoxHandlerCount(arg_18_0)
	return table.count(arg_18_0.MsgBoxHandlers)
end

function Dialog.ForcedCloseMsgBoxByTag(arg_19_0, arg_19_1)
	if not arg_19_1 then
		return 
	end
	
	local var_19_0 = Dialog:findMsgBox(arg_19_1)
	
	if get_cocos_refid(var_19_0) then
		Dialog:msgBoxUIHandler(var_19_0, "btn_cancel")
	end
end

function Dialog.forced_closeMsgbox(arg_20_0)
	local var_20_0
	local var_20_1 = SceneManager:getRunningRootScene()
	
	if get_cocos_refid(var_20_1) then
		local var_20_2 = var_20_1:findChildByName("msgbox")
		
		if get_cocos_refid(var_20_2) then
			Dialog:msgBoxUIHandler(var_20_2, "btn_cancel")
		end
	end
end

function Dialog.msgBoxUIHandler(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	local var_21_0
	local var_21_1
	local var_21_2
	
	if arg_21_0.MsgBoxHandlers[arg_21_1] then
		var_21_0 = arg_21_0.MsgBoxHandlers[arg_21_1].arg
	end
	
	if arg_21_2 == "btn_plus" then
		arg_21_1.slider:setPercent(arg_21_1.slider:getPercent() + 1)
		arg_21_0.defaultSliderEventHandler(arg_21_1.slider, 2)
		
		return 
	elseif arg_21_2 == "btn_minus" then
		local var_21_3 = math.max(0, to_n(arg_21_1.slider.min))
		
		arg_21_1.slider:setPercent(math.max(var_21_3, arg_21_1.slider:getPercent() - 1))
		arg_21_0.defaultSliderEventHandler(arg_21_1.slider, 2)
		
		return 
	elseif arg_21_2 == "btn_cancel" and arg_21_0.MsgBoxHandlers[arg_21_1] then
		local var_21_4 = arg_21_0.MsgBoxHandlers[arg_21_1].cancel_handler
		
		if var_21_4 and type(handler) == "function" then
			var_21_4(arg_21_1, arg_21_2, var_21_0)
		end
	end
	
	if arg_21_2 == "btn_ignore" then
		return 
	end
	
	if not arg_21_0.MsgBoxHandlers[arg_21_1] then
		return 
	end
	
	arg_21_1.opts = arg_21_1.opts or {}
	
	if arg_21_2 == "btn_default" and not arg_21_1.opts.yesno or arg_21_2 ~= "btn_default" and arg_21_2 ~= "btn_cancel" then
		local var_21_5 = arg_21_0.MsgBoxHandlers[arg_21_1].handler
		
		if var_21_5 and type(var_21_5) == "function" then
			local var_21_6 = var_21_5(arg_21_1, arg_21_2, var_21_0, arg_21_3)
			
			if var_21_6 == "dont_close" then
				var_21_1 = true
			elseif var_21_6 == "skip_animation" then
				var_21_2 = true
			end
		end
	end
	
	if get_cocos_refid(arg_21_1) and var_21_0 ~= "dont_close" and var_21_1 ~= true and (arg_21_1.opts.yesno == false or arg_21_2 ~= "btn_default") then
		BackButtonManager:pop({
			id = "Dialog." .. arg_21_2,
			dlg = arg_21_1
		})
	end
	
	if not get_cocos_refid(arg_21_1) then
		return 
	end
	
	if arg_21_2 == "btn_default" and arg_21_1.opts.yesno then
		return 
	end
	
	if var_21_0 == "dont_close" then
		var_21_1 = true
	end
	
	if var_21_1 then
		return 
	end
	
	if arg_21_2 == "btn_default" and not arg_21_1.opts.yesno and not arg_21_0.no_back_button then
		BackButtonManager:pop({
			id = "Dialog." .. arg_21_2,
			dlg = arg_21_1
		})
	end
	
	if var_21_2 then
		arg_21_1:removeFromParent()
	else
		UIAction:Add(SEQ(FADE_OUT(150), REMOVE()), arg_21_1, "block")
	end
	
	arg_21_0.MsgBoxHandlers[arg_21_1] = nil
end

function HANDLER._z_input(arg_22_0, arg_22_1, arg_22_2)
	if arg_22_1 == "btn_cancel" then
		Dialog:close("_z_input")
	end
	
	if arg_22_1 == "btn_delete" and LotaMemoInputView and LotaMemoInputView:isActive() then
		LotaMemoInputView:requestDeleteMemo()
	end
	
	if arg_22_1 == "btn_yes" then
		arg_22_0.info.text = arg_22_0.wnd:getChildByName("txt_input"):getString()
		
		if arg_22_0.callback() == "dont_close" then
			return 
		end
		
		Dialog:close("_z_input")
	end
	
	if arg_22_1 == "btn_checkbox" and arg_22_0.share_checkbox_callback then
		arg_22_0:share_checkbox_callback()
		
		if arg_22_0.toggle_checkbox then
			arg_22_0:toggle_checkbox()
		end
	end
end

function Dialog.openInputBox(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	arg_23_3 = arg_23_3 or {}
	
	local var_23_0 = arg_23_0:open("wnd/_z_input", arg_23_1, arg_23_3)
	local var_23_1 = var_23_0:getChildByName("btn_yes")
	local var_23_2 = arg_23_3.title or T("input_default_title")
	local var_23_3 = arg_23_3.custom_txt_input_limit or "input_default_limit"
	local var_23_4 = arg_23_3.max_limit or 16
	local var_23_5 = T(var_23_3, {
		limit = var_23_4
	})
	local var_23_6 = arg_23_3.info or {}
	
	if_set(var_23_0, "title", var_23_2)
	
	local var_23_7 = var_23_0:getChildByName("txt_input_number")
	
	if_set(var_23_7, nil, var_23_5)
	var_23_0:getChildByName("txt_input"):setMaxLength(var_23_4)
	
	local var_23_8 = var_23_0:getChildByName("frame")
	local var_23_9 = var_23_8:getChildByName("n_top")
	
	var_23_9:getChildByName("txt_input"):setTextColor(cc.c3b(107, 101, 27))
	var_23_9:getChildByName("txt_input"):setCursorEnabled(true)
	
	if arg_23_3.placeholder then
		var_23_9:getChildByName("txt_input"):setPlaceHolder(arg_23_3.placeholder)
	end
	
	if_set(var_23_0, "txt_input", var_23_6.prev_text or T("input_default_text"))
	if_set(var_23_1, "label", arg_23_3.btn_yes_txt or var_23_1:getChildByName("label"):getString())
	
	var_23_1.callback = arg_23_2
	var_23_1.info = var_23_6
	var_23_1.wnd = var_23_0
	
	if arg_23_3.use_share_unit then
		local var_23_10 = var_23_0:getChildByName("btn_checkbox")
		
		if get_cocos_refid(var_23_10) then
			var_23_10:setVisible(true)
			
			var_23_10.share_checkbox_callback = arg_23_3.share_checkbox_callback
			
			local var_23_11 = var_23_10:getChildByName("check_box")
			
			var_23_11:setSelected(false)
			var_23_11:addEventListener(arg_23_3.share_checkbox_callback)
			
			function var_23_10.toggle_checkbox()
				var_23_11:setSelected(not var_23_11:isSelected())
			end
		end
		
		if not var_23_9.move_pos then
			var_23_9:setPositionY(var_23_9:getPositionY() + 34)
			
			var_23_9.move_pos = true
			
			var_23_7:setTextColor(tocolor("#666666"))
			
			local var_23_12 = var_23_8:getContentSize()
			
			var_23_8:setContentSize(var_23_12.width, var_23_12.height + 34)
		end
	end
	
	return var_23_0
end

function Dialog.isExistMsgHandler(arg_25_0)
	for iter_25_0, iter_25_1 in pairs(arg_25_0.MsgBoxHandlers or {}) do
		if get_cocos_refid(iter_25_0) then
			return true
		end
	end
	
	return false
end

function Dialog.findMsgBox(arg_26_0, arg_26_1)
	for iter_26_0, iter_26_1 in pairs(arg_26_0.MsgBoxHandlers or {}) do
		if iter_26_1.tag == arg_26_1 then
			return iter_26_0
		end
	end
end

function Dialog.msgBox(arg_27_0, arg_27_1, arg_27_2)
	set_high_fps_tick()
	
	arg_27_1 = arg_27_1 or ""
	
	if type(arg_27_1) ~= "string" then
		arg_27_2 = arg_27_1
		arg_27_1 = ""
	end
	
	arg_27_2 = arg_27_2 or {}
	
	local var_27_0 = arg_27_2.fade_in or 100
	local var_27_1 = arg_27_2.delay or 0
	
	if type(arg_27_2) == "function" then
		arg_27_2 = {
			handler = arg_27_2
		}
	end
	
	local var_27_2 = arg_27_2.parent or SceneManager:getRunningPopupScene() or SceneManager:getAlertLayer()
	local var_27_3 = arg_27_2.dlg
	local var_27_4
	
	if not var_27_3 then
		var_27_3 = load_dlg(arg_27_2.csb or "msgbox", true, "wnd")
		var_27_4 = true
		
		var_27_3.c.dim_msgbox:setContentSize({
			width = 4096,
			height = 3072
		})
	end
	
	var_27_3.opts = arg_27_2
	
	if arg_27_2.dlg then
		arg_27_2.dlg:setName("msgbox")
	end
	
	local var_27_5 = 0
	local var_27_6
	local var_27_7 = var_27_3:getChildByName("n_title")
	
	if arg_27_2.title then
		if var_27_7 then
			var_27_3:getChildByName("txt_title"):setString(PROC_KR(arg_27_2.title))
		end
	elseif var_27_7 then
		var_27_5 = -70
		
		if_set_visible(var_27_3, "n_title", false)
	end
	
	if arg_27_2.tab_text then
		local var_27_8 = var_27_3:getChildByName("txt_tab")
		
		if var_27_8 then
			var_27_8:setString(PROC_KR(arg_27_2.tab_text))
		end
	end
	
	local var_27_9 = var_27_3:getChildByName("n_img") or var_27_3:getChildByName("CENTER")
	
	if var_27_9 and (arg_27_2.control or arg_27_2.image) then
		local var_27_10 = arg_27_2.image
		
		if type(var_27_10) == "string" then
			var_27_10 = getSprite(var_27_10)
		end
		
		local var_27_11 = var_27_10:getContentSize()
		local var_27_12 = arg_27_2.interval or 30
		
		var_27_5 = var_27_5 + var_27_11.height + var_27_12
		
		var_27_10:setPosition(0, (var_27_11.height + var_27_12) / 2)
		var_27_9:addChild(var_27_10)
	end
	
	local var_27_13
	
	if arg_27_1 and string.find(arg_27_1, "<#") then
		var_27_13 = upgradeLabelToRichLabel(var_27_3, "text")
	else
		var_27_13 = var_27_3:getChildByName("text")
	end
	
	if var_27_13 then
		var_27_13:setString(PROC_KR(arg_27_1))
		
		if var_27_13.setTextVerticalAlignment then
			if arg_27_2.warning then
				if_set(var_27_3, "txt_warning", arg_27_2.warning)
				var_27_13:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
			elseif arg_27_2.green then
				if_set(var_27_3, "txt_green", arg_27_2.green)
				var_27_13:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
			elseif not arg_27_2.ignore_text_alignment then
				local var_27_14 = arg_27_2.banner_txt_vertical_alignment and arg_27_2.banner_txt_vertical_alignment or cc.VERTICAL_TEXT_ALIGNMENT_CENTER
				
				var_27_13:setTextVerticalAlignment(var_27_14)
			end
		elseif tolua.type(var_27_13) == "ccui.RichText" then
			if arg_27_2.warning then
				if_set(var_27_3, "txt_warning", arg_27_2.warning)
				var_27_13:setAlignment(cc.TEXT_ALIGNMENT_CENTER, cc.VERTICAL_TEXT_ALIGNMENT_TOP)
			elseif arg_27_2.green then
				if_set(var_27_3, "txt_green", arg_27_2.green)
				var_27_13:setAlignment(cc.TEXT_ALIGNMENT_CENTER, cc.VERTICAL_TEXT_ALIGNMENT_TOP)
			elseif not arg_27_2.ignore_text_alignment then
				local var_27_15 = arg_27_2.banner_txt_vertical_alignment and arg_27_2.banner_txt_vertical_alignment or cc.VERTICAL_TEXT_ALIGNMENT_CENTER
				
				var_27_13:setAlignment(cc.TEXT_ALIGNMENT_CENTER, var_27_15)
			end
		end
		
		if arg_27_2.postbox then
			local var_27_16 = 5
			
			if var_27_16 < var_27_13:getStringNumLines() then
				local var_27_17 = (var_27_13:getStringNumLines() - var_27_16) * 24
				
				var_27_5 = var_27_5 + var_27_17
				
				var_27_13:setPositionY(var_27_13:getPositionY() + var_27_17)
				
				local var_27_18 = var_27_13:getContentSize()
				
				var_27_13:setContentSize({
					width = var_27_18.width,
					height = var_27_18.height + (var_27_17 + 3)
				})
			end
		end
	end
	
	if_set_visible(var_27_3, "txt_green", arg_27_2.green ~= nil)
	if_set_visible(var_27_3, "txt_warning", arg_27_2.warning ~= nil)
	if_set_visible(var_27_3, "n_buttons", arg_27_2.cost == nil)
	if_set_visible(var_27_3, "n_cost_buttons", arg_27_2.cost ~= nil)
	
	local var_27_19 = var_27_3:getChildByName("n_buttons") or var_27_3
	
	if arg_27_2.cost or arg_27_2.token then
		var_27_19 = var_27_3:getChildByName("n_cost_buttons") or var_27_3
		
		if arg_27_2.cost then
			if_set(var_27_19, "cost", comma_value(arg_27_2.cost))
			
			arg_27_2.yesno = true
		end
		
		if arg_27_2.token then
			local var_27_20, var_27_21 = DB("item_token", arg_27_2.token, {
				"type",
				"icon"
			})
			
			if var_27_21 then
				if_set_sprite(var_27_19, "icon_res", "item/" .. var_27_21 .. ".png")
				if_set_sprite(var_27_3, "icon_item", "item/" .. var_27_21 .. ".png")
			end
		elseif arg_27_2.material then
			local var_27_22, var_27_23 = DB("item_material", arg_27_2.material, {
				"icon",
				"frame_effect"
			})
			
			if var_27_22 then
				if_set_sprite(var_27_19, "icon_res", "item/" .. var_27_22 .. ".png")
				if_set_sprite(var_27_3, "icon_item", "item/" .. var_27_22 .. ".png")
				if_set_effect(var_27_3, "icon_item", var_27_23)
			end
		end
	end
	
	if_set_visible(var_27_19, "btn_yes", arg_27_2.yesno)
	if_set_visible(var_27_19, "txt_yes", arg_27_2.yesno)
	if_set_visible(var_27_19, "btn_cancel", arg_27_2.yesno)
	if_set_visible(var_27_19, "txt_cancel", arg_27_2.yesno)
	if_set_visible(var_27_19, "btn_ok", not arg_27_2.yesno)
	if_set_visible(var_27_19, "txt_ok", not arg_27_2.yesno)
	
	if arg_27_2.yes_text then
		if_set(var_27_19, "txt_yes", arg_27_2.yes_text)
	end
	
	if arg_27_2.no_text then
		if_set(var_27_19, "txt_cancel", arg_27_2.no_text)
	end
	
	if arg_27_2.ok_text then
		if_set(var_27_19, "txt_ok", arg_27_2.ok_text)
	end
	
	if_set_visible(var_27_3, "txt_code", arg_27_2.txt_code ~= nil)
	
	for iter_27_0, iter_27_1 in pairs(arg_27_2) do
		if string.starts(iter_27_0, "txt_") then
			if_set(var_27_19, iter_27_0, PROC_KR(iter_27_1))
			if_set(var_27_3, iter_27_0, PROC_KR(iter_27_1))
		end
	end
	
	arg_27_0:setModal(var_27_3)
	arg_27_0:setBack(var_27_3)
	var_27_2:addChild(var_27_3)
	var_27_3:setLocalZOrder(999999)
	
	Dialog.MsgBoxHandlers[var_27_3] = {
		handler = arg_27_2.handler,
		arg = arg_27_2.arg,
		cancel_handler = arg_27_2.cancel_handler,
		tag = arg_27_2.tag
	}
	arg_27_0.no_back_button = arg_27_2.no_back_button
	
	if not arg_27_2.no_back_button then
		if arg_27_2.cancel_handler then
			BackButtonManager:push({
				back_func = function()
					arg_27_0:msgBoxUIHandler(var_27_3, "btn_cancel")
				end,
				dlg = var_27_3,
				check_id = "Dialog." .. var_27_3:getName()
			})
		elseif arg_27_2.handler and (not arg_27_2.yesno or arg_27_2.yesno == false) then
			BackButtonManager:push({
				back_func = function()
					arg_27_0:msgBoxUIHandler(var_27_3, "btn_default")
				end,
				dlg = var_27_3,
				check_id = "Dialog." .. var_27_3:getName()
			})
		else
			BackButtonManager:push({
				back_func = function()
					arg_27_0:msgBoxUIHandler(var_27_3, "btn_cancel")
				end,
				dlg = var_27_3,
				check_id = "Dialog." .. var_27_3:getName()
			})
		end
	end
	
	if arg_27_2.updater then
		Scheduler:addSlow(var_27_3, arg_27_2.updater)
	end
	
	local var_27_24 = var_27_3:getChildByName("n_show_eff")
	local var_27_25 = var_27_3:getChildByName("n_content")
	local var_27_26 = var_27_3:getChildByName("window_frame")
	local var_27_27
	
	if var_27_26 then
		var_27_27 = var_27_26:getContentSize()
	end
	
	if var_27_24 and not arg_27_2.no_show_effect then
		if var_27_5 ~= 0 and var_27_25 and var_27_7 then
			var_27_25:setPositionY(0 - var_27_5 / 2)
			var_27_7:setPositionY(var_27_5 / 2)
		end
		
		function var_27_26.setHeight(arg_31_0, arg_31_1)
			arg_31_0:setContentSize(arg_31_0:getContentSize().width, arg_31_1)
		end
		
		var_27_26:setContentSize({
			height = 30,
			width = var_27_27.width
		})
		var_27_24:setOpacity(0)
		
		local var_27_28 = 120
		
		UIAction:Add(SEQ(DELAY(var_27_1), SPAWN(DELAY(var_27_28), LOG(LINEAR_CALL(var_27_28, var_27_26, "setHeight", 30, var_27_27.height + var_27_5))), FADE_IN(var_27_0)), var_27_24, "block")
		UIAction:Add(SEQ(DELAY(var_27_1), DELAY(var_27_28), FADE_IN(var_27_0)), var_27_24, "block")
		UIAction:Add(SEQ(DELAY(var_27_1), SHOW(true)), var_27_3, "block")
	else
		var_27_3:setOpacity(0)
		UIAction:Add(SEQ(DELAY(var_27_1), FADE_IN(var_27_0)), var_27_3, "block")
	end
	
	local var_27_29 = var_27_3:getChildByName("n_eff")
	
	if var_27_29 and not arg_27_2.no_reward_effect then
		EffectManager:Play({
			pivot_x = 0,
			fn = "ui_reward_popup_eff.cfx",
			pivot_y = 0,
			pivot_z = 99998,
			layer = var_27_29,
			delay = var_27_1
		})
		UIAction:Add(DELAY(1000), var_27_3, "block")
	end
	
	if var_27_4 then
		local var_27_30 = not arg_27_2.ok_text and not arg_27_2.yesno
		
		if_set_visible(var_27_3, "n_ok_only", var_27_30)
		
		if var_27_30 then
			if_set_visible(var_27_3, "n_buttons", false)
			if_set_visible(var_27_3, "n_cost_buttons", false)
		end
		
		if var_27_30 and arg_27_2.green then
			local var_27_31 = var_27_3:getChildByName("txt_green")
			
			if var_27_31:getStringNumLines() == 5 then
				var_27_13:setPositionY(var_27_13:getPositionY() + 25)
				var_27_31:setPositionY(var_27_31:getPositionY() + 20)
			end
		end
	end
	
	if_set_arrow(var_27_3, "n_arrow")
	
	if arg_27_2.open_effect then
		EffectManager:Play({
			fn = "ui_reward_popup_eff.cfx",
			delay = 100,
			pivot_z = 99998,
			layer = var_27_3,
			pivot_x = DESIGN_WIDTH / 2,
			pivot_y = DESIGN_HEIGHT / 2
		})
		UIAction:Add(DELAY(1000), var_27_3, "block")
	end
	
	SoundEngine:play("event:/ui/popup/normal")
	
	return var_27_3
end

function Dialog.closeShowRareDrop(arg_32_0)
	if not arg_32_0._dropActionList then
		return 
	end
	
	if table.count(arg_32_0._dropActionList) > 0 and UIAction:Find("dialog.drop_action") then
		UIAction:Remove("dialog.drop_action")
		
		arg_32_0._dropActionList = {}
	end
end

function Dialog.ShowRareDrop(arg_33_0, arg_33_1, arg_33_2)
	if not arg_33_0._dropActionList then
		arg_33_0._dropActionList = {}
	end
	
	if ArenaService:isActiveUIScene() then
		return 
	end
	
	if table.count(arg_33_0._dropActionList) > 0 and UIAction:Find("dialog.drop_action") then
		table.insert(arg_33_0._dropActionList, {
			item = arg_33_1,
			opt = arg_33_2
		})
	else
		arg_33_0._dropActionList = {}
		
		table.insert(arg_33_0._dropActionList, {
			item = arg_33_1,
			opt = arg_33_2
		})
		arg_33_0:_ShowRareDrop()
	end
end

function Dialog.showRarePannelEffect(arg_34_0, arg_34_1, arg_34_2)
	arg_34_2 = arg_34_2 or {}
	
	local var_34_0 = arg_34_2.high_grade and "item_get_panel_gold.cfx" or "item_get_panel.cfx"
	local var_34_1 = arg_34_2.high_grade and "item_get_panel_gold_eff.cfx" or "item_get_panel_eff.cfx"
	local var_34_2 = EffectManager:Play({
		fn = var_34_0,
		layer = arg_34_1,
		delay = arg_34_2.delay,
		x = arg_34_2.x,
		y = arg_34_2.y
	})
	local var_34_3 = EffectManager:Play({
		fn = var_34_1,
		layer = arg_34_1,
		delay = arg_34_2.delay,
		x = arg_34_2.x,
		y = arg_34_2.y
	})
	
	return var_34_2, var_34_3
end

local function var_0_1(arg_35_0)
	local var_35_0 = {}
	local var_35_1 = arg_35_0.unit or {
		equip_stat = arg_35_0.equip_stat
	}
	local var_35_2 = arg_35_0.equip or {}
	
	if type(arg_35_0) == "string" then
		var_35_0.code = arg_35_0
	else
		arg_35_0 = arg_35_0.unit or arg_35_0.equip or arg_35_0.item or arg_35_0
		var_35_0.code = arg_35_0.token or arg_35_0.code or arg_35_0.account_skill or var_35_2.code or var_35_1.db.code
		var_35_0.item_grade = arg_35_0.g or arg_35_0.grade or 1
		var_35_0.item_count = arg_35_0.c or arg_35_0.count
		var_35_0.set_fx = arg_35_0.set_fx
		
		local var_35_3 = Account:isCurrencyType(var_35_0.code)
		
		if var_35_3 then
			var_35_0.code = "to_" .. var_35_3
		end
	end
	
	return var_35_0
end

function Dialog._ShowRareDrop(arg_36_0)
	if not arg_36_0._dropActionList then
		arg_36_0._dropActionList = {}
	end
	
	local var_36_0 = arg_36_0._dropActionList[1]
	
	if not var_36_0 then
		return 
	end
	
	local var_36_1 = var_36_0.opt or {}
	local var_36_2 = var_36_0.item or {}
	local var_36_3 = var_0_1(var_36_2)
	
	if not var_36_3.item_grade then
		return 
	end
	
	if var_36_1.limit and var_36_3.item_grade < var_36_1.limit then
		return 
	end
	
	local var_36_4 = var_36_3.item_grade > 3
	
	if var_36_3.code == "to_hero2" then
		var_36_4 = true
	end
	
	local var_36_5 = var_36_1.parent or SceneManager:getRunningPopupScene()
	local var_36_6 = DESIGN_WIDTH * 0.5
	local var_36_7 = DESIGN_HEIGHT * 0.84
	local var_36_8 = cc.Node:create()
	
	var_36_8:setPosition(var_36_6, var_36_7)
	var_36_8:setLocalZOrder(999999)
	
	local var_36_9, var_36_10 = arg_36_0:showRarePannelEffect(var_36_8, {
		high_grade = var_36_4
	})
	local var_36_11 = {
		show_small_count = true,
		no_tooltip = true,
		show_name = true,
		right_hero_name = true,
		no_resize_name = true,
		grade_max = true,
		no_detail_popup = true,
		no_popup = true,
		y = 12,
		scale = 1,
		detail = true,
		parent = var_36_8,
		equip_stat = var_36_3.equip_stat or {},
		use_drop_icon = var_36_1.use_drop_icon,
		right_hero_type = UIUtil:isSDModelItem(var_36_3.code)
	}
	local var_36_12 = false
	
	if var_36_2.code and DB("equip_item", var_36_2.code, {
		"type",
		"icon"
	}) == "artifact" then
		var_36_12 = true
		var_36_11.scale = 0.7
		var_36_11.y = 6
	end
	
	merge_table(var_36_2.unit or var_36_2.equip or var_36_2.item or var_36_2, var_36_11)
	
	local var_36_13
	
	if var_36_2.equip and var_36_2.equip:isArtifact() then
		var_36_13 = UIUtil:updateEquipBar(nil, var_36_2.equip, {
			no_tooltip = true,
			no_grade = true
		})
		
		var_36_13:setAnchorPoint(0.5, 0.44)
		var_36_13:setScale(0.9)
		
		var_36_12 = true
	else
		var_36_13 = UIUtil:getRewardIcon(var_36_2.diff or var_36_2.count, var_36_3.code, var_36_11)
	end
	
	if var_36_12 then
		local var_36_14 = var_36_13:getChildByName("n_names")
		
		if get_cocos_refid(var_36_13) then
			local var_36_15 = var_36_13:getScale()
			
			var_36_13:setScale(1)
			var_36_13:getChildByName("n_root"):setScale(var_36_15)
		end
	end
	
	if Battle.logic and Battle.logic.map and SceneManager:getCurrentSceneName() == "battle" and Account:isFirstReward(Battle.logic.map.enter, var_36_3.code) then
		IconUtil.setIcon(var_36_13).addFirstReward(Account:isFirstReward(Battle.logic.map.enter, var_36_3.code)).done()
	end
	
	local var_36_16 = 267
	local var_36_17 = var_36_1.delay or 300
	local var_36_18 = var_36_1.fade_time or 300
	local var_36_19 = math.max(1000, var_36_10:getDuration() * 1000)
	local var_36_20 = var_36_13:getChildByName("txt_name") or var_36_13:getChildByName("txt_r_name")
	
	if get_cocos_refid(var_36_20) then
		local var_36_21 = 400
		
		if var_36_21 < var_36_20:getContentSize().width then
			var_36_20:setTextAreaSize({
				width = var_36_21,
				height = var_36_20:getLineHeight() * 2
			})
			
			local var_36_22 = var_36_20:getParent()
			
			if get_cocos_refid(var_36_22) then
				var_36_22:setPositionY(var_36_22:getPositionY() + 13)
			end
		end
		
		var_36_13:setPositionX(-var_36_20:getContentSize().width / 2)
	end
	
	if var_36_13:getName() == "sd_model_icon" then
		local var_36_23 = 12
		local var_36_24 = {}
		
		var_36_24[1] = "frame_bg"
		var_36_24[2] = "face"
		var_36_24[3] = "frame"
		
		for iter_36_0, iter_36_1 in pairs(var_36_24) do
			if iter_36_1 and get_cocos_refid(var_36_13:getChildByName(iter_36_1)) then
				local var_36_25 = var_36_13:getChildByName(iter_36_1)
				
				var_36_25:setPositionY(var_36_25:getPositionY() + var_36_23)
			end
		end
		
		if_set_add_position_y(var_36_13, "n_names", 4)
	end
	
	var_36_13:setVisible(false)
	UIAction:Add(SEQ(DELAY(var_36_19), DELAY(var_36_17), FADE_OUT(var_36_18)), var_36_9)
	UIAction:Add(SEQ(DELAY(var_36_19), DELAY(var_36_17), FADE_OUT(var_36_18)), var_36_10)
	UIAction:Add(SEQ(DELAY(var_36_16), SHOW(true), DELAY(var_36_19 - var_36_16 + var_36_17), FADE_OUT(var_36_18)), var_36_13)
	UIAction:Add(SEQ(DELAY(var_36_19 + var_36_17), CALL(function(arg_37_0)
		table.remove(arg_37_0._dropActionList, 1)
	end, arg_36_0), CALL(arg_36_0._ShowRareDrop, arg_36_0), DELAY(var_36_18), REMOVE()), var_36_8, "dialog.drop_action")
	var_36_5:addChild(var_36_8)
	SoundEngine:play("event:/ui/gain_rare")
end

function eff_fade_in(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5)
	local var_38_0 = arg_38_0:getChildByName(arg_38_1)
	
	if not var_38_0 then
		return 
	end
	
	var_38_0:setOpacity(0)
	
	arg_38_4 = (not arg_38_4 or nil) and "block"
	
	UIAction:Add(SEQ(DELAY(arg_38_3), FADE_IN(arg_38_2, arg_38_5)), var_38_0, arg_38_4)
end

function eff_slide_in(arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5)
	local var_39_0 = arg_39_0:getChildByName(arg_39_1)
	
	if not var_39_0 then
		return 
	end
	
	var_39_0:setOpacity(0)
	
	arg_39_4 = (not arg_39_4 or nil) and "block"
	
	UIAction:Add(SEQ(DELAY(arg_39_3), SLIDE_IN(arg_39_2, arg_39_5)), var_39_0, arg_39_4)
end

function eff_slide_out(arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4, arg_40_5)
	local var_40_0 = arg_40_0:getChildByName(arg_40_1)
	
	if not var_40_0 then
		return 
	end
	
	arg_40_4 = (not arg_40_4 or nil) and "block"
	
	UIAction:Add(SEQ(DELAY(arg_40_3), SLIDE_OUT(arg_40_2, arg_40_5 or -600)), var_40_0, arg_40_4)
end

function if_set(arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4, arg_41_5, arg_41_6)
	if not arg_41_0 or not get_cocos_refid(arg_41_0) then
		return 
	end
	
	arg_41_2 = arg_41_2 or ""
	
	local var_41_0 = arg_41_0
	
	if arg_41_1 then
		var_41_0 = arg_41_0:getChildByName(arg_41_1)
	end
	
	if not get_cocos_refid(var_41_0) then
		return 
	end
	
	if arg_41_3 and (arg_41_2 == nil or arg_41_2 == 0) then
		var_41_0:setVisible(false)
	else
		if arg_41_4 == "ratioExpand" then
			arg_41_2 = string.format("%3.1f%%", arg_41_2 * 100)
		elseif arg_41_4 then
			arg_41_2 = string.format("%3.0f%%", arg_41_2 * 100)
		end
		
		var_41_0:setVisible(true)
		
		if arg_41_5 then
			arg_41_2 = arg_41_5 .. arg_41_2
		end
		
		if arg_41_6 then
			arg_41_2 = arg_41_2 .. arg_41_6
		end
		
		local var_41_1 = getUserLanguage()
		
		if var_41_1 == "fr" or var_41_1 == "es" then
			arg_41_2 = string.gsub(arg_41_2, "([%S])%s([%?%!%%])", "%1" .. " " .. "%2")
		end
		
		var_41_0:setString(arg_41_2)
		UIUserData:proc(var_41_0)
	end
end

function get_word_wrapped_name(arg_42_0, arg_42_1)
	if not UIUtil:isUserLanguageMBCS() then
		return arg_42_1
	end
	
	if not get_cocos_refid(arg_42_0) then
		return arg_42_1
	end
	
	local var_42_0 = string.split(arg_42_1, "[ -]", false, true)
	local var_42_1 = ""
	
	for iter_42_0, iter_42_1 in pairs(var_42_0) do
		local var_42_2, var_42_3 = string.rtrim(var_42_1 .. iter_42_1)
		
		arg_42_0:setString(var_42_2)
		
		var_42_1 = (arg_42_0:getContentSize().width < arg_42_0:getAutoRenderSize().width and iter_42_0 ~= 1 and string.rtrim(var_42_1) .. "\n" or var_42_1) .. iter_42_1
	end
	
	return var_42_1
end

function if_inc_number(arg_43_0, arg_43_1)
	if not arg_43_0 or not get_cocos_refid(arg_43_0) then
		return 
	end
	
	local var_43_0 = arg_43_0
	
	if arg_43_1 then
		var_43_0 = arg_43_0:getChildByName(arg_43_1)
	end
	
	if not get_cocos_refid(var_43_0) then
		return 
	end
	
	if var_43_0 then
		UIAction:AddAsync(INC_NUMBER(200), var_43_0)
	end
end

function if_set_diff(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	if not arg_44_0 or not get_cocos_refid(arg_44_0) then
		return 
	end
	
	local var_44_0 = arg_44_0
	
	if arg_44_1 then
		var_44_0 = arg_44_0:getChildByName(arg_44_1)
	end
	
	if not get_cocos_refid(var_44_0) then
		return 
	end
	
	var_44_0:setVisible(arg_44_2 ~= 0)
	
	if arg_44_2 == 0 then
		return 
	end
	
	if_set(arg_44_0, arg_44_1, arg_44_2, false, arg_44_3)
end

function if_set_visible(arg_45_0, arg_45_1, arg_45_2)
	if not arg_45_0 or not get_cocos_refid(arg_45_0) then
		return 
	end
	
	local var_45_0 = arg_45_0
	
	if arg_45_1 then
		var_45_0 = arg_45_0:getChildByName(arg_45_1)
	end
	
	if not get_cocos_refid(var_45_0) then
		return 
	end
	
	var_45_0:setVisible(arg_45_2 ~= nil and arg_45_2 ~= false)
end

function if_set_position(arg_46_0, arg_46_1, arg_46_2, arg_46_3)
	if not arg_46_0 or not get_cocos_refid(arg_46_0) then
		return 
	end
	
	local var_46_0 = arg_46_0
	
	if arg_46_1 then
		var_46_0 = arg_46_0:getChildByName(arg_46_1)
	end
	
	if not get_cocos_refid(var_46_0) then
		return 
	end
	
	var_46_0:setPosition(arg_46_2, arg_46_3)
end

function if_set_position_x(arg_47_0, arg_47_1, arg_47_2)
	if not arg_47_0 or not get_cocos_refid(arg_47_0) then
		return 
	end
	
	local var_47_0 = arg_47_0
	
	if arg_47_1 then
		var_47_0 = arg_47_0:getChildByName(arg_47_1)
	end
	
	if not get_cocos_refid(var_47_0) then
		return 
	end
	
	var_47_0:setPositionX(arg_47_2)
end

function if_set_add_position_x(arg_48_0, arg_48_1, arg_48_2)
	if not arg_48_0 or not get_cocos_refid(arg_48_0) or not arg_48_2 then
		return 
	end
	
	local var_48_0 = arg_48_0
	
	if arg_48_1 then
		var_48_0 = arg_48_0:getChildByName(arg_48_1)
	end
	
	if not get_cocos_refid(var_48_0) then
		return 
	end
	
	var_48_0._origin_pos_x = var_48_0._origin_pos_x or var_48_0:getPositionX()
	
	var_48_0:setPositionX(var_48_0._origin_pos_x + arg_48_2)
end

function if_set_position_y(arg_49_0, arg_49_1, arg_49_2)
	if not arg_49_0 or not get_cocos_refid(arg_49_0) then
		return 
	end
	
	local var_49_0 = arg_49_0
	
	if arg_49_1 then
		var_49_0 = arg_49_0:getChildByName(arg_49_1)
	end
	
	if not get_cocos_refid(var_49_0) then
		return 
	end
	
	var_49_0:setPositionY(arg_49_2)
end

function if_set_add_position_y(arg_50_0, arg_50_1, arg_50_2)
	if not arg_50_0 or not get_cocos_refid(arg_50_0) or not arg_50_2 then
		return 
	end
	
	local var_50_0 = arg_50_0
	
	if arg_50_1 then
		var_50_0 = arg_50_0:getChildByName(arg_50_1)
	end
	
	if not get_cocos_refid(var_50_0) then
		return 
	end
	
	var_50_0._origin_pos_y = var_50_0._origin_pos_y or var_50_0:getPositionY()
	
	var_50_0:setPositionY(var_50_0._origin_pos_y + arg_50_2)
end

function if_set_enabled(arg_51_0, arg_51_1, arg_51_2)
	if not arg_51_0 or not get_cocos_refid(arg_51_0) then
		return 
	end
	
	local var_51_0 = arg_51_0
	
	if arg_51_1 then
		var_51_0 = arg_51_0:getChildByName(arg_51_1)
	end
	
	if not get_cocos_refid(var_51_0) then
		return 
	end
	
	var_51_0:setEnabled(arg_51_2 ~= nil and arg_51_2 ~= false)
end

function if_set_content_size(arg_52_0, arg_52_1, arg_52_2, arg_52_3)
	if not arg_52_0 or not get_cocos_refid(arg_52_0) then
		return 
	end
	
	local var_52_0 = arg_52_0
	
	if arg_52_1 then
		var_52_0 = arg_52_0:getChildByName(arg_52_1)
	end
	
	if not get_cocos_refid(var_52_0) then
		return 
	end
	
	var_52_0:setContentSize(arg_52_2, arg_52_3)
end

function if_set_color(arg_53_0, arg_53_1, arg_53_2)
	if not arg_53_0 or not get_cocos_refid(arg_53_0) then
		return 
	end
	
	local var_53_0 = arg_53_0
	
	if arg_53_1 then
		var_53_0 = arg_53_0:getChildByName(arg_53_1)
	end
	
	if not get_cocos_refid(var_53_0) then
		return 
	end
	
	var_53_0:setColor(arg_53_2)
end

function if_call(arg_54_0, arg_54_1, arg_54_2, ...)
	if not arg_54_0 or not get_cocos_refid(arg_54_0) then
		return 
	end
	
	local var_54_0 = arg_54_0
	
	if arg_54_1 then
		var_54_0 = arg_54_0:getChildByName(arg_54_1)
	end
	
	if not get_cocos_refid(var_54_0) then
		return 
	end
	
	var_54_0[arg_54_2](var_54_0, ...)
end

function if_set_text_color(arg_55_0, arg_55_1, arg_55_2)
	if not arg_55_0 or not get_cocos_refid(arg_55_0) then
		return 
	end
	
	local var_55_0 = arg_55_0
	
	if arg_55_1 then
		var_55_0 = arg_55_0:getChildByName(arg_55_1)
	end
	
	if not get_cocos_refid(var_55_0) then
		return 
	end
	
	var_55_0:setTextColor(arg_55_2)
end

function if_set_cascade_color(arg_56_0, arg_56_1, arg_56_2)
	if not arg_56_0 or not get_cocos_refid(arg_56_0) then
		return 
	end
	
	local var_56_0 = arg_56_0
	
	if arg_56_1 then
		var_56_0 = arg_56_0:getChildByName(arg_56_1)
	end
	
	if not get_cocos_refid(var_56_0) then
		return 
	end
	
	var_56_0:setCascadeColorEnabled(arg_56_2)
end

function if_set_cascade_opacity(arg_57_0, arg_57_1, arg_57_2)
	if not arg_57_0 or not get_cocos_refid(arg_57_0) then
		return 
	end
	
	local var_57_0 = arg_57_0
	
	if arg_57_1 then
		var_57_0 = arg_57_0:getChildByName(arg_57_1)
	end
	
	if not get_cocos_refid(var_57_0) then
		return 
	end
	
	var_57_0:setCascadeOpacityEnabled(arg_57_2)
end

function if_set_tag(arg_58_0, arg_58_1, arg_58_2)
	if not arg_58_0 or not get_cocos_refid(arg_58_0) then
		return 
	end
	
	local var_58_0 = arg_58_0
	
	if arg_58_1 then
		var_58_0 = arg_58_0:getChildByName(arg_58_1)
	end
	
	if not get_cocos_refid(var_58_0) then
		return 
	end
	
	var_58_0.tag = arg_58_2
end

function if_set_opacity(arg_59_0, arg_59_1, arg_59_2)
	if not arg_59_0 or not get_cocos_refid(arg_59_0) then
		return 
	end
	
	local var_59_0 = arg_59_0
	
	if arg_59_1 then
		var_59_0 = arg_59_0:getChildByName(arg_59_1)
	end
	
	if not get_cocos_refid(var_59_0) then
		return 
	end
	
	var_59_0:setOpacity(arg_59_2)
end

function if_set_percent(arg_60_0, arg_60_1, arg_60_2)
	if not arg_60_0 or not get_cocos_refid(arg_60_0) then
		return 
	end
	
	local var_60_0 = arg_60_0
	
	if arg_60_1 then
		var_60_0 = arg_60_0:getChildByName(arg_60_1)
	end
	
	if not get_cocos_refid(var_60_0) then
		return 
	end
	
	if not var_60_0.setPercent then
		return 
	end
	
	var_60_0:setPercent(arg_60_2 * 100)
end

function if_set_circle_percent(arg_61_0, arg_61_1, arg_61_2, arg_61_3)
	if not arg_61_0 or not get_cocos_refid(arg_61_0) then
		return 
	end
	
	local var_61_0 = arg_61_0
	
	if arg_61_1 then
		var_61_0 = arg_61_0:getChildByName(arg_61_1)
	end
	
	if not get_cocos_refid(var_61_0) then
		return 
	end
	
	local var_61_1 = var_61_0:getParent():getChildByName("@progress")
	
	if get_cocos_refid(var_61_1) then
		var_61_1:setPercentage(arg_61_2)
		
		return 
	end
	
	var_61_0:setVisible(false)
	
	local var_61_2 = WidgetUtils:createCircleProgress(arg_61_3 or "img/_hero_s_frame_w.png")
	
	var_61_2:setScale(var_61_0:getScale())
	var_61_2:setPositionX(var_61_0:getPositionX())
	var_61_2:setPositionY(var_61_0:getPositionY())
	var_61_2:setOpacity(var_61_0:getOpacity())
	var_61_2:setColor(var_61_0:getColor())
	var_61_2:setReverseDirection(false)
	var_61_2:setPercentage(arg_61_2)
	var_61_2:setName("@progress")
	var_61_0:getParent():addChild(var_61_2)
end

function if_set_width(arg_62_0, arg_62_1, arg_62_2, arg_62_3, arg_62_4)
	if not arg_62_0 or not get_cocos_refid(arg_62_0) then
		return 
	end
	
	arg_62_3 = arg_62_3 or 0
	arg_62_4 = arg_62_4 or 230
	
	local var_62_0 = arg_62_0
	
	if arg_62_1 then
		var_62_0 = arg_62_0:getChildByName(arg_62_1)
	end
	
	if var_62_0 then
		sz = var_62_0:getContentSize()
		sz.width = (arg_62_4 - arg_62_3) * arg_62_2 + arg_62_3
		
		var_62_0:setContentSize(sz)
	end
end

function if_set_remain_time(arg_63_0, arg_63_1, arg_63_2)
	local var_63_0 = math.floor(os.time() - tonumber(arg_63_2))
	
	if_set(arg_63_0, arg_63_1, var_63_0 < 60 and T("time_just_before") or T("time_before", {
		time = sec_to_string(var_63_0)
	}))
end

function set_width_from_node(arg_64_0, arg_64_1, arg_64_2)
	if not get_cocos_refid(arg_64_0) then
		return 
	end
	
	if not get_cocos_refid(arg_64_1) then
		return 
	end
	
	arg_64_2 = arg_64_2 or {}
	arg_64_2.ratio = arg_64_2.ratio or 1
	arg_64_2.add = arg_64_2.add or 0
	arg_64_2.min = arg_64_2.min or 0
	arg_64_2.max = arg_64_2.max or math.huge
	
	local var_64_0 = (tolua.type() == "ccui.RichText" and arg_64_1:getTextBoxSize() or arg_64_1:getContentSize()).width * arg_64_1:getScaleX() * arg_64_2.ratio + arg_64_2.add
	local var_64_1 = math.max(arg_64_2.min, var_64_0)
	local var_64_2 = math.min(arg_64_2.max, var_64_1)
	
	arg_64_0:setContentSize(var_64_2, arg_64_0:getContentSize().height)
end

function set_height_from_node(arg_65_0, arg_65_1, arg_65_2)
	if not get_cocos_refid(arg_65_0) then
		return 
	end
	
	if not get_cocos_refid(arg_65_1) then
		return 
	end
	
	arg_65_2 = arg_65_2 or {}
	arg_65_2.ratio = arg_65_2.ratio or 1
	arg_65_2.add = arg_65_2.add or 0
	arg_65_2.min = arg_65_2.min or 0
	arg_65_2.max = arg_65_2.max or math.huge
	
	local var_65_0 = arg_65_1:getContentSize()
	
	if arg_65_1.getTextBoxSize then
		var_65_0 = arg_65_1:getTextBoxSize()
		
		arg_65_1:setContentSize(var_65_0)
		arg_65_1:getContentSize()
	end
	
	local var_65_1 = var_65_0.height * arg_65_1:getScaleY() * arg_65_2.ratio + arg_65_2.add
	local var_65_2 = math.max(arg_65_2.min, var_65_1)
	local var_65_3 = math.min(arg_65_2.max, var_65_2)
	
	arg_65_0:setContentSize(arg_65_0:getContentSize().width, var_65_3)
end

function get_ellipsis(arg_66_0, arg_66_1, arg_66_2)
	if not get_cocos_refid(arg_66_0) then
		return arg_66_1
	end
	
	if_set(arg_66_0, nil, arg_66_1)
	
	if not arg_66_2() then
		return arg_66_1
	end
	
	local var_66_0 = arg_66_1
	local var_66_1 = 0
	local var_66_2 = utf8len(var_66_0)
	
	while var_66_2 - var_66_1 > 1 do
		local var_66_3 = math.ceil((var_66_2 + var_66_1) * 0.5)
		
		var_66_0 = utf8sub(arg_66_1, 1, var_66_3)
		
		arg_66_0:setString(var_66_0 .. "...")
		
		if arg_66_2() then
			var_66_2 = var_66_3
		else
			var_66_1 = var_66_3
		end
	end
	
	while arg_66_2() do
		local var_66_4 = utf8len(var_66_0) - 1
		
		if var_66_4 < 1 then
			var_66_0 = ""
			
			break
		end
		
		var_66_0 = utf8sub(arg_66_1, 1, var_66_4)
		
		arg_66_0:setString(var_66_0 .. "...")
	end
	
	return var_66_0 .. "..."
end

function get_ellipsis_label(arg_67_0, arg_67_1, arg_67_2, arg_67_3)
	return get_ellipsis(arg_67_0, arg_67_1, function()
		return arg_67_2 < arg_67_0:getContentSize().width
	end, arg_67_3)
end

function set_ellipsis_label(arg_69_0, arg_69_1, arg_69_2, arg_69_3)
	if_set(arg_69_0, nil, get_ellipsis_label(arg_69_0, arg_69_1, arg_69_2, arg_69_3))
end

function get_ellipsis_multi_label(arg_70_0, arg_70_1, arg_70_2)
	return get_ellipsis(arg_70_0, arg_70_1, function()
		return arg_70_2 < arg_70_0:getStringNumLines()
	end)
end

function set_ellipsis_multi_label(arg_72_0, arg_72_1, arg_72_2)
	if_set(arg_72_0, nil, get_ellipsis_multi_label(arg_72_0, arg_72_1, arg_72_2))
end

function set_ellipsis_label2(arg_73_0, arg_73_1, arg_73_2, arg_73_3)
	if not get_cocos_refid(arg_73_0) then
		return 
	end
	
	arg_73_0:setString(arg_73_1)
	
	if not (arg_73_2 < arg_73_0:getStringNumLines()) then
		return 
	end
	
	local var_73_0 = arg_73_1
	local var_73_1 = utf8len(var_73_0)
	
	for iter_73_0 = 1, arg_73_3 or arg_73_2 * 2 do
		var_73_1 = math.floor(var_73_1 / 2)
		
		if var_73_1 == 0 then
			var_73_1 = 1
		end
		
		local var_73_2 = arg_73_2 < arg_73_0:getStringNumLines()
		
		var_73_0 = utf8sub(arg_73_1, 1, utf8len(var_73_0) + (var_73_2 and -var_73_1 or var_73_1))
		
		arg_73_0:setString(var_73_0)
	end
	
	arg_73_0:setString(utf8sub(var_73_0, 1, utf8len(var_73_0) - 2) .. "...")
end

function if_set_width_from(arg_74_0, arg_74_1, arg_74_2, arg_74_3)
	if not arg_74_0 or not get_cocos_refid(arg_74_0) then
		return 
	end
	
	set_width_from_node(arg_74_0:getChildByName(arg_74_1), arg_74_0:getChildByName(arg_74_2), arg_74_3)
end

function set_scale_fit_width_node(arg_75_0, arg_75_1)
	if not get_cocos_refid(arg_75_0) then
		return 
	end
	
	if not get_cocos_refid(arg_75_1) then
		return 
	end
	
	local var_75_0 = arg_75_1:getContentSize().width * arg_75_1:getScaleX()
	local var_75_1 = arg_75_0:getAutoRenderSize().width * arg_75_0:getScaleX()
	
	set_scale_fit_width(arg_75_0, var_75_0)
end

function set_scale_fit_width(arg_76_0, arg_76_1, arg_76_2)
	if not get_cocos_refid(arg_76_0) then
		return 
	end
	
	arg_76_0._origin_scale_x = arg_76_0._origin_scale_x or arg_76_0:getScaleX()
	
	if not arg_76_2 then
		if tolua.type(arg_76_0) == "ccui.RichText" then
			arg_76_2 = arg_76_0:getTextBoxSize().width * arg_76_0._origin_scale_x
		else
			arg_76_2 = arg_76_0:getContentSize().width * arg_76_0._origin_scale_x
		end
	end
	
	local var_76_0 = arg_76_1 < arg_76_2 and arg_76_1 / arg_76_2 or 1
	
	arg_76_0:setScaleX(arg_76_0._origin_scale_x * var_76_0)
end

local function var_0_2(arg_77_0, arg_77_1, arg_77_2, arg_77_3)
	arg_77_3 = arg_77_3 or 1
	
	if arg_77_3 > 10 then
		return 
	end
	
	arg_77_0:formatText()
	
	local var_77_0 = arg_77_0:getStringNumLines()
	
	if var_77_0 <= arg_77_1 then
		return 
	end
	
	arg_77_0._origin_size = arg_77_0._origin_size or arg_77_0:getContentSize()
	
	local var_77_1 = arg_77_0._origin_size.height / var_77_0
	
	arg_77_0:setContentSize({
		width = arg_77_0._origin_size.width + arg_77_2,
		height = var_77_1 * arg_77_1
	})
	var_0_2(arg_77_0, arg_77_1, arg_77_2 + 50, arg_77_3 + 1)
	
	arg_77_0._origin_scale_x = arg_77_0._origin_scale_x or arg_77_0:getScaleX()
	
	set_scale_fit_width(arg_77_0, arg_77_0._origin_size.width * arg_77_0._origin_scale_x)
end

local function var_0_3(arg_78_0, arg_78_1, arg_78_2, arg_78_3, arg_78_4)
	arg_78_4 = arg_78_4 or 1
	
	if arg_78_4 > 10 then
		return 
	end
	
	local var_78_0 = arg_78_0:getStringNumLines()
	
	if var_78_0 <= arg_78_1 then
		return 
	end
	
	arg_78_0._origin_text_size = arg_78_0._origin_text_size or arg_78_0:getTextBoxSize()
	arg_78_0._origin_scale_x = arg_78_0._origin_scale_x or arg_78_0:getScaleX()
	
	local var_78_1 = arg_78_0._origin_text_size.width + arg_78_2
	local var_78_2 = arg_78_0._origin_text_size.height / var_78_0
	
	if arg_78_3 > arg_78_0._origin_text_size.width / var_78_1 then
		arg_78_0:setContentSize({
			width = arg_78_0._origin_text_size.width / arg_78_3,
			height = var_78_2 * arg_78_1
		})
		
		if arg_78_4 == 1 then
			set_scale_fit_width(arg_78_0, arg_78_0._origin_text_size.width * arg_78_0._origin_scale_x)
		end
		
		return 
	end
	
	arg_78_0:setContentSize({
		width = var_78_1,
		height = var_78_2 * arg_78_1
	})
	var_0_3(arg_78_0, arg_78_1, arg_78_2 + 50, arg_78_3, arg_78_4 + 1)
	set_scale_fit_width(arg_78_0, arg_78_0._origin_text_size.width * arg_78_0._origin_scale_x)
end

function set_scale_fit_width_multi_line(arg_79_0, arg_79_1, arg_79_2, arg_79_3)
	if not get_cocos_refid(arg_79_0) then
		return 
	end
	
	arg_79_3 = arg_79_3 or 0.01
	
	local var_79_0 = tolua.type(arg_79_0)
	
	if var_79_0 == "ccui.Text" then
		var_0_3(arg_79_0, arg_79_1, arg_79_2, arg_79_3)
	elseif var_79_0 == "ccui.RichText" then
		var_0_2(arg_79_0, arg_79_1, arg_79_2)
	end
end

function if_set_scale_fit_width_long_word(arg_80_0, arg_80_1, arg_80_2, arg_80_3)
	if not get_cocos_refid(arg_80_0) then
		return 
	end
	
	local var_80_0 = arg_80_0
	
	if arg_80_1 then
		var_80_0 = arg_80_0:getChildByName(arg_80_1)
	end
	
	if not get_cocos_refid(var_80_0) then
		return 
	end
	
	local var_80_1 = "[ -]"
	local var_80_2 = string.split(arg_80_2, var_80_1, false)
	local var_80_3 = 0
	
	for iter_80_0, iter_80_1 in pairs(var_80_2) do
		var_80_0:setString(iter_80_1 .. "-")
		
		var_80_3 = math.max(var_80_3, var_80_0:getAutoRenderSize().width)
	end
	
	if arg_80_3 < var_80_3 then
		var_80_0:setContentSize({
			width = var_80_3,
			height = var_80_0:getContentSize().height
		})
	end
	
	if_set(var_80_0, nil, arg_80_2)
	set_scale_fit_width(var_80_0, arg_80_3, var_80_3)
end

function if_set_scale_fit_width(arg_81_0, arg_81_1, arg_81_2, arg_81_3)
	if not get_cocos_refid(arg_81_0) then
		return 
	end
	
	local var_81_0 = arg_81_0
	
	if arg_81_1 then
		var_81_0 = arg_81_0:getChildByName(arg_81_1)
	end
	
	set_scale_fit_width(var_81_0, arg_81_2, arg_81_3)
end

function if_set_sprite(arg_82_0, arg_82_1, arg_82_2)
	if not arg_82_0 or not get_cocos_refid(arg_82_0) then
		return 
	end
	
	local var_82_0 = arg_82_0
	
	if arg_82_1 then
		var_82_0 = arg_82_0:getChildByName(arg_82_1)
	end
	
	if not get_cocos_refid(var_82_0) then
		return 
	end
	
	if type(arg_82_2) == "string" then
		SpriteCache:resetSprite(var_82_0, arg_82_2)
		
		return var_82_0
	end
	
	if tolua.type(arg_82_2) == "cc.Sprite" then
	end
	
	return var_82_0
end

function if_set_sprite_with_9_slice(arg_83_0, arg_83_1, arg_83_2, arg_83_3)
	local var_83_0 = arg_83_0
	
	if arg_83_1 then
		var_83_0 = arg_83_0:getChildByName(arg_83_1)
	end
	
	if not get_cocos_refid(var_83_0) then
		return 
	end
	
	if type(arg_83_2) ~= "string" then
		return var_83_0
	end
	
	local var_83_1 = SpriteCache:getSprite(arg_83_2)
	
	if not get_cocos_refid(var_83_1) then
		return 
	end
	
	SpriteCache:resetSprite(var_83_0, arg_83_2)
	
	local var_83_2 = var_83_1:getTextureRect()
	local var_83_3 = {
		x = arg_83_3.left,
		y = arg_83_3.top,
		width = var_83_2.width - (arg_83_3.left + arg_83_3.right),
		height = var_83_2.height - (arg_83_3.top + arg_83_3.bottom)
	}
	
	var_83_0:setCapInsets(var_83_3)
	
	return var_83_0
end

function if_set_effect(arg_84_0, arg_84_1, arg_84_2)
	if not arg_84_0 or not get_cocos_refid(arg_84_0) then
		return 
	end
	
	local var_84_0 = arg_84_0
	
	if arg_84_1 then
		var_84_0 = arg_84_0:getChildByName(arg_84_1)
	end
	
	if not get_cocos_refid(var_84_0) then
		return 
	end
	
	local var_84_1 = arg_84_1 or "default_eff"
	local var_84_2 = var_84_0:getChildByName(var_84_1)
	
	if var_84_2 then
		var_84_2:removeFromParent()
	end
	
	local var_84_3 = CACHE:getEffect(arg_84_2)
	
	if var_84_3 then
		var_84_3:start()
		var_84_3:setName(var_84_1)
		var_84_3:setPositionX(var_84_0:getContentSize().width * 0.5)
		var_84_3:setPositionY(var_84_0:getContentSize().height * 0.5)
		var_84_0:addChild(var_84_3)
	end
end

function if_set_star(arg_85_0, arg_85_1, arg_85_2, arg_85_3, arg_85_4, arg_85_5, arg_85_6)
	arg_85_4 = arg_85_4 or "star0"
	arg_85_5 = "icon_"
	arg_85_6 = arg_85_6 or 16
	
	for iter_85_0 = 6, arg_85_3 + 1, -1 do
		local var_85_0 = arg_85_0:getChildByName(arg_85_4 .. iter_85_0)
		
		if var_85_0 then
			var_85_0:setVisible(false)
		end
	end
	
	local var_85_1 = type(arg_85_2) == "table"
	
	for iter_85_1 = 1, arg_85_3 do
		local var_85_2 = arg_85_0:getChildByName(arg_85_4 .. iter_85_1)
		
		if not var_85_2 then
			return 
		end
		
		local var_85_3 = var_85_2:getPositionX()
		
		var_85_2:setPositionX(var_85_3 + (6 - arg_85_3) * arg_85_6)
		var_85_2:setVisible(true)
		
		if not var_85_1 then
			if arg_85_2 < iter_85_1 then
				SpriteCache:resetSprite(var_85_2, arg_85_5 .. "star_blank.png")
			elseif arg_85_1 < iter_85_1 then
				SpriteCache:resetSprite(var_85_2, arg_85_5 .. "star_upgrade.png")
			else
				SpriteCache:resetSprite(var_85_2, arg_85_5 .. "star.png")
			end
		else
			local var_85_4 = false
			
			for iter_85_2, iter_85_3 in pairs(arg_85_2) do
				if iter_85_1 == iter_85_3 and arg_85_1 ~= iter_85_3 then
					SpriteCache:resetSprite(var_85_2, arg_85_5 .. "star_upgrade.png")
					
					var_85_4 = true
				end
			end
			
			if not var_85_4 then
				if arg_85_1 < iter_85_1 then
					SpriteCache:resetSprite(var_85_2, arg_85_5 .. "star_blank.png")
				else
					SpriteCache:resetSprite(var_85_2, arg_85_5 .. "star.png")
				end
			end
		end
	end
end

function if_set_arrow(arg_86_0, arg_86_1, arg_86_2)
	if not arg_86_0 or not get_cocos_refid(arg_86_0) then
		return 
	end
	
	arg_86_1 = arg_86_1 or "n_arrow"
	
	local var_86_0 = arg_86_0:getChildByName(arg_86_1)
	
	if not get_cocos_refid(var_86_0) then
		return 
	end
	
	arg_86_2 = arg_86_2 or {}
	arg_86_2.time = arg_86_2.time or 350
	arg_86_2.x = arg_86_2.x or 0
	arg_86_2.y = arg_86_2.y or -10
	
	local var_86_1, var_86_2 = var_86_0:getPosition()
	
	UIAction:Add(SEQ(LOOP(SEQ(LOG(MOVE_TO(arg_86_2.time, var_86_1, var_86_2)), RLOG(MOVE_TO(arg_86_2.time, var_86_1 + arg_86_2.x, var_86_2 + arg_86_2.y))))), var_86_0, "arrow_move")
end

function Dialog.msgBoxLevelUp(arg_87_0, arg_87_1)
	arg_87_1 = arg_87_1 or {}
	
	local var_87_0 = arg_87_1.dlg or load_dlg("msgbox_levelup_result", true, "wnd")
	
	arg_87_1.dlg = var_87_0
	
	local var_87_1 = var_87_0:getChildByName("n_msgbox"):getChildByName("n_top"):getChildByName("txt_title")
	local var_87_2 = var_87_0:getChildByName("n_msgbox"):getChildByName("n_top"):getChildByName("txt_disc")
	local var_87_3 = var_87_0:getChildByName("n_msgbox"):getChildByName("n_center"):getChildByName("txt_before")
	local var_87_4 = var_87_0:getChildByName("n_msgbox"):getChildByName("n_center"):getChildByName("txt_after")
	
	var_87_0:getChildByName("n_msgbox"):getChildByName("n_below"):getChildByName("txt_tab"):setString(T("ui_msgbox_reward_continue"))
	var_87_1:setString(arg_87_1.title)
	var_87_2:setString(arg_87_1.text)
	var_87_3:setString(arg_87_1.before_score)
	var_87_4:setString(arg_87_1.after_score)
	arg_87_0:msgBox(arg_87_1.text, arg_87_1)
	
	return var_87_0
end

function HANDLER.expedition_acquisition(arg_88_0, arg_88_1)
	if arg_88_1 == "btn_del" then
		if BattleRepeat:isPlayingRepeatPlay() then
			balloon_message(T("expedition_wanted_hide"))
			
			return 
		end
		
		local function var_88_0(arg_89_0, arg_89_1)
			if arg_89_1 == "btn_yes" then
				query("coop_ticket_delete", {
					boss_slot = CoopMission.drop_boss_slot
				})
				Dialog:closeAll()
			end
		end
		
		Dialog:msgBox(T("expedition_boss_del_desc"), {
			yesno = true,
			title = T("expedition_boss_del_title"),
			handler = var_88_0
		})
		
		return "dont_close"
	elseif arg_88_1 == "btn_move" then
		if BattleRepeat:isPlayingRepeatPlay() then
			balloon_message_with_sound("ui_pet_auto_battle_other_btn")
			
			return 
		end
		
		Dialog:close("expedition_acquisition")
		CoopMission.DoEnter({
			url = "hand"
		})
	end
end

function Dialog.msgboxGetCoopMission(arg_90_0, arg_90_1)
	arg_90_1 = arg_90_1 or {}
	arg_90_1.dlg = arg_90_1.dlg or load_dlg("expedition_acquisition", true, "wnd")
	arg_90_1.node = arg_90_1.dlg:getChildByName("n_boss_info")
	
	if BattleRepeat:isPlayingRepeatPlay() then
		arg_90_1.dlg:getChildByName("btn_del"):setOpacity(30)
	end
	
	local var_90_0 = UIUtil:getPortraitAni("npc1034", {
		pin_sprite_position_y = true
	})
	
	if get_cocos_refid(var_90_0) then
		var_90_0:setScale(0.87)
		
		local var_90_1 = arg_90_1.dlg:getChildByName("n_portrait")
		
		var_90_1:removeAllChildren()
		var_90_1:addChild(var_90_0)
		
		arg_90_1.dlg.portrait = var_90_0
	end
	
	if not arg_90_1.no_effect then
		EffectManager:Play({
			pivot_x = 639,
			fn = "ui_reward_popup_eff.cfx",
			pivot_y = 600,
			delay = 100,
			pivot_z = 99998,
			scale = 2,
			layer = arg_90_1.dlg
		})
		UIAction:Add(DELAY(1000), arg_90_1.dlg:getChildByName("txt_title"), "block")
	end
	
	CoopMission.drop_boss_code = arg_90_1.boss_code
	arg_90_1.handler = HANDLER.expedition_acquisition
	
	CoopUtil:get_boss_img_from_id(arg_90_1)
	arg_90_0:msgBox("", arg_90_1)
	
	return arg_90_1.dlg
end

function Dialog.msgBoxSlider(arg_91_0, arg_91_1)
	set_high_fps_tick()
	
	arg_91_1 = arg_91_1 or {}
	
	local var_91_0 = arg_91_1.dlg or load_dlg("msgbox_slidebar", true, "wnd")
	
	if_set_visible(var_91_0, "n_info", arg_91_1.info)
	
	if arg_91_1.info then
		if_set(var_91_0, "txt_info", arg_91_1.info)
	end
	
	var_91_0.slider = var_91_0:getChildByName("slider")
	
	var_91_0.slider:setMaxPercent(arg_91_1.max or 100)
	var_91_0.slider:addEventListener(Dialog.defaultSliderEventHandler)
	
	var_91_0.slider.handler = arg_91_1.slider_handler
	var_91_0.slider.parent = var_91_0
	var_91_0.slider.min = arg_91_1.min
	arg_91_1.dlg = var_91_0
	
	arg_91_0:msgBox(arg_91_1.text, arg_91_1)
	
	if arg_91_1.slider_pos then
		var_91_0.slider:setPercent(arg_91_1.slider_pos)
	end
	
	if var_91_0.slider.handler then
		var_91_0.slider.handler(var_91_0, arg_91_1.slider_pos or 0, 0)
	end
	
	return var_91_0
end

function Dialog.msgPetLock(arg_92_0, arg_92_1)
	if SubstoryManager:msgEndDescentLock(arg_92_1) then
		return 
	end
	
	local var_92_0 = ""
	
	for iter_92_0, iter_92_1 in pairs(arg_92_1) do
		if iter_92_0 ~= 1 then
			var_92_0 = var_92_0 .. ", "
		end
		
		var_92_0 = var_92_0 .. T(iter_92_1)
	end
	
	local var_92_1 = T("locked_pet_list", {
		codes = var_92_0
	})
	
	arg_92_0:msgBox(T("locked_pet_text"), {
		warning = var_92_1,
		title = T("locked_pet_title")
	})
end

function Dialog.msgUnitLock(arg_93_0, arg_93_1)
	if SubstoryManager:msgEndDescentLock(arg_93_1) then
		return 
	end
	
	local var_93_0 = ""
	
	for iter_93_0, iter_93_1 in pairs(arg_93_1) do
		local var_93_1 = T("ul_" .. iter_93_1)
		
		if not string.find(var_93_0, var_93_1) then
			if iter_93_0 ~= 1 then
				var_93_0 = var_93_0 .. ", "
			end
			
			var_93_0 = var_93_0 .. var_93_1
		end
	end
	
	local var_93_2 = T("ul_code_list", {
		codes = var_93_0
	})
	
	return arg_93_0:msgBox(T("locked_unit_text"), {
		warning = var_93_2,
		title = T("locked_unit_title")
	})
end

function Dialog.msgItems(arg_94_0, arg_94_1)
	if table.count(arg_94_1 or {}) == 0 then
		return 
	end
	
	local var_94_0 = load_dlg("msgbox_rewards_expand", true, "wnd")
	
	if not get_cocos_refid(var_94_0) then
		return 
	end
	
	if_set_visible(var_94_0, "n_scrollview", false)
	
	local var_94_1 = table.count(arg_94_1) > 5
	
	if_set_visible(var_94_0, "n_item_node", not var_94_1)
	if_set_visible(var_94_0, "window_frame", not var_94_1)
	if_set_visible(var_94_0, "n_listview", var_94_1)
	if_set_visible(var_94_0, "window_frame_scroll", var_94_1)
	
	local function var_94_2(arg_95_0, arg_95_1)
		local var_95_0 = table.count(arg_95_1)
		local var_95_1 = var_95_0 % 2 == 1
		
		if_set_visible(arg_95_0, "n_odd", var_95_1)
		if_set_visible(arg_95_0, "n_even", not var_95_1)
		if_set_visible(arg_95_0, var_95_0, true)
		
		local var_95_2 = arg_95_0:getChildByName(var_95_0)
		
		if not get_cocos_refid(var_95_2) then
			return 
		end
		
		local var_95_3 = 1
		
		for iter_95_0, iter_95_1 in pairs(arg_95_1) do
			local var_95_4 = var_95_2:getChildByName("reward_item" .. var_95_3)
			
			if not get_cocos_refid(var_95_4) then
				break
			end
			
			local var_95_5 = {
				show_small_count = true,
				tooltip_delay = 130,
				scale = 1,
				parent = var_95_4,
				set_fx = iter_95_1.set_fx
			}
			
			if iter_95_1.code then
				if string.starts(iter_95_1.code, "c") then
					var_95_5.scale = 1.15
				elseif string.starts(iter_95_1.code, "e") then
					local var_95_6 = DB("equip_item", iter_95_1.code, {
						"type"
					})
					
					if var_95_6 and var_95_6 == "artifact" then
						var_95_5.scale = 0.8
					end
					
					var_95_5.equip = iter_95_1
				end
			end
			
			UIUtil:getRewardIcon(iter_95_1.count, iter_95_1.code, var_95_5)
			
			var_95_3 = var_95_3 + 1
		end
	end
	
	local function var_94_3(arg_96_0, arg_96_1)
		local var_96_0 = arg_96_0:getChildByName("n_top")
		
		if get_cocos_refid(var_96_0) then
			var_96_0:setPositionY(var_96_0:getPositionY() + 56)
		end
		
		local var_96_1 = arg_96_0:getChildByName("n_bottom")
		
		if get_cocos_refid(var_96_1) then
			var_96_1:setPositionY(var_96_1:getPositionY() - 56)
		end
		
		local var_96_2 = arg_96_0:getChildByName("listview")
		local var_96_3 = table.count(arg_96_1)
		
		if var_96_3 > 5 and var_96_3 <= 10 then
			local var_96_4 = var_96_2:getContentSize()
			
			var_96_2:setContentSize(var_96_4.width, var_96_4.height - 20)
		end
		
		local var_96_5 = ItemListView:bindControl(var_96_2)
		local var_96_6 = {
			onUpdate = function(arg_97_0, arg_97_1, arg_97_2)
				arg_97_1:removeAllChildren()
				
				local var_97_0 = {
					show_small_count = true,
					scale = 1,
					tooltip_delay = 130,
					parent = arg_97_1
				}
				
				if arg_97_2.code then
					if string.starts(arg_97_2.code, "c") then
						var_97_0.scale = 1.15
					elseif string.starts(arg_97_2.code, "e") then
						local var_97_1 = DB("equip_item", arg_97_2.code, {
							"type"
						})
						
						if var_97_1 and var_97_1 == "artifact" then
							var_97_0.scale = 0.8
						end
						
						var_97_0.equip = arg_97_2
					end
				end
				
				arg_97_1 = UIUtil:getRewardIcon(arg_97_2.count, arg_97_2.code, var_97_0)
				
				arg_97_1:setPosition(16, 10)
				arg_97_1:setAnchorPoint(0, 0)
			end
		}
		local var_96_7 = cc.Layer:create()
		
		var_96_7:setContentSize(var_0_0, var_0_0)
		var_96_5:setRenderer(var_96_7, var_96_6)
		var_96_5:setItems(arg_96_1)
	end
	
	if var_94_1 then
		var_94_3(var_94_0, arg_94_1)
	else
		var_94_2(var_94_0, arg_94_1)
	end
	
	return var_94_0
end

function Dialog.msgScrollRewards(arg_98_0, arg_98_1, arg_98_2)
	arg_98_2 = arg_98_2 or {}
	
	local var_98_0 = arg_98_2.rewards.new_items or arg_98_2.rewards or {}
	
	for iter_98_0, iter_98_1 in pairs(var_98_0) do
		if iter_98_1.is_package then
			var_98_0[iter_98_0] = nil
		end
	end
	
	if table.count(var_98_0) < 10 then
		if table.count(var_98_0) == 0 then
			return 
		end
		
		local var_98_1 = {}
		
		for iter_98_2, iter_98_3 in pairs(var_98_0) do
			var_98_1[iter_98_2] = {}
			var_98_1[iter_98_2].item = {}
			var_98_1[iter_98_2].item.diff = iter_98_3.count
			var_98_1[iter_98_2].item.code = iter_98_3.code
			
			if iter_98_3.item and iter_98_3.item.isEquip then
				var_98_1[iter_98_2].equip = iter_98_3.item
			end
			
			local var_98_2 = Account:isCurrencyType(var_98_1[iter_98_2].item.code)
			
			if var_98_2 then
				var_98_1[iter_98_2].item.code = "to_" .. var_98_2
			end
		end
		
		arg_98_2.rewards = var_98_1
		
		local var_98_3 = arg_98_0:msgRewards(arg_98_1, arg_98_2)
		
		if var_98_3 then
			if_set(var_98_3, "txt_title", arg_98_2.title or T("expedition_reward_get_title"))
		end
		
		return 
	end
	
	local var_98_4 = arg_98_2.dlg or load_dlg("msgbox_rewards_expand", true, "wnd")
	
	if_set_visible(var_98_4, "window_frame_scroll", true)
	if_set_visible(var_98_4, "n_scrollview", false)
	if_set_visible(var_98_4, "n_lstlview", true)
	if_set_visible(var_98_4, "window_frame", false)
	if_set_visible(var_98_4, "btn_confirm", false)
	if_set_visible(var_98_4, "n_bottom", false)
	if_set_visible(var_98_4, "btn_close", true)
	if_set(var_98_4, "txt_title", arg_98_2.title or T("expedition_reward_get_title"))
	
	local var_98_5 = var_98_4:getChildByName("n_top")
	
	if get_cocos_refid(var_98_5) then
		var_98_5:setPositionY(var_98_5:getPositionY() + 56)
	end
	
	local var_98_6 = var_98_4:getChildByName("n_below")
	
	if get_cocos_refid(var_98_6) then
		var_98_6:setVisible(true)
		var_98_6:setPositionY(var_98_6:getPositionY() - 56)
	end
	
	local var_98_7 = ItemListView:bindControl(var_98_4:getChildByName("listview"))
	local var_98_8 = {
		onUpdate = function(arg_99_0, arg_99_1, arg_99_2)
			arg_99_1:removeAllChildren()
			
			local var_99_0 = Account:isCurrencyType(arg_99_2.code)
			
			if var_99_0 then
				arg_99_2.code = "to_" .. var_99_0
			end
			
			local var_99_1
			
			if arg_99_2.item and arg_99_2.item.isEquip then
				var_99_1 = arg_99_2.item
			end
			
			local var_99_2 = DB("item_material", arg_99_2.code, {
				"ma_type"
			}) == "xpup"
			local var_99_3 = {
				no_detail_popup = true,
				tooltip_delay = 130,
				parent = arg_99_1,
				equip = var_99_1
			}
			
			var_99_3.scale = 1
			
			if arg_99_2.code then
				if string.starts(arg_99_2.code, "c") then
					var_99_3.scale = 1.15
				elseif string.starts(arg_99_2.code, "e") then
					local var_99_4 = DB("equip_item", arg_99_2.code, {
						"type"
					})
					
					if var_99_4 and var_99_4 == "artifact" then
						var_99_3.scale = 0.8
					end
				end
			end
			
			local var_99_5 = 27
			
			arg_99_1 = UIUtil:getRewardIcon(arg_99_2.count, arg_99_2.code, var_99_3)
			
			arg_99_1:setPosition(var_99_5, 10)
			arg_99_1:setAnchorPoint(0, 0)
			
			if var_99_2 then
				arg_99_1:setPositionX(var_99_5 + 7)
			end
		end
	}
	local var_98_9 = cc.Layer:create()
	
	var_98_9:setContentSize(100, 105)
	var_98_7:setRenderer(var_98_9, var_98_8)
	var_98_7:setItems(var_98_0)
	
	arg_98_2.dlg = var_98_4
	
	arg_98_0:msgBox(arg_98_1, arg_98_2)
end

function Dialog.msgRewards(arg_100_0, arg_100_1, arg_100_2)
	arg_100_2 = arg_100_2 or {}
	
	local var_100_0 = arg_100_2.dlg or load_dlg("msgbox_rewards", true, "wnd")
	
	arg_100_2.dlg = var_100_0
	
	if not arg_100_2.txt_count then
		if_set(var_100_0, "txt_count", false)
	end
	
	if arg_100_2.letter then
		if_set(var_100_0, "txt_letter", arg_100_2.letter)
	else
		local var_100_1 = var_100_0:getChildByName("n_line1")
		local var_100_2 = var_100_0:getChildByName("n_line2")
		local var_100_3 = Account:getCurrencyCodes()
		local var_100_4 = {}
		local var_100_5 = {}
		local var_100_6 = {}
		
		for iter_100_0, iter_100_1 in pairs(arg_100_2.rewards) do
			if iter_100_1.token then
				local var_100_7 = iter_100_1.token
				
				if table.find(var_100_3, iter_100_1.token) then
					var_100_7 = "to_" .. iter_100_1.token
				end
				
				var_100_6[var_100_7] = to_n(var_100_6[var_100_7]) + iter_100_1.count
				
				if iter_100_1.lota_arti_bonus then
					var_100_5[var_100_7] = iter_100_1.lota_arti_bonus
				end
			else
				table.push(var_100_4, iter_100_1)
			end
		end
		
		for iter_100_2, iter_100_3 in pairs(var_100_6) do
			table.push(var_100_4, {
				token = iter_100_2,
				count = iter_100_3,
				lota_arti_bonus = var_100_5[iter_100_2]
			})
		end
		
		if arg_100_2.order_first_token then
			table.sort(var_100_4, function(arg_101_0, arg_101_1)
				if arg_101_0.token == arg_100_2.order_first_token and arg_101_1.token ~= arg_100_2.order_first_token then
					return true
				end
				
				if arg_101_0.token ~= arg_100_2.order_first_token and arg_101_1.token == arg_100_2.order_first_token then
					return false
				end
			end)
		end
		
		local var_100_8 = #var_100_4
		local var_100_9 = var_100_8
		local var_100_10 = 0
		
		if var_100_8 > 5 then
			var_100_9 = math.floor(var_100_8 / 2 + 0.6)
			var_100_10 = var_100_8 - var_100_9
			
			var_100_0:getChildByName("n_lines"):setPositionY(40)
		end
		
		local var_100_11 = var_100_1
		
		for iter_100_4, iter_100_5 in pairs(var_100_4 or {}) do
			local var_100_12 = arg_100_2.no_bg or false
			
			if iter_100_5.item and iter_100_5.item.code and string.starts(iter_100_5.item.code, "ma_bg") then
				var_100_12 = true
			end
			
			local var_100_13 = {
				show_small_count = true,
				no_remove_prev_icon = true,
				touch_block = true,
				no_detail_popup = true,
				parent = var_100_11,
				equip = iter_100_5.equip,
				no_bg = var_100_12
			}
			local var_100_14 = iter_100_5.count
			local var_100_15 = iter_100_5.token or iter_100_5.code
			
			if iter_100_5.equip then
				var_100_14 = "equip"
				var_100_15 = iter_100_5.equip.code
			end
			
			if iter_100_5.unit then
				var_100_14 = "c"
				var_100_15 = iter_100_5.unit.db.code
				var_100_13.lv = iter_100_5.unit:getLv()
				var_100_13.hide_lv = iter_100_5.unit:getType() == "xpup" or iter_100_5.unit:getType() == "devotion"
				
				if arg_100_2.no_db_grade then
					var_100_13.no_db_grade = true
					var_100_13.grade = iter_100_5.unit:getGrade()
				end
			end
			
			if iter_100_5.item then
				var_100_15 = iter_100_5.item.code
				var_100_14 = iter_100_5.item.diff
			end
			
			if iter_100_5.account_skill then
				var_100_15 = iter_100_5.account_skill
			end
			
			if iter_100_5.pet then
				var_100_15 = iter_100_5.pet.db.code
				var_100_13.grade = iter_100_5.pet:getGrade()
				var_100_13.pet_detail = true
				var_100_13.pet = iter_100_5.pet
			end
			
			if iter_100_5.lota_arti_bonus then
				var_100_13.lota_arti_bonus = iter_100_5.lota_arti_bonus
			end
			
			if DB("item_material", iter_100_5.code, {
				"ma_type"
			}) == "xpup" then
				var_100_15 = iter_100_5.code
			end
			
			var_100_13.scale = arg_100_2.scale or 1
			
			local var_100_16 = 0
			
			if var_100_15 then
				if string.starts(var_100_15, "c") then
					var_100_13.scale = 1.15
					var_100_16 = 0.1
				elseif string.starts(var_100_15, "e") then
					local var_100_17 = DB("equip_item", var_100_15, {
						"type"
					})
					
					if var_100_17 and var_100_17 == "artifact" then
						var_100_13.scale = 0.8
					end
				end
			end
			
			if string.find(var_100_15, "ma_petpoint") then
				var_100_13.use_drop_icon = true
			end
			
			local var_100_18 = UIUtil:getRewardIcon(var_100_14, var_100_15, var_100_13)
			
			var_100_18:setAnchorPoint(var_100_16, 0.5)
			
			local var_100_19 = iter_100_4
			
			if var_100_9 < iter_100_4 then
				var_100_19 = var_100_19 - var_100_9
			end
			
			var_100_18:setPositionX(var_0_0 * (var_100_19 - 1))
			
			if iter_100_4 == var_100_9 then
				var_100_11 = var_100_2
			end
		end
		
		if var_100_9 > 0 then
			var_100_1:setPositionX(0 - var_0_0 * var_100_9 / 2)
		end
		
		if var_100_10 > 0 then
			var_100_2:setPositionX(0 - var_0_0 * var_100_10 / 2)
		end
	end
	
	if_set_visible(var_100_0, "n_rewards", arg_100_2.letter == nil)
	if_set_visible(var_100_0, "n_letter", arg_100_2.letter ~= nil)
	
	local var_100_20 = var_100_0:findChildByName("text")
	
	if get_cocos_refid(var_100_20) then
		arg_100_2.banner_txt_vertical_alignment = var_100_20:getTextVerticalAlignment()
	end
	
	return arg_100_0:msgBox(arg_100_1, arg_100_2)
end

function HANDLER.daily_skip(arg_102_0, arg_102_1)
	if arg_102_1 == "btn_ok" then
		if arg_102_0.func then
			arg_102_0.func()
		end
	elseif arg_102_1 == "btn_stop_watching" then
		SAVE:set(arg_102_0.skip_id, getCurrent3AMTime())
		
		if arg_102_0.func then
			arg_102_0.func()
		end
	end
	
	Dialog:closeDailySkipPopup()
end

function Dialog.closeDailySkipPopup(arg_103_0)
	if not get_cocos_refid(arg_103_0.daily_skip_dlg) then
		return 
	end
	
	BackButtonManager:pop({
		id = "daily_skip",
		dlg = arg_103_0.daily_skip_dlg
	})
	arg_103_0.daily_skip_dlg:removeFromParent()
	
	arg_103_0.daily_skip_dlg = nil
end

function Dialog.isSkip(arg_104_0, arg_104_1)
	return os.time() < (tonumber(SAVE:get(arg_104_1, 0)) or 0)
end

function Dialog.openDailySkipPopup(arg_105_0, arg_105_1, arg_105_2)
	if get_cocos_refid(arg_105_0.daily_skip_dlg) then
		return 
	end
	
	if arg_105_0:isSkip(arg_105_1) then
		if arg_105_2.func then
			arg_105_2.func()
		end
		
		return 
	end
	
	arg_105_2 = arg_105_2 or {
		info = "expedition_daily_stop_desc",
		title = "abyss_replay_btn_2",
		desc = "expedition_battle_ready_desc"
	}
	
	local var_105_0 = load_dlg(arg_105_2.csd or "expedition_battle_popup", true, "wnd")
	
	var_105_0:setName("daily_skip")
	BackButtonManager:push({
		id = "daily_skip",
		back_func = function()
			arg_105_0:closeDailySkipPopup()
		end,
		dlg = var_105_0
	})
	
	arg_105_0.daily_skip_dlg = var_105_0
	var_105_0:getChildByName("btn_stop_watching").skip_id = arg_105_1
	var_105_0:getChildByName("btn_stop_watching").func = arg_105_2.func
	var_105_0:getChildByName("btn_ok").func = arg_105_2.func
	
	if_set_visible(var_105_0, "btn_ok", true)
	if_set_visible(var_105_0, "btn_cancel", true)
	if_set(var_105_0, "txt_title", T(arg_105_2.title))
	if_set(var_105_0, "txt_info", T(arg_105_2.info))
	if_set_visible(var_105_0, "txt_info", not arg_105_2.hide_info)
	
	local var_105_1 = "txt_disc"
	
	if arg_105_2.use_single_label then
		if_set_visible(var_105_0, var_105_1, false)
		if_set_visible(var_105_0, "txt_info", false)
		
		var_105_1 = "txt_disc_1"
	end
	
	upgradeLabelToRichLabel(var_105_0, var_105_1)
	if_set(var_105_0, var_105_1, T(arg_105_2.desc))
	
	local var_105_5, var_105_7, var_105_8
	
	if arg_105_2.csd and arg_105_2.csd == "pvp_unequipped_hero" and arg_105_2.arg ~= nil and type(arg_105_2.arg) == "table" then
		local var_105_2 = arg_105_2.arg
		local var_105_3 = table.count(var_105_2)
		local var_105_4 = var_105_3 % 2 == 1
		
		if_set_visible(var_105_0, "n_odd_number", var_105_4)
		if_set_visible(var_105_0, "n_even_number", not var_105_4)
		
		var_105_5 = nil
		
		local var_105_6
		
		var_105_7 = 1.4
		
		if var_105_4 then
			var_105_5 = var_105_0:getChildByName("n_odd_number")
			var_105_8 = "n_odd_face_"
		else
			var_105_5 = var_105_0:getChildByName("n_even_number")
			var_105_8 = "n_even_face_"
		end
		
		if var_105_5 then
			if var_105_3 <= 2 then
				for iter_105_0, iter_105_1 in pairs(var_105_2) do
					local var_105_9 = iter_105_1
					
					if var_105_9 and var_105_9:isGrowthBoostRegistered() then
						local var_105_10 = var_105_9:clone()
						
						GrowthBoost:apply(var_105_10)
						
						var_105_9 = var_105_10
					end
					
					local var_105_11 = iter_105_0 + 2
					local var_105_12 = var_105_5:getChildByName(string.format("%s%02d", var_105_8, var_105_11))
					
					UIUtil:getUserIcon(var_105_9, {
						parent = var_105_12,
						scale = var_105_7
					})
				end
			elseif var_105_3 <= 4 then
				for iter_105_2, iter_105_3 in pairs(var_105_2) do
					local var_105_13 = iter_105_3
					
					if var_105_13 and var_105_13:isGrowthBoostRegistered() then
						local var_105_14 = var_105_13:clone()
						
						GrowthBoost:apply(var_105_14)
						
						var_105_13 = var_105_14
					end
					
					local var_105_15 = iter_105_2 + 1
					local var_105_16 = var_105_5:getChildByName(string.format("%s%02d", var_105_8, var_105_15))
					
					UIUtil:getUserIcon(var_105_13, {
						parent = var_105_16,
						scale = var_105_7
					})
				end
			elseif var_105_3 <= 6 then
				for iter_105_4, iter_105_5 in pairs(var_105_2) do
					local var_105_17 = iter_105_5
					
					if var_105_17 and var_105_17:isGrowthBoostRegistered() then
						local var_105_18 = var_105_17:clone()
						
						GrowthBoost:apply(var_105_18)
						
						var_105_17 = var_105_18
					end
					
					local var_105_19 = iter_105_4
					local var_105_20 = var_105_5:getChildByName(string.format("%s%02d", var_105_8, var_105_19))
					
					UIUtil:getUserIcon(var_105_17, {
						parent = var_105_20,
						scale = var_105_7
					})
				end
			end
		end
	end
	
	SoundEngine:play("event:/ui/popup/normal")
	
	if arg_105_2.add_pop_scene then
		SceneManager:getRunningPopupScene():addChild(var_105_0)
	else
		SceneManager:getRunningNativeScene():addChild(var_105_0)
	end
	
	return var_105_0
end

function HANDLER.random_result(arg_107_0, arg_107_1)
	if arg_107_1 == "btn_close" then
		Dialog:CloseRandomResults(getParentWindow(arg_107_0))
	end
end

function Dialog.CloseRandomResults(arg_108_0, arg_108_1)
	UIAction:Add(SEQ(FADE_OUT(150), REMOVE()), arg_108_1, "block")
	BackButtonManager:pop("Dialog.RandomResults")
end

function Dialog.ShowRandomResults(arg_109_0, arg_109_1, arg_109_2)
	arg_109_2 = arg_109_2 or {}
	
	local var_109_0 = arg_109_2.parent or SceneManager:getRunningPopupScene()
	local var_109_1 = load_dlg("big_black_button", true, "wnd")
	
	var_109_1:setName("random_result")
	
	local var_109_2 = 0
	local var_109_3 = 200
	local var_109_4 = 1300
	
	eff_fade_in(var_109_1, var_109_3)
	
	local var_109_5 = var_0_1(arg_109_1)
	local var_109_6 = to_n(var_109_5.item_grade) > 3
	local var_109_7, var_109_8 = arg_109_0:showRarePannelEffect(var_109_1.c.CENTER, {
		delay = 1500,
		y = -10,
		high_grade = var_109_6
	})
	local var_109_9
	
	if arg_109_1.equip and arg_109_1.equip:isArtifact() then
		var_109_9 = UIUtil:updateEquipBar(nil, arg_109_1.equip, {
			no_tooltip = true,
			no_grade = true
		})
		
		var_109_9:setAnchorPoint(0.5, 0.5)
		var_109_9:setScale(0.9)
		var_109_1.c.CENTER:addChild(var_109_9)
	else
		var_109_9 = UIUtil:getRewardIcon(arg_109_1.diff or arg_109_1.count, var_109_5.code, {
			show_name = true,
			right_hero_name = true,
			no_detail_popup = true,
			no_resize_name = true,
			x = -90,
			detail = true,
			set_fx = var_109_5.set_fx,
			grade = var_109_5.item_grade,
			parent = var_109_1.c.CENTER,
			y = var_109_2
		})
	end
	
	var_109_9:setVisible(false)
	UIAction:Add(SEQ(DELAY(var_109_3 + var_109_4), SHOW(true), CALL(function()
		BackButtonManager:push({
			check_id = "Dialog.RandomResults",
			back_func = function()
				Dialog:CloseRandomResults(var_109_1)
			end,
			dlg = var_109_1
		})
	end)), var_109_9, "block")
	EffectManager:Play({
		fn = "randombox_eff.cfx",
		scale = 1,
		layer = var_109_1.c.CENTER,
		delay = var_109_3,
		y = var_109_2
	})
	UIAction:Add(DELAY(2000), var_109_1, "block")
	var_109_0:addChild(var_109_1)
end

function HANDLER.item_select_slidebar_popup(arg_112_0, arg_112_1)
	if arg_112_1 == "btn_go" then
		if Dialog.count and Dialog.count.count_button then
			Dialog.count:count_button()
		end
	elseif arg_112_1 == "btn_plus" then
		if Dialog.count.req_count and Dialog.count.req_count < Dialog.count.slider:getPercent() then
			balloon_message_with_sound(Dialog.count.t_req)
		elseif Dialog.count and Dialog.count.slider then
			Dialog.count.slider:setPercent(math.min(Dialog.count.slider:getPercent() + 1, Dialog.count.slider:getMaxPercent()))
		end
	elseif arg_112_1 == "btn_max" then
		if Dialog.count.req_count and Dialog.count.slider then
			if Dialog.count.req_count > Dialog.count.slider:getMaxPercent() then
				Dialog.count.slider:setPercent(Dialog.count.slider:getMaxPercent())
			else
				Dialog.count.slider:setPercent(Dialog.count.req_count + 1)
				balloon_message_with_sound(Dialog.count.t_req)
			end
		elseif Dialog.count and Dialog.count.slider then
			Dialog.count.slider:setPercent(Dialog.count.slider:getMaxPercent())
		end
	elseif arg_112_1 == "btn_min" then
		if Dialog.count and Dialog.count.slider then
			Dialog.count.slider:setPercent(1)
		end
	elseif arg_112_1 == "btn_minus" then
		if Dialog.count and Dialog.count.slider then
			Dialog.count.slider:setPercent(math.max(Dialog.count.slider:getPercent() - 1, 1))
		end
	elseif arg_112_1 == "btn_close" and Dialog.count and Dialog.count.back_func then
		Dialog.count:back_func()
	end
	
	if Dialog.count.slider.handler then
		Dialog.count.slider.handler(Dialog.count.dlg, arg_112_0, arg_112_1)
	end
end

function Dialog.openCountPopup(arg_113_0, arg_113_1)
	if not arg_113_1 then
		return 
	end
	
	local function var_113_0()
		if arg_113_1.back_func then
			arg_113_1.back_func()
		end
		
		Dialog.count = nil
	end
	
	local var_113_1 = load_dlg("item_select_slidebar_popup", true, "wnd", var_113_0)
	
	if_set(var_113_1:getChildByName("n_window"), "t_title", arg_113_1.t_title or T("ui_item_select_slidebar_popup_inti_title"))
	if_set(var_113_1:getChildByName("n_detail"), "t_title", arg_113_1.t_disc or T("ui_item_select_slidebar_popup_inti_de"))
	if_set(var_113_1, "txt_go", arg_113_1.t_regi or T("ui_item_select_slidebar_popup_inti_btn"))
	
	local var_113_2 = var_113_1:getChildByName("slider")
	
	var_113_2:addEventListener(Dialog.defaultSliderEventHandler)
	
	var_113_2.handler = arg_113_1.slider_func
	var_113_2.slider_pos = 1
	var_113_2.min = 1
	var_113_2.max = arg_113_1.max_count
	
	var_113_2:setMaxPercent(var_113_2.max)
	var_113_2:setPercent(1)
	
	var_113_2.parent = var_113_1
	var_113_1.slider = var_113_2
	arg_113_0.count = {}
	arg_113_0.count.t_req = arg_113_1.t_req
	arg_113_0.count.dlg = var_113_1
	arg_113_0.count.slider = var_113_2
	arg_113_0.count.count_button = arg_113_1.button_func or arg_113_1.back_func
	arg_113_0.count.back_func = arg_113_1.back_func
	
	if arg_113_1.req_count then
		arg_113_0.count.req_count = arg_113_1.req_count - 1
	end
	
	local var_113_3 = var_113_2:getPercent()
	local var_113_4 = arg_113_1.max_count
	
	if_set(var_113_1, "t_count", var_113_3 .. "/" .. var_113_4)
	arg_113_1.wnd:addChild(var_113_1, 9999998)
	
	return var_113_1, arg_113_1
end
