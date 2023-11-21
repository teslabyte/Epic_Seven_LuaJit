CharPreviewCommonPart = {}

function CharPreviewCommonPart.makeAnimaionNode(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	local var_1_0 = ur.Model:create(arg_1_1, arg_1_2, 1)
	
	var_1_0:setPosition(arg_1_3, arg_1_4)
	var_1_0:setScale(0.4)
	var_1_0:setVisible(true)
	Action:Add(SEQ(DMOTION("intro", false), MOTION("loop", true)), var_1_0)
	
	local var_1_1 = var_1_0:getBoneNode("node")
	
	var_1_1:setInheritScale(true)
	var_1_1:setInheritRotation(true)
	
	return var_1_0, var_1_1
end

function CharPreviewCommonPart.makeCharacterNode(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = ur.Model:create(arg_2_1, arg_2_2, 1)
	
	var_2_0:setPosition(0, 0)
	var_2_0:setScale(2.5)
	var_2_0:setAnimation(0, "idle", true)
	var_2_0:update(math.random())
	
	return var_2_0
end

function CharPreviewCommonPart.show(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = CharPreviewData:getGender(arg_3_3)
	local var_3_1 = "ui_new_pickup_intro_female.cfx"
	
	if var_3_0 == "m" then
		var_3_1 = "ui_new_pickup_intro_male.cfx"
	end
	
	arg_3_0.bg = CACHE:getEffect(var_3_1)
	
	arg_3_0.bg:setPosition(VIEW_WIDTH / 2 + VIEW_BASE_LEFT, VIEW_HEIGHT / 2)
	arg_3_0.bg:setScale(VIEW_WIDTH_RATIO)
	arg_3_0.bg:start()
	arg_3_1:addChild(arg_3_0.bg)
	
	arg_3_0.dlg = load_dlg("intro_hero", true, "wnd")
	
	arg_3_0.dlg:setOpacity(0)
	arg_3_0.dlg:setAnchorPoint(0.5, 0.5)
	
	local var_3_2 = arg_3_0.dlg:findChildByName("n_info_Image_txt")
	
	if var_3_2 then
		local var_3_3 = "intro_info_hero.png"
		
		if CharPreviewData:getSkin(arg_3_3) then
			var_3_3 = "intro_info_skin.png"
		end
		
		var_3_2:addChild(cc.Sprite:create("img/" .. var_3_3))
	end
	
	arg_3_2:addChild(arg_3_0.dlg)
	UIAction:Add(SEQ(DELAY(2500), SPAWN(LOG(SCALE(667, 0.8, 1)), LOG(FADE_IN(267))), DELAY(600), SHOW(false)), arg_3_0.dlg, "block")
end

function CharPreviewCommonPart.release(arg_4_0)
	if get_cocos_refid(arg_4_0.bg) then
		arg_4_0.bg:removeFromParent()
	end
	
	if get_cocos_refid(arg_4_0.dlg) then
		arg_4_0.dlg:removeFromParent()
	end
end
