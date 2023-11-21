BattleUtil = {}

function BattleUtil.initVars(arg_1_0)
	if not arg_1_0.vars then
		arg_1_0.vars = {}
		arg_1_0.vars.pending_clear_units = {}
	end
end

function BattleUtil.getZ(arg_2_0, arg_2_1)
	return DESIGN_HEIGHT - arg_2_1
end

function BattleUtil.setZ(arg_3_0, arg_3_1)
	local var_3_0 = 0
	
	if arg_3_1.inst.line == BACK then
		var_3_0 = var_3_0 + 1
	end
	
	arg_3_1.z = BattleUtil:getZ(arg_3_1.y) + var_3_0
end

function BattleUtil.getCamY(arg_4_0, arg_4_1)
	return math.max(150 + (arg_4_1 or 0), DEF_CAM_Y)
end

function BattleUtil.getNearPos(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0
	local var_5_1 = math.huge
	local var_5_2 = 0
	
	for iter_5_0, iter_5_1 in pairs(arg_5_2) do
		local var_5_3 = math.abs(iter_5_1.x - arg_5_1.x)
		
		if var_5_3 < var_5_1 then
			var_5_1 = var_5_3
			var_5_0 = iter_5_1
		end
		
		var_5_2 = var_5_2 + iter_5_1.y
	end
	
	return BattleUtil:getTargetPos(var_5_0, 200), var_5_2 / #arg_5_2
end

function BattleUtil.getFrontPos(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0
	local var_6_1
	local var_6_2 = 0
	
	for iter_6_0, iter_6_1 in pairs(arg_6_1) do
		var_6_0 = math.max(var_6_0 or iter_6_1.x, iter_6_1.x)
		var_6_1 = math.min(var_6_1 or iter_6_1.x, iter_6_1.x)
		var_6_2 = var_6_2 + iter_6_1.y
	end
	
	if arg_6_2 then
		return var_6_1 - 120, var_6_2 / #arg_6_1
	end
	
	return var_6_0 + 120, var_6_2 / #arg_6_1
end

function BattleUtil.getCenterPos(arg_7_0, arg_7_1)
	local var_7_0 = 0
	local var_7_1 = 0
	
	for iter_7_0, iter_7_1 in pairs(arg_7_1) do
		var_7_0 = var_7_0 + iter_7_1.x
		var_7_1 = var_7_1 + iter_7_1.y
	end
	
	return var_7_0 / #arg_7_1, var_7_1 / #arg_7_1
end

function BattleUtil.getCenterInitPos(arg_8_0, arg_8_1)
	local var_8_0 = 0
	local var_8_1 = 0
	
	for iter_8_0, iter_8_1 in pairs(arg_8_1) do
		var_8_0 = var_8_0 + iter_8_1.init_x
		var_8_1 = var_8_1 + iter_8_1.init_y
	end
	
	return var_8_0 / #arg_8_1, var_8_1 / #arg_8_1
end

local function var_0_0(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	if arg_9_4 == nil then
		arg_9_4 = 200 * MODEL_SCALE_FACTOR
	end
	
	local var_9_0 = 1
	
	if arg_9_5 then
		var_9_0 = DB("character", arg_9_5.inst.code, "atk_range")
	end
	
	local var_9_1 = arg_9_4 * var_9_0
	
	if arg_9_1.db.size == 4 then
		var_9_1 = var_9_1 + 50 * MODEL_SCALE_FACTOR
	elseif arg_9_1.db.size == 9 then
		var_9_1 = var_9_1 + 100 * MODEL_SCALE_FACTOR
	end
	
	if arg_9_5 then
		if arg_9_5.db.size == 4 then
			var_9_1 = var_9_1 + 50 * MODEL_SCALE_FACTOR
		elseif arg_9_5.db.size == 9 then
			var_9_1 = var_9_1 + 100 * MODEL_SCALE_FACTOR
		end
	end
	
	if arg_9_1.model then
		if arg_9_1.model:getScaleX() < 0 then
			arg_9_2 = arg_9_2 - var_9_1
		else
			arg_9_2 = arg_9_2 + var_9_1
		end
	else
		if arg_9_1.inst.ally == FRIEND then
			arg_9_2 = arg_9_2 + var_9_1
		end
		
		if arg_9_1.inst.ally == ENEMY then
			arg_9_2 = arg_9_2 - var_9_1
		end
	end
	
	return arg_9_2, arg_9_3
end

function BattleUtil.getTargetInitPos(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = arg_10_1.init_x
	local var_10_1 = arg_10_1.init_y
	
	return var_0_0(arg_10_0, arg_10_1, var_10_0, var_10_1, arg_10_2, arg_10_3)
end

function BattleUtil.getTargetStandPos(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = arg_11_1.x
	local var_11_1 = arg_11_1.y
	
	return var_0_0(arg_11_0, arg_11_1, var_11_0, var_11_1, arg_11_2, arg_11_3)
end

function BattleUtil.getTargetPos(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0, var_12_1 = arg_12_1.model:getPosition()
	
	return var_0_0(arg_12_0, arg_12_1, var_12_0, var_12_1, arg_12_2, arg_12_3)
end

function BattleUtil.removeModel(arg_13_0, arg_13_1)
	if arg_13_1 and get_cocos_refid(arg_13_1) then
		arg_13_1:cleanupReferencedObject()
		arg_13_1:removeFromParent()
	end
end

function BattleUtil.clearUnit(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_1.ui_vars and arg_14_1.ui_vars.gauge
	
	if var_14_0 then
		var_14_0:remove()
		
		arg_14_1.ui_vars.gauge = nil
	end
	
	arg_14_1:clearVars(arg_14_2)
	
	if get_cocos_refid(arg_14_1.model) then
		arg_14_1.model:cleanupReferencedObject()
	end
end

function BattleUtil.clearModel(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_1.model
	
	print("DEBUG #UNIT Model삭제 됨", get_cocos_refid(var_15_0))
	arg_15_0:removeModel(var_15_0)
	
	arg_15_1.shadow = nil
	arg_15_1.model = nil
	arg_15_1.elite_effects = nil
end

function BattleUtil.updateModel(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0
	
	if arg_16_1.getTransformVars then
		var_16_0 = arg_16_1:getTransformVars()
	end
	
	local var_16_1
	
	if var_16_0 and not table.empty(var_16_0) then
		var_16_1 = var_16_0
	else
		var_16_1 = arg_16_1.model_vars
	end
	
	if var_16_1 and var_16_1.model_id then
		local var_16_2 = var_16_1.model_id
		
		if get_cocos_refid(arg_16_1.model) then
			arg_16_1.model:changeBodyTo("model/" .. var_16_2 .. ".scsp", "model/" .. var_16_2 .. ".atlas")
			
			if var_16_1.model_opt then
				arg_16_1.model:loadOption("model/" .. var_16_1.model_opt)
			end
			
			if var_16_1.skin then
				arg_16_1.model:setSkin(var_16_1.skin)
			end
		end
	elseif get_cocos_refid(arg_16_1.model) then
		arg_16_1.model:changeBodyTo()
	end
	
	if get_cocos_refid(arg_16_1.model) and arg_16_2 then
		arg_16_1.model:setAnimation(0, arg_16_2, true)
	end
end

function BattleUtil.collectClearUnits(arg_17_0, arg_17_1)
	arg_17_0:initVars()
	
	arg_17_1 = arg_17_1 or {}
	
	local var_17_0 = systick()
	
	for iter_17_0, iter_17_1 in pairs(arg_17_0.vars.pending_clear_units) do
		if var_17_0 - iter_17_1 > 5000 then
			arg_17_0.vars.pending_clear_units[iter_17_0] = nil
			
			arg_17_0:clearUnit(iter_17_0)
			arg_17_0:clearModel(iter_17_0)
		end
	end
end

function BattleUtil.pendingClearUnits(arg_18_0, arg_18_1)
	arg_18_0:initVars()
	
	for iter_18_0, iter_18_1 in pairs(arg_18_1) do
		if get_cocos_refid(iter_18_1.model) then
			iter_18_1.model:cleanupReferencedObject()
		end
		
		local var_18_0 = iter_18_1.ui_vars and iter_18_1.ui_vars.gauge
		
		if var_18_0 then
			var_18_0:setVisible(false)
		end
		
		arg_18_0.vars.pending_clear_units[iter_18_1] = systick()
	end
end

function BattleUtil.clearUnits(arg_19_0, arg_19_1, arg_19_2)
	for iter_19_0, iter_19_1 in pairs(arg_19_1) do
		arg_19_0:clearUnit(iter_19_1, arg_19_2)
	end
end

function BattleUtil.clearUnitVars(arg_20_0, arg_20_1, arg_20_2)
	for iter_20_0, iter_20_1 in pairs(arg_20_1) do
		iter_20_1:clearVars(arg_20_2)
	end
end

function BattleUtil.playMapTitle(arg_21_0, arg_21_1, arg_21_2)
	if arg_21_2 == "tow" then
		return 
	end
	
	if arg_21_1 == "pvp001" or string.starts(arg_21_1, "rta") then
		return 
	end
	
	if string.starts(arg_21_1 or "", "clan") then
		return 
	end
	
	local var_21_0, var_21_1 = DB("level_enter", arg_21_1, {
		"name",
		"local"
	})
	local var_21_2 = load_dlg("map_title", true, "wnd")
	
	if_set(var_21_2, "txt_fieldname", T(var_21_1))
	if_set(var_21_2, "txt_placename", T(var_21_0))
	var_21_2:setCascadeOpacityEnabled(true)
	var_21_2:setOpacity(0)
	BattleUIAction:Add(SEQ(FADE_IN(1000), DELAY(1660), LOG(FADE_OUT(1000)), REMOVE()), var_21_2, "battle.title")
	BGI.ui_layer:addChild(var_21_2)
	print("PLAY MAP TITLE : ", T(var_21_0), T(var_21_1))
end

function BattleUtil.isEnterableFloor(arg_22_0, arg_22_1, arg_22_2)
	if arg_22_1 == "hunt" and arg_22_2 > (GAME_STATIC_VARIABLE.hunt_last_floor or 11) then
		return false
	end
	
	return true
end

local function var_0_1(arg_23_0)
	local function var_23_0(arg_24_0)
		if type(arg_24_0) == "function" then
			arg_24_0 = string.dump(arg_24_0, true)
		end
		
		local var_24_0
		local var_24_1
		local var_24_2
		local var_24_3 = 4294967295
		
		for iter_24_0 = 1, #arg_24_0 do
			local var_24_4 = string.byte(arg_24_0, iter_24_0)
			
			var_24_3 = bit.bxor(var_24_3, var_24_4)
			
			for iter_24_1 = 1, 8 do
				local var_24_5 = -bit.band(var_24_3, 1)
				
				var_24_3 = bit.bxor(bit.rshift(var_24_3, 1), bit.band(3988292384, var_24_5))
			end
		end
		
		return bit.band(bit.bnot(var_24_3), 4294967295)
	end
	
	local var_23_1 = {}
	
	for iter_23_0, iter_23_1 in pairs(arg_23_0) do
		if type(iter_23_1) == "function" then
			local var_23_2 = var_23_0(iter_23_1)
			
			table.insert(var_23_1, {
				iter_23_0,
				var_23_2
			})
		end
	end
	
	table.sort(var_23_1, function(arg_25_0, arg_25_1)
		return arg_25_0[1] < arg_25_1[1]
	end)
	
	local var_23_3 = 427364645
	
	for iter_23_2, iter_23_3 in ipairs(var_23_1) do
		var_23_3 = bit.bxor(var_23_3, iter_23_3[2])
	end
	
	local var_23_4 = bit.band(var_23_3, 4294967295)
	
	return {
		cs = var_23_4,
		mcs = var_23_1
	}
end

local function var_0_2()
	return {
		ep_1 = var_0_1(BattleLogic),
		ep_2 = var_0_1(UNIT)
	}
end

local function var_0_3()
	local var_27_0 = var_0_2()
	
	for iter_27_0, iter_27_1 in pairs(var_27_0) do
		var_27_0[iter_27_0] = bit.tohex(iter_27_1.cs)
	end
	
	return var_27_0
end

function BattleUtil.getPlayingEpisode(arg_28_0)
	return var_0_3()
end
