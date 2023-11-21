local function var_0_0(arg_1_0)
	return tonumber(string.sub(arg_1_0, 1, 2), 16), tonumber(string.sub(arg_1_0, 3, 4), 16), tonumber(string.sub(arg_1_0, 5, 6), 16)
end

local function var_0_1(arg_2_0, arg_2_1)
	local var_2_0 = string.find(arg_2_0, ">", arg_2_1)
	
	if not var_2_0 or var_2_0 - arg_2_1 > 8 then
		return nil, string.len(arg_2_0)
	end
	
	return string.sub(arg_2_0, arg_2_1 + 1, var_2_0 - 1), var_2_0 + 1
end

local function var_0_2(arg_3_0, arg_3_1)
	if table.count(arg_3_0._colorStack) == 0 then
		return 
	end
	
	local var_3_0 = string.split(arg_3_1, "\n")
	
	for iter_3_0, iter_3_1 in pairs(var_3_0) do
		if iter_3_0 > 1 then
			local var_3_1 = ccui.RichElementNewLine:create(0, arg_3_0._colorStack[#arg_3_0._colorStack], 1)
			
			arg_3_0:pushBackElement(var_3_1)
			table.insert(arg_3_0._elements, var_3_1)
		end
		
		local var_3_2 = ccui.RichElementText:create(0, arg_3_0._colorStack[#arg_3_0._colorStack], 255, iter_3_1, arg_3_0._fontName, arg_3_0._fontSize, arg_3_0._outlineColor, arg_3_0._outlineSize, arg_3_0._flags)
		
		arg_3_0:pushBackElement(var_3_2)
		table.insert(arg_3_0._elements, var_3_2)
		
		arg_3_0.last_text = iter_3_1
	end
end

local function var_0_3(arg_4_0, arg_4_1)
	local var_4_0 = ccui.RichElementImage:create(0, cc.c3b(255, 255, 255), 255, arg_4_1)
	
	arg_4_0:pushBackElement(var_4_0)
	table.insert(arg_4_0._elements, var_4_0)
end

local function var_0_4(arg_5_0, arg_5_1)
	local var_5_0 = string.sub(arg_5_1, 1, 1)
	
	if var_5_0 == "/" then
		if table.count(arg_5_0._colorStack) > 1 then
			table.remove(arg_5_0._colorStack, #arg_5_0._colorStack)
		end
	elseif var_5_0 == "#" then
		table.push(arg_5_0._colorStack, cc.c3b(var_0_0(string.sub(arg_5_1, 2, 7))))
	elseif var_5_0 == "b" then
		arg_5_0._flags = 2
	elseif string.sub(arg_5_1, 1, 3) == "＃" then
		table.push(arg_5_0._colorStack, cc.c3b(var_0_0(string.sub(arg_5_1, 4, 9))))
	else
		arg_5_0:pushImageElement(arg_5_1)
	end
end

local function var_0_5(arg_6_0, arg_6_1)
	if arg_6_0._prevText == arg_6_1 then
		return 
	end
	
	arg_6_0._colorStack = {
		arg_6_0._textColor
	}
	
	for iter_6_0, iter_6_1 in pairs(arg_6_0._elements) do
		arg_6_0:removeElement(iter_6_1)
	end
	
	arg_6_0._elements = {}
	
	local var_6_0 = 1
	local var_6_1 = string.len(arg_6_1)
	
	local function var_6_2(arg_7_0)
		local var_7_0 = string.find(arg_6_1, "<", arg_7_0)
		local var_7_1
		local var_7_2
		
		if var_7_0 then
			var_7_1, var_7_2 = var_0_1(arg_6_1, var_7_0)
			
			if not var_7_1 then
				var_7_1, var_7_0, var_7_2 = var_6_2(arg_7_0 + 1)
			end
		end
		
		return var_7_1, var_7_0, var_7_2
	end
	
	while var_6_0 <= var_6_1 do
		local var_6_3, var_6_4, var_6_5 = var_6_2(var_6_0)
		
		if var_6_3 then
			if var_6_0 ~= var_6_4 then
				arg_6_0:pushTextElement(string.sub(arg_6_1, var_6_0, var_6_4 - 1))
			end
			
			arg_6_0:procTag(var_6_3)
			
			var_6_0 = var_6_5
		else
			if var_6_0 <= var_6_1 then
				arg_6_0:pushTextElement(string.sub(arg_6_1, var_6_0, var_6_1))
			end
			
			break
		end
	end
	
	arg_6_0:formatText()
	
	arg_6_0._prevText = arg_6_1
end

local function var_0_6(arg_8_0, arg_8_1)
	return arg_8_0._prevText or ""
end

local function var_0_7(arg_9_0, arg_9_1)
	arg_9_0:setVerticalSpace(arg_9_1)
	arg_9_0:formatText()
end

local function var_0_8(arg_10_0, arg_10_1)
	arg_10_0:setWrapMode(arg_10_1 and cc.LINE_BREAK_MODE_CHARACTER_WRAP or cc.LINE_BREAK_MODE_WORD_WRAP)
end

local function var_0_9(arg_11_0)
	arg_11_0.setString = var_0_5
	arg_11_0.getString = var_0_6
	arg_11_0.pushTextElement = var_0_2
	arg_11_0.pushImageElement = var_0_3
	arg_11_0.procTag = var_0_4
	arg_11_0.getStringNumLines = arg_11_0.getLineCount
	arg_11_0.setLineSpacing = var_0_7
	
	function arg_11_0.getFontName(arg_12_0)
		return arg_12_0._fontName
	end
	
	function arg_11_0.getFontSize(arg_13_0)
		return arg_13_0._fontSize
	end
	
	arg_11_0.setLineBreakWithoutSpace = var_0_8
end

local function var_0_10(arg_14_0, arg_14_1)
	arg_14_1 = arg_14_1 or {}
	
	arg_14_0:setWrapMode(cc.LINE_BREAK_MODE_WORD_WRAP)
	arg_14_0:setCascadeOpacityEnabled(true)
	arg_14_0:ignoreContentAdaptWithSize(false)
	
	arg_14_0._outlineSize = 1
	arg_14_0._fontSize = 24
	arg_14_0._elements = {}
	arg_14_0._flags = 0
	arg_14_0._outlineColor = arg_14_1.outline_color or cc.c4b(255, 255, 255, 30)
	arg_14_0._textColor = arg_14_1.color or cc.c4b(96, 61, 42, 255)
	arg_14_0._fontName = arg_14_1.font or "font/daum.ttf"
	
	var_0_9(arg_14_0)
end

local function var_0_11(arg_15_0, arg_15_1, arg_15_2)
	arg_15_0._origin_x = arg_15_1._origin_x
	arg_15_0._origin_y = arg_15_1._origin_y
	arg_15_0._origin_scale = arg_15_1._origin_scale
	arg_15_0._origin_scale_x = arg_15_1._origin_scale_x
	arg_15_0._origin_scale_y = arg_15_1._origin_scale_y
	arg_15_0._origin_size = arg_15_1._origin_size
	arg_15_0._origin_scroll_size = arg_15_1._origin_scroll_size
	arg_15_0._origin_anchor_point = arg_15_1._origin_anchor_point
	
	if tolua.type(arg_15_1) == "ccui.RichText" then
		arg_15_0._textHorizontalAlignment = arg_15_1._textHorizontalAlignment
		arg_15_0._textVerticalAlignment = arg_15_1._textVerticalAlignment
		arg_15_0._outlineColor = arg_15_1._outlineColor
		arg_15_0._outlineSize = arg_15_1._outlineSize
		arg_15_0._textColor = arg_15_1._textColor
		arg_15_0._fontName = arg_15_1._fontName
		arg_15_0._fontSize = arg_15_1._fontSize
		arg_15_0._getLineSpacing = arg_15_1._getLineSpacing
		arg_15_0.user_data = arg_15_1.user_data
		
		arg_15_0:setWrapMode(arg_15_1:getWrapMode())
	else
		arg_15_0._textHorizontalAlignment = arg_15_1:getTextHorizontalAlignment()
		arg_15_0._textVerticalAlignment = arg_15_1:getTextVerticalAlignment()
		
		local var_15_0 = cc.c4b(255, 255, 255, 0)
		
		arg_15_0._outlineColor = arg_15_2 and var_15_0 or arg_15_1:getEffectColor()
		arg_15_0._outlineSize = arg_15_1:getOutlineSize()
		arg_15_0._textColor = arg_15_1:getTextColor()
		arg_15_0._fontName = arg_15_1:getFontName()
		arg_15_0._fontSize = arg_15_1:getFontSize()
		arg_15_0._getLineSpacing = arg_15_1:getLineSpacing()
		
		local var_15_1 = arg_15_1:getComponent("ComExtensionData")
		
		if var_15_1 then
			arg_15_0.user_data = var_15_1:getCustomProperty()
			arg_15_0.user_data = arg_15_0.user_data:gsub("(.*)(RICH_LABEL%b())(.*)", "%1%3")
		end
	end
	
	arg_15_0:setContentSize(arg_15_1:getContentSize())
	arg_15_0:setScaleX(arg_15_1:getScaleX())
	arg_15_0:setScaleY(arg_15_1:getScaleY())
	arg_15_0:setPosition(arg_15_1:getPosition())
	arg_15_0:setAnchorPoint(arg_15_1:getAnchorPoint())
	arg_15_0:setName(arg_15_1:getName())
	arg_15_0:setOpacity(arg_15_1:getOpacity())
	arg_15_0:ignoreContentAdaptWithSize(arg_15_1:isIgnoreContentAdaptWithSize())
	arg_15_0:setAlignment(arg_15_0._textHorizontalAlignment, arg_15_0._textVerticalAlignment)
	arg_15_0:setVerticalSpace(arg_15_0._getLineSpacing)
	
	if arg_15_0.user_data then
		UIUserData:call(arg_15_0, arg_15_0.user_data)
	end
end

function createRichLabel(arg_16_0)
	arg_16_0 = arg_16_0 or {}
	
	local var_16_0 = ccui.RichText:create()
	
	var_0_10(var_16_0, arg_16_0)
	
	return var_16_0
end

function upgradeLabelToRichLabel(arg_17_0, arg_17_1, arg_17_2)
	if not get_cocos_refid(arg_17_0) then
		return 
	end
	
	local var_17_0 = arg_17_1 == nil and arg_17_0 or arg_17_0:getChildByName(arg_17_1)
	
	if not get_cocos_refid(var_17_0) then
		return 
	end
	
	if tolua.type(var_17_0) == "ccui.RichText" then
		return var_17_0
	end
	
	local var_17_1 = createRichLabel()
	
	var_0_11(var_17_1, var_17_0, arg_17_2)
	
	local var_17_2 = var_17_0:getChildren()
	
	for iter_17_0, iter_17_1 in pairs(var_17_2) do
		iter_17_1:ejectFromParent()
		var_17_1:addChild(iter_17_1)
	end
	
	var_17_0:getParent():addChild(var_17_1)
	var_17_0:removeFromParent()
	
	return var_17_1
end

function cloneRichLabel(arg_18_0)
	if not get_cocos_refid(arg_18_0) then
		return 
	end
	
	if tolua.type(arg_18_0) ~= "ccui.RichText" then
		return arg_18_0
	end
	
	local var_18_0 = createRichLabel()
	
	var_0_11(var_18_0, arg_18_0)
	
	local var_18_1 = arg_18_0:getChildren()
	
	for iter_18_0, iter_18_1 in pairs(var_18_1) do
		var_18_0:addChild(iter_18_1:clone())
	end
	
	if_set(var_18_0, nil, arg_18_0:getString())
	
	return var_18_0
end
