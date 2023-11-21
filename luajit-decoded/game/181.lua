GLOBAL_EFFECT_POS = {
	{
		-120,
		50
	},
	{
		-30,
		-30
	},
	{
		120,
		20
	},
	{
		-180,
		40
	},
	{
		30,
		50
	},
	{
		90,
		10
	}
}
EVENT_DEPTH = 0
TEAM_INDENT = 0.7
X_GAP = 1
JUMP_TM = 500
PRE_JUMP_DELAY = JUMP_TM * 0.3
BATTLE = {}

setmetatable(BATTLE, {
	__index = function(arg_1_0, arg_1_1)
		return rawget(arg_1_0.var, arg_1_1)()
	end
})

BATTLE.var = {
	FLY_HEIGHT = function()
		return DESIGN_HEIGHT * 0.4 + 100
	end,
	TEAM_WIDTH = function()
		return DESIGN_WIDTH * 0.22
	end,
	TEAM_HEIGHT = function()
		return DESIGN_HEIGHT * 0.25
	end,
	TEAM_X = function()
		return DESIGN_WIDTH * 0.24
	end,
	TEAM_Y = function()
		return DESIGN_HEIGHT * 0.25
	end
}
TARGET_TYPE = {
	UnitSelf = 0,
	Object = 2,
	UnitTarget = 1
}
LOCATION_TYPE = {
	Manual = 7,
	TargetBone = 11,
	OurCenter = 5,
	Target = 1,
	SelfBone = 10,
	ForFront = 4,
	Self = 0,
	OurFront = 3,
	ForCenter = 6,
	Center = 2
}
ATTACH_TYPE = {
	Node = 1,
	Field = 0,
	Bone = 2,
	Screen = 3
}
MOVE_STYLE = {
	Warp = 3,
	Jump = 2,
	Move = 1,
	None = 0
}
CAMERA_FOCUS = {
	In = 40,
	Self = 0,
	Object = 2,
	Location = 20,
	Out = 41,
	ReadyTest = -1,
	Target = 1
}
CAMERA_MODE = {
	Current = 1,
	Tracking = 2,
	Setup = 0
}
UNIT_LAYOUT_CHANGE_MODE = {
	COME_BACK = 1,
	GO_AWAY = 0
}
CLIPPING_STYLE = {
	Default = 0,
	Enabled = 1,
	Disabled = 2
}
PLAYACT_STYLE = {
	"move",
	"jump",
	"jump_rush",
	"jump_return"
}
DEF_CAM_SCALE = 1
BLEND_TARGET_VER2 = {
	Unit_Target = 6,
	WithOut_Self = 55,
	Unit_ForAll = 66,
	Unit_Self = 5,
	Unit_OurAll = 65,
	WithOut_Target = 56
}
HP_BAR_TARGET = {
	Unit_Target = 6,
	WithOut_Self = 55,
	Unit_ForAll = 66,
	Unit_Self = 5,
	Unit_OurAll = 65,
	All_Unit = 67,
	WithOut_Target = 56
}
NODEANI_TARGET = {
	Unit_Target = 6,
	Team_Self = 75,
	Team_Target = 76,
	Unit_Self = 5
}
SPINEANI_TARGET = {
	Unit_Target = 6,
	Unit_Self = 5
}
LOCATION_TYPE_VER2 = {
	Field_BEGIN = 10,
	Screen_Center = 0,
	Attach_Target = 2,
	Unit_Self = 5,
	Attach_Object = 3,
	Attach_Self = 1,
	Field_ForCenter = 42,
	Field_Target = 12,
	Field_TargetFront = 16,
	Field_OurCenter = 32,
	Field_Self = 11,
	Field_OurFront = 31,
	Field_ForFront = 41,
	Unit_Target = 6
}
LOCATION_FORCE_TYPE = {
	Our = 11,
	For = 12,
	None = 0
}
LOCATION_TYPE_ATTACH_TYPE_TABLE = {
	[LOCATION_TYPE_VER2.Attach_Self] = true,
	[LOCATION_TYPE_VER2.Attach_Target] = true,
	[LOCATION_TYPE_VER2.Attach_Object] = true
}
LOCATION_TYPE_FRONT_TYPE_TABLE = {
	[LOCATION_TYPE_VER2.Field_TargetFront] = true,
	[LOCATION_TYPE_VER2.Field_OurFront] = true,
	[LOCATION_TYPE_VER2.Field_ForFront] = true
}
LOCATION_TYPE_TARGETING_TYPE_TABLE = {
	[LOCATION_TYPE_VER2.Attach_Target] = true,
	[LOCATION_TYPE_VER2.Unit_Target] = true,
	[LOCATION_TYPE_VER2.Field_Target] = true
}
COOP_ATTACK_DELAY = 200
SPINE_EFFECT_LOCATION = {
	Attach_Target = 0,
	Field_Self = 1
}
