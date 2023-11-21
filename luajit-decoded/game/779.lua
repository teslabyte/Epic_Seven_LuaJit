function MsgHandler.substory_spl_pos(arg_1_0)
	SPLUserData:setSplData(arg_1_0.spl_doc)
end

function MsgHandler.substory_spl_interaction_object(arg_2_0)
	SPLUserData:setSplData(arg_2_0.spl_doc)
	
	for iter_2_0, iter_2_1 in pairs(arg_2_0.use_object_list or {}) do
		SPLUserData:updateObjectData(iter_2_1)
	end
	
	if arg_2_0.rewards and table.count(arg_2_0.rewards) > 0 then
		local var_2_0 = {
			title = T("tile_sub_box_open_title"),
			desc = T("tile_sub_box_open_desc")
		}
		
		Account:addReward(arg_2_0.rewards, {
			play_reward_data = var_2_0,
			handler = function()
				SPLEventSystem:resume()
			end
		})
	else
		SPLEventSystem:resume()
	end
	
	if arg_2_0.hide_rewards then
		Account:addReward(arg_2_0.hide_rewards)
	end
	
	if arg_2_0.ticketed_limits then
		Account:updateTicketedLimits(arg_2_0.ticketed_limits)
	end
	
	SPLMissionData:updateMissionCompletes()
end

SPLUserData = {}

function SPLUserData.init(arg_4_0, arg_4_1)
	arg_4_0.vars = {}
end

function SPLUserData.getMapId(arg_5_0)
	return SPLUtil:getMapId(arg_5_0:getSubstoryId(), arg_5_0:getUserFloor())
end

function SPLUserData.setData(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0:init()
	SPLData:init()
	
	if not arg_6_1 then
		return 
	end
	
	table.print(arg_6_1)
	arg_6_0:setSplData(arg_6_1.spl_doc)
	arg_6_0:setObjectData(arg_6_1.object_list)
	arg_6_0:setFogData(arg_6_1.fog_list)
end

function SPLUserData.setSplData(arg_7_0, arg_7_1)
	if not arg_7_1 then
		return 
	end
	
	if not arg_7_0.vars then
		return 
	end
	
	arg_7_0.vars.spl_data = arg_7_1
	arg_7_0.vars.last_sync_tm = systick()
end

function SPLUserData.setObjectData(arg_8_0, arg_8_1)
	if not arg_8_1 then
		return 
	end
	
	if not arg_8_0.vars then
		return 
	end
	
	arg_8_0.vars.object_data = arg_8_1
end

function SPLUserData.setFogData(arg_9_0, arg_9_1)
	if not arg_9_1 then
		return 
	end
	
	if not arg_9_0.vars then
		return 
	end
	
	for iter_9_0, iter_9_1 in pairs(arg_9_1) do
		arg_9_0:setFloorFogData(iter_9_1.floor, iter_9_1.floor_view_data)
	end
end

function SPLUserData.setFloorFogData(arg_10_0, arg_10_1, arg_10_2)
	if not arg_10_1 or not arg_10_2 then
		return nil
	end
	
	if not arg_10_0.vars then
		return nil
	end
	
	if not arg_10_0.vars.fog_data then
		arg_10_0.vars.fog_data = {}
	end
	
	if not arg_10_0.vars.fog_data[arg_10_1] then
		arg_10_0.vars.fog_data[arg_10_1] = {}
	end
	
	if arg_10_0.vars.fog_data[arg_10_1] ~= arg_10_2 then
		arg_10_0.vars.fog_data[arg_10_1] = arg_10_2
		
		return true
	end
	
	return false
end

function SPLUserData.getSplData(arg_11_0)
	if not arg_11_0.vars then
		return nil
	end
	
	return arg_11_0.vars.spl_data
end

function SPLUserData.getCurrentFloor(arg_12_0)
	if not arg_12_0.vars then
		return nil
	end
	
	if not arg_12_0.vars.spl_data then
		return nil
	end
	
	return arg_12_0.vars.spl_data.floor
end

function SPLUserData.getPresetID(arg_13_0)
	if not arg_13_0.vars then
		return nil
	end
	
	if not arg_13_0.vars.spl_data then
		return nil
	end
	
	return arg_13_0.vars.spl_data.preset_id
end

function SPLUserData.getObjectData(arg_14_0)
	if not arg_14_0.vars then
		return nil
	end
	
	return arg_14_0.vars.object_data
end

function SPLUserData.getObjectByID(arg_15_0, arg_15_1)
	if not arg_15_0.vars then
		return nil
	end
	
	if not arg_15_0.vars.object_data then
		return nil
	end
	
	return arg_15_0.vars.object_data[arg_15_1]
end

function SPLUserData.updateObjectData(arg_16_0, arg_16_1)
	if not arg_16_0.vars then
		return 
	end
	
	if not arg_16_1 then
		return 
	end
	
	if not arg_16_0.vars.object_data then
		arg_16_0.vars.object_data = {}
	end
	
	local var_16_0 = arg_16_1.obj_id
	
	arg_16_0.vars.object_data[var_16_0] = arg_16_1
	
	if SceneManager:getCurrentSceneName() == "spl" then
		SPLObjectSystem:onResponseObject(var_16_0, arg_16_1)
	end
end

function SPLUserData.getFogData(arg_17_0)
	if not arg_17_0.vars then
		return nil
	end
	
	return arg_17_0.vars.fog_data
end

function SPLUserData.getFloorFogData(arg_18_0, arg_18_1)
	if not arg_18_0.vars then
		return nil
	end
	
	if not arg_18_0.vars.fog_data then
		return nil
	end
	
	return arg_18_0.vars.fog_data[arg_18_1]
end

function SPLUserData.getLastTile(arg_19_0)
	if not arg_19_0.vars then
		return nil
	end
	
	return arg_19_0.vars.spl_data.pos
end

function SPLUserData.getLastSyncTime(arg_20_0)
	if not arg_20_0.vars then
		return nil
	end
	
	return arg_20_0.vars.last_sync_tm
end

function SPLUserData.getFogQueryData(arg_21_0, arg_21_1)
	local var_21_0
	local var_21_1 = SPLFogSystem:getFogString()
	
	if arg_21_0:setFloorFogData(arg_21_1, var_21_1) then
		var_21_0 = {
			[tostring(arg_21_1)] = var_21_1
		}
		var_21_0 = json.encode(var_21_0)
	end
	
	return var_21_0
end

function SPLUserData.queryPos(arg_22_0, arg_22_1)
	local function var_22_0(arg_23_0, arg_23_1)
		return HTUtil:getTileCost(arg_23_0, arg_23_1) < 8
	end
	
	local function var_22_1(arg_24_0)
		return arg_24_0 - arg_22_0:getLastSyncTime() < 60000
	end
	
	local var_22_2 = arg_22_1 or SPLMovableSystem:getPlayerPos()
	local var_22_3 = arg_22_0:getLastTile()
	
	if var_22_3 then
		local var_22_4 = SPLTileMapSystem:getPosById(var_22_3)
		
		if HTUtil:isSamePosition(var_22_2, var_22_4) then
			return 
		end
		
		if var_22_0(var_22_2, var_22_4) and var_22_1(systick()) then
			return 
		end
	end
	
	local var_22_5 = SPLData:getSubstoryID()
	local var_22_6 = SPLTileMapSystem:getTileByPos(var_22_2):getTileId()
	local var_22_7 = 1
	local var_22_8 = SPLUserData:getCurrentFloor()
	local var_22_9 = arg_22_0:getFogQueryData(var_22_8)
	
	query("substory_spl_pos", {
		substory_id = var_22_5,
		tile_id = var_22_6,
		dir = var_22_7,
		floor = var_22_8,
		fog_data = var_22_9
	})
end

function SPLUserData.queryObject(arg_25_0, arg_25_1)
	local var_25_0 = SPLData:getSubstoryID()
	local var_25_1 = SPLMovableSystem:getPlayerPos()
	
	if not var_25_1 then
		Log.e("INVALID PLAYER POS")
		
		return 
	end
	
	local var_25_2 = SPLTileMapSystem:getTileByPos(var_25_1)
	
	if not var_25_2 then
		Log.e("INVALID TILE", var_25_1.x, var_25_1.y)
		
		return 
	end
	
	local var_25_3 = var_25_2:getTileId()
	local var_25_4 = 1
	local var_25_5 = SPLUserData:getCurrentFloor()
	local var_25_6 = arg_25_0:getFogQueryData(var_25_5)
	
	SPLEventSystem:pause()
	query("substory_spl_interaction_object", {
		substory_id = var_25_0,
		tile_id = var_25_3,
		dir = var_25_4,
		floor = var_25_5,
		fog_data = var_25_6,
		object_id = arg_25_1
	})
end

function SPLUserData.queryBattle(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = SPLMovableSystem:getPlayer()
	
	if not var_26_0 then
		return 
	end
	
	local var_26_1 = var_26_0:getNpcTeam()
	
	if not var_26_1 then
		return 
	end
	
	local var_26_2 = SPLData:getSubstoryID()
	local var_26_3 = SPLMovableSystem:getPlayerPos()
	local var_26_4 = SPLTileMapSystem:getTileByPos(var_26_3):getTileId()
	local var_26_5 = 1
	local var_26_6 = SPLUserData:getCurrentFloor()
	local var_26_7 = arg_26_0:getFogQueryData(var_26_6)
	local var_26_8 = {
		npcteam_id = var_26_1,
		sub_story = {
			id = var_26_2
		},
		spl_info = {
			object_id = arg_26_1,
			tile_id = var_26_4,
			dir = var_26_5,
			floor = var_26_6,
			fog_data = var_26_7
		}
	}
	
	print("startBattle", arg_26_2, "?", var_26_1, var_26_2)
	startBattle(arg_26_2, var_26_8)
end

function SPLUserData.debug_warp(arg_27_0, arg_27_1, arg_27_2)
	arg_27_0.vars.spl_data.floor = arg_27_1
	arg_27_0.vars.spl_data.pos = arg_27_2
	
	SceneManager:nextScene("spl")
end

SPLData = SPLData or {}

function SPLData.init(arg_28_0, arg_28_1)
	arg_28_0.vars = {}
end

function SPLData.setSubstoryInfo(arg_29_0, arg_29_1)
	if not arg_29_0.vars then
		return 
	end
	
	arg_29_0.vars.info = arg_29_1
end

function SPLData.getSubstoryInfo(arg_30_0)
	if not arg_30_0.vars then
		return 
	end
	
	local var_30_0 = SubstoryManager:getInfo()
	
	if not arg_30_0.vars.info then
		arg_30_0:setSubstoryInfo(var_30_0)
	end
	
	return arg_30_0.vars.info
end

function SPLData.getSubstoryID(arg_31_0)
	local var_31_0 = arg_31_0:getSubstoryInfo()
	
	if not var_31_0 then
		Log.e("SPLData.getSubstoryID", "substory_info_nil")
		
		return 
	end
	
	return var_31_0.id
end
