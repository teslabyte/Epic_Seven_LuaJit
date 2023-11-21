MusicBoxAlbumEditorUI = {}

copy_functions(ScrollView, MusicBoxAlbumEditorUI)

function HANDLER.music_player_album_edit(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" or arg_1_1 == "btn_cancel" then
		MusicBoxAlbumEditorUI:close()
	elseif string.starts(arg_1_1, "btn_a_") then
		MusicBoxAlbumEditorUI:setUI(MusicBox:getMyAlbumIndex(arg_1_1))
	elseif arg_1_1 == "btn_yes" then
		MusicBoxAlbumEditorUI:commit()
	end
end

function HANDLER.music_player_album_edit_cover(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_select" then
		MusicBoxAlbumEditorUI:selectAlbumImage(arg_2_0:getParent(), arg_2_0.datasource)
	end
end

function MusicBoxAlbumEditorUI.show(arg_3_0, arg_3_1)
	if not arg_3_1 or arg_3_1 == 0 then
		return 
	end
	
	if not MusicBoxUI:isEnableEditMyAlbum() then
		return 
	end
	
	arg_3_0.vars = {}
	arg_3_0.vars.wnd = load_dlg("music_player_album_edit", true, "wnd", function()
		MusicBoxAlbumEditorUI:close()
	end)
	
	for iter_3_0 = 1, 3 do
		if_set(arg_3_0.vars.wnd:getChildByName("btn_a_" .. iter_3_0), "t_custom_album" .. iter_3_0, MusicBox:getMyAlbumName(iter_3_0))
		if_set_visible(arg_3_0.vars.wnd:getChildByName("btn_a_" .. iter_3_0), "_selected", iter_3_0 == 1)
	end
	
	if_set(arg_3_0.vars.wnd, "t_disc_title", T("ui_mp_edit_name_desc"))
	
	arg_3_0.vars.scrollview = arg_3_0.vars.wnd:getChildByName("scrollview")
	
	arg_3_0:initScrollView(arg_3_0.vars.scrollview, 193, 193)
	
	arg_3_0.vars.tmp_my = arg_3_1 or 1
	
	arg_3_0:setUI(arg_3_1 or 1)
	SceneManager:getRunningPopupScene():addChild(arg_3_0.vars.wnd)
	arg_3_0.vars.wnd:bringToFront()
end

function MusicBoxAlbumEditorUI.selectAlbumImage(arg_5_0, arg_5_1, arg_5_2)
	if arg_5_0.vars.selected then
		if_set_visible(arg_5_0.vars.selected, "selected", false)
	end
	
	arg_5_0.vars.selected = arg_5_1
	
	if_set_visible(arg_5_0.vars.selected, "selected", true)
	
	arg_5_0.vars.selected_img = arg_5_2
end

function MusicBoxAlbumEditorUI.getScrollViewItem(arg_6_0, arg_6_1)
	local var_6_0 = load_control("wnd/music_player_album_edit_cover.csb")
	
	if_set_visible(var_6_0, "selected", false)
	
	local var_6_1 = MusicBox:getMyAlbum(arg_6_0.vars.tmp_my)
	
	if not arg_6_0.vars.selected_img and var_6_1 and var_6_1.album_image and var_6_1.album_image == arg_6_1 then
		if_set_visible(var_6_0, "selected", true)
		
		arg_6_0.vars.selected = var_6_0
	elseif not var_6_1 or var_6_1 and var_6_1.album_image == nil then
		local var_6_2 = arg_6_1 == MusicBox:getMyAlbum(arg_6_0.vars.tmp_my).album_img
		
		if_set_visible(var_6_0, "selected", var_6_2)
		
		if var_6_2 then
			arg_6_0.vars.selected = var_6_0
		end
	end
	
	if_set_sprite(var_6_0, "a_cover", "musicplayer/" .. arg_6_1)
	
	var_6_0:getChildByName("btn_select").datasource = arg_6_1
	
	return var_6_0
end

function MusicBoxAlbumEditorUI.isShow(arg_7_0)
	if not arg_7_0.vars then
		return 
	end
	
	return get_cocos_refid(arg_7_0.vars.wnd)
end

function MusicBoxAlbumEditorUI.setUI(arg_8_0, arg_8_1)
	if not arg_8_1 or arg_8_1 == 0 then
		return 
	end
	
	if not MusicBox:isMyAlbumSelected() then
		return 
	end
	
	local var_8_0 = totable(DB("musicplayer_album", MusicBox:getMyAlbumID(arg_8_1), "covers") or "")
	
	arg_8_0.vars.wnd:getChildByName("txt_nickname"):setString(MusicBox:getMyAlbumName(arg_8_1))
	arg_8_0.vars.wnd:getChildByName("txt_nickname"):setCursorEnabled(true)
	arg_8_0.vars.wnd:getChildByName("txt_nickname"):setTextColor(cc.c3b(107, 101, 27))
	arg_8_0.vars.wnd:getChildByName("txt_nickname"):setPlaceHolder(MusicBox:getMyAlbumName(arg_8_1))
	
	arg_8_0.vars.tmp_my = arg_8_1
	arg_8_0.vars.selected_img = nil
	
	arg_8_0:createScrollViewItems(var_8_0.covers)
	
	for iter_8_0 = 1, 3 do
		if_set(arg_8_0.vars.wnd:getChildByName("btn_a_" .. iter_8_0), "t_custom_album" .. iter_8_0, MusicBox:getMyAlbumName(iter_8_0))
		if_set_visible(arg_8_0.vars.wnd:getChildByName("btn_a_" .. iter_8_0), "_selected", iter_8_0 == arg_8_1)
	end
end

function MusicBoxAlbumEditorUI.commit(arg_9_0)
	if not arg_9_0.vars.tmp_my then
		return 
	end
	
	if not MusicBox:isMyAlbumSelected() then
		if MusicBoxAlbumEditorUI:isShow() then
			MusicBoxAlbumEditorUI:close()
		end
		
		return 
	end
	
	local var_9_0 = arg_9_0.vars.wnd:getChildByName("txt_nickname"):getString()
	
	if check_abuse_filter(var_9_0, ABUSE_FILTER.NAME) then
		balloon_message_with_sound("invalid_input_word")
		
		return 
	end
	
	local var_9_1 = 8
	
	if string.match(var_9_0, "^%w+") == var_9_0 or utf8len(var_9_0) == string.len(var_9_0) then
		var_9_1 = 12
	end
	
	if var_9_1 < utf8len(var_9_0) then
		balloon_message_with_sound("ui_mp_edit_name_desc")
		
		return 
	end
	
	if string.starts(var_9_0, " ") or var_9_0 == "" then
		balloon_message_with_sound("ui_pet_name_change_alert_2")
		
		return 
	end
	
	local var_9_2 = {
		album_name = arg_9_0.vars.wnd:getChildByName("txt_nickname"):getString() or "",
		album_number = arg_9_0.vars.tmp_my,
		album_image = arg_9_0.vars.selected_img
	}
	
	query("set_album_info", var_9_2)
end

function MusicBoxAlbumEditorUI.close(arg_10_0)
	if not arg_10_0.vars then
		return 
	end
	
	BackButtonManager:pop()
	arg_10_0.vars.wnd:removeFromParent()
	
	arg_10_0.vars = nil
end
