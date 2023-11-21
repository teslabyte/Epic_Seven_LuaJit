WorldBossBattleEsc = WorldBossBattleEsc or {}

function HANDLER.clan_worldboss_battle_esc(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_option" then
		UIOption:show({
			category = "game",
			close_callback = function()
			end,
			layer = SceneManager:getRunningPopupScene(true)
		})
		
		return 
	end
	
	if arg_1_1 == "btn_close" or arg_1_1 == "btn_return" then
		WorldBossBattleEsc:close()
		
		return 
	end
end

function WorldBossBattleEsc.open(arg_3_0)
	arg_3_0.wnd = load_dlg("clan_worldboss_battle_esc", true, "wnd", function()
		arg_3_0:close()
	end)
	
	local var_3_0 = SceneManager:getRunningNativeScene()
	
	if not var_3_0 then
		UIAction:Add(REMOVE(), arg_3_0.wnd, "worldboss")
		
		return 
	end
	
	var_3_0:addChild(arg_3_0.wnd)
	arg_3_0.wnd:bringToFront()
	WorldBoss:pause()
	pause()
end

function WorldBossBattleEsc.close(arg_5_0)
	if not get_cocos_refid(arg_5_0.wnd) then
		return 
	end
	
	UIAction:Add(SEQ(LOG(FADE_OUT(200)), REMOVE()), arg_5_0.wnd, "block")
	BackButtonManager:pop("clan_worldboss_battle_esc")
	
	arg_5_0.wnd = nil
	
	WorldBoss:resume()
	resume()
end

function WorldBossBattleEsc.isOpen(arg_6_0)
	if not get_cocos_refid(arg_6_0.wnd) then
		return 
	end
	
	return true
end
