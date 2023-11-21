UnitMultiPromoteSetting = {}

function HANDLER.batch_upgrade_settings(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		UnitMultiPromoteSetting:close()
	end
	
	local var_1_0 = arg_1_0:getParent()
	
	if not var_1_0 then
		return 
	end
	
	local var_1_1 = var_1_0:getName()
	
	if string.starts(var_1_1, "n_target_0") then
		UnitMultiPromoteSetting:onHandlerTargetButtons(var_1_0, arg_1_0, arg_1_1)
	end
	
	if string.starts(var_1_1, "n_materials_check_0") then
		UnitMultiPromoteSetting:onHandlerMaterialButtons(var_1_0, arg_1_0, arg_1_1)
	end
end

function UnitMultiPromoteSetting.onHandlerTargetButtons(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_1.key
	
	if not var_2_0 then
		Log.e("UnitMultiPromoteSetting : NO KEY")
		
		return 
	end
	
	local var_2_1 = arg_2_1:findChildByName("check_box")
	local var_2_2 = not arg_2_0.vars.options.target[var_2_0]
	
	var_2_1:setSelected(var_2_2)
	
	arg_2_0.vars.options.target[var_2_0] = var_2_2
end

function UnitMultiPromoteSetting.onHandlerMaterialButtons(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_1.key
	
	if not var_3_0 then
		Log.e("UnitMultiPromoteSetting : NO KEY")
		
		return 
	end
	
	local var_3_1 = arg_3_1:findChildByName("check_materials")
	local var_3_2 = not arg_3_0.vars.options.material[var_3_0]
	
	var_3_1:setSelected(var_3_2)
	
	arg_3_0.vars.options.material[var_3_0] = var_3_2
end

function UnitMultiPromoteSetting.uiSetting(arg_4_0)
	local var_4_0 = arg_4_0.vars.dlg:findChildByName("n_window"):findChildByName("n_target")
	local var_4_1 = {
		"m8043",
		"m8042",
		"m8041"
	}
	
	for iter_4_0 = 1, 3 do
		local var_4_2 = var_4_0:findChildByName("n_target_0" .. iter_4_0):findChildByName("n_target_face")
		
		UIUtil:getRewardIcon(nil, var_4_1[iter_4_0], {
			no_popup = true,
			no_grade = true,
			parent = var_4_2
		})
	end
end

function UnitMultiPromoteSetting.checkBoxesSetting(arg_5_0)
	local var_5_0 = arg_5_0.vars.dlg:findChildByName("n_window")
	local var_5_1 = var_5_0:findChildByName("n_target")
	local var_5_2 = var_5_0:findChildByName("n_materials")
	local var_5_3 = {
		"tera_target",
		"giga_target",
		"mega_target",
		"base_grade2_target",
		nil,
		"lock_unit_target",
		"high_grade_property_target"
	}
	
	for iter_5_0 = 1, 7 do
		if iter_5_0 ~= 5 then
			local var_5_4 = var_5_3[iter_5_0]
			local var_5_5 = arg_5_0.vars.options.target[var_5_4]
			local var_5_6 = var_5_1:findChildByName("n_target_0" .. iter_5_0)
			
			var_5_6:findChildByName("check_box"):setSelected(var_5_5)
			
			var_5_6.key = var_5_4
		end
	end
	
	local var_5_7 = {
		"base_grade3_material",
		"promotion_unit_property_material",
		"devoted_unit_can_material"
	}
	
	for iter_5_1 = 1, 3 do
		local var_5_8 = var_5_7[iter_5_1]
		local var_5_9 = arg_5_0.vars.options.material[var_5_8]
		local var_5_10 = var_5_2:findChildByName("n_materials_check_0" .. iter_5_1)
		
		var_5_10:findChildByName("check_materials"):setSelected(var_5_9)
		
		var_5_10.key = var_5_8
	end
end

function UnitMultiPromoteSetting.open(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0.vars = {}
	arg_6_0.vars.dlg = load_dlg("batch_upgrade_settings", true, "wnd")
	arg_6_0.vars.options = table.clone(arg_6_2)
	
	arg_6_0:uiSetting()
	arg_6_0:checkBoxesSetting()
	BackButtonManager:push({
		check_id = "unit_multi_promote_setting",
		back_func = function()
			arg_6_0:close()
		end
	})
	arg_6_1:addChild(arg_6_0.vars.dlg)
end

function UnitMultiPromoteSetting.close(arg_8_0)
	if arg_8_0.vars and get_cocos_refid(arg_8_0.vars.dlg) then
		arg_8_0.vars.dlg:removeFromParent()
		BackButtonManager:pop("unit_multi_promote_setting")
		UnitMultiPromote:endSettingPopup(arg_8_0.vars.options)
		
		arg_8_0.vars = nil
	end
end
