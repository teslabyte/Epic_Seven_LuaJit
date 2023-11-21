CharPreviewUtil = {}
CharPreviewUtil.COMMON_PART_TIME = 5000
CharPreviewUtil.ENDING_PART_TIME = 3000

function CharPreviewUtil.getSkillIcon(arg_1_0, arg_1_1)
	local var_1_0 = cc.CSLoader:createNode("wnd/skill_icon.csb")
	
	SpriteCache:resetSprite(var_1_0:getChildByName("icon"), "skill/" .. arg_1_1.sk_icon .. ".png")
	if_set_visible(var_1_0, "soul" .. math.floor(to_n(arg_1_1.soul_req) / GAME_STATIC_VARIABLE.max_soul_point) + 1, false)
	if_set_visible(var_1_0, "upgrade_passive", false)
	if_set_visible(var_1_0, "upgrade", false)
	if_set_visible(var_1_0, "exclusive", false)
	var_1_0:setAnchorPoint(0.5, 0.5)
	
	return var_1_0
end

function CharPreviewUtil.SetDBData(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	arg_2_1.char = arg_2_2
	arg_2_1.start_intro = arg_2_3 or arg_2_1.start_intro
	arg_2_1.end_intro = arg_2_4 or arg_2_1.end_intro
	arg_2_1.stage_bg = arg_2_5 or arg_2_1.stage_bg
	arg_2_1.summary_bg = arg_2_6 or arg_2_1.summary_bg
	arg_2_1.sort = table.count(arg_2_0.vars.native_lunch_data)
	
	return arg_2_1
end

function CharPreviewUtil.AddDataFromDB(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_0.vars = arg_3_0.vars or {}
	arg_3_0.vars.native_lunch_data = arg_3_0.vars.native_lunch_data or {}
	
	local var_3_0 = "intro_" .. arg_3_1
	local var_3_1 = DBT("char_intro", var_3_0, {
		"id",
		"char",
		"char_gender",
		"skin",
		"sort",
		"tag",
		"sound",
		"stage_bg",
		"summary_bg",
		"back1",
		"back2",
		"back3",
		"front1",
		"front2",
		"front3",
		"start_intro",
		"end_intro",
		"skill_number"
	})
	local var_3_2 = arg_3_0:SetDBData(var_3_1, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	
	arg_3_0.vars.native_lunch_data[var_3_0] = var_3_2
	
	return arg_3_0.vars.native_lunch_data
end

DEBUG.IGNORE_TIME = nil
DEBUG.IGNORE_ACCOUNT_DATA = nil
DEBUG.IGNORE_MAX = nil

if not PRODUCTION_MODE then
	CharPreviewDebug = {}
	
	function CharPreviewDebug.ignoreAll(arg_4_0)
		DEBUG.IGNORE_TIME = true
		DEBUG.IGNORE_ACCOUNT_DATA = true
		DEBUG.IGNORE_MAX = true
	end
	
	function CharPreviewDebug.ignoreAccountData(arg_5_0)
		DEBUG.IGNORE_ACCOUNT_DATA = true
	end
	
	function CharPreviewDebug.clearSaveData(arg_6_0)
		for iter_6_0, iter_6_1 in pairs(Account:getConfigDatas()) do
			if string.starts(iter_6_0, "intro_") then
				iter_6_1 = "null"
				
				SAVE:setTempConfigData(iter_6_0, iter_6_1)
			end
		end
		
		SAVE:sendQueryServerConfig()
	end
	
	function CharPreviewDebug.showSaveData(arg_7_0)
		for iter_7_0, iter_7_1 in pairs(Account:getConfigDatas()) do
			if string.starts(iter_7_0, "intro_") then
				print(iter_7_0, iter_7_1)
			end
		end
	end
	
	function CharPreviewDebug.changeSaveData(arg_8_0, arg_8_1)
		local var_8_0 = Account:getConfigDatas()["intro_" .. arg_8_1]
		
		if not var_8_0 then
			Log.e("WRONG CODE!")
			
			return 
		end
		
		local var_8_1 = var_8_0 - 1
		
		SAVE:setTempConfigData("intro_" .. arg_8_1, var_8_1)
		SAVE:sendQueryServerConfig()
	end
	
	function CharPreviewDebug.ignoreTime(arg_9_0)
		DEBUG.IGNORE_TIME = true
		DEBUG.IGNORE_ACCOUNT_DATA = true
	end
	
	DEBUG_PREVIEW_PRELOAD_DB = {}
	
	function CharPreviewDebug.ModData(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6)
		local var_10_0 = "intro_" .. arg_10_1
		
		if DEBUG_PREVIEW_PRELOAD_DB[var_10_0] then
			local var_10_1 = DEBUG_PREVIEW_PRELOAD_DB[var_10_0]
			
			var_10_1.start_intro = arg_10_2 or var_10_1.start_intro
			var_10_1.end_intro = arg_10_3 or var_10_1.end_intro
			var_10_1.stage_bg = arg_10_4 or var_10_1.stage_bg
			var_10_1.summary_bg = arg_10_5 or var_10_1.summary_bg
			var_10_1.sort = arg_10_6 or var_10_1.sort
			DEBUG_PREVIEW_PRELOAD_DB[var_10_0] = var_10_1
		else
			Log.e("NOT EXIST IN DB!")
		end
	end
	
	function CharPreviewDebug.MakeDB(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6)
		return {
			front3 = "slime_i_n",
			front2 = "slime_i_n",
			back3 = "slime_i_n",
			front1 = "slime_i_n",
			back2 = "slime_i_n",
			back1 = "slime_i_n",
			char_gender = "f",
			end_intro = arg_11_4,
			start_intro = arg_11_3,
			stage_bg = arg_11_5,
			summary_bg = arg_11_6,
			char = arg_11_2,
			id = arg_11_1,
			sort = table.count(DEBUG_PREVIEW_PRELOAD_DB)
		}
	end
	
	function CharPreviewDebug.SetDBData(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
		arg_12_1.char = arg_12_2
		arg_12_1.start_intro = arg_12_3 or arg_12_1.start_intro
		arg_12_1.end_intro = arg_12_4 or arg_12_1.end_intro
		arg_12_1.stage_bg = arg_12_5 or arg_12_1.stage_bg
		arg_12_1.summary_bg = arg_12_6 or arg_12_1.summary_bg
		arg_12_1.sort = table.count(DEBUG_PREVIEW_PRELOAD_DB)
		
		return arg_12_1
	end
	
	function CharPreviewDebug.AddData(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
		local var_13_0 = "intro_" .. arg_13_1
		
		arg_13_4 = arg_13_4 or "tireil_2_holy"
		arg_13_5 = arg_13_5 or "castle2"
		
		local var_13_1 = arg_13_0:MakeDB(var_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
		
		DEBUG_PREVIEW_PRELOAD_DB[var_13_0] = var_13_1
	end
	
	function CharPreviewDebug.AddDataFromDB(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
		local var_14_0 = "intro_" .. arg_14_1
		local var_14_1 = DBT("char_intro", var_14_0, {
			"id",
			"char",
			"char_gender",
			"skin",
			"sort",
			"tag",
			"sound",
			"stage_bg",
			"summary_bg",
			"back1",
			"back2",
			"back3",
			"front1",
			"front2",
			"front3",
			"start_intro",
			"end_intro",
			"skill_number"
		})
		local var_14_2 = arg_14_0:SetDBData(var_14_1, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
		
		DEBUG_PREVIEW_PRELOAD_DB[var_14_0] = var_14_2
	end
	
	function CharPreviewDebug.AddSkin(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6)
		local var_15_0 = "intro_" .. arg_15_1
		
		arg_15_5 = arg_15_5 or "tireil_2_holy"
		arg_15_6 = arg_15_6 or "castle2"
		
		local var_15_1 = arg_15_0:MakeDB(var_15_0, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6)
		
		var_15_1.skin = arg_15_1
		DEBUG_PREVIEW_PRELOAD_DB[var_15_0] = var_15_1
	end
	
	function CharPreviewDebug.AddSkinFromDB(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6)
		local var_16_0 = "intro_" .. arg_16_1
		local var_16_1 = DBT("char_intro", var_16_0, {
			"id",
			"char",
			"char_gender",
			"skin",
			"sort",
			"tag",
			"sound",
			"stage_bg",
			"summary_bg",
			"back1",
			"back2",
			"back3",
			"front1",
			"front2",
			"front3",
			"start_intro",
			"end_intro",
			"skill_number"
		})
		local var_16_2 = arg_16_0:SetDBData(var_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6)
		
		var_16_2.skin = arg_16_1
		DEBUG_PREVIEW_PRELOAD_DB[var_16_0] = var_16_2
	end
	
	function CharPreviewDebug.ClearData()
		DEBUG_PREVIEW_PRELOAD_DB = {}
	end
	
	function CharPreviewDebug.StartTestData(arg_18_0)
		CharPreviewController:d_init(DEBUG_PREVIEW_PRELOAD_DB)
	end
	
	function CharPreviewDebug.StarCharacterAttributeChangeCinematic(arg_19_0, arg_19_1)
		CharPreviewController:d_init(DEBUG_PREVIEW_PRELOAD_DB)
	end
	
	function CharPreviewDebug.StartAttributeChangeCinematic(arg_20_0)
		CharPreviewController:native_scene_init(DEBUG_PREVIEW_PRELOAD_DB)
	end
	
	CPD = CharPreviewDebug
end
