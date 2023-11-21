function Lobby.setupNightBar(arg_1_0, arg_1_1)
	local var_1_0 = {
		{
			"lobby_night_bg",
			"_night"
		},
		{
			"lobby_night_bar",
			"_night"
		},
		{
			"lobby_night_back_table",
			"_night"
		},
		{
			"lobby_night_lamp_node",
			"_night",
			"spani"
		},
		{
			"lobby_night_main_chairs",
			"_night"
		},
		{
			"lobby_night_main_table",
			"_night"
		},
		{
			"lobby_night_front_table",
			"_night"
		},
		{
			"lobby_night_chan_pos",
			"_night",
			"spani"
		},
		{
			"lobby_night_intro_probs",
			"_night"
		},
		{
			"lobby_night_dust_node",
			"_night",
			"spani"
		}
	}
	
	arg_1_0.vars.ambient = cc.c3b(225, 180, 150)
	arg_1_0.vars.fade_color = cc.c3b(0, 0, 0)
	arg_1_0.vars.night = true
	
	arg_1_0:setupBasicObjects(arg_1_1, var_1_0)
	arg_1_0:attach("lobby_bg", "out_can", CACHE:getEffect("lobby_candle_strong.cfx", "effect"), 0.18)
	arg_1_0:attach("lobby_bg", "left_can", CACHE:getEffect("lobby_candle_strong.cfx", "effect"), 0.27)
	arg_1_0:attach("lobby_bg", "wall_can", CACHE:getEffect("lobby_candle_strong.cfx", "effect"), 0.27)
	arg_1_0:attach("lobby_bar", "lantern_pos", CACHE:getEffect("lobby_night_lantern", "effect"))
	arg_1_0:attach("lobby_bar", "mugs_pos", CACHE:getEffect("lobby_night_mugs", "effect"))
	arg_1_0:attach("lobby_bar", "bar_can1", CACHE:getEffect("lobby_candle_weak.cfx", "effect"), 0.31)
	arg_1_0:attach("lobby_bar", "bar_can2", CACHE:getEffect("lobby_candle_weak.cfx", "effect"), 0.31)
	arg_1_0:attach("lobby_bar", "bar_can3", CACHE:getEffect("lobby_candle_weak.cfx", "effect"), 0.31)
	arg_1_0:attach("lobby_back_table", "back_table_can", CACHE:getEffect("lobby_candle_strong.cfx", "effect"), 0.54)
	arg_1_0:attach("lobby_lamp_node", "lamp1", CACHE:getEffect("lobby_night_lamp_light_pil", "effect"), 1.35)
	arg_1_0:attach("lobby_lamp_node", "lamp2", CACHE:getEffect("lobby_night_lamp_light_pil", "effect"), 1.26)
	arg_1_0:attach("lobby_lamp_node", "lamp3", CACHE:getEffect("lobby_night_lamp_light_door", "effect"), 1.35)
	arg_1_0:attach("lobby_lamp_node", "right_can", CACHE:getEffect("lobby_candle_strong", "effect"), 0.3)
	arg_1_0:attach("lobby_main_table", "main_table_can1", CACHE:getEffect("lobby_candle_weak.cfx", "effect"), 0.81)
	arg_1_0:attach("lobby_main_table", "main_table_can2", CACHE:getEffect("lobby_candle_weak.cfx", "effect"), 0.72)
	arg_1_0:attach("lobby_main_table", "main_table_can3", CACHE:getEffect("lobby_candle_weak.cfx", "effect"), 0.81)
	arg_1_0:attach("lobby_front_table", "front_table_can", CACHE:getEffect("lobby_candle_strong.cfx", "effect"), 1.44)
	
	arg_1_0.childs.lobby_chan = CACHE:getEffect("lobby_night_chan.scsp", "effect")
	
	arg_1_0:attach("lobby_chan", "chan_can5", CACHE:getEffect("lobby_candle_weak.cfx", "effect"), 0.63)
	arg_1_0:attach("lobby_chan", "chan_can6", CACHE:getEffect("lobby_candle_weak.cfx", "effect"), 0.63)
	arg_1_0:attach("lobby_chan", "chan_can7", CACHE:getEffect("lobby_candle_weak.cfx", "effect"), 0.63)
	arg_1_0:attach("lobby_chan_pos", "chan_pos", arg_1_0.childs.lobby_chan)
	arg_1_0:attach("lobby_chan", "chan_can1", CACHE:getEffect("lobby_candle_weak.cfx", "effect"), 0.9)
	arg_1_0:attach("lobby_chan", "chan_can2", CACHE:getEffect("lobby_candle_weak.cfx", "effect"), 0.9)
	arg_1_0:attach("lobby_chan", "chan_can3", CACHE:getEffect("lobby_candle_weak.cfx", "effect"), 0.9)
	arg_1_0:attach("lobby_chan", "chan_can4", CACHE:getEffect("lobby_candle_weak.cfx", "effect"), 0.9)
	arg_1_0:attach("lobby_dust_node", "bg_zoom", CACHE:getEffect("lobby_day_dust_pati1.particle", "effect"))
	arg_1_0:attach("lobby_dust_node", "bg_zoom", CACHE:getEffect("lobby_day_dust_pati3.particle", "effect"))
end

function Lobby.setupDayBar(arg_2_0, arg_2_1)
	local var_2_0 = DESIGN_WIDTH / 2
	local var_2_1 = DESIGN_HEIGHT / 2
	local var_2_2 = {
		{
			"lobby_day_bg",
			"_day"
		},
		{
			"lobby_day_bar",
			"_day"
		},
		{
			"lobby_day_back_table",
			"_day"
		},
		{
			"lobby_day_main_chairs",
			"_day"
		},
		{
			"lobby_day_main_table",
			"_day"
		},
		{
			"lobby_day_front_table",
			"_day"
		},
		{
			"lobby_day_lights",
			"_day",
			"spani"
		},
		{
			"lobby_day_chan_pos",
			"_day",
			"spani"
		},
		{
			"lobby_day_intro_probs",
			"_day"
		},
		{
			"lobby_day_dust_node",
			"_day",
			"spani"
		}
	}
	
	arg_2_0.vars.ambient = cc.c3b(255, 225, 200)
	arg_2_0.vars.fade_color = cc.c3b(255, 255, 255)
	
	arg_2_0:setupBasicObjects(arg_2_1, var_2_2)
	arg_2_0:attach("lobby_bg", "bg_zoom", CACHE:getEffect("lobby_day_exit_shine.scsp", "effect"))
	arg_2_0:attach("lobby_bg", "exit_pati_pos", CACHE:getEffect("lobby_day_exit_pati1.particle", "effect"))
	arg_2_0:attach("lobby_bar", "lantern_pos", CACHE:getEffect("lobby_day_lantern.scsp", "effect"))
	arg_2_0:attach("lobby_bar", "mugs_pos", CACHE:getEffect("lobby_day_mugs.scsp", "effect"))
	arg_2_0:attach("lobby_lights", "ceiling_pos", CACHE:getEffect("lobby_day_ceiling_shine", "effect"))
	arg_2_0:attach("lobby_lights", "ceiling_pos", CACHE:getEffect("lobby_day_dust_pati2.particle", "effect"))
	arg_2_0:attach("lobby_lights", "door_pos", CACHE:getEffect("lobby_day_door_shine", "effect"))
	arg_2_0:attach("lobby_lights", "door_pos", CACHE:getEffect("lobby_day_dust_pati2.particle", "effect"))
	arg_2_0:attach("lobby_dust_node", "bg_zoom", CACHE:getEffect("lobby_day_dust_pati1.particle", "effect"))
	arg_2_0:attach("lobby_dust_node", "bg_zoom", CACHE:getEffect("lobby_day_dust_pati3.particle", "effect"))
	
	arg_2_0.childs.lobby_chan = CACHE:getEffect("lobby_day_chan.scsp", "effect")
	
	arg_2_0:attach("lobby_chan_pos", "chan_pos", arg_2_0.childs.lobby_chan)
end

function Lobby.christmasBar(arg_3_0, arg_3_1)
	local var_3_0 = {
		{
			"lobby_christmas_bg",
			"_christmas"
		},
		{
			"lobby_christmas_bar",
			"_christmas"
		},
		{
			"lobby_christmas_back_table",
			"_christmas"
		},
		{
			"lobby_night_lamp_node",
			"_night",
			"spani"
		},
		{
			"lobby_christmas_tree_pos",
			"_christmas",
			"spani"
		},
		{
			"lobby_christmas_bar_prob_pos",
			"_christmas",
			"spani"
		},
		{
			"lobby_christmas_main_chairs",
			"_christmas"
		},
		{
			"lobby_christmas_main_table",
			"_christmas"
		},
		{
			"lobby_christmas_front_table",
			"_christmas"
		},
		{
			"lobby_night_chan_pos",
			"_night",
			"spani"
		},
		{
			"lobby_christmas_intro_probs",
			"_christmas"
		},
		{
			"lobby_night_dust_node",
			"_night",
			"spani"
		}
	}
	
	arg_3_0.vars.ambient = cc.c3b(225, 180, 150)
	arg_3_0.vars.fade_color = cc.c3b(0, 0, 0)
	arg_3_0.vars.night = true
	
	arg_3_0:setupBasicObjects(arg_3_1, var_3_0)
	arg_3_0:attach("lobby_bg", "out_can", CACHE:getEffect("lobby_candle_strong.cfx", "effect"), 0.18)
	arg_3_0:attach("lobby_bg", "left_can", CACHE:getEffect("lobby_candle_strong.cfx", "effect"), 0.27)
	arg_3_0:attach("lobby_bg", "wall_can", CACHE:getEffect("lobby_candle_strong.cfx", "effect"), 0.27)
	arg_3_0:attach("lobby_bar", "lantern_pos", CACHE:getEffect("lobby_christmas_lantern", "effect"))
	arg_3_0:attach("lobby_bar", "mugs_pos", CACHE:getEffect("lobby_christmas_mugs", "effect"))
	arg_3_0:attach("lobby_bar", "bar_can1", CACHE:getEffect("lobby_candle_weak.cfx", "effect"), 0.31)
	arg_3_0:attach("lobby_bar", "bar_can2", CACHE:getEffect("lobby_candle_weak.cfx", "effect"), 0.31)
	arg_3_0:attach("lobby_bar", "bar_can3", CACHE:getEffect("lobby_candle_weak.cfx", "effect"), 0.31)
	
	local var_3_1 = CACHE:getEffect("lobby_christmas_tree", "effect")
	
	if get_cocos_refid(var_3_1) then
		var_3_1:setAnimation(0, "loop", true)
		arg_3_0:attach("lobby_tree_pos", "pos", var_3_1)
	end
	
	local var_3_2 = CACHE:getEffect("lobby_christmas_bar_prob", "effect")
	
	if get_cocos_refid(var_3_2) then
		var_3_2:setAnimation(0, "loop", true)
		arg_3_0:attach("lobby_bar_prob_pos", "bar_prob_pos", var_3_2)
	end
	
	arg_3_0:attach("lobby_back_table", "back_table_can", CACHE:getEffect("lobby_candle_strong.cfx", "effect"), 0.54)
	arg_3_0:attach("lobby_lamp_node", "lamp1", CACHE:getEffect("lobby_night_lamp_light_pil", "effect"), 1.35)
	arg_3_0:attach("lobby_lamp_node", "lamp2", CACHE:getEffect("lobby_night_lamp_light_pil", "effect"), 1.26)
	arg_3_0:attach("lobby_lamp_node", "lamp3", CACHE:getEffect("lobby_night_lamp_light_door", "effect"), 1.35)
	arg_3_0:attach("lobby_lamp_node", "right_can", CACHE:getEffect("lobby_candle_strong", "effect"), 0.3)
	arg_3_0:attach("lobby_main_table", "main_table_can1", CACHE:getEffect("lobby_candle_weak.cfx", "effect"), 0.81)
	arg_3_0:attach("lobby_main_table", "main_table_can2", CACHE:getEffect("lobby_candle_weak.cfx", "effect"), 0.72)
	arg_3_0:attach("lobby_main_table", "main_table_can3", CACHE:getEffect("lobby_candle_weak.cfx", "effect"), 0.81)
	arg_3_0:attach("lobby_front_table", "front_table_can", CACHE:getEffect("lobby_candle_strong.cfx", "effect"), 1.44)
	
	arg_3_0.childs.lobby_chan = CACHE:getEffect("lobby_christmas_chan.scsp", "effect")
	
	arg_3_0:attach("lobby_chan", "chan_can5", CACHE:getEffect("lobby_candle_weak.cfx", "effect"), 0.63)
	arg_3_0:attach("lobby_chan", "chan_can6", CACHE:getEffect("lobby_candle_weak.cfx", "effect"), 0.63)
	arg_3_0:attach("lobby_chan", "chan_can7", CACHE:getEffect("lobby_candle_weak.cfx", "effect"), 0.63)
	arg_3_0:attach("lobby_chan_pos", "chan_pos", arg_3_0.childs.lobby_chan)
	arg_3_0:attach("lobby_chan", "chan_can1", CACHE:getEffect("lobby_candle_weak.cfx", "effect"), 0.9)
	arg_3_0:attach("lobby_chan", "chan_can2", CACHE:getEffect("lobby_candle_weak.cfx", "effect"), 0.9)
	arg_3_0:attach("lobby_chan", "chan_can3", CACHE:getEffect("lobby_candle_weak.cfx", "effect"), 0.9)
	arg_3_0:attach("lobby_chan", "chan_can4", CACHE:getEffect("lobby_candle_weak.cfx", "effect"), 0.9)
	arg_3_0:attach("lobby_dust_node", "bg_zoom", CACHE:getEffect("lobby_day_dust_pati1.particle", "effect"))
	arg_3_0:attach("lobby_dust_node", "bg_zoom", CACHE:getEffect("lobby_day_dust_pati3.particle", "effect"))
end
