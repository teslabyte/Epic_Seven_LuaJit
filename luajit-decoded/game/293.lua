WidgetUtils = {}

local var_0_0 = {
	scale = {
		open = function(arg_1_0, arg_1_1)
			arg_1_1 = arg_1_1 or {}
			
			arg_1_0:setScale(0)
			
			if not arg_1_1.no_sound then
				SoundEngine:play("event:/ui/tooltip/scaleup")
			end
			
			UIAction:Add(SEQ(DELAY(arg_1_1.delay or 0), SCALE(50, 0, 1.3), SCALE(100, 1.3, 1)), arg_1_0, "tooltip_open")
		end,
		close = function(arg_2_0, arg_2_1)
			arg_2_1 = arg_2_1 or {}
			
			if not arg_2_1.no_sound then
				SoundEngine:play("event:/ui/tooltip/scaledown")
			end
			
			UIAction:Add(SEQ(SCALE(50, 1, 1.3), SCALE(100, 1.3, 0), REMOVE()), arg_2_0, "tooltip_close")
		end
	},
	fade = {
		open = function(arg_3_0, arg_3_1)
			arg_3_1 = arg_3_1 or {}
			
			if not arg_3_1.no_sound then
				SoundEngine:play("event:/ui/tooltip/fadein")
			end
			
			if to_n(arg_3_1.delay) > 0 then
				arg_3_0:setOpacity(0)
				UIAction:Add(SEQ(DELAY(arg_3_1.delay or 0), OPACITY(100, 0, 1)), arg_3_0, "tooltip_open")
			end
		end,
		close = function(arg_4_0, arg_4_1)
			if not get_cocos_refid(arg_4_0) then
				return 
			end
			
			arg_4_1 = arg_4_1 or {}
			
			local var_4_0 = arg_4_0:getOpacity() / 255
			
			if not arg_4_1.no_sound then
				SoundEngine:play("event:/ui/tooltip/fadeout")
			end
			
			UIAction:Add(SEQ(OPACITY(120 * var_4_0, 1 * var_4_0, 0), CALL(function()
				WidgetUtils.is_show_tooltip = false
			end), REMOVE()), arg_4_0, "tooltip_close")
		end
	}
}

function WidgetUtils.isHitTest(arg_6_0, arg_6_1, arg_6_2)
	if not arg_6_1:isVisible(true) then
		return 
	end
	
	local function var_6_0(arg_7_0, arg_7_1)
		local var_7_0 = arg_7_0:getParent()
		
		while var_7_0 do
			if (tolua.type(var_7_0) == "ccui.ScrollView" or tolua.type(var_7_0) == "ccui.ListView") and not WidgetUtils:isHitTest(var_7_0, arg_7_1) then
				return false
			end
			
			local var_7_1 = var_7_0:getParent()
			
			if not get_cocos_refid(var_7_1) then
				break
			end
			
			var_7_0 = var_7_1
		end
		
		return true
	end
	
	local var_6_1 = arg_6_1:convertTouchToNodeSpace(arg_6_2)
	local var_6_2 = arg_6_1:getContentSize()
	local var_6_3 = cc.rect(0, 0, var_6_2.width, var_6_2.height)
	
	if containsPoint(var_6_3, var_6_1.x, var_6_1.y) and var_6_0(arg_6_1, arg_6_2) then
		return true
	end
end

function WidgetUtils.isCircleHitTest(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_1:convertTouchToNodeSpace(arg_8_2)
	
	arg_8_3 = arg_8_3 or arg_8_1:getContentSize().height
	
	local var_8_1 = var_8_0.x * var_8_0.x
	local var_8_2 = var_8_0.y * var_8_0.y
	
	if arg_8_3 * arg_8_3 >= var_8_1 + var_8_2 then
		return true
	end
	
	return false
end

function WidgetUtils.simpleTouchCallback(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	if not get_cocos_refid(arg_9_1) or not arg_9_2 then
		return 
	end
	
	local var_9_0
	local var_9_1
	
	local function var_9_2(arg_10_0, arg_10_1)
		var_9_0 = arg_9_1:convertTouchToNodeSpace(arg_10_0)
		
		if arg_9_3 then
			arg_9_3(arg_9_1)
		end
		
		return true
	end
	
	local function var_9_3(arg_11_0, arg_11_1)
		if WidgetUtils:isHitTest(arg_9_1, arg_11_0) then
			local var_11_0 = arg_9_1:convertTouchToNodeSpace(arg_11_0)
			
			if var_11_0 and var_9_0 and math.sqrt(math.pow(var_9_0.x - var_11_0.x, 2) + math.pow(var_9_0.y - var_11_0.y, 2)) < 5 then
				arg_9_2(arg_9_1)
			end
		end
	end
	
	local var_9_4 = cc.EventListenerTouchOneByOne:create()
	local var_9_5 = cc.Director:getInstance():getEventDispatcher()
	
	var_9_4:registerScriptHandler(var_9_2, cc.Handler.EVENT_TOUCH_BEGAN)
	var_9_4:registerScriptHandler(var_9_3, cc.Handler.EVENT_TOUCH_ENDED)
	var_9_5:addEventListenerWithSceneGraphPriority(var_9_4, arg_9_1)
end

function WidgetUtils.setupPopup(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_1.control._TOUCH_LISTENER
	
	if not var_12_0 then
		var_12_0 = cc.Layer:create()
		
		if arg_12_1.content_size then
			var_12_0:setTouchEnabled(true)
		end
		
		var_12_0:setContentSize(arg_12_1.content_size or arg_12_1.control:getContentSize())
		
		if arg_12_1.content_size then
			var_12_0:setPosition(20, 20)
		end
		
		local var_12_1
		local var_12_2
		
		local function var_12_3(arg_13_0, arg_13_1)
			if WidgetUtils:isHitTest(arg_12_1.content_size ~= nil and var_12_0 or arg_12_1.control, arg_13_0) then
				var_12_2 = arg_12_1.control:convertTouchToNodeSpace(arg_13_0)
				
				if var_12_2 and var_12_1 and math.sqrt(math.pow(var_12_1.x - var_12_2.x, 2) + math.pow(var_12_1.y - var_12_2.y, 2)) < 5 then
					local var_13_0 = arg_12_1.creator()
					
					if get_cocos_refid(var_13_0) and arg_12_1.control:isVisible(true) then
						WidgetUtils:showPopup({
							popup = var_13_0,
							control = arg_12_1.control,
							delay = arg_12_1.delay,
							style = arg_12_1.style
						})
					end
				end
			end
		end
		
		local function var_12_4(arg_14_0, arg_14_1)
			if not TutorialGuide:isAllowEvent() and not arg_12_1.force_enable then
				return false
			end
			
			var_12_1 = arg_12_1.control:convertTouchToNodeSpace(arg_14_0)
			
			if arg_12_1.delay then
				UIAction:Add(SEQ(DELAY(arg_12_1.delay), CALL(var_12_3, arg_14_0, arg_14_1)), arg_12_1.control, "start_tooptip")
			end
			
			return true
		end
		
		local function var_12_5(arg_15_0, arg_15_1)
			if not TutorialGuide:isAllowEvent() and not arg_12_1.force_enable then
				return false
			end
			
			if not arg_12_1.delay then
				var_12_3(arg_15_0, arg_15_1)
			end
			
			UIAction:Remove("start_tooptip")
		end
		
		local var_12_6 = cc.EventListenerTouchOneByOne:create()
		local var_12_7 = cc.Director:getInstance():getEventDispatcher()
		
		var_12_6:registerScriptHandler(var_12_4, cc.Handler.EVENT_TOUCH_BEGAN)
		var_12_6:registerScriptHandler(var_12_5, cc.Handler.EVENT_TOUCH_ENDED)
		var_12_7:addEventListenerWithSceneGraphPriority(var_12_6, var_12_0)
		
		arg_12_1.control._TOUCH_LISTENER = var_12_0
		
		arg_12_1.control:addChild(var_12_0)
	end
end

function WidgetUtils.setupTooltip(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_1.control._TOUCH_LISTENER
	
	if not var_16_0 then
		var_16_0 = cc.Layer:create()
		
		var_16_0:setContentSize(arg_16_1.content_size or arg_16_1.control:getContentSize())
		
		local function var_16_1(arg_17_0, arg_17_1)
			if not TutorialGuide:isAllowEvent() then
				return false
			end
			
			if cc.EventCode.BEGAN == arg_17_1:getEventCode() then
				if WidgetUtils:isHitTest(arg_16_1.control, arg_17_0) then
					local function var_17_0(arg_18_0)
						local var_18_0 = arg_18_0.creator()
						
						if get_cocos_refid(var_18_0) and arg_18_0.control:isVisible(true) then
							if arg_18_0.tooltip_callback then
								arg_18_0.tooltip_callback()
							end
							
							WidgetUtils:showTooltip({
								tooltip = var_18_0,
								control = arg_18_0.control,
								adjust_x = arg_16_1.adjust_x,
								adjust_y = arg_16_1.adjust_y,
								call_by_show = arg_16_1.call_by_show,
								opts = arg_16_1.opts
							})
						end
					end
					
					var_16_0.pos = arg_17_0:getLocation()
					
					UIAction:Add(SEQ(DELAY(arg_16_1.delay), CALL(var_17_0, arg_16_1)), arg_16_1.control, "start_tooptip")
					
					return true
				end
			elseif cc.EventCode.ENDED == arg_17_1:getEventCode() or cc.EventCode.CANCELLED == arg_17_1:getEventCode() then
				UIAction:Remove("start_tooptip")
				
				return false
			end
		end
		
		local function var_16_2(arg_19_0, arg_19_1)
			if not TutorialGuide:isAllowEvent() then
				return false
			end
			
			local var_19_0 = arg_19_0:getLocation()
			local var_19_1 = arg_16_1.control._TOUCH_LISTENER
			local var_19_2 = DESIGN_HEIGHT * 0.015
			
			if var_19_1 and var_19_1.pos and (var_19_2 < math.abs(var_19_1.pos.x - var_19_0.x) or var_19_2 < math.abs(var_19_1.pos.y - var_19_0.y)) then
				UIAction:Remove("start_tooptip")
			end
			
			return false
		end
		
		local var_16_3 = cc.EventListenerTouchOneByOne:create()
		local var_16_4 = cc.Director:getInstance():getEventDispatcher()
		
		var_16_3:registerScriptHandler(var_16_1, cc.Handler.EVENT_TOUCH_BEGAN)
		var_16_3:registerScriptHandler(var_16_1, cc.Handler.EVENT_TOUCH_ENDED)
		var_16_3:registerScriptHandler(var_16_1, cc.Handler.EVENT_TOUCH_CANCELLED)
		var_16_3:registerScriptHandler(var_16_2, cc.Handler.EVENT_TOUCH_MOVED)
		var_16_4:addEventListenerWithSceneGraphPriority(var_16_3, var_16_0)
		
		arg_16_1.control._TOUCH_LISTENER = var_16_0
		
		arg_16_1.control:addChild(var_16_0)
	end
end

function WidgetUtils.setupTooltipAndPopup(arg_20_0, arg_20_1)
	local var_20_0 = 0
	local var_20_1 = 10
	local var_20_2 = arg_20_1.control._TOUCH_LISTENER
	local var_20_3 = arg_20_1.event_name or ""
	
	if not var_20_2 then
		var_20_2 = cc.Layer:create()
		
		var_20_2:setContentSize(arg_20_1.control:getContentSize())
		
		local var_20_4 = SceneManager:getCurrentSceneName() or ""
		local var_20_5
		local var_20_6
		
		local function var_20_7(arg_21_0, arg_21_1)
			if not arg_20_1.control or not get_cocos_refid(arg_20_1.control) or not get_cocos_refid(arg_21_0) or UIAction:Find("showing_tooptip2") then
				return 
			end
			
			if WidgetUtils:isHitTest(arg_20_1.control, arg_21_0) then
				var_20_6 = arg_20_1.control:convertTouchToNodeSpace(arg_21_0)
				
				if var_20_6 and var_20_5 and math.sqrt(math.pow(var_20_5.x - var_20_6.x, 2) + math.pow(var_20_5.y - var_20_6.y, 2)) < 5 then
					local var_21_0 = arg_20_1.creator(true)
					
					if get_cocos_refid(var_21_0) and arg_20_1.control:isVisible(true) then
						if var_20_4 and var_20_4 == "battle" then
							balloon_message_with_sound("item_info_battle")
						elseif TutorialGuide:isPlayingTutorial() then
						else
							UIAction:Add(SEQ(DELAY(1)), arg_20_1.control, "showing_tooptip2")
							WidgetUtils:showPopup({
								popup = var_21_0,
								control = arg_20_1.control,
								delay = arg_20_1.delay,
								style = arg_20_1.style
							})
						end
					end
				end
			end
		end
		
		local function var_20_8(arg_22_0, arg_22_1)
			if not arg_20_1.control or not get_cocos_refid(arg_20_1.control) or not get_cocos_refid(arg_22_0) or UIAction:Find("showing_tooptip2") then
				Scheduler:removeByName("_tooltip_popup_count" .. var_20_3)
				
				var_20_0 = 0
				
				return true
			end
			
			local var_22_0 = WidgetUtils:isHitTest(arg_20_1.control, arg_22_0)
			
			if var_20_0 > var_20_1 and var_22_0 then
				local function var_22_1(arg_23_0)
					local var_23_0 = arg_23_0.creator(false)
					
					if get_cocos_refid(var_23_0) and arg_23_0.control:isVisible(true) then
						if arg_23_0.tooltip_callback then
							arg_23_0.tooltip_callback()
						end
						
						WidgetUtils:showTooltip({
							tooltip = var_23_0,
							control = arg_23_0.control,
							adjust_x = arg_20_1.adjust_x,
							adjust_y = arg_20_1.adjust_y,
							call_by_show = arg_20_1.call_by_show
						})
					end
				end
				
				var_20_2.pos = arg_22_0:getLocation()
				
				UIAction:Add(SEQ(CALL(var_22_1, arg_20_1)), arg_20_1.control, "start_tooptip")
				Scheduler:removeByName("_tooltip_popup_count" .. var_20_3)
				
				var_20_0 = 0
				
				return true
			end
			
			var_20_0 = var_20_0 + 5
		end
		
		local var_20_9
		
		local function var_20_10(arg_24_0, arg_24_1)
			if not arg_20_1.control or not get_cocos_refid(arg_20_1.control) or not get_cocos_refid(arg_24_0) then
				return 
			end
			
			var_20_0 = 0
			var_20_9 = Scheduler:addGlobalInterval(50, var_20_8, arg_24_0, arg_24_1)
			
			var_20_9:setName("_tooltip_popup_count" .. var_20_3)
		end
		
		local function var_20_11(arg_25_0, arg_25_1)
			if Scheduler:findByName("_tooltip_popup_count" .. var_20_3) then
				Scheduler:removeByName("_tooltip_popup_count" .. var_20_3)
				
				if var_20_0 <= var_20_1 then
					var_20_7(arg_25_0, arg_25_1)
				end
				
				var_20_0 = 0
			end
		end
		
		local function var_20_12(arg_26_0, arg_26_1)
			if not TutorialGuide:isAllowEvent() then
				return false
			end
			
			var_20_5 = arg_20_1.control:convertTouchToNodeSpace(arg_26_0)
			
			UIAction:Add(SEQ(DELAY(arg_20_1.delay), CALL(var_20_10, arg_26_0, arg_26_1)), arg_20_1.control, "start_tooptip")
			
			return true
		end
		
		local function var_20_13(arg_27_0, arg_27_1)
			if not TutorialGuide:isAllowEvent() then
				return false
			end
			
			var_20_11(arg_27_0, arg_27_1)
			UIAction:Remove("start_tooptip")
		end
		
		local function var_20_14(arg_28_0, arg_28_1)
			if not TutorialGuide:isAllowEvent() then
				return false
			end
			
			local var_28_0 = arg_28_0:getLocation()
			local var_28_1 = arg_20_1.control._TOUCH_LISTENER
			local var_28_2 = DESIGN_HEIGHT * 0.025
			
			if var_28_1 and var_28_1.pos and (var_28_2 < math.abs(var_28_1.pos.x - var_28_0.x) or var_28_2 < math.abs(var_28_1.pos.y - var_28_0.y)) then
				UIAction:Remove("start_tooptip")
			end
			
			return false
		end
		
		local var_20_15 = cc.EventListenerTouchOneByOne:create()
		local var_20_16 = cc.Director:getInstance():getEventDispatcher()
		
		var_20_15:registerScriptHandler(var_20_12, cc.Handler.EVENT_TOUCH_BEGAN)
		var_20_15:registerScriptHandler(var_20_13, cc.Handler.EVENT_TOUCH_ENDED)
		var_20_15:registerScriptHandler(var_20_13, cc.Handler.EVENT_TOUCH_CANCELLED)
		var_20_15:registerScriptHandler(var_20_14, cc.Handler.EVENT_TOUCH_MOVED)
		var_20_16:addEventListenerWithSceneGraphPriority(var_20_15, var_20_2)
		
		arg_20_1.control._TOUCH_LISTENER = var_20_2
		
		arg_20_1.control:addChild(var_20_2)
	end
end

function WidgetUtils.TestAction(arg_29_0, arg_29_1)
	print("test Action : ")
end

function WidgetUtils.placeTooltipPosition(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	local var_30_0 = {
		x = arg_30_2.x + arg_30_1.width * 0.5 + VIEW_BASE_LEFT,
		y = arg_30_2.y + arg_30_1.height * 0.5
	}
	local var_30_1 = {
		x = 0,
		y = 0.5
	}
	local var_30_2 = arg_30_3:getContentSize()
	local var_30_3 = false
	
	if arg_30_2.x < to_n(DESIGN_WIDTH) * 0.5 then
		var_30_0.x = var_30_0.x + 80
		var_30_3 = true
	else
		var_30_0.x = var_30_0.x - var_30_2.width - 20
	end
	
	var_30_0.x = math.max(20 + VIEW_BASE_LEFT, var_30_0.x)
	var_30_0.x = math.min(DESIGN_WIDTH - VIEW_BASE_LEFT - 20 - var_30_2.width, var_30_0.x)
	var_30_0.y = math.max(20 + var_30_2.height * var_30_1.y, var_30_0.y)
	var_30_0.y = math.min(DESIGN_HEIGHT - 20 - var_30_2.height * var_30_1.y, var_30_0.y)
	
	if DESIGN_HEIGHT < var_30_2.height + 30 then
		local var_30_4 = var_30_2.height + 30 - DESIGN_HEIGHT
		
		var_30_0.y = var_30_0.y + var_30_4
	end
	
	arg_30_3:setPosition(var_30_0.x, var_30_0.y)
	arg_30_3:setAnchorPoint(var_30_1.x, var_30_1.y)
	
	local var_30_5 = arg_30_3:findChildByName("n_desc")
	
	if get_cocos_refid(var_30_5) then
		local var_30_6 = var_30_5:getWorldPosition()
		
		if var_30_6.y < 0 then
			var_30_0.y = var_30_0.y + var_30_6.y * -1 + 20
		end
		
		arg_30_3:setPositionY(var_30_0.y)
	end
	
	local var_30_7 = arg_30_3:findChildByName("n_effs")
	
	if get_cocos_refid(var_30_7) then
		if var_30_7.height then
			local var_30_8 = var_30_7.height - (var_30_0.y + arg_30_3.skill_tooltip_height * var_30_1.y - 40)
			
			if var_30_8 > 0 then
				arg_30_3:setPositionY(var_30_0.y + var_30_8)
			end
		end
		
		if var_30_7.width and var_30_3 and DESIGN_WIDTH < var_30_0.x + var_30_2.width + var_30_7.width then
			local var_30_9 = var_30_0.x + var_30_2.width + var_30_7.width - DESIGN_WIDTH
			
			arg_30_3:setPositionX(var_30_0.x - var_30_9)
		end
	end
	
	local var_30_10 = arg_30_3:getChildByName("item_private_info")
	
	if get_cocos_refid(var_30_10) then
		local var_30_11 = var_30_10:getChildByName("bg")
		local var_30_12 = var_30_11:convertToWorldSpace({
			x = 0,
			y = 0
		})
		local var_30_13 = var_30_11:getContentSize().width
		local var_30_14 = var_30_12.x + var_30_13 - VIEW_BASE_RIGHT
		
		var_30_0.x = var_30_14 < 0 and var_30_0.x or var_30_0.x - var_30_14
		var_30_0.y = var_30_12.y > 0 and var_30_0.y or var_30_0.y - var_30_12.y
		
		arg_30_3:setPosition(var_30_0.x, var_30_0.y - 30)
	end
	
	local var_30_15 = arg_30_3:findChildByName("txt_device_info")
	
	if var_30_15 then
		local var_30_16 = var_30_15:getWorldPosition()
		local var_30_17 = var_30_15:getTextBoxSize()
		
		if var_30_16.y - var_30_17.height <= 0 then
			arg_30_3:setPositionY(arg_30_3:getPositionY() + (var_30_16.y - var_30_17.height) * -1)
		end
		
		local var_30_18 = arg_30_3:getChildByName("n_top_info")
		local var_30_19 = arg_30_3:getChildByName("top_bg")
		
		if get_cocos_refid(var_30_18) and get_cocos_refid(var_30_19) then
			local var_30_20 = var_30_18:getWorldPosition()
			
			if var_30_20.y > DESIGN_HEIGHT then
				arg_30_3:setPositionY(arg_30_3:getPositionY() - (var_30_20.y - DESIGN_HEIGHT + 10))
			end
		end
	end
end

function WidgetUtils.showPopup(arg_31_0, arg_31_1)
	set_high_fps_tick()
	
	local var_31_0 = arg_31_1.popup
	local var_31_1 = arg_31_1.control
	local var_31_2 = string.lower(arg_31_1.style or "fade")
	local var_31_3 = var_0_0[var_31_2]
	
	SceneManager:getRunningPopupScene():addChildLast(var_31_0)
	var_31_3.open(var_31_0, arg_31_1)
	BackButtonManager:push({
		check_id = "WidgetUtils.showPopup",
		back_func = function()
			var_31_3.close(var_31_0, arg_31_1)
			BackButtonManager:pop("WidgetUtils.showPopup")
		end
	})
	
	local function var_31_4(arg_33_0, arg_33_1)
		print("_onTouchEvent")
		
		local var_33_0 = cc.Director:getInstance():getEventDispatcher()
		local var_33_1 = arg_33_1:getEventListener()
		
		if cc.EventCode.ENDED == arg_33_1:getEventCode() or cc.EventCode.CANCELLED == arg_33_1:getEventCode() then
			var_33_0:removeEventListener(var_33_1)
		end
	end
	
	var_31_0:getChildByName("btn_close"):addTouchEventListener(function(arg_34_0, arg_34_1)
		if arg_34_1 == 2 then
			if TutorialGuide:isPlayingTutorial("tuto_adin_awake_3") then
				return 
			end
			
			if UIAction:Find("tooltip_close") then
				return 
			end
			
			var_31_3.close(var_31_0, arg_31_1)
			BackButtonManager:pop("WidgetUtils.showPopup")
		end
	end)
end

function WidgetUtils.showTooltip(arg_35_0, arg_35_1)
	if UIAction:Find("showing_tooptip") then
		return 
	end
	
	if not get_cocos_refid(arg_35_0.show_tooltip_widget) then
		arg_35_0.show_tooltip_widget = nil
		arg_35_0.is_show_tooltip = false
	end
	
	if arg_35_0.is_show_tooltip then
		return 
	end
	
	arg_35_0.is_show_tooltip = true
	
	set_high_fps_tick()
	
	local var_35_0 = arg_35_1.tooltip
	
	UIAction:Add(SEQ(DELAY(1)), var_35_0, "showing_tooptip")
	
	arg_35_0.show_tooltip_widget = var_35_0
	
	local var_35_1 = arg_35_1.control
	local var_35_2 = string.lower(arg_35_1.style or "fade")
	local var_35_3 = arg_35_1.adjust_x or 0
	local var_35_4 = arg_35_1.adjust_y or 0
	
	if arg_35_1.pos then
		var_35_0:setPosition(arg_35_1.pos.x, arg_35_1.pos.y)
	elseif var_35_1 then
		if not var_35_1:isVisible() then
			return 
		end
		
		local var_35_5 = var_35_1:convertToWorldSpace({
			x = 0,
			y = 0
		})
		
		var_35_5.x = var_35_5.x + var_35_3
		var_35_5.y = var_35_5.y + var_35_4
		
		arg_35_0:placeTooltipPosition(var_35_1:getContentSize(), var_35_5, var_35_0)
	else
		arg_35_0:placeTooltipPosition({
			width = 0,
			height = 0
		}, {
			x = 0,
			y = 0
		}, var_35_0)
	end
	
	local var_35_6 = var_0_0[var_35_2]
	
	SceneManager:getRunningPopupScene():addChildLast(var_35_0)
	
	var_35_0.handleCtrl = var_35_1
	
	var_35_6.open(var_35_0, arg_35_1)
	
	local function var_35_7(arg_36_0, arg_36_1)
		local var_36_0 = cc.Director:getInstance():getEventDispatcher()
		local var_36_1 = arg_36_1:getEventListener()
		
		if cc.EventCode.ENDED == arg_36_1:getEventCode() or cc.EventCode.CANCELLED == arg_36_1:getEventCode() then
			var_36_0:removeEventListener(var_36_1)
			var_35_6.close(var_35_0, arg_35_1)
			UIAction:Add(SEQ(DELAY(1)), var_35_0, "showed_tooptip")
		elseif cc.Handler.EVENT_TOUCH_MOVED == arg_36_1:getEventCode() then
		end
	end
	
	local var_35_8 = cc.Director:getInstance():getEventDispatcher()
	local var_35_9 = cc.EventListenerTouchOneByOne:create()
	
	var_35_9:setForceClaimed(true)
	var_35_9:registerScriptHandler(var_35_7, cc.Handler.EVENT_TOUCH_ENDED)
	var_35_9:registerScriptHandler(var_35_7, cc.Handler.EVENT_TOUCH_BEGAN)
	var_35_9:registerScriptHandler(var_35_7, cc.Handler.EVENT_TOUCH_CANCELLED)
	var_35_8:addEventListenerWithFixedPriority(var_35_9, -100)
	
	if arg_35_1.call_by_show and type(arg_35_1.call_by_show) == "function" then
		arg_35_1.call_by_show(var_35_0, var_35_1, arg_35_1)
	end
end

function WidgetUtils.checkCloseToolTip(arg_37_0)
	local var_37_0 = SceneManager:getRunningPopupScene():getChildByName("item_tooltip_simple")
	
	if get_cocos_refid(var_37_0) and var_37_0.handleCtrl and not get_cocos_refid(var_37_0.handleCtrl) then
		var_0_0.fade.close(var_37_0, {})
	end
end

function WidgetUtils.createBarProgress(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	local var_38_0 = cc.Sprite:create(arg_38_1)
	local var_38_1 = cc.ProgressTimer:create(var_38_0)
	
	var_38_1:setType(1)
	var_38_1:setMidpoint(arg_38_2)
	var_38_1:setBarChangeRate(arg_38_3)
	
	return var_38_1
end

function WidgetUtils.createCircleProgress(arg_39_0, arg_39_1)
	local var_39_0 = cc.Sprite:create(arg_39_1)
	local var_39_1 = cc.ProgressTimer:create(var_39_0)
	
	var_39_1:setMidpoint(cc.p(0.5, 0.5))
	var_39_1:setType(0)
	var_39_1:setBarChangeRate(cc.p(1, 1))
	var_39_1:setReverseDirection(true)
	
	return var_39_1
end
