NotchManager = {}
NotchStatus = {}

local var_0_0 = {
	"iPhone10,3",
	"iPhone10,6",
	"iPhone11,2",
	"iPhone11,4",
	"iPhone11,6",
	"iPhone11,8",
	"iPhone12,1",
	"iPhone12,3",
	"iPhone12,5",
	"iPhone13,1",
	"iPhone13,2",
	"iPhone13,3",
	"iPhone13,4",
	"iPhone14,2",
	"iPhone14,3",
	"iPhone14,4",
	"iPhone14,5",
	"iPhone14,7",
	"iPhone14,8",
	"iPhone15,2",
	"iPhone15,3",
	"iPhone15,4",
	"iPhone15,5",
	"iPhone16,1",
	"iPhone16,2"
}
local var_0_1 = {
	"iPhone15,2",
	"iPhone15,3",
	"iPhone15,4",
	"iPhone15,5",
	"iPhone16,1",
	"iPhone16,2"
}

NotchStatus.SOUL_GAUGE_BAR_UP = nil

function NotchStatus.isSourGaugeBarUp(arg_1_0)
	local var_1_0 = IOS_MACHINE_ID
	
	if var_1_0 then
		return table.find(var_0_0, var_1_0)
	end
	
	if arg_1_0.SOUL_GAUGE_BAR_UP == true then
		return true
	end
	
	return false
end

function NotchStatus.is_support_device(arg_2_0)
	local var_2_0 = IOS_MACHINE_ID
	local var_2_1 = ANDROID_MACHINE_ID
	
	if var_2_0 then
		return table.find(var_0_0, var_2_0), "ios"
	elseif var_2_1 then
		return false, "android"
	else
		local var_2_2 = PLATFORM == "win32" and "win32" or "not_defined"
		
		return DEVICE_HEIGHT == 1125 and DEVICE_WIDTH == 2436 or var_2_2 == "win32", var_2_2
	end
	
	return false
end

function NotchStatus.isLeft(arg_3_0)
	local var_3_0 = getenv("device.orientation")
	
	return DEBUG.ORIENTAION_TEST ~= nil and DEBUG.ORIENTAION_TEST or var_3_0 == "landscape_left"
end

NotchStatus.ADJUST_EDGE_VALUE = 15
NotchStatus.ADJUST_EDGE = nil

function NotchStatus.isRequireAdjustEdge(arg_4_0)
	local var_4_0 = IOS_MACHINE_ID
	
	if var_4_0 then
		return table.find(var_0_0, var_4_0)
	end
	
	return NotchStatus.ADJUST_EDGE
end

function NotchStatus.getAdjustEdgeValue(arg_5_0)
	return arg_5_0.ADJUST_EDGE_VALUE
end

function NotchStatus.resetGlobalValues(arg_6_0, arg_6_1)
	if not arg_6_0.vars then
		NotchStatus:settingNotch()
	end
	
	local var_6_0 = NOTCH_WIDTH > 0 and NOTCH_WIDTH / 2 or NOTCH_LEFT_WIDTH / 2
	local var_6_1 = NOTCH_WIDTH / 2
	
	if not arg_6_1 then
		arg_6_0.vars.NOTCH_SAFE_LEFT = var_6_1
		arg_6_0.vars.NOTCH_SAFE_LEFT_ALL = var_6_0
		arg_6_0.vars.NOTCH_SAFE_RIGHT = 0
		arg_6_0.vars.NOTCH_SAFE_RIGHT_ALL = 0
	else
		arg_6_0.vars.NOTCH_SAFE_LEFT = 0
		arg_6_0.vars.NOTCH_SAFE_LEFT_ALL = 0
		arg_6_0.vars.NOTCH_SAFE_RIGHT = -var_6_1
		arg_6_0.vars.NOTCH_SAFE_RIGHT_ALL = -var_6_0
	end
	
	arg_6_0.vars.NOTCH_BASE_LEFT = VIEW_BASE_LEFT + arg_6_0.vars.NOTCH_SAFE_LEFT
	arg_6_0.vars.NOTCH_BASE_RIGHT = VIEW_BASE_RIGHT + arg_6_0.vars.NOTCH_SAFE_RIGHT
	arg_6_0.vars.NOTCH_BASE_LEFT_ALL = VIEW_BASE_LEFT + arg_6_0.vars.NOTCH_SAFE_LEFT_ALL
	arg_6_0.vars.NOTCH_BASE_RIGHT_ALL = VIEW_BASE_RIGHT + arg_6_0.vars.NOTCH_SAFE_RIGHT_ALL
end

function NotchStatus.getNotchSafeLeft(arg_7_0, arg_7_1)
	if not arg_7_0.vars then
		NotchStatus:settingNotch()
	end
	
	if arg_7_1 then
		return arg_7_0.vars.NOTCH_SAFE_LEFT_ALL
	end
	
	return arg_7_0.vars.NOTCH_SAFE_LEFT
end

function NotchStatus.getNotchSafeRight(arg_8_0, arg_8_1)
	if not arg_8_0.vars then
		NotchStatus:settingNotch()
	end
	
	if arg_8_1 then
		return arg_8_0.vars.NOTCH_SAFE_RIGHT_ALL
	end
	
	return arg_8_0.vars.NOTCH_SAFE_RIGHT
end

function NotchStatus.getNotchBaseLeft(arg_9_0, arg_9_1)
	if not arg_9_0.vars then
		NotchStatus:settingNotch()
	end
	
	if arg_9_1 then
		return arg_9_0.vars.NOTCH_BASE_LEFT_ALL
	end
	
	return arg_9_0.vars.NOTCH_BASE_LEFT
end

function NotchStatus.getNotchBaseRight(arg_10_0, arg_10_1)
	if not arg_10_0.vars then
		NotchStatus:settingNotch()
	end
	
	if arg_10_1 then
		return arg_10_0.vars.NOTCH_BASE_RIGHT_ALL
	end
	
	return arg_10_0.vars.NOTCH_BASE_RIGHT
end

function NotchStatus.getDeviceDefaultSetting(arg_11_0, arg_11_1)
	local var_11_0, var_11_1 = arg_11_0:is_support_device()
	local var_11_2 = arg_11_1 or nil
	
	if var_11_0 and var_11_1 == "ios" then
		var_11_2 = "central"
	elseif not var_11_0 then
		var_11_2 = "none"
	end
	
	return var_11_2
end

function NotchStatus.settingNotch(arg_12_0, arg_12_1)
	if not arg_12_0.vars then
		arg_12_0.vars = {}
	end
	
	local var_12_0 = arg_12_1 or SAVE:getOptionData("notch_setting", "none")
	local var_12_1 = arg_12_0:getDeviceDefaultSetting(var_12_0)
	
	if var_12_1 == "corner" then
		NOTCH_LEFT_WIDTH = (0.03333333333333333 * VIEW_WIDTH + 0.013333333333333334 * VIEW_WIDTH) * 2
		NOTCH_WIDTH = 0
	elseif var_12_1 == "central" then
		local var_12_2 = IOS_MACHINE_ID
		
		NOTCH_LEFT_WIDTH = 0
		
		if (function(arg_13_0)
			arg_13_0 = arg_13_0 or IOS_MACHINE_ID
			
			if arg_13_0 then
				return table.find(var_0_1, arg_13_0) ~= nil
			end
			
			return false
		end)(var_12_2) then
			NOTCH_WIDTH = 170
		else
			NOTCH_WIDTH = 120
		end
	else
		NOTCH_WIDTH = 0
		NOTCH_LEFT_WIDTH = 0
	end
	
	arg_12_0:resetGlobalValues(arg_12_0:isLeft())
end

local function var_0_2(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	if arg_14_3 then
		arg_14_0:setAnchorPoint(1, 1)
		arg_14_0:setPosition(VIEW_BASE_RIGHT - VIEW_WIDTH * arg_14_2.x, VIEW_HEIGHT * arg_14_1 + VIEW_HEIGHT * arg_14_2.y)
	else
		arg_14_0:setAnchorPoint(0, 0)
		arg_14_0:setPosition(VIEW_BASE_LEFT + VIEW_WIDTH * arg_14_2.x, VIEW_HEIGHT - VIEW_HEIGHT * arg_14_1 - VIEW_HEIGHT * arg_14_2.y)
	end
end

function NotchManager.reverseOrientaion(arg_15_0)
	if not DEBUG.ORIENTAION_TEST then
		DEBUG.ORIENTAION_TEST = true
	else
		DEBUG.ORIENTAION_TEST = false
	end
end

function NotchManager.reverseNotch(arg_16_0)
	if not get_cocos_refid(arg_16_0.vars.notch_test) then
		return 
	end
	
	arg_16_0.vars.isReverse = not arg_16_0.vars.isReverse
	
	var_0_2(arg_16_0.vars.notch_test, arg_16_0.vars.info.length, arg_16_0.vars.info.gap, arg_16_0.vars.isReverse)
end

function NotchManager.makeNotch(arg_17_0, arg_17_1)
	if not arg_17_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_17_0.vars.notch_test) then
		arg_17_0.vars.notch_test:removeFromParent()
		
		return 
	end
	
	local var_17_0 = SceneManager:getRunningNativeScene()
	local var_17_1 = cc.Sprite:create("img/_white_s.png")
	
	var_17_1:setName("notch")
	var_17_1:setAnchorPoint(0, 0)
	
	local var_17_2 = 0.0625
	local var_17_3 = 0
	local var_17_4 = 0
	local var_17_5 = 0
	local var_17_6 = 0
	
	if arg_17_1 == "infinity_display" then
		var_17_3 = 0.03333333333333333
		var_17_4 = 0.16428571428571428
		var_17_5 = 0.013333333333333334
		var_17_6 = 0.05714285714285715
		
		var_0_2(var_17_1, var_17_4, {
			x = var_17_5,
			y = var_17_6
		}, false)
	elseif arg_17_1 == "iphone_display" then
		var_17_3 = 0.03597122302158273
		var_17_4 = 0.5573333333333333
		var_17_5 = 0
		var_17_6 = 0.22133333333333333
		
		var_0_2(var_17_1, var_17_4, {
			x = var_17_5,
			y = var_17_6
		}, false)
	end
	
	var_17_1:setScaleX(var_17_2 * VIEW_WIDTH * var_17_3)
	var_17_1:setScaleY(var_17_2 * VIEW_HEIGHT * var_17_4)
	var_17_0:addChild(var_17_1)
	var_17_1:bringToFront()
	
	arg_17_0.vars.notch_test = var_17_1
	arg_17_0.vars.info = {
		length = var_17_4,
		gap = {
			x = var_17_5,
			y = var_17_6
		}
	}
	arg_17_0.vars.isReverse = false
end

function NotchManager.findNotchEvent(arg_18_0, arg_18_1)
	if not arg_18_0.vars then
		return 
	end
	
	local var_18_0 = table.find(arg_18_0.vars.events, function(arg_19_0, arg_19_1)
		return arg_19_1.node == arg_18_1
	end)
	
	if not var_18_0 then
		return 
	end
	
	return arg_18_0.vars.events[var_18_0]
end

function NotchManager.only_use_in_action_resetOriginPos(arg_20_0, arg_20_1, arg_20_2)
	if not arg_20_0.vars then
		return 
	end
	
	local var_20_0 = arg_20_0:findNotchEvent(arg_20_1)
	
	if not var_20_0 or not var_20_0.action_reset_origin_pos then
		return 
	end
	
	if var_20_0.before_ui_action == arg_20_2 then
		var_20_0.ui_action_mode = false
	else
		var_20_0.ui_action_mode = true
	end
	
	local var_20_1, var_20_2, var_20_3 = isSameOrientation(arg_20_1)
	
	if var_20_0.ui_action_mode and not var_20_1 then
		local var_20_4 = false
		
		if string.find(var_20_3, "BOT") or string.find(var_20_3, "TOP") then
			var_20_4 = true
		end
		
		arg_20_2 = arg_20_2 + (var_20_2 and -NotchStatus:getNotchSafeRight(var_20_4) or -NotchStatus:getNotchSafeLeft(var_20_4))
	end
	
	var_20_0.origin_x = arg_20_2
end

function NotchManager.setActionResetOriginPos(arg_21_0, arg_21_1, arg_21_2)
	if not arg_21_0.vars then
		return 
	end
	
	local var_21_0 = arg_21_0:findNotchEvent(arg_21_1)
	
	if not var_21_0 then
		return 
	end
	
	var_21_0.action_reset_origin_pos = true
end

function NotchManager.resetOriginPos(arg_22_0, arg_22_1, arg_22_2)
	if not arg_22_0.vars then
		return 
	end
	
	local var_22_0 = arg_22_0:findNotchEvent(arg_22_1)
	
	if not var_22_0 then
		return 
	end
	
	var_22_0.origin_x = arg_22_2
	var_22_0.before_ui_action = arg_22_2
end

function NotchManager.adjustOriginPos(arg_23_0, arg_23_1, arg_23_2)
	if not arg_23_0.vars then
		return 
	end
	
	local var_23_0 = arg_23_0:findNotchEvent(arg_23_1)
	
	if not var_23_0 then
		return 
	end
	
	var_23_0.origin_x = var_23_0.origin_x + arg_23_2
	var_23_0.before_ui_action = var_23_0.origin_x + arg_23_2
end

function NotchManager.resetListener(arg_24_0, arg_24_1)
	if not get_cocos_refid(arg_24_1) then
		return 
	end
	
	if not arg_24_0.vars then
		Log.e("resetListener Failed, Because self.vars was nil.")
		
		return 
	end
	
	local var_24_0 = table.find(arg_24_0.vars.events, function(arg_25_0, arg_25_1)
		return arg_25_1.node == arg_24_1
	end)
	
	if not var_24_0 then
		return 
	end
	
	local var_24_1 = arg_24_0.vars.events[var_24_0]
	
	if var_24_1.callback and arg_24_1:isVisible() then
		var_24_1.callback(arg_24_1, var_24_1.isChild, var_24_1.isLeft, var_24_1.origin_x)
	elseif arg_24_1:isVisible() then
		resetPosForNotch(arg_24_1, var_24_1.isChild, {
			isLeft = var_24_1.isLeft,
			origin_x = var_24_1.origin_x
		})
	end
end

function NotchManager.addListener(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	if not arg_26_0.vars then
		Log.e("addListener Failed, Because self.vars was nil.")
		
		return 
	end
	
	if not get_cocos_refid(arg_26_1) then
		return 
	end
	
	local var_26_0 = table.find(arg_26_0.vars.events, function(arg_27_0, arg_27_1)
		return arg_27_1.node == arg_26_1
	end)
	local var_26_1
	local var_26_2 = arg_26_1:getPositionX()
	
	if var_26_0 then
		var_26_2 = arg_26_0.vars.events[var_26_0].origin_x
		arg_26_0.vars.events[var_26_0] = {
			node = arg_26_1,
			callback = arg_26_0.vars.events[var_26_0].callback or arg_26_3,
			isChild = arg_26_2,
			origin_x = arg_26_0.vars.events[var_26_0].origin_x
		}
		var_26_1 = arg_26_0.vars.events[var_26_0]
	else
		table.insert(arg_26_0.vars.events, {
			node = arg_26_1,
			callback = arg_26_3,
			isChild = arg_26_2,
			origin_x = arg_26_1:getPositionX()
		})
		
		var_26_1 = arg_26_0.vars.events[#arg_26_0.vars.events]
	end
	
	var_26_1.before_ui_action = var_26_1.origin_x
	
	local var_26_3 = NotchStatus:isLeft()
	
	if arg_26_3 then
		arg_26_3(arg_26_1, arg_26_2, var_26_3, var_26_2)
	else
		resetPosForNotch(arg_26_1, arg_26_2, {
			isLeft = var_26_3,
			origin_x = var_26_2
		})
	end
end

function NotchManager.setIgnoreViewBase(arg_28_0, arg_28_1, arg_28_2)
	if not arg_28_0.vars then
		Log.e("addListener Failed, Because self.vars was nil.")
		
		return 
	end
	
	if not get_cocos_refid(arg_28_1) then
		return 
	end
	
	local var_28_0 = table.find(arg_28_0.vars.events, function(arg_29_0, arg_29_1)
		return arg_29_1.node == arg_28_1
	end)
	
	if not var_28_0 then
		return 
	end
	
	arg_28_0.vars.events[var_28_0].isChild = arg_28_2
	
	local var_28_1 = arg_28_0.vars.events[var_28_0]
	local var_28_2 = arg_28_0.vars.events[var_28_0].origin_x
	
	var_28_1.before_ui_action = var_28_1.origin_x
	
	local var_28_3 = NotchStatus:isLeft()
	
	if var_28_1.callback then
		var_28_1.callback(arg_28_1, arg_28_2, var_28_3, var_28_2)
	else
		resetPosForNotch(arg_28_1, arg_28_2, {
			isLeft = var_28_3,
			origin_x = var_28_2
		})
	end
end

local function var_0_3(arg_30_0, arg_30_1)
	if not get_cocos_refid(arg_30_0.node) then
		return true
	end
	
	if arg_30_0.node:isVisible() then
		if arg_30_0.callback then
			arg_30_0.callback(arg_30_0.node, arg_30_0.isChild, arg_30_1, arg_30_0.origin_x)
		else
			resetPosForNotch(arg_30_0.node, arg_30_0.isChild or arg_30_0.ui_action_mode, {
				isLeft = arg_30_1,
				origin_x = arg_30_0.origin_x
			})
		end
		
		return true
	end
	
	return false
end

function NotchManager.visibleEvent(arg_31_0, arg_31_1)
	local var_31_0 = {}
	
	for iter_31_0, iter_31_1 in pairs(arg_31_0.vars.onVisible_events) do
		if var_0_3(iter_31_1, arg_31_1) then
			table.insert(var_31_0, iter_31_0)
		end
	end
	
	for iter_31_2, iter_31_3 in pairs(var_31_0) do
		arg_31_0.vars.onVisible_events[iter_31_3] = nil
	end
end

function NotchManager.notchEvent(arg_32_0, arg_32_1)
	NotchStatus:resetGlobalValues(arg_32_1)
	
	for iter_32_0, iter_32_1 in pairs(arg_32_0.vars.events) do
		if not get_cocos_refid(iter_32_1.node) then
			iter_32_1.del_flag = true
		elseif iter_32_1.callback and iter_32_1.node:isVisible() then
			iter_32_1.callback(iter_32_1.node, iter_32_1.isChild or iter_32_1.ui_action_mode, arg_32_1, iter_32_1.origin_x)
		elseif iter_32_1.node:isVisible() then
			resetPosForNotch(iter_32_1.node, iter_32_1.isChild or iter_32_1.ui_action_mode, {
				isLeft = arg_32_1,
				origin_x = iter_32_1.origin_x
			})
		elseif not iter_32_1.node:isVisible() and not arg_32_0.vars.onVisible_events[iter_32_1] then
			arg_32_0.vars.onVisible_events[iter_32_1] = iter_32_1
		end
	end
	
	for iter_32_2 = #arg_32_0.vars.events, 1, -1 do
		if arg_32_0.vars.events[iter_32_2] and arg_32_0.vars.events[iter_32_2].del_flag then
			table.remove(arg_32_0.vars.events, iter_32_2)
		end
	end
end

function NotchManager.event(arg_33_0, arg_33_1)
	if not arg_33_0.vars then
		return 
	end
	
	local var_33_0 = NotchStatus:isLeft()
	
	arg_33_0:visibleEvent(var_33_0)
	
	if not arg_33_1 and arg_33_0.vars.prv_isLeft == var_33_0 then
		return 
	end
	
	arg_33_0:notchEvent(var_33_0)
	
	arg_33_0.vars.prv_isLeft = var_33_0
end

function NotchManager.init(arg_34_0)
	arg_34_0.vars = {}
	arg_34_0.vars.prv_isLeft = nil
	arg_34_0.vars.events = {}
	arg_34_0.vars.onVisible_events = {}
	
	NotchStatus:settingNotch()
	print("NOTCH EVENTS CLEARED!")
end
