PetUIBase = {}

function PetUIBase.onCreate(arg_1_0, arg_1_1)
	arg_1_1 = arg_1_1 or {}
	arg_1_0.vars = {}
	arg_1_0.vars.parent = arg_1_1.layer
	arg_1_0.vars.base_wnd = load_dlg("unit_pet_base", true, "wnd")
	
	arg_1_0.vars.parent:addChild(arg_1_0.vars.base_wnd)
	arg_1_0:initTopBar(arg_1_1)
	
	arg_1_0.vars.base_layer = cc.Layer:create()
	
	arg_1_0.vars.base_wnd:addChild(arg_1_0.vars.base_layer)
	
	arg_1_0.vars.pet_belt = PetBelt:create()
	
	UIUtil:addPetBelt("PetUIBase", arg_1_0.vars.pet_belt)
	
	local var_1_0 = arg_1_0.vars.pet_belt:getWnd()
	
	if get_cocos_refid(var_1_0) then
		arg_1_0.vars.base_wnd:addChild(var_1_0)
	end
	
	if arg_1_1.update_func then
		Scheduler:add(arg_1_0.vars.base_wnd, arg_1_1.update_func, arg_1_1.update_self)
	end
end

function PetUIBase.onEnter(arg_2_0)
end

function PetUIBase.onPause()
end

function PetUIBase.onResume()
end

function PetUIBase.setVisibleBG(arg_5_0, arg_5_1)
	if_set_visible(arg_5_0.vars.base_wnd, "bg", arg_5_1)
end

function PetUIBase.getPetBelt(arg_6_0)
	if not arg_6_0.vars then
		return nil
	end
	
	if arg_6_0.vars.pet_belt and arg_6_0.vars.pet_belt:getWnd() then
		return arg_6_0.vars.pet_belt
	end
	
	return nil
end

function PetUIBase.clilpPetBelt(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = PetUIBase:getPetBelt()
	local var_7_1 = var_7_0:getWnd()
	local var_7_2
	local var_7_3
	local var_7_4
	
	if arg_7_1 then
		if not get_cocos_refid(arg_7_2) then
			return 
		end
		
		local var_7_5 = arg_7_2:getChildByName("clipper")
		
		if get_cocos_refid(var_7_5) then
			local var_7_6 = var_7_5:getChildByName("n_petlist")
			
			if get_cocos_refid(var_7_6) then
				var_7_2 = var_7_6
			end
		end
		
		local var_7_7 = arg_7_2:getChildByName("n_sorting")
		
		if get_cocos_refid(var_7_7) then
			var_7_3 = var_7_7
		end
		
		local var_7_8 = arg_7_2:getChildByName("n_equip_menu")
		
		if get_cocos_refid(var_7_8) then
			var_7_4 = var_7_8:getChildByName("add_inven")
		end
	else
		var_7_2 = PetUIBase:getBaseUI()
		var_7_3 = var_7_1:getChildByName("n_sorting")
		var_7_4 = var_7_1:getChildByName("add_inven")
	end
	
	if not get_cocos_refid(var_7_2) or not get_cocos_refid(var_7_3) or not get_cocos_refid(var_7_4) then
		return 
	end
	
	if_set_visible(var_7_1, "grow", not arg_7_1)
	var_7_1:ejectFromParent()
	var_7_2:addChild(var_7_1)
	var_7_0:clearGarbageItems()
	var_7_0:changeSorterParent(var_7_3, true)
	var_7_0:changeCountParent(var_7_4)
	var_7_0:updatePetCount()
end

function PetUIBase.setVisiblePetBelt(arg_8_0, arg_8_1)
	if not arg_8_0.vars.pet_belt then
		return 
	end
	
	local var_8_0 = arg_8_0.vars.pet_belt:getWnd()
	
	if get_cocos_refid(var_8_0) then
		if_set_visible(var_8_0, nil, arg_8_1)
	end
	
	arg_8_0.vars.pet_belt:setTouchEnabled(arg_8_1)
end

function PetUIBase.onPetBeltCurrentChange(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0.vars.pet_belt:getControl(arg_9_1)
	local var_9_1 = arg_9_0.vars.pet_belt:getControl(arg_9_2)
	
	if var_9_0 then
		var_9_0:getChildByName("add"):setVisible(false)
	end
	
	if var_9_1 then
		var_9_1:getChildByName("add"):setVisible(true)
	end
end

function PetUIBase.getCurrencies(arg_10_0)
	return {
		"crystal",
		"gold",
		"stamina",
		"ma_petpoint"
	}
end

function PetUIBase.initTopBar(arg_11_0, arg_11_1)
	TopBarNew:createFromPopup(T("ui_pet_house_title"), arg_11_0.vars.base_wnd, function()
		PetUIMain:onPushBackButton()
	end, arg_11_0:getCurrencies())
end

function PetUIBase.getPopupLayer(arg_13_0)
	return SceneManager:getRunningPopupScene()
end

function PetUIBase.getBaseUI(arg_14_0)
	return arg_14_0.vars.base_layer
end

function PetUIBase.onLeave(arg_15_0)
	arg_15_0.vars.pet_belt:destroy()
	UIUtil:deletePetBelt("PetUIBase")
end
