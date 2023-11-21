PetTransferListView = {}

function PetTransferListView.init(arg_1_0, arg_1_1)
	arg_1_0.vars = {}
	arg_1_0.vars.parent = arg_1_1
	arg_1_0.vars.listview = ItemListView_v2:bindControl(arg_1_0.vars.parent:getChildByName("listview"))
	
	local var_1_0 = {
		onUpdate = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
			arg_1_0:updateListViewItem(arg_2_1, arg_2_3)
			
			return arg_2_3.id
		end
	}
	local var_1_1 = load_control("wnd/pet_sell_item.csb")
	
	arg_1_0.vars.listview:setRenderer(var_1_1, var_1_0)
	arg_1_0.vars.listview:removeAllChildren()
end

function PetTransferListView.getListView(arg_3_0)
	if not arg_3_0.vars then
		return 
	end
	
	return arg_3_0.vars.listview
end

function PetTransferListView.setItems(arg_4_0, arg_4_1)
	if not arg_4_0.vars or table.empty(arg_4_1) or not get_cocos_refid(arg_4_0.vars.listview) then
		return 
	end
	
	arg_4_0.vars.listview:setDataSource(arg_4_1)
end

function PetTransferListView.jumpToTop(arg_5_0)
	if not arg_5_0.vars or not get_cocos_refid(arg_5_0.vars.listview) then
		return 
	end
	
	arg_5_0.vars.listview:jumpToTop()
end

function PetTransferListView.updateListViewItem(arg_6_0, arg_6_1, arg_6_2)
	if not get_cocos_refid(arg_6_1) or not arg_6_2 then
		return 
	end
	
	local var_6_0 = arg_6_1:getChildByName("n_pet_bar")
	
	var_6_0:removeAllChildren()
	
	local var_6_1 = arg_6_2.pet
	
	if not table.empty(var_6_1) and arg_6_2.id then
		arg_6_1:getChildByName("btn_slot").id = arg_6_2.id
		
		local var_6_2 = UIUtil:updatePetBar(nil, nil, arg_6_2.pet)
		
		UIUtil:updatePetBarInfo(var_6_2, nil, arg_6_2.pet)
		var_6_0:addChild(var_6_2)
	end
end

function PetTransferListView.reset(arg_7_0)
	if not arg_7_0.vars or not get_cocos_refid(arg_7_0.vars.listview) then
		return 
	end
	
	arg_7_0.vars.listview:setDataSource({})
	
	arg_7_0.vars = {}
end
