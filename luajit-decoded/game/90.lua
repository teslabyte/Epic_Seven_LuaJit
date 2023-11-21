NewChapterNavigator = NewChapterNavigator or {}
NewChapterNavigator.new_chapters = {}

local var_0_0 = {}
local var_0_1 = "checked_new_chapter_ids"

local function var_0_2(arg_1_0, arg_1_1)
	if not arg_1_0.chapter then
		return false
	end
	
	if arg_1_1.type and arg_1_1.type ~= arg_1_0.type then
		return false
	end
	
	if arg_1_1.continent == arg_1_0.continent then
		return true
	end
	
	if arg_1_1.chapter == arg_1_0.chapter then
		return true
	end
	
	return false
end

local function var_0_3(arg_2_0)
	local var_2_0 = Account:getConfigData(var_0_1) or {}
	
	for iter_2_0, iter_2_1 in pairs(var_2_0) do
		if arg_2_0.chapter == iter_2_1 then
			return true
		end
	end
	
	return false
end

local function var_0_4(arg_3_0)
	local var_3_0 = {}
	
	for iter_3_0, iter_3_1 in pairs(arg_3_0) do
		if not var_0_3(iter_3_1) then
			table.insert(var_3_0, iter_3_1)
		end
	end
	
	return var_3_0
end

local function var_0_5(arg_4_0)
	local var_4_0 = {}
	
	for iter_4_0, iter_4_1 in pairs(arg_4_0) do
		local var_4_1 = var_0_0[iter_4_1.continent]
		
		if var_4_1 and Account:checkEnterMap(var_4_1 .. "001") then
			table.insert(var_4_0, iter_4_1)
		end
	end
	
	return var_4_0
end

local function var_0_6(arg_5_0)
	local var_5_0 = Account:getConfigData(var_0_1) or {}
	
	for iter_5_0, iter_5_1 in pairs(arg_5_0) do
		table.deleteByValue(var_5_0, iter_5_1)
	end
	
	SAVE:setTempConfigData(var_0_1, var_5_0)
end

local function var_0_7(arg_6_0)
	NewChapterNavigator.new_chapters = {}
	
	local var_6_0 = {}
	
	for iter_6_0 = 1, 9999 do
		local var_6_1, var_6_2, var_6_3, var_6_4, var_6_5 = DBN("level_world_1_world", iter_6_0, {
			"id",
			"type",
			"key_continent",
			"default_chapter",
			"update_date"
		})
		
		if not var_6_1 then
			break
		end
		
		if var_6_5 and var_6_3 and var_6_4 then
			if arg_6_0 <= var_6_5 then
				table.insert(NewChapterNavigator.new_chapters, {
					type = "episode",
					continent = var_6_3,
					chapter = var_6_4
				})
			else
				table.insert(var_6_0, var_6_4)
			end
		end
		
		if var_6_2 == "adventure" and var_6_3 then
			var_0_0[var_6_3] = var_6_4
		end
	end
	
	for iter_6_1 = 1, 9999 do
		local var_6_6, var_6_7, var_6_8 = DBN("level_world_2_continent", iter_6_1, {
			"id",
			"key_normal",
			"update_date"
		})
		
		if not var_6_6 then
			break
		end
		
		if var_6_8 and var_6_7 then
			if arg_6_0 <= var_6_8 then
				local var_6_9 = string.sub(var_6_6, 1, -4)
				
				table.insert(NewChapterNavigator.new_chapters, {
					default_chpater = "",
					type = "chapter",
					continent = var_6_9,
					chapter = var_6_7
				})
			else
				table.insert(var_6_0, var_6_7)
			end
		end
	end
	
	var_0_6(var_6_0)
end

function NewChapterNavigator.check(arg_7_0, arg_7_1)
	local var_7_0 = false
	
	for iter_7_0, iter_7_1 in pairs(arg_7_0.new_chapters) do
		if arg_7_1 == iter_7_1.chapter then
			var_7_0 = true
			
			break
		end
	end
	
	if not var_7_0 then
		return 
	end
	
	local var_7_1 = Account:getConfigData(var_0_1) or {}
	
	if table.find(var_7_1, arg_7_1) then
		return 
	end
	
	table.insert(var_7_1, arg_7_1)
	SAVE:setTempConfigData(var_0_1, var_7_1)
end

local var_0_8 = false

function NewChapterNavigator.isNew(arg_8_0, arg_8_1)
	if not var_0_8 then
		var_0_8 = true
		
		var_0_7(tonumber(os.date("%y%m%d")))
	end
	
	if tolua.type(arg_8_0.new_chapters) ~= "table" then
		Log.e("NewChapterNavigator", "new_chapters 가 유효한 형식의 데이타가 아닙니다.", arg_8_0.new_chapters)
		
		return false
	end
	
	local var_8_0 = arg_8_0.new_chapters
	local var_8_1 = var_0_4(var_8_0)
	local var_8_2 = var_0_5(var_8_1)
	
	if table.empty(var_8_2) then
		return false
	end
	
	if arg_8_1 == nil and not table.empty(var_8_2) then
		return true
	end
	
	for iter_8_0, iter_8_1 in pairs(var_8_2) do
		if var_0_2(iter_8_1, arg_8_1) then
			return true
		end
	end
	
	return false
end

local function var_0_9(arg_9_0, arg_9_1)
	if string.ends(arg_9_1, ".cfx") then
		return EffectManager:Play({
			fn = arg_9_1,
			layer = arg_9_0
		})
	end
	
	if string.ends(arg_9_1, ".png") then
		local var_9_0 = cc.Sprite:create(arg_9_1)
		
		if get_cocos_refid(var_9_0) then
			arg_9_0:addChild(var_9_0)
			
			return var_9_0
		end
	end
	
	return nil
end

function NewChapterNavigator.attachIndicator(arg_10_0, arg_10_1, arg_10_2)
	if not get_cocos_refid(arg_10_1) then
		Log.e("NewChapterNavigator", "attachIndicator의 n_target이 유효하지 않습니다.")
		
		return 
	end
	
	local var_10_0 = var_0_9(arg_10_1, arg_10_2.resource_path or "img/shop_icon_new.png")
	
	if not var_10_0 then
		return 
	end
	
	var_10_0:setName(arg_10_2.name or "indicator")
	
	if arg_10_2.anchor then
		var_10_0:setAnchorPoint(arg_10_2.anchor.x, arg_10_2.anchor.y)
	end
	
	if arg_10_2.pos then
		var_10_0:setPosition(arg_10_2.pos.x, arg_10_2.pos.y)
	end
	
	if arg_10_2.scale then
		var_10_0:setScale(arg_10_2.scale)
	end
	
	var_10_0:setRotation(-calcWorldRotation(var_10_0))
	var_10_0:bringToFront()
	var_10_0:setCascadeOpacityEnabled(false)
	
	return var_10_0
end

function NewChapterNavigator.__init(arg_11_0, arg_11_1)
	if PRODUCTION_MODE then
		return 
	end
	
	print("NewChapterNavigator cheat: today ", arg_11_1)
	var_0_7(arg_11_1)
end

function NewChapterNavigator.__clearCheckedIDs(arg_12_0)
	if PRODUCTION_MODE then
		return 
	end
	
	print("NewChapterNavigator cheat: clear checked IDs")
	SAVE:setTempConfigData(var_0_1, {})
	SAVE:sendQueryServerConfig()
end

function NewChapterNavigator.__aw(arg_13_0, arg_13_1)
	if PRODUCTION_MODE then
		return 
	end
	
	print("NewChapterNavigator cheat: attach world new")
	
	arg_13_1 = arg_13_1 or {
		pos = {
			x = 0,
			y = 0
		}
	}
	
	local function var_13_0(arg_14_0)
		if not (arg_14_0:getName() == "indicator") then
			return 
		end
		
		arg_14_0:removeFromParent()
		
		arg_14_0 = nil
	end
	
	__call_node_tree(SceneManager:getRunningRootScene(), -1, var_13_0)
	
	if arg_13_1.name then
		local var_13_1 = SceneManager:getRunningRootScene():getChildByName(arg_13_1.name)
		
		if get_cocos_refid(var_13_1) then
			local var_13_2 = var_13_1:getChildByName("label_name")
			
			arg_13_1.pos = {
				x = var_13_2:getContentSize().width + arg_13_1.pos.x,
				y = arg_13_1.pos.y
			}
			
			arg_13_0:attachIndicator(var_13_2, arg_13_1)
		end
		
		return 
	end
	
	local function var_13_3(arg_15_0)
		if not (arg_15_0:getName():find("world_name_%w%w%w") or arg_15_0:getName():find("level_word_%d_name_%d")) then
			return 
		end
		
		print(arg_15_0:getName())
		
		local var_15_0 = arg_15_0:getChildByName("label_name")
		
		arg_13_0:attachIndicator(var_15_0, {
			anchor = arg_13_1.anchor,
			pos = {
				x = var_15_0:getContentSize().width + arg_13_1.pos.x,
				y = arg_13_1.pos.y
			},
			scale = arg_13_1.scale
		})
	end
	
	__call_node_tree(SceneManager:getRunningRootScene(), -1, var_13_3)
end
