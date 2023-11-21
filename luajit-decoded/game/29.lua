cc.Director:getInstance():setMaxDeltaTime(0.1)
cc.Director:getInstance():setMaxDeltaTime(0.1)

HANDLER = HANDLER or {}
HANDLER_BEFORE = {}
HANDLER_CANCEL = {}
REPORT_COUNT = 0
REPORT_TIME = 0
REPORT_PACKET = nil
REPORT_HASH = {}

local var_0_0

LAST_TICK = 0
CocosSchedulerManager = CocosSchedulerManager or {}

function CocosSchedulerManager.addScheduler(arg_1_0, arg_1_1, arg_1_2)
	if not arg_1_0.scheduler_list then
		arg_1_0:init()
	end
	
	if not arg_1_0.scheduler_list[arg_1_2] or not get_cocos_refid(arg_1_0.scheduler_list[arg_1_2]) then
		arg_1_0.scheduler_list[arg_1_2] = arg_1_1
		arg_1_0.ticktime_list[arg_1_2] = arg_1_0.ticktime_list[arg_1_2] or 0
		arg_1_0.cur_process_delta_list[arg_1_2] = arg_1_0.cur_process_delta_list[arg_1_2] or 0
	else
		print("ALREDY EXIST SCHEUDLER!!!!", arg_1_2)
	end
	
	return arg_1_0.scheduler_list[arg_1_2]
end

function CocosSchedulerManager.init(arg_2_0)
	arg_2_0.poll_scheduler = nil
	arg_2_0.poll_scheduler_name = nil
	arg_2_0.poll_process_delta = 0
	arg_2_0.scheduler_list = {}
	arg_2_0.ticktime_list = {}
	arg_2_0.cur_process_delta_list = {}
	arg_2_0.main_scheduler = cc.Director:getInstance():getScheduler()
end

function CocosSchedulerManager.removeCustomSchForPoll(arg_3_0)
	if get_cocos_refid(arg_3_0.poll_scheduler) then
		arg_3_0.poll_scheduler:release()
	end
	
	arg_3_0.poll_scheduler = nil
	arg_3_0.poll_scheduler_name = nil
end

function CocosSchedulerManager.useCustomSchForPoll(arg_4_0, arg_4_1)
	arg_4_0.poll_scheduler = arg_4_0.scheduler_list[arg_4_1]
	arg_4_0.poll_process_delta = 0
	arg_4_0.poll_scheduler_name = arg_4_1
	arg_4_0.ticktime_list[arg_4_0.poll_scheduler_name] = arg_4_0.ticktime_list[arg_4_0.poll_scheduler_name] or 0
	arg_4_0.cur_process_delta_list[arg_4_0.poll_scheduler_name] = arg_4_0.cur_process_delta_list[arg_4_0.poll_scheduler_name] or 0
end

function CocosSchedulerManager.isUseCustomSchForPoll(arg_5_0)
	return arg_5_0.poll_scheduler ~= nil and get_cocos_refid(arg_5_0.poll_scheduler) and SceneManager:getCurrentSceneName() == "gacha_unit" and GachaUnit:isActive()
end

function CocosSchedulerManager.getCurrentSchForPoll(arg_6_0)
	if arg_6_0:isUseCustomSchForPoll() then
		return arg_6_0.poll_scheduler
	end
end

function CocosSchedulerManager.updateForPoll(arg_7_0, arg_7_1)
	if not arg_7_0:isUseCustomSchForPoll() then
		return 
	end
	
	arg_7_0.poll_process_delta = arg_7_0.poll_process_delta + arg_7_1 * arg_7_0.poll_scheduler:getTimeScale()
	
	while arg_7_0.poll_process_delta > TICK_TIME do
		arg_7_0.poll_process_delta = arg_7_0.poll_process_delta - TICK_TIME
		
		BattleAction:Poll()
	end
end

function CocosSchedulerManager.updateIter(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	if not get_cocos_refid(arg_8_2) then
		return 
	end
	
	if not arg_8_0.cur_process_delta_list[arg_8_1] then
		arg_8_0.cur_process_delta_list[arg_8_1] = 0
	end
	
	if not arg_8_0.ticktime_list[arg_8_1] then
		arg_8_0.ticktime_list[arg_8_1] = 0
	end
	
	if PAUSED then
		arg_8_0.cur_process_delta_list[arg_8_1] = 0
	else
		local var_8_0 = arg_8_0.ticktime_list[arg_8_1] + arg_8_3 * arg_8_2:getTimeScale() * 1000
		
		arg_8_0.ticktime_list[arg_8_1] = var_8_0
		arg_8_0.cur_process_delta_list[arg_8_1] = arg_8_3 * arg_8_2:getTimeScale()
	end
end

function CocosSchedulerManager.updateScheduler(arg_9_0, arg_9_1)
	if not arg_9_0.scheduler_list then
		return 
	end
	
	local var_9_0 = {}
	
	for iter_9_0, iter_9_1 in pairs(arg_9_0.scheduler_list) do
		if get_cocos_refid(iter_9_1) and arg_9_0:isUseCustomSchForPoll() then
			iter_9_1:update(arg_9_1)
		else
			table.insert(var_9_0, iter_9_0)
		end
	end
	
	for iter_9_2, iter_9_3 in pairs(var_9_0) do
		arg_9_0.scheduler_list[iter_9_3] = nil
	end
end

function CocosSchedulerManager.update(arg_10_0, arg_10_1)
	if not arg_10_0.scheduler_list then
		return 
	end
	
	if not arg_10_0.cur_process_delta_list then
		arg_10_0.cur_process_delta_list = {}
	end
	
	if not arg_10_0.ticktime_list then
		arg_10_0.ticktime_list = {}
	end
	
	for iter_10_0, iter_10_1 in pairs(arg_10_0.scheduler_list) do
		arg_10_0:updateIter(iter_10_0, iter_10_1, arg_10_1)
	end
end

function CocosSchedulerManager.getCurProcessDelta(arg_11_0, arg_11_1)
	if not arg_11_0.scheduler_list then
		return 
	end
	
	if not arg_11_0.scheduler_list[arg_11_1] then
		return 
	end
	
	if not arg_11_0.cur_process_delta_list then
		arg_11_0.cur_process_delta_list = {}
	end
	
	if not arg_11_0.cur_process_delta_list[arg_11_1] then
		arg_11_0.cur_process_delta_list[arg_11_1] = 0
	end
	
	return arg_11_0.cur_process_delta_list[arg_11_1]
end

function CocosSchedulerManager.getTickTime(arg_12_0, arg_12_1)
	if not arg_12_0.scheduler_list then
		return nil
	end
	
	if not arg_12_0.scheduler_list[arg_12_1] then
		return nil
	end
	
	if not arg_12_0.ticktime_list then
		arg_12_0.ticktime_list = {}
	end
	
	if not arg_12_0.ticktime_list[arg_12_1] then
		arg_12_0.ticktime_list[arg_12_1] = 0
	end
	
	return arg_12_0.ticktime_list[arg_12_1]
end

function CocosSchedulerManager.get(arg_13_0, arg_13_1)
	if not arg_13_0.scheduler_list[arg_13_1] then
		return nil
	end
	
	return arg_13_0.scheduler_list[arg_13_1]
end

function GET_LAST_TICK()
	if CocosSchedulerManager:isUseCustomSchForPoll() then
		return CocosSchedulerManager:getTickTime(CocosSchedulerManager.poll_scheduler_name)
	end
	
	return LAST_TICK
end

LAST_UI_TICK = 0
CUR_PROCESS_DELTA = 0

function GET_CUR_PROCESS_DELTA()
	if CocosSchedulerManager:isUseCustomSchForPoll() then
		return CocosSchedulerManager:getCurProcessDelta(CocosSchedulerManager.poll_scheduler_name)
	end
	
	return CUR_PROCESS_DELTA
end

LOGIC_FPS = 60
TICK_TIME = 1 / LOGIC_FPS
STORY_ACTION_TICK = 0
TOOLS_FPS = 60
SCENE_FPS = DEFAULT_DISPLAY_FPS
HIGH_FPS_TICK = 0

if not MINIMUM_FPS then
	MINIMUM_FPS = 0
	ADAPTIVE_FPS_FLAG = true
end

if not PRODUCTION_MODE and DebugScenes then
	for iter_0_0, iter_0_1 in pairs(DebugScenes) do
		print("Load Cheat Scene : ", iter_0_0)
		iter_0_1()
	end
end

SERVER_TIME_DELTA = 0
origin_os_time = origin_os_time or os.time

function new_os_time(arg_16_0)
	if arg_16_0 ~= nil then
		return origin_os_time(arg_16_0)
	end
	
	if SERVER_TIME_DELTA ~= 0 then
		return origin_os_time(arg_16_0) + SERVER_TIME_DELTA
	else
		return origin_os_time(arg_16_0)
	end
end

os.time = new_os_time
origin_os_date = origin_os_date or os.date

function new_os_date(arg_17_0, arg_17_1)
	if arg_17_0 then
		if arg_17_1 then
			return origin_os_date(arg_17_0, arg_17_1)
		else
			return origin_os_date(arg_17_0, os.time())
		end
	else
		return origin_os_date("%x %X", os.time())
	end
end

os.date = new_os_date

function set_scene_fps(arg_18_0, arg_18_1)
	SCENE_FPS = arg_18_0
	DEFAULT_DISPLAY_FPS = arg_18_1 or 45
	
	if CURRENT_DISPLAY_FPS < SCENE_FPS then
		set_fps(SCENE_FPS)
	end
end

function set_high_fps_tick(arg_19_0)
	arg_19_0 = arg_19_0 or 2000
	
	if HIGH_FPS_TICK >= LAST_UI_TICK + arg_19_0 then
		return 
	end
	
	HIGH_FPS_TICK = LAST_UI_TICK + arg_19_0
	
	set_fps(math.max(DEFAULT_DISPLAY_FPS, MINIMUM_FPS))
end

function set_fps(arg_20_0)
	if CURRENT_DISPLAY_FPS ~= arg_20_0 then
		CURRENT_DISPLAY_FPS = arg_20_0
		
		local var_20_0 = cc.Director:getInstance():isNextDeltaTimeZero()
		
		cc.Director:getInstance():setAnimationInterval(1 / CURRENT_DISPLAY_FPS)
		cc.Director:getInstance():setNextDeltaTimeZero(var_20_0)
	end
end

function adjust_fps()
	if IS_TOOL_MODE then
		set_fps(TOOLS_FPS)
		
		return 
	end
	
	if not ADAPTIVE_FPS_FLAG then
		return 
	end
	
	local var_21_0 = ccui.ScrollView:getLastScrollTime()
	
	if math.max(var_21_0 + 2000, HIGH_FPS_TICK) > LAST_UI_TICK then
		set_fps(math.max(DEFAULT_DISPLAY_FPS, MINIMUM_FPS))
	else
		set_fps(SCENE_FPS)
	end
end

local var_0_1 = 0
local var_0_2

G_INITED_PRERES = false
G_NO_SPACE_ERROR = false

function _init_presource()
	if not G_INITED_PRERES then
		G_INITED_PRERES = true
		
		preload_db()
	end
end

function _check_startup_scene()
	print("DEBUG _check_startup_scene")
	
	if not PRODUCTION_MODE and reg_debug_feature then
		reg_debug_feature()
	end
	
	_init_presource()
	reg_keyboard_feature()
	ShaderManager:loadShader()
	CocosSchedulerManager:init()
	SceneManager:initWithScene(getenv("init.scene", "title"))
	
	var_0_2 = nil
end

G_REQUST_STOVE_AUTH = false

function _check_startup_login()
	print("DEBUG _check_startup_login")
	_init_presource()
	
	if not G_REQUST_STOVE_AUTH then
		G_REQUST_STOVE_AUTH = true
		
		Login.FSM:changeState(LoginState.INITIALIZE)
		
		return 
	end
	
	var_0_2 = _check_startup_scene
end

function _systemAfterUpdate()
	Login.FSM:update()
	
	if Stove.enable then
		StoveIap.FSM:update()
	elseif Zlong.enable then
		ZlongIap.FSM:update()
		ZlongIap.AcquireWorker:update()
	end
	
	if var_0_2 then
		var_0_2()
		
		return 
	end
	
	SceneManager:doAfterUpdate()
	TutorialGuide:update()
	
	if not G_NO_SPACE_ERROR and getenv("file.write.error") == "no_space_left_on_device" then
		G_NO_SPACE_ERROR = true
		
		Dialog:msgBox(T("not_enough_storage"), {
			handler = terminated_process
		})
	end
end

function _systemLoop()
	if DEBUG.LAST_LUA_ERROR then
		DEBUG_INFO.last_error = DEBUG_INFO.last_error or {}
		
		table.insert(DEBUG_INFO.last_error, DEBUG.LAST_LUA_ERROR)
		
		DEBUG.LAST_LUA_ERROR = false
	end
	
	if not PROCESS_DELTA_temp then
		PROCESS_DELTA_temp = LAST_TICK
	end
	
	if LAST_TICK - PROCESS_DELTA_temp >= 1000 then
		PROCESS_DELTA_temp = LAST_TICK
	end
	
	LAST_UI_TICK = systick()
	
	local var_26_0 = cc.Director:getInstance():getDeltaTime()
	
	if DEBUG.TEST_LACK and math.random() < 0.1 then
		sleep(math.random(var_26_0 * 10, 600))
	end
	
	local var_26_1 = 0
	
	if PAUSED then
		CUR_PROCESS_DELTA = 0
		
		CocosSchedulerManager:update(0)
	else
		CUR_PROCESS_DELTA = var_26_0
		
		if not CocosSchedulerManager:isUseCustomSchForPoll() then
			var_0_1 = var_0_1 + var_26_0
			
			while var_0_1 > TICK_TIME do
				var_0_1 = var_0_1 - TICK_TIME
				
				BattleAction:Poll()
				
				if STORY_ACTION_MANAGER:isNotPausedStoryAction() then
					StoryAction:Poll()
				end
			end
		else
			CocosSchedulerManager:updateForPoll(var_26_0)
		end
		
		CocosSchedulerManager:update(var_26_0)
		
		LAST_TICK = LAST_TICK + var_26_0 * 1000
		
		if STORY_ACTION_MANAGER:isNotPausedStoryAction() then
			STORY_ACTION_TICK = STORY_ACTION_TICK + var_26_0 * 1000
			
			StoryAction:Poll()
		end
		
		BattleAction:Poll()
	end
	
	Action:Poll()
	BattleUIAction:Poll()
	UIAction:Poll()
	SysAction:Poll()
	Scheduler:Poll()
	SceneManager:doAfterDraw()
	ThreadManager:process()
	Scheduler:Poll("afterdraw")
	ChatMain:Poll()
	SAVE:Poll()
	Analytics:loadLocalLogDatas_once()
	EffectManager:checkLoopSoundNode()
	adjust_fps()
end

if G_SYSTEM_EVENT_NATIVE_LISTENERS then
	for iter_0_2, iter_0_3 in pairs(G_SYSTEM_EVENT_NATIVE_LISTENERS) do
		cc.Director:getInstance():getEventDispatcher():removeEventListener(iter_0_3)
	end
end

G_SYSTEM_EVENT_NATIVE_LISTENERS = {}
G_SYSTEM_EVENT_LISTENERS = {}

function G_SYSTEM_EVENT_LISTENERS.application_did_finish_launching()
end

function G_SYSTEM_EVENT_LISTENERS.application_resources_ready()
	print("DEBUG application_resources_ready")
	
	if load_db_crypt_file then
		load_db_crypt_file("pass/public.pass")
	end
	
	local var_28_0 = getenv("cdn.url") .. "/webpubs/res"
	
	cc.FileUtils:getInstance():setPropertyString("res.url", var_28_0)
	cc.FileUtils:getInstance():setLocaleCode(get_user_language())
	
	local var_28_1 = getenv("app.pubid")
	
	if var_28_1 then
		cc.FileUtils:getInstance():setPublisherId(var_28_1)
		
		local var_28_2 = Zlong:isUseGlobalResource()
		local var_28_3
		local var_28_4
		local var_28_5
		
		if var_28_2 then
			var_28_3 = "{loc}/{name}{ext}|{name}{ext}|{loc}/{name}_{pubid}{ext}"
			var_28_5 = "{m.qlt}/{name}{ext}|{m.qlt}/{loc}/{name}_{pubid}{ext}"
		else
			var_28_3 = "{loc}/{name}_{pubid}{ext}|{loc}/{name}{ext}"
			var_28_5 = "{m.qlt}/{loc}/{name}_{pubid}{ext}|{m.qlt}/{name}{ext}"
		end
		
		cc.FileUtils:getInstance():addLocaleFilter("banner", var_28_3)
		cc.FileUtils:getInstance():addLocaleFilter("effect", var_28_3)
		cc.FileUtils:getInstance():addLocaleFilter("img", var_28_3)
		cc.FileUtils:getInstance():addLocaleFilter("font", var_28_3)
		cc.FileUtils:getInstance():addLocaleFilter("tutorial", var_28_3)
		cc.FileUtils:getInstance():addLocaleFilter("text", var_28_3)
		cc.FileUtils:getInstance():addLocaleFilter("buff", var_28_3)
		cc.FileUtils:getInstance():addLocaleFilter("credits", var_28_3)
		cc.FileUtils:getInstance():addLocaleFilter("db", var_28_3)
		cc.FileUtils:getInstance():addLocaleFilter("emblem", var_28_3)
		cc.FileUtils:getInstance():addLocaleFilter("face", var_28_3)
		cc.FileUtils:getInstance():addLocaleFilter("item", var_28_3)
		cc.FileUtils:getInstance():addLocaleFilter("item_arti", var_28_3)
		cc.FileUtils:getInstance():addLocaleFilter("skill", var_28_3)
		cc.FileUtils:getInstance():addLocaleFilter("model", var_28_3)
		cc.FileUtils:getInstance():addLocaleFilter("portrait", var_28_3)
		cc.FileUtils:getInstance():addLocaleFilter("shop", var_28_3)
		cc.FileUtils:getInstance():addLocaleFilter("story/bg", var_28_3)
		cc.FileUtils:getInstance():addLocaleFilter("stagept", var_28_3)
		cc.FileUtils:getInstance():addLocaleFilter("cut", var_28_5)
		cc.FileUtils:getInstance():addLocaleFilter("sound", "{m.loc}/{name}_{pubid}{ext}|{m.loc}/{name}_{m.loc}{ext}")
		cc.FileUtils:getInstance():addLocaleFilter("cinema", "{m.loc}/{m.qlt}/{name}_{pubid}{ext}|{res.url}/cinema/{m.loc}/{m.qlt}/{name}_{pubid}{ext}")
	else
		cc.FileUtils:getInstance():addLocaleFilter("banner", "{loc}/{name}{ext}")
		cc.FileUtils:getInstance():addLocaleFilter("effect", "{loc}/{name}{ext}")
		cc.FileUtils:getInstance():addLocaleFilter("img", "{loc}/{name}{ext}")
		cc.FileUtils:getInstance():addLocaleFilter("font", "{loc}/{name}{ext}")
		cc.FileUtils:getInstance():addLocaleFilter("tutorial", "{loc}/{name}{ext}")
		cc.FileUtils:getInstance():addLocaleFilter("text", "{loc}/{name}{ext}")
		cc.FileUtils:getInstance():addLocaleFilter("cut", "{m.qlt}/{name}{ext}")
		cc.FileUtils:getInstance():addLocaleFilter("sound", "{m.loc}/{name}_{m.loc}{ext}")
		cc.FileUtils:getInstance():addLocaleFilter("cinema", "{m.loc}/{m.qlt}/{name}{ext}|{res.url}/cinema/{m.loc}/{m.qlt}/{name}{ext}")
	end
	
	cc.FileUtils:getInstance():addLocaleFilter("emoticon_chat", "{loc}/{name}{ext}")
	cc.FileUtils:getInstance():addLocaleFilter("prologue", "{name}_{loc}{ext}")
	cc.FileUtils:getInstance():addLocaleFilter("bgm_ost", "{name}{ext}|{res.url}/sound/bgm_ost/{name}{ext}")
	cc.FileUtils:getInstance():addLocaleFilter("ep_bgm", "{name}{ext}|{res.url}/title/ep_bgm/{name}{ext}")
	cc.FileUtils:getInstance():addLocaleFilter("ep_cinema", "{name}{ext}|{res.url}/title/ep_cinema/{name}{ext}")
	
	if getenv("init.scene", "title") == "title" and getenv("app.viewer") ~= "true" then
		var_0_2 = _check_startup_login
	else
		setenv("patch.status", "complete")
		
		var_0_2 = _check_startup_scene
	end
end

function G_SYSTEM_EVENT_LISTENERS.application_scripts_loaded()
	if getenv("mascot.hazel.use") == "true" then
		MHWindowRestore:restore()
	end
end

function G_SYSTEM_EVENT_LISTENERS.application_did_enter_background()
	cc.Director:getInstance():setNextDeltaTimeZero(true)
	SceneManager:applicationDidEnterBackground()
end

function G_SYSTEM_EVENT_LISTENERS.application_will_enter_foreground()
	cc.Director:getInstance():setNextDeltaTimeZero(true)
	ChatMain:onEnterForground()
	Stove:excuteStoveDeepLink()
	SceneManager:applicationWillEnterForeground()
end

function G_SYSTEM_EVENT_LISTENERS.application_will_resign_active()
	cc.Director:getInstance():setNextDeltaTimeZero(true)
	SceneManager:applicationDidEnterBackground()
end

function G_SYSTEM_EVENT_LISTENERS.application_did_become_active()
	cc.Director:getInstance():setNextDeltaTimeZero(true)
	SceneManager:applicationWillEnterForeground()
end

function G_SYSTEM_EVENT_LISTENERS.application_resource_error(arg_34_0)
	if SceneManager:getCurrentSceneName() == "effecttool" then
		balloon_message("File Not Found!   " .. getenv("last_application_resource_error", "<unknow>"))
	elseif not DEBUG.NO_ERROR then
		Log.e("File Not Found!", "File Not Found! " .. getenv("last_application_resource_error", "<unknow>"))
	end
end

function G_SYSTEM_EVENT_LISTENERS.director_complete_draw()
	SceneManager:doCompleteDraw()
end

function G_SYSTEM_EVENT_LISTENERS.director_before_draw()
	SceneManager:doBeforeDraw()
end

function G_SYSTEM_EVENT_LISTENERS.director_after_draw()
	_systemLoop()
	collectgarbage("step", 10)
end

function G_SYSTEM_EVENT_LISTENERS.director_before_update()
	if LotaFogRenderer and LotaFogRenderer:isActive() then
		LotaFogSystem:procRender()
		LotaFogRenderer:updateRender()
	end
	
	local var_38_0 = cc.Director:getInstance():getDeltaTime()
	
	CocosSchedulerManager:updateScheduler(var_38_0)
end

function G_SYSTEM_EVENT_LISTENERS.director_after_update()
	_systemAfterUpdate()
end

function G_SYSTEM_EVENT_LISTENERS.application_scene_reload()
	print("application_scene_reload")
	print("scene name : ", SceneManager:getCurrentSceneName())
	screen_reload_event()
end

for iter_0_4, iter_0_5 in pairs(G_SYSTEM_EVENT_LISTENERS) do
	G_SYSTEM_EVENT_NATIVE_LISTENERS[iter_0_4] = cc.EventListenerCustom:create(iter_0_4, G_SYSTEM_EVENT_LISTENERS[iter_0_4])
	
	cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(G_SYSTEM_EVENT_NATIVE_LISTENERS[iter_0_4], 1)
end

local function var_0_3(arg_41_0)
	local var_41_0 = cc.LayerColor:create(cc.c3b(70, 0, 0))
	
	var_41_0:setOpacity(150)
	
	local var_41_1 = ccui.Text:create()
	
	var_41_1:ignoreContentAdaptWithSize(true)
	var_41_1:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	var_41_1:setTextVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	var_41_1:setFontSize(24)
	var_41_1:setFontName("font/daum.ttf")
	var_41_1:enableOutline(cc.c3b(0, 0, 0), 1)
	var_41_1:setString(arg_41_0)
	var_41_1:setScale(0.8)
	var_41_1:setAnchorPoint(0, 1)
	var_41_1:setPosition(30, DESIGN_HEIGHT - 70)
	var_41_0:setLocalZOrder(99999)
	var_41_0:addChild(var_41_1)
	
	return var_41_0, var_41_1
end

function reset_msg(arg_42_0, arg_42_1, arg_42_2)
	if not arg_42_0 then
		return 
	end
	
	if arg_42_2 then
		arg_42_0:setString(arg_42_2 .. ":" .. arg_42_1)
	else
		arg_42_0:setString(arg_42_1)
	end
end

function __G__TRACKBACK__(arg_43_0)
	local var_43_0 = debug.traceback(arg_43_0, 2)
	local var_43_1 = var_43_0
	
	if Action.CUR_DEBUG then
		print("ERROR ACTION : " .. Action.CUR_DEBUG)
	end
	
	print("G_TRACKBACK : " .. var_43_0)
	
	local var_43_2 = string.format("%s - APP %s (%s) - #%s  /  RES #%s", os.date(), getenv("app.id", ""), PLATFORM, getAppVersionString(), getVersionDetailString())
	local var_43_3 = string.format("** QA용 정보입니다. 10초뒤 자동으로 사라지니 스샷을 캡쳐해 주세요. **\n\n%s\n", var_43_2) .. var_43_1
	
	if Action.CUR_DEBUG then
		var_43_3 = var_43_3 .. "\n\n---- ACTION ----\n" .. Action.CUR_DEBUG
	end
	
	local var_43_4 = true
	
	if PLATFORM == "win32" and load_file("script/TODO.md") then
		var_43_4 = nil
	end
	
	if PRODUCTION_MODE and REPORT_COUNT > 0 then
		return 
	end
	
	if log_analytics_lua_event then
		log_analytics_lua_event("traceback", var_43_1)
	end
	
	if REPORT_TIME + 300 > os.time() then
		var_43_4 = nil
	end
	
	if ContentDisable:byAlias("exception_report") then
		var_43_4 = nil
	end
	
	local var_43_5
	local var_43_6
	
	if not PRODUCTION_MODE and not IS_TOOL_MODE and not ContentDisable:byAlias("instant_debug") then
		var_43_5, var_43_6 = var_0_3(var_43_3)
		
		cc.Director:getInstance():getRunningScene():addChild(var_43_5)
		SysAction:Add(SEQ(DELAY(10000), REMOVE()), var_43_5)
	end
	
	REPORT_TIME = os.time()
	
	reset_msg(var_43_6, var_43_3, "STEP 1")
	
	REPORT_COUNT = REPORT_COUNT + 1
	
	local var_43_7 = {}
	local var_43_8 = {
		"app.id",
		"build.number"
	}
	
	var_43_7.date = os.date()
	
	for iter_43_0, iter_43_1 in pairs(var_43_8) do
		var_43_7[string.gsub(iter_43_1, "%.", "_")] = tostring(getenv(iter_43_1) or "empty")
	end
	
	reset_msg(var_43_6, var_43_3, "STEP 2")
	
	var_43_7.bininfo = tostring(getenv("luabin.info") or "")
	
	reset_msg(var_43_6, var_43_3, "STEP 3")
	
	local var_43_9 = {
		uid = AccountData and AccountData.id,
		name = AccountData and AccountData.name,
		region = Login.getRegion and Login:getRegion(),
		last_action = Action.CUR_DEBUG,
		info_line = var_43_2,
		tag_info = SceneManager:getCurrentSceneTagInfo(),
		report_count = REPORT_COUNT
	}
	
	reset_msg(var_43_6, var_43_3, "STEP 4")
	
	var_43_7.orign = getenv("orign_head") or ""
	var_43_7.infos = json.encode(var_43_9)
	var_43_7.stack = var_43_1
	
	if REPORT_PACKET then
		var_43_7.packet_cmd = REPORT_PACKET.cmd
		var_43_7.packet_size = string.len(REPORT_PACKET.packet)
		var_43_7.packet = string.tohex(REPORT_PACKET.packet)
	end
	
	var_43_7.report_count = REPORT_COUNT
	var_43_7.scene = SceneManager:getCurrentSceneName()
	var_43_7.scene_prev = SceneManager:getPrevSceneName()
	var_43_7.scene_next = SceneManager:getNextSceneName()
	var_43_7.platform = PLATFORM
	
	reset_msg(var_43_6, var_43_3, "STEP 5")
	
	if DEBUG_INFO.getLog_e then
		var_43_7.debug = DEBUG_INFO:getLog_e()
	end
	
	reset_msg(var_43_6, var_43_3, "STEP 6")
	
	if var_43_4 then
		print("START EXCEPTION REPORT..", string.split(var_43_0, "\n")[1])
		
		local var_43_10 = getenv("app.id")
		
		if var_43_10 == "stove_epic7live" or var_43_10 == "stove_epic7qa" then
			Net:direct_query("report", var_43_7, {
				uri = getenv("app.report", "http://epic7-reports.supercre.com:3333/api/")
			})
		elseif var_43_10 == "zlong_epic7live" then
			Net:direct_query("report", var_43_7, {
				uri = getenv("app.report", "http://dqss-luareport-514ce1993d49b38e.elb.cn-north-1.amazonaws.com.cn:3333/api/")
			})
		else
			Net:direct_query("report", var_43_7, {
				uri = getenv("app.report", "http://alpha.supercreative.kr:3335/api/")
			})
		end
		
		print("END EXCEPTION REPORT..")
	end
	
	reset_msg(var_43_6, var_43_3, "STEP 7")
	
	DEBUG_INFO.reports = DEBUG_INFO.reports or {}
	DEBUG_INFO.last_report = arg_43_0
	
	table.insert(DEBUG_INFO.reports, arg_43_0)
	reset_msg(var_43_6, var_43_3)
	
	if var_43_5 and var_43_5 and PRODUCTION_MODE then
		var_43_5:removeFromParent()
	end
	
	return var_43_1
end

function reg_keyboard_feature()
	cc.Director:getInstance():getEventDispatcher():removeEventListener(var_0_0)
	
	var_0_0 = cc.EventListenerKeyboard:create()
	
	var_0_0:registerScriptHandler(function(arg_45_0, arg_45_1)
		reg_feature_onKeyReleased(arg_45_0, arg_45_1)
	end, cc.Handler.EVENT_KEYBOARD_RELEASED)
	cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(var_0_0, 1)
end

function reg_feature_onKeyReleased(arg_46_0, arg_46_1)
	if arg_46_0 == cc.KeyCode.KEY_BACK then
		BackButtonManager:back()
		
		return 
	end
	
	if ChatMain:OnKeyUp(arg_46_0, arg_46_1) then
		return 
	end
	
	if story_key_release(arg_46_0, arg_46_1) then
		return 
	end
end
