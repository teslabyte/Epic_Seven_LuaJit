SPLMainUI = {}

function HANDLER.dungeon_heritage_main(arg_1_0, arg_1_1)
	if UIAction:Find("spl.block") then
		return 
	end
	
	if arg_1_1 == "btn_current_location" then
		SPLMainUI:onBtnCurrentLocation()
	end
end

function SPLMainUI.onBtnCurrentLocation(arg_2_0)
	if not arg_2_0:isVisibleLocationButton() then
		return 
	end
	
	SPLCameraSystem:setCameraPlayerPos()
end

function SPLMainUI.init(arg_3_0, arg_3_1)
	if not get_cocos_refid(arg_3_1) then
		return 
	end
	
	arg_3_0.vars = {}
	arg_3_0.vars.layer = arg_3_1
	arg_3_0.vars.main_ui = load_dlg("dungeon_heritage_main", true, "wnd")
	
	if not get_cocos_refid(arg_3_0.vars.main_ui) then
		return 
	end
	
	arg_3_0:addChild(arg_3_0.vars.main_ui)
	
	local var_3_0 = arg_3_0.vars.main_ui:getChildByName("n_goal")
	
	SPLMissionUI:initUI(var_3_0)
	
	arg_3_0.vars.is_visible_location_button = false
	
	if_set_visible(arg_3_0.vars.main_ui, "btn_current_location", arg_3_0.vars.is_visible_location_button)
	
	local function var_3_1()
		if SPLEventSystem:isPlayingEvent() then
			return 
		end
		
		BackButtonManager:pop()
		SceneManager:popScene()
	end
	
	local var_3_2 = {
		"crystal",
		"gold"
	}
	local var_3_3 = DB("tile_sub", SPLSystem:getCurrentMapId(), "name")
	
	TopBarNew:createFromPopup(T(var_3_3), arg_3_0.vars.main_ui, var_3_1, var_3_2, "infosubs")
end

function SPLMainUI.fadeIn(arg_5_0)
	if not arg_5_0.vars or not get_cocos_refid(arg_5_0.vars.main_ui) then
		return 
	end
	
	arg_5_0.vars.main_ui:setScale(1.05)
	arg_5_0.vars.main_ui:setOpacity(0)
	UIAction:Add(SEQ(SHOW(true), LOG(SPAWN(FADE_IN(800), SCALE(1000, 1.05, 1)))), arg_5_0.vars.main_ui, "block")
end

function SPLMainUI.fadeOut(arg_6_0)
	if not arg_6_0.vars or not get_cocos_refid(arg_6_0.vars.main_ui) then
		return 
	end
	
	arg_6_0.vars.main_ui:setScale(1)
	arg_6_0.vars.main_ui:setOpacity(255)
	UIAction:Add(SEQ(LOG(SPAWN(FADE_OUT(800), SCALE(1000, 1, 1.05))), SHOW(false)), arg_6_0.vars.main_ui, "block")
end

function SPLMainUI.getLayer(arg_7_0)
	if not arg_7_0.vars then
		return 
	end
	
	return arg_7_0.vars.layer
end

function SPLMainUI.addChild(arg_8_0, arg_8_1)
	if not arg_8_0.vars or not get_cocos_refid(arg_8_0.vars.layer) then
		return 
	end
	
	arg_8_0.vars.layer:addChild(arg_8_1)
end

function SPLMainUI.isVisibleLocationButton(arg_9_0)
	if not SPLMovableSystem:isPlayerOutScreen() then
		return false
	end
	
	if SPLEventSystem:getState() ~= SPLEventState.IDLE then
		return false
	end
	
	if SPLMovableSystem:isPlayerRunning() then
		return false
	end
	
	return true
end

function SPLMainUI.updateLocationButton(arg_10_0)
	if not arg_10_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_10_0.vars.main_ui) then
		return 
	end
	
	local var_10_0 = arg_10_0.vars.main_ui:getChildByName("btn_current_location")
	
	if not get_cocos_refid(var_10_0) then
		return 
	end
	
	local var_10_1 = arg_10_0:isVisibleLocationButton()
	
	if arg_10_0.vars.is_visible_location_button == var_10_1 then
		return 
	end
	
	arg_10_0.vars.is_visible_location_button = var_10_1
	
	if UIAction:Find("update_location_button") then
		UIAction:Remove("update_location_button")
	end
	
	local var_10_2 = arg_10_0.vars.is_visible_location_button and FADE_IN or FADE_OUT
	
	UIAction:Add(var_10_2(100), var_10_0, "update_location_button")
end
