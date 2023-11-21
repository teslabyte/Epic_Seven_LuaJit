UnitMultiPromoteTargetList = {}

function UnitMultiPromoteTargetList.setBtnIndex(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_1:findChildByName(arg_1_3).index = arg_1_2
end

function UnitMultiPromoteTargetList.createIcon(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	if arg_2_1 then
		local var_2_0 = arg_2_2:findChildByName("n_face")
		local var_2_1 = UIUtil:getRewardIcon(nil, arg_2_1.db.code, {
			no_db_grade = true,
			no_popup = true,
			role = true,
			parent = var_2_0,
			lv = arg_2_1:getLv(),
			grade = arg_2_1:getGrade()
		})
		
		var_2_1.uid = arg_2_1:getUID()
		
		var_2_1:setName(arg_2_3)
	end
	
	local var_2_2 = arg_2_2:findChildByName("btn_material")
	
	if var_2_2 then
		var_2_2.unit = arg_2_1
	end
end

function UnitMultiPromoteTargetList.refreshItem(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_2.target
	local var_3_1 = arg_3_1:findChildByName("n_target")
	local var_3_2 = var_3_1:findChildByName("reward_icon")
	
	if var_3_2.uid ~= var_3_0:getUID() then
		var_3_2:removeFromParent()
		arg_3_0:createIcon(var_3_0, var_3_1, "reward_icon")
	end
	
	local var_3_3 = arg_3_1:findChildByName("n_material")
	
	for iter_3_0 = 1, 4 do
		local var_3_4 = arg_3_2.materials[iter_3_0]
		local var_3_5 = var_3_3:findChildByName("material_face_0" .. iter_3_0)
		local var_3_6 = var_3_5:findChildByName("material_icon_" .. iter_3_0)
		local var_3_7 = var_3_4 and var_3_4:getUID() or -1
		local var_3_8 = var_3_6 and var_3_6.uid or -2
		
		arg_3_0:setBtnIndex(var_3_5, arg_3_3, "btn_material")
		
		if var_3_6 and var_3_7 ~= var_3_8 then
			var_3_6:removeFromParent()
			
			var_3_5:findChildByName("btn_material").unit = nil
		end
		
		if var_3_7 ~= -1 and var_3_7 ~= var_3_8 then
			arg_3_0:createIcon(var_3_4, var_3_5, "material_icon_" .. iter_3_0)
		end
	end
	
	var_3_1:findChildByName("check_target"):setSelected(var_3_0:getGrade() == table.count(arg_3_2.materials))
	
	local var_3_9 = 255
	
	if arg_3_0.vars.select_idx ~= nil and not arg_3_2.selected then
		var_3_9 = var_3_9 * 0.3
	end
	
	if_set_opacity(arg_3_1, nil, var_3_9)
	if_set_visible(arg_3_1, "select_red", arg_3_2.selected)
end

function UnitMultiPromoteTargetList.updateItem(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	if not arg_4_2.materials or not arg_4_2.target then
		Log.e("NO MATERIAL")
		
		return 
	end
	
	local var_4_0 = arg_4_1:findChildByName("n_target")
	
	if not var_4_0 then
		Log.e("INVALID N_TARGET")
	end
	
	arg_4_0:setBtnIndex(arg_4_1, arg_4_3, "btn_target")
	if_set_visible(arg_4_1, "select_red", false)
	
	local var_4_1 = arg_4_2.target
	
	arg_4_0:createIcon(var_4_1, var_4_0, "reward_icon", arg_4_3)
	
	local var_4_2 = arg_4_1:findChildByName("n_material")
	
	for iter_4_0 = 1, 4 do
		local var_4_3 = arg_4_2.materials[iter_4_0]
		local var_4_4 = var_4_2:findChildByName("material_face_0" .. iter_4_0)
		
		arg_4_0:setBtnIndex(var_4_4, arg_4_3, "btn_material")
		
		if var_4_3 then
			arg_4_0:createIcon(var_4_3, var_4_4, "material_icon_" .. iter_4_0)
		end
		
		local var_4_5 = 255
		
		if iter_4_0 > var_4_1:getGrade() then
			var_4_5 = var_4_5 * 0.3
		end
		
		if_set_opacity(var_4_4, "slot_bg", var_4_5)
	end
	
	local var_4_6 = arg_4_1:findChildByName("n_results_face")
	local var_4_7 = UNIT:create({
		code = var_4_1.db.code,
		g = var_4_1:getGrade() + 1,
		lv = var_4_1:getLv(),
		exp = var_4_1:getEXP()
	})
	
	arg_4_0:createIcon(var_4_7, var_4_6, "results_face_icon")
	
	local var_4_8 = var_4_0:findChildByName("check_target")
	
	if var_4_8 then
		var_4_8:setSelected(true)
	end
end

function UnitMultiPromoteTargetList.isSelected(arg_5_0)
	return arg_5_0.vars.select_idx ~= nil
end

function UnitMultiPromoteTargetList.selectOff(arg_6_0)
	if not arg_6_0.vars.select_idx then
		return 
	end
	
	local var_6_0 = arg_6_0.vars.select_idx
	local var_6_1 = arg_6_0.vars.data_source[var_6_0]
	
	if not var_6_1 then
		Log.e("NO DATA SELECTED")
		
		return 
	end
	
	arg_6_0.vars.select_idx = nil
	var_6_1.selected = false
	arg_6_0.vars.data_source[var_6_0] = var_6_1
	
	arg_6_0.vars.list_view:targetUpdate(var_6_0, var_6_1)
	UnitMultiPromote:editEnd()
end

function UnitMultiPromoteTargetList.removeAll(arg_7_0, arg_7_1, arg_7_2)
	for iter_7_0, iter_7_1 in pairs(arg_7_2.materials) do
		arg_7_0.vars.hero_belt:revertPoppedItem(iter_7_1)
	end
	
	arg_7_2.materials = {}
	arg_7_0.vars.data_source[arg_7_1.index] = arg_7_2
	
	arg_7_0.vars.list_view:targetUpdate(arg_7_1.index, arg_7_2)
	UnitMultiPromote:updateText()
end

function UnitMultiPromoteTargetList.selected(arg_8_0, arg_8_1, arg_8_2)
	if not arg_8_1.index then
		return 
	end
	
	local var_8_0 = arg_8_0.vars.data_source[arg_8_1.index]
	
	if not var_8_0 then
		Log.e("NO DATA SELECTED")
		
		return 
	end
	
	if arg_8_0.vars.select_idx ~= nil and arg_8_0.vars.select_idx ~= arg_8_1.index then
		arg_8_0:selectOff()
		
		return 
	end
	
	if table.count(var_8_0.materials) == var_8_0.target:getGrade() and not var_8_0.selected then
		if not var_8_0.selected and arg_8_2 then
			arg_8_0:removeAll(arg_8_1, var_8_0)
			
			return 
		else
			balloon_message_with_sound("ui_bulkup_edit_already_full")
			
			return 
		end
	end
	
	var_8_0.selected = not var_8_0.selected
	
	if var_8_0.selected then
		arg_8_0.vars.select_idx = arg_8_1.index
		
		UnitMultiPromote:edit(var_8_0.target)
	else
		arg_8_0.vars.select_idx = nil
		
		UnitMultiPromote:editEnd()
	end
	
	arg_8_0.vars.data_source[arg_8_1.index] = var_8_0
	
	arg_8_0.vars.list_view:targetUpdate(arg_8_1.index, var_8_0)
end

function UnitMultiPromoteTargetList.remove(arg_9_0, arg_9_1)
	if not arg_9_1.unit then
		return 
	end
	
	local var_9_0 = arg_9_1.unit
	local var_9_1 = arg_9_0.vars.data_source[arg_9_1.index]
	
	if not var_9_1 then
		Log.e("TARGET LIST VIEW  : REMOVE DATA NOT EXISTS")
		
		return 
	end
	
	if arg_9_0.vars.select_idx and arg_9_0.vars.select_idx ~= arg_9_1.index then
		arg_9_0:selectOff()
		
		return 
	end
	
	local var_9_2
	
	for iter_9_0, iter_9_1 in pairs(var_9_1.materials) do
		if iter_9_1:getUID() == var_9_0:getUID() then
			var_9_2 = iter_9_0
		end
	end
	
	if not var_9_2 then
		Log.e("NO REMOVE INDEX")
		
		return 
	end
	
	table.remove(var_9_1.materials, var_9_2)
	arg_9_0.vars.hero_belt:revertPoppedItem(var_9_0)
	
	arg_9_0.vars.data_source[arg_9_1.index] = var_9_1
	
	arg_9_0.vars.list_view:targetUpdate(arg_9_1.index, var_9_1)
	UnitMultiPromote:updateText()
end

function UnitMultiPromoteTargetList.addMaterial(arg_10_0, arg_10_1)
	if not arg_10_0.vars.select_idx then
		balloon_message_with_sound("ui_bulkup_edit_list_off")
		
		return 
	end
	
	if not arg_10_1 then
		Log.e("UnitMultiPromoteTargetList : NIL MATERIAL")
		
		return 
	end
	
	if not isCanMaterialInMultiPromote(arg_10_1) then
		Log.e("UnitMultiPromoteTargetList : WRONG MATERIAL")
		
		return 
	end
	
	local var_10_0 = arg_10_0.vars.data_source[arg_10_0.vars.select_idx]
	local var_10_1 = var_10_0.target
	
	if not var_10_1 then
		Log.e("UnitMultiPromoteTargetList : NO TARGET")
		
		return 
	end
	
	if var_10_1:getGrade() ~= arg_10_1:getGrade() then
		balloon_message_with_sound("bulk_upgrade_select_no")
		
		return 
	end
	
	if not var_10_0.materials then
		Log.e("UnitMultiPromoteTargetList : WRONG MATERIALS")
		
		return 
	end
	
	if var_10_1:getGrade() <= table.count(var_10_0.materials) then
		balloon_message_with_sound("ui_bulkup_edit_already_full")
		
		return 
	end
	
	table.insert(var_10_0.materials, arg_10_1)
	
	local var_10_2 = arg_10_0.vars.select_idx
	local var_10_3 = var_10_1:getGrade() == table.count(var_10_0.materials)
	
	if var_10_3 then
		arg_10_0.vars.select_idx = nil
		var_10_0.selected = false
	end
	
	arg_10_0.vars.data_source[var_10_2] = var_10_0
	
	arg_10_0.vars.list_view:targetUpdate(var_10_2, var_10_0)
	arg_10_0.vars.hero_belt:popItem(arg_10_1)
	UnitMultiPromote:updateText()
	
	if var_10_3 then
		UnitMultiPromote:editEnd()
	end
end

function UnitMultiPromoteTargetList.setList(arg_11_0, arg_11_1, arg_11_2)
	arg_11_0:selectOff()
	arg_11_0.vars.list_view:removeAllChildren()
	arg_11_0.vars.hero_belt:revertPoppedItem()
	
	arg_11_0.vars.target_units = arg_11_1
	arg_11_0.vars.material_units = arg_11_2
	arg_11_0.vars.data_source = {}
	
	for iter_11_0, iter_11_1 in pairs(arg_11_0.vars.target_units) do
		local var_11_0 = iter_11_1:getUID()
		local var_11_1 = arg_11_0.vars.material_units[var_11_0]
		
		if var_11_1 then
			table.insert(arg_11_0.vars.data_source, {
				target = iter_11_1,
				materials = var_11_1
			})
			
			for iter_11_2, iter_11_3 in pairs(var_11_1) do
				arg_11_0.vars.hero_belt:removeSafely(iter_11_3)
			end
		end
	end
	
	arg_11_0.vars.list_view:setDataSource(arg_11_0.vars.data_source)
	UnitMultiPromote:updateText()
	arg_11_0.vars.hero_belt:endRemoveSafely()
end

function UnitMultiPromoteTargetList.getList(arg_12_0)
	return arg_12_0.vars.data_source
end

function UnitMultiPromoteTargetList.adjustStretch(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_1:findChildByName("n_material")
	local var_13_1 = arg_13_1:findChildByName("RIGHT")
	
	if not var_13_0 or not var_13_1 then
		return 
	end
	
	var_13_0:setPositionX(var_13_0:getPosition() + arg_13_2 / 2)
	var_13_1:setPositionX(var_13_1:getPosition() + arg_13_2)
	
	local var_13_2 = var_13_0:findChildByName("icon_plus")
	local var_13_3 = var_13_0:findChildByName("img_arrow")
	
	if var_13_3 then
		var_13_3:setPositionX(arg_13_2 / 4 + var_13_3:getPositionX())
	end
	
	if var_13_2 then
		var_13_2:setPositionX(var_13_2:getPositionX() - arg_13_2 / 4)
	end
	
	local var_13_4 = arg_13_1:findChildByName("select_red")
	
	if var_13_4 then
		var_13_4:setPositionX(var_13_4:getPositionX() + arg_13_2 / 2)
	end
end

function UnitMultiPromoteTargetList.init(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	if not get_cocos_refid(arg_14_1) then
		return 
	end
	
	if not arg_14_2 or not arg_14_3 then
		return 
	end
	
	arg_14_0.vars = {}
	arg_14_0.vars.hero_belt = HeroBelt:getInst("UnitMain")
	arg_14_0.vars.list_view = FastListView:bindControl(arg_14_1)
	
	local var_14_0 = load_control("wnd/unit_bulk_upgrade_item.csb")
	
	if arg_14_1.STRETCH_INFO then
		local var_14_1 = arg_14_1:getContentSize()
		
		resetControlPosAndSize(var_14_0, var_14_1.width, arg_14_1.STRETCH_INFO.width_prev)
		arg_14_0:adjustStretch(var_14_0, var_14_1.width - arg_14_1.STRETCH_INFO.width_prev)
	end
	
	local var_14_2 = {
		onUpdate = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
			UnitMultiPromoteTargetList:updateItem(arg_15_1, arg_15_3, arg_15_2)
			
			return arg_15_3.id
		end
	}
	
	arg_14_0.vars.list_view:setRenderer(var_14_0, var_14_2)
	arg_14_0.vars.list_view:onRefresh(function(arg_16_0, arg_16_1, arg_16_2)
		UnitMultiPromoteTargetList:refreshItem(arg_16_0, arg_16_2, arg_16_1)
	end)
	arg_14_0:setList(arg_14_2, arg_14_3)
	
	return true
end
