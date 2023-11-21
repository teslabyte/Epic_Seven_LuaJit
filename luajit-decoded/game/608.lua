DEBUG.DO_NOT_SHOW_PREVIEW_UI = false
CharPreviewSkillPart = {}

function CharPreviewSkillPart.uiSetting(arg_1_0, arg_1_1)
	if DEBUG.DO_NOT_SHOW_PREVIEW_UI then
		return 
	end
	
	local var_1_0 = load_dlg("intro_hero2", true, "wnd")
	
	upgradeLabelToRichLabel(var_1_0, "txt_desc")
	
	arg_1_1 = arg_1_1 or "c1001"
	
	local var_1_1 = CharPreviewData:getSkin(arg_1_1) or arg_1_1
	
	if_set_sprite(var_1_0, "portrait_su", "face/" .. var_1_1 .. "_su.png")
	
	local var_1_2 = CharPreviewData:getSkin(arg_1_1) ~= nil
	local var_1_3 = CharPreviewData:getUnit(arg_1_1):getName()
	local var_1_4 = ""
	
	if var_1_2 then
		local var_1_5 = "ma_" .. var_1_1
		
		var_1_4 = T(DB("item_material", var_1_5, "name"))
	end
	
	local var_1_6 = DB("char_intro", CharPreviewData:getKey(arg_1_1), "desc")
	
	if_set(var_1_0, "txt_desc", T(var_1_6))
	
	if var_1_4 == "" then
		if_set(var_1_0, "txt_name", var_1_3)
	else
		if_set(var_1_0, "txt_name", var_1_3 .. " : " .. var_1_4)
	end
	
	local var_1_7 = var_1_0:findChildByName("txt_desc")
	local var_1_8 = var_1_0:findChildByName("txt_name")
	local var_1_9 = var_1_0:findChildByName("bar")
	local var_1_10 = var_1_7:getStringNumLines()
	local var_1_11 = 24 * (-2 + var_1_10)
	local var_1_12 = 22 * (-2 + var_1_10) + 22
	local var_1_13 = 77 + (var_1_10 - 1) * 22
	local var_1_14 = var_1_7:getContentSize()
	local var_1_15 = var_1_8:getPositionY()
	local var_1_16 = var_1_9:getContentSize()
	
	var_1_14.height = var_1_14.height + var_1_11
	var_1_16.width = var_1_13
	
	var_1_8:setPositionY(var_1_15 + var_1_12)
	var_1_7:setContentSize(var_1_14)
	var_1_9:setContentSize(var_1_16)
	
	return var_1_0
end

function CharPreviewSkillPart.prepare(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = CharPreviewData:getFieldData(arg_2_3)
	local var_2_1 = CharPreviewViewer:Init(arg_2_1, var_2_0)
	
	CharPreviewViewer:MakeTeam({
		arg_2_3
	}, FRIEND, CharPreviewData:getSkin(arg_2_3))
	CharPreviewViewer:MakeTeam(CharPreviewData:getEnemy(arg_2_3), ENEMY)
	CharPreviewViewer:MakeLayouts()
	
	local var_2_2 = CharPreviewData:getSkillIdx(arg_2_3) or 3
	
	CharPreviewViewer:UseSkill(var_2_2)
	
	arg_2_0.layer = var_2_1
	
	arg_2_0.layer:setVisible(false)
	
	arg_2_0.ui_layer = arg_2_0:uiSetting(arg_2_3)
	
	if arg_2_0.ui_layer then
		arg_2_0.ui_layer:setVisible(false)
		arg_2_2:addChild(arg_2_0.ui_layer)
	end
	
	setenv("time_scale", 1.2)
end

function CharPreviewSkillPart.show(arg_3_0)
	if not arg_3_0.layer then
		return 
	end
	
	arg_3_0.layer:setVisible(true)
	
	arg_3_0.layer = nil
	
	if arg_3_0.ui_layer then
		arg_3_0.ui_layer:setVisible(true)
	end
end

function CharPreviewSkillPart.release(arg_4_0)
	if arg_4_0.ui_layer then
		arg_4_0.ui_layer:removeFromParent()
		
		arg_4_0.ui_layer = nil
	end
	
	setenv("time_scale", 1)
	CharPreviewViewer:Destroy()
	CameraManager:resetDefault()
end
