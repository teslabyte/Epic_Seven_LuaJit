PetSkillList = {}

function PetSkillList.create(arg_1_0, arg_1_1)
	local var_1_0 = {}
	
	copy_functions(PetSkillList, var_1_0)
	var_1_0:init(arg_1_1, true)
	
	return var_1_0
end

function PetSkillList.init(arg_2_0, arg_2_1, arg_2_2)
	if not arg_2_2 then
		Log.e("INIT 금지!")
		
		return 
	end
	
	arg_2_1 = arg_2_1 or {}
	arg_2_0.vars = {}
	
	if arg_2_1.pet then
		arg_2_0:setPet(arg_2_1.pet)
	end
	
	if arg_2_1.control then
		arg_2_0:initControl(arg_2_1.control)
	end
	
	if arg_2_1.control_name then
		arg_2_0.vars.control_name = arg_2_1.control_name
	end
	
	if arg_2_1.mode then
		arg_2_0.vars.mode = arg_2_1.mode
	end
	
	if arg_2_1.use_button then
		arg_2_0.vars.use_button = true
	end
	
	if arg_2_1.check_new then
		arg_2_0.vars.check_new = true
	end
	
	if arg_2_1.button_id then
		arg_2_0.vars.button_id = arg_2_1.button_id
	end
	
	arg_2_0.vars.gap = arg_2_1.gap or 0
	
	arg_2_0:updateDataAtControl()
end

function PetSkillList.getPetSkillList(arg_3_0, arg_3_1)
	local var_3_0 = {}
	local var_3_1 = arg_3_1:getAllSkillID()
	
	for iter_3_0 = 1, #var_3_1 do
		table.insert(var_3_0, {
			pet_uid = arg_3_1:getUID(),
			skill_idx = iter_3_0,
			skill = var_3_1[iter_3_0],
			skill_lv = arg_3_1:getSkillRank(iter_3_0)
		})
	end
	
	return var_3_0
end

function PetSkillList.setPet(arg_4_0, arg_4_1)
	arg_4_0.vars.pet = arg_4_1
	arg_4_0.vars.dataSource = arg_4_0:getPetSkillList(arg_4_1)
	arg_4_0.vars.pets = {}
	arg_4_0.vars.pets[arg_4_1:getUID()] = arg_4_1
	
	arg_4_0:updateDataAtControl()
end

function PetSkillList.setPetSkills(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_1 or {}
	
	arg_5_0.vars.dataSource = var_5_0
	arg_5_0.vars.pets = {}
	
	for iter_5_0, iter_5_1 in pairs(var_5_0) do
		if not arg_5_0.vars.pets[iter_5_1.pet_uid] then
			arg_5_0.vars.pets[iter_5_1.pet_uid] = Account:getPet(iter_5_1.pet_uid)
		end
	end
	
	arg_5_0:updateDataAtControl()
end

function PetSkillList.updateToSelected(arg_6_0, arg_6_1)
end

function PetSkillList._getRendererHeight(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1:findChildByName("txt_skill")
	local var_7_1 = arg_7_1:findChildByName("grade_icon")
	local var_7_2 = var_7_0:getTextBoxSize()
	local var_7_3 = var_7_1:getContentSize()
	local var_7_4 = var_7_1:getScaleY()
	local var_7_5 = var_7_0:getScaleY()
	local var_7_6 = (var_7_0:getStringNumLines() - 1) * 19
	
	return var_7_2.height * var_7_5 + var_7_3.height * var_7_4 + arg_7_0.vars.gap + var_7_6
end

function PetSkillList._listViewMid(arg_8_0, arg_8_1)
	arg_8_0.vars.renderers = {}
	
	local var_8_0 = #arg_8_0.vars.dataSource
	local var_8_1 = 0
	local var_8_2 = arg_8_1:getContentSize().height
	
	for iter_8_0 = 1, var_8_0 do
		local var_8_3 = arg_8_1:clone()
		
		arg_8_0.vars.list_updater:onUpdate(var_8_3, iter_8_0, arg_8_0.vars.dataSource[iter_8_0])
		
		var_8_1 = math.max(var_8_1, arg_8_0:_getRendererHeight(var_8_3))
		
		table.insert(arg_8_0.vars.renderers, var_8_3)
	end
	
	local var_8_4 = arg_8_0.vars.listView:getInnerContainerSize()
	
	arg_8_0.vars.listView:setInnerContainerSize({
		width = var_8_4.width,
		height = var_8_1 + 20
	})
	
	local var_8_5 = arg_8_0.vars.listView:getInnerContainerSize().height
	local var_8_6 = arg_8_1:getContentSize()
	local var_8_7 = (var_8_4.width - var_8_6.width * var_8_0) / 2
	
	for iter_8_1 = 1, var_8_0 do
		local var_8_8 = arg_8_0.vars.renderers[iter_8_1]
		
		var_8_8:setPositionX(var_8_7)
		
		local var_8_9 = var_8_8:findChildByName("txt_skill")
		local var_8_10 = var_8_9:getTextBoxSize()
		local var_8_11 = var_8_9:getContentSize()
		
		if var_8_10.height > var_8_11.height then
			var_8_9:setContentSize(var_8_10)
		end
		
		var_8_8:setPositionY(var_8_5 - var_8_2)
		
		var_8_7 = var_8_7 + var_8_6.width
		
		arg_8_0.vars.listView:addChild(var_8_8)
	end
end

function PetSkillList._listViewVertical(arg_9_0, arg_9_1)
	arg_9_0.vars.renderers = {}
	
	local var_9_0 = #arg_9_0.vars.dataSource
	local var_9_1 = arg_9_0.vars.listView:getInnerContainerSize()
	local var_9_2 = arg_9_0.vars.listView:getContentSize().height
	local var_9_3 = 0
	local var_9_4 = {}
	
	for iter_9_0 = 1, var_9_0 do
		local var_9_5 = arg_9_1:clone()
		
		arg_9_0.vars.list_updater:onUpdate(var_9_5, iter_9_0, arg_9_0.vars.dataSource[iter_9_0])
		
		var_9_3 = var_9_3 + arg_9_0:_getRendererHeight(var_9_5)
		
		arg_9_0.vars.listView:addChild(var_9_5)
		
		if arg_9_0.vars.use_button then
			local var_9_6 = var_9_5:findChildByName("btn_skill_item_select")
			local var_9_7 = var_9_6:getContentSize()
			
			var_9_6:setContentSize({
				width = var_9_7.width,
				height = var_9_3
			})
		end
		
		var_9_4[iter_9_0] = var_9_5
	end
	
	local var_9_8 = math.max(var_9_2, var_9_3)
	
	arg_9_0.vars.listView:setInnerContainerSize({
		width = var_9_1.width,
		height = var_9_8
	})
	
	for iter_9_1 = 1, var_9_0 do
		local var_9_9 = var_9_4[iter_9_1]
		local var_9_10 = arg_9_0:_getRendererHeight(var_9_9)
		
		var_9_9:setPositionY(var_9_8)
		
		var_9_8 = var_9_8 - var_9_10
	end
	
	arg_9_0.vars.renderers = var_9_4
end

function PetSkillList.getControlNameByListViewMode(arg_10_0)
	if arg_10_0.vars.control_name then
		return arg_10_0.vars.control_name
	end
	
	if arg_10_0.vars.mode == "mid" then
		return "wnd/pet_skill_item.csb"
	elseif arg_10_0.vars.mode == "vertical" then
		return "wnd/pet_node_text.csb"
	end
end

function PetSkillList.updateDataAtListView(arg_11_0)
	if not arg_11_0.vars.dataSource then
		return 
	end
	
	arg_11_0.vars.listView:removeAllChildren()
	
	local var_11_0 = arg_11_0:getControlNameByListViewMode()
	local var_11_1 = load_control(var_11_0)
	
	var_11_1:setAnchorPoint(0, 0)
	
	if arg_11_0.vars.listView.STRETCH_INFO then
		local var_11_2 = arg_11_0.vars.listView:getContentSize()
		
		resetControlPosAndSize(var_11_1, var_11_2.width, arg_11_0.vars.listView.STRETCH_INFO.width_prev)
	end
	
	if arg_11_0.vars.mode == "mid" then
		arg_11_0:_listViewMid(var_11_1)
	elseif arg_11_0.vars.mode == "vertical" then
		arg_11_0:_listViewVertical(var_11_1)
	end
end

function PetSkillList.updateDataAtControl(arg_12_0)
	if arg_12_0.vars.type == "ListView" then
		arg_12_0:updateDataAtListView()
	end
end

function PetSkillList.onPushButton(arg_13_0, arg_13_1)
	if not arg_13_1.select_flag then
		arg_13_1.select_flag = true
	else
		arg_13_1.select_flag = false
	end
	
	local var_13_0 = arg_13_1.parent
	
	if_set_visible(var_13_0, "_select", arg_13_1.select_flag)
	if_set_visible(var_13_0, "_icon_check", arg_13_1.select_flag)
	
	return arg_13_1.select_flag
end

function PetSkillList.setButtonSelected(arg_14_0, arg_14_1)
	for iter_14_0, iter_14_1 in pairs(arg_14_0.vars.dataSource) do
		if iter_14_1.skill_idx == arg_14_1.skill_idx then
			arg_14_0:onPushButton(arg_14_0.vars.renderers[iter_14_0]:findChildByName("btn_skill_item_select"))
			
			return 
		end
	end
end

function PetSkillList.initListView(arg_15_0, arg_15_1)
	arg_15_0.vars.type = "ListView"
	
	local var_15_0 = {
		onUpdate = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
			arg_15_0:update(arg_16_1, arg_16_2, arg_16_3)
		end
	}
	
	arg_15_0.vars.listView = arg_15_1
	arg_15_0.vars.list_updater = var_15_0
end

function PetSkillList.initControl(arg_17_0, arg_17_1)
	arg_17_0.vars.control = arg_17_1
	
	arg_17_0:initListView(arg_17_1)
end

function PetSkillList._updateUseButton(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	if arg_18_0.vars.use_button then
		local var_18_0 = arg_18_1:findChildByName("btn_skill_item_select")
		
		var_18_0.parent = arg_18_1
		var_18_0.id = arg_18_0.vars.button_id
		var_18_0.idx = arg_18_2
		var_18_0.item = arg_18_3
	end
end

function PetSkillList._updateNewSkills(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	if arg_19_0.vars.check_new then
		if_set_visible(arg_19_1, "n_new", arg_19_3.is_new)
		
		if not arg_19_3.is_new then
			return 
		end
		
		local var_19_0 = arg_19_1:findChildByName("txt_skill")
		
		if not var_19_0 then
			return 
		end
		
		var_19_0:setTextColor(cc.c3b(255, 255, 255))
	end
end

function PetSkillList._updateOpts(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	arg_20_0:_updateUseButton(arg_20_1, arg_20_2, arg_20_3)
	arg_20_0:_updateNewSkills(arg_20_1, arg_20_2, arg_20_3)
end

function PetSkillList.update(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	local var_21_0 = arg_21_0.vars.pets[arg_21_3.pet_uid]
	
	UIUtil:updatePetSkillItem(arg_21_1, var_21_0, arg_21_3.skill_idx)
	if_set_visible(arg_21_1, "btn_skill_item_select", arg_21_0.vars.use_button)
	if_set_visible(arg_21_1, "_select", false)
	if_set_visible(arg_21_1, "_icon_check", false)
	arg_21_0:_updateOpts(arg_21_1, arg_21_2, arg_21_3)
end
