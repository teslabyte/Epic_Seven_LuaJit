function HANDLER.clan_heritage_member(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		LotaClanStatusUI:close()
	end
end

LotaClanStatusUI = {}

function LotaClanStatusUI.init(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.vars = {}
	arg_2_0.vars.layer = arg_2_1
	arg_2_0.vars.response = arg_2_2
	arg_2_0.vars.dlg = load_dlg("clan_heritage_member", true, "wnd")
	arg_2_0.vars.sort_idx = nil
	arg_2_0.vars.member_sorter = Sorter:create(arg_2_0.vars.dlg:findChildByName("n_sort"))
	
	arg_2_0.vars.member_sorter:setSorter({
		default_sort_index = 1,
		menus = {
			{
				name = T("ui_clanheritage_status_sort_2"),
				func = function(arg_3_0, arg_3_1)
					return arg_3_0.exp > arg_3_1.exp
				end
			},
			{
				name = T("ui_clanheritage_status_sort_3"),
				func = function(arg_4_0, arg_4_1)
					return arg_4_0.ap > arg_4_1.ap
				end
			}
		},
		callback_sort = function(arg_5_0, arg_5_1)
			arg_2_0:updateData()
		end
	})
	arg_2_0.vars.layer:addChild(arg_2_0.vars.dlg)
	BackButtonManager:push({
		check_id = "clan_status",
		back_func = function()
			arg_2_0:close()
		end
	})
	arg_2_0:setupUI()
end

function LotaClanStatusUI.setupUI(arg_7_0)
	LotaClanStatusScrollView:init(arg_7_0.vars.dlg:findChildByName("ScrollView"), arg_7_0.vars.response.user_data_hash)
	LotaClanStatusScrollView:bindingSorter(arg_7_0.vars.member_sorter)
	arg_7_0.vars.member_sorter:sort(1)
	
	local var_7_0 = arg_7_0.vars.dlg:findChildByName("btn_toggle")
	
	var_7_0:setContentSize(228, 47)
	
	local var_7_1 = var_7_0:findChildByName("txt_cur_sort")
	
	var_7_1:setContentSize(211, 26)
	UIUserData:call(var_7_1, "SINGLE_WSCALE(168)", {
		origin_scale_x = 0.78
	})
	
	local var_7_2 = arg_7_0.vars.dlg:findChildByName("btn_toggle_active")
	
	var_7_2:setContentSize(228, 47)
	
	local var_7_3 = var_7_2:findChildByName("txt_cur_sort")
	
	var_7_3:setContentSize(211, 26)
	UIUserData:call(var_7_3, "SINGLE_WSCALE(168)", {
		origin_scale_x = 0.78
	})
end

function LotaClanStatusUI.updateData(arg_8_0)
	LotaClanStatusScrollView:update()
	
	local var_8_0 = LotaClanStatusScrollView:getItemCount()
	
	if_set_visible(arg_8_0.vars.dlg, "n_no_data", var_8_0 == 0)
end

function LotaClanStatusUI.close(arg_9_0)
	if not arg_9_0.vars or not get_cocos_refid(arg_9_0.vars.dlg) then
		return 
	end
	
	if LotaSystem:isActive() then
		LotaSystem:setBlockCoolTime()
	end
	
	arg_9_0.vars.dlg:removeFromParent()
	
	arg_9_0.vars = nil
	
	BackButtonManager:pop("clan_status")
end

LotaClanStatusScrollView = {}

copy_functions(ScrollView, LotaClanStatusScrollView)

function LotaClanStatusScrollView.init(arg_10_0, arg_10_1, arg_10_2)
	arg_10_0.vars = {}
	
	arg_10_0:initScrollView(arg_10_1, 762, 108)
	arg_10_0:setupData(arg_10_2)
end

function LotaClanStatusScrollView.setupData(arg_11_0, arg_11_1)
	arg_11_0.vars.data = arg_11_1
	
	local var_11_0 = {}
	
	for iter_11_0, iter_11_1 in pairs(arg_11_0.vars.data) do
		if iter_11_1.user_info then
			table.insert(var_11_0, iter_11_1)
		end
	end
	
	arg_11_0.vars.list = var_11_0
	
	arg_11_0:updateScrollViewItems(var_11_0)
end

function LotaClanStatusScrollView.update(arg_12_0)
	arg_12_0:updateScrollViewItems(arg_12_0.vars.list)
end

function LotaClanStatusScrollView.getItemCount(arg_13_0)
	return table.count(arg_13_0.vars.list)
end

function LotaClanStatusScrollView.bindingSorter(arg_14_0, arg_14_1)
	arg_14_1:setItems(arg_14_0.vars.list)
end

function LotaClanStatusScrollView.setJobElements(arg_15_0, arg_15_1, arg_15_2)
	LotaUtil:updateJobLevelUIElement(arg_15_1, arg_15_2.role, arg_15_2.lv, 15, arg_15_2.lv, 0, 0, true)
	
	local var_15_0 = "img/" .. CollectionUtil.ROLE_COMP_TO_KEY_DATA_ICON[arg_15_2.role]
	
	SpriteCache:resetSprite(arg_15_1:findChildByName("icon_jop"), var_15_0)
end

function LotaClanStatusScrollView.getScrollViewItem(arg_16_0, arg_16_1)
	local var_16_0 = load_control("wnd/clan_heritage_member_item.csb")
	local var_16_1 = arg_16_1.user_info
	local var_16_2 = UNIT:create({
		code = var_16_1.leader_code
	})
	local var_16_3 = var_16_1.border_code
	
	UIUtil:getUserIcon(var_16_2, {
		no_popup = true,
		no_lv = true,
		no_role = true,
		no_grade = true,
		parent = var_16_0:getChildByName("n_face_icon"),
		border_code = var_16_3
	})
	
	local var_16_4 = var_16_0:findChildByName("n_lv_0")
	
	UIUtil:setLevel(var_16_4, var_16_1.level, nil, 6)
	if_set(var_16_0, "t_name", var_16_1.name)
	if_set_color(var_16_0, "t_name", var_16_1.id == AccountData.id and cc.c3b(107, 193, 27) or cc.c3b(255, 255, 255))
	
	local var_16_5 = arg_16_1.ap
	local var_16_6 = LotaUserData:getConfigMaxActionPoint()
	local var_16_7 = LotaUtil:getUserLevel(arg_16_1.exp)
	
	LotaUtil:updateLevelIconWithLv(var_16_0, var_16_7)
	if_set(var_16_0, "t_token_count", var_16_5 .. "/" .. var_16_6)
	
	local var_16_8 = {}
	local var_16_9 = arg_16_1.job_levels or {}
	
	for iter_16_0, iter_16_1 in pairs(LotaUtil:getListRoles()) do
		if not var_16_9[iter_16_1] then
			table.insert(var_16_8, {
				lv = 1,
				role = iter_16_1
			})
		else
			table.insert(var_16_8, {
				lv = var_16_9[iter_16_1],
				role = iter_16_1
			})
		end
	end
	
	table.sort(var_16_8, function(arg_17_0, arg_17_1)
		return arg_17_0.lv > arg_17_1.lv
	end)
	
	local var_16_10 = var_16_8[1]
	local var_16_11 = var_16_8[2]
	
	arg_16_0:setJobElements(var_16_0:findChildByName("n_jop01"), var_16_10)
	arg_16_0:setJobElements(var_16_0:findChildByName("n_jop02"), var_16_11)
	
	return var_16_0
end
