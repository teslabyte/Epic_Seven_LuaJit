Action = {}
Action.List = {}
Action.ON_MAKE = {}
Action.ON_UPDATE = {}
Action.ON_FINISH = {}
Action.ON_RESET = {}

local var_0_0 = Action.ON_MAKE
local var_0_1 = Action.ON_UPDATE
local var_0_2 = Action.ON_FINISH
local var_0_3 = Action.ON_RESET

local function var_0_4()
end

local var_0_5 = 1e-07

local function var_0_6(arg_2_0)
	return true
end

local function var_0_7(arg_3_0)
	local var_3_0 = arg_3_0.TOTAL_TIME - arg_3_0.elapsed_time
	
	return arg_3_0.removed or arg_3_0.finished or var_3_0 < var_0_5 and var_3_0 > 0 - var_0_5
end

local function var_0_8(arg_4_0)
	return arg_4_0.removed or arg_4_0.INTERFACE:IsFinished(arg_4_0)
end

local function var_0_9(arg_5_0)
	return arg_5_0.removed or arg_5_0.CHILD:IsFinished()
end

local function var_0_10(arg_6_0)
	return arg_6_0.removed or arg_6_0.count > 0
end

local function var_0_11(arg_7_0)
	if arg_7_0.removed then
		return true
	end
	
	for iter_7_0 = 1, #arg_7_0.CHILDS do
		if not arg_7_0.CHILDS[iter_7_0]:IsFinished() then
			return false
		end
	end
	
	return true
end

local function var_0_12(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	if type(arg_8_2) == "function" then
		local var_8_0 = getmetatable(arg_8_0)
		
		if not var_8_0 then
			var_8_0 = {
				__index = function(arg_9_0, arg_9_1)
					local var_9_0 = getmetatable(arg_9_0).getter[arg_9_1]
					
					if var_9_0 then
						if var_9_0.always then
							return var_9_0.call()
						else
							rawset(arg_9_0, arg_9_1, var_9_0.call())
						end
					end
					
					return rawget(arg_9_0, arg_9_1)
				end
			}
			
			setmetatable(arg_8_0, var_8_0)
		end
		
		var_8_0.getter = var_8_0.getter or {}
		var_8_0.getter[arg_8_1] = {
			call = arg_8_2,
			always = arg_8_3
		}
	else
		arg_8_0[arg_8_1] = arg_8_2
	end
end

function INC_NUMBER(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	return {
		INC_NUMBER,
		arg_10_0,
		arg_10_1,
		arg_10_2,
		arg_10_3
	}
end

function TEXT(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	return {
		TEXT,
		arg_11_0,
		arg_11_1,
		arg_11_2,
		arg_11_3
	}
end

function STORY_TEXT(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	return {
		STORY_TEXT,
		arg_12_0,
		arg_12_1,
		arg_12_2,
		arg_12_3
	}
end

function SOUND_TEXT(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	return {
		SOUND_TEXT,
		arg_13_0,
		arg_13_1,
		arg_13_2,
		arg_13_3,
		arg_13_4
	}
end

function LOG(arg_14_0, arg_14_1)
	return {
		LOG,
		arg_14_0,
		arg_14_1
	}
end

function RLOG(arg_15_0, arg_15_1)
	return {
		RLOG,
		arg_15_0,
		arg_15_1
	}
end

function MAXRLOG(arg_16_0, arg_16_1, arg_16_2)
	return {
		MAXRLOG,
		arg_16_0,
		arg_16_1,
		arg_16_2
	}
end

function BEZIER(arg_17_0, arg_17_1)
	return {
		BEZIER,
		arg_17_0,
		arg_17_1
	}
end

function MOVE_TO(arg_18_0, arg_18_1, arg_18_2)
	return {
		MOVE_TO,
		arg_18_0,
		arg_18_1,
		arg_18_2
	}
end

function JUMP_TO(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	return {
		JUMP_TO,
		arg_19_0,
		arg_19_1,
		arg_19_2,
		arg_19_3
	}
end

function WARP_TO(arg_20_0, arg_20_1, arg_20_2)
	return {
		WARP_TO,
		arg_20_0,
		arg_20_1,
		arg_20_2
	}
end

function MOVE_BY(arg_21_0, arg_21_1, arg_21_2)
	return {
		MOVE_BY,
		arg_21_0,
		arg_21_1,
		arg_21_2
	}
end

function MOVE_BY_SMOOTH(arg_22_0, arg_22_1, arg_22_2)
	return {
		MOVE_BY_SMOOTH,
		arg_22_0,
		arg_22_1,
		arg_22_2
	}
end

function JUMP_BY(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	return {
		JUMP_BY,
		arg_23_0,
		arg_23_1,
		arg_23_2,
		arg_23_3
	}
end

function MOVE(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5)
	return {
		MOVE,
		arg_24_0,
		arg_24_1,
		arg_24_2,
		arg_24_3,
		arg_24_4,
		arg_24_5
	}
end

function SHOW(arg_25_0)
	return {
		SHOW,
		arg_25_0
	}
end

function SOUND(arg_26_0)
	return {
		SOUND,
		arg_26_0
	}
end

function ZORDER(arg_27_0)
	return {
		ZORDER,
		arg_27_0
	}
end

function DMOTION(arg_28_0, arg_28_1, arg_28_2)
	return {
		DMOTION,
		arg_28_0,
		arg_28_1,
		arg_28_2
	}
end

function MOTION(arg_29_0, arg_29_1, arg_29_2)
	return {
		MOTION,
		arg_29_0,
		arg_29_1,
		arg_29_2
	}
end

function STOP()
	return {
		STOP
	}
end

function REMOVE()
	return {
		REMOVE
	}
end

function REMOVE_SPRITE()
	return {
		REMOVE_SPRITE
	}
end

function RESUME()
	return {
		RESUME
	}
end

function PAUSE()
	return {
		PAUSE
	}
end

function RELEASE_UNIT()
	return {
		RELEASE_UNIT
	}
end

function SPRITE(arg_36_0)
	return {
		SPRITE,
		arg_36_0
	}
end

function RESET_SPRITE(arg_37_0, arg_37_1, arg_37_2)
	return {
		RESET_SPRITE,
		arg_37_0,
		arg_37_1,
		arg_37_2
	}
end

function BLEND(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	return {
		BLEND,
		arg_38_0,
		arg_38_1,
		arg_38_2,
		arg_38_3
	}
end

function SCALE(arg_39_0, arg_39_1, arg_39_2)
	return {
		SCALE,
		arg_39_0,
		arg_39_1,
		arg_39_2
	}
end

function SCALE_TO(arg_40_0, arg_40_1)
	return {
		SCALE_TO,
		arg_40_0,
		arg_40_1
	}
end

function SCALE_TO_X(arg_41_0, arg_41_1)
	return {
		SCALE_TO_X,
		arg_41_0,
		arg_41_1
	}
end

function SCALE_TO_Y(arg_42_0, arg_42_1)
	return {
		SCALE_TO_Y,
		arg_42_0,
		arg_42_1
	}
end

function SCALEX(arg_43_0, arg_43_1, arg_43_2)
	return {
		SCALEX,
		arg_43_0,
		arg_43_1,
		arg_43_2
	}
end

function SCALEY(arg_44_0, arg_44_1, arg_44_2)
	return {
		SCALEY,
		arg_44_0,
		arg_44_1,
		arg_44_2
	}
end

function CONTENT_SIZE(arg_45_0, arg_45_1, arg_45_2)
	return {
		CONTENT_SIZE,
		arg_45_0,
		arg_45_1,
		arg_45_2
	}
end

function SPAWN(...)
	return {
		SPAWN,
		...
	}
end

function SEQ(...)
	return {
		SEQ,
		...
	}
end

function SEQ_LIST(arg_48_0)
	return {
		SEQ_LIST,
		arg_48_0
	}
end

function FADE_IN(arg_49_0)
	return {
		FADE_IN,
		arg_49_0
	}
end

function FADE_OUT(arg_50_0, arg_50_1)
	return {
		FADE_OUT,
		arg_50_0,
		arg_50_1
	}
end

function SLIDE_IN(arg_51_0, arg_51_1, arg_51_2, arg_51_3)
	return {
		SLIDE_IN,
		arg_51_0,
		arg_51_1,
		arg_51_2,
		arg_51_3
	}
end

function SLIDE_IN_Y(arg_52_0, arg_52_1, arg_52_2)
	return {
		SLIDE_IN_Y,
		arg_52_0,
		arg_52_1,
		arg_52_2
	}
end

function APPEAR(arg_53_0, arg_53_1, arg_53_2, arg_53_3)
	return {
		APPEAR,
		arg_53_0,
		arg_53_1,
		arg_53_2,
		false,
		arg_53_3
	}
end

function DISAPPEAR(arg_54_0, arg_54_1, arg_54_2, arg_54_3)
	return {
		APPEAR,
		arg_54_0,
		arg_54_1,
		arg_54_2,
		true,
		arg_54_3
	}
end

function SLIDE_OUT(arg_55_0, arg_55_1, arg_55_2)
	return {
		SLIDE_OUT,
		arg_55_0,
		arg_55_1,
		arg_55_2
	}
end

function SLIDE_OUT_Y(arg_56_0, arg_56_1, arg_56_2)
	return {
		SLIDE_OUT_Y,
		arg_56_0,
		arg_56_1,
		arg_56_2
	}
end

function SHAKE_UI(arg_57_0, arg_57_1, arg_57_2, arg_57_3)
	return {
		SHAKE_UI,
		arg_57_0,
		arg_57_1,
		arg_57_2,
		arg_57_3
	}
end

function SHAKE_CAM(arg_58_0, arg_58_1, arg_58_2, arg_58_3, arg_58_4)
	return {
		SHAKE_CAM,
		arg_58_0,
		arg_58_1,
		arg_58_2,
		arg_58_3,
		arg_58_4
	}
end

function ANI_CAM(arg_59_0)
	return {
		ANI_CAM,
		arg_59_0
	}
end

function DELAY(arg_60_0)
	return {
		DELAY,
		arg_60_0
	}
end

function VAR(arg_61_0, arg_61_1, arg_61_2, arg_61_3, arg_61_4)
	return {
		VAR,
		arg_61_0,
		arg_61_1,
		arg_61_2,
		arg_61_3,
		arg_61_4
	}
end

function VAR_TO(arg_62_0, arg_62_1, arg_62_2, arg_62_3)
	return {
		VAR_TO,
		arg_62_0,
		arg_62_1,
		arg_62_2,
		arg_62_3
	}
end

function LINEAR_CALL(arg_63_0, arg_63_1, arg_63_2, arg_63_3, arg_63_4)
	return {
		LINEAR_CALL,
		arg_63_0,
		arg_63_1,
		arg_63_2,
		arg_63_3,
		arg_63_4
	}
end

function CALL(arg_64_0, ...)
	return {
		CALL,
		arg_64_0,
		{
			...
		}
	}
end

function RUN(arg_65_0)
	return {
		RUN,
		arg_65_0
	}
end

function COLOR(arg_66_0, arg_66_1, arg_66_2, arg_66_3, arg_66_4, arg_66_5, arg_66_6)
	return {
		COLOR,
		arg_66_0,
		arg_66_1,
		arg_66_2,
		arg_66_3,
		arg_66_4,
		arg_66_5,
		arg_66_6
	}
end

function FIX_MODEL_FROM_COLOR(arg_67_0, arg_67_1, arg_67_2, arg_67_3, arg_67_4, arg_67_5, arg_67_6)
	return {
		FIX_MODEL_FROM_COLOR,
		arg_67_0,
		arg_67_1,
		arg_67_2,
		arg_67_3,
		arg_67_4,
		arg_67_5,
		arg_67_6
	}
end

function OPACITY(arg_68_0, arg_68_1, arg_68_2)
	return {
		OPACITY,
		arg_68_0,
		arg_68_1,
		arg_68_2
	}
end

function PROGRESS(arg_69_0, arg_69_1, arg_69_2)
	return {
		PROGRESS,
		arg_69_0,
		arg_69_1,
		arg_69_2
	}
end

function PERCENTAGE(arg_70_0, arg_70_1, arg_70_2)
	return {
		PERCENTAGE,
		arg_70_0,
		arg_70_1,
		arg_70_2
	}
end

function ROTATE(arg_71_0, arg_71_1, arg_71_2)
	return {
		ROTATE,
		arg_71_0,
		arg_71_1,
		arg_71_2
	}
end

function LAYER_OPACITY(arg_72_0, arg_72_1, arg_72_2)
	return {
		LAYER_OPACITY,
		arg_72_0,
		arg_72_1,
		arg_72_2
	}
end

function REPEAT(arg_73_0, arg_73_1)
	return {
		REPEAT,
		arg_73_0,
		arg_73_1
	}
end

function LOOP(arg_74_0)
	return {
		LOOP,
		arg_74_0
	}
end

function COND_LOOP(arg_75_0, arg_75_1, arg_75_2)
	return {
		COND_LOOP,
		arg_75_0,
		arg_75_1,
		arg_75_2
	}
end

function ANCHOR(arg_76_0, arg_76_1, arg_76_2)
	return {
		ANCHOR,
		arg_76_0,
		arg_76_1,
		arg_76_2
	}
end

function ANCHOR_BY(arg_77_0, arg_77_1, arg_77_2)
	return {
		ANCHOR_BY,
		arg_77_0,
		arg_77_1,
		arg_77_2
	}
end

function ANI(arg_78_0, arg_78_1, arg_78_2, arg_78_3, arg_78_4, arg_78_5)
	return {
		ANI,
		arg_78_0,
		arg_78_1,
		arg_78_2,
		arg_78_3,
		arg_78_4,
		arg_78_5
	}
end

function ANI_LOOP(arg_79_0, arg_79_1)
	return {
		ANI_LOOP,
		arg_79_0,
		arg_79_1
	}
end

function TARGET(arg_80_0, arg_80_1)
	return {
		TARGET,
		arg_80_0,
		arg_80_1
	}
end

function WAVESTRING(arg_81_0)
	return {
		WAVESTRING,
		arg_81_0
	}
end

function USER_ACT(arg_82_0, ...)
	return {
		USER_ACT,
		arg_82_0,
		{
			...
		}
	}
end

NONE = DELAY
var_0_0[ANI] = function(arg_83_0, arg_83_1, arg_83_2)
	arg_83_0.ANI_TIME = arg_83_1[2]
	arg_83_0.AUTO_REMOVE = arg_83_1[4]
	arg_83_0.REPEAT = arg_83_1[5]
	arg_83_0.TIMING = arg_83_1[6]
	arg_83_0.INTERVAL = arg_83_1[7] or 0
	arg_83_0.ORIGIN_SCALE = arg_83_2:getScale()
	
	if type(arg_83_1[3]) == "table" then
		arg_83_0.MAP = arg_83_1[3]
		arg_83_0.FRAME = #arg_83_0.MAP
	elseif type(arg_83_1[3]) == "string" then
		arg_83_0.FRAME = SpriteCache:getFrameCount(arg_83_1[3])
	else
		arg_83_0.FRAME = SpriteCache:getFrameCount(arg_83_0.TARGET)
	end
	
	if arg_83_0.REPEAT then
		if arg_83_0.REPEAT == true then
			arg_83_0.TOTAL_TIME = math.huge
		else
			arg_83_0.TOTAL_TIME = (arg_83_0.ANI_TIME + arg_83_0.INTERVAL) * arg_83_0.REPEAT
		end
	else
		arg_83_0.TOTAL_TIME = arg_83_0.ANI_TIME + arg_83_0.INTERVAL
	end
end
var_0_1[ANI] = function(arg_84_0, arg_84_1, arg_84_2)
	local var_84_0 = (arg_84_0.elapsed_time + arg_84_2) / (arg_84_0.ANI_TIME + arg_84_0.INTERVAL)
	
	if var_84_0 > 1 then
		var_84_0 = var_84_0 % 1
	end
	
	local var_84_1 = var_84_0 * (arg_84_0.ANI_TIME + arg_84_0.INTERVAL) / arg_84_0.ANI_TIME
	
	if var_84_1 > 1 then
		arg_84_0.TARGET:setVisible(false)
		
		return 
	end
	
	arg_84_0.TARGET:setVisible(true)
	
	local var_84_2 = var_84_1
	local var_84_3
	
	if arg_84_0.TIMING then
		for iter_84_0 = 1, #arg_84_0.TIMING do
			if var_84_2 * arg_84_0.ANI_TIME <= arg_84_0.TIMING[iter_84_0] then
				var_84_3 = iter_84_0
				
				break
			end
		end
	else
		var_84_3 = math.min(arg_84_0.FRAME, math.floor(var_84_2 * arg_84_0.FRAME) + 1)
	end
	
	if arg_84_0.MAP ~= nil then
		var_84_3 = arg_84_0.MAP[var_84_3]
	end
	
	local var_84_4
	
	if arg_84_0.prev_frame ~= var_84_3 then
		var_84_4 = SpriteCache:resetSprite(arg_84_0.TARGET, var_84_3)
		arg_84_0.prev_frame = var_84_3
	end
	
	if var_84_4 then
		local var_84_5 = var_84_4:getOriginalSizeInPixels()
		
		if var_84_5.width == 284 and var_84_5.height == 160 then
			arg_84_0.TARGET:setScale(arg_84_0.ORIGIN_SCALE * 2)
		else
			arg_84_0.TARGET:setScale(arg_84_0.ORIGIN_SCALE)
		end
	end
end
var_0_2[ANI] = function(arg_85_0, arg_85_1)
	if arg_85_0.AUTO_REMOVE then
		remove_object(arg_85_0.TARGET)
	end
end
var_0_0[BLEND] = function(arg_86_0, arg_86_1, arg_86_2)
	arg_86_0.COLOR = arg_86_1[3]
	arg_86_0.FROM_FACTOR = arg_86_1[4] or 1
	arg_86_0.TO_FACTOR = arg_86_1[5] or 1
	arg_86_0.TOTAL_TIME = arg_86_1[2] or 0
end
var_0_1[BLEND] = function(arg_87_0, arg_87_1, arg_87_2)
	local var_87_0 = (arg_87_0.elapsed_time + arg_87_2) / arg_87_0.TOTAL_TIME
	local var_87_1 = arg_87_0.FROM_FACTOR + (arg_87_0.TO_FACTOR - arg_87_0.FROM_FACTOR) * var_87_0
	
	if arg_87_0.COLOR == "white" then
		setBlendColor2(arg_87_0.TARGET, "def", cc.c4f(1, 1, 1, 1), var_87_1)
	elseif arg_87_0.COLOR == "black" then
		setBlendColor2(arg_87_0.TARGET, "def", cc.c4f(-1, -1, -1, 1), var_87_1)
	elseif arg_87_0.COLOR == "red" then
		setBlendColor2(arg_87_0.TARGET, "def", cc.c4f(1, 0, 0, 1), var_87_1)
	elseif arg_87_0.COLOR then
		setBlendColor2(arg_87_0.TARGET, "def", arg_87_0.COLOR, var_87_1)
	else
		setBlendColor2(arg_87_0.TARGET, "def")
	end
end
var_0_0[WAVESTRING] = function(arg_88_0, arg_88_1, arg_88_2)
	arg_88_0.AUTO_REMOVE = arg_88_1[2]
	arg_88_0.ANI_TIME = utf8len(arg_88_2:getString()) * 60 + 190
	arg_88_0.TOTAL_TIME = arg_88_0.ANI_TIME
	
	if arg_88_0.AUTO_REMOVE then
		arg_88_0.TOTAL_TIME = arg_88_0.TOTAL_TIME + 600
	end
end
var_0_1[WAVESTRING] = function(arg_89_0, arg_89_1, arg_89_2)
	if arg_89_0.elapsed_time == 0 then
		arg_89_0.TARGET:updateFontAnimation(-1)
	end
	
	arg_89_0.TARGET:updateFontAnimation(arg_89_2 / 1000)
	
	if arg_89_0.elapsed_time > arg_89_0.ANI_TIME + 300 then
		local var_89_0 = 1 - (arg_89_0.elapsed_time - (arg_89_0.ANI_TIME + 300)) / 300
		
		arg_89_0.TARGET:setOpacity(var_89_0 * 255)
	end
end
var_0_2[WAVESTRING] = function(arg_90_0, arg_90_1)
	if arg_90_0.AUTO_REMOVE then
		remove_object(arg_90_0.TARGET)
	end
end
var_0_0[TEXT] = function(arg_91_0, arg_91_1, arg_91_2)
	local var_91_0 = string.gsub(arg_91_1[2], "\\n", "\n")
	local var_91_1 = utf8len(var_91_0, arg_91_1[5])
	
	if var_91_1 > 10 and not arg_91_1[3] then
		arg_91_0.START_TIME = math.min(STORY_TXT_START_TIME, var_91_1 * 3)
	else
		arg_91_0.START_TIME = 0
	end
	
	arg_91_0.TXT_SPEED = arg_91_1[4] or STORY_TXT_SPEED
	arg_91_0.TOTAL_TIME = math.max(0, var_91_1 * arg_91_0.TXT_SPEED)
	arg_91_0.TAG_ENABLED = arg_91_1[5]
	arg_91_0.TEXT = var_91_0
	arg_91_0.gap = arg_91_1[6]
end
var_0_1[TEXT] = function(arg_92_0, arg_92_1, arg_92_2)
	local var_92_0 = arg_92_0.elapsed_time + arg_92_2 + arg_92_0.START_TIME
	local var_92_1 = math.floor(var_92_0 / arg_92_0.TXT_SPEED)
	local var_92_2 = utf8sub(arg_92_0.TEXT, 1, var_92_1, arg_92_0.TAG_ENABLED)
	
	if var_92_2 == nil then
		var_92_2 = ""
	end
	
	if_set(arg_92_0.TARGET, nil, var_92_2)
end
var_0_2[TEXT] = function(arg_93_0, arg_93_1)
	if_set(arg_93_0.TARGET, nil, arg_93_0.TEXT)
end
var_0_3[TEXT] = function(arg_94_0, arg_94_1)
	if_set(arg_94_0.TARGET, nil, "")
end
var_0_0[STORY_TEXT] = function(arg_95_0, arg_95_1, arg_95_2)
	local var_95_0 = string.gsub(arg_95_1[2], "\\n", "\n")
	local var_95_1 = utf8len(var_95_0, arg_95_1[5])
	
	if var_95_1 > 10 and not arg_95_1[3] then
		arg_95_0.START_TIME = math.min(STORY_TXT_START_TIME, var_95_1 * 3)
	else
		arg_95_0.START_TIME = 0
	end
	
	arg_95_0.TXT_SPEED = arg_95_1[4] or STORY_TXT_SPEED
	arg_95_0.TOTAL_TIME = math.max(0, var_95_1 * arg_95_0.TXT_SPEED)
	arg_95_0.TAG_ENABLED = arg_95_1[5]
	arg_95_0.TEXT = var_95_0
	
	if_set(arg_95_0.TARGET, nil, var_95_0)
end
var_0_1[STORY_TEXT] = function(arg_96_0, arg_96_1, arg_96_2)
	local var_96_0 = arg_96_0.elapsed_time + arg_96_2 + arg_96_0.START_TIME
	local var_96_1 = math.floor(var_96_0 / arg_96_0.TXT_SPEED)
	local var_96_2 = utf8sub(arg_96_0.TEXT, 1, var_96_1, arg_96_0.TAG_ENABLED) or ""
	
	arg_96_0.TARGET:setDrawLettersNum(var_96_2:utf8len())
end
var_0_2[STORY_TEXT] = function(arg_97_0, arg_97_1)
	arg_97_0.TARGET:setDrawLettersNum(-1)
end
var_0_3[STORY_TEXT] = function(arg_98_0, arg_98_1)
	arg_98_0.TARGET:setDrawLettersNum(0)
end
var_0_0[SOUND_TEXT] = function(arg_99_0, arg_99_1, arg_99_2)
	var_0_0[TEXT](arg_99_0, arg_99_1, arg_99_2)
	
	if isEULanguage() then
		if_set(arg_99_0.TARGET, nil, arg_99_0.TEXT)
		arg_99_0.TARGET:setDrawLettersNum(0)
	end
end
var_0_1[SOUND_TEXT] = function(arg_100_0, arg_100_1, arg_100_2)
	local var_100_0 = arg_100_0.elapsed_time + arg_100_2 + arg_100_0.START_TIME
	local var_100_1 = math.floor(var_100_0 / arg_100_0.TXT_SPEED)
	
	if isEULanguage() then
		arg_100_0.TARGET:setDrawLettersNum(var_100_1)
	else
		local var_100_2 = utf8sub(arg_100_0.TEXT, 1, var_100_1, arg_100_0.TAG_ENABLED)
		
		if var_100_2 == nil then
			var_100_2 = ""
		end
		
		if_set(arg_100_0.TARGET, nil, var_100_2)
	end
	
	SoundEngine:play("event:/ui/text", {
		gap = arg_100_0.gap
	})
end
var_0_2[SOUND_TEXT] = function(arg_101_0, arg_101_1)
	SoundEngine:play("event:/ui/text")
	if_set(arg_101_0.TARGET, nil, arg_101_0.TEXT)
	UIUserData:parse(arg_101_0.TARGET)
	UIUserData:procAfterLoadDlg()
end
var_0_3[SOUND_TEXT] = var_0_3[TEXT]
var_0_0[INC_NUMBER] = function(arg_102_0, arg_102_1, arg_102_2)
	arg_102_0.TOTAL_TIME = arg_102_1[2]
	arg_102_0.TEXT = arg_102_1[3] or tonumber(arg_102_2:getString())
	
	if arg_102_1[4] == "time" or arg_102_1[4] == true then
		arg_102_0.DECO = sec_to_string
	elseif arg_102_1[4] == "%" then
		function arg_102_0.DECO(arg_103_0)
			return math.floor(arg_103_0) .. "%"
		end
	else
		function arg_102_0.DECO(arg_104_0)
			return comma_value(math.floor(arg_104_0))
		end
	end
	
	arg_102_0.START_NUM = arg_102_1[5]
end
var_0_1[INC_NUMBER] = function(arg_105_0, arg_105_1, arg_105_2)
	local var_105_0 = (arg_105_0.elapsed_time + arg_105_2) / arg_105_0.TOTAL_TIME
	local var_105_1 = math.log(1 + var_105_0 * 99, 100) / 1
	
	if not arg_105_0.START_NUM then
		local var_105_2 = arg_105_0.DECO(math.floor(arg_105_0.TEXT * var_105_1))
		
		arg_105_0.TARGET:setString(var_105_2)
	elseif arg_105_0.TEXT == arg_105_0.START_NUM then
		arg_105_0.TARGET:setString(arg_105_0.DECO(arg_105_0.TEXT))
	else
		local var_105_3 = arg_105_0.DECO(arg_105_0.START_NUM + math.floor((arg_105_0.TEXT - arg_105_0.START_NUM) * var_105_1))
		
		arg_105_0.TARGET:setString(var_105_3)
	end
end
var_0_2[INC_NUMBER] = function(arg_106_0, arg_106_1)
	arg_106_0.TARGET:setString(arg_106_0.DECO(arg_106_0.TEXT))
end
var_0_3[INC_NUMBER] = function(arg_107_0, arg_107_1)
	arg_107_0.TARGET:setString(arg_107_0.DECO(0))
end
var_0_0[APPEAR] = function(arg_108_0, arg_108_1, arg_108_2)
	arg_108_0.TO_X, arg_108_0.TO_Y = arg_108_2:getPosition()
	arg_108_0.FROM_X = arg_108_0.TO_X - to_n(arg_108_1[3])
	arg_108_0.FROM_Y = arg_108_0.TO_Y - to_n(arg_108_1[4])
	arg_108_0.TOTAL_TIME = arg_108_1[2]
	arg_108_0.DISAPPEAR = arg_108_1[5]
	arg_108_0.IGNORE_FADE = arg_108_1[6]
	
	if not arg_108_0.IGNORE_FADE then
		arg_108_2:setVisible(arg_108_1[5] == true)
	end
	
	if arg_108_0.DISAPPEAR then
		arg_108_0.TO_X, arg_108_0.FROM_X = arg_108_0.FROM_X, arg_108_0.TO_X
		arg_108_0.TO_Y, arg_108_0.FROM_Y = arg_108_0.FROM_Y, arg_108_0.TO_Y
	else
		arg_108_2:setPosition(arg_108_0.FROM_X, arg_108_0.FROM_Y)
	end
end
var_0_1[APPEAR] = function(arg_109_0, arg_109_1, arg_109_2, arg_109_3)
	local var_109_0 = (arg_109_0.elapsed_time + arg_109_2) / arg_109_0.TOTAL_TIME
	local var_109_1 = 1000
	
	if arg_109_0.DISAPPEAR then
		var_109_1 = 100
		var_109_0 = 1 - var_109_0
	end
	
	local var_109_2 = math.log(1 + var_109_0 * (var_109_1 - 1), var_109_1) / 1
	
	if arg_109_0.DISAPPEAR then
		var_109_2 = 1 - var_109_2
	end
	
	local var_109_3 = math.floor(var_109_2 * arg_109_0.TOTAL_TIME)
	
	if arg_109_3 then
		var_109_2 = 1
	end
	
	if not arg_109_0.IGNORE_FADE then
		if arg_109_0.elapsed_time == 0 then
			arg_109_0.TARGET:setVisible(true)
		end
		
		if arg_109_0.DISAPPEAR then
			arg_109_0.TARGET:setOpacity(var_109_0 * 255)
		else
			arg_109_0.TARGET:setOpacity(var_109_0 * 255)
		end
	end
	
	arg_109_0.TARGET:setPosition((arg_109_0.TO_X - arg_109_0.FROM_X) * var_109_2 + arg_109_0.FROM_X, (arg_109_0.TO_Y - arg_109_0.FROM_Y) * var_109_2 + arg_109_0.FROM_Y)
end
var_0_2[APPEAR] = function(arg_110_0, arg_110_1)
	if arg_110_0.DISAPPEAR then
		arg_110_0.TARGET:setOpacity(0)
	else
		arg_110_0.TARGET:setOpacity(255)
	end
	
	if arg_110_0.DISAPPEAR then
		arg_110_0.TARGET:setPosition(arg_110_0.FROM_X, arg_110_0.FROM_Y)
	else
		arg_110_0.TARGET:setPosition(arg_110_0.TO_X, arg_110_0.TO_Y)
	end
end
var_0_3[APPEAR] = function(arg_111_0, arg_111_1)
	arg_111_0.TARGET:setPosition(arg_111_0.FROM_X, arg_111_0.FROM_Y)
	arg_111_0.TARGET:setVisible(arg_111_0.DISAPPEAR)
end
var_0_1[DISAPPEAR] = var_0_1[APPEAR]
var_0_2[DISAPPEAR] = var_0_2[APPEAR]
var_0_3[DISAPPEAR] = var_0_3[APPEAR]
var_0_0[MOVE_TO] = function(arg_112_0, arg_112_1, arg_112_2)
	var_0_12(arg_112_0, "TO_X", arg_112_1[3])
	var_0_12(arg_112_0, "TO_Y", arg_112_1[4])
	
	arg_112_0.TOTAL_TIME = arg_112_1[2]
end
var_0_1[MOVE_TO] = function(arg_113_0, arg_113_1, arg_113_2)
	if not get_cocos_refid(arg_113_0.TARGET) then
		return 
	end
	
	if arg_113_0.elapsed_time == 0 then
		arg_113_0.FROM_X, arg_113_0.FROM_Y = arg_113_0.TARGET:getPosition()
	end
	
	local var_113_0 = (arg_113_0.elapsed_time + arg_113_2) / arg_113_0.TOTAL_TIME
	local var_113_1 = ((arg_113_0.TO_X or arg_113_0.FROM_X) - arg_113_0.FROM_X) * var_113_0 + arg_113_0.FROM_X
	
	if arg_113_0.TO_X and (arg_113_0.TO_Y == arg_113_0.FROM_Y or arg_113_0.TO_Y == nil) then
		arg_113_0.TARGET:setPositionX(math.floor((arg_113_0.TO_X - arg_113_0.FROM_X) * var_113_0 + arg_113_0.FROM_X))
	elseif arg_113_0.TO_Y and (arg_113_0.TO_X == arg_113_0.FROM_X or arg_113_0.TO_X == nil) then
		arg_113_0.TARGET:setPositionY((arg_113_0.TO_Y - arg_113_0.FROM_Y) * var_113_0 + arg_113_0.FROM_Y)
	elseif arg_113_0.TO_X and arg_113_0.TO_Y then
		arg_113_0.TARGET:setPosition(math.floor((arg_113_0.TO_X - arg_113_0.FROM_X) * var_113_0 + arg_113_0.FROM_X), (arg_113_0.TO_Y - arg_113_0.FROM_Y) * var_113_0 + arg_113_0.FROM_Y)
	end
end
var_0_2[MOVE_TO] = function(arg_114_0, arg_114_1)
	if arg_114_0.TO_X == nil then
		arg_114_0.TARGET:setPositionY(arg_114_0.TO_Y)
	elseif arg_114_0.TO_Y == nil then
		arg_114_0.TARGET:setPositionX(arg_114_0.TO_X)
	else
		arg_114_0.TARGET:setPosition(arg_114_0.TO_X, arg_114_0.TO_Y)
	end
	
	NotchManager:only_use_in_action_resetOriginPos(arg_114_0.TARGET, arg_114_0.TO_X)
end
var_0_3[MOVE_TO] = function(arg_115_0, arg_115_1)
end
var_0_0[MOVE_BY] = function(arg_116_0, arg_116_1, arg_116_2)
	arg_116_0.FROM_X, arg_116_0.FROM_Y = arg_116_2:getPosition()
	arg_116_0.TO_X = arg_116_0.FROM_X + (arg_116_1[3] or 0)
	arg_116_0.TO_Y = arg_116_0.FROM_Y + (arg_116_1[4] or 0)
	arg_116_0.TOTAL_TIME = arg_116_1[2]
end
var_0_1[MOVE_BY] = var_0_1[MOVE_TO]
var_0_2[MOVE_BY] = var_0_2[MOVE_TO]
var_0_3[MOVE_BY] = var_0_3[MOVE_TO]
var_0_0[MOVE_BY_SMOOTH] = var_0_0[MOVE_BY]
var_0_1[MOVE_BY_SMOOTH] = function(arg_117_0, arg_117_1, arg_117_2)
	if not get_cocos_refid(arg_117_0.TARGET) then
		return 
	end
	
	if arg_117_0.elapsed_time == 0 then
		arg_117_0.FROM_X, arg_117_0.FROM_Y = arg_117_0.TARGET:getPosition()
	end
	
	local var_117_0 = (arg_117_0.elapsed_time + arg_117_2) / arg_117_0.TOTAL_TIME
	
	if arg_117_0.TO_X and (arg_117_0.TO_Y == arg_117_0.FROM_Y or arg_117_0.TO_Y == nil) then
		arg_117_0.TARGET:setPositionX((arg_117_0.TO_X - arg_117_0.FROM_X) * var_117_0 + arg_117_0.FROM_X)
	elseif arg_117_0.TO_Y and (arg_117_0.TO_X == arg_117_0.FROM_X or arg_117_0.TO_X == nil) then
		arg_117_0.TARGET:setPositionY((arg_117_0.TO_Y - arg_117_0.FROM_Y) * var_117_0 + arg_117_0.FROM_Y)
	elseif arg_117_0.TO_X and arg_117_0.TO_Y then
		arg_117_0.TARGET:setPosition((arg_117_0.TO_X - arg_117_0.FROM_X) * var_117_0 + arg_117_0.FROM_X, (arg_117_0.TO_Y - arg_117_0.FROM_Y) * var_117_0 + arg_117_0.FROM_Y)
	end
end
var_0_2[MOVE_BY_SMOOTH] = var_0_2[MOVE_TO]
var_0_3[MOVE_BY_SMOOTH] = var_0_3[MOVE_TO]
var_0_0[MOVE] = function(arg_118_0, arg_118_1, arg_118_2)
	arg_118_0.FROM_X = arg_118_1[3]
	arg_118_0.FROM_Y = arg_118_1[4]
	arg_118_0.TO_X = arg_118_1[5]
	arg_118_0.TO_Y = arg_118_1[6]
	arg_118_0.TOTAL_TIME = arg_118_1[2]
	
	if arg_118_1[7] then
		arg_118_2:setPosition(arg_118_0.FROM_X, arg_118_0.FROM_Y)
	end
end
var_0_1[MOVE] = var_0_1[MOVE_TO]
var_0_2[MOVE] = var_0_2[MOVE_TO]
var_0_3[MOVE] = var_0_3[MOVE_TO]
var_0_0[JUMP_TO] = function(arg_119_0, arg_119_1, arg_119_2)
	var_0_12(arg_119_0, "TO_X", arg_119_1[3])
	var_0_12(arg_119_0, "TO_Y", arg_119_1[4])
	
	arg_119_0.POWER = arg_119_1[5] or 50
	arg_119_0.TOTAL_TIME = arg_119_1[2]
end
var_0_1[JUMP_TO] = function(arg_120_0, arg_120_1, arg_120_2)
	if arg_120_0.elapsed_time == 0 then
		arg_120_0.FROM_X, arg_120_0.FROM_Y = arg_120_0.TARGET:getPosition()
	end
	
	local var_120_0 = (arg_120_0.elapsed_time + arg_120_2) / arg_120_0.TOTAL_TIME
	local var_120_1 = math.log(1 + 4 * var_120_0, 5) / 1
	local var_120_2 = (arg_120_0.TO_X - arg_120_0.FROM_X) * var_120_1 + arg_120_0.FROM_X
	local var_120_3 = (arg_120_0.TO_Y - arg_120_0.FROM_Y) * var_120_0 + arg_120_0.FROM_Y + math.sin(var_120_1 * math.pi) * arg_120_0.POWER
	
	arg_120_0.TARGET:setPosition(var_120_2, var_120_3)
end
var_0_2[JUMP_TO] = var_0_2[MOVE_TO]
var_0_3[JUMP_TO] = var_0_3[MOVE_TO]
var_0_0[WARP_TO] = function(arg_121_0, arg_121_1, arg_121_2)
	var_0_12(arg_121_0, "TO_X", arg_121_1[3])
	var_0_12(arg_121_0, "TO_Y", arg_121_1[4])
	
	arg_121_0.TOTAL_TIME = arg_121_1[2]
end
var_0_1[WARP_TO] = function(arg_122_0, arg_122_1, arg_122_2)
end
var_0_2[WARP_TO] = function(arg_123_0, arg_123_1)
	if arg_123_0.TO_X and arg_123_0.TO_Y then
		arg_123_0.TARGET:setPosition(arg_123_0.TO_X, arg_123_0.TO_Y)
	end
end
var_0_3[WARP_TO] = var_0_3[MOVE_TO]
var_0_0[JUMP_BY] = function(arg_124_0, arg_124_1, arg_124_2)
	arg_124_0.FROM_X, arg_124_0.FROM_Y = arg_124_2:getPosition()
	arg_124_0.TO_X = arg_124_0.FROM_X + arg_124_1[3]
	arg_124_0.TO_Y = arg_124_0.FROM_Y + arg_124_1[4]
	arg_124_0.POWER = arg_124_1[5] or 50
	arg_124_0.TOTAL_TIME = arg_124_1[2]
end
var_0_1[JUMP_BY] = var_0_1[JUMP_TO]
var_0_2[JUMP_BY] = var_0_2[JUMP_TO]
var_0_3[JUMP_BY] = var_0_3[JUMP_TO]
var_0_0[SCALE] = function(arg_125_0, arg_125_1, arg_125_2)
	arg_125_0.FROM_SCALE = arg_125_1[3]
	arg_125_0.TO_SCALE = arg_125_1[4]
	arg_125_0.TOTAL_TIME = arg_125_1[2]
end
var_0_1[SCALE] = function(arg_126_0, arg_126_1, arg_126_2)
	local var_126_0 = (arg_126_0.elapsed_time + arg_126_2) / arg_126_0.TOTAL_TIME
	local var_126_1 = (arg_126_0.TO_SCALE - arg_126_0.FROM_SCALE) * var_126_0 + arg_126_0.FROM_SCALE
	
	arg_126_0.TARGET:setScale(var_126_1)
end
var_0_2[SCALE] = function(arg_127_0, arg_127_1)
	arg_127_0.TARGET:setScale(arg_127_0.TO_SCALE)
end
var_0_3[SCALE] = function(arg_128_0, arg_128_1)
	arg_128_0.TARGET:setScale(arg_128_0.FROM_SCALE)
end
var_0_0[SCALE_TO] = function(arg_129_0, arg_129_1, arg_129_2)
	arg_129_0.TO_SCALE = arg_129_1[3]
	arg_129_0.TOTAL_TIME = arg_129_1[2]
end
var_0_1[SCALE_TO] = function(arg_130_0, arg_130_1, arg_130_2)
	if not arg_130_0.FROM_SCALE then
		arg_130_0.FROM_SCALE = arg_130_0.TARGET:getScaleX()
	end
	
	local var_130_0 = (arg_130_0.elapsed_time + arg_130_2) / arg_130_0.TOTAL_TIME
	local var_130_1 = (arg_130_0.TO_SCALE - arg_130_0.FROM_SCALE) * var_130_0 + arg_130_0.FROM_SCALE
	
	arg_130_0.TARGET:setScale(var_130_1)
end
var_0_2[SCALE_TO] = function(arg_131_0, arg_131_1)
	arg_131_0.TARGET:setScale(arg_131_0.TO_SCALE)
end
var_0_3[SCALE_TO] = function(arg_132_0, arg_132_1)
end
var_0_0[SCALE_TO_X] = function(arg_133_0, arg_133_1, arg_133_2)
	arg_133_0.TO_SCALE = arg_133_1[3]
	arg_133_0.TOTAL_TIME = arg_133_1[2]
end
var_0_1[SCALE_TO_X] = function(arg_134_0, arg_134_1, arg_134_2)
	if not arg_134_0.FROM_SCALE then
		arg_134_0.FROM_SCALE = arg_134_0.TARGET:getScaleX()
	end
	
	local var_134_0 = (arg_134_0.elapsed_time + arg_134_2) / arg_134_0.TOTAL_TIME
	local var_134_1 = (arg_134_0.TO_SCALE - arg_134_0.FROM_SCALE) * var_134_0 + arg_134_0.FROM_SCALE
	
	arg_134_0.TARGET:setScaleX(var_134_1)
end
var_0_2[SCALE_TO_X] = function(arg_135_0, arg_135_1)
	arg_135_0.TARGET:setScaleX(arg_135_0.TO_SCALE)
end
var_0_3[SCALE_TO_X] = function(arg_136_0, arg_136_1)
end
var_0_0[SCALE_TO_Y] = function(arg_137_0, arg_137_1, arg_137_2)
	arg_137_0.TO_SCALE = arg_137_1[3]
	arg_137_0.TOTAL_TIME = arg_137_1[2]
end
var_0_1[SCALE_TO_Y] = function(arg_138_0, arg_138_1, arg_138_2)
	if not arg_138_0.FROM_SCALE then
		arg_138_0.FROM_SCALE = arg_138_0.TARGET:getScaleY()
	end
	
	local var_138_0 = (arg_138_0.elapsed_time + arg_138_2) / arg_138_0.TOTAL_TIME
	local var_138_1 = (arg_138_0.TO_SCALE - arg_138_0.FROM_SCALE) * var_138_0 + arg_138_0.FROM_SCALE
	
	arg_138_0.TARGET:setScaleY(var_138_1)
end
var_0_2[SCALE_TO_Y] = function(arg_139_0, arg_139_1)
	arg_139_0.TARGET:setScaleY(arg_139_0.TO_SCALE)
end
var_0_3[SCALE_TO_Y] = function(arg_140_0, arg_140_1)
end
var_0_0[SCALEX] = var_0_0[SCALE]
var_0_1[SCALEX] = function(arg_141_0, arg_141_1, arg_141_2)
	local var_141_0 = (arg_141_0.elapsed_time + arg_141_2) / arg_141_0.TOTAL_TIME
	local var_141_1 = (arg_141_0.TO_SCALE - arg_141_0.FROM_SCALE) * var_141_0 + arg_141_0.FROM_SCALE
	
	arg_141_0.TARGET:setScaleX(var_141_1)
end
var_0_2[SCALEX] = function(arg_142_0, arg_142_1)
	arg_142_0.TARGET:setScaleX(arg_142_0.TO_SCALE)
end
var_0_3[SCALEX] = function(arg_143_0, arg_143_1)
end
var_0_0[SCALEY] = var_0_0[SCALE]
var_0_1[SCALEY] = function(arg_144_0, arg_144_1, arg_144_2)
	local var_144_0 = (arg_144_0.elapsed_time + arg_144_2) / arg_144_0.TOTAL_TIME
	local var_144_1 = (arg_144_0.TO_SCALE - arg_144_0.FROM_SCALE) * var_144_0 + arg_144_0.FROM_SCALE
	
	arg_144_0.TARGET:setScaleY(var_144_1)
end
var_0_2[SCALEY] = function(arg_145_0, arg_145_1)
	arg_145_0.TARGET:setScaleY(arg_145_0.TO_SCALE)
end
var_0_3[SCALEY] = function(arg_146_0, arg_146_1)
end
var_0_0[CONTENT_SIZE] = function(arg_147_0, arg_147_1, arg_147_2)
	arg_147_0.FROM_CONTENT_SIZE = arg_147_2:getContentSize()
	arg_147_0.TO_WIDTH = arg_147_1[3]
	arg_147_0.TO_HEIGHT = arg_147_1[4]
	arg_147_0.TOTAL_TIME = arg_147_1[2]
end
var_0_1[CONTENT_SIZE] = function(arg_148_0, arg_148_1, arg_148_2)
	local var_148_0 = (arg_148_0.elapsed_time + arg_148_2) / arg_148_0.TOTAL_TIME
	local var_148_1 = (arg_148_0.TO_WIDTH - arg_148_0.FROM_CONTENT_SIZE.width) * var_148_0 + arg_148_0.FROM_CONTENT_SIZE.width
	local var_148_2 = (arg_148_0.TO_HEIGHT - arg_148_0.FROM_CONTENT_SIZE.height) * var_148_0 + arg_148_0.FROM_CONTENT_SIZE.height
	
	arg_148_0.TARGET:setContentSize(var_148_1, var_148_2)
end
var_0_2[CONTENT_SIZE] = function(arg_149_0, arg_149_1)
	arg_149_0.TARGET:setContentSize(arg_149_0.TO_WIDTH, arg_149_0.TO_HEIGHT)
end
var_0_3[CONTENT_SIZE] = function(arg_150_0, arg_150_1)
	arg_150_0.TARGET:setContentSize(arg_150_0.FROM_CONTENT_SIZE)
end
var_0_0[RESET_SPRITE] = function(arg_151_0, arg_151_1, arg_151_2)
	arg_151_0.SPRITE = arg_151_1[3]
	arg_151_0.TOTAL_TIME = arg_151_1[2]
	arg_151_0.SCALE = arg_151_1[4]
end
var_0_1[RESET_SPRITE] = function(arg_152_0, arg_152_1, arg_152_2)
	if not arg_152_0.flag then
		SpriteCache:resetSprite(arg_152_0.TARGET, arg_152_0.SPRITE)
		
		if arg_152_0.SCALE then
			arg_152_0.TARGET:setScale(arg_152_0.SCALE)
		end
		
		arg_152_0.flag = true
	end
end
var_0_0[CALL] = function(arg_153_0, arg_153_1, arg_153_2)
	arg_153_0.FUNCTION = arg_153_1[2]
	arg_153_0.ARGS = arg_153_1[3]
	arg_153_0.TOTAL_TIME = 0
	
	if not arg_153_0.FUNCTION then
		error("action.FUNCTION is nil value")
	end
end
var_0_1[CALL] = function(arg_154_0, arg_154_1, arg_154_2)
	if not arg_154_0.run_flag then
		arg_154_0.FUNCTION(argument_unpack(arg_154_0.ARGS))
		
		arg_154_0.run_flag = true
	end
end
var_0_2[CALL] = var_0_1[CALL]
var_0_3[CALL] = function(arg_155_0, arg_155_1)
	arg_155_0.run_flag = nil
end
var_0_0[USER_ACT] = function(arg_156_0, arg_156_1, arg_156_2)
	arg_156_0.INTERFACE = arg_156_1[2]
	arg_156_0.ARGS = arg_156_1[3]
	
	if arg_156_0.INTERFACE.Init then
		arg_156_0.INTERFACE:Init(arg_156_0, argument_unpack(arg_156_0.ARGS))
	end
	
	arg_156_0.UPDATE_COUNT = 0
	arg_156_0.TOTAL_TIME = arg_156_0.INTERFACE.TOTAL_TIME or 0
end
var_0_1[USER_ACT] = function(arg_157_0, arg_157_1, arg_157_2)
	if arg_157_0.UPDATE_COUNT == 0 and arg_157_0.INTERFACE.Start then
		arg_157_0.INTERFACE:Start(arg_157_0, arg_157_1)
	end
	
	if arg_157_0.TOTAL_TIME > 0 or arg_157_0.UPDATE_COUNT == 0 then
		arg_157_0.INTERFACE:Update(arg_157_0, arg_157_2)
		
		arg_157_0.UPDATE_COUNT = arg_157_0.UPDATE_COUNT + 1
	end
end
var_0_2[USER_ACT] = function(arg_158_0, arg_158_1)
	if arg_158_0.UPDATE_COUNT == 0 then
		arg_158_0.INTERFACE:Update(arg_158_0)
	end
	
	if arg_158_0.INTERFACE.Finish then
		arg_158_0.INTERFACE:Finish(arg_158_0)
	end
end
var_0_3[USER_ACT] = function(arg_159_0, arg_159_1)
	if arg_159_0.INTERFACE.Reset then
		arg_159_0.INTERFACE:Reset(arg_159_0)
	end
	
	arg_159_0.UPDATE_COUNT = 0
end
var_0_0[LINEAR_CALL] = function(arg_160_0, arg_160_1, arg_160_2)
	arg_160_0.TABLE = arg_160_1[3]
	arg_160_0.FUNC_NAME = arg_160_1[4]
	arg_160_0.FROM_LINEAR_CALL = arg_160_1[5]
	arg_160_0.TO_LINEAR_CALL = arg_160_1[6]
	arg_160_0.TOTAL_TIME = arg_160_1[2]
end
var_0_1[LINEAR_CALL] = function(arg_161_0, arg_161_1, arg_161_2)
	local var_161_0
	
	if arg_161_0.TO_LINEAR_CALL then
		local var_161_1 = (arg_161_0.elapsed_time + arg_161_2) / arg_161_0.TOTAL_TIME
		
		var_161_0 = (arg_161_0.TO_LINEAR_CALL - arg_161_0.FROM_LINEAR_CALL) * var_161_1 + arg_161_0.FROM_LINEAR_CALL
	else
		var_161_0 = arg_161_0.FROM_LINEAR_CALL
	end
	
	if type(arg_161_0.FUNC_NAME) == "string" then
		arg_161_0.TABLE[arg_161_0.FUNC_NAME](arg_161_0.TABLE, var_161_0)
	else
		arg_161_0.FUNC_NAME(arg_161_0.TABLE, var_161_0)
	end
end
var_0_2[LINEAR_CALL] = function(arg_162_0, arg_162_1)
	if arg_162_0.TO_LINEAR_CALL then
		if type(arg_162_0.FUNC_NAME) == "string" then
			arg_162_0.TABLE[arg_162_0.FUNC_NAME](arg_162_0.TABLE, arg_162_0.TO_LINEAR_CALL)
		else
			arg_162_0.FUNC_NAME(arg_162_0.TABLE, arg_162_0.TO_LINEAR_CALL)
		end
	end
end
var_0_3[LINEAR_CALL] = function(arg_163_0, arg_163_1)
	if arg_163_0.TO_LINEAR_CALL and type(arg_163_0.FUNC_NAME) == "string" then
		arg_163_0.TABLE[arg_163_0.FUNC_NAME](arg_163_0.TABLE, arg_163_0.FROM_LINEAR_CALL)
	end
	
	if false then
	end
end
var_0_0[VAR] = function(arg_164_0, arg_164_1, arg_164_2)
	arg_164_0.TABLE = arg_164_1[3]
	arg_164_0.NAME = arg_164_1[4]
	arg_164_0.FROM_VAR = arg_164_1[5]
	arg_164_0.TO_VAR = arg_164_1[6]
	arg_164_0.TOTAL_TIME = arg_164_1[2]
end
var_0_1[VAR] = function(arg_165_0, arg_165_1, arg_165_2)
	local var_165_0 = (arg_165_0.elapsed_time + arg_165_2) / arg_165_0.TOTAL_TIME
	local var_165_1 = (arg_165_0.TO_VAR - arg_165_0.FROM_VAR) * var_165_0 + arg_165_0.FROM_VAR
	
	arg_165_0.TABLE[arg_165_0.NAME] = var_165_1
end
var_0_2[VAR] = function(arg_166_0, arg_166_1)
	arg_166_0.TABLE[arg_166_0.NAME] = arg_166_0.TO_VAR
end
var_0_3[VAR] = function(arg_167_0, arg_167_1)
	arg_167_0.TABLE[arg_167_0.NAME] = arg_167_0.FROM_VAR
end
var_0_0[VAR_TO] = function(arg_168_0, arg_168_1, arg_168_2)
	arg_168_0.TABLE = arg_168_1[3]
	arg_168_0.NAME = arg_168_1[4]
	
	var_0_12(arg_168_0, "TO_VAR", arg_168_1[5])
	
	arg_168_0.TOTAL_TIME = arg_168_1[2]
end
var_0_1[VAR_TO] = function(arg_169_0, arg_169_1, arg_169_2)
	if arg_169_0.elapsed_time == 0 then
		arg_169_0.FROM_VAR = arg_169_0.TABLE[arg_169_0.NAME]
	end
	
	local var_169_0 = (arg_169_0.elapsed_time + arg_169_2) / arg_169_0.TOTAL_TIME
	local var_169_1 = (arg_169_0.TO_VAR - arg_169_0.FROM_VAR) * var_169_0 + arg_169_0.FROM_VAR
	
	arg_169_0.TABLE[arg_169_0.NAME] = var_169_1
end
var_0_2[VAR_TO] = function(arg_170_0, arg_170_1)
	if not arg_170_0.TO_VAR and arg_170_0.getTO_VAR then
		arg_170_0.TO_VAR = arg_170_0.getTO_VAR()
	end
	
	arg_170_0.TABLE[arg_170_0.NAME] = arg_170_0.TO_VAR
end
var_0_3[VAR_TO] = var_0_3[VAR]
var_0_0[ANCHOR] = function(arg_171_0, arg_171_1, arg_171_2)
	arg_171_0.FROM_ANCHOR = arg_171_1[3]
	arg_171_0.TO_ANCHOR = arg_171_1[4]
	arg_171_0.TOTAL_TIME = arg_171_1[2]
	
	if arg_171_0.TO_ANCHOR == nil then
		arg_171_0.TO_ANCHOR = arg_171_0.FROM_ANCHOR
		arg_171_0.FROM_ANCHOR = arg_171_2:getAnchorPoint()
	end
end
var_0_1[ANCHOR] = function(arg_172_0, arg_172_1, arg_172_2)
	local var_172_0 = (arg_172_0.elapsed_time + arg_172_2) / arg_172_0.TOTAL_TIME
	local var_172_1 = cc.p(arg_172_0.FROM_ANCHOR.x + (arg_172_0.TO_ANCHOR.x - arg_172_0.FROM_ANCHOR.x) * var_172_0, arg_172_0.FROM_ANCHOR.y + (arg_172_0.TO_ANCHOR.y - arg_172_0.FROM_ANCHOR.y) * var_172_0)
	
	arg_172_0.TARGET:setAnchorPoint(var_172_1)
end
var_0_3[ANCHOR] = function(arg_173_0, arg_173_1)
	arg_173_0.TARGET:setAnchorPoint(arg_173_0.FROM_ANCHOR)
end
var_0_2[ANCHOR] = function(arg_174_0, arg_174_1)
	arg_174_0.TARGET:setAnchorPoint(arg_174_0.TO_ANCHOR)
end
var_0_0[ANCHOR_BY] = function(arg_175_0, arg_175_1, arg_175_2)
	arg_175_0.FROM_ANCHOR = arg_175_2:getAnchorPoint()
	
	local var_175_0 = arg_175_2:getAnchorPoint()
	
	if type(arg_175_1[3]) == "table" then
		var_175_0.x = var_175_0.x + arg_175_1[3].x
		var_175_0.y = var_175_0.y + arg_175_1[3].y
	else
		var_175_0.x = var_175_0.x + arg_175_1[3]
		var_175_0.y = var_175_0.y + arg_175_1[4]
	end
	
	arg_175_0.TO_ANCHOR = var_175_0
	arg_175_0.TOTAL_TIME = arg_175_1[2]
end
var_0_1[ANCHOR_BY] = var_0_1[ANCHOR]
var_0_3[ANCHOR_BY] = var_0_3[ANCHOR]
var_0_2[ANCHOR_BY] = var_0_2[ANCHOR]
var_0_0[ROTATE] = function(arg_176_0, arg_176_1, arg_176_2)
	arg_176_0.t = arg_176_1
	arg_176_0.FROM_ROTATE = arg_176_1[3]
	arg_176_0.TO_ROTATE = arg_176_1[4]
	arg_176_0.TOTAL_TIME = arg_176_1[2]
end
var_0_1[ROTATE] = function(arg_177_0, arg_177_1, arg_177_2)
	local var_177_0 = (arg_177_0.elapsed_time + arg_177_2) / arg_177_0.TOTAL_TIME * (arg_177_0.TO_ROTATE - arg_177_0.FROM_ROTATE) + arg_177_0.FROM_ROTATE
	
	arg_177_0.TARGET:setRotation(var_177_0)
end
var_0_2[ROTATE] = function(arg_178_0, arg_178_1)
end
var_0_3[ROTATE] = function(arg_179_0, arg_179_1)
end
var_0_0[OPACITY] = function(arg_180_0, arg_180_1, arg_180_2)
	arg_180_0.t = arg_180_1
	arg_180_0.FROM_OPACITY = arg_180_1[3]
	arg_180_0.TO_OPACITY = arg_180_1[4]
	arg_180_0.TOTAL_TIME = arg_180_1[2]
end
var_0_1[OPACITY] = function(arg_181_0, arg_181_1, arg_181_2)
	local var_181_0 = (arg_181_0.elapsed_time + arg_181_2) / arg_181_0.TOTAL_TIME * (arg_181_0.TO_OPACITY - arg_181_0.FROM_OPACITY) + arg_181_0.FROM_OPACITY
	
	arg_181_0.TARGET:setOpacity(var_181_0 * 255)
end
var_0_2[OPACITY] = function(arg_182_0, arg_182_1)
	arg_182_0.TARGET:setOpacity(arg_182_0.TO_OPACITY * 255)
end
var_0_3[OPACITY] = function(arg_183_0, arg_183_1)
	arg_183_0.TARGET:setOpacity(arg_183_0.FROM_OPACITY * 255)
end
var_0_0[PROGRESS] = function(arg_184_0, arg_184_1, arg_184_2)
	arg_184_0.t = arg_184_1
	arg_184_0.FROM_PERCENT = arg_184_1[3]
	arg_184_0.TO_PERCENT = arg_184_1[4]
	arg_184_0.TOTAL_TIME = arg_184_1[2]
end
var_0_1[PROGRESS] = function(arg_185_0, arg_185_1, arg_185_2)
	local var_185_0 = (arg_185_0.elapsed_time + arg_185_2) / arg_185_0.TOTAL_TIME * (arg_185_0.TO_PERCENT - arg_185_0.FROM_PERCENT) + arg_185_0.FROM_PERCENT
	
	arg_185_0.TARGET:setPercent(var_185_0 * 100)
end
var_0_2[PROGRESS] = function(arg_186_0, arg_186_1)
	arg_186_0.TARGET:setPercent(arg_186_0.TO_PERCENT * 100)
end
var_0_3[PROGRESS] = function(arg_187_0, arg_187_1)
	arg_187_0.TARGET:setPercent(arg_187_0.FROM_PERCENT * 100)
end
var_0_0[PERCENTAGE] = var_0_0[PROGRESS]
var_0_1[PERCENTAGE] = function(arg_188_0, arg_188_1, arg_188_2)
	local var_188_0 = (arg_188_0.elapsed_time + arg_188_2) / arg_188_0.TOTAL_TIME * (arg_188_0.TO_PERCENT - arg_188_0.FROM_PERCENT) + arg_188_0.FROM_PERCENT
	
	arg_188_0.TARGET:setPercentage(var_188_0)
end
var_0_2[PERCENTAGE] = function(arg_189_0, arg_189_1)
	arg_189_0.TARGET:setPercentage(arg_189_0.TO_PERCENT)
end
var_0_3[PERCENTAGE] = function(arg_190_0, arg_190_1)
	arg_190_0.TARGET:setPercentage(arg_190_0.FROM_PERCENT)
end
var_0_0[LAYER_OPACITY] = function(arg_191_0, arg_191_1, arg_191_2)
	arg_191_0.t = arg_191_1
	arg_191_0.FROM_OPACITY = arg_191_1[3]
	arg_191_0.TO_OPACITY = arg_191_1[4]
	arg_191_0.TOTAL_TIME = arg_191_1[2]
end

function SET_LAYER_OPACITY(arg_192_0, arg_192_1)
	local var_192_0 = arg_192_0:getChildren()
	
	for iter_192_0 = 1, #var_192_0 do
		if tolua:type(var_192_0[iter_192_0]) == "cc.Layer" then
			SET_LAYER_OPACITY(var_192_0[iter_192_0], arg_192_1)
		else
			var_192_0[iter_192_0]:setOpacity(arg_192_1)
		end
	end
end

var_0_1[LAYER_OPACITY] = function(arg_193_0, arg_193_1, arg_193_2)
	local var_193_0 = (arg_193_0.elapsed_time + arg_193_2) / arg_193_0.TOTAL_TIME * (arg_193_0.TO_OPACITY - arg_193_0.FROM_OPACITY) + arg_193_0.FROM_OPACITY
	
	SET_LAYER_OPACITY(arg_193_0.TARGET, var_193_0 * 255)
end
var_0_2[LAYER_OPACITY] = function(arg_194_0, arg_194_1)
end
var_0_3[LAYER_OPACITY] = function(arg_195_0, arg_195_1)
end
var_0_0[COLOR] = function(arg_196_0, arg_196_1, arg_196_2)
	arg_196_0.t = arg_196_1
	
	if arg_196_1[5] == nil then
		arg_196_0.TO_COLOR = arg_196_1[3]
		arg_196_0.TO_TOP_COLOR = arg_196_1[4]
	else
		arg_196_0.TO_COLOR = cc.c3b(arg_196_1[3], arg_196_1[4], arg_196_1[5])
		
		if arg_196_1[6] ~= nil then
			arg_196_0.TO_TOP_COLOR = cc.c3b(arg_196_1[6], arg_196_1[7], arg_196_1[8])
		end
	end
	
	arg_196_0.TOTAL_TIME = arg_196_1[2]
end
var_0_1[COLOR] = function(arg_197_0, arg_197_1, arg_197_2)
	if arg_197_0.elapsed_time == 0 then
		arg_197_0.FROM_COLOR = arg_197_0.TARGET:getColor()
	end
	
	local var_197_0 = (arg_197_0.elapsed_time + arg_197_2) / arg_197_0.TOTAL_TIME
	local var_197_1 = var_197_0 * (arg_197_0.TO_COLOR.r - arg_197_0.FROM_COLOR.r) + arg_197_0.FROM_COLOR.r
	local var_197_2 = var_197_0 * (arg_197_0.TO_COLOR.g - arg_197_0.FROM_COLOR.g) + arg_197_0.FROM_COLOR.g
	local var_197_3 = var_197_0 * (arg_197_0.TO_COLOR.b - arg_197_0.FROM_COLOR.b) + arg_197_0.FROM_COLOR.b
	local var_197_4
	
	if arg_197_0.TO_TOP_COLOR ~= nil then
		local var_197_5 = var_197_0 * (arg_197_0.TO_TOP_COLOR.r - arg_197_0.FROM_COLOR.r) + arg_197_0.FROM_COLOR.r
		local var_197_6 = var_197_0 * (arg_197_0.TO_TOP_COLOR.g - arg_197_0.FROM_COLOR.g) + arg_197_0.FROM_COLOR.g
		local var_197_7 = var_197_0 * (arg_197_0.TO_TOP_COLOR.b - arg_197_0.FROM_COLOR.b) + arg_197_0.FROM_COLOR.b
		
		var_197_4 = cc.c3b(var_197_5, var_197_6, var_197_7)
	end
	
	if var_197_4 ~= nil then
		arg_197_0.TARGET:setColor(cc.c3b(var_197_1, var_197_2, var_197_3), var_197_4)
	else
		arg_197_0.TARGET:setColor(cc.c3b(var_197_1, var_197_2, var_197_3))
	end
end
var_0_2[COLOR] = function(arg_198_0, arg_198_1)
	if arg_198_0.TO_TOP_COLOR ~= nil then
		arg_198_0.TARGET:setColor(arg_198_0.TO_COLOR, arg_198_0.TO_TOP_COLOR)
	else
		arg_198_0.TARGET:setColor(arg_198_0.TO_COLOR)
	end
end
var_0_3[COLOR] = function(arg_199_0, arg_199_1)
	arg_199_0.TARGET:setColor(arg_199_0.FROM_COLOR)
end
var_0_0[FIX_MODEL_FROM_COLOR] = function(arg_200_0, arg_200_1, arg_200_2)
	arg_200_0.t = arg_200_1
	
	if arg_200_1[5] == nil then
		arg_200_0.TO_COLOR = arg_200_1[3]
		arg_200_0.TO_TOP_COLOR = arg_200_1[4]
	else
		arg_200_0.TO_COLOR = cc.c3b(arg_200_1[3], arg_200_1[4], arg_200_1[5])
		
		if arg_200_1[6] ~= nil then
			arg_200_0.TO_TOP_COLOR = cc.c3b(arg_200_1[6], arg_200_1[7], arg_200_1[8])
		end
	end
	
	arg_200_0.TOTAL_TIME = arg_200_1[2]
end
var_0_1[FIX_MODEL_FROM_COLOR] = function(arg_201_0, arg_201_1, arg_201_2)
	if arg_201_0.elapsed_time == 0 then
		arg_201_0.FROM_COLOR = arg_201_0.TARGET:getColor()
		
		if arg_201_0.TARGET.body then
			arg_201_0.FROM_COLOR = arg_201_0.TARGET.body:getColor()
		end
	end
	
	local var_201_0 = (arg_201_0.elapsed_time + arg_201_2) / arg_201_0.TOTAL_TIME
	local var_201_1 = var_201_0 * (arg_201_0.TO_COLOR.r - arg_201_0.FROM_COLOR.r) + arg_201_0.FROM_COLOR.r
	local var_201_2 = var_201_0 * (arg_201_0.TO_COLOR.g - arg_201_0.FROM_COLOR.g) + arg_201_0.FROM_COLOR.g
	local var_201_3 = var_201_0 * (arg_201_0.TO_COLOR.b - arg_201_0.FROM_COLOR.b) + arg_201_0.FROM_COLOR.b
	local var_201_4
	
	if arg_201_0.TO_TOP_COLOR ~= nil then
		local var_201_5 = var_201_0 * (arg_201_0.TO_TOP_COLOR.r - arg_201_0.FROM_COLOR.r) + arg_201_0.FROM_COLOR.r
		local var_201_6 = var_201_0 * (arg_201_0.TO_TOP_COLOR.g - arg_201_0.FROM_COLOR.g) + arg_201_0.FROM_COLOR.g
		local var_201_7 = var_201_0 * (arg_201_0.TO_TOP_COLOR.b - arg_201_0.FROM_COLOR.b) + arg_201_0.FROM_COLOR.b
		
		var_201_4 = cc.c3b(var_201_5, var_201_6, var_201_7)
	end
	
	if var_201_4 ~= nil then
		arg_201_0.TARGET:setColor(cc.c3b(var_201_1, var_201_2, var_201_3), var_201_4)
	else
		arg_201_0.TARGET:setColor(cc.c3b(var_201_1, var_201_2, var_201_3))
	end
end
var_0_2[FIX_MODEL_FROM_COLOR] = function(arg_202_0, arg_202_1)
	if arg_202_0.TO_TOP_COLOR ~= nil then
		arg_202_0.TARGET:setColor(arg_202_0.TO_COLOR, arg_202_0.TO_TOP_COLOR)
	else
		arg_202_0.TARGET:setColor(arg_202_0.TO_COLOR)
	end
end
var_0_3[FIX_MODEL_FROM_COLOR] = function(arg_203_0, arg_203_1)
	arg_203_0.TARGET:setColor(arg_203_0.FROM_COLOR)
end
var_0_0[SPRITE] = function(arg_204_0, arg_204_1, arg_204_2)
	arg_204_0.sprite = arg_204_1[2]
	arg_204_0.TOTAL_TIME = 0
end
var_0_1[SPRITE] = function(arg_205_0, arg_205_1, arg_205_2)
	arg_205_0.TARGET:setSpriteName(arg_205_0.sprite)
end
var_0_0[RUN] = function(arg_206_0, arg_206_1)
	arg_206_0.CMD = arg_206_1[2]
	arg_206_0.TOTAL_TIME = 0
end
var_0_2[RUN] = function(arg_207_0, arg_207_1)
	loadstring(arg_207_0.CMD)()
end
var_0_0[LOG] = function(arg_208_0, arg_208_1, arg_208_2)
	arg_208_0.CHILD = Action:create(arg_208_1[2], arg_208_2, arg_208_0.DEBUG)
	arg_208_0.V = arg_208_1[3] or 50
	arg_208_0.TOTAL_TIME = arg_208_0.CHILD.TOTAL_TIME
end
var_0_1[LOG] = function(arg_209_0, arg_209_1, arg_209_2, arg_209_3)
	local var_209_0 = (arg_209_0.elapsed_time + arg_209_2) / arg_209_0.TOTAL_TIME
	local var_209_1 = math.log(1 + var_209_0 * (arg_209_0.V - 1), arg_209_0.V) / 1
	local var_209_2 = math.floor(var_209_1 * arg_209_0.TOTAL_TIME) - arg_209_0.CHILD.elapsed_time
	
	if arg_209_3 then
		var_209_2 = arg_209_0.CHILD.TOTAL_TIME - arg_209_0.CHILD.elapsed_time
	end
	
	if var_209_2 >= 0 then
		arg_209_0.CHILD:Update(arg_209_1, var_209_2, arg_209_3)
	end
end
var_0_2[LOG] = function(arg_210_0, arg_210_1, arg_210_2)
	arg_210_0.CHILD:Finish(arg_210_1, arg_210_2)
end
var_0_3[LOG] = function(arg_211_0, arg_211_1, arg_211_2)
	arg_211_0.CHILD:Reset(arg_211_1, arg_211_2)
end
var_0_0[RLOG] = var_0_0[LOG]
var_0_1[RLOG] = function(arg_212_0, arg_212_1, arg_212_2, arg_212_3)
	local var_212_0 = 1 - (arg_212_0.elapsed_time + arg_212_2) / arg_212_0.TOTAL_TIME
	local var_212_1 = 1 - math.log(1 + var_212_0 * (arg_212_0.V - 1), arg_212_0.V) / 1
	local var_212_2 = math.floor(var_212_1 * arg_212_0.TOTAL_TIME) - arg_212_0.CHILD.elapsed_time
	
	if arg_212_3 then
		var_212_2 = arg_212_0.CHILD.TOTAL_TIME - arg_212_0.CHILD.elapsed_time
	end
	
	if var_212_2 >= 0 then
		arg_212_0.CHILD:Update(arg_212_1, var_212_2, arg_212_3)
	end
end
var_0_2[RLOG] = var_0_2[LOG]
var_0_3[RLOG] = var_0_3[LOG]
var_0_0[MAXRLOG] = function(arg_213_0, arg_213_1, arg_213_2)
	arg_213_0.CHILD = Action:create(arg_213_1[2], arg_213_2, arg_213_0.DEBUG)
	arg_213_0.V = arg_213_1[3] or 50
	arg_213_0.TOTAL_TIME = arg_213_0.CHILD.TOTAL_TIME
	arg_213_0.MAX = arg_213_1[4] or 50
end
var_0_1[MAXRLOG] = function(arg_214_0, arg_214_1, arg_214_2, arg_214_3, arg_214_4)
	local var_214_0 = 1 - (arg_214_0.elapsed_time + arg_214_2) / arg_214_0.TOTAL_TIME
	local var_214_1 = 1 - math.log(1 + var_214_0 * (arg_214_0.V - 1), arg_214_0.V) / 1
	local var_214_2 = math.floor(var_214_1 * arg_214_0.TOTAL_TIME) - arg_214_0.CHILD.elapsed_time
	
	if arg_214_4 then
		var_214_2 = arg_214_0.CHILD.TOTAL_TIME - arg_214_0.CHILD.elapsed_time
	end
	
	if var_214_2 >= arg_214_0.MAX then
		var_214_2 = arg_214_0.MAX
	end
	
	if var_214_2 >= 0 then
		arg_214_0.CHILD:Update(arg_214_1, var_214_2, arg_214_4)
	end
end
var_0_2[MAXRLOG] = var_0_2[LOG]
var_0_3[MAXRLOG] = var_0_3[LOG]
var_0_0[BEZIER] = function(arg_215_0, arg_215_1, arg_215_2)
	arg_215_0.CHILD = Action:create(arg_215_1[2], arg_215_2, arg_215_0.DEBUG)
	arg_215_0.TOTAL_TIME = arg_215_0.CHILD.TOTAL_TIME
	arg_215_0.CONTROL_POINTS = arg_215_1[3] or {}
	arg_215_0.CURVES = BezierCurves(table.unpack(arg_215_0.CONTROL_POINTS))
end
var_0_1[BEZIER] = function(arg_216_0, arg_216_1, arg_216_2, arg_216_3)
	local var_216_0 = (arg_216_0.elapsed_time + arg_216_2) / arg_216_0.TOTAL_TIME
	local var_216_1 = arg_216_0.CURVES:getPercentAtX(var_216_0)
	local var_216_2 = math.floor(var_216_1 * arg_216_0.TOTAL_TIME) - arg_216_0.CHILD.elapsed_time
	
	if arg_216_3 then
		var_216_2 = arg_216_0.CHILD.TOTAL_TIME - arg_216_0.CHILD.elapsed_time
	end
	
	if var_216_2 >= 0 then
		arg_216_0.CHILD:Update(arg_216_1, var_216_2, arg_216_3)
	end
end
var_0_2[BEZIER] = function(arg_217_0, arg_217_1, arg_217_2)
	arg_217_0.CHILD:Finish(arg_217_1, arg_217_2)
end
var_0_3[BEZIER] = function(arg_218_0, arg_218_1, arg_218_2)
	arg_218_0.CHILD:Reset(arg_218_1, arg_218_2)
end
var_0_0[SPAWN] = function(arg_219_0, arg_219_1, arg_219_2)
	arg_219_0.CHILDS = {}
	arg_219_0.TOTAL_TIME = 0
	
	local var_219_0 = arg_219_0.CHILDS
	
	for iter_219_0 = 2, #arg_219_1 do
		local var_219_1 = Action:create(arg_219_1[iter_219_0], arg_219_2, arg_219_0.DEBUG)
		
		table.insert(var_219_0, var_219_1)
		
		if var_219_1.TOTAL_TIME > arg_219_0.TOTAL_TIME then
			arg_219_0.TOTAL_TIME = var_219_1.TOTAL_TIME
		end
	end
end
var_0_1[SPAWN] = function(arg_220_0, arg_220_1, arg_220_2, arg_220_3)
	for iter_220_0 = 1, #arg_220_0.CHILDS do
		arg_220_0.CHILDS[iter_220_0]:Update(arg_220_1, arg_220_2, arg_220_3)
	end
end
var_0_2[SPAWN] = function(arg_221_0, arg_221_1, arg_221_2)
	for iter_221_0 = 1, #arg_221_0.CHILDS do
		arg_221_0.CHILDS[iter_221_0]:Finish(arg_221_1, arg_221_2)
	end
end
var_0_3[SPAWN] = function(arg_222_0, arg_222_1)
	for iter_222_0 = 1, #arg_222_0.CHILDS do
		arg_222_0.CHILDS[iter_222_0]:Reset(arg_222_1)
	end
end
var_0_0[REPEAT] = function(arg_223_0, arg_223_1, arg_223_2)
	local var_223_0 = Action:create(arg_223_1[3], arg_223_2, arg_223_0.DEBUG)
	
	arg_223_0.COUNT = arg_223_1[2]
	arg_223_0.TOTAL_TIME = var_223_0.TOTAL_TIME * arg_223_0.COUNT
	arg_223_0.CHILD = var_223_0
	arg_223_0.rest_count = arg_223_0.COUNT
end
var_0_1[REPEAT] = function(arg_224_0, arg_224_1, arg_224_2)
	local var_224_0 = arg_224_2
	local var_224_1 = arg_224_0.CHILD
	
	while var_224_0 > 0 and arg_224_0.rest_count > 0 do
		local var_224_2 = math.min(var_224_1:RestTime(), var_224_0)
		
		var_224_1:Update(arg_224_1, var_224_2)
		
		var_224_0 = var_224_0 - var_224_2
		
		if var_224_1:IsFinished() then
			arg_224_0.rest_count = arg_224_0.rest_count - 1
			
			if arg_224_0.rest_count > 0 then
				var_224_1:Reset()
			end
		end
	end
end
var_0_2[REPEAT] = function(arg_225_0, arg_225_1, arg_225_2)
	arg_225_0.CHILD:Finish(arg_225_1, arg_225_2)
	
	arg_225_0.rest_count = 0
end
var_0_3[REPEAT] = function(arg_226_0, arg_226_1)
	arg_226_0.rest_count = arg_226_0.COUNT
end
var_0_0[LOOP] = function(arg_227_0, arg_227_1, arg_227_2)
	arg_227_0.CHILD, arg_227_0.TOTAL_TIME = Action:create(arg_227_1[2], arg_227_2, arg_227_0.DEBUG), math.huge
	arg_227_0.COUNT = math.huge
	arg_227_0.rest_count = math.huge
end
var_0_1[LOOP] = var_0_1[REPEAT]
var_0_2[LOOP] = var_0_2[REPEAT]
var_0_3[LOOP] = var_0_3[REPEAT]
var_0_0[COND_LOOP] = function(arg_228_0, arg_228_1, arg_228_2)
	arg_228_0.CHILD, arg_228_0.TOTAL_TIME = Action:create(arg_228_1[2], arg_228_2, arg_228_0.DEBUG), math.huge
	arg_228_0.check_cond = arg_228_1[3]
	arg_228_0.check_arg = arg_228_1[4]
end
var_0_1[COND_LOOP] = function(arg_229_0, arg_229_1, arg_229_2)
	local var_229_0 = arg_229_0.CHILD
	
	var_229_0:Update(arg_229_1, arg_229_2)
	
	if var_229_0:IsFinished() then
		var_229_0:Reset()
	end
	
	if arg_229_0.check_cond and arg_229_0.check_cond(arg_229_0.check_arg) then
		arg_229_0.removed = true
	end
end
var_0_2[COND_LOOP] = var_0_2[REPEAT]
var_0_3[COND_LOOP] = var_0_3[REPEAT]
var_0_0[DELAY] = function(arg_230_0, arg_230_1, arg_230_2)
	arg_230_0.TOTAL_TIME = math.max(0, arg_230_1[2] or 0)
end
var_0_0[TARGET] = function(arg_231_0, arg_231_1, arg_231_2)
	arg_231_0.CHILD = Action:create(arg_231_1[3], arg_231_1[2], arg_231_0.DEBUG)
	arg_231_0.TARGET = arg_231_1[2]
	arg_231_0.TOTAL_TIME = arg_231_0.CHILD.TOTAL_TIME
end
var_0_1[TARGET] = function(arg_232_0, arg_232_1, arg_232_2, arg_232_3)
	if Action:isNull(arg_232_0.TARGET) then
		arg_232_0.removed = true
		
		return 
	end
	
	arg_232_0.CHILD:Update(arg_232_1, arg_232_2, arg_232_3)
end
var_0_3[TARGET] = function(arg_233_0, arg_233_1)
	if Action:isNull(arg_233_0.TARGET) then
		arg_233_0.removed = true
		
		return 
	end
	
	arg_233_0.CHILD:Reset(arg_233_1)
end
var_0_2[TARGET] = function(arg_234_0, arg_234_1)
	if Action:isNull(arg_234_0.TARGET) then
		arg_234_0.removed = true
		
		return 
	end
	
	arg_234_0.CHILD:Finish(arg_234_1)
end
var_0_0[SEQ] = function(arg_235_0, arg_235_1, arg_235_2)
	arg_235_0.CHILDS = {}
	arg_235_0.TOTAL_TIME = 0
	arg_235_0.cur_idx = 1
	
	local var_235_0 = arg_235_0.CHILDS
	
	for iter_235_0 = 2, #arg_235_1 do
		local var_235_1 = Action:create(arg_235_1[iter_235_0], arg_235_2, arg_235_0.DEBUG)
		
		table.insert(var_235_0, var_235_1)
		
		if var_235_1.TOTAL_TIME == math.huge then
			arg_235_0.TOTAL_TIME = math.huge
			
			if not var_235_1.check_cond then
				break
			end
		else
			arg_235_0.TOTAL_TIME = arg_235_0.TOTAL_TIME + var_235_1.TOTAL_TIME
		end
	end
end
var_0_1[SEQ] = function(arg_236_0, arg_236_1, arg_236_2, arg_236_3)
	local var_236_0 = arg_236_2
	
	for iter_236_0 = arg_236_0.cur_idx, #arg_236_0.CHILDS do
		local var_236_1 = arg_236_0.CHILDS[iter_236_0]
		local var_236_2 = math.min(var_236_1:RestTime(), var_236_0)
		
		var_236_1:Update(arg_236_1, var_236_2, arg_236_3)
		
		var_236_0 = var_236_0 - var_236_2
		
		if var_236_1:IsFinished() then
			arg_236_0.cur_idx = arg_236_0.cur_idx + 1
		else
			break
		end
	end
end
var_0_2[SEQ] = function(arg_237_0, arg_237_1)
	local var_237_0 = arg_237_0.cur_idx
	
	arg_237_0.cur_idx = #arg_237_0.CHILDS + 1
	
	for iter_237_0 = var_237_0, #arg_237_0.CHILDS do
		arg_237_0.CHILDS[iter_237_0]:Finish(arg_237_1)
	end
end
var_0_3[SEQ] = function(arg_238_0, arg_238_1)
	for iter_238_0 = 1, math.min(arg_238_0.cur_idx, #arg_238_0.CHILDS) do
		arg_238_0.CHILDS[iter_238_0]:Reset()
	end
	
	arg_238_0.cur_idx = 1
end
var_0_0[SEQ_LIST] = function(arg_239_0, arg_239_1, arg_239_2)
	arg_239_0.CHILDS = {}
	arg_239_0.TOTAL_TIME = 0
	arg_239_0.cur_idx = 1
	
	local var_239_0 = arg_239_0.CHILDS
	
	for iter_239_0 = 2, #arg_239_1 do
		for iter_239_1, iter_239_2 in pairs(arg_239_1[iter_239_0]) do
			local var_239_1 = Action:create(iter_239_2, arg_239_2, arg_239_0.DEBUG)
			
			table.insert(var_239_0, var_239_1)
			
			if var_239_1.TOTAL_TIME == math.huge then
				arg_239_0.TOTAL_TIME = math.huge
				
				if not var_239_1.check_cond then
					break
				end
			else
				arg_239_0.TOTAL_TIME = arg_239_0.TOTAL_TIME + var_239_1.TOTAL_TIME
			end
		end
	end
end
var_0_1[SEQ_LIST] = var_0_1[SEQ]
var_0_2[SEQ_LIST] = var_0_2[SEQ]
var_0_3[SEQ_LIST] = var_0_3[SEQ]
var_0_0[FADE_IN] = function(arg_240_0, arg_240_1, arg_240_2)
	arg_240_0.TOTAL_TIME = arg_240_1[2]
end
var_0_1[FADE_IN] = function(arg_241_0, arg_241_1, arg_241_2)
	local var_241_0 = (arg_241_0.elapsed_time + arg_241_2) / arg_241_0.TOTAL_TIME
	
	if arg_241_0.elapsed_time == 0 then
		arg_241_0.TARGET:setVisible(true)
	end
	
	arg_241_0.TARGET:setOpacity(255 * var_241_0)
end
var_0_2[FADE_IN] = function(arg_242_0, arg_242_1)
	arg_242_0.TARGET:setOpacity(255)
end
var_0_3[FADE_IN] = function(arg_243_0, arg_243_1)
end
var_0_0[FADE_OUT] = function(arg_244_0, arg_244_1, arg_244_2)
	arg_244_0.TOTAL_TIME = arg_244_1[2]
	arg_244_0.INVISIBLE = arg_244_1[3]
end
var_0_1[FADE_OUT] = function(arg_245_0, arg_245_1, arg_245_2)
	local var_245_0 = 1 - (arg_245_0.elapsed_time + arg_245_2) / arg_245_0.TOTAL_TIME
	
	arg_245_0.TARGET:setOpacity(255 * var_245_0)
	
	if arg_245_0.elapsed_time == 0 then
		arg_245_0.TARGET:setVisible(true)
	end
end
var_0_2[FADE_OUT] = function(arg_246_0, arg_246_1)
	if arg_246_0.INVISIBLE then
		arg_246_0.TARGET:setVisible(false)
	end
end
var_0_3[FADE_OUT] = function(arg_247_0, arg_247_1)
end
var_0_0[SLIDE_IN] = function(arg_248_0, arg_248_1, arg_248_2)
	local var_248_0 = arg_248_1[3] or DESIGN_WIDTH / 2
	
	arg_248_0.TO_X = arg_248_2:getPositionX()
	arg_248_0.FROM_X = arg_248_0.TO_X - var_248_0
	arg_248_0.TOTAL_TIME = arg_248_1[2]
	arg_248_0.SKIP_FADE = arg_248_1[4]
	arg_248_0.TO_FADE = arg_248_1[5] or 255
end
var_0_1[SLIDE_IN] = function(arg_249_0, arg_249_1, arg_249_2)
	if arg_249_0.elapsed_time == 0 then
		arg_249_0.TARGET:setVisible(true)
	end
	
	local var_249_0 = (arg_249_0.elapsed_time + arg_249_2) / arg_249_0.TOTAL_TIME
	local var_249_1 = math.log(1 + var_249_0 * 99, 100) / 1
	local var_249_2 = arg_249_0.TO_X - (1 - var_249_1) * (arg_249_0.TO_X - arg_249_0.FROM_X)
	
	if var_249_1 == 1 then
		var_249_2 = arg_249_0.TO_X
	end
	
	arg_249_0.TARGET:setPositionX(var_249_2)
	
	if not arg_249_0.SKIP_FADE then
		local var_249_3 = 1 - math.log(1 + (1 - var_249_0) * 99, 100) / 1
		
		arg_249_0.TARGET:setOpacity(var_249_3 * arg_249_0.TO_FADE)
	end
end
var_0_0[SLIDE_IN_Y] = function(arg_250_0, arg_250_1, arg_250_2)
	local var_250_0 = arg_250_1[3] or DESIGN_HEIGHT / 2
	
	arg_250_0.TO_Y = arg_250_2:getPositionY()
	arg_250_0.FROM_Y = arg_250_0.TO_Y - var_250_0
	arg_250_0.TOTAL_TIME = arg_250_1[2]
	arg_250_0.SKIP_FADE = arg_250_1[4]
end
var_0_1[SLIDE_IN_Y] = function(arg_251_0, arg_251_1, arg_251_2)
	if arg_251_0.elapsed_time == 0 then
		arg_251_0.TARGET:setVisible(true)
	end
	
	local var_251_0 = (arg_251_0.elapsed_time + arg_251_2) / arg_251_0.TOTAL_TIME
	local var_251_1 = math.log(1 + var_251_0 * 99, 100) / 1
	local var_251_2 = arg_251_0.TO_Y - (1 - var_251_1) * (arg_251_0.TO_Y - arg_251_0.FROM_Y)
	
	if var_251_1 == 1 then
		x = arg_251_0.TO_Y
	end
	
	arg_251_0.TARGET:setPositionY(var_251_2)
	
	if not arg_251_0.SKIP_FADE then
		local var_251_3 = 1 - math.log(1 + (1 - var_251_0) * 99, 100) / 1
		
		arg_251_0.TARGET:setOpacity(var_251_3 * 255)
	end
end
var_0_0[SLIDE_OUT] = function(arg_252_0, arg_252_1, arg_252_2)
	local var_252_0 = arg_252_1[3] or DESIGN_WIDTH / 2
	
	arg_252_0.FROM_X = arg_252_2:getPositionX()
	arg_252_0.TO_X = arg_252_0.FROM_X + var_252_0
	arg_252_0.TOTAL_TIME = arg_252_1[2]
	arg_252_0.SKIP_FADE = arg_252_1[4]
end
var_0_1[SLIDE_OUT] = function(arg_253_0, arg_253_1, arg_253_2)
	if arg_253_0.elapsed_time == 0 then
		arg_253_0.TARGET:setVisible(true)
	end
	
	local var_253_0 = 1 - (arg_253_0.elapsed_time + arg_253_2) / arg_253_0.TOTAL_TIME
	local var_253_1 = 1 - math.log(1 + var_253_0 * 99, 100) / 1
	local var_253_2 = arg_253_0.TO_X - (1 - var_253_1) * (arg_253_0.TO_X - arg_253_0.FROM_X)
	
	if var_253_1 == 1 then
		var_253_2 = arg_253_0.FROM_X
		
		arg_253_0.TARGET:setPositionX(var_253_2)
		arg_253_0.TARGET:setVisible(false)
	else
		arg_253_0.TARGET:setPositionX(var_253_2)
	end
	
	if not arg_253_0.SKIP_FADE then
		arg_253_0.TARGET:setOpacity((1 - var_253_1) * 255)
	end
end
var_0_2[SLIDE_OUT] = function(arg_254_0)
	arg_254_0.TARGET:setPositionX(arg_254_0.FROM_X or 0)
	arg_254_0.TARGET:setVisible(false)
end
var_0_0[SLIDE_OUT_Y] = function(arg_255_0, arg_255_1, arg_255_2)
	local var_255_0 = arg_255_1[3] or DESIGN_HEIGHT / 2
	
	arg_255_0.FROM_Y = arg_255_2:getPositionY()
	arg_255_0.TO_Y = arg_255_0.FROM_Y + var_255_0
	arg_255_0.TOTAL_TIME = arg_255_1[2]
	arg_255_0.SKIP_FADE = arg_255_1[4]
end
var_0_1[SLIDE_OUT_Y] = function(arg_256_0, arg_256_1, arg_256_2)
	if arg_256_0.elapsed_time == 0 then
		arg_256_0.TARGET:setVisible(true)
	end
	
	local var_256_0 = 1 - (arg_256_0.elapsed_time + arg_256_2) / arg_256_0.TOTAL_TIME
	local var_256_1 = 1 - math.log(1 + var_256_0 * 99, 100) / 1
	local var_256_2 = arg_256_0.TO_Y - (1 - var_256_1) * (arg_256_0.TO_Y - arg_256_0.FROM_Y)
	
	if var_256_1 == 1 then
		var_256_2 = arg_256_0.FROM_Y
		
		arg_256_0.TARGET:setPositionY(var_256_2)
		arg_256_0.TARGET:setVisible(false)
	else
		arg_256_0.TARGET:setPositionY(var_256_2)
	end
	
	if not arg_256_0.SKIP_FADE then
		arg_256_0.TARGET:setOpacity((1 - var_256_1) * 255)
	end
end
var_0_2[SLIDE_OUT_Y] = function(arg_257_0)
	arg_257_0.TARGET:setPositionY(arg_257_0.FROM_Y or 0)
	arg_257_0.TARGET:setVisible(false)
end
var_0_0[SHAKE_UI] = function(arg_258_0, arg_258_1, arg_258_2)
	arg_258_0.RAND = getRandom(systick())
	
	local var_258_0 = arg_258_1[3] or 3
	
	arg_258_0.USE_LOG = arg_258_1[4]
	
	local var_258_1 = arg_258_1[5] or {}
	
	if var_258_1.only_x then
		arg_258_0.POWER_X = var_258_0
	elseif var_258_1.only_y then
		arg_258_0.POWER_Y = var_258_0
	elseif var_258_1.power_x or var_258_1.power_y then
		arg_258_0.POWER_X = var_258_1.power_x
		arg_258_0.POWER_Y = var_258_1.power_y
	else
		arg_258_0.POWER_X = var_258_0
		arg_258_0.POWER_Y = var_258_0
	end
	
	arg_258_0.TOTAL_TIME = arg_258_1[2]
	arg_258_0.turn = 0
	
	if BGI and BGI.game_layer == arg_258_2 then
		arg_258_0.____disable = true
	end
end
var_0_1[SHAKE_UI] = function(arg_259_0, arg_259_1, arg_259_2, arg_259_3)
	local var_259_0 = arg_259_0.elapsed_time + arg_259_2
	
	if arg_259_0.X == nil then
		arg_259_0.X, arg_259_0.Y = arg_259_0.TARGET:getPosition()
	end
	
	local var_259_1 = 30
	local var_259_2 = math.floor(var_259_0 / var_259_1)
	
	if not arg_259_3 and arg_259_0.turn ~= var_259_2 then
		arg_259_0.turn = var_259_2
		
		local var_259_3 = arg_259_0.POWER_X
		local var_259_4 = arg_259_0.POWER_Y
		
		if arg_259_0.USE_LOG then
			local var_259_5 = (arg_259_0.elapsed_time + arg_259_2) / arg_259_0.TOTAL_TIME
			
			var_259_3 = var_259_3 and var_259_3 * (1 - var_259_5)
			var_259_4 = var_259_4 and var_259_4 * (1 - var_259_5)
		end
		
		local var_259_6 = 0
		
		if var_259_3 then
			var_259_6 = var_259_3 * (arg_259_0.RAND:get() - 0.5)
		end
		
		local var_259_7 = 0
		
		if var_259_4 then
			var_259_7 = var_259_4 * (arg_259_0.RAND:get() - 0.5)
		end
		
		if not arg_259_0.____disable then
			arg_259_0.TARGET:setPosition(arg_259_0.X + var_259_6, arg_259_0.Y + var_259_7)
		end
	end
end
var_0_2[SHAKE_UI] = function(arg_260_0, arg_260_1)
	if not arg_260_0.____disable then
		arg_260_0.TARGET:setPosition(arg_260_0.X, arg_260_0.Y)
	end
	
	arg_260_0.turn = 0
end
var_0_3[SHAKE_UI] = var_0_2[SHAKE_UI]
var_0_0[SHAKE_CAM] = function(arg_261_0, arg_261_1, arg_261_2)
	local var_261_0 = ShakeManager:createAction({
		name = arg_261_1[2],
		duration = arg_261_1[3],
		powerX = arg_261_1[4] or 0,
		powerY = arg_261_1[5] or 0,
		timeScale = arg_261_1[6] or 1
	})
	
	arg_261_0.CHILD = Action:create(var_261_0, arg_261_2, arg_261_0.DEBUG)
	arg_261_0.TOTAL_TIME = arg_261_0.CHILD.TOTAL_TIME
end
var_0_1[SHAKE_CAM] = function(arg_262_0, arg_262_1, arg_262_2, arg_262_3)
	arg_262_0.CHILD:Update(arg_262_1, arg_262_2, arg_262_3)
end
var_0_3[SHAKE_CAM] = function(arg_263_0, arg_263_1)
	arg_263_0.CHILD:Reset(arg_263_1)
end
var_0_2[SHAKE_CAM] = function(arg_264_0, arg_264_1)
	arg_264_0.CHILD:Finish(arg_264_1)
end
var_0_0[ANI_CAM] = function(arg_265_0, arg_265_1, arg_265_2)
	local var_265_0 = ShakeManager:createAction({
		duration = -1,
		type = 1,
		name = arg_265_1[2],
		source = arg_265_1[2]
	})
	
	arg_265_0.CHILD = Action:create(var_265_0, arg_265_2, arg_265_0.DEBUG)
	arg_265_0.TOTAL_TIME = arg_265_0.CHILD.TOTAL_TIME
end
var_0_1[ANI_CAM] = var_0_1[SHAKE_CAM]
var_0_3[ANI_CAM] = var_0_3[SHAKE_CAM]
var_0_2[ANI_CAM] = var_0_2[SHAKE_CAM]
var_0_0[STOP] = function(arg_266_0, arg_266_1, arg_266_2)
	arg_266_0.TOTAL_TIME = 0
end
var_0_1[STOP] = function(arg_267_0, arg_267_1, arg_267_2)
	stop_or_remove(arg_267_0.TARGET)
end
var_0_0[REMOVE] = function(arg_268_0, arg_268_1, arg_268_2)
	arg_268_0.TOTAL_TIME = 0
end
var_0_1[REMOVE] = function(arg_269_0, arg_269_1, arg_269_2)
	remove_object(arg_269_0.TARGET)
end
var_0_0[REMOVE_SPRITE] = function(arg_270_0, arg_270_1, arg_270_2)
	arg_270_0.TOTAL_TIME = 0
end
var_0_1[REMOVE_SPRITE] = function(arg_271_0, arg_271_1, arg_271_2)
	local var_271_0 = arg_271_0.TARGET:getTexture()
	
	cc.Director:getInstance():getTextureCache():removeTexture(var_271_0)
	remove_object(arg_271_0.TARGET)
end
var_0_0[ZORDER] = function(arg_272_0, arg_272_1, arg_272_2)
	if get_cocos_refid(arg_272_2) then
		arg_272_0.BEGIN_Z = arg_272_2:getLocalZOrder()
	end
	
	var_0_12(arg_272_0, "Z", arg_272_1[2])
	
	arg_272_0.TOTAL_TIME = 0
end
var_0_1[ZORDER] = function(arg_273_0, arg_273_1, arg_273_2)
	arg_273_0.TARGET:setLocalZOrder(arg_273_0.Z)
end
var_0_3[ZORDER] = function(arg_274_0, arg_274_1)
	if arg_274_0.BEGIN_Z then
		arg_274_0.TARGET:setLocalZOrder(arg_274_0.BEGIN_Z)
	end
end
var_0_0[SHOW] = function(arg_275_0, arg_275_1, arg_275_2)
	if not get_cocos_refid(arg_275_2) then
		return 
	end
	
	arg_275_0.BEGIN_FLAG = arg_275_2:isVisible()
	arg_275_0.FLAG = arg_275_1[2]
	arg_275_0.TOTAL_TIME = 0
end
var_0_1[SHOW] = function(arg_276_0, arg_276_1, arg_276_2)
	if not get_cocos_refid(arg_276_0.TARGET) then
		return 
	end
	
	arg_276_0.TARGET:setVisible(arg_276_0.FLAG)
end
var_0_2[SHOW] = var_0_1[SHOW]
var_0_3[SHOW] = function(arg_277_0, arg_277_1)
	if not get_cocos_refid(arg_277_0.TARGET) then
		return 
	end
	
	arg_277_0.TARGET:setVisible(arg_277_0.BEGIN_FLAG)
end
var_0_0[SOUND] = function(arg_278_0, arg_278_1, arg_278_2)
	arg_278_0.EVENT = arg_278_1[2]
	arg_278_0.TOTAL_TIME = 0
end
var_0_1[SOUND] = function(arg_279_0, arg_279_1, arg_279_2)
	SoundEngine:play(arg_279_0.EVENT)
end
var_0_2[SOUND] = function()
end
var_0_3[SOUND] = function(arg_281_0, arg_281_1)
end
var_0_0[MOTION] = function(arg_282_0, arg_282_1, arg_282_2)
	local var_282_0 = 2
	
	if type(arg_282_1[2]) == "number" then
		local var_282_1 = arg_282_1[2]
		
		arg_282_0.DURATION = arg_282_2:getAnimationDuration(arg_282_1[3])
		arg_282_0.TIME_SCALE = var_282_1 / (arg_282_0.DURATION * 1000)
		arg_282_0.PREV_TIME_SCALE = arg_282_2:getTimeScale()
		var_282_0 = 3
	else
		arg_282_0.TIME_SCALE = 1
	end
	
	arg_282_0.MOTION = arg_282_1[var_282_0]
	arg_282_0.LOOP = arg_282_1[var_282_0 + 1]
	arg_282_0.TOTAL_TIME = 0
	
	if arg_282_2.getEvents then
		arg_282_0.EVENTS = arg_282_2:getEvents(arg_282_0.MOTION)
	end
	
	if arg_282_1[var_282_0 + 2] then
		arg_282_0.START_POS = math.random()
	end
	
	if arg_282_0.LOOP then
		arg_282_0.TIME_SCALE = nil
		arg_282_0.PREV_TIME_SCALE = nil
	end
end
var_0_1[MOTION] = function(arg_283_0, arg_283_1, arg_283_2)
	arg_283_0.TARGET:setAnimation(0, arg_283_0.MOTION, arg_283_0.LOOP)
	
	if arg_283_0.START_POS then
		arg_283_0.TARGET:update(arg_283_0.START_POS)
	end
	
	if arg_283_0.TIME_SCALE ~= nil then
		arg_283_0.TARGET:setTimeScale(arg_283_0.TIME_SCALE)
	else
		arg_283_0.TARGET:setTimeScale(1)
	end
	
	if arg_283_0.EVENTS then
		LuaEventDispatcher:dispatchActionEvent(arg_283_0, arg_283_1)
	end
end
var_0_3[MOTION] = function(arg_284_0, arg_284_1, arg_284_2)
	if arg_284_0.PREV_TIME_SCALE ~= nil then
		arg_284_0.TARGET:setTimeScale(arg_284_0.PREV_TIME_SCALE)
	end
end
var_0_2[MOTION] = var_0_3[MOTION]
var_0_0[RESUME] = function(arg_285_0, arg_285_1)
	arg_285_0.flag = false
	arg_285_0.TOTAL_TIME = 0
end
var_0_3[RESUME] = var_0_0[RESUME]
var_0_1[RESUME] = function(arg_286_0, arg_286_1, arg_286_2)
	if not arg_286_0.flag then
		arg_286_0.TARGET:resume()
		
		arg_286_0.flag = true
	end
end
var_0_0[PAUSE] = function(arg_287_0, arg_287_1)
	arg_287_0.flag = false
	arg_287_0.TOTAL_TIME = 0
end
var_0_3[PAUSE] = var_0_0[PAUSE]
var_0_1[PAUSE] = function(arg_288_0, arg_288_1, arg_288_2)
	if not arg_288_0.flag then
		arg_288_0.TARGET:pause()
		
		arg_288_0.flag = true
	end
end
var_0_0[DMOTION] = function(arg_289_0, arg_289_1, arg_289_2)
	if type(arg_289_1[2]) == "number" then
		arg_289_0.DURATION = arg_289_2:getAnimationDuration(arg_289_1[3])
		arg_289_0.TOTAL_TIME = arg_289_1[2]
		
		if arg_289_0.TOTAL_TIME ~= 0 then
			arg_289_0.TIME_SCALE = arg_289_0.DURATION * 1000 / arg_289_0.TOTAL_TIME
		else
			arg_289_0.TIME_SCALE = 1
		end
		
		arg_289_0.PREV_TIME_SCALE = arg_289_2:getTimeScale()
		arg_289_0.MOTION = arg_289_1[3]
		arg_289_0.LOOP = arg_289_1[4]
		
		if arg_289_1[5] then
			arg_289_0.TIME_SCALE = arg_289_1[5]
		end
		
		if arg_289_0.LOOP then
			arg_289_0.TIME_SCALE = 1
		end
	else
		arg_289_0.TIME_SCALE = 1
		arg_289_0.DURATION = arg_289_2:getAnimationDuration(arg_289_1[2])
		arg_289_0.TOTAL_TIME = arg_289_0.DURATION * 1000
		arg_289_0.MOTION = arg_289_1[2]
		arg_289_0.LOOP = arg_289_1[3]
	end
	
	arg_289_0.EVENTS = arg_289_2:getEvents(arg_289_0.MOTION)
end
var_0_1[DMOTION] = function(arg_290_0, arg_290_1, arg_290_2)
	if arg_290_0.PLAYED ~= true then
		arg_290_0.TARGET:setAnimation(0, arg_290_0.MOTION, arg_290_0.LOOP)
		
		if arg_290_0.TIME_SCALE ~= nil then
			arg_290_0.TARGET:setTimeScale(arg_290_0.TIME_SCALE)
		else
			arg_290_0.TARGET:setTimeScale(1)
		end
		
		arg_290_0.PLAYED = true
		
		if arg_290_0.EVENTS then
			LuaEventDispatcher:dispatchActionEvent(arg_290_0, arg_290_1)
		end
	end
end
var_0_3[DMOTION] = function(arg_291_0, arg_291_1)
	if arg_291_0.PREV_TIME_SCALE ~= nil then
		arg_291_0.TARGET:setTimeScale(arg_291_0.PREV_TIME_SCALE)
	end
	
	arg_291_0.PLAYED = false
end
var_0_2[DMOTION] = function(arg_292_0, arg_292_1)
	var_0_3[DMOTION](arg_292_0, arg_292_1)
end
var_0_0[DEBUG] = function(arg_293_0, arg_293_1)
	print("DEBUG START")
	
	arg_293_0.TOTAL_TIME = arg_293_1[2]
end
var_0_1[DEBUG] = function(arg_294_0, arg_294_1, arg_294_2)
	print("DEBUG", arg_294_0, (arg_294_0.elapsed_time + arg_294_2) / arg_294_0.TOTAL_TIME, arg_294_0.elapsed_time, arg_294_2, arg_294_0.TOTAL_TIME, arg_294_0:getTick())
end
var_0_2[DEBUG] = function(arg_295_0, arg_295_1)
	print("DEBUG FIN")
end

local function var_0_13(arg_296_0)
	arg_296_0.elapsed_time = 0
	arg_296_0.count = 0
	arg_296_0.finished = false
	
	arg_296_0:_Reset()
end

local function var_0_14(arg_297_0, arg_297_1, arg_297_2, arg_297_3)
	local var_297_0 = uitick()
	
	if not DEBUG_INFO.last_action_err then
		DEBUG_INFO.last_action_err = arg_297_0.DEBUG
		DEBUG_INFO.last_action = arg_297_0
	end
	
	local var_297_1 = math.min(arg_297_0.speed * arg_297_2, arg_297_0:RestTime())
	local var_297_2 = math.max(0, arg_297_0.TOTAL_TIME - (arg_297_0.elapsed_time + var_297_1))
	local var_297_3 = math.floor(var_297_2 * 1000000)
	
	if arg_297_0._Update ~= nil and arg_297_0:IsFinished() ~= true then
		Action.CUR_DEBUG = arg_297_0.DEBUG
		
		arg_297_0:_Update(arg_297_1, var_297_1, var_297_3 <= 1e-05 or arg_297_3)
		
		Action.CUR_DEBUG = nil
	end
	
	arg_297_0.count = arg_297_0.count + 1
	arg_297_0.elapsed_time = arg_297_0.elapsed_time + var_297_1
	
	if arg_297_0:IsFinished() and arg_297_0.finished ~= true then
		arg_297_0:Finish(arg_297_1)
	end
	
	if DEBUG_INFO.last_action_err == arg_297_0.DEBUG then
		DEBUG_INFO.last_action_err = nil
		DEBUG_INFO.last_action = nil
	end
end

local function var_0_15(arg_298_0, arg_298_1)
	arg_298_0.speed = arg_298_1
end

local function var_0_16(arg_299_0)
	if arg_299_0._Finish ~= nil and not arg_299_0.finished then
		arg_299_0:_Finish()
	end
	
	arg_299_0.finished = true
end

local function var_0_17(arg_300_0)
	return math.max(0, arg_300_0.TOTAL_TIME - arg_300_0.elapsed_time)
end

function Action.create(arg_301_0, arg_301_1, arg_301_2, arg_301_3)
	local var_301_0 = {
		TYPE = arg_301_1[1],
		TARGET = arg_301_2
	}
	
	if Action.ON_MAKE[var_301_0.TYPE] == nil then
		print("Action error ! ")
		
		return nil
	end
	
	var_301_0.DEBUG = arg_301_3
	var_301_0.TARGET = arg_301_2
	var_301_0.speed = 1
	var_301_0.count = 0
	var_301_0.elapsed_time = 0
	var_301_0.finished = false
	var_301_0.Update = var_0_14
	var_301_0._Update = Action.ON_UPDATE[var_301_0.TYPE]
	var_301_0.data = Action.ON_MAKE[var_301_0.TYPE](var_301_0, arg_301_1, arg_301_2)
	var_301_0.Reset = var_0_13
	var_301_0._Reset = Action.ON_RESET[var_301_0.TYPE] or var_0_4
	var_301_0._Finish = Action.ON_FINISH[var_301_0.TYPE] or var_0_4
	var_301_0.SetSpeed = var_0_15
	
	if var_301_0.INTERFACE and var_301_0.INTERFACE.IsFinished then
		var_301_0.IsFinished = var_0_8
	elseif var_301_0.CHILD then
		var_301_0.IsFinished = var_0_9
	elseif var_301_0.CHILDS then
		var_301_0.IsFinished = var_0_11
	elseif var_301_0.TOTAL_TIME == 0 then
		var_301_0.IsFinished = var_0_10
	else
		var_301_0.IsFinished = var_0_7
	end
	
	var_301_0.Finish = var_0_16
	var_301_0.RestTime = var_0_17
	
	return var_301_0
end

function Action.Find(arg_302_0, arg_302_1, arg_302_2)
	arg_302_2 = arg_302_2 or arg_302_0.List
	
	if type(arg_302_1) == "string" then
		for iter_302_0 = 1, #arg_302_2 do
			if not arg_302_2[iter_302_0].removed and (arg_302_2[iter_302_0][2] == arg_302_1 or arg_302_2[iter_302_0][2] == "*" .. arg_302_1) then
				return arg_302_2[iter_302_0]
			end
		end
	else
		for iter_302_1 = 1, #arg_302_2 do
			if not arg_302_2[iter_302_1].removed and arg_302_2[iter_302_1][1].TARGET == arg_302_1 then
				return arg_302_2[iter_302_1]
			end
		end
	end
	
	return nil
end

function Action.Finish(arg_303_0, arg_303_1, arg_303_2)
	local var_303_0
	
	arg_303_2 = arg_303_2 or arg_303_0.List
	
	if type(arg_303_1) == "string" then
		for iter_303_0 = #arg_303_2, 1, -1 do
			if arg_303_2[iter_303_0][2] == arg_303_1 then
				arg_303_2[iter_303_0][1].IsFinished = var_0_6
				
				arg_303_2[iter_303_0][1]:Finish()
				
				arg_303_2[iter_303_0].removed = true
				var_303_0 = (var_303_0 or 0) + 1
			end
		end
	else
		for iter_303_1 = #arg_303_2, 1, -1 do
			if arg_303_2[iter_303_1][1].TARGET == arg_303_1 then
				arg_303_2[iter_303_1][1].IsFinished = var_0_6
				
				arg_303_2[iter_303_1][1]:Finish()
				
				arg_303_2[iter_303_1].removed = true
				var_303_0 = (var_303_0 or 0) + 1
			end
		end
	end
	
	return var_303_0
end

function Action.Remove(arg_304_0, arg_304_1, arg_304_2, arg_304_3)
	arg_304_2 = arg_304_2 or arg_304_0.List
	
	if type(arg_304_1) == "string" then
		for iter_304_0 = #arg_304_2, 1, -1 do
			if arg_304_2[iter_304_0][2] == arg_304_1 then
				arg_304_2[iter_304_0].removed = true
				
				if arg_304_3 and get_cocos_refid(arg_304_2[iter_304_0][1].TARGET) then
					arg_304_2[iter_304_0][1].TARGET:removeFromParent()
				end
			end
		end
	else
		for iter_304_1 = #arg_304_2, 1, -1 do
			if arg_304_2[iter_304_1][1].TARGET == arg_304_1 then
				arg_304_2[iter_304_1].removed = true
				
				if arg_304_3 and get_cocos_refid(arg_304_2[iter_304_1][1].TARGET) then
					arg_304_2[iter_304_1][1].TARGET:removeFromParent()
				end
			end
		end
	end
end

function Action.Append(arg_305_0, arg_305_1, arg_305_2, arg_305_3, arg_305_4, arg_305_5)
	local var_305_0 = arg_305_0:Find(assert(arg_305_3))
	
	if var_305_0 then
		arg_305_0:Add(SEQ(COND_LOOP(DELAY(0), function()
			return var_305_0[1].finished
		end), arg_305_1), arg_305_2, arg_305_3, arg_305_4, arg_305_5)
	else
		arg_305_0:Add(arg_305_1, arg_305_2, arg_305_3, arg_305_4, arg_305_5)
	end
end

function Action.AddSync(arg_307_0, arg_307_1, arg_307_2, arg_307_3, arg_307_4, arg_307_5)
	arg_307_4 = arg_307_4 or arg_307_0.List
	
	local var_307_0
	
	if not PRODUCTION_MODE then
		local var_307_1 = 0
		
		if arg_307_5 and arg_307_5 <= 0 then
			var_307_1 = 1
		end
		
		var_307_0 = debug.getinfo(2 + var_307_1)
		var_307_0 = string.split(var_307_0.source, "\n")[1] .. ":" .. var_307_0.currentline
	end
	
	if arg_307_3 == "battle.camera" and arg_307_0:Find(arg_307_3) then
		print("Duplicated camera action : " .. var_307_0)
	end
	
	arg_307_1 = arg_307_0:create(arg_307_1, arg_307_2, var_307_0)
	arg_307_1.NAME = arg_307_3
	
	local var_307_2 = CocosSchedulerManager:getCurrentSchForPoll()
	
	if var_307_2 and arg_307_0.name_tag == "BattleAction" then
		arg_307_5 = GET_LAST_TICK()
		arg_307_1.USE_SCHEDULER = var_307_2
	end
	
	local var_307_3 = get_cocos_refid(arg_307_2) ~= nil
	
	if arg_307_1.TARGET == nil then
		if not PRODUCTION_MODE then
			print("ACTION ERROR:TARGET is nil : " .. var_307_0)
		end
		
		return occur_exception()
	end
	
	if false then
	end
	
	arg_307_5 = arg_307_5 or arg_307_0:getTick()
	
	table.insert(arg_307_4, {
		arg_307_1,
		arg_307_3,
		arg_307_5,
		var_307_3
	})
	
	return arg_307_1
end

function Action.AddAsync(arg_308_0, arg_308_1, arg_308_2, arg_308_3, arg_308_4, arg_308_5)
	arg_308_0:AddSync(arg_308_1, arg_308_2, arg_308_3, arg_308_4, -1)
end

function Action.AddSmooth(arg_309_0, arg_309_1, arg_309_2, arg_309_3, arg_309_4, arg_309_5)
	arg_309_0:AddSync(arg_309_1, arg_309_2, arg_309_3, arg_309_4, -1)
end

Action.Add = Action.AddSync

function Action.RemoveAll(arg_310_0)
	for iter_310_0 = 1, #arg_310_0.List do
		arg_310_0.List[iter_310_0].removed = true
	end
end

function Action.getTick(arg_311_0)
	return LAST_TICK
end

function Action.isNull(arg_312_0, arg_312_1)
	if type(arg_312_1) == "userdata" then
		return not get_cocos_refid(arg_312_1)
	end
	
	return not arg_312_1
end

function Action.Pause(arg_313_0)
	arg_313_0._timescale = 0
end

function Action.Resume(arg_314_0)
	arg_314_0._timescale = arg_314_0._realTimeScale or 1
end

function Action.Poll(arg_315_0, arg_315_1, arg_315_2)
	if arg_315_2 then
		error("action time is no nil")
	end
	
	arg_315_1 = arg_315_1 or arg_315_0.List
	arg_315_2 = arg_315_2 or arg_315_0:getTick()
	
	local var_315_0
	local var_315_1 = {}
	
	for iter_315_0 = 1, #arg_315_1 do
		if not arg_315_1[iter_315_0].removed and arg_315_1[iter_315_0][4] and Action:isNull(arg_315_1[iter_315_0][1].TARGET) then
			arg_315_1[iter_315_0].removed = true
			
			print("action auto removed : " .. (arg_315_1[iter_315_0][1].DEBUG or ""))
		end
		
		if arg_315_1[iter_315_0].removed then
			table.insert(var_315_1, iter_315_0)
		else
			local var_315_2
			
			if CocosSchedulerManager:getCurrentSchForPoll() and arg_315_0.name_tag == "BattleAction" then
				arg_315_2 = GET_LAST_TICK()
			end
			
			if arg_315_1[iter_315_0][3] == 0 then
				arg_315_1[iter_315_0][3] = arg_315_2
				var_315_2 = true
			elseif arg_315_1[iter_315_0][3] == -1 then
				arg_315_1[iter_315_0][3] = 0
				var_315_2 = xpcall(arg_315_1[iter_315_0][1].Update, __G__TRACKBACK__, arg_315_1[iter_315_0][1], arg_315_0, 0)
			else
				local var_315_3 = (arg_315_2 - arg_315_1[iter_315_0][3]) * (arg_315_0._timescale or 1)
				
				var_315_2 = xpcall(arg_315_1[iter_315_0][1].Update, __G__TRACKBACK__, arg_315_1[iter_315_0][1], arg_315_0, var_315_3)
				arg_315_1[iter_315_0][3] = arg_315_2
			end
			
			if not var_315_2 then
				table.insert(var_315_1, iter_315_0)
			end
		end
	end
	
	for iter_315_1 = #var_315_1, 1, -1 do
		table.remove(arg_315_1, var_315_1[iter_315_1])
	end
	
	for iter_315_2 = #arg_315_1, 1, -1 do
		if arg_315_1[iter_315_2][1].finished then
			table.remove(arg_315_1, iter_315_2)
		end
	end
end

function Action.setNameTag(arg_316_0, arg_316_1)
	arg_316_0.name_tag = arg_316_1
end

function Action.getNameTag(arg_317_0)
	return arg_317_0.name_tag
end

Action:setNameTag("Action")

UIAction = table.clone(Action)

UIAction:setNameTag("UIAction")

BattleUIAction = table.clone(Action)

BattleUIAction:setNameTag("BattleUIAction")

BattleAction = table.clone(Action)

BattleAction:setNameTag("BattleAction")

StoryAction = table.clone(Action)

StoryAction:setNameTag("StoryAction")

if SysAction == nil then
	SysAction = table.clone(Action)
	
	function SysAction.getTick(arg_318_0)
		return systick()
	end
end

function UIAction.getTick(arg_319_0)
	return LAST_UI_TICK
end

function StoryAction.getTick(arg_320_0)
	return STORY_ACTION_TICK
end

UIAction.Add = UIAction.AddAsync
SHAKE = NONE
