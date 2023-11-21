LobbyEventIcon = LobbyEventIcon or {}

function LobbyEventIcon.isShowEventIcon(arg_1_0)
	local var_1_0 = AccountData.event_lobby_icon_schedule
	
	if table.empty(var_1_0) then
		return false, nil
	end
	
	if not var_1_0.start_time or not var_1_0.end_time or not var_1_0.id then
		return false, nil
	end
	
	local var_1_1 = os.time()
	
	if var_1_1 < var_1_0.start_time or var_1_1 >= var_1_0.end_time then
		return false, nil
	end
	
	local var_1_2 = DB("event_lobby_icon_set", var_1_0.id, "icon")
	
	if not var_1_2 then
		return false, nil
	end
	
	return true, var_1_2
end
