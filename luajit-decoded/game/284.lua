CollectionMonsterList = {}

copy_functions(CollectionListBase, CollectionMonsterList)

function CollectionMonsterList.onItemUpdate(arg_1_0, arg_1_1, arg_1_2)
	if_set_visible(arg_1_1, "n_unit_card", true)
	if_set_visible(arg_1_1, "n_arti_card", false)
	
	local var_1_0, var_1_1, var_1_2, var_1_3, var_1_4, var_1_5, var_1_6 = DB("character", arg_1_2.id, {
		"face_id",
		"name",
		"monster_tier",
		"ch_attribute",
		"role",
		"grade",
		"type"
	})
	
	arg_1_0:_if_not_blank(arg_1_1, "role", "img/cm_icon_role_", var_1_4, ".png")
	arg_1_0:_if_not_blank(arg_1_1, "element", "img/cm_icon_pro", var_1_3, ".png")
	arg_1_0:_if_not_blank(arg_1_1, "face", "face/", var_1_0, "_s.png")
	arg_1_0:_setIconStar(arg_1_1, var_1_5)
	
	local var_1_7 = arg_1_1:getChildByName("txt_name")
	
	if not get_cocos_refid(var_1_7) then
		return 
	end
	
	local var_1_8 = get_word_wrapped_name(var_1_7, T(var_1_1))
	
	if_set_scale_fit_width_long_word(var_1_7, nil, var_1_8, 180)
	arg_1_0:_setMetadata(arg_1_1, "btn_select", arg_1_2.id, "unit", arg_1_2)
	
	if arg_1_0.SHOW_CHAR_CODE then
		if_set_scale_fit_width_long_word(var_1_7, nil, var_1_8 .. "\n" .. arg_1_2.id, 180)
	end
end

function CollectionMonsterList.getPureDB(arg_2_0, arg_2_1)
	if not arg_2_0.vars then
		return 
	end
	
	if not arg_2_0.vars.monster.pure_DB then
		Log.e("PURE DB Was NIL")
		
		return 
	end
	
	return arg_2_0.vars.monster.pure_DB
end

function CollectionMonsterList.init(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.vars = {}
	arg_3_0.vars.monster = {}
	arg_3_0.vars.monster.pure_DB = arg_3_2
	
	arg_3_0:initMonsterDB(arg_3_1)
	
	local var_3_0 = {}
	
	for iter_3_0, iter_3_1 in pairs(CollectionUtil.ROLE_COMP_TO_KEY_DATA_STRING) do
		var_3_0[iter_3_0] = iter_3_1
	end
	
	var_3_0.all = "ui_hero_role_all"
	
	arg_3_0:addTextKeys(var_3_0, "sort")
end

function CollectionMonsterList.open(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	if not arg_4_0.vars then
		return 
	end
	
	arg_4_0.vars.mode = arg_4_3.mode
	arg_4_0.vars.isAscending = false
	
	local var_4_0 = {
		onUpdate = function(arg_5_0, arg_5_1, arg_5_2)
			arg_4_0:onItemUpdate(arg_5_1, arg_5_2)
		end
	}
	local var_4_1
	local var_4_2
	local var_4_3
	local var_4_4 = arg_4_0.vars.monster.story_DB
	local var_4_5 = arg_4_0.vars.monster.count_db
	local var_4_6 = "monster1"
	
	arg_4_0.vars.db_type = "m"
	
	arg_4_0:listBaseInit(arg_4_1, arg_4_2, var_4_4, var_4_5, var_4_0)
	
	arg_4_0.vars.scrollview = arg_4_2
end

function CollectionMonsterList.initMonsterDB(arg_6_0, arg_6_1)
	arg_6_0.vars.monster.story_DB = {}
	arg_6_0.vars.monster.count_db = {}
	
	arg_6_0:makeParentDB(arg_6_1, arg_6_0.vars.monster.story_DB, arg_6_0.vars.monster.count_db)
end

function CollectionMonsterList.search(arg_7_0, arg_7_1)
	if arg_7_1 == nil or arg_7_1 == "" then
		return false
	end
	
	local var_7_0 = arg_7_0:getPureDB(arg_7_0.vars.mode)
	local var_7_1 = arg_7_0:_search(var_7_0, arg_7_1, "character", "name", nil)
	
	arg_7_0:setCurrentDB(var_7_1)
	
	return true
end
