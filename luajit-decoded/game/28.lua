MAX_UNIT_TICK = 1000
MAX_TEAM_COUNT = 19
MAX_TEAM_UNIT_COUNT = 7
FLY_ATK_TICK = MAX_UNIT_TICK * 0.5
FLY_ATK_TICK = 0
FRONT = "front"
BACK = "back"
GOBLIN_MOVE_GOAL = 0.46
META_BATTLE_MODE_LIST = {
	coop = "tow",
	heritage = "tow",
	abyss = "tow",
	extra_quest = "nor",
	defense = "def",
	defense_quest = "def",
	quest = "nor",
	dungeon_quest = "adv",
	dungeon = "adv",
	trial_hall = "tow",
	stage = "nor"
}
LIMIT_TEAM_RES = {
	soul_piece = 80
}
GET_BATTLE_MODE = {}

setmetatable(GET_BATTLE_MODE, {
	__index = function(arg_1_0, arg_1_1)
		local var_1_0 = tostring(arg_1_1) or "stage"
		
		return META_BATTLE_MODE_LIST[var_1_0] or META_BATTLE_MODE_LIST["0"]
	end
})
