GlobalSubstoryManager = GlobalSubstoryManager or {}
GLOBAL_SUBSTORY_CONTENTS_TYPE = {}
GLOBAL_SUBSTORY_CONTENTS_TYPE.SUBSTORY_ALBUM = "substory_album"

function MsgHandler.enter_global_substory(arg_1_0)
	if arg_1_0.global_substory_info then
		Account:setGlobalSubstory(arg_1_0.global_substory_info)
		GlobalSubstoryManager:updateSubstory()
	end
	
	local var_1_0 = GlobalSubstoryManager:getInfoByID(arg_1_0.substory_id)
	
	if not var_1_0 then
		balloon_message_with_sound("no_substory_info")
		
		return 
	end
	
	if arg_1_0.substory_piece_info then
		Account:setSubStoryAlbumPieces(arg_1_0.substory_piece_info)
	end
	
	if arg_1_0.mission_info then
		Account:setSubStoryAlbumMissions(arg_1_0.mission_info)
	end
	
	GlobalSubstoryManager:nextContent({
		info = var_1_0
	})
end

function GlobalSubstoryManager.enterQuery(arg_2_0, arg_2_1)
	local var_2_0, var_2_1 = BackPlayUtil:checkSubstoryInBackPlay()
	
	if not var_2_0 then
		balloon_message_with_sound(var_2_1)
		
		return 
	end
	
	local var_2_2 = SubstoryAlbumMain:isRequestSubStoryPieceAlbum(arg_2_1)
	
	query("enter_global_substory", {
		substory_id = arg_2_1,
		is_request_pieces = var_2_2
	})
end

function GlobalSubstoryManager.nextContent(arg_3_0, arg_3_1)
	arg_3_1 = arg_3_1 or {}
	
	if arg_3_1.info and arg_3_1.info.contents_type == GLOBAL_SUBSTORY_CONTENTS_TYPE.SUBSTORY_ALBUM then
		SceneManager:nextScene("substory_album", arg_3_1)
	end
end

function GlobalSubstoryManager.isNotiAblum(arg_4_0)
	if not arg_4_0.vars then
		return false
	end
	
	if not arg_4_0.vars.info then
		return false
	end
	
	for iter_4_0, iter_4_1 in pairs(arg_4_0.vars.info) do
		local var_4_0 = arg_4_0:isActiveSchedule(iter_4_0, SUBSTORY_CONSTANTS.ONE_WEEK)
		local var_4_1 = arg_4_0:isContentsType(iter_4_1, GLOBAL_SUBSTORY_CONTENTS_TYPE.SUBSTORY_ALBUM)
		
		if var_4_0 and var_4_1 and SubstoryAlbum:canReceiveMissionReward(iter_4_0) then
			return true
		end
	end
	
	return false
end

function GlobalSubstoryManager.setInfo(arg_5_0, arg_5_1)
	if not arg_5_0.vars then
		arg_5_0.vars = {}
	end
	
	if not arg_5_0.vars.info then
		arg_5_0.vars.info = {}
	end
	
	local var_5_0 = SubStoryUtil:getSubstoryDB(arg_5_1)
	
	if var_5_0 and var_5_0.id then
		var_5_0.id = tostring(var_5_0.id)
		arg_5_0.vars.info[var_5_0.id] = var_5_0
	end
end

function GlobalSubstoryManager.getInfo(arg_6_0)
	if not arg_6_0.vars then
		return 
	end
	
	return arg_6_0.vars.info
end

function GlobalSubstoryManager.isContentsType(arg_7_0, arg_7_1, arg_7_2)
	if arg_7_1.contents_type == arg_7_2 then
		return true
	end
	
	if arg_7_1.contents_type_2 == arg_7_2 then
		return true
	end
	
	return false
end

function GlobalSubstoryManager.getInfoByID(arg_8_0, arg_8_1)
	return (arg_8_0:getInfo() or {})[arg_8_1]
end

function GlobalSubstoryManager.updateSubstory(arg_9_0)
	local var_9_0 = Account:getSubStoryScheduleDB()
	local var_9_1 = Account:getGlobalSubstory()
	local var_9_2 = {}
	
	for iter_9_0, iter_9_1 in pairs(var_9_0) do
		if iter_9_1.event_type == "global" and iter_9_1.is_main then
			table.insert(var_9_2, iter_9_1)
		end
	end
	
	table.sort(var_9_2, function(arg_10_0, arg_10_1)
		return (arg_10_0.sort or 0) < (arg_10_1.sort or 0)
	end)
	
	for iter_9_2, iter_9_3 in pairs(var_9_2) do
		arg_9_0:setInfo(iter_9_3.id)
	end
end

function GlobalSubstoryManager.isActiveSchedule(arg_11_0, arg_11_1, arg_11_2)
	if SubstoryManager:getActiveSchedules(arg_11_2)[arg_11_1] then
		return true
	end
	
	return false
end
