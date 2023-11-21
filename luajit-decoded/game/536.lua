UnitZodiacMix = {}

function HANDLER.unit_zodiac_mix(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		UnitZodiacMix:close()
		
		return 
	end
	
	if string.starts(arg_1_1, "btn_item") then
		UnitZodiacMix:select(to_n(string.sub(arg_1_1, -1, -1)))
	end
	
	if string.starts(arg_1_1, "btn_go") then
		UnitZodiacMix:reqMix()
	end
	
	if arg_1_1 == "btn_min" or arg_1_1 == "btn_max" or arg_1_1 == "btn_plus" or arg_1_1 == "btn_minus" then
		UnitZodiacMix:onSliderButton(arg_1_1)
	end
end

function MsgHandler.mix_item(arg_2_0)
	UnitZodiacMix:onMixItem(arg_2_0)
end

local function var_0_0(arg_3_0, arg_3_1)
	UnitZodiacMix:onChangeSlider(arg_3_0:getPercent())
end

function UnitZodiacMix.onSliderButton(arg_4_0, arg_4_1)
	if arg_4_0.vars.max_count < 1 then
		return 
	end
	
	local var_4_0 = 0
	
	if arg_4_1 == "btn_minus" then
		var_4_0 = math.max(arg_4_0.vars.cur_count - 1, 1)
	end
	
	if arg_4_1 == "btn_min" then
		var_4_0 = 1
	end
	
	if arg_4_1 == "btn_max" then
		var_4_0 = arg_4_0.vars.max_count
	end
	
	if arg_4_1 == "btn_plus" then
		var_4_0 = math.min(arg_4_0.vars.cur_count + 1, arg_4_0.vars.max_count)
	end
	
	arg_4_0.vars.slider:setPercent(var_4_0)
end

function UnitZodiacMix.onChangeSlider(arg_5_0, arg_5_1)
	arg_5_0:updateCount(arg_5_1)
end

function UnitZodiacMix.close(arg_6_0)
	if not arg_6_0.vars then
		return 
	end
	
	if not arg_6_0.vars.wnd then
		return 
	end
	
	if not get_cocos_refid(arg_6_0.vars.wnd) then
		return 
	end
	
	BackButtonManager:pop("unit_zodiac_mix")
	arg_6_0.vars.wnd:removeFromParent()
end

function UnitZodiacMix.open(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0.vars = {}
	
	if not arg_7_1 then
		return 
	end
	
	local var_7_0 = load_dlg("unit_zodiac_mix", true, "wnd", function()
		UnitZodiacMix:close()
	end)
	
	arg_7_0.vars.wnd = var_7_0
	arg_7_0.vars.key = arg_7_2
	
	arg_7_1:addChild(var_7_0)
	
	arg_7_0.vars.slider = var_7_0:getChildByName("slider")
	
	arg_7_0.vars.slider:addEventListener(var_0_0)
	if_set_visible(var_7_0, "n_detail", false)
	arg_7_0:init(arg_7_2)
	SoundEngine:play("event:/ui/popup/tap")
end

function UnitZodiacMix.init(arg_9_0, arg_9_1)
	local var_9_0
	
	arg_9_0.vars.db = {}
	arg_9_0.vars.res = {}
	
	for iter_9_0 = 1, 2 do
		local var_9_1 = SLOW_DB_ALL("item_mix", arg_9_1 .. "_" .. iter_9_0)
		
		if not var_9_1.id then
			break
		end
		
		table.push(arg_9_0.vars.db, var_9_1)
		
		var_9_0 = var_9_0 or var_9_1.res1
		
		local var_9_2 = Account:getItemCount(var_9_1.result)
		local var_9_3 = UIUtil:getRewardIcon(nil, var_9_1.result, {
			show_count = false,
			tooltip_delay = 300,
			parent = arg_9_0.vars.wnd:getChildByName("n_item" .. iter_9_0)
		})
		
		if_set(arg_9_0.vars.wnd, "t_have" .. iter_9_0, T("item_count", {
			num = var_9_2
		}))
		
		arg_9_0.vars.res[iter_9_0] = var_9_1.result
	end
	
	arg_9_0.vars.res[0] = var_9_0
	
	UIUtil:getRewardIcon(nil, var_9_0, {
		show_count = false,
		tooltip_delay = 300,
		parent = arg_9_0.vars.wnd:getChildByName("n_item0")
	})
	if_set(arg_9_0.vars.wnd, "t_have0", T("item_count", {
		num = Account:getItemCount(var_9_0)
	}))
end

function UnitZodiacMix.select(arg_10_0, arg_10_1)
	if arg_10_0.vars.index == arg_10_1 then
		return 
	end
	
	if arg_10_1 < 1 or not arg_10_0.vars.db[arg_10_1] then
		balloon_message_with_sound("cant_mix")
		
		return 
	end
	
	arg_10_0.vars.index = arg_10_1
	
	arg_10_0:updateInfo()
end

function UnitZodiacMix.updateInfo(arg_11_0)
	arg_11_0.vars.wnd:getChildByName("cursor"):setPosition(arg_11_0.vars.wnd:getChildByName("n_item" .. arg_11_0.vars.index):getPosition())
	if_set_visible(arg_11_0.vars.wnd, "n_detail_yet", false)
	if_set_visible(arg_11_0.vars.wnd, "n_detail", true)
	
	local var_11_0 = arg_11_0.vars.db[arg_11_0.vars.index]
	
	UIUtil:getRewardIcon(nil, var_11_0.res1, {
		tooltip_delay = 300,
		parent = arg_11_0.vars.wnd:getChildByName("n_from")
	})
	UIUtil:getRewardIcon(nil, var_11_0.result, {
		tooltip_delay = 300,
		parent = arg_11_0.vars.wnd:getChildByName("n_to")
	})
	if_set(arg_11_0.vars.wnd, "count_from", T("item_count", {
		num = var_11_0.res_count1
	}))
	if_set(arg_11_0.vars.wnd, "count_to", T("item_count", {
		num = var_11_0.count
	}))
	if_set(arg_11_0.vars.wnd, "t_name1", T(DB("item_material", var_11_0.res1, "name")))
	if_set(arg_11_0.vars.wnd, "t_name2", T(DB("item_material", var_11_0.result, "name")))
	
	local var_11_1 = Account:getItemCount(var_11_0.res1)
	local var_11_2 = var_11_0.res_count1
	
	arg_11_0.vars.max_count = math.floor(var_11_1 / var_11_2)
	
	local var_11_3 = arg_11_0.vars.wnd:getChildByName("btn_go")
	
	if arg_11_0.vars.max_count > 0 and Account:getCurrency("gold") > var_11_0.res_count0 then
		var_11_3:setOpacity(255)
		var_11_3:setTouchEnabled(true)
	else
		var_11_3:setOpacity(76.5)
		var_11_3:setTouchEnabled(false)
	end
	
	arg_11_0.vars.slider:setEnabled(arg_11_0.vars.max_count ~= 0)
	arg_11_0.vars.slider:setMaxPercent(arg_11_0.vars.max_count)
	
	local var_11_4 = math.min(1, arg_11_0.vars.max_count)
	
	arg_11_0.vars.slider:setPercent(var_11_4)
	arg_11_0:updateUICount(var_11_4)
end

function UnitZodiacMix.updateCount(arg_12_0, arg_12_1)
	if arg_12_1 == 0 and arg_12_0.vars.max_count > 0 then
		arg_12_1 = 1
	end
	
	arg_12_0.vars.cur_count = arg_12_1
	
	arg_12_0:updateUICount(arg_12_0.vars.cur_count)
end

function UnitZodiacMix.updateUICount(arg_13_0, arg_13_1)
	if_set_visible(arg_13_0.vars.wnd, "t_lack", arg_13_1 == 0)
	if_set_visible(arg_13_0.vars.wnd, "t_mix_count", arg_13_1 ~= 0)
	
	if arg_13_1 ~= 0 then
		if_set(arg_13_0.vars.wnd, "t_mix_count", tostring(arg_13_0.vars.cur_count) .. "/" .. arg_13_0.vars.max_count)
	end
	
	if_set(arg_13_0.vars.wnd, "cost", comma_value(arg_13_0.vars.db[arg_13_0.vars.index].res_count0 * arg_13_1))
end

function UnitZodiacMix.reqMix(arg_14_0)
	print(arg_14_0.vars.db.id)
	query("mix_item", {
		mix_id = arg_14_0.vars.db[arg_14_0.vars.index].id,
		count = arg_14_0.vars.cur_count
	})
end

function UnitZodiacMix.onMixItem(arg_15_0, arg_15_1)
	balloon_message_with_sound("mix_success")
	Account:updateProperties(arg_15_1.properties)
	Account:updateProperties(arg_15_1.rewards)
	TopBarNew:topbarUpdate()
	arg_15_0:updateInfo()
	
	for iter_15_0 = 0, 2 do
		if_set(arg_15_0.vars.wnd, "t_have" .. iter_15_0, T("item_count", {
			num = Account:getItemCount(arg_15_0.vars.res[iter_15_0])
		}))
	end
	
	UnitZodiac:updateInterfaces()
	UnitZodiac:updateSidePanelWithoutInfo()
end
