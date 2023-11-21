if not PRODUCTION_MODE then
	Scene.debug = SceneHandler:create("debug", 1280, 720)
	
	local function var_0_0(arg_1_0)
		local var_1_0 = Account.equips[13]
		
		arg_1_0:addChild(ItemTooltip:getItemTooltip({
			code = "to_gold",
			x = 20,
			y = 20
		}))
		arg_1_0:addChild(ItemTooltip:getItemTooltip({
			code = "to_honor",
			x = 420,
			y = 20
		}))
		arg_1_0:addChild(ItemTooltip:getItemTooltip({
			code = "to_stamina",
			x = 820,
			y = 20
		}))
		
		local var_1_1 = Account.equips[13]
		
		arg_1_0:addChild(ItemTooltip:getItemTooltip({
			x = 20,
			y = 280,
			code = var_1_1.code,
			equip = var_1_1
		}))
		
		local var_1_2 = Account.equips[2]
		
		arg_1_0:addChild(ItemTooltip:getItemTooltip({
			x = 420,
			y = 280,
			code = var_1_2.code,
			equip = var_1_2
		}))
		arg_1_0:addChild(ItemTooltip:getItemTooltip({
			set_drop = "set_mase_ije",
			x = 820,
			y = 280,
			code = Account.equips[1].code
		}))
	end
	
	local function var_0_1(arg_2_0)
		local var_2_0
		local var_2_1 = load_dlg("story", true, "wnd")
		
		arg_2_0:addChild(var_2_1)
		var_2_1:setName("test_dialog")
		var_2_1:getChildByName("n_monologue"):removeFromParent()
		upgradeLabelToRichLabel(var_2_1, "txt_info"):setString("아무튼 서두르자고.\n성약의 계승자, <#ff0000>라스 엘클레어</>님")
	end
	
	function onResizeControlChild(arg_3_0, arg_3_1)
	end
	
	function resizeControl(arg_4_0, arg_4_1, arg_4_2)
		local var_4_0 = arg_4_1 - arg_4_0:getContentSize().width
	end
	
	local function var_0_2(arg_5_0)
		ChatMain:show(arg_5_0)
	end
	
	local function var_0_3(arg_6_0)
		local var_6_0 = load_control("wnd/archievement_item.csb")
		
		var_6_0:setAnchorPoint(0.5, 0.5)
		var_6_0:setPosition(640, 400)
		arg_6_0:addChild(var_6_0)
		
		local var_6_1 = load_control("wnd/archievement_item.csb")
		local var_6_2 = var_6_1:getChildByName("btn_go")
		local var_6_3 = var_6_1:getContentSize()
		
		var_6_1:setAnchorPoint(0.5, 0.5)
		var_6_1:setPosition(640, 180)
		resetControlPosAndSize(var_6_1, var_6_3.width + 200, var_6_3.width, true)
		arg_6_0:addChild(var_6_1)
	end
	
	local var_0_4 = {}
	
	local function var_0_5(arg_7_0)
		local var_7_0 = {
			{
				2000,
				2000,
				1000,
				1000
			},
			{
				1000,
				2000,
				500,
				1000
			},
			{
				500,
				2000,
				500,
				1000
			},
			{
				500,
				2000
			}
		}
		local var_7_1 = {
			106,
			102,
			104,
			202,
			203
		}
		
		for iter_7_0, iter_7_1 in pairs(Account.units) do
			if iter_7_0 <= 4 then
				iter_7_1.states:clear()
				
				if var_7_0[iter_7_0] then
					if var_7_0[iter_7_0][3] then
						local var_7_2, var_7_3 = iter_7_1:addState("106", 1, iter_7_1)
						
						var_7_3.value = var_7_0[iter_7_0][3]
						var_7_3.start_value = var_7_0[iter_7_0][4]
					end
					
					iter_7_1.inst.hp = var_7_0[iter_7_0][1]
					iter_7_1.status.max_hp = var_7_0[iter_7_0][2]
				else
					for iter_7_2 = 0, math.random(1, 5) do
						local var_7_4 = var_7_1[math.random(1, 10)]
						
						iter_7_1:addState(tostring(var_7_4), 1, iter_7_1)
					end
					
					iter_7_1:calc()
				end
				
				local var_7_5 = HPBar:create(iter_7_1)
				
				var_7_5:updateState()
				
				local var_7_6 = 100 + 220 * math.floor((iter_7_0 - 1) / 5)
				local var_7_7 = 100 + 130 * ((iter_7_0 - 1) % 5)
				
				var_7_5.control:setPosition(var_7_6 + iter_7_0 % 10 + 0.3, var_7_7)
				arg_7_0:addChild(var_7_5.control)
				table.push(var_0_4, var_7_5)
			end
		end
	end
	
	function DEBUG_TEST_HP_BAR(arg_8_0)
		local var_8_0 = math.floor(var_0_4[1].owner.status.max_hp * 0.4)
		local var_8_1 = math.min(var_0_4[1].owner.inst.hp - 1, var_8_0)
		
		var_0_4[1].owner:decHP({}, var_8_1)
		var_0_4[1]:setHP(arg_8_0)
		var_0_4[1]:updateState()
	end
	
	local function var_0_6(arg_9_0)
		local var_9_0 = cc.Layer:create()
		
		arg_9_0:addChild(var_9_0)
		ShopBuyAgeBase:show(var_9_0)
	end
	
	local function var_0_7(arg_10_0, arg_10_1)
		local var_10_0 = cc.Layer:create()
		
		arg_10_0:addChild(var_10_0)
		CollectionNewHero:show(var_10_0, arg_10_1)
	end
	
	local function var_0_8(arg_11_0)
		local var_11_0 = HeroBelt:create()
		
		arg_11_0:addChild(var_11_0.wnd)
	end
	
	local function var_0_9(arg_12_0)
		Inventory:open(arg_12_0, {
			main_tab = 1
		})
		TopBarNew:create("1", arg_12_0)
	end
	
	local function var_0_10(arg_13_0)
		UnitEquip:OpenPopup(Account.units[1], 1)
	end
	
	local function var_0_11(arg_14_0)
		local var_14_0
		local var_14_1 = UNIT:create({
			code = "c1048"
		})
		local var_14_2 = UIUtil:getSkillTooltip(var_14_1, 1, {
			show_effs = true
		})
		
		var_14_2:setPosition(50, 20)
		arg_14_0:addChild(var_14_2)
		
		local var_14_3 = UIUtil:getSkillTooltip(var_14_1, 2, {
			show_effs = "left"
		})
		
		var_14_3:setPosition(760, 20)
		arg_14_0:addChild(var_14_3)
		
		local var_14_4 = UIUtil:getSkillTooltip(var_14_1, 3, {
			hide_stat = true
		})
		
		var_14_4:setPosition(50, 460)
		arg_14_0:addChild(var_14_4)
	end
	
	local function var_0_12(arg_15_0)
		local var_15_0 = math.random(4, 12)
		local var_15_1 = {}
		
		for iter_15_0 = 1, var_15_0 do
			table.push(var_15_1, {
				count = 30,
				token = "to_crystal"
			})
		end
		
		var_15_1[1] = {
			unit = Account.units[1]
		}
		var_15_1[2] = {
			equip = Account.equips[math.random(1, #Account.equips)]
		}
		var_15_1[3] = {
			equip = Account.equips[math.random(1, #Account.equips)]
		}
		var_15_1[4] = {
			equip = Account.equips[math.random(1, #Account.equips)]
		}
		
		Dialog:msgRewards(T("abyss_clear_desc"), {
			rewards = var_15_1,
			title = T("abyss_clear_title"),
			handler = var_0_12
		})
	end
	
	local function var_0_13(arg_16_0)
		Bistro:show(arg_16_0)
	end
	
	local function var_0_14(arg_17_0)
		Bistro:show(arg_17_0)
	end
	
	local function var_0_15(arg_18_0)
		SubTask:show(arg_18_0)
	end
	
	local function var_0_16(arg_19_0)
		local var_19_0 = {
			{
				"eq_swd001",
				1
			},
			{
				"sp_gacha35",
				1
			},
			{
				"sp_gacha12",
				5,
				{
					count = 3
				}
			},
			{
				"sp_1001000001",
				1
			},
			{
				"eq_art002",
				1
			},
			{
				"eq",
				1,
				{
					show_name = true,
					equip = Account.equips[1]
				}
			},
			{
				"eq",
				1,
				{
					show_name = true,
					equip = Account.equips[2]
				}
			}
		}
		
		for iter_19_0, iter_19_1 in pairs(var_19_0) do
			local var_19_1 = UIUtil:getRewardIcon(iter_19_1[2], iter_19_1[1], iter_19_1[3])
			local var_19_2 = 80
			
			var_19_1:setPosition(80, var_19_2 + (iter_19_0 - 1) * 100)
			arg_19_0:addChild(var_19_1)
		end
	end
	
	local function var_0_17(arg_20_0)
		function focus(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
			local var_21_0, var_21_1, var_21_2, var_21_3, var_21_4 = DB("character", arg_21_0, {
				"model_id",
				"model_code",
				"scale",
				"skin",
				"atlas"
			})
			local var_21_5 = CACHE:getModel(var_21_0, var_21_3)
			
			var_21_5:setPosition(arg_21_2, arg_21_3)
			arg_21_1:addChild(var_21_5)
			var_21_5:setAnimation(0, "b_idle", true)
			
			do return Battle:setFocusRing(var_21_5, SpriteCache:getSprite("focus.png")) end
			
			Action:Poll(Action.List)
			
			local var_21_6 = var_21_5:getAttachmentBoundingBox("turn_box", "turn_box")
			local var_21_7 = cc.Sprite:create("img/_white.png")
			local var_21_8 = var_21_7:getContentSize()
			
			var_21_7:setColor(cc.c3b(50, 255, 50))
			var_21_7:setOpacity(100)
			var_21_7:setAnchorPoint(0.5, 0.5)
			var_21_7:setScaleX(var_21_2 * var_21_6.width / var_21_8.width / BASE_SCALE)
			var_21_7:setScaleY(var_21_2 * var_21_6.height / var_21_8.height / BASE_SCALE)
			var_21_5:addChild(var_21_7)
			var_21_7:setPosition((var_21_6.x + var_21_6.width / 2) / BASE_SCALE, (var_21_6.y + var_21_6.height / 2) / BASE_SCALE)
		end
		
		focus("c1006", arg_20_0, 300, 270)
		focus("c1015", arg_20_0, 600, 270)
	end
	
	function test_sell_equip(arg_22_0)
		SellEquips:open(arg_22_0)
	end
	
	function test_ui_loader_speed()
		local var_23_0 = systick()
		
		for iter_23_0 = 1, 10 do
			local var_23_1 = cc.CSLoader:createNode("wnd/battle_ready_support_card.csb")
			local var_23_2 = cc.CSLoader:createNode("wnd/mob_icon.wnd")
			local var_23_3 = cc.CSLoader:createNode("wnd/reward_icon.wnd")
		end
		
		print(systick() - var_23_0)
	end
	
	function test_artifact_tooltip(arg_24_0)
		for iter_24_0, iter_24_1 in pairs(Account.equips) do
			if iter_24_1:isArtifact() then
				arg_24_0:addChild(ItemTooltip:getItemTooltip({
					x = 300,
					y = 330,
					equip = iter_24_1
				}))
				
				break
			end
		end
	end
	
	function test_bg(arg_25_0)
		arg_25_0:removeAllChildren()
		
		DEFAULT_DISPLAY_FPS = 120
		
		set_fps(120)
		
		local var_25_0 = FIELD_NEW:create("final")
		
		arg_25_0:addChild(var_25_0)
	end
	
	function test_stat(arg_26_0)
		ResultStatUI:show(arg_26_0)
	end
	
	function test_drop_item(arg_27_0)
		item = {
			count = 1,
			grade = 5,
			code = "eco1b",
			t = "equip",
			temp = {
				set_random_pool = "set_ije"
			}
		}
		
		Dialog:ShowRareDrop(item, {
			parent = arg_27_0
		})
	end
	
	function test_msgbox(arg_28_0)
		Dialog:msgBox("fewoijfoifjwoifjfwe", {
			title = "ewoirjeriojrew",
			handler = function()
				Dialog:msgBox({
					delay = 0,
					title = 123,
					fade_in = 100,
					dlg = load_dlg("hero_up_dedication", true, "wnd"),
					handler = function()
						Dialog:msgBox("fewoijfoifjwoifjfwe", {
							yesno = true,
							handler = function()
								Dialog:msgBox(T("wanna_fin_eating"), {
									cost = 333,
									token = "to_gold",
									yesno = true,
									handler = function()
										Dialog:msgBox("fewoijfoifjwoifjfwe", {
											image = "img/_hero_s_bg_enemy.png",
											title = "ewoirjeriojrew",
											handler = function()
												Dialog:msgBox({
													delay = 0,
													title = 123,
													fade_in = 100,
													dlg = load_dlg("dlg_zodiac_reward_stat", true, "wnd")
												})
											end
										})
									end
								})
							end
						})
					end
				})
			end
		})
	end
	
	function test_rankup(arg_34_0)
		Rankup:show({
			lv_after = 41,
			lv_before = 40,
			parent = arg_34_0
		})
	end
	
	local var_0_18 = {
		e = 82031,
		ct = 1608713835,
		mg = 111,
		s = "0",
		g = 5,
		id = 4366216,
		code = "ecw6n",
		f = "set_speed",
		op = {
			{
				"att_rate",
				0.12
			},
			{
				"acc",
				0.06
			},
			{
				"cri",
				0.04
			},
			{
				"def_rate",
				0.04
			},
			{
				"cri_dmg",
				0.07
			},
			{
				"cri",
				0.05
			},
			{
				"cri_dmg",
				0.07
			},
			{
				"def_rate",
				0.08
			},
			{
				"cri_dmg",
				0.07
			},
			{
				"acc",
				0.08
			}
		}
	}
	
	function Scene.debug.onLoad(arg_35_0, arg_35_1)
		arg_35_0.layer = cc.LayerColor:create(cc.c3b(0, 0, 0))
		
		arg_35_0.layer:setPositionX(VIEW_BASE_LEFT)
		
		local var_35_0 = cc.Node:create()
		
		var_35_0:setPositionX(0 - VIEW_BASE_LEFT)
		arg_35_0.layer:addChild(var_35_0)
	end
	
	function Scene.debug.onUnload(arg_36_0)
		if get_cocos_refid(arg_36_0.layer) then
			arg_36_0.layer:removeFromParent()
		end
	end
	
	function Scene.debug.onEnter(arg_37_0)
		print("lota_lobby???")
		LotaNetworkSystem:sendQuery("lota_enter")
	end
	
	function Scene.debug.onAfterUpdate(arg_38_0)
	end
	
	function Scene.debug.onAfterDraw(arg_39_0)
		if not arg_39_0.tm or os.time() == arg_39_0.tm then
			arg_39_0.tm = os.time()
			
			return 
		end
		
		arg_39_0.tm = os.time()
	end
	
	function Scene.debug.onLeave(arg_40_0)
	end
	
	function Scene.debug.onTouchDown(arg_41_0, arg_41_1, arg_41_2)
	end
	
	function Scene.debug.onTouchUp(arg_42_0, arg_42_1, arg_42_2)
	end
	
	function Scene.debug.onTouchMove(arg_43_0, arg_43_1, arg_43_2)
	end
end
