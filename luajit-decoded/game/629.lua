ArenaNetMusicBox = {}
ArenaNetMusicBox.DEFAULT_SONG_ID = "bgm_rta_lounge2"

function HANDLER.pvplive_lounge_music_sel(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_play" then
		return 
	end
	
	if arg_1_1 == "btn_close" then
		ArenaNetMusicBox:close()
		
		return 
	end
end

function HANDLER.music_player_a_card_simple(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_a" then
		ArenaNetMusicBox:selectAlbum(arg_2_0.datasource.album_id, arg_2_0:getParent())
		
		return 
	end
end

function HANDLER.music_player_s_card_simple(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_a" then
		local var_3_0 = ArenaNetMusicBox:getSongID(arg_3_0:getParent())
		
		ArenaNetMusicBox:selectSongNode(var_3_0)
		
		return 
	end
end

function ArenaNetMusicBox.requestShowSimple(arg_4_0)
	if not MusicBox.server_data then
		query("get_music_box_info")
		
		return 
	end
	
	ArenaNetMusicBox:show({
		service = ArenaNetLounge.vars.service,
		cur_bgm_id = ArenaNetLounge.vars.bgm_id,
		callback = function(arg_5_0)
			ArenaNetLounge:onChangeBGM(arg_5_0)
		end
	})
end

function ArenaNetMusicBox.show(arg_6_0, arg_6_1)
	if arg_6_0.vars and arg_6_0.vars.wnd and get_cocos_refid(arg_6_0.vars.wnd) then
		arg_6_0.vars.wnd:setVisible(true)
		
		return 
	end
	
	arg_6_1 = arg_6_1 or {}
	arg_6_0.vars = {}
	arg_6_0.vars.wnd = load_dlg("pvplive_lounge_music_sel", true, "wnd", function()
		arg_6_0:close()
	end)
	arg_6_0.vars.callback = arg_6_1.callback
	
	arg_6_0:init()
	SceneManager:getRunningPopupScene():addChild(arg_6_0.vars.wnd)
end

function ArenaNetMusicBox.selectSongNode(arg_8_0, arg_8_1)
	if not arg_8_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_8_0.vars.wnd) then
		return 
	end
	
	local var_8_0 = arg_8_0:getSongNode(arg_8_1)
	
	if not get_cocos_refid(var_8_0) then
		return 
	end
	
	if arg_8_0.vars.selected_song_id == arg_8_1 then
		arg_8_0.vars.selected_song_id = nil
		
		arg_8_0:play(arg_8_0.DEFAULT_SONG_ID)
	else
		local var_8_1 = arg_8_0:getSongNode(arg_8_0.vars.selected_song_id)
		
		arg_8_0.vars.selected_song_id = arg_8_1
		
		arg_8_0:play(arg_8_1)
		arg_8_0:updateSongNodeUI(var_8_1)
	end
	
	arg_8_0:updateSongNodeUI(arg_8_0:getSongNode(arg_8_0.DEFAULT_SONG_ID))
	arg_8_0:updateSongNodeUI(var_8_0)
end

function ArenaNetMusicBox.getPlayingSongID(arg_9_0)
	return ArenaNetLounge.vars.playing_song_id
end

function ArenaNetMusicBox.updateSongNodeUI(arg_10_0, arg_10_1)
	if not arg_10_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_10_0.vars.wnd) then
		return 
	end
	
	if arg_10_0:getPlayingSongID() == arg_10_0:getSongID(arg_10_1) then
		MusicBoxUI:makeLoopText(arg_10_1, 9000)
		MusicBoxUI:playEff(arg_10_1)
	else
		MusicBoxUI:resetLoopText(arg_10_1)
		MusicBoxUI:stopEff(arg_10_1)
	end
	
	local var_10_0 = arg_10_0.vars.selected_song_id == arg_10_0:getSongID(arg_10_1)
	
	if_set_visible(arg_10_1, "selected", var_10_0)
end

function ArenaNetMusicBox.getSongID(arg_11_0, arg_11_1)
	if not arg_11_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_11_1) then
		return 
	end
	
	local var_11_0 = arg_11_1:getChildByName("btn_a")
	
	if not get_cocos_refid(var_11_0) then
		return 
	end
	
	return var_11_0.datasource.id
end

function ArenaNetMusicBox.selectAlbum(arg_12_0, arg_12_1, arg_12_2)
	if not arg_12_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_12_0.vars.wnd) then
		return 
	end
	
	if arg_12_0.vars.selected_album then
		if_set_visible(arg_12_0.vars.selected_album, "selected", false)
	end
	
	if get_cocos_refid(arg_12_2) then
		arg_12_0.vars.selected_album = arg_12_2
		
		if_set_visible(arg_12_0.vars.selected_album, "selected", true)
	end
	
	local var_12_0 = MusicBox:getAlbumSongs(arg_12_1, {
		without_lock_music = true
	})
	
	if_set_visible(arg_12_0.vars.wnd, "scr_view_song", table.count(var_12_0 or {}) > 0)
	if_set_visible(arg_12_0.vars.wnd, "no_data", table.count(var_12_0 or {}) == 0)
	
	if arg_12_0.vars.playlist_scroll_view then
		arg_12_0.vars.playlist_scroll_view:createScrollViewItems(var_12_0)
		
		local var_12_1, var_12_2 = arg_12_0:getSongNode(arg_12_0:getPlayingSongID())
		
		if var_12_2 then
			arg_12_0.vars.playlist_scroll_view:jumpToIndex(var_12_2)
		end
	end
end

function ArenaNetMusicBox.initAlbumScrollView(arg_13_0)
	local function var_13_0(arg_14_0, arg_14_1)
		local var_14_0 = load_control("wnd/music_player_a_card_simple.csb")
		
		if_set_visible(var_14_0, "selected", false)
		if_set_sprite(var_14_0, "icon_album", "musicplayer/" .. arg_14_1.album_img)
		if_set(var_14_0, "t_a", arg_14_1.album_title)
		
		var_14_0:getChildByName("btn_a").datasource = arg_14_1
		
		return var_14_0
	end
	
	arg_13_0.vars.album_scroll_view = {}
	
	copy_functions(ScrollView, arg_13_0.vars.album_scroll_view)
	
	arg_13_0.vars.album_scroll_view.getScrollViewItem = var_13_0
	
	arg_13_0.vars.album_scroll_view:initScrollView(arg_13_0.vars.wnd:getChildByName("scr_view_album"), 278, 78)
	arg_13_0.vars.album_scroll_view:createScrollViewItems(MusicBox:getAllAlbums(true))
end

function ArenaNetMusicBox.initPlaylistScrollView(arg_15_0)
	local function var_15_0(arg_16_0, arg_16_1)
		local var_16_0 = load_control("wnd/music_player_s_card_simple.csb")
		
		var_16_0:getChildByName("btn_a").datasource = arg_16_1
		
		if_set(var_16_0, "t_song_title", T(arg_16_1.song_title))
		if_set(var_16_0, "t_sub", T(arg_16_1.song_desc))
		
		if not MusicBox:isUnLock(arg_16_1.lock_id) then
			set_ellipsis_label(var_16_0:getChildByName("t_song_title"), T(arg_16_1.song_title), 245, 10)
			set_ellipsis_label(var_16_0:getChildByName("t_sub"), T(arg_16_1.song_desc), 245, 10)
		end
		
		ArenaNetMusicBox:updateSongNodeUI(var_16_0)
		
		return var_16_0
	end
	
	arg_15_0.vars.playlist_scroll_view = {}
	
	copy_functions(ScrollView, arg_15_0.vars.playlist_scroll_view)
	
	arg_15_0.vars.playlist_scroll_view.getScrollViewItem = var_15_0
	
	arg_15_0.vars.playlist_scroll_view:initScrollView(arg_15_0.vars.wnd:getChildByName("scr_view_song"), 327, 63)
end

function ArenaNetMusicBox.getAlbumNode(arg_17_0, arg_17_1)
	if not arg_17_1 then
		return 
	end
	
	if not get_cocos_refid(arg_17_0.vars.wnd) then
		return 
	end
	
	local var_17_0 = arg_17_0.vars.wnd:getChildByName("scr_view_album")
	
	if not get_cocos_refid(var_17_0) then
		return 
	end
	
	for iter_17_0, iter_17_1 in pairs(var_17_0:getChildren() or {}) do
		local var_17_1 = iter_17_1:getChildByName("btn_a")
		
		if get_cocos_refid(var_17_1) and var_17_1.datasource and var_17_1.datasource.album_id == arg_17_1 then
			return iter_17_1, iter_17_0
		end
	end
end

function ArenaNetMusicBox.getSongNode(arg_18_0, arg_18_1)
	if not arg_18_1 then
		return 
	end
	
	if not get_cocos_refid(arg_18_0.vars.wnd) then
		return 
	end
	
	local var_18_0 = arg_18_0.vars.wnd:getChildByName("scr_view_song")
	
	if not get_cocos_refid(var_18_0) then
		return 
	end
	
	for iter_18_0, iter_18_1 in pairs(var_18_0:getChildren() or {}) do
		local var_18_1 = iter_18_1:getChildByName("btn_a")
		
		if get_cocos_refid(var_18_1) and var_18_1.datasource and var_18_1.datasource.id == arg_18_1 then
			return iter_18_1, iter_18_0
		end
	end
end

function ArenaNetMusicBox.init(arg_19_0)
	if arg_19_0.vars.album_scroll_view then
		return 
	end
	
	MusicBox:init()
	arg_19_0:initAlbumScrollView()
	arg_19_0:initPlaylistScrollView()
	if_set_visible(arg_19_0.vars.wnd, "btn_close", true)
	
	local var_19_0 = ArenaNetLounge.vars.infos.bgm_id or ArenaNetMusicBox.DEFAULT_SONG_ID
	local var_19_1 = MusicBox:getAllSongs()[var_19_0].album
	local var_19_2, var_19_3 = arg_19_0:getAlbumNode(var_19_1)
	
	arg_19_0.vars.album_scroll_view:jumpToIndex(var_19_3)
	arg_19_0:selectAlbum(var_19_1, var_19_2)
	
	local var_19_4, var_19_5 = arg_19_0:getSongNode(var_19_0)
	
	if var_19_5 then
		arg_19_0.vars.playlist_scroll_view:jumpToIndex(var_19_5)
		arg_19_0:selectSongNode(var_19_0)
	end
	
	if_set_visible(arg_19_0.vars.wnd, "icon_menu_play", false)
	if_set_visible(arg_19_0.vars.wnd, "icon_menu_pause", false)
end

function ArenaNetMusicBox.close(arg_20_0)
	if not arg_20_0.vars then
		return 
	end
	
	arg_20_0.vars.wnd:setVisible(false)
end

function ArenaNetMusicBox.stopMusic(arg_21_0)
	if not arg_21_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_21_0.vars.bgm_se) then
		arg_21_0.vars.bgm_se:stop()
	end
end

function ArenaNetMusicBox.play(arg_22_0, arg_22_1)
	arg_22_0.vars.callback(arg_22_1)
	
	local var_22_0 = MusicBox:getSong(arg_22_1).streaming_id
	local var_22_1 = var_22_0 and cc.FileUtils:getInstance():fullPathForFilename("bgm_ost/" .. var_22_0)
	
	SoundEngine:playBGM(var_22_0 and var_22_1 or "event:/bgm/" .. arg_22_1)
	
	ArenaNetLounge.vars.playing_song_id = arg_22_1
end
