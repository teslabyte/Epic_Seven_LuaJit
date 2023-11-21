CollectionPetList = {}

copy_functions(CollectionListBase, CollectionPetList)

function CollectionPetList.onItemUpdate(arg_1_0, arg_1_1, arg_1_2)
	if_set_visible(arg_1_1, "n_unit_card", false)
	if_set_visible(arg_1_1, "n_arti_card", false)
	if_set_visible(arg_1_1, "n_pet_card", true)
	
	local var_1_0, var_1_1, var_1_2, var_1_3 = DB("pet_character", arg_1_2.id, {
		"name",
		"type",
		"feature",
		"face_1"
	})
	local var_1_4 = arg_1_1:getChildByName("n_pet_card")
	local var_1_5 = UIUtil:getTypeIconPath(var_1_1, var_1_2)
	
	arg_1_0:_if_not_blank(var_1_4, "role", var_1_5)
	arg_1_0:_if_not_blank(var_1_4, "face", "face/", var_1_3, "_s.png")
	if_set_visible(var_1_4, "n_stars", false)
	
	local var_1_6 = var_1_4:getChildByName("txt_name")
	
	if not get_cocos_refid(var_1_6) then
		return 
	end
	
	local var_1_7 = get_word_wrapped_name(var_1_6, T(var_1_0))
	
	if_set_scale_fit_width_long_word(var_1_6, nil, var_1_7, 180)
	
	if not Account:getCollectionPet(arg_1_2.id) then
		if_set_color(arg_1_1, nil, cc.c3b(136, 136, 136))
	end
	
	arg_1_0:_setMetadata(arg_1_1, "btn_select", arg_1_2.id, "pet", arg_1_2)
	
	if arg_1_0.SHOW_CHAR_CODE then
		if_set_scale_fit_width_long_word(var_1_6, nil, var_1_7 .. "\n" .. arg_1_2.id, 180)
	end
end

function CollectionPetList.initPetDB(arg_2_0, arg_2_1)
	arg_2_0.vars.type_db = {}
	arg_2_0.vars.count_db = {}
	
	arg_2_0:makeParentDB(arg_2_1, arg_2_0.vars.type_db, arg_2_0.vars.count_db, function(arg_3_0)
		return Account:getCollectionPet(arg_3_0.id)
	end, {
		all_db_name = "pet1",
		make_all_db = true
	})
end

function CollectionPetList.getPureDB(arg_4_0, arg_4_1)
	if not arg_4_0.vars then
		return 
	end
	
	if not arg_4_0.vars.pure_db then
		Log.e("PURE DB Was NIL")
		
		return 
	end
	
	return arg_4_0.vars.pure_db
end

function CollectionPetList.init(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0.vars = {}
	arg_5_0.vars.pure_db = arg_5_2
	
	arg_5_0:initPetDB(arg_5_1)
end

function CollectionPetList.open(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if not arg_6_0.vars then
		return 
	end
	
	local var_6_0 = {
		onUpdate = function(arg_7_0, arg_7_1, arg_7_2)
			arg_6_0:onItemUpdate(arg_7_1, arg_7_2)
		end
	}
	local var_6_1
	local var_6_2
	local var_6_3 = arg_6_0.vars.type_db
	local var_6_4 = arg_6_0.vars.count_db
	
	arg_6_0.vars.db_type = "p"
	
	arg_6_0:listBaseInit(arg_6_1, arg_6_2, var_6_3, var_6_4, var_6_0, nil, {
		on_conflict_sort_bonus = {
			pet1 = {
				pet3 = 2,
				pet2 = 0
			}
		}
	})
	
	arg_6_0.vars.scrollview = arg_6_2
end

function CollectionPetList.search(arg_8_0, arg_8_1)
	if arg_8_1 == nil or arg_8_1 == "" then
		return false
	end
	
	local var_8_0 = arg_8_0:getPureDB(arg_8_0.vars.mode)
	local var_8_1 = arg_8_0:_search(var_8_0, arg_8_1, "pet_character", "name", nil)
	
	arg_8_0:setCurrentDB(var_8_1)
	
	return true
end
