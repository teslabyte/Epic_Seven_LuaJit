ThirdPartySocial = {}
ThirdPartySocial.enable = PLATFORM ~= "win32"

local var_0_0 = {
	{
		"manager_001_02",
		"CggIpearrD8QAhAD",
		"CgkIw9e_x-gfEAIQAg",
		"CgkIw9e_x_gfEAIQAg"
	},
	{
		"manager_008_01",
		"CggIpearrD8QAhAE",
		"CgkIw9e_x-gfEAIQAw",
		"CgkIw9e_x_gfEAIQAw"
	},
	{
		"manager_012_04",
		"CggIpearrD8QAhAF",
		"CgkIw9e_x-gfEAIQBA",
		"CgkIw9e_x_gfEAIQBA"
	},
	{
		"manager_015_03",
		"CggIpearrD8QAhAG",
		"CgkIw9e_x-gfEAIQBQ",
		"CgkIw9e_x_gfEAIQBQ"
	},
	{
		"manager_018_02",
		"CggIpearrD8QAhAH",
		"CgkIw9e_x-gfEAIQBg",
		"CgkIw9e_x_gfEAIQBg"
	},
	{
		"manager_019_01",
		"CggIpearrD8QAhAI",
		"CgkIw9e_x-gfEAIQBw",
		"CgkIw9e_x_gfEAIQBw"
	},
	{
		"sanate_003_01 ",
		"CggIpearrD8QAhAJ",
		"CgkIw9e_x-gfEAIQCA",
		"CgkIw9e_x_gfEAIQCA"
	},
	{
		"merchant_020_02",
		"CggIpearrD8QAhAK",
		"CgkIw9e_x-gfEAIQCQ",
		"CgkIw9e_x_gfEAIQCQ"
	},
	{
		"phantom_002_01",
		"CggIpearrD8QAhAL",
		"CgkIw9e_x-gfEAIQCg",
		"CgkIw9e_x_gfEAIQCg"
	},
	{
		"phantom_003_01",
		"CggIpearrD8QAhAM",
		"CgkIw9e_x-gfEAIQCw",
		"CgkIw9e_x_gfEAIQCw"
	},
	{
		"phantom_005_01",
		"CggIpearrD8QAhAN",
		"CgkIw9e_x-gfEAIQDA",
		"CgkIw9e_x_gfEAIQDA"
	},
	{
		"phantom_009_02",
		"CggIpearrD8QAhAO",
		"CgkIw9e_x-gfEAIQDQ",
		"CgkIw9e_x_gfEAIQDQ"
	},
	{
		"phantom_014_03",
		"CggIpearrD8QAhAP",
		"CgkIw9e_x-gfEAIQDg",
		"CgkIw9e_x_gfEAIQDg"
	},
	{
		"phantom_015_03",
		"CggIpearrD8QAhAQ",
		"CgkIw9e_x-gfEAIQDw",
		"CgkIw9e_x_gfEAIQDw"
	},
	{
		"phantom_016_03",
		"CggIpearrD8QAhAR",
		"CgkIw9e_x-gfEAIQEA",
		"CgkIw9e_x_gfEAIQEA"
	},
	{
		"phantom_017_03",
		"CggIpearrD8QAhAS",
		"CgkIw9e_x-gfEAIQEQ",
		"CgkIw9e_x_gfEAIQEQ"
	},
	{
		"phantom_018_03",
		"CggIpearrD8QAhAT",
		"CgkIw9e_x-gfEAIQEg",
		"CgkIw9e_x_gfEAIQEg"
	},
	{
		"phantom_019_03",
		"CggIpearrD8QAhAU",
		"CgkIw9e_x-gfEAIQEw",
		"CgkIw9e_x_gfEAIQEw"
	},
	{
		"phantom_020_03",
		"CggIpearrD8QAhAV",
		"CgkIw9e_x-gfEAIQFA",
		"CgkIw9e_x_gfEAIQFA"
	},
	{
		"phantom_021_03",
		"CggIpearrD8QAhAW",
		"CgkIw9e_x-gfEAIQFQ",
		"CgkIw9e_x_gfEAIQFQ"
	}
}

function ThirdPartySocial.onSyncThirdPartySocialAchievements(arg_1_0)
	Log.d("ThirdPartySocial", "onSyncThirdPartySocialAchievements ")
	
	if not arg_1_0.enable then
		return 
	end
	
	for iter_1_0, iter_1_1 in pairs(var_0_0) do
		if Account:isClearedAchieve(iter_1_1[1]) then
			ThirdPartySocial:UnlockAchievement(iter_1_0)
		end
	end
end

function onBeforeShowThirdPartySocialAchievements()
	ThirdPartySocial:onSyncThirdPartySocialAchievements()
end

function ThirdPartySocial.ShowAchievements(arg_3_0)
	Log.d("ThirdPartySocial", "Third party ShowAchievements")
	
	if not arg_3_0.enable then
		return 
	end
	
	if show_third_party_social_achievements then
		show_third_party_social_achievements()
	end
end

function ThirdPartySocial.UnlockAchievement(arg_4_0, arg_4_1)
	if not arg_4_0.enable then
		return 
	end
	
	if arg_4_1 == nil then
		return 
	end
	
	Log.d("ThirdPartySocial", "UnlockAchievement: " .. arg_4_1)
	
	if type(arg_4_1) ~= "number" or not (arg_4_1 >= 1) or not (arg_4_1 <= #var_0_0) then
		Log.e("ThirdPartySocial", "유효하지 않은 id: " .. arg_4_1)
		
		return 
	end
	
	if not unlock_third_party_social_achievement then
		return 
	end
	
	local var_4_0 = 2
	
	if getenv("stove.environment") == "live" then
		var_4_0 = IS_ANDROID_BASED_PLATFORM and 3 or 4
	end
	
	Log.d("ThirdPartySocial", "UnlockAchievement: " .. var_0_0[arg_4_1][var_4_0])
	
	return unlock_third_party_social_achievement(var_0_0[arg_4_1][var_4_0])
end
