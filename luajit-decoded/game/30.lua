UIUserData = UIUserData or {}

local var_0_0 = {}

var_0_0.SINGLE_WSCALE = 1
var_0_0.LINE_HEIGHT = 2
var_0_0.VERTICAL_SCROLL_VIEW = 2
var_0_0.AUTOSIZE_WIDTH = 2
var_0_0.AUTOSIZE_HEIGHT = 2
var_0_0.RICH_LABEL = 2
var_0_0.RELATIVE_X_POS = 3
var_0_0.RELATIVE_Y_POS = 3
var_0_0.MULTI_SCALE_LONG_WORD = 4
var_0_0.MULTI_SCALE = 5
var_0_0.ELLIPSIS = 6
var_0_0.SHAKE = 7
var_0_0.ROTATE = 8

local function var_0_1(arg_1_0, arg_1_1)
	local var_1_0 = debug.getinfo(2, "Snl").currentline or ""
	
	Log.e("user_data", string.format("L%s, %s, %s에서 %s node를 찾을 수 없습니다.", var_1_0, SceneManager:getCurrentSceneName(), getNodePath(arg_1_0), arg_1_1))
end

local function var_0_2(arg_2_0, arg_2_1)
	if not arg_2_1.userdata_affect_nodes then
		return 
	end
	
	if table.find(arg_2_1.userdata_affect_nodes, arg_2_0) then
		return true
	end
	
	for iter_2_0, iter_2_1 in pairs(arg_2_1.userdata_affect_nodes) do
		if var_0_2(arg_2_0, iter_2_1) then
			return true
		end
	end
	
	return false
end

local function var_0_3(arg_3_0, arg_3_1)
	arg_3_0.userdata_affect_nodes = arg_3_0.userdata_affect_nodes or {}
	
	table.appendIfNotExist(arg_3_0.userdata_affect_nodes, arg_3_1)
end

local function var_0_4(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	arg_4_1 = (arg_4_1 or 0) + arg_4_0:getPositionX()
	arg_4_2 = (arg_4_2 or 0) + arg_4_0:getPositionY()
	arg_4_3 = (arg_4_3 or 1) * arg_4_0:getScaleX()
	arg_4_4 = (arg_4_4 or 1) * arg_4_0:getScaleY()
	
	local var_4_0 = arg_4_0:getAnchorPoint()
	local var_4_1 = arg_4_0:getContentSize().width * arg_4_3
	local var_4_2 = arg_4_0:getContentSize().height * arg_4_4
	local var_4_3 = {
		left = arg_4_1 - var_4_0.x * var_4_1,
		right = arg_4_1 + (1 - var_4_0.x) * var_4_1,
		bottom = arg_4_2 - var_4_0.y * var_4_2,
		top = arg_4_2 + (1 - var_4_0.y) * var_4_2
	}
	
	for iter_4_0, iter_4_1 in pairs(arg_4_0:getChildren()) do
		local var_4_4 = var_0_4(iter_4_1, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		
		if var_4_4.left < var_4_3.left then
			var_4_3.left = var_4_4.left
		end
		
		if var_4_3.right < var_4_4.right then
			var_4_3.right = var_4_4.right
		end
		
		if var_4_4.bottom < var_4_3.bottom then
			var_4_3.bottom = var_4_4.bottom
		end
		
		if var_4_3.top < var_4_4.top then
			var_4_3.top = var_4_4.top
		end
	end
	
	return var_4_3
end

local var_0_5 = {
	RICH_LABEL = function(arg_5_0)
		if not get_cocos_refid(arg_5_0) then
			return 
		end
		
		if tolua.type(arg_5_0) ~= "ccui.Text" then
			return 
		end
		
		local var_5_0 = arg_5_0.user_data_params.RICH_LABEL
		local var_5_1 = var_5_0[1] and string.lower(var_5_0[1]) ~= "false"
		local var_5_2 = arg_5_0:getString()
		local var_5_3 = upgradeLabelToRichLabel(arg_5_0, nil, var_5_1)
		
		var_5_3:ignoreContentAdaptWithSize(arg_5_0:isIgnoreContentAdaptWithSize())
		var_5_3:setString(var_5_2)
		UIUserData:proc(var_5_3)
	end,
	SHAKE = function(arg_6_0)
		if not get_cocos_refid(arg_6_0) then
			return 
		end
		
		local var_6_0 = arg_6_0.user_data_params.SHAKE
		local var_6_1 = var_6_0[3] and to_n(var_6_0[3])
		local var_6_2 = var_6_0[1] and to_n(var_6_0[1])
		local var_6_3 = var_6_0[2] and to_n(var_6_0[2])
		local var_6_4 = var_6_0[4]
		
		if UIAction:Find("userdata.ani." .. arg_6_0:getName()) then
			UIAction:Remove("userdata.ani." .. arg_6_0:getName())
		end
		
		local var_6_5 = SAVE:getOptionData("notch_setting", "none")
		local var_6_6 = NotchStatus:getDeviceDefaultSetting(var_6_5)
		local var_6_7
		local var_6_8 = var_6_6 == "none" and 0 or NotchManager.vars and NotchManager.vars.isReverse and NotchStatus:getNotchBaseRight() or NotchStatus:getNotchBaseLeft()
		
		if var_6_4 == "true" then
			if var_6_8 then
				UIAction:Add(LOOP(SEQ(MOVE_BY(var_6_1, var_6_8 - -var_6_2 * 0.5, -var_6_3 * 0.5), MOVE_BY(var_6_1, var_6_8 - var_6_2 * 0.5, var_6_3 * 0.5))), arg_6_0, "userdata.ani." .. arg_6_0:getName())
			else
				UIAction:Add(LOOP(SEQ(MOVE_BY(var_6_1, var_6_8 + -var_6_2 * 0.5, -var_6_3 * 0.5), MOVE_BY(var_6_1, var_6_8 + var_6_2 * 0.5, var_6_3 * 0.5))), arg_6_0, "userdata.ani." .. arg_6_0:getName())
			end
		elseif var_6_8 then
			UIAction:Add(SEQ(MOVE_BY(var_6_1, var_6_8 - -var_6_2 * 0.5, -var_6_3 * 0.5), MOVE_BY(var_6_1, var_6_8 - var_6_2 * 0.5, var_6_3 * 0.5)), arg_6_0, "userdata.ani." .. arg_6_0:getName())
		else
			UIAction:Add(SEQ(MOVE_BY(var_6_1, var_6_8 + -var_6_2 * 0.5, -var_6_3 * 0.5), MOVE_BY(var_6_1, var_6_8 + var_6_2 * 0.5, var_6_3 * 0.5)), arg_6_0, "userdata.ani." .. arg_6_0:getName())
		end
	end,
	ROTATE = function(arg_7_0)
		if not get_cocos_refid(arg_7_0) then
			return 
		end
		
		local var_7_0 = arg_7_0.user_data_params.ROTATE
		local var_7_1 = var_7_0[1] and to_n(var_7_0[1])
		local var_7_2 = var_7_0[2] and to_n(var_7_0[2])
		local var_7_3 = var_7_0[3]
		
		if UIAction:Find("userdata.rot." .. arg_7_0:getName()) then
			UIAction:Remove("userdata.rot." .. arg_7_0:getName())
		end
		
		if var_7_3 == "true" then
			UIAction:Add(LOOP(ROTATE(var_7_1, 0, var_7_2)), arg_7_0, "userdata.rot." .. arg_7_0:getName())
		else
			UIAction:Add(ROTATE(var_7_1, 0, var_7_2), arg_7_0, "userdata.rot." .. arg_7_0:getName())
		end
	end,
	SINGLE_WSCALE = function(arg_8_0)
		if not get_cocos_refid(arg_8_0) then
			return 
		end
		
		if tolua.type(arg_8_0) ~= "ccui.Text" and tolua.type(arg_8_0) ~= "ccui.RichText" then
			return 
		end
		
		if not arg_8_0:isIgnoreContentAdaptWithSize() and not PRODUCTION_MODE and not PRODUCTION_MODE then
			Log.e("[SINGLE_WSCALE] '" .. getNodePath(arg_8_0) .. "'의 Custom Size 옵션을 꺼주세요!")
		end
		
		local var_8_0 = arg_8_0.user_data_params.SINGLE_WSCALE
		
		arg_8_0._origin_scale_x = arg_8_0._origin_scale_x or arg_8_0:getScaleX()
		
		local var_8_1 = arg_8_0:getContentSize().width
		
		if tolua.type(arg_8_0) == "ccui.RichText" then
			var_8_1 = arg_8_0:getTextBoxSize().width
		end
		
		local var_8_2 = var_8_0[1] and to_n(var_8_0[1]) or var_8_1 * arg_8_0._origin_scale_x
		local var_8_3 = arg_8_0:getParent()
		
		while var_8_3 do
			if math.abs(var_8_3:getScaleX()) > 1e-05 then
				var_8_2 = var_8_2 / var_8_3:getScaleX()
			end
			
			var_8_3 = var_8_3:getParent()
		end
		
		set_scale_fit_width(arg_8_0, var_8_2)
	end
}

function UIUserData.resetMultiScalePivot(arg_9_0, arg_9_1)
	arg_9_1._origin_scale_x = arg_9_1:getScaleX()
	arg_9_1._origin_scale_y = arg_9_1:getScaleY()
	arg_9_1._origin_size = arg_9_1:getContentSize()
end

function var_0_5.MULTI_SCALE(arg_10_0)
	if not get_cocos_refid(arg_10_0) then
		return 
	end
	
	arg_10_0._origin_size = arg_10_0._origin_size or arg_10_0:getContentSize()
	
	arg_10_0:setContentSize(arg_10_0._origin_size)
	
	arg_10_0._origin_scale_x = arg_10_0._origin_scale_x or arg_10_0:getScaleX()
	
	arg_10_0:setScaleX(arg_10_0._origin_scale_x)
	
	local var_10_0 = arg_10_0.user_data_params.MULTI_SCALE
	local var_10_1 = math.max(1, var_10_0[1] and to_n(var_10_0[1]) or 1)
	local var_10_2 = var_10_0[2] and to_n(var_10_0[2]) or 30
	local var_10_3 = var_10_0[3] and to_n(var_10_0[3]) or 0.01
	
	set_scale_fit_width_multi_line(arg_10_0, var_10_1, var_10_2, var_10_3)
end

function var_0_5.MULTI_SCALE_LONG_WORD(arg_11_0)
	if not get_cocos_refid(arg_11_0) then
		return 
	end
	
	arg_11_0._origin_size = arg_11_0._origin_size or arg_11_0:getContentSize()
	
	arg_11_0:setContentSize(arg_11_0._origin_size)
	
	arg_11_0._origin_scale_x = arg_11_0._origin_scale_x or arg_11_0:getScaleX()
	
	arg_11_0:setScaleX(arg_11_0._origin_scale_x)
	
	local var_11_0 = arg_11_0:getString()
	local var_11_1 = arg_11_0:getContentSize().width * arg_11_0:getScaleX()
	local var_11_2 = string.split(var_11_0, "[ -]", false)
	local var_11_3 = 0
	
	for iter_11_0, iter_11_1 in pairs(var_11_2) do
		arg_11_0:setString(iter_11_1)
		
		var_11_3 = math.max(var_11_3, arg_11_0:getAutoRenderSize().width * arg_11_0:getScaleX())
	end
	
	if var_11_1 < var_11_3 then
		arg_11_0._origin_size = arg_11_0:getContentSize()
		
		arg_11_0:setContentSize({
			width = var_11_3 * (1 / arg_11_0:getScaleX()),
			height = arg_11_0:getContentSize().height
		})
	end
	
	arg_11_0:setString(var_11_0)
	set_scale_fit_width(arg_11_0, var_11_1, var_11_3)
end

function var_0_5.AUTOSIZE_WIDTH(arg_12_0)
	if not get_cocos_refid(arg_12_0) then
		return 
	end
	
	local var_12_0 = arg_12_0.user_data_params.AUTOSIZE_WIDTH
	local var_12_1 = getChildByPath(arg_12_0, var_12_0[1])
	
	if not var_12_1 then
		var_0_1(arg_12_0, var_12_0[1])
		
		return 
	end
	
	var_0_3(var_12_1, arg_12_0)
	
	local var_12_2 = {
		ratio = var_12_0[2] and to_n(var_12_0[2]) or 1,
		add = var_12_0[3] and to_n(var_12_0[3]) or 0,
		min = var_12_0[4] and to_n(var_12_0[4]) or 0,
		max = var_12_0[5] and to_n(var_12_0[5]) or math.huge
	}
	
	set_width_from_node(arg_12_0, var_12_1, var_12_2)
end

function var_0_5.RELATIVE_X_POS(arg_13_0)
	if not get_cocos_refid(arg_13_0) then
		return 
	end
	
	local var_13_0 = arg_13_0.user_data_params.RELATIVE_X_POS
	local var_13_1 = getChildByPath(arg_13_0, var_13_0[1])
	
	if not var_13_1 then
		var_0_1(arg_13_0, var_13_0[1])
		
		return 
	end
	
	var_0_3(var_13_1, arg_13_0)
	
	local var_13_2 = var_13_0[2] and to_n(var_13_0[2]) or 0
	local var_13_3 = var_13_0[3] and to_n(var_13_0[3]) or 0
	local var_13_4 = var_13_1:getContentSize().width * var_13_2 + var_13_3
	
	arg_13_0:setPositionX(var_13_4)
end

function var_0_5.RELATIVE_X_POS_AFFECTED(arg_14_0)
	if not get_cocos_refid(arg_14_0) then
		return 
	end
	
	local var_14_0 = arg_14_0.user_data_params.RELATIVE_X_POS_AFFECTED
	local var_14_1 = getChildByPath(arg_14_0, var_14_0[1])
	
	if not var_14_1 then
		var_0_1(arg_14_0, var_14_0[1])
		
		return 
	end
	
	var_0_3(var_14_1, arg_14_0)
	
	local var_14_2 = var_14_0[2] and to_n(var_14_0[2]) or 0
	local var_14_3 = var_14_0[3] and to_n(var_14_0[3]) or 0
	local var_14_4 = var_14_1:getContentSize().width * var_14_2 + var_14_3
	
	arg_14_0:setPositionX(var_14_4)
end

function var_0_5.AUTOSIZE_HEIGHT(arg_15_0)
	if not get_cocos_refid(arg_15_0) then
		return 
	end
	
	local var_15_0 = arg_15_0.user_data_params.AUTOSIZE_HEIGHT
	local var_15_1 = getChildByPath(arg_15_0, var_15_0[1])
	
	if not var_15_1 then
		var_0_1(arg_15_0, var_15_0[1])
		
		return 
	end
	
	var_0_3(var_15_1, arg_15_0)
	
	local var_15_2 = {
		ratio = var_15_0[2] and to_n(var_15_0[2]) or 1,
		add = var_15_0[3] and to_n(var_15_0[3]) or 0,
		min = var_15_0[4] and to_n(var_15_0[4]) or 0,
		max = var_15_0[5] and to_n(var_15_0[5]) or math.huge
	}
	
	set_height_from_node(arg_15_0, var_15_1, var_15_2)
end

function var_0_5.RELATIVE_Y_POS(arg_16_0)
	if not get_cocos_refid(arg_16_0) then
		return 
	end
	
	local var_16_0 = arg_16_0.user_data_params.RELATIVE_Y_POS
	local var_16_1 = getChildByPath(arg_16_0, var_16_0[1])
	
	if not var_16_1 then
		var_0_1(arg_16_0, var_16_0[1])
		
		return 
	end
	
	var_0_3(var_16_1, arg_16_0)
	
	local var_16_2 = var_16_0[2] and to_n(var_16_0[2]) or 0
	local var_16_3 = var_16_0[3] and to_n(var_16_0[3]) or 0
	local var_16_4 = var_16_1:getContentSize().height * var_16_2 + var_16_3
	
	arg_16_0:setPositionY(var_16_4)
end

function var_0_5.LINE_HEIGHT(arg_17_0)
	if not get_cocos_refid(arg_17_0) then
		return 
	end
	
	local var_17_0 = arg_17_0.user_data_params.LINE_HEIGHT
	local var_17_1 = var_17_0[1] and to_n(var_17_0[1]) or 0
	
	if tolua.type(arg_17_0) == "ccui.Text" then
		arg_17_0:setLineSpacing(var_17_1)
	end
	
	if tolua.type(arg_17_0) == "ccui.RichText" then
		arg_17_0:setVerticalSpace(var_17_1)
	end
end

function var_0_5.OVERFLOW(arg_18_0, arg_18_1)
	if not get_cocos_refid(arg_18_0) then
		return 
	end
	
	if tolua.type(arg_18_0) ~= "ccui.Text" then
		return 
	end
	
	local var_18_0 = arg_18_0.user_data_params.OVERFLOW[1] or 0
	
	if arg_18_0.setOverflow then
		arg_18_0:setOverflow(var_18_0)
	end
end

function var_0_5.LONG_WORD_NUM(arg_19_0)
	if not get_cocos_refid(arg_19_0) then
		return 
	end
	
	if tolua.type(arg_19_0) ~= "ccui.Text" then
		return 
	end
	
	local var_19_0 = arg_19_0.user_data_params.LONG_WORD_NUM
	local var_19_1 = var_19_0[1] and to_n(var_19_0[1]) or 0
	
	UIUtil:updateTextWrapMode(arg_19_0, arg_19_0:getString(), var_19_1)
end

local function var_0_6(arg_20_0)
	if not get_cocos_refid(arg_20_0) then
		Log.e("VERTICAL_SCROLL_VIEW", "node is invalid")
		
		return "_scroll_view"
	end
	
	return arg_20_0:getName() .. "_scroll_view"
end

local function var_0_7(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	local var_21_0 = arg_21_0:getParent()
	
	if not get_cocos_refid(var_21_0) then
		return 
	end
	
	local var_21_1 = {
		width = arg_21_0._origin_scroll_size.width,
		height = arg_21_1
	}
	local var_21_2 = {
		width = var_21_1.width,
		height = var_21_1.height + arg_21_2 - arg_21_3 + arg_21_4
	}
	local var_21_3 = 20
	local var_21_4 = {
		width = arg_21_0._origin_scroll_size.width + var_21_3,
		height = arg_21_0._origin_scroll_size.height + arg_21_2 + arg_21_4
	}
	local var_21_5 = ccui.ScrollView:create()
	
	var_21_5:setName(var_0_6(arg_21_0))
	var_21_5:setAnchorPoint(arg_21_0._origin_anchor_point)
	var_21_5:setPosition(arg_21_0._origin_x, arg_21_0._origin_y + arg_21_2)
	var_21_5:setScale(arg_21_0._origin_scale)
	var_21_5:setContentSize(var_21_4)
	var_21_5:setInnerContainerSize(var_21_2)
	var_21_5:setDirection(1)
	var_21_5:setBounceEnabled(true)
	var_21_5:setScrollBarAutoHideEnabled(true)
	var_21_0:addChild(var_21_5)
	arg_21_0:ejectFromParent()
	var_21_5:addChild(arg_21_0)
	arg_21_0:setAnchorPoint(0, 1)
	arg_21_0:setScale(1)
	arg_21_0:setPosition(0, var_21_1.height)
	
	if tolua.type(arg_21_0) ~= "ccui.RichText" then
		arg_21_0:setContentSize(var_21_2)
	end
	
	arg_21_0.is_inner_scroll_view = true
end

local function var_0_8(arg_22_0)
	local var_22_0 = tolua.type(arg_22_0)
	
	if var_22_0 == "ccui.Text" then
		return arg_22_0:getTextBoxSize().height
	end
	
	if var_22_0 == "ccui.RichText" then
		return arg_22_0:getTextBoxSize().height + arg_22_0:getStringNumLines() * (arg_22_0._getLineSpacing + 2)
	end
	
	if var_22_0 == "ccui.Layout" then
		if arg_22_0.need_inner_scroll_size then
			return arg_22_0.need_inner_scroll_size
		end
		
		local var_22_1 = var_0_4(arg_22_0)
		
		return var_22_1.top - var_22_1.bottom
	end
	
	return 0
end

local function var_0_9(arg_23_0)
	arg_23_0._origin_scroll_size = arg_23_0._origin_scroll_size or arg_23_0:getContentSize()
	arg_23_0._origin_anchor_point = arg_23_0._origin_anchor_point or arg_23_0:getAnchorPoint()
	arg_23_0._origin_scale = arg_23_0._origin_scale or arg_23_0:getScale()
	
	if not arg_23_0._origin_x then
		arg_23_0._origin_x, arg_23_0._origin_y = arg_23_0:getPosition()
	end
end

local function var_0_10(arg_24_0)
	if not arg_24_0._origin_scroll_size then
		return 
	end
	
	arg_24_0:ignoreContentAdaptWithSize(false)
	arg_24_0:setContentSize(arg_24_0._origin_scroll_size)
	arg_24_0:setPosition(arg_24_0._origin_x, arg_24_0._origin_y)
	arg_24_0:setScale(arg_24_0._origin_scale)
	arg_24_0:setAnchorPoint(arg_24_0._origin_anchor_point)
	
	if not get_cocos_refid(arg_24_0:getParent()) then
		return 
	end
	
	if not get_cocos_refid(arg_24_0:getParent():getParent()) then
		return 
	end
	
	local var_24_0 = arg_24_0:getParent():getParent()
	
	if var_24_0:getName() ~= var_0_6(arg_24_0) then
		return 
	end
	
	arg_24_0:ejectFromParent()
	var_24_0:getParent():addChild(arg_24_0)
	var_24_0:removeFromParent()
	
	arg_24_0.is_inner_scroll_view = nil
end

function var_0_5.VERTICAL_SCROLL_VIEW(arg_25_0)
	if not get_cocos_refid(arg_25_0) then
		return 
	end
	
	local var_25_0 = tolua.type(arg_25_0)
	
	if var_25_0 ~= "ccui.Text" and var_25_0 ~= "ccui.RichText" and var_25_0 ~= "ccui.Layout" then
		return 
	end
	
	local var_25_1 = arg_25_0.user_data_params.VERTICAL_SCROLL_VIEW
	local var_25_2 = to_n(var_25_1[1]) or 0
	local var_25_3 = to_n(var_25_1[2]) or 0
	local var_25_4 = to_n(var_25_1[3]) or 0
	
	if (var_25_1[4] or "") == "STRETCH" then
		local var_25_5, var_25_6 = arg_25_0:getPosition()
		local var_25_7 = arg_25_0:getAnchorPoint()
		local var_25_8 = arg_25_0:getContentSize()
		local var_25_9 = get_stretch_ratio(VIEW_WIDTH, DESIGN_WIDTH, var_25_8, arg_25_0:getScale())
		local var_25_10 = var_25_8.width * var_25_9 - var_25_8.width
		
		arg_25_0:setContentSize({
			width = var_25_8.width + var_25_10,
			height = var_25_8.height
		})
		arg_25_0:setPositionX(var_25_5 + var_25_10 * var_25_7.x * arg_25_0:getScale())
	end
	
	var_0_9(arg_25_0)
	var_0_10(arg_25_0)
	
	if tolua.type(arg_25_0) == "ccui.RichText" then
		arg_25_0:formatText()
	end
	
	local var_25_11 = var_0_8(arg_25_0)
	
	if var_25_11 < arg_25_0._origin_scroll_size.height then
		return 
	end
	
	var_0_7(arg_25_0, var_25_11, var_25_2, var_25_3, var_25_4)
end

function var_0_5.ELLIPSIS(arg_26_0)
	if not get_cocos_refid(arg_26_0) then
		return 
	end
	
	local var_26_0 = arg_26_0:getString()
	local var_26_1 = math.floor(arg_26_0:getContentSize().height / arg_26_0:getLineHeight())
	
	if var_26_1 >= arg_26_0:getStringNumLines() then
		return 
	end
	
	local var_26_2 = var_26_0
	local var_26_3 = utf8len(var_26_2)
	
	local function var_26_4()
		var_26_3 = math.floor(var_26_3 * 0.5)
		
		if var_26_3 == 0 then
			var_26_3 = 1
		end
		
		local var_27_0 = var_26_1 < arg_26_0:getStringNumLines() and -var_26_3 or var_26_3
		
		var_26_2 = utf8sub(var_26_0, 1, utf8len(var_26_2) + var_27_0)
		
		arg_26_0:setString(var_26_2)
	end
	
	for iter_26_0 = 1, 5 do
		var_26_4()
	end
	
	while var_26_1 < arg_26_0:getStringNumLines() do
		var_26_4()
	end
	
	arg_26_0:setString(utf8sub(var_26_2, 1, utf8len(var_26_2) - 2) .. "...")
end

function UIUserData.proc(arg_28_0, arg_28_1, arg_28_2)
	if not get_cocos_refid(arg_28_1) then
		return 
	end
	
	if arg_28_1.user_data_procs then
		for iter_28_0, iter_28_1 in pairs(arg_28_1.user_data_procs) do
			iter_28_1(arg_28_1)
		end
	end
	
	arg_28_2 = arg_28_2 or 3
	
	if arg_28_2 == 0 then
		return 
	end
	
	if not arg_28_1.userdata_affect_nodes then
		return 
	end
	
	for iter_28_2, iter_28_3 in pairs(arg_28_1.userdata_affect_nodes) do
		UIUserData:proc(iter_28_3, arg_28_2 - 1)
	end
end

local function var_0_11(arg_29_0)
	local var_29_0, var_29_1 = string.find(arg_29_0, "%b()")
	local var_29_2 = {}
	
	if var_29_0 and var_29_1 then
		local var_29_3 = string.sub(arg_29_0, var_29_0 + 1, var_29_1 - 1)
		
		for iter_29_0, iter_29_1 in pairs(string.split(var_29_3, ",")) do
			var_29_2[iter_29_0] = string.trim(iter_29_1)
		end
	end
	
	return var_29_2
end

local var_0_12 = {}

function UIUserData.procAfterLoadDlg()
	local var_30_0 = (function(arg_31_0, arg_31_1)
		local var_31_0 = {}
		
		for iter_31_0 in pairs(arg_31_0) do
			table.insert(var_31_0, iter_31_0)
		end
		
		table.sort(var_31_0, function(arg_32_0, arg_32_1)
			return arg_31_1(arg_31_0[arg_32_0], arg_31_0[arg_32_1])
		end)
		
		return var_31_0
	end)(var_0_12, function(arg_33_0, arg_33_1)
		return arg_33_0 < arg_33_1
	end)
	
	for iter_30_0, iter_30_1 in ipairs(var_30_0) do
		iter_30_1()
	end
	
	var_0_12 = {}
end

local function var_0_13(arg_34_0, arg_34_1)
	for iter_34_0 in string.gmatch(arg_34_1, "[%u_]+%b()") do
		if not get_cocos_refid(arg_34_0) then
			return 
		end
		
		if not iter_34_0 or iter_34_0 == "" then
			return 
		end
		
		local var_34_0 = string.match(iter_34_0, "^[%u_]+")
		local var_34_1 = var_0_5[var_34_0]
		
		if not var_34_1 then
			Log.e("잘못된 userdata", var_34_0, getNodeLog(arg_34_0))
			
			return 
		end
		
		arg_34_0.user_data_params = arg_34_0.user_data_params or {}
		arg_34_0.user_data_params[var_34_0] = var_0_11(iter_34_0)
		arg_34_0.user_data_procs = arg_34_0.user_data_procs or {}
		arg_34_0.user_data_procs[var_34_0] = var_34_1
	end
end

local function var_0_14(arg_35_0)
	if not arg_35_0 or not get_cocos_refid(arg_35_0) then
		return 
	end
	
	if not arg_35_0.user_data_procs then
		return 
	end
	
	for iter_35_0, iter_35_1 in pairs(arg_35_0.user_data_procs) do
		local function var_35_0()
			if arg_35_0 and get_cocos_refid(arg_35_0) then
				iter_35_1(arg_35_0)
			end
		end
		
		var_0_12[var_35_0] = var_0_0[iter_35_0] or 0
	end
end

function UIUserData.getUserData(arg_37_0, arg_37_1)
	if not get_cocos_refid(arg_37_1) then
		return 
	end
	
	local var_37_0 = arg_37_1:getComponent("ComExtensionData")
	
	if not var_37_0 then
		return 
	end
	
	local var_37_1 = var_37_0:getCustomProperty()
	
	if not var_37_1 then
		return 
	end
	
	if var_37_1 == "" then
		return 
	end
	
	return var_37_1
end

function UIUserData.parse(arg_38_0, arg_38_1)
	local var_38_0 = arg_38_0:getUserData(arg_38_1)
	
	if not var_38_0 then
		return 
	end
	
	var_0_13(arg_38_1, var_38_0)
	var_0_14(arg_38_1)
end

function UIUserData.call(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
	if not get_cocos_refid(arg_39_1) then
		return 
	end
	
	arg_39_3 = arg_39_3 or {}
	
	if arg_39_3.origin_scale_x then
		arg_39_1._origin_scale_x = arg_39_3.origin_scale_x
	end
	
	var_0_13(arg_39_1, arg_39_2)
	arg_39_0:proc(arg_39_1)
end
