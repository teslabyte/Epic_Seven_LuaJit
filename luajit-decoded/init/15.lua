print("pre.lua Load")

ENABLE_LOGO_SKIP = getenv("app.disable_logo_skip") ~= "true"
LOGO_SKIP_HOUR = tonumber(getenv("app.logo_skip_hour") or 4)
PRODUCTION_MODE = getenv("app.production") ~= "false"

cc.Device:setKeepScreenOn(true)

MINIMUM_FPS = 0
ADAPTIVE_FPS_FLAG = true
LOW_RESOLUTION_MODE = false
DEFAULT_DISPLAY_FPS = 45
CURRENT_DISPLAY_FPS = DEFAULT_DISPLAY_FPS
FPS_BEFORE_PLAY = CURRENT_DISPLAY_FPS

cc.Director:getInstance():setAnimationInterval(1 / DEFAULT_DISPLAY_FPS)

PLATFORM = getenv("platform")
IS_ANDROID_BASED_PLATFORM = PLATFORM == "android" or PLATFORM == "mycard" or PLATFORM == "amazon" or PLATFORM == "huawei"
USER_LANG = get_user_language()
MEDIA_LANG = getenv("patch.local.lang")
IS_PUBLISHER_ZLONG = getenv("app.pubid") == "zl"
IS_PUBLISHER_STOVE = getenv("app.pubid") ~= "zl"
ZLONG_SDK_ENABLE = getenv("zlong.enable") == "true"

function application_change_resolution()
	print("application_change_resolution")
	
	DEVICE_WIDTH = tonumber(getenv("device.width", 1280))
	DEVICE_HEIGHT = tonumber(getenv("device.height", 720))
	DESIGN_WIDTH = tonumber(getenv("design.width", 1280))
	DESIGN_HEIGHT = tonumber(getenv("design.height", 720))
	DESIGN_CENTER_X = DESIGN_WIDTH / 2
	DESIGN_CENTER_Y = DESIGN_HEIGHT / 2
	MAX_VIEW_WIDTH = 1580
	MAX_VIEW_WITH_LETTERBOX_HEIGHT = 960
	VIEW_WIDTH = math.max(1280, math.min(math.floor(DEVICE_WIDTH * (720 / DEVICE_HEIGHT)), MAX_VIEW_WIDTH))
	VIEW_HEIGHT = 720
	
	if DESIGN_WIDTH / DESIGN_HEIGHT <= DEVICE_WIDTH / DEVICE_HEIGHT then
		SCREEN_WIDTH = math.floor(DESIGN_HEIGHT * DEVICE_WIDTH / DEVICE_HEIGHT)
		SCREEN_HEIGHT = DESIGN_HEIGHT
	else
		SCREEN_WIDTH = DESIGN_WIDTH
		SCREEN_HEIGHT = math.floor(DESIGN_WIDTH * DEVICE_HEIGHT / DEVICE_WIDTH)
	end
	
	TITLE_WIDTH = VIEW_WIDTH
	TITLE_HEIGHT = math.min(SCREEN_HEIGHT, MAX_VIEW_WITH_LETTERBOX_HEIGHT)
	
	print("DEVICE_WIDTH", DEVICE_WIDTH, "DEVICE_HEIGHT", DEVICE_HEIGHT)
	print("DESIGN_WIDTH", DESIGN_WIDTH, "DESIGN_HEIGHT", DESIGN_HEIGHT)
	print("VIEW_WIDTH", VIEW_WIDTH, "VIEW_HEIGHT", VIEW_HEIGHT)
	print("SCREEN_WIDTH", SCREEN_WIDTH, "SCREEN_HEIGHT", SCREEN_HEIGHT)
	print("TITLE_WIDTH", TITLE_WIDTH, "TITLE_HEIGHT", TITLE_HEIGHT)
	
	ORIGIN_VIEW_WIDTH = math.max(1280, math.floor(DEVICE_WIDTH * (720 / DEVICE_HEIGHT)))
	ORIGIN_VIEW_HEIGHT = 720
	ORIGIN_VIEW_BASE_LEFT = 0 - math.max(0, (ORIGIN_VIEW_WIDTH - DESIGN_WIDTH) / 2)
	ORIGIN_VIEW_BASE_RIGHT = ORIGIN_VIEW_WIDTH + ORIGIN_VIEW_BASE_LEFT
	VIEW_ASPECT_RATIO = VIEW_WIDTH / VIEW_HEIGHT
	VIEW_BASE_LEFT = 0 - math.max(0, (VIEW_WIDTH - DESIGN_WIDTH) / 2)
	VIEW_BASE_RIGHT = VIEW_WIDTH + VIEW_BASE_LEFT
	HEIGHT_MARGIN = math.max(0, DEVICE_HEIGHT * DESIGN_WIDTH / DEVICE_WIDTH - DESIGN_HEIGHT)
	VIEW_WIDTH_RATIO = VIEW_WIDTH / DESIGN_WIDTH
	SCREEN_ASPECT_RATIO = DESIGN_WIDTH / DESIGN_HEIGHT
	REVERSE_ASPECT_RATIO = DESIGN_HEIGHT / DESIGN_WIDTH
	MIN_ASPECT_RATIO = 0.75
	MAX_ASPECT_RATIO = 0.5625
	NOTCH_WIDTH = 0
	NOTCH_LEFT_WIDTH = 0
	
	TitleBackground:updateOffsetCtrl()
	Patch:updateOffsetCtrl()
	PlatformInitializer:updateOffsetDlg()
	_updateOffsetLogo()
end

function _updateOffsetLogo()
	local var_2_0 = cc.Director:getInstance():getRunningScene()
	
	if not get_cocos_refid(var_2_0) then
		return 
	end
	
	if not var_2_0:getName() == "INIT_SCENE" then
		return 
	end
	
	local var_2_1 = var_2_0:findChildByName("START_LOGO_LAYER")
	
	if get_cocos_refid(var_2_1) then
		var_2_1:setPosition(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
	end
	
	local var_2_2 = var_2_0:findChildByName("START_ENGINE_LAYER")
	
	if get_cocos_refid(var_2_2) then
		var_2_2:setPosition(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
	end
end

local var_0_0 = cc.EventListenerCustom:create("application_change_resolution", application_change_resolution)

cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(var_0_0, -1)

function set_fps(arg_3_0)
	if CURRENT_DISPLAY_FPS ~= arg_3_0 then
		CURRENT_DISPLAY_FPS = arg_3_0
		
		local var_3_0 = cc.Director:getInstance():isNextDeltaTimeZero()
		
		cc.Director:getInstance():setAnimationInterval(1 / CURRENT_DISPLAY_FPS)
		cc.Director:getInstance():setNextDeltaTimeZero(var_3_0)
	end
end

function get_fps()
	return CURRENT_DISPLAY_FPS
end

local function var_0_1()
	if getenv("verinfo.status") == "appupgrade" then
		print("verinfo.status : appupgrade")
		
		return false
	elseif getenv("verinfo.status") == "maintenance" then
		print("verinfo.status : maintenance")
		
		return false
	elseif getenv("verinfo.status") == "busy" then
		print("verinfo.status : busy")
		
		return false
	elseif getenv("verinfo.error", "") ~= "" then
		print("verinfo.error", getenv("verinfo.error"))
		
		return false
	elseif getenv("cdn.url", "") == "" then
		setenv("verinfo.error", "verinfo verify failed.\n cdn: " .. getenv("cdn.url", "nil"))
		print("check_verinfo : failed cdn url")
		print("verinfo.error", getenv("verinfo.error"))
		print(getenv("verinfo.data"))
		
		return false
	end
	
	print("check_verinfo : ok")
	
	return true
end

function getStoreUrl()
	local var_6_0 = getenv("store.url", "")
	local var_6_1 = PLATFORM
	
	if IS_ANDROID_BASED_PLATFORM then
		var_6_1 = getenv("stove.iap", PLATFORM)
	end
	
	local var_6_2 = getenv("store.url." .. var_6_1, var_6_0)
	local var_6_3 = getenv("store.url." .. var_6_1 .. "." .. getUserLanguage(), var_6_2)
	
	print("store_url: " .. "store.url." .. var_6_1 .. "." .. getUserLanguage() .. ", " .. var_6_3)
	
	return var_6_3
end

function getAppVersionString()
	return string.format("%.1f.%d", getenv("app.version", 0), getenv("build.number", 0))
end

function getPatchOriginalVersionString()
	return string.format("R%sT%sM%sS%s\nP%s", getenv("patch.res.original_version", "0"), getenv("patch.text.original_version", "0"), getenv("patch.media.original_version", "0"), getenv("patch.story.original_version", "0"), getenv("patch.pk.version", "0"))
end

function getPatchVersionString()
	return string.format("R%sT%sM%sS%s\nP%s", getenv("patch.res.version", "0"), getenv("patch.text.version", "0"), getenv("patch.media.version", "0"), getenv("patch.story.version", "0"), getenv("patch.pk.version", "0"))
end

function getVersionDetailString()
	local var_10_0 = string.format("\nR:%s T:%s M:%s S:%s P:%s\n", getenv("patch.res.version", "0"), getenv("patch.text.version", "0"), getenv("patch.media.version", "0"), getenv("patch.story.version", "0"), getenv("patch.pk.version", "0"))
	local var_10_1 = "App:" .. getAppVersionString() .. var_10_0
	
	print("getVersionDetailString")
	print(var_10_1)
	
	if not IS_PUBLISHER_ZLONG then
		var_10_1 = var_10_1 .. getUserLanguage()
		
		if Login and Login.getWorldID then
			var_10_1 = var_10_1 .. " " .. tostring(Login:getWorldID() or "")
		end
		
		if getIPCountry then
			print(getIPCountry())
			
			var_10_1 = var_10_1 .. " " .. tostring(getIPCountry())
		end
		
		if getenv("qa_ip", "0") == "1" then
			var_10_1 = var_10_1 .. " " .. get_udid()
		end
	end
	
	return var_10_1
end

function getUserLanguage()
	USER_LANG = USER_LANG or get_user_language() or "en"
	
	return USER_LANG
end

function getMediaLanguage()
	MEDIA_LANG = MEDIA_LANG or getenv("patch.local.lang") or "en"
	
	return MEDIA_LANG
end

function invalidate_language_cache()
	USER_LANG = nil
	MEDIA_LANG = nil
end

function async_load_version_info()
	print("async_load_version_info")
	
	if not getenv("verinfo.api") or getenv("verinfo.api") == "" then
		setenv("verinfo.error", "invalid verinfo api.\n verinfo api: " .. getenv("verinfo.api", "nil"))
		print("verinfo.error", getenv("verinfo.error"))
	else
		setenv("verinfo.error", "")
		setenv("patch.error", "")
		setenv("patch.status", "")
		
		Patch.has_verinfo = false
		
		async_load_remote_environment(function()
			Patch.has_verinfo = true
			
			if ZLONG_SDK_ENABLE then
				call_zlong_async_api("ZlongGameEventLog", json.encode({
					remark = "",
					eventID = "1"
				}))
			end
			
			print("async_load_remote_environment done. verinfo.status : " .. getenv("verinfo.status", "nil"))
			print("is_review : ", getenv("is_review"))
			invalidate_language_cache()
			print("apply Pre LANG : ", getUserLanguage())
			print("patch.local.lang: ", getMediaLanguage())
			print("patch.local.enable : ", getenv("patch.local.enable", ""))
			TitleBackground:updateVersionInfo()
			
			if var_0_1() then
				Patch:startPatch()
			end
		end)
	end
end

local function var_0_2()
	Patch:update()
	TitleBackground:update()
	PlatformInitializer:update()
	
	if (Patch.patch_nextstep or Patch.patch_complete) and not Patch.patch_cleared then
		Patch.patch_cleared = true
		
		set_fps(DEFAULT_DISPLAY_FPS)
		load_application_resources()
	end
	
	collectgarbage("step", 10)
end

local function var_0_3()
	cc.FileUtils:getInstance():setLocaleCode(getUserLanguage())
	
	local var_17_0 = getenv("app.pubid")
	
	if var_17_0 then
		print("set PreFileFilter publisher id :", var_17_0)
		cc.FileUtils:getInstance():setPublisherId(var_17_0)
		cc.FileUtils:getInstance():addLocaleFilter("font", "{name}_{pubid}{ext}|{name}_{loc}{ext}")
		cc.FileUtils:getInstance():addLocaleFilter("ui", "{name}_{pubid}{ext}")
	else
		cc.FileUtils:getInstance():addLocaleFilter("font", "{name}_{loc}{ext}")
	end
end

local function var_0_4()
	print("DEBUG _start_title_scene")
	
	if not cc.UserDefault:getInstance():getBoolForKey("tracking.new_play", false) then
		cc.UserDefault:getInstance():setBoolForKey("tracking.new_play", true)
		
		if tracking_custom_event then
			tracking_custom_event("new_play")
		end
	end
	
	local var_18_0 = 0.3
	
	if PLATFORM == "win32" then
		local var_18_1 = 0
	end
	
	local var_18_2 = cc.Scene:create()
	
	var_18_2:setName("BGANI_SCENE")
	cc.Director:getInstance():replaceScene(cc.TransitionFade:create(0.5, var_18_2, cc.c3b(0, 0, 0)))
	
	local var_18_3 = TitleBackground:createScene()
	
	TitleBackground:show(var_18_2)
	cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(cc.EventListenerCustom:create("director_after_draw", var_0_2), var_18_3)
	Patch:show(var_18_3)
	PlatformInitializer:setScene(var_18_3)
end

local function var_0_5(arg_19_0)
	local var_19_0 = cc.CSLoader:createNode("ui/engine.csb")
	
	var_19_0:setName("START_ENGINE_LAYER")
	var_19_0:setOpacity(0)
	var_19_0:setAnchorPoint(0.5, 0.5)
	var_19_0:setPosition(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
	arg_19_0:addChild(var_19_0)
	
	local var_19_1 = TitleBackground:getEffect("logo_yuna")
	
	var_19_0:getChildByName("n_engine"):addChild(var_19_1)
	
	local var_19_2 = cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(function()
		var_19_1:setAnimation(0, "animation", false)
	end), cc.FadeIn:create(0.2), cc.DelayTime:create(1), cc.CallFunc:create(var_0_4), cc.FadeOut:create(0.3), cc.RemoveSelf:create())
	
	var_19_0:runAction(var_19_2)
end

local function var_0_6(arg_21_0)
	print("[pre] display_logo play")
	
	local var_21_0 = cc.CSLoader:createNode("ui/logo.csb")
	
	var_21_0:setName("START_LOGO_LAYER")
	var_21_0:setOpacity(0)
	var_21_0:setAnchorPoint(0.5, 0.5)
	var_21_0:setPosition(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
	
	local var_21_1 = var_21_0:getChildByName("n_logos")
	local var_21_2 = var_21_0:getChildByName("n_logos_zl")
	
	var_21_1:setVisible(not IS_PUBLISHER_ZLONG)
	var_21_2:setVisible(IS_PUBLISHER_ZLONG)
	arg_21_0:addChild(var_21_0)
	
	local var_21_3 = cc.Sequence:create(cc.DelayTime:create(0.1), cc.FadeIn:create(0.2), cc.DelayTime:create(1.2), cc.FadeOut:create(0.2), cc.CallFunc:create(function()
		var_21_1:setVisible(true)
		var_21_2:setVisible(false)
	end), cc.FadeIn:create(0.2), cc.DelayTime:create(1.2), cc.CallFunc:create(var_0_4), cc.CallFunc:create(function()
		arg_21_0:setColor(cc.c3b(255, 255, 255))
	end), cc.FadeOut:create(0.3), cc.RemoveSelf:create(), cc.CallFunc:create(function()
		print("[pre] display_logo end")
	end))
	local var_21_4 = cc.Sequence:create(cc.DelayTime:create(0.1), cc.FadeIn:create(0.2), cc.DelayTime:create(1.2), cc.CallFunc:create(function()
		var_0_5(arg_21_0)
	end), cc.CallFunc:create(function()
		arg_21_0:setColor(cc.c3b(0, 0, 0))
	end), cc.FadeOut:create(0.3), cc.RemoveSelf:create(), cc.CallFunc:create(function()
		print("[pre] display_logo end")
	end))
	local var_21_5 = var_21_0:getChildByName("n_logos")
	
	var_21_5:setScale(0.735)
	var_21_5:runAction(cc.Sequence:create(cc.DelayTime:create(0.6), cc.EaseOut:create(cc.ScaleTo:create(1, 0.75), 2)))
	var_21_0:runAction(IS_PUBLISHER_ZLONG and var_21_3 or var_21_4)
end

local function var_0_7(arg_28_0, arg_28_1)
	print("[pre] _display_healthy play")
	
	local var_28_0 = cc.CSLoader:createNode("ui/login_healthy.csb")
	
	var_28_0:setOpacity(0)
	var_28_0:setAnchorPoint(0.5, 0.5)
	var_28_0:setPosition(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
	arg_28_0:addChild(var_28_0)
	
	local var_28_1 = cc.Sequence:create(cc.DelayTime:create(0.1), cc.FadeIn:create(0.2), cc.DelayTime:create(2), cc.CallFunc:create(function()
		if arg_28_1 then
			var_0_4()
		else
			var_0_6(arg_28_0)
		end
	end), cc.FadeOut:create(0.3), cc.RemoveSelf:create())
	
	var_28_0:runAction(var_28_1)
end

local function var_0_8()
	if not ENABLE_LOGO_SKIP then
		return false
	end
	
	if not file_mtime then
		return false
	end
	
	local var_30_0 = file_mtime(getenv("app.data_path", "") .. "/" .. "config.db") or 0
	local var_30_1 = os.time() < var_30_0 + 3600 * LOGO_SKIP_HOUR
	
	print("is skip logo: " .. tostring(var_30_1) .. ", " .. os.time() .. " < " .. var_30_0 + 3600 * LOGO_SKIP_HOUR)
	
	return var_30_1
end

local function var_0_9(arg_31_0)
	print("_application_start_contents")
	application_change_resolution()
	
	if is_low_end_custom_view_height then
		LOW_RESOLUTION_MODE = is_low_end_custom_view_height() or false
	end
	
	if getenv("android.pc", "") == "true" then
		LOW_RESOLUTION_MODE = false
	end
	
	print("LOW_RESOLUTION_MODE : ", LOW_RESOLUTION_MODE)
	
	local var_31_0 = getenv("media.quality", "")
	
	if var_31_0 == "" then
		var_31_0 = LOW_RESOLUTION_MODE and "sd" or "fhd"
		
		setenv("media.quality", var_31_0)
	elseif var_31_0 ~= "sd" and var_31_0 ~= "fhd" then
		print("err:wrong media pack quality", var_31_0)
		
		var_31_0 = LOW_RESOLUTION_MODE and "sd" or "fhd"
		
		setenv("media.quality", var_31_0)
	end
	
	print("media_quality : ", var_31_0)
	
	if cc.FileUtils:getInstance().getPropertyString and cc.FileUtils:getInstance():getPropertyString("m.qlt") ~= var_31_0 and cc.FileUtils:getInstance().eraseProperty then
		cc.FileUtils:getInstance():eraseProperty("m.qlt")
	end
	
	if cc.FileUtils:getInstance().setPropertyString then
		cc.FileUtils:getInstance():setPropertyString("m.qlt", var_31_0)
	end
	
	local var_31_1 = getenv("patch.local.lang")
	
	if var_31_1 == "kja" or var_31_1 == "gja" then
		setenv("patch.local.lang", "ja")
		
		if patchpack_rawget and patchpack_rawset then
			local var_31_2 = patchpack_rawget("@patch.attributes")
			local var_31_3 = string.split(var_31_2, ",")
			
			if var_31_3 then
				for iter_31_0, iter_31_1 in pairs(var_31_3) do
					if string.find(iter_31_1, "media") then
						var_31_3[iter_31_0] = nil
					end
				end
				
				local var_31_4
				
				for iter_31_2, iter_31_3 in pairs(var_31_3) do
					if not var_31_4 then
						var_31_4 = iter_31_3
					else
						var_31_4 = var_31_4 .. "," .. iter_31_3
					end
				end
				
				if var_31_4 then
					patchpack_rawset("@patch.attributes", var_31_4)
				end
			end
		end
	end
	
	cc.Director:getInstance():getEventDispatcher():removeEventListener(arg_31_0:getEventListener())
	
	local var_31_5 = cc.Scene:create()
	
	var_31_5:setName("INIT_SCENE")
	
	if getenv("init.scene") and getenv("init.scene") ~= "title" then
		cc.Director:getInstance():runWithScene(var_31_5)
		
		Patch.patch_complete = true
		Patch.patch_cleared = true
		
		var_31_5:runAction(cc.CallFunc:create(load_application_resources))
		
		return 
	end
	
	USER_LANG = get_user_language()
	MEDIA_LANG = getenv("patch.local.lang")
	
	print("Pre LANG : ", USER_LANG)
	PreDatas:init()
	var_0_3()
	PlatformInitializer:performInitialize(function()
		async_load_version_info()
	end)
	
	local var_31_6 = cc.LayerColor:create(cc.c3b(255, 255, 255))
	
	var_31_5.bg_layer = var_31_6
	
	var_31_5:addChild(var_31_6)
	cc.Director:getInstance():runWithScene(var_31_5)
	
	local var_31_7 = var_0_8()
	
	if IS_PUBLISHER_ZLONG then
		var_0_7(var_31_6, var_31_7)
	elseif var_31_7 then
		var_0_4()
	else
		var_0_6(var_31_6)
	end
end

cc.Director:getInstance():getEventDispatcher():addCustomEventListener("application_start_contents", var_0_9)
