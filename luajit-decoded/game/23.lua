MAX_ACCOUNT_LEVEL = 99
CLAN_MAX_LEVEL = 50
PRIMAL_STANDARD_TIME = os.time({
	hour = 4,
	month = 1,
	year = 2018,
	min = 0,
	sec = 0,
	day = 1
})
GAME_SRC_VER = 2
TITLE = getenv("app.title", "UR")
PLATFORM = getenv("platform")
BATTLE_TIME_SCALE_X0 = 1.2
BATTLE_TIME_SCALE_X1 = 0.9
BATTLE_TIME_SCALE_X2 = 1.2
BTLHUD_ACTIONBAR_COUNT = 7
DELAY_SKILL_CHAIN = 1500
PERFECT_CHAIN_RATE_1 = 0.6
PERFECT_CHAIN_RATE_2 = 0.9
MAX_SOUL_FX_COUNT = 10
MODEL_DESIGN_HEIGHT = 640
WIDGET_DESIGN_WIDTH = 1280
WIDGET_DESIGN_HEIGHT = 720
STORY_TXT_SPEED = 15
STORY_TXT_START_TIME = 300
COLOR_CRI_HIGH_FONT = cc.c3b(255, 200, 200)
COLOR_CRI_FONT = {
	cc.c3b(255, 255, 50),
	cc.c3b(230, 50, 50)
}
COLOR_DAMAGE_FONT = {
	cc.c3b(120, 120, 120),
	cc.c3b(255, 255, 255)
}
COLOR_HEAL_FONT = {
	cc.c3b(0, 255, 0),
	cc.c3b(255, 255, 255)
}
COLOR_SP_HEAL_FONT = {
	cc.c3b(0, 120, 255),
	cc.c3b(255, 255, 255)
}
COLOR_LEVELUP_FONT = {
	cc.c3b(255, 255, 0),
	cc.c3b(255, 200, 200)
}
COLOR_POISON_FONT = {
	cc.c3b(120, 120, 120),
	cc.c3b(255, 255, 255)
}
COLOR_SET_ITEM_LACK_FONT = cc.c3b(220, 220, 220)
COLOR_SET_ITEM_FULL_FONT = cc.c3b(160, 250, 150)
EQUIP_COLORS = {
	cc.c3b(220, 220, 220),
	cc.c3b(160, 250, 150),
	cc.c3b(90, 120, 190),
	cc.c3b(160, 100, 180),
	cc.c3b(255, 90, 0)
}
ELEMENT_COLORS = {
	light = cc.c3b(255, 220, 0),
	fire = cc.c3b(200, 0, 0),
	wind = cc.c3b(0, 200, 0),
	ice = cc.c3b(0, 0, 200),
	dark = cc.c3b(255, 0, 255)
}
CAM_RUN_SCALE = 1
CAM_DEFAULT_SCALE = 1
CAM_READY_SCALE = 1.15
CAM_FOCUS_SCALE = 1.6
CAM_JUMP_ATTACK_SCALE = 2
FONT_SIZE_H1 = 24
FONT_SIZE_H2 = 22
FONT_SIZE_H3 = 20
FONT_SIZE_H4 = 17
FONT_SIZE = 36
DEVICE_SPEC_NUM = 10
LOCAL_PUSH_IDS = {
	ORBIS_COLLECT = {
		id = 100,
		title = "push_sanc_orbis",
		category = "push_orbis",
		desc = "orbis_collect"
	},
	FOREST_SPIRIT = {
		id = 201,
		title = "push_title_forest_new_spirit",
		category = "push_forest",
		desc = "push_desc_forest_new_spirit"
	},
	FOREST_PENGUIN = {
		id = 202,
		title = "push_title_forest_new_pen",
		category = "push_forest",
		desc = "push_desc_forest_new_pen"
	},
	FOREST_MURA_WATER = {
		id = 203,
		title = "push_title_forest_new_mura_water",
		category = "push_forest",
		desc = "push_desc_forest_new_mura_water"
	},
	FOREST_MURA_GET = {
		id = 204,
		title = "push_title_forest_new_mura_get",
		category = "push_forest",
		desc = "push_desc_forest_new_mura_get"
	},
	SUBTASK_COMPLETE_1 = {
		id = 301,
		title = "push_sanc_subtask",
		category = "push_subtask",
		desc = "subtask_end"
	},
	SUBTASK_COMPLETE_2 = {
		id = 302,
		title = "push_sanc_subtask",
		category = "push_subtask",
		desc = "subtask_end"
	},
	SUBTASK_COMPLETE_3 = {
		id = 303,
		title = "push_sanc_subtask",
		category = "push_subtask",
		desc = "subtask_end"
	},
	STAMINA_FILL = {
		id = 400,
		title = "push_stamina",
		category = "push_stamina",
		desc = "stamina_fill_end"
	},
	DAILY_CONNECT_1 = {
		id = 500,
		title = "push_login_aos_title_d1",
		category = "push_connect",
		desc = "push_login_aos_desc_d1"
	},
	DAILY_CONNECT_3 = {
		id = 501,
		title = "push_login_aos_title_d3",
		category = "push_connect",
		desc = "push_login_aos_desc_d3"
	}
}

if PLATFORM == "iphoneos" then
	LOCAL_PUSH_IDS.DAILY_CONNECT_1.desc = "push_login_ios_d1"
	LOCAL_PUSH_IDS.DAILY_CONNECT_3.desc = "push_login_ios_d3"
end

NOTI_UNIT_SKILL_UPGRADE = "noti.unit.skill_upgrade."
NOTI_UNIT_EXCLUSIVE_EQUIP = "noti.unit.exclusive_equip."
DAILY_CONNECT_1_PUSH_TIME = 86400
DAILY_CONNECT_3_PUSH_TIME = 259200
IOS_MACHINE_ID = getenv("ios.machine_id") or nil
ANDROID_MACHINE_ID = getenv("android.device_id") or nil
IS_ANDROID_PC = PLATFORM == "android" and getenv("android.pc", "") == "true"
STOVE_IAP = IS_ANDROID_BASED_PLATFORM and getenv("stove.iap", "google") or ""
EPISODE_THRESHOLD = 5
SUBTITLE_COLOR = cc.c3b(245, 245, 245)
SUBTITLE_OUT_LINE_COLOR = cc.c3b(0, 0, 0)
SUBTITLE_OUT_LINE_PIXEL = 1
SUBTITLE_SCALE = 1.4
SUBTITLE_FONT_SIZE = 24
SUBTITLE_TEXT_ALIGNMENT = cc.TEXT_ALIGNMENT_CENTER
SUBTITLE_FIXED_Y = 0
MIN_DOWNLOAD_RATE = 0.8
ZL_MD5_HEX = "5cee45e1f04dc91db99d7ed38aae4efb"
ZL_INI_KEY = "rescdn=update.cdn.smilegate.com/kr/cdn/"

function init_resolution_constanst()
	print("init_resolution_constanst")
	
	WIDGET_ASPECT_RATIO = math.max(MIN_ASPECT_RATIO, math.min(SCREEN_ASPECT_RATIO, MAX_ASPECT_RATIO))
	WIDGET_SCALE_FACTOR = DESIGN_WIDTH / WIDGET_DESIGN_WIDTH
	MODEL_SCALE_FACTOR = DESIGN_HEIGHT / MODEL_DESIGN_HEIGHT
	FIT_HEIGHT_SCALE_FACTOR = DESIGN_HEIGHT / WIDGET_DESIGN_HEIGHT
	FIT_WIDTH_SCALE_FACTOR = DESIGN_WIDTH / WIDGET_DESIGN_WIDTH
	FIT_HEIGHT_LEGACY_FACTOR = DESIGN_HEIGHT / 1080
	FIT_WIDTH_LEGACY_FACTOR = DESIGN_WIDTH / 1920
	LEGACY_FACTOR = FIT_WIDTH_LEGACY_FACTOR
	BASE_SCALE = MODEL_SCALE_FACTOR * 0.4
	CAM_ANCHOR_X = 0.5
	CAM_ANCHOR_Y = 0.2
	DEF_CAM_X = DESIGN_WIDTH * CAM_ANCHOR_X
	DEF_CAM_Y = DESIGN_HEIGHT * CAM_ANCHOR_Y
end

init_resolution_constanst()
