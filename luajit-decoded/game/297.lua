TutorialNotice = TutorialNotice or {}
TutorialNotice.vars = {}

local var_0_0 = "tutorial_indicator"
local var_0_1 = "tutorial_notice"

local function var_0_2(arg_1_0)
	local var_1_0 = arg_1_0:getParent()
	
	while tolua.type(var_1_0) ~= "ccui.ScrollView" and tolua.type(var_1_0) ~= "cc.Layer" do
		if not get_cocos_refid(var_1_0) then
			return nil
		end
		
		var_1_0 = var_1_0:getParent()
	end
	
	return var_1_0
end

local function var_0_3(arg_2_0, arg_2_1)
	for iter_2_0, iter_2_1 in pairs(arg_2_0:getChildren()) do
		if iter_2_1.guide_tag == arg_2_1 then
			return iter_2_1
		end
	end
	
	return nil
end

local function var_0_4(arg_3_0, arg_3_1, arg_3_2)
	if arg_3_1 == "" then
		return var_0_3(arg_3_0, arg_3_2)
	end
	
	if arg_3_0:getName() == arg_3_1 and arg_3_0.guide_tag == arg_3_2 then
		return arg_3_0
	end
	
	local var_3_0 = arg_3_0:getChildByName(arg_3_1)
	
	if not get_cocos_refid(var_3_0) then
		return nil
	end
	
	if not var_3_0.guide_tag then
		return nil
	end
	
	if var_3_0.guide_tag == arg_3_2 then
		return var_3_0
	end
	
	local var_3_1 = var_0_2(var_3_0)
	
	if not get_cocos_refid(var_3_1) then
		return nil
	end
	
	for iter_3_0, iter_3_1 in pairs(var_3_1:getChildren()) do
		if iter_3_1:getName() == arg_3_1 and iter_3_1.guide_tag == arg_3_2 then
			return iter_3_1
		end
		
		local var_3_2 = iter_3_1:getChildByName(arg_3_1)
		
		if get_cocos_refid(var_3_2) and var_3_2.guide_tag == arg_3_2 then
			return var_3_2
		end
	end
	
	return nil
end

local function var_0_5(arg_4_0)
	local var_4_0 = SceneManager:getRunningRootScene()
	
	for iter_4_0, iter_4_1 in pairs(string.split(arg_4_0, "/")) do
		local var_4_1, var_4_2 = iter_4_1:find("%b[]")
		
		if var_4_1 then
			local var_4_3 = iter_4_1:sub(1, var_4_1 - 1)
			local var_4_4 = iter_4_1:sub(var_4_1 + 1, var_4_2 - 1)
			
			var_4_0 = var_0_4(var_4_0, var_4_3, var_4_4)
		else
			var_4_0 = var_4_0:getChildByName(iter_4_1)
		end
		
		if not get_cocos_refid(var_4_0) then
			return nil
		end
	end
	
	return var_4_0
end

function TutorialNotice.detach(arg_5_0, arg_5_1)
	if not arg_5_1.ui_target then
		return 
	end
	
	local var_5_0 = var_0_5(arg_5_1.ui_target)
	
	if not get_cocos_refid(var_5_0) then
		return 
	end
	
	local var_5_1 = var_5_0:getChildByName(var_0_0)
	
	if not get_cocos_refid(var_5_1) then
		return 
	end
	
	var_5_1:removeFromParent()
	
	local var_5_2
	
	if var_5_0.force_visible then
		if_set_visible(var_5_0, nil, false)
		
		var_5_0.force_visible = nil
	end
end

function TutorialNotice.detachTutorialIndicators(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0:getDBByTutorialID(arg_6_1)
	
	if not var_6_0 then
		return 
	end
	
	for iter_6_0, iter_6_1 in pairs(var_6_0) do
		arg_6_0:detach(iter_6_1)
	end
end

function TutorialNotice.attachTutorialIndicators(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0:getDBByTutorialID(arg_7_1)
	
	if not var_7_0 then
		return 
	end
	
	for iter_7_0, iter_7_1 in pairs(var_7_0) do
		arg_7_0:attach(iter_7_1)
	end
end

local function var_0_6(arg_8_0, arg_8_1)
	local var_8_0
	
	if string.ends(arg_8_1, ".cfx") then
		local var_8_1 = EffectManager:Play({
			fn = arg_8_1,
			layer = arg_8_0
		})
		
		return 
	end
	
	if string.ends(arg_8_1, ".png") then
		local var_8_2 = cc.Sprite:create(arg_8_1)
		
		if get_cocos_refid(var_8_2) then
			arg_8_0:addChild(var_8_2)
		end
		
		return 
	end
	
	Log.e(var_0_1, arg_8_1 .. "는 유효하지 않은 리소스 입니다.")
end

function TutorialNotice.attach(arg_9_0, arg_9_1)
	if not arg_9_1.ui_target then
		if arg_9_1.is_debug then
			Log.e(var_0_1, string.format("%s: ui_target 이 없습니다.", arg_9_1.id))
		end
		
		return 
	end
	
	local var_9_0 = var_0_5(arg_9_1.ui_target)
	
	if not get_cocos_refid(var_9_0) then
		if arg_9_1.is_debug then
			Log.e(var_0_1, string.format("%s: %s ui_target 이 없습니다.", arg_9_1.id, arg_9_1.ui_target))
		end
		
		return 
	end
	
	if arg_9_1.force or arg_9_1.is_debug then
		if not var_9_0:isVisible() then
			var_9_0.force_visible = true
		end
		
		if_set_visible(var_9_0, nil, true)
	end
	
	if not var_9_0:isVisible() then
		return 
	end
	
	if var_9_0:getChildByName(var_0_0) then
		return 
	end
	
	local var_9_1 = cc.Node:create()
	
	var_9_1:setName(var_0_0)
	var_9_1:setPosition(arg_9_1.pos_x, arg_9_1.pos_y)
	var_9_1:setScale(arg_9_1.scale)
	var_9_0:addChild(var_9_1)
	
	for iter_9_0, iter_9_1 in pairs(arg_9_1.effects) do
		var_0_6(var_9_1, iter_9_1)
	end
end

function TutorialNotice.initDB(arg_10_0)
	if arg_10_0.vars.db then
		return 
	end
	
	local var_10_0 = {}
	local var_10_1 = {}
	local var_10_2 = {}
	
	for iter_10_0 = 1, 999 do
		local var_10_3 = DBNFields("tutorial_notice", iter_10_0, {
			"id",
			"tutorial_id",
			"update_point",
			"ui_target",
			"effects",
			"pos_x",
			"pos_y",
			"scale",
			"force"
		})
		
		if not var_10_3.id then
			break
		end
		
		if var_10_3.effects then
			var_10_3.effects = string.gsub(var_10_3.effects, " ", "")
			var_10_3.effects = string.split(var_10_3.effects, ",")
		end
		
		var_10_3.scale = var_10_3.scale or 1
		
		if var_10_3.force then
			var_10_3.force = string.lower(string.trim(var_10_3.force))
			var_10_3.force = var_10_3.force == "y"
		end
		
		var_10_0[var_10_3.id] = var_10_3
		
		if var_10_3.tutorial_id then
			var_10_1[var_10_3.tutorial_id] = var_10_1[var_10_3.tutorial_id] or {}
			
			table.insert(var_10_1[var_10_3.tutorial_id], var_10_3)
		else
			Log.e(var_0_1, string.format("%s 의 tutorial_id가 없습니다.", var_10_3.id))
		end
		
		if var_10_3.update_point then
			var_10_2[var_10_3.update_point] = var_10_2[var_10_3.update_point] or {}
			
			table.insert(var_10_2[var_10_3.update_point], var_10_3)
		else
			Log.e(var_0_1, string.format("%s 의 update_point가 없습니다.", var_10_3.update_point))
		end
	end
	
	arg_10_0.vars.db = var_10_0
	arg_10_0.vars.db_tutorial_id = var_10_1
	arg_10_0.vars.db_update_point = var_10_2
end

function TutorialNotice.getDB(arg_11_0, arg_11_1)
	arg_11_0:initDB()
	
	if arg_11_1 then
		return arg_11_0.vars.db[arg_11_1]
	end
	
	return arg_11_0.vars.db
end

function TutorialNotice.getDBByTutorialID(arg_12_0, arg_12_1)
	arg_12_0:initDB()
	
	if arg_12_1 then
		return arg_12_0.vars.db_tutorial_id[arg_12_1]
	end
	
	return arg_12_0.vars.db_tutorial_id
end

function TutorialNotice.getDBByUpdatePoint(arg_13_0, arg_13_1)
	arg_13_0:initDB()
	
	if arg_13_1 then
		return arg_13_0.vars.db_update_point[arg_13_1]
	end
	
	return arg_13_0.vars.db_update_point
end

function TutorialNotice.updateSpecific(arg_14_0, arg_14_1)
	arg_14_0:initDB()
	
	local var_14_0 = arg_14_0:getDB(arg_14_1)
	
	if not var_14_0 then
		return 
	end
	
	arg_14_0:proc(var_14_0)
end

function TutorialNotice.detachByPoint(arg_15_0, arg_15_1)
	arg_15_0:initDB()
	
	local var_15_0 = arg_15_0:getDBByUpdatePoint(arg_15_1)
	
	if not var_15_0 then
		return 
	end
	
	for iter_15_0, iter_15_1 in pairs(var_15_0) do
		arg_15_0:detach(iter_15_1)
	end
end

function TutorialNotice.detachByID(arg_16_0, arg_16_1)
	arg_16_0:initDB()
	
	local var_16_0 = arg_16_0:getDB(arg_16_1)
	
	if not var_16_0 then
		return 
	end
	
	arg_16_0:detach(var_16_0)
end

function TutorialNotice.update(arg_17_0, arg_17_1, arg_17_2)
	arg_17_0:initDB()
	
	local var_17_0 = arg_17_0:getDBByUpdatePoint(arg_17_1)
	
	if not var_17_0 then
		return 
	end
	
	for iter_17_0, iter_17_1 in pairs(var_17_0) do
		arg_17_0:proc(iter_17_1, arg_17_2)
	end
end

function TutorialNotice.proc(arg_18_0, arg_18_1, arg_18_2)
	if not TutorialCondition:isEnable(arg_18_1.tutorial_id, arg_18_2) then
		return 
	end
	
	arg_18_0:attach(arg_18_1)
end

function TutorialNotice.___attach(arg_19_0, arg_19_1, arg_19_2)
	if PRODUCTION_MODE then
		return 
	end
	
	if not arg_19_1 then
		return 
	end
	
	local var_19_0 = arg_19_0:getDBByTutorialID(arg_19_1)
	
	if not var_19_0 then
		Log.e(var_0_1, arg_19_1 .. " 에 해당하는 tutorial_notice datas 가 없습니다.")
		
		return 
	end
	
	Log.i(var_0_1, table.print(var_19_0))
	
	arg_19_2 = arg_19_2 or {}
	
	if arg_19_2.is_debug == nil then
		arg_19_2.is_debug = true
	end
	
	arg_19_0:detachTutorialIndicators(arg_19_1)
	
	for iter_19_0, iter_19_1 in pairs(var_19_0) do
		iter_19_1.is_debug = arg_19_2.is_debug
		iter_19_1.pos_x = arg_19_2.x or iter_19_1.pos_x
		iter_19_1.pos_y = arg_19_2.y or iter_19_1.pos_y
		iter_19_1.scale = arg_19_2.scale or iter_19_1.scale
		
		arg_19_0:detach(iter_19_1)
		arg_19_0:attach(iter_19_1)
	end
end

function TutorialNotice.__attach(arg_20_0, arg_20_1, arg_20_2)
	if PRODUCTION_MODE then
		return 
	end
	
	arg_20_2 = arg_20_2 or {}
	
	if arg_20_2.is_debug == nil then
		arg_20_2.is_debug = true
	end
	
	if arg_20_1 then
		local var_20_0 = arg_20_0:getDB(arg_20_1)
		
		if var_20_0 then
			var_20_0.is_debug = arg_20_2.is_debug
			var_20_0.pos_x = arg_20_2.x or var_20_0.pos_x
			var_20_0.pos_y = arg_20_2.y or var_20_0.pos_y
			var_20_0.scale = arg_20_2.scale or var_20_0.scale
			
			arg_20_0:detach(var_20_0)
			arg_20_0:attach(var_20_0)
			Log.i(var_0_1, table.print(var_20_0))
		else
			Log.e(var_0_1, arg_20_1 .. " 에 해당하는 tutorial_notice data 가 없습니다.")
		end
		
		return 
	end
	
	local var_20_1 = arg_20_0:getDB()
	
	if not var_20_1 then
		return 
	end
	
	for iter_20_0, iter_20_1 in pairs(var_20_1) do
		iter_20_1.is_debug = arg_20_2.is_debug
		iter_20_1.pos_x = arg_20_2.x or iter_20_1.pos_x
		iter_20_1.pos_y = arg_20_2.y or iter_20_1.pos_y
		iter_20_1.scale = arg_20_2.scale or iter_20_1.scale
		
		arg_20_0:detach(iter_20_1)
		arg_20_0:attach(iter_20_1)
	end
end
