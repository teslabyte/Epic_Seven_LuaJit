maintenanceHandler = {}

function isMaintenanceError(arg_1_0)
	for iter_1_0, iter_1_1 in pairs(maintenanceHandler) do
		if iter_1_0 == arg_1_0 then
			return true
		end
	end
	
	return false
end

function handleMaintenance(arg_2_0, arg_2_1)
	if maintenanceHandler[arg_2_0] then
		if TransitionScreen:isShow() then
			TransitionScreen:hide()
		end
		
		maintenanceHandler[arg_2_0](arg_2_1)
	end
end

function msgBoxMaintenance(arg_3_0, arg_3_1, arg_3_2)
	Dialog:msgBox(tostring(arg_3_0), {
		title = arg_3_1,
		warning = arg_3_2,
		tab_text = T("tab_to_retry"),
		handler = function()
			restart_contents()
		end
	})
end

function maintenanceHandler.server_closed(arg_5_0)
	msgBoxMaintenance(T("server_run_over"), T("ui_mail_list_event"))
end

function maintenanceHandler.maintenance(arg_6_0)
	table.print(arg_6_0)
	
	local var_6_0 = arg_6_0["maintenance_title." .. getUserLanguage()] or T("maintenance_title") or ""
	local var_6_1 = arg_6_0["maintenance_msg." .. getUserLanguage()] or T("maintenance_desc") or ""
	local var_6_2 = string.gsub(var_6_1, "\\n", "\n")
	local var_6_3 = ""
	local var_6_4 = arg_6_0.maintenance_start or ""
	
	if var_6_4 and var_6_4 ~= "" then
		var_6_3 = T("time_slash_m_d_time", timeToStringDef({
			preceding_with_zeros = true,
			time = var_6_4
		}))
	end
	
	local var_6_5 = T("maintenance_time") .. ": " .. var_6_3 .. " - "
	local var_6_6 = arg_6_0.maintenance_end or ""
	
	if var_6_6 and var_6_6 ~= "" then
		var_6_5 = var_6_5 .. T("time_slash_m_d_time", timeToStringDef({
			preceding_with_zeros = true,
			time = var_6_6
		}))
	end
	
	msgBoxMaintenance(var_6_2, var_6_0, var_6_5)
end

function maintenanceHandler.invalid_app_version(arg_7_0)
	table.print(arg_7_0)
	Dialog:msgBox(T("touch_to_app_market"), {
		title = T("need_app_upgrade"),
		handler = function()
			if getStoreUrl then
				openURL(getStoreUrl())
			else
				openURL(getenv("store.url"))
			end
			
			restart_contents()
		end
	})
end

function maintenanceHandler.invalid_patch_version(arg_9_0)
	Dialog:msgBox(T("patch_update_desc"), {
		title = T("patch_update_title"),
		handler = function()
			restart_contents()
		end
	})
end

function maintenanceHandler.invalid_version_info(arg_11_0)
	table.print(arg_11_0)
	Dialog:msgBox(tostring(arg_11_0.msg), {
		title = T("invalid_version_info", "Invalid verinfo"),
		handler = function()
			restart_contents()
		end
	})
end

function maintenanceHandler.session_error(arg_13_0)
	VARS.GAME_STARTED = false
	
	Dialog:msgBox(T("session_error_desc"), {
		handler = function()
			restart_contents()
		end
	})
end

function maintenanceHandler.access_denied(arg_15_0)
	VARS.GAME_STARTED = false
	
	Dialog:msgBox(T("session_error_desc"), {
		txt_code = T("code") .. " : " .. "err_ad",
		handler = function()
			remove_all_local_push()
			Stove:setRegion("")
			restart_contents()
		end
	})
end

function maintenanceHandler.banned_user(arg_17_0)
	local var_17_0 = arg_17_0 and arg_17_0.ban_tm
	
	var_17_0 = var_17_0 and os.date("%m/%d/%Y %H:%M", var_17_0)
	
	local var_17_1 = ""
	local var_17_2 = ""
	
	if IS_PUBLISHER_ZLONG then
		local var_17_3 = arg_17_0 and arg_17_0.ban_reason
		
		var_17_1 = string.format("%s\n%s: %s", T("zlong_banned_user_desc", {
			banReson = var_17_3
		}), T("game_log_subtask_v6"), tostring(var_17_0 or "-"))
		var_17_2 = T("stove_banned_user_title")
	else
		local var_17_4 = arg_17_0 and arg_17_0.account_no
		
		var_17_1 = string.format("%s\n\n%s: %s\n%s: %s", T("stove_banned_user_desc"), T("account_number"), tostring(var_17_4), T("game_log_subtask_v6"), tostring(var_17_0 or "-"))
		var_17_2 = T("stove_banned_user_title")
	end
	
	Dialog:msgBox(var_17_1, {
		title = var_17_2,
		handler = function()
			restart_contents()
		end
	})
end

function maintenanceHandler.invalid_time(arg_19_0)
	msgBoxMaintenance(T("invalid_time_desc"), T("invalid_time_title"))
end
