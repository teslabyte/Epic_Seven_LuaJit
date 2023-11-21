LotaMinimapPingRenderer = {}

copy_functions(LotaPingRenderer, LotaMinimapPingRenderer)

function LotaMinimapPingRenderer.init(arg_1_0, arg_1_1)
	arg_1_0.vars = {}
	arg_1_0.vars.ping_layer = arg_1_1
	arg_1_0.vars.ping_sprite_data = {}
	arg_1_0.vars.y_gap = 0
	arg_1_0.vars.tile_width = 42
	arg_1_0.vars.tile_height = 70
	arg_1_0.vars.adj_x = 12
	arg_1_0.vars.adj_y = 0
	arg_1_0.vars.use_on_minimap = true
end

function LotaMinimapPingRenderer.resetParent(arg_2_0, arg_2_1)
	arg_2_0.vars.ping_layer:ejectFromParent()
	arg_2_1:addChild(arg_2_0.vars.ping_layer)
end

function LotaMinimapPingRenderer.hideMemo(arg_3_0, arg_3_1)
	if not arg_3_0.vars then
		return 
	end
	
	arg_3_1 = arg_3_1 or arg_3_0.vars.memo_show_ping
	
	if not get_cocos_refid(arg_3_1) then
		return 
	end
	
	if not arg_3_1._is_memo then
		return 
	end
	
	local var_3_0 = arg_3_1:findChildByName("n_memo")
	local var_3_1 = arg_3_1:findChildByName("n_tag")
	
	if UIAction:Find("ping_fade_in") then
		UIAction:Remove("ping_fade_in")
	end
	
	var_3_0:setVisible(true)
	var_3_1:setVisible(true)
	var_3_1:setScale(0.01)
	var_3_1:setOpacity(255)
	UIAction:Add(SPAWN(TARGET(var_3_0, SEQ(LOG(SCALE_TO(100, 0.01)), SHOW(false))), TARGET(var_3_1, SEQ(LOG(SCALE_TO(100, 1))))), arg_3_1, "ping_fade_out")
	
	if arg_3_1 == arg_3_0.vars.memo_show_ping then
		arg_3_0.vars.memo_show_ping = nil
	end
	
	arg_3_1._is_memo = false
end

function LotaMinimapPingRenderer.addPing(arg_4_0, arg_4_1)
	local var_4_0 = LotaPingRenderer.addPing(arg_4_0, arg_4_1)
	local var_4_1 = var_4_0:getChildByName("btn_memo")
	
	if not var_4_1 then
		print("not btn_memo")
		
		return 
	end
	
	if_set_visible(var_4_1, nil, true)
	var_4_1:addTouchEventListener(function(arg_5_0, arg_5_1)
		if arg_5_1 == ccui.TouchEventType.began then
			LotaMinimapPingRenderer:showMemo(var_4_0)
		end
		
		if arg_5_1 == ccui.TouchEventType.ended or arg_5_1 == ccui.TouchEventType.canceled then
			LotaMinimapPingRenderer:hideMemo(var_4_0)
		end
	end)
	var_4_1:setVisible(true)
	
	return var_4_0
end

function LotaMinimapPingRenderer.showMemo(arg_6_0, arg_6_1)
	if not get_cocos_refid(arg_6_1) then
		return 
	end
	
	local var_6_0 = arg_6_0.vars.ping_sprite_data or {}
	local var_6_1
	
	for iter_6_0, iter_6_1 in pairs(var_6_0) do
		if iter_6_1 == arg_6_1 then
			var_6_1 = iter_6_0
			
			break
		end
	end
	
	if not var_6_1 then
		print("NOT HAVE KEY")
		
		return 
	end
	
	local var_6_2 = LotaPingSystem:getMemoData(var_6_1)
	
	if not var_6_2 then
		print("NOT MEMO")
		
		return 
	end
	
	local var_6_3 = arg_6_0.vars.ping_sprite_data[var_6_1]
	
	if not get_cocos_refid(var_6_3) then
		return 
	end
	
	local var_6_4 = var_6_3:findChildByName("n_memo")
	local var_6_5 = var_6_3:findChildByName("n_tag")
	
	var_6_4:setVisible(true)
	var_6_5:setVisible(true)
	var_6_4:setScale(0.01)
	var_6_5:setOpacity(255)
	
	if UIAction:Find("ping_fade_out") then
		UIAction:Remove("ping_fade_out")
	end
	
	UIAction:Add(SPAWN(TARGET(var_6_4, LOG(SCALE_TO(100, 1))), TARGET(var_6_5, SEQ(LOG(SCALE_TO(100, 0.01)), SHOW(false)))), var_6_3, "ping_fade_in")
	
	local var_6_6 = var_6_3:findChildByName("txt_disc")
	
	UIUtil:updateTextWrapMode(var_6_6, var_6_2)
	if_set(var_6_6, nil, var_6_2)
	
	arg_6_1._is_memo = true
	arg_6_0.vars.memo_show_ping = arg_6_1
end

function LotaMinimapPingRenderer.updateScale(arg_7_0)
	local var_7_0 = arg_7_0.vars.ping_sprite_data or {}
	
	for iter_7_0, iter_7_1 in pairs(var_7_0) do
		if not iter_7_1._origin_scale then
			iter_7_1._origin_scale = iter_7_1:getScale()
		end
		
		iter_7_1:setScale(iter_7_1._origin_scale / LotaMinimapRenderer:getZoomScale())
	end
end
