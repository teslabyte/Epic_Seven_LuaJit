CollectionIllustList = {}

copy_functions(CollectionListBase, CollectionIllustList)

function CollectionIllustList.onItemUpdate(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = CollectionUtil:isIllustUnlock(arg_1_2) or false
	
	if_set_visible(arg_1_1, "img_nodata", not var_1_0)
	if_set_visible(arg_1_1, "n_illust", var_1_0)
	
	if var_1_0 then
		local var_1_1 = arg_1_2.illust or ""
		
		if string.find(var_1_1, ",") then
			var_1_1 = string.split(var_1_1, ",")[1]
		end
		
		arg_1_1:findChildByName("img"):removeFromParent()
		
		local var_1_2
		local var_1_3
		
		if arg_1_2.thumbnail then
			if string.starts(arg_1_2.thumbnail, "story/bg/") then
				local var_1_4 = UIUtil:getIllustPath("story/bg/", string.replace(arg_1_2.thumbnail, "story/bg/", ""))
				
				var_1_2 = SpriteCache:getSprite(var_1_4)
			else
				var_1_2 = cc.Sprite:create("item/art/" .. arg_1_2.thumbnail .. ".png")
			end
			
			var_1_2:setName("img")
			var_1_2:setPosition(109, 62)
		elseif string.find(var_1_1, ".cfx") then
			var_1_2 = CACHE:getEffect(var_1_1, "effect")
			var_1_3 = {
				effect = var_1_2,
				fn = var_1_1
			}
			var_1_3.x = 109
			var_1_3.y = 62
			var_1_3.scale = 0.23
		else
			local var_1_5 = "story/bg/" .. var_1_1 .. "_th.webp"
			
			if not cc.FileUtils:getInstance():isFileExist(var_1_5) then
				var_1_5 = "story/bg/" .. var_1_1 .. ".png"
			end
			
			var_1_2 = cc.Sprite:create(var_1_5)
			
			var_1_2:setName("img")
			var_1_2:setLocalZOrder(99999)
			var_1_2:setPosition(109, 62)
			var_1_2:setAnchorPoint(0.5, 0.5)
			
			if string.find(var_1_5, ".png") then
				var_1_2:setScale(0.23)
			end
		end
		
		local var_1_6 = arg_1_1:findChildByName("n_illust")
		
		if var_1_3 then
			var_1_3.layer = var_1_6
			
			EffectManager:EffectPlay(var_1_3)
		else
			var_1_6:addChild(var_1_2)
		end
	else
		if_set_color(arg_1_1, "n_illust_card", cc.c3b(136, 136, 136))
	end
	
	arg_1_1:getChildByName("btn_illust").data = {
		type = "illust",
		illust = arg_1_2.illust,
		unlock_msg = arg_1_2.unlock_msg,
		isCanShow = var_1_0
	}
end

function CollectionIllustList.init(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.vars = {}
	arg_2_0.vars.pure_db = arg_2_2
	
	arg_2_0:initIllistDB(arg_2_1)
end

function CollectionIllustList.initIllistDB(arg_3_0, arg_3_1)
	arg_3_0.vars.parent_db = {}
	arg_3_0.vars.count_db = {}
	
	arg_3_0:makeParentDB(arg_3_1, arg_3_0.vars.parent_db, arg_3_0.vars.count_db, function(arg_4_0)
		return CollectionUtil:isIllustUnlock(arg_4_0)
	end)
end

function CollectionIllustList.getPureDB(arg_5_0, arg_5_1)
	if not arg_5_0.vars then
		return 
	end
	
	if not arg_5_0.vars.pure_db then
		Log.e("PURE DB Was NIL")
		
		return 
	end
	
	return arg_5_0.vars.pure_db
end

function CollectionIllustList.open(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
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
	local var_6_3 = arg_6_0.vars.parent_db
	local var_6_4 = arg_6_0.vars.count_db
	
	arg_6_0.vars.db_type = "illust"
	
	arg_6_0:listBaseInit(arg_6_1, arg_6_2, var_6_3, var_6_4, var_6_0, nil, {
		item_renderer_name = "wnd/dict_illust_item.csb",
		sort_func = function(arg_8_0, arg_8_1)
			return arg_8_0.sort < arg_8_1.sort
		end
	})
	
	arg_6_0.vars.scrollview = arg_6_2
end

CollectionImageViewer = {}

function CollectionImageViewer.isOpen(arg_9_0)
	return not not arg_9_0.vars
end

function HANDLER.dict_story_zoom(arg_10_0, arg_10_1)
	if arg_10_1 == "btn_left" then
		CollectionImageViewer:onTouchChange(false)
	elseif arg_10_1 == "btn_right" then
		CollectionImageViewer:onTouchChange(true)
	end
end

function CollectionImageViewer.load(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = arg_11_2.illust
	local var_11_1 = arg_11_3
	
	if not get_cocos_refid(arg_11_0.vars.wnd) then
		arg_11_0.vars.wnd = load_dlg("dict_story_zoom", true, "wnd")
		
		if_set_visible(arg_11_0.vars.wnd, "n_btn", arg_11_0.vars.is_multi)
		arg_11_0.vars.wnd:setLocalZOrder(1)
		arg_11_1:addChild(arg_11_0.vars.wnd)
	end
	
	if get_cocos_refid(arg_11_0.vars.sprite) then
		arg_11_0.vars.sprite:removeFromParent()
		
		arg_11_0.vars.sprite = nil
	end
	
	if arg_11_0.vars.is_multi then
		if_set_visible(arg_11_0.vars.wnd, "btn_left", false)
		if_set_visible(arg_11_0.vars.wnd, "btn_right", true)
	end
	
	local var_11_2
	local var_11_3 = string.find(var_11_0, ".cfx")
	local var_11_4
	
	if var_11_1 then
		var_11_0 = var_11_0 .. ".webp"
		
		if not cc.FileUtils:getInstance():isFileExist(var_11_0) then
			local var_11_5, var_11_6, var_11_7 = Path.split(var_11_0)
			
			if not var_11_5 then
				var_11_0 = var_11_6 .. ".png"
			else
				var_11_0 = var_11_5 .. "/" .. var_11_6 .. ".png"
			end
		end
		
		var_11_2 = cc.Sprite:create(var_11_0)
	elseif var_11_3 then
		local var_11_8 = ccui.Layout:create()
		
		var_11_8:setContentSize(1580, 720)
		var_11_8:setAnchorPoint(0.5, 0.5)
		var_11_8:setClippingEnabled(true)
		
		var_11_2 = var_11_8
		
		local var_11_9 = CACHE:getEffect(var_11_0, "effect")
		
		var_11_4 = {
			effect = var_11_9,
			layer = var_11_8,
			fn = var_11_0
		}
		var_11_4.x = 790
		var_11_4.y = 360
	else
		var_11_2 = cc.Sprite:create(UIUtil:getIllustPath("story/bg/", var_11_0))
	end
	
	local var_11_10 = var_11_2:getContentSize()
	
	var_11_2:setCascadeOpacityEnabled(true)
	var_11_2:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	
	if var_11_3 then
		arg_11_1:addChild(var_11_2)
		EffectManager:EffectPlay(var_11_4)
	else
		arg_11_1:addChild(var_11_2)
	end
	
	arg_11_0.vars.sprite = var_11_2
end

function CollectionImageViewer.updateBtnUI(arg_12_0)
	if not arg_12_0.vars or not get_cocos_refid(arg_12_0.vars.wnd) or not arg_12_0.vars.is_multi then
		return 
	end
	
	local var_12_0 = arg_12_0.vars.cur_idx
	local var_12_1 = arg_12_0.vars.illust_paths[var_12_0 - 1]
	local var_12_2 = arg_12_0.vars.illust_paths[var_12_0 + 1]
	
	if_set_visible(arg_12_0.vars.wnd, "btn_left", var_12_1)
	if_set_visible(arg_12_0.vars.wnd, "btn_right", var_12_2)
end

function CollectionImageViewer.onTouchChange(arg_13_0, arg_13_1)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_0.vars.wnd) or not arg_13_0.vars.is_multi then
		return 
	end
	
	if arg_13_1 then
		arg_13_0.vars.cur_idx = arg_13_0.vars.cur_idx + 1
	else
		arg_13_0.vars.cur_idx = arg_13_0.vars.cur_idx - 1
	end
	
	arg_13_0:load(arg_13_0.vars.parent, {
		illust = arg_13_0.vars.illust_paths[arg_13_0.vars.cur_idx]
	}, arg_13_0.vars.is_dlc)
	arg_13_0:updateBtnUI()
	
	local function var_13_0()
		local var_14_0 = arg_13_0.vars.sprite:getContentSize()
		
		if var_14_0.width == 0 then
			return false
		end
		
		local var_14_1 = math.min(VIEW_WIDTH / var_14_0.width, VIEW_HEIGHT / var_14_0.height)
		
		arg_13_0.vars.zoom_cont = ZoomController({
			max_scale = 4,
			rotate = 0,
			layer = arg_13_0.vars.sprite,
			scale = var_14_1,
			min_scale = var_14_1,
			sz = {
				width = VIEW_WIDTH * (1 / var_14_1),
				height = VIEW_HEIGHT * (1 / var_14_1)
			}
		})
		
		UIAction:Remove("ui_show_hide")
		UIAction:Remove("ui_show_hide_2")
		UIAction:Remove("ui_show_hide_3")
		
		arg_13_0.vars.top_left = arg_13_0.vars.parent:getChildByName("TOP_LEFT")
		arg_13_0.vars.top_bar = arg_13_0.vars.parent:getChildByName("top_bar")
		arg_13_0.vars.fade_time = 1000
		arg_13_0.vars.ui_hide_delay = 2000
		
		local var_14_2 = arg_13_0.vars.fade_time
		local var_14_3 = arg_13_0.vars.ui_hide_delay
		
		UIAction:Add(SEQ(FADE_IN(var_14_2), DELAY(var_14_3), FADE_OUT(var_14_2)), arg_13_0.vars.top_left, "ui_show_hide")
		UIAction:Add(SEQ(FADE_IN(var_14_2), DELAY(var_14_3), FADE_OUT(var_14_2)), arg_13_0.vars.top_bar, "ui_show_hide_2")
		UIAction:Add(SEQ(FADE_IN(var_14_2), DELAY(var_14_3), FADE_OUT(var_14_2)), arg_13_0.vars.wnd, "ui_show_hide_3")
		
		return true
	end
	
	if arg_13_0.vars.sprite:getContentSize().width > 0 then
		var_13_0()
		
		return 
	end
	
	UIAction:Add(COND_LOOP(DELAY(1), function()
		if not arg_13_0.vars or not get_cocos_refid(arg_13_0.vars.sprite) then
			return true
		end
		
		return var_13_0()
	end), arg_13_0.vars.sprite, "block")
end

function CollectionImageViewer.updateFullscreenMode(arg_16_0)
	if_set_position_y(arg_16_0.vars.wnd, "n_bottom", -(HEIGHT_MARGIN * 0.5))
	TopBarNew:setFullScreenMode(arg_16_0.vars.anchor_right, arg_16_0.vars.anchor_left)
	SceneManager:getCurrentScene():showLetterBox(false)
end

function CollectionImageViewer.open(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	arg_17_0.vars = {}
	arg_17_3 = arg_17_3 or {}
	
	local var_17_0 = table.shallow_clone(arg_17_2 or {})
	
	arg_17_0.vars.close_callback = arg_17_3.close_callback
	
	if string.find(var_17_0.illust, ",") then
		local var_17_1 = string.split(var_17_0.illust, ",")
		
		var_17_0.illust = var_17_1[1]
		arg_17_0.vars.cur_idx = 1
		arg_17_0.vars.is_multi = true
		arg_17_0.vars.illust_paths = {}
		
		for iter_17_0, iter_17_1 in pairs(var_17_1) do
			table.insert(arg_17_0.vars.illust_paths, iter_17_1)
		end
	end
	
	arg_17_0.vars.is_dlc = arg_17_3.is_dlc
	arg_17_0.vars.parent = arg_17_1
	
	arg_17_0:load(arg_17_1, var_17_0, arg_17_3.is_dlc)
	TopBarNew:createFromPopup(arg_17_3.topbar_title, arg_17_1, function()
		if arg_17_0.vars.close_callback then
			arg_17_0.vars.close_callback()
		end
		
		CollectionImageViewer:close()
	end)
	
	arg_17_0.vars.anchorY = arg_17_0.vars.wnd:getPositionY()
	arg_17_0.vars.anchor_right, arg_17_0.vars.anchor_left = TopBarNew:getFullscreenAnchors()
	
	TopBarNew:setCurrencies({})
	TopBarNew:setEnableTip(false)
	TopBarNew:forcedHelp_OnOff(false)
	TopBarNew:setVisibleTopRightButtons(false)
	arg_17_0:updateFullscreenMode()
	NotchManager:addListener(arg_17_0.vars.wnd, false, function()
		arg_17_0:updateFullscreenMode()
	end)
	
	local function var_17_2()
		local var_20_0 = arg_17_0.vars.sprite:getContentSize()
		
		if var_20_0.width == 0 then
			return false
		end
		
		local var_20_1 = math.min(VIEW_WIDTH / var_20_0.width, VIEW_HEIGHT / var_20_0.height)
		
		arg_17_0.vars.zoom_cont = ZoomController({
			max_scale = 4,
			rotate = 0,
			layer = arg_17_0.vars.sprite,
			scale = var_20_1,
			min_scale = var_20_1,
			sz = {
				width = VIEW_WIDTH * (1 / var_20_1),
				height = VIEW_HEIGHT * (1 / var_20_1)
			}
		})
		arg_17_0.vars.top_left = arg_17_1:getChildByName("TOP_LEFT")
		arg_17_0.vars.top_bar = arg_17_1:getChildByName("top_bar")
		arg_17_0.vars.fade_time = 1000
		arg_17_0.vars.ui_hide_delay = 2000
		
		local var_20_2 = arg_17_0.vars.fade_time
		local var_20_3 = arg_17_0.vars.ui_hide_delay
		
		UIAction:Add(SEQ(FADE_IN(var_20_2), DELAY(var_20_3), FADE_OUT(var_20_2)), arg_17_0.vars.top_left, "ui_show_hide")
		UIAction:Add(SEQ(FADE_IN(var_20_2), DELAY(var_20_3), FADE_OUT(var_20_2)), arg_17_0.vars.top_bar, "ui_show_hide_2")
		UIAction:Add(SEQ(FADE_IN(var_20_2), DELAY(var_20_3), FADE_OUT(var_20_2)), arg_17_0.vars.wnd, "ui_show_hide_3")
		
		return true
	end
	
	if arg_17_0.vars.sprite:getContentSize().width > 0 then
		var_17_2()
		
		return 
	end
	
	UIAction:Add(COND_LOOP(DELAY(1), function()
		if not arg_17_0.vars or not get_cocos_refid(arg_17_0.vars.sprite) then
			return true
		end
		
		return var_17_2()
	end), arg_17_0.vars.sprite, "viewer_updater")
end

function CollectionImageViewer.onTouchDown(arg_22_0, arg_22_1, arg_22_2)
	if not arg_22_0.vars then
		return 
	end
	
	if not arg_22_0.vars.zoom_cont then
		return 
	end
	
	if not UIAction:Find("ui_show_hide") then
		arg_22_0.vars.zoom_cont:onTouchDown(arg_22_1, arg_22_2)
		
		local var_22_0 = arg_22_0.vars.top_left
		local var_22_1 = arg_22_0.vars.top_bar
		local var_22_2 = arg_22_0.vars.fade_time
		local var_22_3 = arg_22_0.vars.ui_hide_delay
		
		if get_cocos_refid(var_22_0) then
			UIAction:Add(SEQ(FADE_IN(var_22_2), DELAY(var_22_3), FADE_OUT(var_22_2)), var_22_0, "ui_show_hide")
			UIAction:Add(SEQ(FADE_IN(var_22_2), DELAY(var_22_3), FADE_OUT(var_22_2)), var_22_1, "ui_show_hide_2")
			UIAction:Add(SEQ(FADE_IN(var_22_2), DELAY(var_22_3), FADE_OUT(var_22_2)), arg_22_0.vars.wnd, "ui_show_hide_3")
		end
	else
		arg_22_0.vars.zoom_cont:onTouchDown(arg_22_1, arg_22_2)
	end
end

function CollectionImageViewer.onTouchUp(arg_23_0, arg_23_1, arg_23_2)
	if not arg_23_0.vars then
		return 
	end
	
	if not arg_23_0.vars.zoom_cont then
		return 
	end
	
	arg_23_0.vars.zoom_cont:onTouchUp(arg_23_1, arg_23_2)
end

function CollectionImageViewer.onTouchMove(arg_24_0, arg_24_1, arg_24_2)
	if not arg_24_0.vars then
		return 
	end
	
	if not arg_24_0.vars.zoom_cont then
		return 
	end
	
	arg_24_0.vars.zoom_cont:onTouchMove(arg_24_1, arg_24_2)
end

function CollectionImageViewer.onGestureZoom(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	if not arg_25_0.vars then
		return 
	end
	
	if not arg_25_0.vars.zoom_cont then
		return 
	end
	
	arg_25_0.vars.zoom_cont:onGestureZoom(arg_25_1, arg_25_2, arg_25_3)
end

function CollectionImageViewer.onMouseWheel(arg_26_0, arg_26_1, arg_26_2)
	if not arg_26_0.vars then
		return 
	end
	
	if not arg_26_0.vars.zoom_cont then
		return 
	end
	
	arg_26_0.vars.zoom_cont:onMouseWheel(arg_26_1)
end

function CollectionImageViewer.close(arg_27_0)
	arg_27_0.vars = nil
end
