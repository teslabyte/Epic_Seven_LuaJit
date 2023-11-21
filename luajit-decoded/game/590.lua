Prologue = {}

local function var_0_0(arg_1_0)
	if tolua.type(arg_1_0) == "ccui.Button" then
		arg_1_0:addTouchEventListener(function(arg_2_0, arg_2_1)
			if arg_2_1 == ccui.TouchEventType.ended then
				local var_2_0 = arg_2_0:getName()
				local var_2_1
				local var_2_2 = string.find(var_2_0, "#")
				
				if var_2_2 then
					local var_2_3 = var_2_0
					
					var_2_0 = string.sub(var_2_3, 1, var_2_2 - 1)
					var_2_1 = string.sub(var_2_3, var_2_2 + 1, -1)
				end
				
				Prologue[var_2_0](Prologue, var_2_1)
			end
		end)
	end
end

function Prologue.show(arg_3_0, arg_3_1)
	print("Prologue show", arg_3_1, get_cocos_refid(arg_3_1))
	arg_3_0:loadPrologueData()
	
	arg_3_0.vars = {}
	arg_3_0.vars.wnd = cc.CSLoader:createNode("prologue/prologue.csb", var_0_0)
	
	arg_3_0.vars.wnd:setCascadeColorEnabled(false)
	arg_3_0:updateOffsetDlg()
	arg_3_1:addChild(arg_3_0.vars.wnd)
	arg_3_0.vars.wnd:setLocalZOrder(1)
	
	arg_3_0.vars.btn_index = arg_3_0.vars.wnd:getChildByName("onPushIndex")
	arg_3_0.vars.btn_left = arg_3_0.vars.wnd:getChildByName("onPushLeft")
	arg_3_0.vars.btn_right = arg_3_0.vars.wnd:getChildByName("onPushRight")
	
	arg_3_0:setContent(1)
	arg_3_0.vars.wnd:runAction(cc.FadeIn:create(0.4))
	
	return arg_3_0.vars.wnd
end

function Prologue.updateOffsetDlg(arg_4_0)
	if not arg_4_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_4_0.vars.wnd) then
		return 
	end
	
	print("Prologue.updateOffsetDlg")
	arg_4_0.vars.wnd:setPosition(VIEW_WIDTH / 2, VIEW_HEIGHT / 2)
	arg_4_0.vars.wnd:findChildByName("dim"):setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
	
	if get_cocos_refid(arg_4_0.vars.content_wnd) then
		local var_4_0 = arg_4_0.vars.content_wnd:findChildByName("n_btn_back")
		
		if get_cocos_refid(var_4_0) then
			var_4_0:setPositionX(VIEW_BASE_LEFT)
		end
	end
end

function Prologue.onPushIndex(arg_5_0)
	arg_5_0:setContent(1)
end

function Prologue.onPushLeft(arg_6_0)
	if arg_6_0.vars.idx > 1 then
		arg_6_0:setContent(arg_6_0.vars.idx - 1)
	end
end

function Prologue.onPushRight(arg_7_0)
	if arg_7_0.prologue_contents[arg_7_0.vars.idx + 1] then
		arg_7_0:setContent(arg_7_0.vars.idx + 1)
	end
end

function Prologue.isVisible(arg_8_0)
	return arg_8_0.vars and get_cocos_refid(arg_8_0.vars.wnd)
end

function Prologue.clear(arg_9_0)
	if arg_9_0:isVisible() then
		arg_9_0.vars.wnd:runAction(cc.FadeOut:create(0.4))
	end
end

function Prologue.setContent(arg_10_0, arg_10_1)
	arg_10_1 = tonumber(arg_10_1)
	
	if arg_10_0.vars.last_time and os.time() < arg_10_0.vars.last_time + 1 then
		return 
	end
	
	if arg_10_0.vars.idx == 1 and arg_10_1 ~= 1 then
		BackButtonManager:push({
			back_func = function()
				BackButtonManager:pop()
				arg_10_0:setContent(1)
			end
		})
	end
	
	if arg_10_1 == 1 then
		BackButtonManager:pop()
	end
	
	arg_10_0.vars.idx = arg_10_1
	arg_10_0.vars.last_time = os.time()
	
	if arg_10_0.vars.content_wnd then
		arg_10_0.vars.content_wnd:runAction(cc.Sequence:create(cc.DelayTime:create(0.3), cc.FadeOut:create(0.2), cc.RemoveSelf:create()))
	end
	
	arg_10_0.vars.btn_left:setVisible(arg_10_1 > 1)
	arg_10_0.vars.btn_right:setVisible(arg_10_1 > 1 and arg_10_0.prologue_contents[arg_10_1 + 1] ~= nil)
	
	if arg_10_0.vars.btn_index then
		arg_10_0.vars.btn_index:setVisible(arg_10_1 ~= 1)
	end
	
	local var_10_0 = arg_10_0.prologue_contents[arg_10_1]
	
	arg_10_0.vars.content_wnd = cc.CSLoader:createNode(var_10_0.dialog or "prologue/prologue_content.csb", var_0_0)
	
	arg_10_0.vars.content_wnd:setOpacity(0)
	arg_10_0.vars.content_wnd:runAction(cc.FadeIn:create(0.5))
	
	local var_10_1 = arg_10_0.vars.content_wnd:findChildByName("n_btn_back")
	
	for iter_10_0, iter_10_1 in pairs(arg_10_0.vars.content_wnd:findChildByName("n_nodes"):getChildren()) do
		if iter_10_1.setString then
			iter_10_1:setString("")
		end
	end
	
	for iter_10_2, iter_10_3 in pairs(var_10_0) do
		if iter_10_2 == "image" then
			local var_10_2 = cc.Sprite:create("prologue/" .. var_10_0.image)
			
			arg_10_0.vars.content_wnd:findChildByName("n_img"):addChild(var_10_2)
		else
			local var_10_3 = arg_10_0.vars.content_wnd:findChildByName(iter_10_2)
			
			if var_10_3 then
				var_10_3:setString(iter_10_3)
			end
			
			if iter_10_2 == "desc_right" then
				local var_10_4 = arg_10_0.vars.content_wnd:findChildByName("grow_right")
				
				if var_10_4 then
					var_10_4:setVisible(true)
				end
			end
		end
	end
	
	local var_10_5 = arg_10_0.vars.content_wnd:findChildByName("txt_back")
	
	if var_10_5 then
		var_10_5:setString(T("pre_texts.prol_back"))
	end
	
	arg_10_0.vars.wnd:findChildByName("n_content"):addChild(arg_10_0.vars.content_wnd)
	arg_10_0:updateOffsetDlg()
end

function Prologue.loadPrologueData(arg_12_0)
	arg_12_0.prologue_contents = {
		{
			dialog = "prologue/prologue_main.csb",
			txt_heroes = T("pre_texts.prol_heroes_desc"),
			txt_world = T("pre_texts.prol_world_desc")
		},
		{
			image = "img_cha_001.png",
			title = T("pre_texts.prol_title_01"),
			sub_title = T("pre_texts.prol_sub_01"),
			desc_right = T("pre_texts.prol_desc_01")
		},
		{
			image = "img_cha_002.png",
			title = T("pre_texts.prol_title_02"),
			sub_title = T("pre_texts.prol_sub_02"),
			desc_right = T("pre_texts.prol_desc_02")
		},
		{
			image = "img_cha_003.png",
			title = T("pre_texts.prol_title_03"),
			sub_title = T("pre_texts.prol_sub_03"),
			desc_right = T("pre_texts.prol_desc_03")
		},
		{
			image = "img_cha_004.png",
			title = T("pre_texts.prol_title_04"),
			sub_title = T("pre_texts.prol_sub_04"),
			desc_right = T("pre_texts.prol_desc_04")
		},
		{
			image = "img_cha_005.png",
			title = T("pre_texts.prol_title_05"),
			sub_title = T("pre_texts.prol_sub_05"),
			desc_right = T("pre_texts.prol_desc_05")
		},
		{
			image = "img_cha_006.png",
			title = T("pre_texts.prol_title_06"),
			sub_title = T("pre_texts.prol_sub_06"),
			desc_right = T("pre_texts.prol_desc_06")
		},
		{
			image = "img_cha_007.png",
			title = T("pre_texts.prol_title_07"),
			sub_title = T("pre_texts.prol_sub_07"),
			desc_right = T("pre_texts.prol_desc_07")
		},
		{
			image = "img_world_001.png",
			title = T("pre_texts.prol_title_08"),
			desc_center = T("pre_texts.prol_desc_08")
		},
		{
			image = "img_world_002.png",
			title = T("pre_texts.prol_title_09"),
			desc_center = T("pre_texts.prol_desc_09")
		},
		{
			image = "img_world_003.png",
			title = T("pre_texts.prol_title_10"),
			desc_center = T("pre_texts.prol_desc_10")
		},
		{
			image = "img_world_004.png",
			title = T("pre_texts.prol_title_11"),
			desc_center = T("pre_texts.prol_desc_11")
		},
		{
			image = "img_world_005.png",
			title = T("pre_texts.prol_title_12"),
			desc_center = T("pre_texts.prol_desc_12")
		},
		{
			image = "img_world_006.png",
			title = T("pre_texts.prol_title_13"),
			desc_center = T("pre_texts.prol_desc_13")
		}
	}
end
