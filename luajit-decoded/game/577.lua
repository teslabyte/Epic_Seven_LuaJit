Announcement = Announcement or {}

function HANDLER.announcement(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close_announcement" then
		local var_1_0 = Dialog:msgBox(T("chat_notice_skip"), {
			yesno = true,
			handler = function()
				local var_2_0 = Announcement:getWnd()
				
				if var_2_0 or get_cocos_refid(var_2_0) then
					var_2_0:removeFromParent()
					
					local var_2_1
				end
				
				Scheduler:remove(Announcement:getScheduler())
				Announcement:setScheduler(nil)
				SAVE:set("game.announcement_last_id", Announcement:getLastId())
			end,
			cancel_handler = function()
			end,
			yes_text = T("ui_msgbox_ok"),
			parent = SceneManager:getAlertLayer()
		})
		
		var_1_0:setPositionY(HEIGHT_MARGIN / 2 + var_1_0:getPositionY())
	end
end

if not PRODUCTION_MODE then
	function open_rolling()
		local var_4_0 = {
			tm = 999999999,
			info = {
				{
					msg = "이건 테스트입니다. 야호.",
					end_time = 9999999999,
					start_time = os.time() - 1
				}
			}
		}
		
		Announcement:setData(var_4_0)
	end
end

function Announcement.setData(arg_5_0, arg_5_1)
	if IS_TOOL_MODE then
		return 
	end
	
	if to_n(arg_5_0.rn_tm) >= to_n(arg_5_1.tm) then
		return 
	end
	
	local var_5_0 = arg_5_1.info
	
	if not var_5_0 or type(var_5_0) ~= "table" or var_5_0[1] == nil then
		if arg_5_0.scheduler then
			arg_5_0:clear()
		end
		
		return 
	end
	
	local var_5_1 = var_5_0[#var_5_0]
	
	if SAVE:get("game.announcement_last_id", -1) == var_5_1.notice_id then
		return 
	end
	
	arg_5_0.rn_tm = arg_5_1.tm
	arg_5_0.vars = arg_5_0.vars or {}
	arg_5_0.vars.last_id = var_5_1.notice_id
	
	local var_5_2 = json.encode(var_5_0)
	
	if arg_5_0.vars.source == var_5_2 then
		return 
	end
	
	arg_5_0.vars.source = var_5_2
	arg_5_0.vars.start_time = os.time()
	arg_5_0.vars.all_texts = {}
	
	for iter_5_0, iter_5_1 in pairs(var_5_0) do
		iter_5_1.period = iter_5_1.period or 5
		
		local var_5_3 = iter_5_1.platform == ""
		
		var_5_3 = var_5_3 or string.find(iter_5_1.platform, PLATFORM) ~= nil
		
		if var_5_3 then
			local var_5_4 = json.decode(iter_5_1.msg or "")
			
			if var_5_4 and var_5_4[getUserLanguage()] ~= nil and string.trim(var_5_4[getUserLanguage()]) ~= "" then
				table.push(arg_5_0.vars.all_texts, iter_5_1)
			end
		end
	end
	
	if not arg_5_0.scheduler then
		arg_5_0.scheduler = Scheduler:addGlobalInterval(1000, arg_5_0.onUpdate, arg_5_0)
	end
	
	arg_5_0:onUpdate()
end

function Announcement.bringToFront(arg_6_0)
	local var_6_0 = SceneManager:getAlertLayer():findChildByName("announcement")
	
	if get_cocos_refid(var_6_0) then
		var_6_0:bringToFront()
	end
end

function Announcement.updateLeftTime(arg_7_0)
	if not get_cocos_refid(arg_7_0.wnd) then
		return 
	end
	
	if not arg_7_0.vars.use_timer then
		return 
	end
	
	if not arg_7_0.vars.end_time then
		for iter_7_0, iter_7_1 in pairs(arg_7_0.vars.cur_texts or {}) do
			arg_7_0.vars.end_time = iter_7_1.end_time
			
			break
		end
	end
	
	local var_7_0 = arg_7_0.vars.end_time
	local var_7_1 = os.time()
	
	if tonumber(var_7_0) - var_7_1 < 0 then
		if_set(arg_7_0.wnd, "text_time", "00:00:00")
		
		return 
	end
	
	local var_7_2 = tonumber(var_7_0) - var_7_1
	local var_7_3 = math.floor(var_7_2 / 60 / 60)
	local var_7_4 = math.floor(var_7_2 / 60) % 60
	local var_7_5 = var_7_2 % 60
	
	var_7_3 = var_7_3 < 10 and "0" .. var_7_3 or var_7_3
	var_7_4 = var_7_4 < 10 and "0" .. var_7_4 or var_7_4
	var_7_5 = var_7_5 < 10 and "0" .. var_7_5 or var_7_5
	
	if_set(arg_7_0.wnd, "text_time", var_7_3 .. ":" .. var_7_4 .. ":" .. var_7_5)
	
	local var_7_6 = arg_7_0.wnd:getChildByName("n_notice_time"):getChildByName("text_time")
end

function Announcement.onUpdate(arg_8_0)
	if IS_TOOL_MODE then
		arg_8_0.vars = nil
	end
	
	if SceneManager:getCurrentSceneName() == "title" then
		return 
	end
	
	if not SceneManager:getRunningScene() then
		return 
	end
	
	if not arg_8_0.vars then
		if arg_8_0.wnd then
			if get_cocos_refid(arg_8_0.wnd) then
				arg_8_0.wnd:removeFromParent()
			end
			
			arg_8_0.wnd = nil
		end
		
		Scheduler:remove(arg_8_0.scheduler)
		
		arg_8_0.scheduler = nil
		
		return 
	end
	
	local var_8_0 = os.time()
	
	arg_8_0.vars.total_time = 0
	arg_8_0.vars.cur_texts = {}
	
	for iter_8_0, iter_8_1 in pairs(arg_8_0.vars.all_texts) do
		if not iter_8_1.start_time or var_8_0 >= iter_8_1.start_time and var_8_0 <= iter_8_1.end_time then
			table.push(arg_8_0.vars.cur_texts, iter_8_1)
			
			arg_8_0.vars.total_time = arg_8_0.vars.total_time + iter_8_1.period
		end
	end
	
	if #arg_8_0.vars.cur_texts == 0 then
		arg_8_0:clear()
		
		return 
	end
	
	if not arg_8_0.wnd or not get_cocos_refid(arg_8_0.wnd) then
		arg_8_0.vars.cur_msg = ""
		arg_8_0.wnd = load_control("wnd/announcement.csb")
		
		arg_8_0.wnd:setPositionY(arg_8_0.wnd:getPositionY() + HEIGHT_MARGIN / 2)
		SceneManager:updateTouchEventTime()
		SceneManager:getAlertLayer():addChild(arg_8_0.wnd)
		arg_8_0:bringToFront()
	end
	
	local var_8_1 = (var_8_0 - arg_8_0.vars.start_time) % arg_8_0.vars.total_time
	
	local function var_8_2(arg_9_0)
		arg_8_0.vars.use_timer = true
		
		if not get_cocos_refid(arg_8_0.wnd) then
			return 
		end
		
		local var_9_0 = arg_8_0.wnd:getChildByName("n_notice_time")
		
		if not get_cocos_refid(var_9_0) then
			return 
		end
		
		local var_9_1 = var_9_0:getChildByName("n_time")
		
		if not get_cocos_refid(var_9_1) then
			return 
		end
		
		local var_9_2 = arg_8_0.wnd:getChildByName("btn_close_announcement")
		
		if not get_cocos_refid(var_9_2) then
			return 
		end
		
		local var_9_3 = var_9_1:getChildByName("text_remaining")
		
		if not get_cocos_refid(var_9_3) then
			return 
		end
		
		if_set(var_9_0, "text", arg_9_0)
		var_9_2:setContentSize({
			width = 371,
			height = var_9_0:getChildByName("text"):getLineHeight() * 24
		})
		if_set(var_9_0, "text_remaining", T("ui_announcement_remain_time"))
		
		arg_8_0.vars.origin_text_remaining_x = arg_8_0.vars.origin_text_remaining_x or var_9_3:getPositionX()
		
		local var_9_4 = arg_8_0.vars.origin_text_remaining_x + 15
		
		var_9_3:setPositionX(var_9_4)
		var_9_1:getChildByName("text_time"):setPositionX(var_9_4 + var_9_3:getContentSize().width * 0.35)
		if_set_visible(var_9_0, nil, true)
		if_set_visible(arg_8_0.wnd, "n_notice", false)
	end
	
	local function var_8_3(arg_10_0)
		if arg_8_0.vars.cur_msg == arg_10_0.msg then
			return 
		end
		
		local var_10_0 = json.decode(arg_10_0.msg or "")
		local var_10_1 = var_10_0 and var_10_0[getUserLanguage()] or ""
		local var_10_2 = string.gsub(var_10_1, "\\n", "\n")
		
		if arg_10_0.use_timer and tonumber(arg_10_0.use_timer) == 1 then
			var_8_2(var_10_2)
		else
			if_set(arg_8_0.wnd:getChildByName("n_notice"), "text", var_10_2)
		end
		
		arg_8_0.vars.cur_msg = arg_10_0.msg
	end
	
	for iter_8_2, iter_8_3 in pairs(arg_8_0.vars.cur_texts or {}) do
		if var_8_1 < iter_8_3.period then
			var_8_3(iter_8_3)
			
			break
		end
		
		var_8_1 = var_8_1 - iter_8_3.period
	end
	
	arg_8_0:updateLeftTime()
	arg_8_0.wnd:setVisible(arg_8_0.vars.cur_msg and arg_8_0.vars.cur_msg ~= "")
end

function Announcement.getNoticeList(arg_11_0)
	local var_11_0 = {}
	
	if arg_11_0.vars and arg_11_0.vars.cur_texts then
		for iter_11_0, iter_11_1 in pairs(arg_11_0.vars.cur_texts) do
			local var_11_1 = UIUtil:translateServerText(iter_11_1.msg)
			
			table.insert(var_11_0, var_11_1)
		end
	end
	
	return var_11_0
end

function Announcement.clear(arg_12_0)
	arg_12_0.vars = nil
end

function Announcement.getWnd(arg_13_0)
	return arg_13_0.wnd
end

function Announcement.getLastId(arg_14_0)
	return arg_14_0.vars.last_id
end

function Announcement.getScheduler(arg_15_0)
	return arg_15_0.scheduler
end

function Announcement.setScheduler(arg_16_0, arg_16_1)
	arg_16_0.scheduler = arg_16_1
end
