MusicBoxUI = MusicBoxUI or {}

local function var_0_0(arg_1_0)
	local var_1_0 = arg_1_0 / 1000
	local var_1_1 = math.floor(var_1_0 % 60)
	
	return math.floor(var_1_0 / 60) .. ":" .. string.format("%02d", var_1_1)
end

function HANDLER.music_player(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_a" then
		MusicBoxUI:btnAlbum(arg_2_0)
		
		return 
	end
	
	if arg_2_1 == "btn_song" then
		MusicBoxUI:btnSong(arg_2_0)
		
		return 
	end
	
	if arg_2_1 == "btn_bg_search" then
		MusicBoxUI:btnBGSearch()
		
		return 
	end
	
	if arg_2_1 == "btn_like" then
		local var_2_0 = MusicBoxUI:getSongFromFavoriteToggleButton(arg_2_0) or MusicBox:getTargetSong()
		
		MusicBoxUI:toggleFavorite(var_2_0)
		
		return 
	end
	
	if arg_2_1 == "btn_play" then
		MusicBoxUI:btnPlay()
		
		return 
	end
	
	if arg_2_1 == "btn_ff" then
		MusicBox:next()
		
		return 
	end
	
	if arg_2_1 == "btn_rff" then
		MusicBox:prev()
		
		return 
	end
	
	if arg_2_1 == "btn_repeat" then
		MusicBox:switchLoopType()
		
		return 
	end
	
	if arg_2_1 == "btn_shuff" then
		MusicBoxUI:btnShuffle()
		
		return 
	end
	
	if arg_2_1 == "btn_open_search" or arg_2_1 == "btn_close_search" then
		MusicBoxUI:toggleSearch()
		
		return 
	end
	
	if arg_2_1 == "btn_search" then
		MusicBoxUI:btnSearch()
		
		return 
	end
	
	if arg_2_1 == "btn_addtolist" or arg_2_1 == "btn_close" then
		MusicBoxUI:toggleAddList()
		
		return 
	end
	
	if string.starts(arg_2_1, "btn_my") then
		local var_2_1 = string.sub(arg_2_1, #arg_2_1, -1)
		
		MusicBoxUI:toggleAlbumCheckBox(var_2_1)
		
		local var_2_2 = arg_2_0:getChildByName("check_box")
		
		var_2_2:setSelected(not var_2_2:isSelected())
		
		return 
	end
	
	if arg_2_1 == "check_box" then
		local var_2_3 = arg_2_0:getParent():getName()
		local var_2_4 = string.sub(var_2_3, -1)
		
		MusicBoxUI:toggleAlbumCheckBox(var_2_4)
		
		return 
	end
	
	if arg_2_1 == "sort_1" then
		MusicBoxUI:setBestAlbumSortOption("prev_fav")
		
		return 
	end
	
	if arg_2_1 == "sort_2" then
		MusicBoxUI:setBestAlbumSortOption("total")
		
		return 
	end
	
	if arg_2_1 == "btn_bg" then
		MusicBoxUI:toggleBestAlbumCountOptionLayer()
		
		return 
	end
	
	if arg_2_1 == "btn_list_edit" then
		MusicBoxUI:turnOnPlaylistEditMode()
		MusicBoxUI:updatePlaylist()
		
		return 
	end
	
	if arg_2_1 == "btn_list_edit_active" then
		MusicBoxUI:turnOffPlaylistEditMode()
		MusicBoxUI:updatePlaylist()
		
		return 
	end
	
	if arg_2_1 == "btn_up" then
		MusicBoxUI:editUp(arg_2_0:getParent().song_data)
		
		return 
	end
	
	if arg_2_1 == "btn_down" then
		MusicBoxUI:editDown(arg_2_0:getParent().song_data)
		
		return 
	end
	
	if arg_2_1 == "btn_x" then
		MusicBoxUI:editRemove(arg_2_0:getParent().song_data)
		
		return 
	end
	
	if arg_2_1 == "btn_custom_name" then
		MusicBoxAlbumEditorUI:show(to_n(string.sub(MusicBox:getSelectedAlbumID(), -1)))
		
		return 
	end
	
	if arg_2_1 == "btn_movie" then
		MusicBox:stop()
		Stove:openVideoPage(MusicBox:getTargetSongVideoUrl())
		
		return 
	end
	
	if arg_2_1 == "btn_bgm_option" then
		MusicBoxUI:btnOpenBgmVolumeOption()
		
		return 
	end
	
	if arg_2_1 == "btn_close_sound_opt" then
		MusicBoxUI:btnCloseBgmVolumeOption()
		
		return 
	end
	
	if arg_2_1 == "btn_sound" or arg_2_1 == "btn_mute" then
		MusicBoxUI:toggleBgmMute(arg_2_0)
		
		return 
	end
end

function MusicBoxUI.isEnableEditMyAlbum(arg_3_0)
	if not MusicBox:isMyAlbumSelected() then
		return false
	end
	
	if not arg_3_0:isShow() then
		return false
	end
	
	local var_3_0 = arg_3_0.vars.wnd:getChildByName("btn_custom_name")
	
	if not get_cocos_refid(var_3_0) then
		return false
	end
	
	return var_3_0:isVisible()
end

function MusicBoxUI.unselectSongCard(arg_4_0, arg_4_1, arg_4_2)
	if not get_cocos_refid(arg_4_1) then
		return 
	end
	
	arg_4_2 = arg_4_2 or {}
	arg_4_2.fade_tm = arg_4_2.fade_tm or 0
	
	arg_4_0:stopEff(arg_4_1)
	arg_4_0:resetLoopText(arg_4_1)
	
	local var_4_0 = arg_4_1:getChildByName("img_playing")
	
	if var_4_0:getOpacity() ~= 0 then
		UIAction:Remove(arg_4_1.song_data.id .. "_img_playing")
		
		if arg_4_2.fade_tm == 0 then
			if_set_opacity(var_4_0, nil, 0)
		else
			if_set_opacity(var_4_0, nil, 255)
			UIAction:Add(SEQ(FADE_OUT(arg_4_2.fade_tm)), var_4_0, arg_4_1.song_data.id .. "_img_playing")
		end
	end
	
	if_set_color(arg_4_1, "song_icon", tocolor("#ffffff"))
end

function MusicBoxUI.selectSongCard(arg_5_0, arg_5_1, arg_5_2)
	if not get_cocos_refid(arg_5_1) then
		return 
	end
	
	arg_5_2 = arg_5_2 or {}
	arg_5_2.fade_tm = arg_5_2.fade_tm or 0
	
	if MusicBox:isPlaying() then
		arg_5_0:playEff(arg_5_1)
		arg_5_0:makeLoopText(arg_5_1, 9000)
	else
		arg_5_0:stopEff(arg_5_1)
		arg_5_0:resetLoopText(arg_5_1)
	end
	
	local var_5_0 = arg_5_1:getChildByName("img_playing")
	
	if var_5_0:getOpacity() ~= 255 then
		UIAction:Remove(arg_5_1.song_data.id .. "_img_playing")
		
		if arg_5_2.fade_tm == 0 then
			if_set_opacity(var_5_0, nil, 255)
		else
			if_set_opacity(var_5_0, nil, 0)
			UIAction:Add(SEQ(FADE_IN(arg_5_2.fade_tm)), var_5_0, arg_5_1.song_data.id .. "_img_playing")
		end
	end
	
	if_set_color(arg_5_1, "song_icon", tocolor("#818181"))
end

function MusicBoxUI.updateUI(arg_6_0)
	arg_6_0:updateMusicUI()
	arg_6_0:updatePlaylist()
	arg_6_0:updateAlbumList()
	arg_6_0:hideBestAlbumCountOptionLayer()
	arg_6_0:updateBestAlbumSortOption()
end

function MusicBoxUI.onStop(arg_7_0)
	if not arg_7_0:isShow() then
		return 
	end
	
	arg_7_0:updateUI()
end

function MusicBoxUI.onPlay(arg_8_0)
	if not arg_8_0:isShow() then
		return 
	end
	
	arg_8_0:updateUI()
end

function MusicBoxUI.btnPlay(arg_9_0)
	if not arg_9_0.vars then
		return 
	end
	
	MusicBox:togglePlayPause()
end

function MusicBoxUI.isBgmMute(arg_10_0)
	return SAVE:getUserDefaultData("sound.mute_bgm", false)
end

function MusicBoxUI.setBgmMute(arg_11_0, arg_11_1)
	SoundEngine:setMute("bgm", arg_11_1)
	SAVE:setUserDefaultData("sound.mute_bgm", arg_11_1)
end

function MusicBoxUI.toggleBgmMute(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_1:getParent()
	
	if not get_cocos_refid(var_12_0) then
		return 
	end
	
	local var_12_1 = var_12_0:getParent()
	
	if not get_cocos_refid(var_12_1) then
		return 
	end
	
	arg_12_0:setBgmMute(not arg_12_0:isBgmMute())
	arg_12_0:updateBgmVolume()
end

function MusicBoxUI.updateBgmVolume(arg_13_0)
	local var_13_0 = "bgm_slider"
	local var_13_1 = arg_13_0.vars.wnd:getChildByName(var_13_0)
	
	if not get_cocos_refid(var_13_1) then
		return 
	end
	
	local var_13_2 = arg_13_0:isBgmMute()
	
	UIUtil:equalizeProgress(var_13_1, {
		reset = true,
		per = SoundEngine:getVolume("bgm") * 100,
		enable = not var_13_2
	})
	if_set_visible(var_13_1, "btn_sound", not var_13_2)
	if_set_visible(var_13_1, "btn_mute", var_13_2)
end

function MusicBoxUI.btnCloseBgmVolumeOption(arg_14_0)
	if not arg_14_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_14_0.vars.wnd) then
		return 
	end
	
	local var_14_0 = arg_14_0.vars.wnd:getChildByName("layer_sound_opt")
	
	if not get_cocos_refid(var_14_0) then
		return 
	end
	
	BackButtonManager:pop({
		check_id = "layer_sound_opt",
		dlg = var_14_0
	})
	if_set_visible(var_14_0, nil, false)
end

function MusicBoxUI.btnOpenBgmVolumeOption(arg_15_0)
	if not arg_15_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_15_0.vars.wnd) then
		return 
	end
	
	local var_15_0 = arg_15_0.vars.wnd:getChildByName("layer_sound_opt")
	
	if not get_cocos_refid(var_15_0) then
		return 
	end
	
	BackButtonManager:push({
		check_id = "layer_sound_opt",
		back_func = function()
			arg_15_0:btnCloseBgmVolumeOption()
		end,
		dlg = var_15_0
	})
	if_set_visible(var_15_0, nil, true)
	
	if not arg_15_0.vars.is_init_bgm_slider then
		arg_15_0.vars.is_init_bgm_slider = true
		
		local var_15_1 = var_15_0:getChildByName("bgm_slider")
		local var_15_2 = var_15_1:getChildByName("slider")
		
		UIUtil:initProgress(var_15_1, {
			per = SoundEngine:getVolume("bgm"),
			handler = function(arg_17_0, arg_17_1, arg_17_2)
				arg_17_1 = arg_17_1 * 0.01
				
				SoundEngine:setVolumeBGM(arg_17_1)
				
				if not arg_17_2 then
					return 
				end
				
				SAVE:setUserDefaultData("sound.vol_bgm", arg_17_1)
			end
		})
	end
	
	arg_15_0:updateBgmVolume()
end

function MusicBoxUI.btnAlbum(arg_18_0, arg_18_1)
	if not arg_18_0.vars then
		return 
	end
	
	arg_18_0:turnOffPlaylistEditMode()
	MusicBox:setAlbum(arg_18_1.album_data.album_id)
	
	if arg_18_1.album_data.album_id == MusicBox:getTargetAlbumID() and MusicBox:isTargetPlaylistShuffle() then
		MusicBox:setTrack(MusicBox:getSelectTrack(MusicBox:getTargetSongID()))
		arg_18_0:updateUI()
	end
end

function MusicBoxUI.onSetTrack(arg_19_0, arg_19_1)
	arg_19_1 = arg_19_1 or {}
	
	local var_19_0 = MusicBox:getTargetSong()
	
	if not var_19_0 then
		return 
	end
	
	if not MusicBox:isUnLock(var_19_0.lock_id) then
		if not arg_19_1.is_quiet then
			arg_19_0:showLockMsg(var_19_0.lock_id)
		end
		
		return 
	end
	
	arg_19_0.vars.playtime_slider:setMaxPercent(var_19_0.length or 0)
	arg_19_0:updateMusicUIShuffle()
end

function MusicBoxUI.btnSong(arg_20_0, arg_20_1)
	if not arg_20_0.vars then
		return 
	end
	
	if not MusicBox:isUnLock(arg_20_1.song_data.lock_id) then
		arg_20_0:showLockMsg(arg_20_1.song_data.lock_id)
		
		return 
	end
	
	local var_20_0 = MusicBox:getTargetSong()
	
	MusicBox:setTrack(arg_20_1.song_data.index)
	
	local var_20_1 = MusicBox:getTargetSong()
	
	MusicBox:setSameSong(var_20_0.id == var_20_1.id)
	
	if var_20_0.id == MusicBox:getTargetSongID() then
		MusicBox:togglePlayPause()
	else
		MusicBox:play()
	end
end

function MusicBoxUI.btnBGSearch(arg_21_0)
	if not arg_21_0.vars then
		return 
	end
	
	if arg_21_0.vars and get_cocos_refid(arg_21_0.vars.wnd) then
		arg_21_0.vars.wnd:getChildByName("input_search"):setTextColor(cc.c3b(107, 101, 27))
		arg_21_0.vars.wnd:getChildByName("input_search"):setCursorEnabled(true)
	end
end

function MusicBoxUI.btnShuffle(arg_22_0)
	if not arg_22_0.vars then
		return 
	end
	
	if arg_22_0:isPlaylistEditMode() then
		return 
	end
	
	UIAction:Add(DELAY(150), arg_22_0.vars.wnd, "block")
	MusicBox:shufflePlaylist()
end

function MusicBoxUI.btnSearch(arg_23_0)
	if not arg_23_0.vars then
		return 
	end
	
	UIAction:Add(DELAY(150), arg_23_0.vars.wnd, "block")
	arg_23_0:search()
end

function MusicBoxUI.updateAlbumList(arg_24_0)
	if not arg_24_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_24_0.vars.listview_albums) then
		return 
	end
	
	arg_24_0.vars.listview_albums:refresh()
end

function MusicBoxUI.updatePlaylistFavorite(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_0:getSongCardByID(arg_25_1)
	
	if not get_cocos_refid(var_25_0) then
		return 
	end
	
	local var_25_1 = var_25_0:getChildByName(MusicBox:isBestAlbumSelected() and "n_like" or "n_common")
	
	if_set(var_25_1, "count", MusicBox:getFavoriteCount(arg_25_1))
	arg_25_0:actionToggleFavorite(var_25_1, arg_25_2)
end

function MusicBoxUI.updatePlaylist(arg_26_0)
	if not arg_26_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_26_0.vars.listview_playlist) then
		return 
	end
	
	if_set_visible(arg_26_0.vars.wnd:getChildByName("RIGHT"), "btn_list_edit", MusicBox:isMyAlbumSelected() and not arg_26_0:isPlaylistEditMode())
	if_set_visible(arg_26_0.vars.wnd:getChildByName("RIGHT"), "btn_list_edit_active", MusicBox:isMyAlbumSelected() and arg_26_0:isPlaylistEditMode())
	if_set_visible(arg_26_0.vars.wnd:getChildByName("CENTER"), "btn_custom_name", MusicBox:isMyAlbumSelected())
	
	if MusicBox:isMyAlbumSelected() then
		arg_26_0.vars._playlist_y = arg_26_0.vars.listview_playlist:getInnerContainerPosition().y
	else
		arg_26_0:turnOffPlaylistEditMode()
	end
	
	if_set_visible(arg_26_0.vars.wnd:getChildByName("RIGHT"), "btn_sort_period", MusicBox:isBestAlbumSelected())
	
	local var_26_0 = table.count(MusicBox:getSelectPlaylist() or {})
	local var_26_1 = MusicBox:isSelectPlaylistSearch() and T("dic_search_title") .. "(" .. var_26_0 .. ")" or T("ui_mp_playlist", {
		song = var_26_0
	})
	
	if_set(arg_26_0.vars.wnd, "txt_list", var_26_1)
	if_set_visible(arg_26_0.vars.wnd, "scr_view_song", var_26_0 ~= 0)
	if_set_visible(arg_26_0.vars.wnd, "no_data", var_26_0 == 0)
	arg_26_0.vars.listview_playlist:refresh()
end

function MusicBoxUI.toggleAlbumCheckBox(arg_27_0, arg_27_1)
	if not arg_27_0.vars then
		return 
	end
	
	local var_27_0 = false
	local var_27_1 = MusicBox:getAlbumSongs(MusicBox:getMyAlbumID(arg_27_1))
	
	for iter_27_0, iter_27_1 in pairs(var_27_1 or {}) do
		if iter_27_1.id == MusicBox:getTargetSongID() then
			var_27_0 = true
			
			break
		end
	end
	
	local var_27_2 = {
		album_number = arg_27_1,
		music_id = MusicBox:getTargetSongID(),
		remove = var_27_0
	}
	
	query("edit_album_list", var_27_2)
end

function MusicBoxUI.toggleAddList(arg_28_0)
	if not arg_28_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_28_0.vars.wnd) then
		return 
	end
	
	if not MusicBox:getTargetSong() then
		return 
	end
	
	local var_28_0 = arg_28_0.vars.wnd:getChildByName("n_addtolist")
	
	if not get_cocos_refid(var_28_0) then
		return 
	end
	
	if_set_visible(var_28_0, nil, not var_28_0:isVisible())
	
	if var_28_0:isVisible() then
		BackButtonManager:push({
			check_id = "mb.list",
			back_func = function()
				if_set_visible(arg_28_0.vars.wnd, "n_addtolist", false)
				BackButtonManager:pop()
			end
		})
	else
		BackButtonManager:pop({
			id = "mb.list"
		})
	end
	
	if_set(arg_28_0.vars.wnd, "txt_addtolist", T("ui_mp_myalbum_add"))
	
	for iter_28_0 = 1, 3 do
		local var_28_1 = arg_28_0.vars.wnd:getChildByName("btn_my" .. iter_28_0):getChildByName("check_box")
		
		var_28_1:setSelected(MusicBox:isSongInAlbum(MusicBox:getMyAlbumID(iter_28_0), MusicBox:getTargetSongID()))
		if_set(var_28_1, "t", MusicBox:getMyAlbumName(iter_28_0))
	end
end

function MusicBoxUI.hideSearchLayer(arg_30_0)
	if not arg_30_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_30_0.vars.wnd) then
		return 
	end
	
	if not arg_30_0:isShowSearchLayer() then
		return 
	end
	
	local var_30_0 = arg_30_0.vars.wnd:getChildByName("layer_search")
	
	if_set_visible(var_30_0, nil, false)
	BackButtonManager:pop({
		check_id = "layer_search",
		dlg = var_30_0
	})
end

function MusicBoxUI.isShowSearchLayer(arg_31_0)
	if not arg_31_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_31_0.vars.wnd) then
		return 
	end
	
	local var_31_0 = arg_31_0.vars.wnd:getChildByName("layer_search")
	
	if not get_cocos_refid(var_31_0) then
		return 
	end
	
	return var_31_0:isVisible()
end

function MusicBoxUI.showSearchLayer(arg_32_0)
	if not arg_32_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_32_0.vars.wnd) then
		return 
	end
	
	if arg_32_0:isShowSearchLayer() then
		return 
	end
	
	local var_32_0 = arg_32_0.vars.wnd:getChildByName("layer_search")
	
	if_set_visible(var_32_0, nil, true)
	BackButtonManager:push({
		check_id = "layer_search",
		back_func = function()
			arg_32_0:hideSearchLayer()
		end,
		dlg = var_32_0
	})
end

function MusicBoxUI.toggleSearch(arg_34_0)
	if arg_34_0:isShowSearchLayer() then
		arg_34_0:hideSearchLayer()
	else
		arg_34_0:showSearchLayer()
	end
end

function MusicBoxUI.getSearchText(arg_35_0)
	if not arg_35_0.vars then
		return ""
	end
	
	if not get_cocos_refid(arg_35_0.vars.wnd) then
		return ""
	end
	
	local var_35_0 = arg_35_0.vars.wnd:getChildByName("input_search")
	
	if not get_cocos_refid(var_35_0) then
		return ""
	end
	
	local var_35_1 = var_35_0:getString()
	local var_35_2 = string.trim(var_35_1)
	
	return (string.lower(var_35_2))
end

function MusicBoxUI.search(arg_36_0)
	if not arg_36_0.vars then
		return 
	end
	
	arg_36_0:hideSearchLayer()
	
	local var_36_0 = arg_36_0:getSearchText()
	
	if var_36_0 == "" then
		return 
	end
	
	local var_36_1 = MusicBox:search(var_36_0)
	
	MusicBox:setSelectPlaylist(var_36_1, {
		album_id = MusicBox.SEARCH_ALBUM_ID
	})
end

function MusicBoxUI.showLockMsg(arg_37_0, arg_37_1)
	if not arg_37_0.vars then
		return 
	end
	
	local var_37_0 = {}
	
	var_37_0.condition, var_37_0.value, var_37_0.lock_desc = DB("musicplayer_lock", arg_37_1, {
		"condition",
		"value",
		"lock_desc"
	})
	
	if var_37_0.lock_desc then
		balloon_message_with_sound(var_37_0.lock_desc)
		
		return 
	end
	
	if var_37_0.condition == "character" then
		balloon_message_with_sound("mp_lock_character", {
			name = T(DB("character", var_37_0.value, "name"))
		})
		
		return 
	end
	
	if var_37_0.condition == "lock" then
		local var_37_1 = {}
		
		var_37_1.type, var_37_1.value = DB("system_achievement", var_37_0.value, {
			"condition",
			"value"
		})
		
		if var_37_1.type == "clear_enter_count" then
			local var_37_2, var_37_3 = DB("level_enter", totable(var_37_1.value).enter, {
				"episode",
				"name"
			})
			
			var_37_2 = var_37_2 or ""
			var_37_3 = var_37_3 or ""
			
			local var_37_4 = "ep_select_num" .. string.sub(var_37_2, #var_37_2)
			
			balloon_message_with_sound("mp_lock_system_stage", {
				episode = T(var_37_4),
				map = T(var_37_3)
			})
		elseif var_37_1.type == "accountrank_count" then
			balloon_message_with_sound("mp_lock_system_rank", {
				level = totable(var_37_1.value).count
			})
		end
	end
end

function MusicBoxUI.onUpdateFavorite(arg_38_0, arg_38_1, arg_38_2)
	arg_38_0:updatePlaylistFavorite(arg_38_1, arg_38_2)
	
	if arg_38_1 == MusicBox:getTargetSongID() then
		arg_38_0:updateMusicUIFavorite(arg_38_2)
	end
end

function MusicBoxUI.toggleFavorite(arg_39_0, arg_39_1)
	if not arg_39_0.vars then
		return 
	end
	
	if not arg_39_1 then
		return 
	end
	
	if not MusicBox:isUnLock(arg_39_1.lock_id) then
		arg_39_0:showLockMsg(arg_39_1.lock_id)
		
		return 
	end
	
	MusicBox:toggleFavorite(arg_39_1.id)
end

function MusicBoxUI.actionToggleFavorite(arg_40_0, arg_40_1, arg_40_2)
	if not get_cocos_refid(arg_40_1) then
		return 
	end
	
	local var_40_0 = arg_40_1:getChildByName("icon_like")
	
	if not get_cocos_refid(var_40_0) then
		return 
	end
	
	local var_40_1 = arg_40_2 and "cm_icon_like.png" or "cm_icon_unlike.png"
	
	UIAction:Add(SPAWN(CALL(function()
		if_set_sprite(var_40_0, nil, var_40_1)
	end), SEQ(RLOG(SCALE(100, 0, 1)), RLOG(SCALE(40, 1, 0.7)))), var_40_0, "block")
end

function MusicBoxUI.makeLoopText(arg_42_0, arg_42_1, arg_42_2)
	if not get_cocos_refid(arg_42_1) then
		return 
	end
	
	arg_42_0:resetLoopText(arg_42_1)
	
	local function var_42_0(arg_43_0, arg_43_1)
		local var_43_0 = "musicbox.loop" .. get_cocos_refid(arg_43_0)
		local var_43_1 = arg_43_0:getParent():getContentSize().width
		
		if var_43_1 >= arg_43_0:getAutoRenderSize().width then
			return 
		end
		
		local var_43_2 = arg_43_0:getAutoRenderSize().width * arg_43_0:getScale()
		
		UIAction:Add(SEQ(MOVE_BY(arg_43_1 or 3000, -var_43_2, 0), LOOP(SEQ(MOVE_BY(0, var_43_1, 0), MOVE_BY(arg_43_1 or 3000, 0, 0), MOVE_BY(arg_43_1 or 3000, -var_43_2, 0)))), arg_43_0, var_43_0)
	end
	
	var_42_0(arg_42_1:getChildByName("t_sub"), arg_42_2)
	var_42_0(arg_42_1:getChildByName("t_song_title"), arg_42_2)
end

function MusicBoxUI.resetLoopText(arg_44_0, arg_44_1)
	if not get_cocos_refid(arg_44_1) then
		return 
	end
	
	local function var_44_0(arg_45_0)
		if not get_cocos_refid(arg_45_0) then
			return 
		end
		
		local var_45_0 = "musicbox.loop" .. get_cocos_refid(arg_45_0)
		
		UIAction:Remove(var_45_0)
		arg_45_0:setPositionX(0)
	end
	
	var_44_0(arg_44_1:getChildByName("t_sub"))
	var_44_0(arg_44_1:getChildByName("t_song_title"))
end

function MusicBoxUI.showBestAlbumCountOptionLayer(arg_46_0)
	if not arg_46_0.vars then
		return 
	end
	
	if not MusicBox:isBestAlbumSelected() then
		return 
	end
	
	if_set_visible(arg_46_0.vars.wnd, "n_layer_sort", true)
	
	local var_46_0 = arg_46_0.vars.wnd:getChildByName("n_layer_sort")
	
	if_set_visible(var_46_0:getChildByName("sort_1"), "sort_cursor", MusicBox:getBestAlbumSortType() == "prev_fav")
	if_set_visible(var_46_0:getChildByName("sort_2"), "sort_cursor", MusicBox:getBestAlbumSortType() == "total")
	if_set(var_46_0:getChildByName("sort_1"), "label", T("ui_mp_best_month"))
	if_set(var_46_0:getChildByName("sort_2"), "label", T("ui_mp_best_all"))
end

function MusicBoxUI.hideBestAlbumCountOptionLayer(arg_47_0)
	if not arg_47_0.vars then
		return 
	end
	
	if_set_visible(arg_47_0.vars.wnd, "n_layer_sort", false)
end

function MusicBoxUI.toggleBestAlbumCountOptionLayer(arg_48_0)
	if not arg_48_0.vars then
		return 
	end
	
	if not MusicBox:isBestAlbumSelected() then
		return 
	end
	
	local var_48_0 = arg_48_0.vars.wnd:getChildByName("n_layer_sort")
	
	if not get_cocos_refid(var_48_0) then
		return 
	end
	
	if not var_48_0:isVisible() then
		arg_48_0:showBestAlbumCountOptionLayer()
	else
		arg_48_0:hideBestAlbumCountOptionLayer()
	end
end

function MusicBoxUI.updateBestAlbumSortOption(arg_49_0)
	if not arg_49_0.vars then
		return 
	end
	
	local var_49_0 = MusicBox:getBestAlbumSortType() == "prev_fav"
	
	if_set(arg_49_0.vars.wnd, "txt_sort", var_49_0 and T("ui_mp_best_month") or T("ui_mp_best_all"))
end

function MusicBoxUI.setBestAlbumSortOption(arg_50_0, arg_50_1)
	if not arg_50_0.vars then
		return 
	end
	
	arg_50_0:hideBestAlbumCountOptionLayer()
	MusicBox:setBestAlbumSortOption(arg_50_1)
	arg_50_0:updateBestAlbumSortOption()
end

function MusicBoxUI.isPlaylistEditMode(arg_51_0)
	if not arg_51_0.vars then
		return 
	end
	
	return arg_51_0.vars.is_playlist_edit_mode
end

function MusicBoxUI.turnOnPlaylistEditMode(arg_52_0)
	if not arg_52_0.vars then
		return 
	end
	
	local var_52_0 = MusicBox:getSelectedAlbumID()
	
	MusicBox:setSelectPlaylist(MusicBox:getAlbumSongs(var_52_0), {
		album_id = var_52_0
	})
	
	if var_52_0 == MusicBox:getTargetAlbumID() then
		MusicBox:setTrack(MusicBox:getSelectTrack(MusicBox:getTargetSongID()))
	end
	
	arg_52_0.vars.is_playlist_edit_mode = true
end

function MusicBoxUI.turnOffPlaylistEditMode(arg_53_0)
	if not arg_53_0.vars then
		return 
	end
	
	arg_53_0.vars.is_playlist_edit_mode = false
end

function MusicBoxUI.editUp(arg_54_0, arg_54_1)
	if not arg_54_0.vars then
		return 
	end
	
	local var_54_0 = string.sub(MusicBox:getSelectedAlbumID(), -1)
	local var_54_1 = MusicBox:getAlbumSongIDs(MusicBox:getMyAlbumID(var_54_0))
	
	for iter_54_0, iter_54_1 in pairs(var_54_1) do
		if var_54_1[iter_54_0] == arg_54_1.id then
			local var_54_2 = math.max(1, iter_54_0 - 1)
			
			var_54_1[iter_54_0], var_54_1[var_54_2] = var_54_1[var_54_2], var_54_1[iter_54_0]
			
			break
		end
	end
	
	arg_54_0.vars._playlist_y = arg_54_0.vars.listview_playlist:getInnerContainerPosition().y
	
	query("replace_album_list", {
		album_number = to_n(var_54_0),
		music_list = json.encode(var_54_1)
	})
end

function MusicBoxUI.editDown(arg_55_0, arg_55_1)
	if not arg_55_0.vars then
		return 
	end
	
	local var_55_0 = string.sub(MusicBox:getSelectedAlbumID(), -1)
	local var_55_1 = MusicBox:getAlbumSongIDs(MusicBox:getMyAlbumID(var_55_0))
	
	for iter_55_0, iter_55_1 in pairs(var_55_1) do
		if var_55_1[iter_55_0] == arg_55_1.id then
			local var_55_2 = math.min(#var_55_1, iter_55_0 + 1)
			
			var_55_1[iter_55_0], var_55_1[var_55_2] = var_55_1[var_55_2], var_55_1[iter_55_0]
			
			break
		end
	end
	
	arg_55_0.vars._playlist_y = arg_55_0.vars.listview_playlist:getInnerContainerPosition().y
	
	query("replace_album_list", {
		album_number = to_n(var_55_0),
		music_list = json.encode(var_55_1)
	})
end

function MusicBoxUI.editRemove(arg_56_0, arg_56_1)
	if not arg_56_0.vars then
		return 
	end
	
	local var_56_0 = string.sub(MusicBox:getSelectedAlbumID(), -1)
	local var_56_1 = {
		remove = true,
		album_number = var_56_0,
		music_id = arg_56_1.id
	}
	
	for iter_56_0, iter_56_1 in pairs(MusicBox:getMyAlbumSongs(var_56_0)) do
		if iter_56_1.id == arg_56_1.id and iter_56_1.my_album_ids and iter_56_1.my_album_ids[var_56_0] then
			iter_56_1.my_album_ids[var_56_0] = nil
		end
	end
	
	arg_56_0.vars._playlist_y = arg_56_0.vars.listview_playlist:getInnerContainerPosition().y
	arg_56_0.vars._rm_flag = true
	
	query("edit_album_list", var_56_1)
end

function MusicBoxUI.playEff(arg_57_0, arg_57_1)
	if not get_cocos_refid(arg_57_1) then
		return 
	end
	
	local var_57_0 = arg_57_1:getChildByName("n_eff")
	
	if not get_cocos_refid(var_57_0) then
		return 
	end
	
	if var_57_0:getChildByName("eff_play") then
		return 
	end
	
	EffectManager:Play({
		z = 1,
		fn = "eff_musicplayer_on.cfx",
		y = 0,
		x = 0,
		layer = var_57_0
	}):setName("eff_play")
end

function MusicBoxUI.stopEff(arg_58_0, arg_58_1)
	if not get_cocos_refid(arg_58_1) then
		return 
	end
	
	local var_58_0 = arg_58_1:getChildByName("eff_play")
	
	if not get_cocos_refid(var_58_0) then
		return 
	end
	
	var_58_0:removeFromParent()
end

function MusicBoxUI.onUpdateSongCard(arg_59_0, arg_59_1, arg_59_2, arg_59_3)
	if get_cocos_refid(arg_59_1) then
		arg_59_1.song_data = arg_59_3
		arg_59_1:getChildByName("btn_song").song_data = arg_59_3
		arg_59_1:getChildByName("btn_song").song_data.index = arg_59_2
		arg_59_1:getChildByName("n_edit_mode").song_data = arg_59_3
	end
	
	if_set(arg_59_1, "t_song_title", T(arg_59_3.song_title))
	if_set(arg_59_1, "t_sub", T(arg_59_3.song_desc))
	
	if not PRODUCTION_MODE and arg_59_3.length == 0 then
		if_set_color(arg_59_1, nil, cc.c3b(255, 78, 78))
	end
	
	if MusicBox:isBestAlbumSelected() then
		local var_59_0 = arg_59_1:getChildByName("panel_txt_roll"):getContentSize()
		
		arg_59_1:getChildByName("panel_txt_roll"):setContentSize(276, var_59_0.height)
	end
	
	if_set_visible(arg_59_1, "n_like", MusicBox:isBestAlbumSelected() and not arg_59_0.vars.is_playlist_edit_mode)
	if_set_visible(arg_59_1, "n_common", not MusicBox:isBestAlbumSelected() and not arg_59_0.vars.is_playlist_edit_mode)
	
	local var_59_1 = arg_59_1:getChildByName(MusicBox:isBestAlbumSelected() and "n_like" or "n_common")
	
	if_set(var_59_1, "time1", var_0_0(arg_59_3.length))
	if_set(var_59_1, "count", MusicBox:getFavoriteCount(arg_59_3.id))
	if_set_visible(arg_59_1, "n_edit_mode", arg_59_0.vars.is_playlist_edit_mode)
	if_set_sprite(arg_59_1, "song_icon", "musicplayer/" .. arg_59_3.song_img)
	
	if MusicBox:getTargetSongID() == arg_59_3.id then
		arg_59_0:selectSongCard(arg_59_1, {
			fade_tm = 100
		})
	else
		arg_59_0:unselectSongCard(arg_59_1)
	end
	
	local var_59_2 = MusicBox:isFavoriteSong(arg_59_3.id)
	
	if_set_sprite(var_59_1, "icon_like", var_59_2 and "cm_icon_like.png" or "cm_icon_unlike.png")
	
	local var_59_3 = arg_59_3.new
	local var_59_4 = arg_59_3.recom and arg_59_3.recom == "y"
	
	if_set_visible(arg_59_1, "badge", var_59_4 or var_59_3)
	
	if var_59_3 then
		if_set_sprite(arg_59_1, "badge", "_new.png")
	end
	
	arg_59_3.lock = not MusicBox:isUnLock(arg_59_3.lock_id)
	
	if arg_59_3.lock then
		if_set(arg_59_1, "t_sub", T("ui_mp_lock_none"))
		if_set_opacity(arg_59_1, "song_icon", 127.5)
		if_set_opacity(arg_59_1, "t_song_title", 127.5)
		if_set_opacity(arg_59_1, "t_sub", 76.5)
		arg_59_1:getChildByName("t_sub"):setTextColor(tocolor("#ffffff"))
		
		if MusicBox:isBestAlbumSelected() then
			if_set_visible(arg_59_1:getChildByName("n_like"), "time1", false)
			if_set_opacity(arg_59_1, "n_like", 76.5)
			arg_59_1:getChildByName("lock"):setPositionX(390)
		end
	else
		if_set_opacity(arg_59_1, "n_song", 255)
	end
	
	if_set_visible(arg_59_1, "lock", arg_59_3.lock)
	
	if arg_59_1:getChildByName("n_common"):isVisible() then
		if_set_visible(arg_59_1, "n_common", not arg_59_3.lock)
	end
end

function MusicBoxUI.getSongFromFavoriteToggleButton(arg_60_0, arg_60_1)
	if not get_cocos_refid(arg_60_1) then
		return 
	end
	
	if arg_60_1:getName() ~= "btn_like" then
		return 
	end
	
	local var_60_0 = arg_60_1:getParent():getParent()
	
	if not get_cocos_refid(var_60_0) then
		return 
	end
	
	if not var_60_0.song_data then
		return 
	end
	
	return var_60_0.song_data
end

function MusicBoxUI.initPlaylist(arg_61_0)
	if not arg_61_0.vars then
		return 
	end
	
	arg_61_0.vars.listview_playlist = ItemListView_v2:bindControl(arg_61_0.vars.wnd:getChildByName("scr_view_song"))
	
	local var_61_0 = load_control("wnd/music_player_s_card.csb")
	
	if arg_61_0.vars.listview_playlist.STRETCH_INFO then
		local var_61_1 = arg_61_0.vars.listview_playlist:getContentSize()
		
		resetControlPosAndSize(var_61_0, var_61_1.width, arg_61_0.vars.listview_playlist.STRETCH_INFO.width_prev)
	end
	
	arg_61_0.vars.listview_playlist:setRenderer(var_61_0, {
		onUpdate = function(arg_62_0, arg_62_1, arg_62_2, arg_62_3)
			arg_61_0:onUpdateSongCard(arg_62_1, arg_62_2, arg_62_3)
		end
	})
end

function MusicBoxUI.jumpToTargetAlbum(arg_63_0)
	if not arg_63_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_63_0.vars.listview_albums) then
		return 
	end
	
	local var_63_0 = MusicBox:getSelectedAlbumID()
	
	if not var_63_0 then
		arg_63_0.vars.listview_albums:jumpToTop()
		
		return 
	end
	
	local var_63_1 = MusicBox:getAllAlbums()
	local var_63_2 = 1
	
	for iter_63_0, iter_63_1 in pairs(var_63_1) do
		if iter_63_1.id == var_63_0 then
			var_63_2 = iter_63_0
			
			break
		end
	end
	
	local var_63_3 = #var_63_1
	
	if var_63_3 < 2 then
		arg_63_0.vars.listview_albums:jumpToTop()
		
		return 
	end
	
	local var_63_4 = (var_63_2 - 1) / (var_63_3 - 1) * 100
	
	arg_63_0.vars.listview_albums:scrollToPercentVertical(var_63_4, 0.3, true)
end

function MusicBoxUI.onSetAlbum(arg_64_0, arg_64_1)
	if not arg_64_0:isShow() then
		return 
	end
	
	local var_64_0 = arg_64_0.vars.n_selected_album_card
	
	if get_cocos_refid(var_64_0) then
		if_set_visible(var_64_0, "_selected", false)
	end
	
	arg_64_0.vars.n_selected_album_card = arg_64_0:getAlbumCard(arg_64_1)
	
	if_set_visible(arg_64_0.vars.n_selected_album_card, "_selected", true)
	arg_64_0.vars.listview_playlist:jumpToTop()
	arg_64_0:updateUI()
end

function MusicBoxUI.updatePlaylistPosition(arg_65_0)
	local var_65_0 = table.count(arg_65_0.vars.listview_playlist:getChildren() or {})
	
	arg_65_0.vars.listview_playlist:setInnerContainerSize({
		width = 495,
		height = 81 * var_65_0
	})
	
	if arg_65_0.vars._playlist_y then
		if arg_65_0.vars._playlist_y < arg_65_0.vars.listview_playlist:getTopYPosition() then
			arg_65_0.vars.listview_playlist:jumpToTop()
		else
			arg_65_0.vars.listview_playlist:setInnerContainerPosition({
				x = 0,
				y = arg_65_0.vars._playlist_y or 0
			})
		end
		
		arg_65_0.vars._playlist_y = nil
	else
		local var_65_1 = MusicBox:getTargetSongID()
		
		if MusicBoxUI:getSongCardByID(var_65_1) then
			arg_65_0.vars.listview_playlist:jumpToIndex(MusicBox:getTargetTrack())
		else
			arg_65_0.vars.listview_playlist:jumpToTop()
		end
	end
end

function MusicBoxUI.onSetPlaylist(arg_66_0, arg_66_1)
	if not arg_66_0:isShow() then
		return 
	end
	
	arg_66_0:hideBestAlbumCountOptionLayer()
	arg_66_0.vars.listview_playlist:removeAllChildren()
	arg_66_0.vars.listview_playlist:setDataSource(arg_66_1)
	arg_66_0:updatePlaylistPosition()
	arg_66_0:updateMusicUIShuffle()
	arg_66_0:updatePlaylist()
	arg_66_0:updateAlbumList()
end

function MusicBoxUI.setAlbumCardImage(arg_67_0, arg_67_1)
	if not arg_67_1 then
		return 
	end
	
	local var_67_0 = arg_67_1.album_data
	
	if not var_67_0 then
		return 
	end
	
	local var_67_1 = var_67_0.album_img or ""
	
	if_set_sprite(arg_67_1, "a_cover", "musicplayer/" .. var_67_1)
end

function MusicBoxUI.setAlbumCardTitle(arg_68_0, arg_68_1)
	if not arg_68_1 then
		return 
	end
	
	local var_68_0 = arg_68_1.album_data
	
	if not var_68_0 then
		return 
	end
	
	local var_68_1 = var_68_0.album_title
	local var_68_2 = arg_68_1:getChildByName("label")
	
	if not get_cocos_refid(var_68_2) then
		return 
	end
	
	if_set(var_68_2, nil, var_68_1)
	
	local var_68_3 = var_68_2:getStringNumLines() == 1 and "MULTI_SCALE_LONG_WORD()" or "MULTI_SCALE_LONG_WORD(), MULTI_SCALE(2, 60)"
	
	UIUserData:call(var_68_2, var_68_3)
end

function MusicBoxUI.setAlbumCardLocked(arg_69_0, arg_69_1)
	if not arg_69_1 then
		return 
	end
	
	local var_69_0 = arg_69_1.album_data
	
	if not var_69_0 then
		return 
	end
	
	if not (string.starts(var_69_0.album_id, "episode") or var_69_0.album_id == "substory") then
		return 
	end
	
	if table.count(MusicBox:getAlbumSongs(var_69_0.album_id, {
		without_lock_music = true
	})) ~= 0 then
		return 
	end
	
	if_set_opacity(arg_69_1, nil, 76.5)
	if_set_visible(arg_69_1, "lock", true)
end

function MusicBoxUI.onUpdateAlbumCard(arg_70_0, arg_70_1, arg_70_2, arg_70_3)
	arg_70_1.album_data = arg_70_3
	
	local var_70_0 = arg_70_1:getChildByName("btn_a")
	
	if get_cocos_refid(var_70_0) then
		var_70_0.album_data = arg_70_3
	end
	
	local var_70_1 = MusicBox:getSelectedAlbumID() == arg_70_3.album_id
	
	if_set_visible(arg_70_1, "_selected", var_70_1)
	
	if MusicBox:getTargetAlbumID() == arg_70_3.album_id and MusicBox:isPlaying() then
		arg_70_0:playEff(arg_70_1)
	else
		arg_70_0:stopEff(arg_70_1)
	end
	
	arg_70_0:setAlbumCardImage(arg_70_1)
	arg_70_0:setAlbumCardTitle(arg_70_1)
	arg_70_0:setAlbumCardLocked(arg_70_1)
end

function MusicBoxUI.initAlbumListview(arg_71_0)
	if not arg_71_0.vars then
		return 
	end
	
	arg_71_0.vars.listview_albums = ItemListView_v2:bindControl(arg_71_0.vars.wnd:getChildByName("scr_view_album"))
	
	local var_71_0 = load_control("wnd/music_player_a_card.csb")
	
	if arg_71_0.vars.listview_albums.STRETCH_INFO then
		local var_71_1 = listview:getContentSize()
		
		resetControlPosAndSize(var_71_0, var_71_1.width, arg_71_0.vars.listview_albums.STRETCH_INFO.width_prev)
	end
	
	arg_71_0.vars.listview_albums:setRenderer(var_71_0, {
		onUpdate = function(arg_72_0, arg_72_1, arg_72_2, arg_72_3)
			arg_71_0:onUpdateAlbumCard(arg_72_1, arg_72_2, arg_72_3)
		end
	})
	arg_71_0.vars.listview_albums:removeAllChildren()
	arg_71_0.vars.listview_albums:setDataSource(MusicBox:getAllAlbums())
	arg_71_0.vars.listview_albums:jumpToTop()
end

function MusicBoxUI.onPlayUpdate(arg_73_0)
	if not arg_73_0:isShow() then
		return 
	end
	
	if not MusicBox:getTargetSong() then
		return 
	end
	
	if not MusicBox:isPlaying() then
		return 
	end
	
	if arg_73_0.vars.is_operating_playtime_slider then
		return 
	end
	
	arg_73_0:updatePlaytimeSlider(MusicBox:getCurrentPlaytime())
end

function MusicBoxUI.isShow(arg_74_0)
	if not arg_74_0.vars then
		return false
	end
	
	if not get_cocos_refid(arg_74_0.vars.wnd) then
		return false
	end
	
	return arg_74_0.vars.wnd:isVisible()
end

function MusicBoxUI.PlaytimeSliderListener(arg_75_0, arg_75_1, arg_75_2)
	local var_75_0 = MusicBox:getTargetSong()
	
	if not var_75_0 then
		return 
	end
	
	local var_75_1 = arg_75_0.vars.wnd:getChildByName("song_loading"):getPercent() * 0.01
	local var_75_2 = arg_75_1:getPercent()
	local var_75_3 = var_75_2 / var_75_0.length
	
	if MusicBox:getTargetSongStreamingID() and get_cocos_refid(SoundEngine.bgm_se) and var_75_1 < 0.95 then
		local var_75_4 = var_75_1 - 0.05
		
		if var_75_1 < var_75_3 or var_75_4 < var_75_3 then
			var_75_2 = (var_75_4 > 0 and var_75_4 or 0) * var_75_0.length
		end
	end
	
	MusicBox:setPlayPos(var_75_2)
	
	if arg_75_2 == 0 then
	elseif arg_75_2 == 1 then
		arg_75_0.vars.is_operating_playtime_slider = true
	elseif arg_75_2 == 2 then
		MusicBox:setSameSong(true)
		
		if MusicBox:isPlaying() then
			if UIAction:Find("delay_slider") then
				UIAction:Remove("delay_slider")
			end
			
			UIAction:Add(SEQ(DELAY(200), CALL(function()
				arg_75_0.vars.is_operating_playtime_slider = false
			end)), arg_75_0.vars.wnd, "delay_slider")
			MusicBox:play({
				pos = var_75_2
			})
		else
			arg_75_0.vars.is_operating_playtime_slider = false
		end
	end
	
	arg_75_0:updatePlaytimeSlider(var_75_2)
end

function MusicBoxUI.bindDelegate(arg_77_0)
	MusicBox.onPlay:add("music_box_ui", function()
		arg_77_0:onPlay()
	end)
	MusicBox.onStop:add("music_box_ui", function()
		arg_77_0:onStop()
	end)
	MusicBox.onUpdateLoadingBar:add("music_box_ui", function(arg_80_0)
		arg_77_0:onUpdateLoadingBar(arg_80_0)
	end)
	MusicBox.onPlayUpdate:add("music_box_ui", function()
		arg_77_0:onPlayUpdate()
	end)
	MusicBox.onSetAlbum:add("music_box_ui", function(arg_82_0)
		arg_77_0:onSetAlbum(arg_82_0)
	end)
	MusicBox.onSetTrack:add("music_box_ui", function(arg_83_0)
		arg_77_0:onSetTrack(arg_83_0)
	end)
	MusicBox.onSetSelectPlaylist:add("music_box_ui", function(arg_84_0)
		arg_77_0:onSetPlaylist(arg_84_0)
	end)
	MusicBox.onSwitchLoopType:add("music_box_ui", function()
		arg_77_0:onSwitchLoopType()
	end)
	MusicBox.onUpdateFavorite:add("music_box_ui", function(arg_86_0, arg_86_1)
		arg_77_0:onUpdateFavorite(arg_86_0, arg_86_1)
	end)
end

function MusicBoxUI.unbindDelegate(arg_87_0)
	MusicBox.onPlay:remove("music_box_ui")
	MusicBox.onStop:remove("music_box_ui")
	MusicBox.onUpdateLoadingBar:remove("music_box_ui")
	MusicBox.onPlayUpdate:remove("music_box_ui")
	MusicBox.onSetAlbum:remove("music_box_ui")
	MusicBox.onSetTrack:remove("music_box_ui")
	MusicBox.onSetSelectPlaylist:remove("music_box_ui")
	MusicBox.onSwitchLoopType:remove("music_box_ui")
	MusicBox.onUpdateFavorite:remove("music_box_ui")
end

function MusicBoxUI.updateShowBtnMovie(arg_88_0)
	if not arg_88_0.vars then
		return 
	end
	
	if_set_visible(arg_88_0.vars.wnd, "btn_movie", MusicBox:getTargetSongVideoUrl())
end

function MusicBoxUI.onSwitchLoopType(arg_89_0)
	if not arg_89_0:isShow() then
		return 
	end
	
	arg_89_0:updateMusicUILoop()
end

function MusicBoxUI.getTargetSongCard(arg_90_0)
	return arg_90_0:getSongCardByID(MusicBox:getTargetSongID())
end

function MusicBoxUI.updatePlayButton(arg_91_0)
	if not arg_91_0.vars then
		return 
	end
	
	local var_91_0 = MusicBox:isPlaying()
	
	if_set_visible(arg_91_0.vars.wnd, "icon_menu_pause", var_91_0)
	if_set_visible(arg_91_0.vars.wnd, "icon_menu_play", not var_91_0)
end

function MusicBoxUI.updatePlaytimeSlider(arg_92_0, arg_92_1)
	if not arg_92_1 then
		return 
	end
	
	local var_92_0 = MusicBox:getTargetSong()
	
	if not var_92_0 then
		return 
	end
	
	if_set(arg_92_0.vars.wnd, "time1", var_0_0(arg_92_1))
	if_set(arg_92_0.vars.wnd, "time2", var_0_0(var_92_0.length - arg_92_1))
	
	if not arg_92_0.vars.is_operating_playtime_slider then
		arg_92_0.vars.playtime_slider:setPercent(arg_92_1)
	end
end

function MusicBoxUI.updateMusicUIFavorite(arg_93_0, arg_93_1)
	if not arg_93_0:isShow() then
		return 
	end
	
	arg_93_0:actionToggleFavorite(arg_93_0.vars.wnd, arg_93_1)
end

function MusicBoxUI.updateMusicUILoop(arg_94_0)
	if_set_visible(arg_94_0.vars.wnd, "t_1", MusicBox:getLoopType() == MusicBox.LOOP_TYPE.ONE_LOOP)
	if_set_visible(arg_94_0.vars.wnd, "t_a", MusicBox:getLoopType() == MusicBox.LOOP_TYPE.LIST_LOOP)
	if_set_opacity(arg_94_0.vars.wnd, "btn_repeat", MusicBox:getLoopType() == MusicBox.LOOP_TYPE.NONE and 76.5 or 255)
end

function MusicBoxUI.updateMusicUIShuffle(arg_95_0)
	if_set_opacity(arg_95_0.vars.wnd, "btn_shuff", MusicBox:isTargetPlaylistShuffle() and 255 or 76.5)
end

function MusicBoxUI.updateMusicUI(arg_96_0)
	if not arg_96_0:isShow() then
		return 
	end
	
	local var_96_0 = MusicBox:getTargetSong()
	
	if not var_96_0 then
		return 
	end
	
	if_set_visible(arg_96_0.vars.wnd, "song_loading", MusicBox:getTargetSongStreamingID())
	
	if get_cocos_refid(SoundEngine.bgm_se) and SoundEngine.bgm_se.getAvailableRate and MusicBox:isPlaying() then
		arg_96_0:onUpdateLoadingBar(SoundEngine.bgm_se:getAvailableRate())
	end
	
	if MusicBox:isPlaying() then
		arg_96_0:playEff(arg_96_0.vars.wnd)
	else
		arg_96_0:stopEff(arg_96_0.vars.wnd)
	end
	
	if_set(arg_96_0.vars.wnd, "t_a_title", MusicBox:getTargetAlbumTitle())
	if_set_sprite(arg_96_0.vars.wnd, "img_album_cover", "musicplayer/" .. MusicBox:getTargetAlbumImage())
	if_set_sprite(arg_96_0.vars.wnd, "icon_song", "musicplayer/" .. var_96_0.song_img)
	if_set(arg_96_0.vars.wnd, "t_song_title", T(var_96_0.song_title))
	if_set(arg_96_0.vars.wnd, "t_sub", T(var_96_0.song_desc))
	arg_96_0:makeLoopText(arg_96_0.vars.wnd, 9000)
	if_set_sprite(arg_96_0.vars.wnd, "icon_like", MusicBox:isFavoriteSong(var_96_0.id) and "cm_icon_like.png" or "cm_icon_unlike.png")
	arg_96_0:updateMusicUILoop()
	arg_96_0:updateMusicUIShuffle()
	arg_96_0:updatePlaytimeSlider(MusicBox:getCurrentPlaytime())
	arg_96_0:updatePlayButton()
	arg_96_0:updateShowBtnMovie()
end

function MusicBoxUI.getAlbumCard(arg_97_0, arg_97_1)
	if not arg_97_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_97_0.vars.listview_albums) then
		return 
	end
	
	local var_97_0 = arg_97_0.vars.listview_albums:getChildren()
	
	for iter_97_0, iter_97_1 in pairs(var_97_0 or {}) do
		local var_97_1 = iter_97_1:getChildByName("music_player_a_card")
		
		if var_97_1 and var_97_1.album_data and var_97_1.album_data.id == arg_97_1 then
			return var_97_1
		end
	end
end

function MusicBoxUI.getSelectedAlbumCard(arg_98_0)
	return arg_98_0:getAlbumCard(MusicBox:getSelectedAlbumID())
end

function MusicBoxUI.getSongCardByID(arg_99_0, arg_99_1)
	if not arg_99_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_99_0.vars.listview_playlist) then
		return 
	end
	
	local var_99_0 = arg_99_0.vars.listview_playlist:getChildren()
	
	for iter_99_0, iter_99_1 in pairs(var_99_0 or {}) do
		local var_99_1 = iter_99_1:getChildByName("music_player_s_card")
		
		if var_99_1 and var_99_1.song_data and var_99_1.song_data.id == arg_99_1 then
			return var_99_1
		end
	end
	
	return nil
end

function MusicBoxUI.close(arg_100_0)
	if not arg_100_0.vars or not get_cocos_refid(arg_100_0.vars.wnd) then
		return 
	end
	
	BackButtonManager:pop({
		check_id = "TopBarNew." .. T("ui_title_musicplayer"),
		dlg = arg_100_0.vars.wnd
	})
	
	if TOP_BAR_STACK[#TOP_BAR_STACK] and TOP_BAR_STACK[#TOP_BAR_STACK].title_name == T("ui_title_musicplayer") then
		TopBarNew:pop()
	end
	
	arg_100_0:unbindDelegate()
	
	if get_cocos_refid(arg_100_0.vars.wnd) then
		arg_100_0.vars.wnd:removeFromParent()
		
		arg_100_0.vars.wnd = 0
	end
	
	arg_100_0.vars = nil
end

function MusicBoxUI.onUpdateLoadingBar(arg_101_0, arg_101_1)
	if not arg_101_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_101_0.vars.wnd) then
		return 
	end
	
	if not arg_101_0:isShow() then
		return 
	end
	
	if_set_percent(arg_101_0.vars.wnd, "song_loading", arg_101_1)
	if_set_visible(arg_101_0.vars.wnd, "song_loading", MusicBox:isPlaying() and MusicBox:getTargetSongStreamingID())
end

function MusicBoxUI.show(arg_102_0)
	if not MusicBox:isValid() then
		query("get_music_box_info")
		
		return 
	end
	
	if arg_102_0:isShow() then
		return 
	end
	
	if arg_102_0.vars and get_cocos_refid(arg_102_0.vars.wnd) and arg_102_0.vars.wnd:isVisible() == false then
		arg_102_0:close()
	end
	
	arg_102_0:bindDelegate()
	
	arg_102_0.vars = {}
	arg_102_0.vars.wnd = load_dlg("music_player", true, "wnd")
	
	SceneManager:getRunningPopupScene():addChild(arg_102_0.vars.wnd)
	TopBarNew:createFromPopup(T("ui_title_musicplayer"), arg_102_0.vars.wnd, function()
		arg_102_0:close()
	end)
	if_set(arg_102_0.vars.wnd, "txt_search", T("ui_mp_search"))
	if_set(arg_102_0.vars.wnd, "txt_sort", T("ui_mp_best_month"))
	if_set(arg_102_0.vars.wnd:getChildByName("btn_list_edit"), "label", T("ui_mp_listedit"))
	if_set(arg_102_0.vars.wnd:getChildByName("btn_list_edit_active"), "label", T("ui_mp_listedit"))
	arg_102_0:hideSearchLayer()
	
	arg_102_0.vars.playtime_slider = arg_102_0.vars.wnd:getChildByName("song_slider")
	
	arg_102_0.vars.playtime_slider:addEventListener(function(arg_104_0, arg_104_1)
		arg_102_0:PlaytimeSliderListener(arg_104_0, arg_104_1)
	end)
	
	local var_102_0 = 0
	
	if get_cocos_refid(SoundEngine.bgm_se) and SoundEngine.bgm_se.getAvailableRate and MusicBox:isPlaying() then
		var_102_0 = SoundEngine.bgm_se:getAvailableRate()
	end
	
	arg_102_0:onUpdateLoadingBar(var_102_0)
	arg_102_0:initAlbumListview()
	arg_102_0:initPlaylist()
	
	if MusicBox:getTargetTrack() then
		MusicBox:setSelectPlaylist(MusicBox:getTargetPlaylist(), {
			album_id = MusicBox:getTargetAlbumID(),
			is_shuffle = MusicBox:isTargetPlaylistShuffle()
		})
		MusicBox:setTrack(MusicBox:getTargetTrack())
	else
		local var_102_1 = MusicBox:getTargetSong()
		
		if var_102_1 then
			MusicBox:setSelectPlaylist(MusicBox:getAlbumSongs(var_102_1.album), {
				album_id = var_102_1.album
			})
			
			local var_102_2 = MusicBox:getSelectTrack(var_102_1.id)
			
			MusicBox:setTrack(var_102_2)
		else
			MusicBox:setSelectPlaylist(MusicBox:getAlbumSongs(MusicBox.DEFAULT_ALBUM_ID), {
				is_shuffle = false,
				album_id = MusicBox.DEFAULT_ALBUM_ID
			})
			MusicBox:setTrack(1)
		end
	end
	
	arg_102_0:updateUI()
	UIAction:Add(SEQ(DELAY(1), CALL(function()
		arg_102_0:jumpToTargetAlbum()
	end)), arg_102_0.vars.wnd, "delay")
end
