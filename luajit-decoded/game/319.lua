GachaResultShare = GachaResultShare or {}
GachaResultShare.vars = {}

function HANDLER.gacha_result_share(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_back" then
		GachaResultShare:close()
		
		return 
	end
	
	if arg_1_1 == "btn_qq" then
		GachaResultShare:doShare(ZLONG_SHARE_PLATFORM.QQ)
		
		return 
	end
	
	if arg_1_1 == "btn_wechat" then
		GachaResultShare:doShare(ZLONG_SHARE_PLATFORM.WE_CHAT_MOMENTS)
		
		return 
	end
	
	if arg_1_1 == "btn_wechatf" then
		GachaResultShare:doShare(ZLONG_SHARE_PLATFORM.WE_CHAT)
		
		return 
	end
	
	if arg_1_1 == "btn_weibo" then
		GachaResultShare:doShare(ZLONG_SHARE_PLATFORM.SINA_WEIBO)
		
		return 
	end
end

local var_0_0 = "gacha_share.png"
local var_0_1 = 800

local function var_0_2(arg_2_0, arg_2_1, arg_2_2)
	for iter_2_0, iter_2_1 in pairs(arg_2_1) do
		local var_2_0 = getChildByPath(arg_2_0, iter_2_1.path)
		
		if get_cocos_refid(var_2_0) and var_2_0:isVisible() then
			if iter_2_1.action == "hide" then
				UIAction:Add(SEQ(FADE_IN(arg_2_2)), var_2_0, "block")
			elseif iter_2_1.action == "move" then
				UIAction:Add(LOG(MOVE_BY(arg_2_2, 0, -50)), var_2_0, "block")
			end
		end
	end
end

local function var_0_3(arg_3_0, arg_3_1, arg_3_2)
	for iter_3_0, iter_3_1 in pairs(arg_3_1) do
		local var_3_0 = getChildByPath(arg_3_0, iter_3_1.path)
		
		if get_cocos_refid(var_3_0) and var_3_0:isVisible() then
			if iter_3_1.action == "hide" then
				UIAction:Add(SEQ(FADE_OUT(arg_3_2)), var_3_0, "block")
			elseif iter_3_1.action == "move" then
				UIAction:Add(LOG(MOVE_BY(arg_3_2, 0, 50)), var_3_0, "block")
			end
		end
	end
end

function GachaResultShare.doShare(arg_4_0, arg_4_1)
	if not arg_4_0.vars.captured_file_path then
		return 
	end
	
	if not arg_4_0.vars.thumbnail_file_path then
		return 
	end
	
	Zlong:doShare(arg_4_0.vars.captured_file_path, arg_4_0.vars.thumbnail_file_path, arg_4_1)
end

function GachaResultShare.close(arg_5_0)
	if not get_cocos_refid(arg_5_0.vars.dlg) then
		return 
	end
	
	arg_5_0.vars.captured_file_path = nil
	
	var_0_2(arg_5_0.vars.parent, arg_5_0.vars.play_node_infos, 300)
	UIAction:Add(SEQ(FADE_OUT(300), REMOVE()), arg_5_0.vars.dlg, "block")
	BackButtonManager:pop({
		check_id = "gacha_result_share",
		dlg = arg_5_0.vars.dlg
	})
	arg_5_0.vars.dlg:removeFromParent()
	
	arg_5_0.vars = nil
end

function GachaResultShare.click(arg_6_0)
	if not get_cocos_refid(arg_6_0.vars.dlg) then
		return 
	end
	
	local var_6_0 = arg_6_0.vars.dlg:getChildByName("img_white")
	
	if not get_cocos_refid(var_6_0) then
		return 
	end
	
	SoundEngine:play("event:/ui/gocha_share_effect")
	if_set_visible(var_6_0, nil, true)
	if_set_opacity(var_6_0, nil, 0)
	UIAction:Add(SEQ(LOG(FADE_IN(var_0_1 * 0.1)), FADE_OUT(var_0_1 * 0.5), SHOW(false)), var_6_0, "block")
end

function GachaResultShare.setAccountInfo(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	if not get_cocos_refid(arg_7_1) then
		return 
	end
	
	if_set(arg_7_1, "t_user_name", arg_7_2)
	
	local var_7_0 = arg_7_1:getChildByName("n_lv")
	
	if get_cocos_refid(var_7_0) then
		UIUtil:setLevel(var_7_0, arg_7_3, MAX_ACCOUNT_LEVEL, 3, false, nil, 19)
	end
end

function GachaResultShare.onEndCapture(arg_8_0)
	if not get_cocos_refid(arg_8_0.vars.dlg) then
		return 
	end
	
	local var_8_0 = arg_8_0.vars.dlg:getChildByName("n_info")
	
	if get_cocos_refid(var_8_0) then
		local var_8_1 = var_8_0:getPositionX()
		local var_8_2 = var_8_0.origin_pos_y
		local var_8_3, var_8_4 = var_8_0:getPosition()
		
		UIAction:AddSmooth(LOG(MOVE(500, var_8_3, var_8_4, var_8_1, var_8_2, true), 3000), var_8_0, "block")
	end
	
	local var_8_5 = arg_8_0.vars.dlg:getChildByName("n_bottom")
	
	if get_cocos_refid(var_8_5) then
		if_set_visible(var_8_5, nil, true)
		
		local var_8_6, var_8_7 = var_8_5:getPosition()
		local var_8_8 = var_8_6
		local var_8_9 = var_8_7 - 89
		
		UIAction:AddSmooth(LOG(MOVE(500, var_8_8, var_8_9, var_8_6, var_8_7, true), 3000), var_8_5, "block")
	end
end

function GachaResultShare.open(arg_9_0, arg_9_1, arg_9_2)
	if not IS_PUBLISHER_ZLONG then
		return 
	end
	
	if not get_cocos_refid(arg_9_1) then
		return 
	end
	
	arg_9_0.vars = {}
	arg_9_0.vars.parent = arg_9_1
	arg_9_0.vars.play_node_infos = arg_9_2
	
	var_0_3(arg_9_0.vars.parent, arg_9_0.vars.play_node_infos, var_0_1 * 0.5)
	
	arg_9_0.vars.dlg = load_dlg("gacha_result_share", true, "wnd", function()
		arg_9_0:close()
	end)
	
	if not get_cocos_refid(arg_9_0.vars.dlg) then
		return 
	end
	
	arg_9_0.vars.parent:addChild(arg_9_0.vars.dlg)
	if_set_visible(arg_9_0.vars.dlg, "n_bottom", false)
	
	local var_9_0 = arg_9_0.vars.dlg:getChildByName("n_info")
	
	if get_cocos_refid(var_9_0) then
		var_9_0.origin_pos_y = var_9_0.origin_pos_y or var_9_0:getPositionY()
		
		if_set_position_y(var_9_0, nil, var_9_0.origin_pos_y - 89)
		arg_9_0:setAccountInfo(var_9_0, Account:getName(), Account:getLevel())
		if_set_visible(var_9_0, nil, false)
		UIAction:Add(SEQ(SHOW(true), FADE_IN(var_0_1 * 0.5)), var_9_0, "block")
	end
end

local function var_0_4(arg_11_0)
	cc.Director:getInstance():getTextureCache():reloadTexture(arg_11_0)
	
	local var_11_0 = cc.Sprite:create(arg_11_0)
	
	if not get_cocos_refid(var_11_0) then
		return 
	end
	
	local var_11_1 = var_11_0:getContentSize()
	local var_11_2 = var_11_1.width * var_11_1.height
	local var_11_3 = math.sqrt(11000 / var_11_2)
	
	var_11_0:setScale(var_11_3)
	var_11_0:setAnchorPoint(0, 0)
	
	local var_11_4 = cc.RenderTexture:create(math.round(var_11_1.width * var_11_3), math.round(var_11_1.height * var_11_3), cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
	
	if not get_cocos_refid(var_11_4) then
		return 
	end
	
	var_11_4:begin()
	var_11_0:visit()
	var_11_4:endToLua()
	force_render()
	
	local var_11_5, var_11_6 = arg_11_0:match("(.-)([^/\\]+)$")
	local var_11_7 = var_11_6:match("^.+(%..+)$")
	local var_11_8 = var_11_5 .. var_11_6:gsub(var_11_7, "_" .. "thumbnail" .. var_11_7)
	local var_11_9 = var_11_4:newImage()
	
	if not get_cocos_refid(var_11_9) then
		return 
	end
	
	var_11_9:saveToFile(var_11_8)
	
	return var_11_8
end

function GachaResultShare.updateAction(arg_12_0)
	if not arg_12_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_12_0.vars.dlg) then
		return 
	end
	
	if arg_12_0.vars.action and arg_12_0.vars.action.is_finish then
		return 
	end
	
	arg_12_0.vars.action = arg_12_0.vars.action or {}
	arg_12_0.vars.action.time = (arg_12_0.vars.action.time or 0) + cc.Director:getInstance():getDeltaTime()
	
	if not arg_12_0.vars.action.is_delay_before_click then
		if arg_12_0.vars.action.time > 1 then
			arg_12_0.vars.action.is_delay_before_click = true
		end
		
		return 
	end
	
	if not arg_12_0.vars.action.is_clicked then
		arg_12_0:click()
		
		arg_12_0.vars.action.is_clicked = true
		
		return 
	end
	
	if not arg_12_0.vars.action.is_delay_capture then
		if arg_12_0.vars.action.time > 1.6 then
			arg_12_0.vars.action.is_delay_capture = true
		end
		
		return 
	end
	
	if not arg_12_0.vars.action.is_capture then
		cc.utils:captureScreen(function(arg_13_0, arg_13_1)
			if arg_13_0 == false then
				return 
			end
			
			arg_12_0.vars.captured_file_path = arg_13_1
			
			arg_12_0:onEndCapture(arg_13_1)
		end, var_0_0)
		
		arg_12_0.vars.action.is_capture = true
		
		return 
	end
	
	if arg_12_0.vars.captured_file_path then
		arg_12_0.vars.action.delay_frame = (arg_12_0.vars.action.delay_frame or 0) + 1
		
		if arg_12_0.vars.action.delay_frame == 2 then
			arg_12_0.vars.thumbnail_file_path = var_0_4(arg_12_0.vars.captured_file_path)
			arg_12_0.vars.action.is_finish = true
		end
		
		return 
	end
end
