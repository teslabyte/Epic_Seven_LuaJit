EXPBar = {}

local function var_0_0()
	local var_1_0 = Battle.logic.friends[1]
	
	var_1_0.ui_vars.exp_gauge = EXPBar:create(var_1_0)
	
	var_1_0.ui_vars.exp_gauge.control:setAnchorPoint(0.5, 0.5)
	var_1_0.ui_vars.exp_gauge.control:setLocalZOrder(100000)
	var_1_0.ui_vars.exp_gauge:set({
		prev_exp = 2000,
		to = 0.2,
		from = 0.1
	})
end

function test_expbar()
	dofile(cc.FileUtils:getInstance():fullPathForFilename("script/expbar.lua"))
	var_0_0()
end

function EXPBar.create(arg_3_0, arg_3_1)
	local var_3_0 = {}
	local var_3_1 = "wnd/expbar.csb"
	
	var_3_0.control = cc.CSLoader:createNode(var_3_1)
	
	var_3_0.control:setAnchorPoint(0.5, 0)
	var_3_0.control:setVisible(true)
	
	var_3_0.exp = var_3_0.control:getChildByName("gauge")
	var_3_0.exp_white = var_3_0.control:getChildByName("gauge_white")
	var_3_0.states = {}
	
	var_3_0.control:setPosition(56, 10)
	
	if arg_3_1.ui_vars.gauge and arg_3_1.ui_vars.gauge:isValid() then
		arg_3_1.ui_vars.gauge.control:addChild(var_3_0.control)
	end
	
	copy_functions(EXPBar, var_3_0)
	
	var_3_0.owner = arg_3_1
	
	local var_3_2 = Account:getUnit(arg_3_1.inst.uid)
	
	if var_3_2 then
		var_3_0.start_exp = var_3_2.inst.exp or 0
	else
		var_3_0.start_exp = 0
	end
	
	return var_3_0
end

function EXPBar.updateLv(arg_4_0)
end

function EXPBar.Set(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8, arg_5_9, arg_5_10)
	local var_5_0 = arg_5_1:getChildByName("gauge")
	local var_5_1 = arg_5_1:getChildByName("gauge_white")
	
	arg_5_2 = arg_5_2 or 0
	arg_5_3 = arg_5_3 or arg_5_2
	arg_5_7 = arg_5_7 or 0
	arg_5_8 = arg_5_8 or 20
	
	local var_5_2 = 0
	
	if not tonumber(arg_5_4) then
		local var_5_3 = 0
	end
	
	local var_5_4 = arg_5_2
	local var_5_5 = arg_5_3
	local var_5_6 = 500
	local var_5_7
	
	if arg_5_6 then
		var_5_7 = NONE()
	else
		var_5_7 = TARGET(arg_5_1, SHOW(false))
	end
	
	if arg_5_3 < arg_5_2 or arg_5_5 then
		var_5_1:setPercent(0)
		var_5_0:setVisible(true)
		var_5_0:setPercent(var_5_4 * 100)
		BattleUIAction:AddAsync(SEQ(TARGET(arg_5_1, SHOW(true)), DELAY(200), LOG(PROGRESS(var_5_6 / 2, var_5_4, 1)), DELAY(var_5_6 / 2), CALL(arg_5_0.updateLv, arg_5_0), TARGET(var_5_0, SHOW(false)), LOG(PROGRESS(var_5_6, 0, var_5_5)), DELAY(500), var_5_7), var_5_1)
	elseif arg_5_2 < arg_5_3 then
		var_5_0:setPercent(var_5_4 * 100)
		var_5_1:setPercent(var_5_4 * 100)
		BattleUIAction:AddAsync(SEQ(TARGET(arg_5_1, SHOW(true)), DELAY(200), LOG(PROGRESS(var_5_6, var_5_4, var_5_5)), DELAY(500), var_5_7), var_5_1)
	else
		var_5_0:setPercent(var_5_5 * 100)
		BattleUIAction:AddAsync(SEQ(TARGET(arg_5_1, SHOW(true)), DELAY(700 + var_5_6), var_5_7), var_5_1)
	end
	
	if arg_5_4 then
		UIUtil:playExpNumber({
			from_exp = 0,
			layer = arg_5_1,
			add_exp = arg_5_4,
			x = arg_5_7,
			y = arg_5_8,
			dist_exp = arg_5_9,
			exp_under_line = arg_5_10
		})
	end
end
