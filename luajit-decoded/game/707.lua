LotaStatusLegacyUI = {}

function HANDLER.clan_heritage_legacy(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		LotaStatusLegacyUI:close()
	end
	
	if string.find(arg_1_1, "btn_%d") then
		local var_1_0 = string.sub(arg_1_1, -1, -1)
		local var_1_1 = tonumber(var_1_0)
		
		LotaStatusLegacyUI:select(var_1_1)
	end
end

function LotaStatusLegacyUI.open(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.vars = {}
	arg_2_0.vars.dlg = LotaUtil:getUIDlg("clan_heritage_legacy")
	
	arg_2_1:addChild(arg_2_0.vars.dlg)
	
	arg_2_0.vars.movable = arg_2_2
	arg_2_0.vars.artifact_items = arg_2_2.artifact_items
	
	arg_2_0:updateUI(arg_2_0.vars.movable)
	BackButtonManager:push({
		check_id = "lota_legacy",
		back_func = function()
			arg_2_0:close()
		end
	})
end

function LotaStatusLegacyUI.close(arg_4_0)
	if not arg_4_0.vars or not get_cocos_refid(arg_4_0.vars.dlg) then
		return 
	end
	
	arg_4_0.vars.dlg:removeFromParent()
	
	arg_4_0.vars = nil
	
	LotaSystem:setBlockCoolTime()
	BackButtonManager:pop("lota_legacy")
end

function LotaStatusLegacyUI.onDeselect(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0.vars.dlg:findChildByName("n_slot" .. arg_5_1):findChildByName("n_select")
	
	LotaUtil:onDeselectAnimation(var_5_0, "status_legacy")
end

function LotaStatusLegacyUI.onSelectAnimation(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.vars.dlg:findChildByName("n_slot" .. arg_6_1):findChildByName("n_select")
	
	LotaUtil:onSelectAnimation(var_6_0, "status_legacy")
end

function LotaStatusLegacyUI.select(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.vars.artifact_items[arg_7_1]
	
	if not var_7_0 then
		return 
	end
	
	if arg_7_0.vars.selected_idx then
		arg_7_0:onDeselect(arg_7_0.vars.selected_idx)
	end
	
	if_set_visible(arg_7_0.vars.dlg, "n_selected", true)
	LotaUtil:updateLegacyTooltip(arg_7_0.vars.dlg, var_7_0, {
		dont_pos = true,
		n_detail_name = "n_selected"
	})
	arg_7_0:onSelectAnimation(arg_7_1)
	
	arg_7_0.vars.selected_idx = arg_7_1
end

function LotaStatusLegacyUI.updateUI(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.vars.dlg
	local var_8_1 = LotaUtil:getLegacyInventoryMax(arg_8_1.exp)
	
	LotaUtil:updateLegacySlots(var_8_0, arg_8_1.artifact_items, var_8_1, arg_8_1.exp)
end
