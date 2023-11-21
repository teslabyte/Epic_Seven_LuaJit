UnitInfosStory = {}

function HANDLER.hero_detail_relationsihp(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_cur" then
		UnitInfosStory:selectGeneration(UnitInfosStory.vars.current_generation, "next")
	elseif arg_1_1 == "btn_pre" then
		UnitInfosStory:selectGeneration(UnitInfosStory.vars.current_generation, "pre")
	end
end

function UnitInfosStory.showDetailPopup(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	if not arg_2_1 or not arg_2_3 then
		return 
	end
	
	RelationPipeLine:showDetailPopup(arg_2_0.vars.slot_info, arg_2_0.vars.slot_req_story, arg_2_1, arg_2_2, arg_2_3, arg_2_4, SceneManager:getCurrentSceneName() ~= "unit_ui")
end

function UnitInfosStory.selectGeneration(arg_3_0, arg_3_1, arg_3_2)
	if arg_3_2 == "next" then
		arg_3_1 = arg_3_1 + 1
	else
		arg_3_1 = arg_3_1 - 1
	end
	
	if arg_3_0.vars.current_generation == arg_3_1 then
		return 
	end
	
	if arg_3_1 > arg_3_0.vars.total_generation then
		return 
	end
	
	arg_3_0.vars.current_generation = arg_3_1
	
	arg_3_0:makeRelationWnd(true)
end

function UnitInfosStory.onSlotTouch(arg_4_0, arg_4_1)
	if arg_4_1 ~= 2 then
		return 
	end
	
	local var_4_0 = string.split(arg_4_0:getName(), "slot_")[2]
	local var_4_1 = UnitInfosStory.vars.slot_info[var_4_0]
	
	if var_4_1.slot_type == "fix" then
		if UIAction:Find("block") then
			return 
		end
		
		if var_4_1.locked then
			UnitStory:showUnlockInfoText(var_4_1)
		else
			UnitInfosStory:showDetailPopup(var_4_1, UnitInfosStory.vars.released_slot[var_4_0], var_4_0)
		end
	else
		balloon_message_with_sound("cant_relation")
	end
end

function UnitInfosStory.makeRelationWnd(arg_5_0, arg_5_1)
	if get_cocos_refid(arg_5_0.vars.relation_wnd) then
		arg_5_0.vars.relation_wnd:removeFromParent()
	end
	
	local var_5_0 = UnitInfosController:getUnit()
	local var_5_1 = var_5_0.db.code
	
	if var_5_0:isMoonlightDestinyUnit() then
		var_5_1 = MoonlightDestiny:getRelationCharacterCode(var_5_1)
	end
	
	RelationPipeLine:start()
	
	if not arg_5_1 then
		arg_5_0.vars.total_generation, arg_5_0.vars.current_generation = RelationPipeLine:getGeneration(var_5_1)
	end
	
	local var_5_2 = RelationPipeLine:makeRelationWnd(var_5_0, arg_5_0.vars.current_generation or 1)
	
	arg_5_0.vars.relation_wnd = var_5_2
	
	var_5_2:setPosition(0, 0)
	RelationPipeLine:setGenerationButton(arg_5_0.vars.dlg, UnitInfosController:getUnit(), RelationPipeLine:getCache("current_id"), arg_5_0.vars.total_generation, arg_5_0.vars.current_generation)
	RelationPipeLine:generateRelationMap(var_5_2, arg_5_0.onSlotTouch)
	
	arg_5_0.vars.slot_info = RelationPipeLine:getCache("slot_info")
	arg_5_0.vars.released_slot = {}
	arg_5_0.vars.slot_req_story = {}
	
	arg_5_0.vars.dlg:findChildByName("pivot"):addChild(var_5_2)
	RelationPipeLine:End()
	
	local var_5_3 = 300
	local var_5_4, var_5_5 = var_5_2:getPosition()
	
	var_5_2:setPosition(var_5_4, var_5_5 + 500)
	arg_5_0.vars.relation_wnd:setOpacity(0)
	UIAction:Add(SPAWN(FADE_IN(var_5_3), LOG(MOVE_TO(var_5_3 - 150, var_5_4, var_5_5))), arg_5_0.vars.relation_wnd, "block")
	
	for iter_5_0, iter_5_1 in pairs(arg_5_0.vars.relation_wnd:getChildren()) do
		if string.starts(iter_5_1:getName(), "new_line_") then
			for iter_5_2, iter_5_3 in pairs(iter_5_1:getChildren()) do
				iter_5_3:setOpacity(0)
				UIAction:Add(SEQ(FADE_IN(var_5_3 + 400)), iter_5_3, "block")
			end
		end
	end
end

function UnitInfosStory.setLeft(arg_6_0)
	UnitInfosUtil:setUnitDetail(arg_6_0.vars.dlg, arg_6_0.vars.left)
end

function UnitInfosStory.heroChangeInStory(arg_7_0, arg_7_1)
	local var_7_0 = SceneManager:getRunningPopupScene():getChildByName("hero_story_fix_detail")
	
	if var_7_0 and get_cocos_refid(var_7_0) then
		var_7_0:removeFromParent()
		BackButtonManager:pop("hero_story_fix_detail")
	end
	
	local var_7_1 = UnitMain:getHeroBelt()
	
	if var_7_1 then
		var_7_1:resetFilter()
		var_7_1:scrollToUnit(arg_7_1, 0)
		var_7_1:updateSelectedControlColor(arg_7_1)
	end
	
	UnitMain:onSelectUnit(arg_7_1)
	UnitMain:movePortrait("Story")
	arg_7_0:setLeft()
	arg_7_0:makeRelationWnd()
end

function UnitInfosStory.onCreate(arg_8_0, arg_8_1)
	arg_8_0.vars = {}
	arg_8_0.vars.dlg = load_dlg("hero_detail_relationsihp", true, "wnd")
	arg_8_0.vars.left = arg_8_0.vars.dlg:findChildByName("LEFT")
	
	if not get_cocos_refid(arg_8_0.vars.dim_layer) then
		arg_8_0.vars.dim_layer = cc.LayerColor:create(cc.c3b(0, 0, 0))
		
		arg_8_0.vars.dlg:addChild(arg_8_0.vars.dim_layer)
		arg_8_0.vars.dim_layer:setPosition(VIEW_BASE_LEFT, 0)
		arg_8_0.vars.dim_layer:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
		arg_8_0.vars.dim_layer:setOpacity(0)
		arg_8_0.vars.dim_layer:sendToBack()
	end
	
	if_set_opacity(arg_8_0.vars.left, nil, 0)
	UIAction:Add(SEQ(SLIDE_IN(200, 600)), arg_8_0.vars.left, "block")
	UIAction:Add(SEQ(LOG(OPACITY(400, 0, 0.82))), arg_8_0.vars.dim_layer, "block")
	UnitMain:movePortrait("Story")
	arg_8_0:setLeft()
	arg_8_0:makeRelationWnd()
	arg_8_1:addChild(arg_8_0.vars.dlg)
end

function UnitInfosStory.onLeave(arg_9_0)
	if not arg_9_0.vars then
		return 
	end
	
	if_set_visible(arg_9_0.vars.dlg, "pivot", false)
	if_set_visible(arg_9_0.vars.dlg, "name", false)
	UIAction:Add(SEQ(FADE_OUT(400), REMOVE()), arg_9_0.vars.dlg, "block")
	
	arg_9_0.vars = nil
end
