Sequencer = {}

function test()
	local var_1_0 = Sequencer:init()
	
	var_1_0:add(BattleUI.showNextCursor, BattleUI, var_1_0:getLayer())
	var_1_0:addClearAsync("stage_clear")
	var_1_0:add(Battle.showResultDialog, Battle)
	var_1_0:add(print, 2)
	var_1_0:add(print, 3)
	var_1_0:play()
end

function HANDLER.event_bg(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_next" then
		getParentWindow(arg_2_0).seq:next(true)
	end
end

function Sequencer.init(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = {
		vars = {}
	}
	
	copy_functions(Sequencer, var_3_0)
	
	var_3_0.vars.auto_next = arg_3_2
	var_3_0.vars.queue = {}
	var_3_0.vars.base = load_dlg("event_bg", true, "wnd")
	
	var_3_0.vars.base:setPositionX(DESIGN_WIDTH / 2)
	
	var_3_0.vars.base.seq = var_3_0
	var_3_0.vars.layer = cc.Layer:create()
	
	var_3_0.vars.layer:setContentSize({
		width = VIEW_WIDTH,
		height = VIEW_HEIGHT
	})
	var_3_0.vars.layer:setAnchorPoint({
		x = 0.5,
		y = 0.5
	})
	var_3_0.vars.layer:setPosition({
		x = 0,
		y = 0
	})
	var_3_0.vars.layer:setCascadeOpacityEnabled(true)
	var_3_0.vars.base:addChild(var_3_0.vars.layer)
	
	return var_3_0
end

function Sequencer.add(arg_4_0, arg_4_1, ...)
	if not arg_4_0.vars then
		arg_4_0:init()
	end
	
	table.push(arg_4_0.vars.queue, {
		func = arg_4_1,
		args = {
			...
		}
	})
end

function Sequencer.addAsync(arg_5_0, arg_5_1, ...)
	if not arg_5_0.vars then
		arg_5_0:init()
	end
	
	table.push(arg_5_0.vars.queue, {
		async = true,
		func = arg_5_1,
		args = {
			...
		}
	})
end

function Sequencer.addRaw(arg_6_0, arg_6_1, ...)
	if not arg_6_0.vars then
		arg_6_0:init()
	end
	
	table.push(arg_6_0.vars.queue, {
		raw = true,
		func = arg_6_1,
		args = {
			...
		}
	})
end

function Sequencer.getLayer(arg_7_0)
	return arg_7_0.vars.layer
end

function Sequencer.play(arg_8_0, arg_8_1, arg_8_2)
	BackButtonManager:push({
		check_id = "Sequencer",
		back_func = function()
			arg_8_0:next(nil, true)
		end,
		dlg = arg_8_0.vars.base
	})
	
	if not arg_8_0.vars then
		arg_8_0:init()
	end
	
	arg_8_2 = arg_8_2 or {}
	arg_8_0.vars.opts = arg_8_2
	arg_8_1 = arg_8_1 or SceneManager:getRunningNativeScene()
	
	arg_8_1:addChild(arg_8_0.vars.base)
	
	if not arg_8_0.vars.opts.bg then
		arg_8_0.vars.base:getChildByName("btn_next"):setOpacity(0)
	end
	
	if arg_8_0.vars.opts.fade_in then
		arg_8_0.vars.base:setOpacity(0)
		UIAction:Add(FADE_IN(500), arg_8_0.vars.base, "block")
	end
	
	Scheduler:add(arg_8_0.vars.base, Sequencer.onUpdate, arg_8_0)
	arg_8_0:next(nil, true)
end

function Sequencer.addClearAsync(arg_10_0, arg_10_1)
	arg_10_0:addAsync(arg_10_0.clearLayer, arg_10_0, arg_10_1)
end

function Sequencer.clearLayer(arg_11_0, arg_11_1)
	if arg_11_1 then
		arg_11_0.vars.layer:getChildByName(arg_11_1):removeFromParent()
	else
		arg_11_0.vars.layer:removeAllChildren()
	end
end

function Sequencer.deinit(arg_12_0)
	Scheduler:remove(Sequencer.onUpdate)
	
	if get_cocos_refid(arg_12_0.vars.base) then
		arg_12_0.vars.base:removeFromParent()
	end
	
	arg_12_0.vars = nil
end

function Sequencer.next(arg_13_0, arg_13_1, arg_13_2)
	if UIAction:Find("block") and not arg_13_2 then
		return 
	end
	
	if not arg_13_0.vars then
		Log.e("ERROR IN SEQ NEXT")
		
		return 
	end
	
	if #arg_13_0.vars.queue < 1 then
		arg_13_0:deinit()
		Scheduler:remove(Sequencer.onUpdate)
		
		return 
	end
	
	if arg_13_0.vars.raw and arg_13_1 and not arg_13_2 then
		return 
	end
	
	local var_13_0 = arg_13_0.vars.queue[1]
	
	table.remove(arg_13_0.vars.queue, 1)
	
	if #arg_13_0.vars.queue < 1 then
		BackButtonManager:pop({
			check_id = "Sequencer",
			dlg = arg_13_0.vars.base
		})
	end
	
	var_13_0.func(argument_unpack(var_13_0.args))
	
	if arg_13_0.vars then
		arg_13_0.vars.raw = var_13_0.raw
		arg_13_0.vars.async = var_13_0.async
	end
end

function Sequencer.setAutoNext(arg_14_0, arg_14_1)
	if not arg_14_0.vars then
		return 
	end
	
	arg_14_0.vars.auto_next = arg_14_1
end

function Sequencer.isEmpty(arg_15_0)
	return not arg_15_0.vars or #arg_15_0.vars.queue < 1
end

function Sequencer.onUpdate(arg_16_0)
	if UIAction:Find("block") then
		return 
	end
	
	if not arg_16_0.vars or #arg_16_0.vars.queue < 1 then
		return 
	end
	
	if arg_16_0.vars.auto_next then
		if not arg_16_0.vars.auto_next_tm then
			arg_16_0.vars.auto_next_tm = uitick() + 2000
			
			return 
		end
		
		if arg_16_0.vars.auto_next_tm < uitick() then
			arg_16_0:next()
			
			arg_16_0.vars.auto_next_tm = nil
			
			return 
		end
	end
	
	if arg_16_0.vars.async then
		arg_16_0:next()
	end
end
