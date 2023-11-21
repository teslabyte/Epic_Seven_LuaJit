SPLFieldUI = {}

function SPLFieldUI.init(arg_1_0, arg_1_1)
	if not get_cocos_refid(arg_1_1) then
		return 
	end
	
	arg_1_0.vars = {}
	arg_1_0.vars.layer = arg_1_1
	arg_1_0.vars.field_ui_infos = {}
end

function SPLFieldUI.getLayer(arg_2_0)
	if not arg_2_0.vars then
		return 
	end
	
	return arg_2_0.vars.layer
end

function SPLFieldUI.addFieldUI(arg_3_0, arg_3_1, arg_3_2)
	if not arg_3_0.vars or not get_cocos_refid(arg_3_1) then
		return 
	end
	
	arg_3_2 = arg_3_2 or {}
	
	local var_3_0 = SPLFieldUIInfo(arg_3_1, arg_3_2)
	
	if arg_3_2.id then
		arg_3_0.vars.field_ui_infos[arg_3_2.id] = var_3_0
	else
		table.insert(arg_3_0.vars.field_ui_infos, var_3_0)
	end
	
	arg_3_0.vars.layer:addChild(arg_3_1)
	
	return var_3_0
end

function SPLFieldUI.removeFieldUI(arg_4_0, arg_4_1)
	if not arg_4_0.vars then
		return 
	end
	
	local var_4_0 = arg_4_0.vars.field_ui_infos[arg_4_1]
	
	if not var_4_0 then
		return 
	end
	
	var_4_0:remove()
	
	arg_4_0.vars.field_ui_infos[arg_4_1] = nil
end

function SPLFieldUI.getFieldUI(arg_5_0, arg_5_1)
	if not arg_5_0.vars then
		return 
	end
	
	return arg_5_0.vars.field_ui_infos[arg_5_1]
end

function SPLFieldUI.updateFieldUIScale(arg_6_0)
	if not arg_6_0.vars then
		return 
	end
	
	local var_6_0 = arg_6_0.vars.field_ui_infos
	
	for iter_6_0, iter_6_1 in pairs(var_6_0) do
		iter_6_1:updateUIScale()
	end
end

function SPLFieldUI.removeAllChildren(arg_7_0)
	if not arg_7_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_7_0.vars.layer) then
		arg_7_0.vars.layer:removeAllChildren()
	end
	
	arg_7_0.vars.field_ui_infos = {}
end
