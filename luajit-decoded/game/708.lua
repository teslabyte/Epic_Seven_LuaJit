LotaStatusUI = {}

function HANDLER.clan_heritage_status(arg_1_0, arg_1_1)
	local var_1_0 = LotaStatusUI:isDlgVisible()
	
	if var_1_0 == nil then
		return 
	end
	
	if arg_1_1 == "btn_go_enhancement " then
		if LotaLevelInfoUI:isOpen() or not var_1_0 then
			return 
		end
		
		LotaRoleEnhancementUI:open(LotaStatusUI:getPopupLayer())
		LotaStatusUI:setVisible(false)
	end
	
	if arg_1_1 == "btn_registration_hero" then
		if LotaLevelInfoUI:isOpen() or not var_1_0 then
			return 
		end
		
		if LotaRegistrationUI:isAvailableEnter() then
			LotaStatusUI:setVisible(false)
			LotaRegistrationUI:open(LotaStatusUI:getPopupLayer(), {
				register_list = LotaUserData:getRegistrationList(),
				close_callback = function()
					LotaStatusUI:setVisible(true)
					LotaStatusUI:update()
				end
			})
		else
			LotaRegistrationUI:sendWarningMessage()
		end
	end
	
	if arg_1_1 == "btn_go_hero" then
		if LotaLevelInfoUI:isOpen() or not var_1_0 then
			return 
		end
		
		if LotaHeroInformationUI:open(LotaStatusUI:getPopupLayer(), {
			close_callback = function()
				LotaStatusUI:update()
				LotaStatusUI:setVisible(true)
			end
		}) then
			LotaStatusUI:setVisible(false)
		end
	end
	
	if arg_1_1 == "btn_expedition_benefit" then
		if not var_1_0 then
			return 
		end
		
		LotaLevelInfoUI:init(LotaStatusUI:getPopupLayer())
	end
end

function LotaStatusUI.open(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0.vars = {}
	arg_4_0.vars.info = arg_4_2
	arg_4_0.vars.dlg = LotaUtil:getUIDlg("clan_heritage_status")
	
	TopBarNew:createFromPopup(T("ui_clanheritage_status_title"), arg_4_0.vars.dlg, function()
		arg_4_0:onPushBackButton()
	end)
	TopBarNew:setCurrencies({
		"clanheritage",
		"clanheritagecoin"
	})
	TopBarNew:checkhelpbuttonID("heritagelevel")
	arg_4_1:addChild(arg_4_0.vars.dlg)
	
	arg_4_0.vars.parent_layer = arg_4_1
	
	arg_4_0:updateUI()
end

function LotaStatusUI.isDlgVisible(arg_6_0)
	if not arg_6_0.vars or not get_cocos_refid(arg_6_0.vars.dlg) then
		return 
	end
	
	return (arg_6_0.vars.dlg:isVisible())
end

function LotaStatusUI.isActive(arg_7_0)
	return arg_7_0.vars and get_cocos_refid(arg_7_0.vars.dlg)
end

function LotaStatusUI.getPopupLayer(arg_8_0)
	return arg_8_0.vars.parent_layer
end

function LotaStatusUI.setVisible(arg_9_0, arg_9_1)
	if not arg_9_0.vars or not get_cocos_refid(arg_9_0.vars.dlg) then
		return 
	end
	
	if_set_visible(arg_9_0.vars.dlg, nil, arg_9_1)
end

function LotaStatusUI.update(arg_10_0)
	arg_10_0.vars.info = LotaUtil:getMyUserInfo()
	
	arg_10_0:updateUI()
end

function LotaStatusUI.onPushBackButton(arg_11_0)
	if not arg_11_0.vars then
		return 
	end
	
	arg_11_0.vars.dlg:removeFromParent()
	
	arg_11_0.vars = nil
	
	TopBarNew:pop()
	BackButtonManager:pop("상태창!")
end

function LotaStatusUI.updateUI(arg_12_0)
	local var_12_0 = arg_12_0.vars.info
	
	LotaUtil:updateUserInfoUI(arg_12_0.vars.dlg, var_12_0)
	LotaUtil:updateBenefit(arg_12_0.vars.dlg, var_12_0)
	LotaUtil:setJobLevelUI(arg_12_0.vars.dlg, true)
	
	local var_12_1 = arg_12_0.vars.dlg:findChildByName("n_enhancement_meterial")
	
	if_set(var_12_1, "txt_count", var_12_0.enhance_material_count)
	
	local var_12_2 = arg_12_0.vars.dlg:findChildByName("n_registration_count")
	local var_12_3 = table.count(var_12_0.hero_register_list)
	local var_12_4 = LotaUtil:getMaxHeroCount(var_12_0.exp)
	
	if_set(var_12_2, "txt_registration_count", var_12_3 .. "/" .. var_12_4)
	
	local var_12_5 = arg_12_0.vars.dlg:findChildByName("btn_registration_hero")
	local var_12_6 = var_12_5:findChildByName("noti_count")
	
	if LotaRegistrationUI:isAvailableEnter() then
		if_set(var_12_6, "count_hero", var_12_4 - var_12_3)
		if_set_visible(var_12_6, nil, var_12_3 < var_12_4)
		if_set_opacity(var_12_5, nil, 255)
	else
		if_set_visible(var_12_6, nil, false)
		if_set_opacity(var_12_5, nil, 76.5)
	end
	
	local var_12_7 = arg_12_0.vars.dlg:findChildByName("btn_go_enhancement ")
	
	if_set_visible(var_12_7, "icon_noti", LotaUserData:isUpgradeable())
	if_set_opacity(arg_12_0.vars.dlg, "btn_go_hero", var_12_3 > 0 and 255 or 76.5)
end
