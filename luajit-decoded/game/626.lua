MusicBox = MusicBox or {}
MusicBox.vars = MusicBox.vars or {}
MusicBox.onPlay = Delegate.new()
MusicBox.onStop = Delegate.new()
MusicBox.onUpdateLoadingBar = Delegate.new()
MusicBox.onPlayUpdate = Delegate.new()
MusicBox.onSetAlbum = Delegate.new()
MusicBox.onSetTrack = Delegate.new()
MusicBox.onUpdateFavorite = Delegate.new()
MusicBox.onSetSelectPlaylist = Delegate.new()
MusicBox.onSwitchLoopType = Delegate.new()
MusicBox.ALL_ALBUM_ID = "all"
MusicBox.BEST_ALBUM_ID = "best"
MusicBox.FAVORITE_ALBUM_ID = "love"
MusicBox.MY_ALBUM_ID_PREFIX = "my"
MusicBox.SEARCH_ALBUM_ID = "search"
MusicBox.DEFAULT_ALBUM_ID = MusicBox.ALL_ALBUM_ID
MusicBox.MUSIC_BOX_ACTION_NAME = "music_player.playing"
MusicBox.SAVE_KEY = "music_box"
MusicBox.SAVE_KEY_PLAYLIST = "music_box.playlist"
MusicBox.ENABLE_SCENES = {
	"lobby",
	"sanctuary",
	"shop",
	"unit_ui",
	"achievement",
	"pet_ui",
	"clan",
	"pvp",
	"DungeonList",
	"substory_lobby",
	"collection",
	"equip_storage",
	"waitingroom",
	"friend",
	"class_change",
	"growth_boost",
	"growth_guide",
	"substory_album",
	"substory_dlc_main",
	"substory_dlc_lobby"
}

function MusicBox.isEnable(arg_1_0)
	if ContentDisable:byAlias("music_player") then
		return false
	end
	
	if not UnlockSystem:isUnlockSystem(UNLOCK_ID.MUSIC_PLAYER) then
		return false
	end
	
	return true
end

function MusicBox.isInvalidTrack(arg_2_0)
	local var_2_0 = arg_2_0:getTargetTrack()
	local var_2_1 = arg_2_0:getTargetSong()
	
	return not var_2_0 and var_2_1
end

function MusicBox.savePlaylist(arg_3_0)
	if not arg_3_0:isValid() then
		return 
	end
	
	if arg_3_0:isInvalidTrack() then
		local var_3_0 = arg_3_0:getTargetSong()
		
		if var_3_0 then
			SAVE:setKeep(MusicBox.SAVE_KEY_PLAYLIST, json.encode(arg_3_0:getPlaylistToIDs(arg_3_0:getAlbumSongs(var_3_0.album))))
			
			return 
		end
	end
	
	SAVE:setKeep(MusicBox.SAVE_KEY_PLAYLIST, json.encode(arg_3_0:getPlaylistToIDs(arg_3_0:getTargetPlaylist())))
end

function MusicBox.save(arg_4_0)
	if not arg_4_0:isValid() then
		return 
	end
	
	local var_4_0 = {
		song_id = arg_4_0:getTargetSongID(),
		album_id = arg_4_0:getTargetAlbumID(),
		is_playing = arg_4_0:isPlaying() or arg_4_0:isPauseReasonByDisableScene(),
		loop_type = arg_4_0:getLoopType(),
		is_shuffle = arg_4_0:isTargetPlaylistShuffle()
	}
	
	if arg_4_0:isInvalidTrack() then
		local var_4_1 = arg_4_0:getTargetSong()
		
		if var_4_1 then
			var_4_0.album_id = var_4_1.album
		end
	end
	
	SAVE:setKeep(MusicBox.SAVE_KEY, json.encode(var_4_0))
end

function MusicBox.load(arg_5_0)
	if not arg_5_0:isValid() then
		return 
	end
	
	local var_5_0 = json.decode(SAVE:getKeep(MusicBox.SAVE_KEY, ""))
	
	if not var_5_0 then
		arg_5_0:switchLoopType(arg_5_0.LOOP_TYPE.LIST_LOOP)
		
		return 
	end
	
	local var_5_1 = json.decode(SAVE:getKeep(MusicBox.SAVE_KEY_PLAYLIST, ""))
	
	if var_5_1 and not table.empty(var_5_1) then
		arg_5_0:setSelectPlaylist(arg_5_0:getIDsToPlaylist(var_5_1), {
			album_id = var_5_0.album_id,
			is_shuffle = var_5_0.is_shuffle
		})
	else
		arg_5_0:setSelectPlaylist(arg_5_0:getAlbumSongs(var_5_0.album_id or arg_5_0.DEFAULT_ALBUM_ID), {
			album_id = var_5_0.album_id
		})
	end
	
	if var_5_0.song_id then
		arg_5_0:setTrack(arg_5_0:getSelectTrack(var_5_0.song_id) or 1)
	elseif var_5_0.track then
		arg_5_0:setTrack(var_5_0.track)
	end
	
	if var_5_0.loop_type then
		arg_5_0:switchLoopType(var_5_0.loop_type)
	end
	
	if var_5_0.is_playing then
		arg_5_0:play()
	end
end

function MusicBox.removeLastState(arg_6_0)
	SAVE:setKeep(MusicBox.SAVE_KEY, nil)
end

function MusicBox.isEnableScene(arg_7_0, arg_7_1)
	return table.find(arg_7_0.ENABLE_SCENES, arg_7_1)
end

function MusicBox.isTargetPlaylistShuffle(arg_8_0)
	if not arg_8_0.music_data.target then
		return false
	end
	
	arg_8_0.music_data.target.is_shuffle = arg_8_0.music_data.target.is_shuffle or false
	
	return arg_8_0.music_data.target.is_shuffle
end

function MusicBox.isSelectPlaylistShuffle(arg_9_0)
	if not arg_9_0.music_data.select then
		return false
	end
	
	arg_9_0.music_data.select.is_shuffle = arg_9_0.music_data.select.is_shuffle or false
	
	return arg_9_0.music_data.select.is_shuffle
end

function MusicBox.isSelectPlaylistSearch(arg_10_0)
	if not arg_10_0.music_data.select then
		return false
	end
	
	return arg_10_0.music_data.select.album_id == arg_10_0.SEARCH_ALBUM_ID
end

function MusicBox.getTargetSong(arg_11_0)
	if not arg_11_0.music_data then
		return 
	end
	
	if not arg_11_0.music_data.target then
		return 
	end
	
	return arg_11_0.music_data.target.song
end

function MusicBox.getTargetSongVideoUrl(arg_12_0)
	if IS_PUBLISHER_ZLONG then
		return 
	end
	
	local var_12_0 = arg_12_0:getTargetSong()
	
	if not var_12_0 then
		return 
	end
	
	return var_12_0.video_url
end

function MusicBox.getTargetSongID(arg_13_0)
	local var_13_0 = arg_13_0:getTargetSong()
	
	if not var_13_0 then
		return 
	end
	
	return var_13_0.id
end

function MusicBox.getTargetSongStreamingID(arg_14_0)
	local var_14_0 = arg_14_0:getTargetSong()
	
	if not var_14_0 then
		return 
	end
	
	return var_14_0.streaming_id
end

function MusicBox.getTargetSongUnlockID(arg_15_0)
	local var_15_0 = arg_15_0:getTargetSong()
	
	if not var_15_0 then
		return 
	end
	
	return var_15_0.lock_id
end

function MusicBox.getTargetSongLength(arg_16_0)
	local var_16_0 = arg_16_0:getTargetSong()
	
	if not var_16_0 then
		return 0
	end
	
	return var_16_0.length
end

function MusicBox.getCurrentPlayAlbum(arg_17_0)
	return arg_17_0:getTargetSong() and arg_17_0:getTargetSong().album
end

function MusicBox.isPlaying(arg_18_0)
	if not arg_18_0.music_data then
		return false
	end
	
	if not arg_18_0.music_data.target then
		return false
	end
	
	if not arg_18_0.music_data.target.song then
		return false
	end
	
	return arg_18_0.vars.is_playing
end

function MusicBox.isPauseReasonByDisableScene(arg_19_0)
	if arg_19_0:isPlaying() then
		return false
	end
	
	return arg_19_0.vars.is_pause_reason_by_disable_scene
end

function MusicBox.resume(arg_20_0)
	if arg_20_0:isPlaying() then
		return 
	end
	
	arg_20_0:play({
		pos = arg_20_0:getCurrentPlaytime()
	})
end

MusicBox.LOOP_TYPE = {
	ONE_LOOP = 2,
	LIST_LOOP = 1,
	NONE = 0
}

function MusicBox.switchLoopType(arg_21_0, arg_21_1)
	if not arg_21_0.music_data then
		return 
	end
	
	if not arg_21_0.music_data.target then
		return 
	end
	
	if arg_21_1 then
		arg_21_0.vars.loop_type = arg_21_1
	else
		arg_21_0.vars.loop_type = arg_21_0:getLoopType()
		
		if arg_21_0.vars.loop_type == MusicBox.LOOP_TYPE.NONE then
			arg_21_0.vars.loop_type = MusicBox.LOOP_TYPE.LIST_LOOP
		elseif arg_21_0.vars.loop_type == MusicBox.LOOP_TYPE.LIST_LOOP then
			arg_21_0.vars.loop_type = MusicBox.LOOP_TYPE.ONE_LOOP
		elseif arg_21_0.vars.loop_type == MusicBox.LOOP_TYPE.ONE_LOOP then
			arg_21_0.vars.loop_type = MusicBox.LOOP_TYPE.NONE
		end
	end
	
	arg_21_0.onSwitchLoopType()
	arg_21_0:save()
end

function MusicBox.getLoopType(arg_22_0)
	if not arg_22_0.music_data then
		return 
	end
	
	if not arg_22_0.music_data.target then
		return 
	end
	
	return arg_22_0.vars.loop_type or MusicBox.LOOP_TYPE.LIST_LOOP
end

function MusicBox.onTrackIsOver(arg_23_0)
	if not arg_23_0.music_data then
		return 
	end
	
	if not arg_23_0.music_data.target then
		return 
	end
	
	local var_23_0 = arg_23_0:getLoopType()
	
	if var_23_0 == arg_23_0.LOOP_TYPE.ONE_LOOP then
		arg_23_0:play({
			pos = 0
		})
		
		return 
	end
	
	if var_23_0 == arg_23_0.LOOP_TYPE.NONE then
		arg_23_0:stop({
			pos = 0
		})
		
		return 
	end
	
	arg_23_0:next()
end

function MusicBox.setPlayPos(arg_24_0, arg_24_1)
	arg_24_0.vars.play_pos = arg_24_1 or 0
end

function MusicBox.getPlayPos(arg_25_0)
	return arg_25_0.vars.play_pos or 0
end

function MusicBox.togglePlayPause(arg_26_0)
	if arg_26_0:isPlaying() then
		arg_26_0:stop()
		MusicBox:setSameSong(false)
	else
		arg_26_0:resume()
		MusicBox:setSameSong(true)
	end
end

function MusicBox._playStreamingWithFade(arg_27_0, arg_27_1)
	local var_27_0 = arg_27_0:getTargetSong()
	
	if not var_27_0 then
		return 
	end
	
	SoundEngine.bgm_se = SoundEngine:playStreamSound("bgm_ost/" .. arg_27_1, {
		OnStart = function(arg_28_0)
			arg_28_0:setPosition(arg_27_0:getPlayPos())
			
			if arg_28_0:getLength() > 0 then
				MusicBox.music_data.all_songs[var_27_0.id].length = arg_28_0:getLength()
			end
			
			arg_27_0.onPlay()
		end,
		OnUpdate = function(arg_29_0, arg_29_1)
			arg_27_0.onUpdateLoadingBar(arg_29_0)
			
			if arg_29_1:getLength() > 0 and MusicBox.music_data.all_songs[var_27_0.id].length ~= arg_29_1:getLength() then
				MusicBox.music_data.all_songs[var_27_0.id].length = arg_29_1:getLength()
			end
		end
	})
	
	if get_cocos_refid(SoundEngine.bgm_se) then
		SoundEngine.bgm_se:setVolume(0)
		UIAction:Add(SEQ(LINEAR_CALL(500, nil, function(arg_30_0, arg_30_1)
			if get_cocos_refid(SoundEngine.bgm_se) then
				SoundEngine.bgm_se:setVolume(arg_30_1)
			end
		end, 0, SoundEngine:getRealVolume("bgm"))), arg_27_0, "bgm.fade")
	end
end

function MusicBox.play(arg_31_0, arg_31_1)
	arg_31_1 = arg_31_1 or {}
	arg_31_1.pos = arg_31_1.pos or 0
	
	local var_31_0 = arg_31_0:getTargetSong()
	
	if not var_31_0 then
		return 
	end
	
	if var_31_0.lock then
		arg_31_0:next()
		
		return 
	end
	
	if (arg_31_0:isMyAlbumSelected() or arg_31_0:isFavoriteAlbumSelected()) and arg_31_0:getSelectedAlbumID() == arg_31_0:getTargetAlbumID() then
		local var_31_1 = arg_31_0:getSelectTrack(arg_31_0:getTargetSongID())
		
		if var_31_1 then
			arg_31_0:setTrack(var_31_1)
		end
	end
	
	arg_31_0:setPlayPos(arg_31_1.pos)
	
	if UIAction:Find(arg_31_0.MUSIC_BOX_ACTION_NAME) then
		UIAction:Remove(arg_31_0.MUSIC_BOX_ACTION_NAME)
	end
	
	local var_31_2 = arg_31_0:getTargetSongLength() - arg_31_0:getPlayPos()
	
	UIAction:Add(SEQ(DELAY(var_31_2), CALL(function()
		arg_31_0:onTrackIsOver()
	end)), arg_31_0, arg_31_0.MUSIC_BOX_ACTION_NAME)
	
	local var_31_3 = arg_31_0:getTargetSongStreamingID()
	
	if var_31_3 then
		local function var_31_4()
			if get_cocos_refid(SoundEngine.bgm_se) and arg_31_0:isSameSong() and arg_31_0:isPlaying() then
				SoundEngine.bgm_se:setPosition(arg_31_0:getPlayPos())
			else
				arg_31_0:_playStreamingWithFade(var_31_3)
			end
		end
		
		check_cool_time(arg_31_0, "ost_streaming", 200, nil, var_31_4, true)
	else
		SoundEngine:playBGMatTime("event:/bgm/" .. arg_31_0:getTargetSongID(), arg_31_0:getPlayPos())
	end
	
	if arg_31_0.vars.play_interval then
		Scheduler:removeByName(arg_31_0.MUSIC_BOX_ACTION_NAME)
		
		arg_31_0.vars.play_interval = nil
	end
	
	arg_31_0.vars.play_interval = Scheduler:addGlobalInterval(100, arg_31_0.onPlayUpdate, arg_31_0)
	
	arg_31_0.vars.play_interval:setName(arg_31_0.MUSIC_BOX_ACTION_NAME)
	
	arg_31_0.vars.is_pause_reason_by_disable_scene = false
	arg_31_0.vars.is_playing = true
	
	arg_31_0:save()
	arg_31_0.onPlay()
end

function MusicBox.getCurrentPlaytime(arg_34_0)
	if not arg_34_0.vars then
		return 
	end
	
	if arg_34_0:isPlaying() then
		local var_34_0
		
		if get_cocos_refid(SoundEngine.bgm_se) and arg_34_0:getTargetSongStreamingID() then
			if SoundEngine.bgm_se.getPosition then
				var_34_0 = SoundEngine.bgm_se:getPosition()
			end
		else
			var_34_0 = SoundEngine:getTrackTimelinePosition(0)
		end
		
		if var_34_0 ~= 0 then
			return var_34_0
		end
	end
	
	return arg_34_0:getPlayPos()
end

function MusicBox.stop(arg_35_0, arg_35_1)
	arg_35_1 = arg_35_1 or {}
	
	if not arg_35_0:getTargetSong() then
		return 
	end
	
	arg_35_0.vars.is_pause_reason_by_disable_scene = arg_35_0:isPlaying() and arg_35_1.is_disable_scene
	
	arg_35_0:setPlayPos(arg_35_1.pos or arg_35_0:getCurrentPlaytime())
	
	if arg_35_0.vars.play_interval then
		Scheduler:removeByName(arg_35_0.MUSIC_BOX_ACTION_NAME)
		
		arg_35_0.vars.play_interval = nil
	end
	
	UIAction:Remove(arg_35_0.MUSIC_BOX_ACTION_NAME)
	
	arg_35_0.vars.is_playing = false
	
	arg_35_0:save()
	arg_35_0.onStop()
	SoundEngine:playBGM(SoundEngine.current_bgm or "event:/bgm/default")
end

function MusicBox.next(arg_36_0, arg_36_1)
	local var_36_0 = arg_36_0:getTargetSong()
	
	if not var_36_0 then
		return 
	end
	
	arg_36_1 = arg_36_1 or 0
	
	if arg_36_1 > arg_36_0:getTargetPlaylistLength() then
		arg_36_0:stop()
		
		return 
	end
	
	if arg_36_0:getTargetPlaylistLength() == 0 then
		arg_36_0:play()
		
		return 
	end
	
	local var_36_1 = arg_36_0:getTargetTrack()
	
	if not var_36_1 then
		if var_36_0.track then
			var_36_1 = var_36_0.track - 1
		else
			var_36_1 = 0
		end
	end
	
	local var_36_2 = var_36_1 + 1
	
	if not arg_36_0:isValidTrackNum(var_36_2) then
		var_36_2 = var_36_2 < arg_36_0:getTargetPlaylistLength() and var_36_2 or 1
	end
	
	MusicBox:setSameSong(false)
	arg_36_0:setTargetTrack(var_36_2, {
		is_quiet = true
	})
	
	if arg_36_0:isUnLock(arg_36_0:getTargetSongUnlockID()) and arg_36_0:getTargetSong().length ~= 0 then
		arg_36_0:play()
		
		return 
	end
	
	arg_36_0:next(arg_36_1 + 1)
end

function MusicBox.prev(arg_37_0, arg_37_1)
	local var_37_0 = arg_37_0:getTargetSong()
	
	if not var_37_0 then
		return 
	end
	
	arg_37_1 = arg_37_1 or 0
	
	if arg_37_1 > arg_37_0:getTargetPlaylistLength() then
		arg_37_0:stop()
		
		return 
	end
	
	if arg_37_0:getCurrentPlaytime() > 5000 then
		arg_37_0:play()
		
		return 
	end
	
	if arg_37_0:getTargetPlaylistLength() == 0 then
		arg_37_0:play()
		
		return 
	end
	
	MusicBox:setSameSong(false)
	
	local var_37_1 = arg_37_0:getTargetTrack()
	
	if not var_37_1 then
		if var_37_0.track then
			var_37_1 = var_37_0.track
		else
			var_37_1 = 0
		end
	end
	
	local var_37_2 = var_37_1 - 1
	
	if not arg_37_0:isValidTrackNum(var_37_2) then
		if arg_37_0.vars.loop_type == arg_37_0.LOOP_TYPE.NONE then
			arg_37_0:stop()
			
			return 
		end
		
		var_37_2 = var_37_2 > 0 and var_37_2 or arg_37_0:getTargetPlaylistLength()
	end
	
	arg_37_0:setTargetTrack(var_37_2, {
		is_quiet = true
	})
	
	if arg_37_0:isUnLock(arg_37_0:getTargetSongUnlockID()) and arg_37_0:getTargetSong().length ~= 0 then
		arg_37_0:play()
		
		return 
	end
	
	arg_37_0:prev(arg_37_1 + 1)
end

function MusicBox.diffFavorites(arg_38_0, arg_38_1, arg_38_2)
	local var_38_0 = table.clone(arg_38_2)
	local var_38_1 = table.clone(arg_38_1)
	local var_38_2 = {}
	
	for iter_38_0, iter_38_1 in pairs(var_38_0) do
		if table.find(var_38_1, iter_38_1) then
			table.deleteByValue(var_38_1, iter_38_1)
		else
			table.insert(var_38_2, iter_38_1)
		end
	end
	
	return var_38_1, var_38_2
end

function MusicBox.updateFavorite(arg_39_0, arg_39_1)
	local var_39_0, var_39_1 = arg_39_0:diffFavorites(arg_39_1.fav_list, arg_39_0.server_data.fav_list)
	
	arg_39_0.server_data.fav_list = arg_39_1.fav_list
	
	for iter_39_0, iter_39_1 in pairs(var_39_0) do
		arg_39_0.onUpdateFavorite(iter_39_1, true)
	end
	
	for iter_39_2, iter_39_3 in pairs(var_39_1) do
		arg_39_0.onUpdateFavorite(iter_39_3, false)
	end
	
	if arg_39_0:isFavoriteAlbumSelected() then
		arg_39_0:setAlbum(arg_39_0.FAVORITE_ALBUM_ID)
	end
	
	if arg_39_0:getTargetAlbumID() == arg_39_0.FAVORITE_ALBUM_ID then
		arg_39_0:setTargetPlaylist(arg_39_0:getFavoriteAlbumSongs())
		arg_39_0:save()
	end
end

function MusicBox.isFavoriteSong(arg_40_0, arg_40_1)
	if not arg_40_0.server_data then
		return false
	end
	
	if not arg_40_1 then
		return false
	end
	
	if table.find(arg_40_0.server_data.fav_list, arg_40_1) then
		return true
	end
	
	return false
end

function MusicBox.getFavoriteSongIndex(arg_41_0, arg_41_1)
	if not arg_41_0.server_data then
		return nil
	end
	
	arg_41_1 = arg_41_1 or arg_41_0:getTargetSongID()
	
	if not arg_41_1 then
		return nil
	end
	
	for iter_41_0, iter_41_1 in pairs(arg_41_0.server_data.fav_list or {}) do
		if iter_41_1 == arg_41_1 then
			return iter_41_0
		end
	end
	
	return nil
end

function MusicBox.search(arg_42_0, arg_42_1)
	local var_42_0 = arg_42_0:getAllSongs()
	local var_42_1 = {}
	
	for iter_42_0, iter_42_1 in pairs(var_42_0) do
		if arg_42_0:isAddAbleSong(iter_42_1) and (string.find(string.lower(T(iter_42_1.song_title)), arg_42_1, nil, true) or string.find(string.lower(T(iter_42_1.song_desc)), arg_42_1, nil, true)) then
			table.push(var_42_1, iter_42_1)
		end
	end
	
	return var_42_1
end

function MusicBox.__devIsUnlockAll(arg_43_0)
	if PRODUCTION_MODE then
		return false
	end
	
	if DEBUG.UNLOCK_ALL_MUSIC == nil then
		DEBUG.UNLOCK_ALL_MUSIC = SAVE:get("game.unlock_all_music_debug", false)
	end
	
	return DEBUG.UNLOCK_ALL_MUSIC
end

function MusicBox.isUnLock(arg_44_0, arg_44_1)
	local var_44_0, var_44_1 = DB("musicplayer_lock", arg_44_1, {
		"condition",
		"value"
	})
	
	if arg_44_0:__devIsUnlockAll() then
		return true
	end
	
	if var_44_0 == "lock" then
		return UnlockSystem:isUnlockSystem(var_44_1)
	end
	
	if var_44_0 == "character" then
		return Account:getCollectionUnit(var_44_1)
	end
	
	if var_44_0 == "dlc" then
		return SubStoryDlcMain:checkSubstoryHave(var_44_1)
	end
	
	if var_44_0 == "substory" or var_44_0 == "music" then
		return Account:getItemCount(var_44_1) > 0
	end
	
	return true
end

function MusicBox.mergeGMData(arg_45_0, arg_45_1)
	if not arg_45_1 then
		return 
	end
	
	for iter_45_0, iter_45_1 in pairs(arg_45_0:getAllSongs()) do
		local var_45_0 = arg_45_1[iter_45_1.id]
		
		if var_45_0 then
			iter_45_1.sort = var_45_0.sort or iter_45_1.sort
			iter_45_1.new = var_45_0.new or iter_45_1.new
			iter_45_1.recom = var_45_0.recom or iter_45_1.recom
			iter_45_1.hide = var_45_0.hide or iter_45_1.hide
		end
	end
end

function MusicBox.setMyAlbumFromServer(arg_46_0, arg_46_1)
	local var_46_0 = arg_46_1.album_number
	local var_46_1 = arg_46_0:getMyAlbumID(var_46_0)
	local var_46_2 = arg_46_0.music_data.albums[var_46_1]
	
	var_46_2.album_img = arg_46_1.album_image or var_46_2.album_img
	var_46_2.album_title = arg_46_1.album_name or var_46_2.album_title
	var_46_2.list = {}
	
	arg_46_0:clearAlbum(var_46_1)
	
	for iter_46_0, iter_46_1 in pairs(arg_46_1.music_list) do
		local var_46_3 = arg_46_0:getSong(iter_46_1)
		
		if var_46_3 then
			var_46_3.my_album_ids = var_46_3.my_album_ids or {}
			var_46_3.my_album_ids[var_46_0] = var_46_1
			
			arg_46_0:addSongToAlbum(var_46_1, var_46_3)
		end
	end
	
	if arg_46_0:getTargetAlbumID() == var_46_1 then
		arg_46_0:setTargetPlaylist(arg_46_0:getMyAlbumSongs(var_46_0))
		arg_46_0:save()
	end
end

function MusicBox.getIDsToPlaylist(arg_47_0, arg_47_1)
	local var_47_0 = {}
	
	for iter_47_0, iter_47_1 in pairs(arg_47_1) do
		table.push(var_47_0, arg_47_0.music_data.all_songs[iter_47_1])
	end
	
	return var_47_0
end

function MusicBox.getPlaylistToIDs(arg_48_0, arg_48_1)
	local var_48_0 = {}
	
	for iter_48_0, iter_48_1 in pairs(arg_48_1) do
		table.push(var_48_0, iter_48_1.id)
	end
	
	return var_48_0
end

function MusicBox.getAlbumSongIDs(arg_49_0, arg_49_1)
	return arg_49_0:getPlaylistToIDs(arg_49_0:getAlbumSongs(arg_49_1))
end

function MusicBox.isSongInAlbum(arg_50_0, arg_50_1, arg_50_2)
	if not arg_50_0.vars then
		return false
	end
	
	if not arg_50_1 then
		return false
	end
	
	if not arg_50_2 then
		return false
	end
	
	local var_50_0 = arg_50_0:getAlbumSongs(arg_50_1)
	
	for iter_50_0, iter_50_1 in pairs(var_50_0) do
		if arg_50_2 == iter_50_1.id then
			return true
		end
	end
	
	return false
end

function MusicBox.setMyAlbumsFromServer(arg_51_0, arg_51_1)
	if not arg_51_1 then
		return 
	end
	
	for iter_51_0, iter_51_1 in pairs(arg_51_1) do
		arg_51_0:setMyAlbumFromServer(iter_51_1)
	end
end

function MusicBox.setServerData(arg_52_0, arg_52_1)
	local var_52_0 = arg_52_0:getAllSongs()
	
	for iter_52_0, iter_52_1 in pairs(var_52_0) do
		iter_52_1.my_album_ids = nil
	end
	
	arg_52_0:setMyAlbumsFromServer(arg_52_1.my_albums)
	
	arg_52_0.server_data = arg_52_0.server_data or {}
	arg_52_0.server_data.fav_list = arg_52_1.fav_list or {}
	arg_52_0.server_data.fav_count_info = arg_52_1.fav_count_info or {}
	
	for iter_52_2, iter_52_3 in pairs(arg_52_0.server_data.fav_list) do
		local var_52_1 = arg_52_0.server_data.fav_count_info[iter_52_3]
		
		if var_52_1 and var_52_1.total then
			var_52_1.total = var_52_1.total - 1
		end
	end
	
	if arg_52_1.substory_docs then
		Account:updateSubStoryInfo(arg_52_1.substory_docs)
	end
	
	arg_52_0:mergeGMData(arg_52_1.music_webdata)
end

function MusicBox.getFavoriteCount(arg_53_0, arg_53_1, arg_53_2)
	if not arg_53_0.vars then
		return 0
	end
	
	if not arg_53_0.server_data then
		return 
	end
	
	local var_53_0 = arg_53_0.server_data.fav_count_info[arg_53_1]
	
	if not var_53_0 then
		return 0
	end
	
	arg_53_2 = arg_53_2 or arg_53_0:getBestAlbumSortType()
	
	local var_53_1 = var_53_0[arg_53_2] or 0
	
	if arg_53_2 == "prev_fav" then
		return var_53_1
	end
	
	return var_53_1 + (arg_53_0:isFavoriteSong(arg_53_1) and 1 or 0)
end

function MusicBox.getMyAlbumID(arg_54_0, arg_54_1)
	return arg_54_0.MY_ALBUM_ID_PREFIX .. arg_54_1
end

function MusicBox.getMyAlbum(arg_55_0, arg_55_1)
	return arg_55_0:getAlbum(arg_55_0:getMyAlbumID(arg_55_1))
end

function MusicBox.isAddAbleSong(arg_56_0, arg_56_1, arg_56_2)
	if not (not arg_56_1.hide or arg_56_1.hide == "n") then
		return false
	end
	
	if not (not arg_56_2 or arg_56_2 and arg_56_0:isUnLock(arg_56_1.lock_id)) then
		return false
	end
	
	return true
end

function MusicBox.init(arg_57_0)
	arg_57_0:buildMusicData()
end

function MusicBox.buildAlbums(arg_58_0)
	if arg_58_0.music_data.albums then
		return arg_58_0.music_data.albums
	end
	
	arg_58_0.music_data.albums = {}
	
	for iter_58_0 = 1, 9999 do
		local var_58_0 = DBNFields("musicplayer_album", iter_58_0, {
			"id",
			"album_id",
			"album_img",
			"album_title",
			"new",
			"sort"
		})
		
		if not var_58_0.id then
			break
		end
		
		var_58_0.album_title = T(var_58_0.album_title)
		arg_58_0.music_data.albums[var_58_0.id] = var_58_0
	end
end

function MusicBox.getAllAlbums(arg_59_0, arg_59_1)
	local var_59_0 = {}
	
	for iter_59_0, iter_59_1 in pairs(arg_59_0.music_data.albums) do
		if arg_59_1 then
			if not arg_59_0:isMyAlbumID(iter_59_1.id) and not string.find(iter_59_1.id, arg_59_0.BEST_ALBUM_ID) and not string.find(iter_59_1.id, arg_59_0.FAVORITE_ALBUM_ID) then
				table.push(var_59_0, iter_59_1)
			end
		else
			table.push(var_59_0, iter_59_1)
		end
	end
	
	table.sort(var_59_0, function(arg_60_0, arg_60_1)
		return arg_60_0.sort < arg_60_1.sort
	end)
	
	return var_59_0
end

function MusicBox.isLast(arg_61_0)
	if not arg_61_0:getTargetTrack() then
		return true
	end
	
	return table.count(arg_61_0:getTargetPlaylist() or {}) <= arg_61_0:getTargetTrack()
end

function MusicBox.isValidTrackNum(arg_62_0, arg_62_1)
	if arg_62_1 < 1 then
		return false
	end
	
	if arg_62_1 > arg_62_0:getTargetPlaylistLength() then
		return false
	end
	
	return true
end

function MusicBox.setTargetPlaylist(arg_63_0, arg_63_1)
	arg_63_0.music_data.target.playlist = arg_63_1
	
	arg_63_0:savePlaylist()
end

function MusicBox.setTrack(arg_64_0, arg_64_1)
	if not arg_64_0.music_data then
		return 
	end
	
	if not arg_64_0.music_data.select then
		return 
	end
	
	arg_64_0.music_data.target = {}
	
	arg_64_0:setTargetPlaylist(arg_64_0.music_data.select.playlist)
	
	arg_64_0.music_data.target.album_id = arg_64_0.music_data.select.album_id
	arg_64_0.music_data.target.is_shuffle = arg_64_0.music_data.select.is_shuffle
	
	arg_64_0:setTargetTrack(arg_64_1)
	arg_64_0:save()
end

function MusicBox.setSameSong(arg_65_0, arg_65_1)
	if not arg_65_0.vars then
		return 
	end
	
	arg_65_0.vars.is_same_play = arg_65_1
end

function MusicBox.isSameSong(arg_66_0)
	if not arg_66_0.vars then
		return 
	end
	
	return arg_66_0.vars.is_same_play
end

function MusicBox.setTargetTrack(arg_67_0, arg_67_1, arg_67_2)
	if not arg_67_1 then
		return 
	end
	
	if not arg_67_0.music_data then
		return 
	end
	
	if not arg_67_0.music_data.target then
		return 
	end
	
	if arg_67_0:getTargetPlaylistLength() == 0 then
		return 
	end
	
	local var_67_0 = math.min(math.max(arg_67_1, 1), arg_67_0:getTargetPlaylistLength())
	
	arg_67_0.music_data.target.song = arg_67_0.music_data.target.playlist[var_67_0]
	
	if not arg_67_0.music_data.target.song then
		return 
	end
	
	arg_67_0.music_data.target.song.track = var_67_0
	
	arg_67_0.onSetTrack(arg_67_2 or {})
end

function MusicBox.getTargetTrack(arg_68_0)
	if not arg_68_0.music_data then
		return 
	end
	
	if not arg_68_0.music_data.target then
		return 
	end
	
	if not arg_68_0.music_data.target.song then
		return 
	end
	
	for iter_68_0, iter_68_1 in pairs(arg_68_0:getTargetPlaylist()) do
		if iter_68_1.id == arg_68_0.music_data.target.song.id then
			return iter_68_0
		end
	end
end

function MusicBox.getAlbum(arg_69_0, arg_69_1)
	return arg_69_0.music_data.albums[arg_69_1]
end

function MusicBox.getAlbumTitle(arg_70_0, arg_70_1)
	local var_70_0 = arg_70_0:getAlbum(arg_70_1)
	
	if not var_70_0 then
		return ""
	end
	
	return var_70_0.album_title
end

function MusicBox.getAlbumImage(arg_71_0, arg_71_1)
	local var_71_0 = arg_71_0:getAlbum(arg_71_1)
	
	if not var_71_0 then
		return ""
	end
	
	return var_71_0.album_img
end

function MusicBox.getBestAlbumSongs(arg_72_0, arg_72_1)
	arg_72_1 = arg_72_1 or {}
	
	local var_72_0 = arg_72_1.force_favorite_opt or arg_72_0:getBestAlbumSortType()
	local var_72_1 = {}
	
	for iter_72_0, iter_72_1 in pairs(arg_72_0.music_data.all_songs or {}) do
		if arg_72_0:isAddAbleSong(iter_72_1, arg_72_1.without_lock_music) and arg_72_0:getFavoriteCount(iter_72_1.id, var_72_0) > 0 then
			table.push(var_72_1, iter_72_1)
		end
	end
	
	table.sort(var_72_1, function(arg_73_0, arg_73_1)
		return arg_72_0:getFavoriteCount(arg_73_1.id, var_72_0) < arg_72_0:getFavoriteCount(arg_73_0.id, var_72_0)
	end)
	
	local var_72_2 = 30
	local var_72_3 = {}
	
	for iter_72_2, iter_72_3 in pairs(var_72_1) do
		table.push(var_72_3, iter_72_3)
		
		if var_72_2 <= table.count(var_72_3) then
			break
		end
	end
	
	return var_72_3
end

function MusicBox.getFavoriteAlbumSongs(arg_74_0, arg_74_1)
	arg_74_1 = arg_74_1 or {}
	
	local var_74_0 = {}
	
	for iter_74_0, iter_74_1 in pairs(arg_74_0.music_data.all_songs or {}) do
		if arg_74_0:isAddAbleSong(iter_74_1, arg_74_1.without_lock_music) then
			iter_74_1.best_album_sort_type = arg_74_0:getFavoriteSongIndex(iter_74_1.id)
			
			if iter_74_1.best_album_sort_type then
				table.push(var_74_0, iter_74_1)
			end
		end
	end
	
	table.sort(var_74_0, function(arg_75_0, arg_75_1)
		return arg_75_0.best_album_sort_type < arg_75_1.best_album_sort_type
	end)
	
	return var_74_0
end

function MusicBox.getMyAlbumSongs(arg_76_0, arg_76_1)
	return arg_76_0:getAlbumSongs(MusicBox:getMyAlbumID(arg_76_1)) or {}
end

function MusicBox.getAlbumSongs(arg_77_0, arg_77_1, arg_77_2)
	arg_77_2 = arg_77_2 or {}
	
	if arg_77_1 == arg_77_0.BEST_ALBUM_ID then
		return arg_77_0:getBestAlbumSongs(arg_77_2)
	end
	
	if arg_77_1 == arg_77_0.FAVORITE_ALBUM_ID then
		return arg_77_0:getFavoriteAlbumSongs(arg_77_2)
	end
	
	local var_77_0 = arg_77_0.music_data.albums[arg_77_1]
	
	if not var_77_0 then
		return 
	end
	
	var_77_0.list = var_77_0.list or {}
	
	local var_77_1 = {}
	
	for iter_77_0, iter_77_1 in pairs(var_77_0.list) do
		if arg_77_0:isAddAbleSong(iter_77_1, arg_77_2.without_lock_music) then
			table.push(var_77_1, iter_77_1)
		end
	end
	
	return var_77_1
end

function MusicBox.clearAlbum(arg_78_0, arg_78_1)
	local var_78_0 = arg_78_0.music_data.albums[arg_78_1]
	
	if not var_78_0 then
		return 
	end
	
	var_78_0.list = {}
end

function MusicBox.addSongToAlbum(arg_79_0, arg_79_1, arg_79_2)
	local var_79_0 = arg_79_0.music_data.albums[arg_79_1]
	
	if not var_79_0 then
		return 
	end
	
	var_79_0.list = var_79_0.list or {}
	
	table.push(var_79_0.list, arg_79_2)
end

function MusicBox.buildSong(arg_80_0, arg_80_1)
	if string.find(arg_80_1.id, "test") then
		return 
	end
	
	local var_80_0
	
	if arg_80_1.music_time then
		var_80_0 = arg_80_1.music_time
	else
		var_80_0 = SoundEngine:getMusicLength("event:/bgm/" .. arg_80_1.id) or 0
	end
	
	if not PRODUCTION_MODE and var_80_0 == 0 then
		print("error id ", arg_80_1.id, " is not Music.. or length is zero")
	end
	
	if not PRODUCTION_MODE or var_80_0 ~= 0 then
		arg_80_1.length = var_80_0
		
		local var_80_1 = arg_80_1["video_" .. getUserLanguage()]
		
		if var_80_1 then
			arg_80_1.video_url = var_80_1
			arg_80_1["video_" .. getUserLanguage()] = nil
		end
		
		arg_80_0.music_data.all_songs[arg_80_1.id] = arg_80_1
		
		arg_80_0:addSongToAlbum(arg_80_1.album, arg_80_1)
		arg_80_0:addSongToAlbum(arg_80_0.ALL_ALBUM_ID, arg_80_1)
	end
end

function MusicBox.buildMusicData(arg_81_0)
	if arg_81_0.music_data then
		return arg_81_0.music_data
	end
	
	arg_81_0.music_data = {}
	arg_81_0.music_data.all_songs = {}
	
	arg_81_0:buildAlbums()
	
	for iter_81_0 = 1, 9999 do
		local var_81_0 = DBNFields("musicplayer_song", iter_81_0, {
			"id",
			"lock_id",
			"album",
			"song_img",
			"song_title",
			"song_desc",
			"new",
			"recom",
			"sort",
			"hide",
			"video_" .. getUserLanguage(),
			"streaming_id",
			"music_time"
		})
		
		if not var_81_0.id then
			break
		end
		
		arg_81_0:buildSong(var_81_0)
	end
end

function MusicBox.getAllSongs(arg_82_0)
	if not arg_82_0.music_data then
		return {}
	end
	
	return arg_82_0.music_data.all_songs or {}
end

function MusicBox.isValid(arg_83_0)
	if not arg_83_0.music_data then
		return 
	end
	
	if not arg_83_0.server_data then
		return 
	end
	
	return not table.empty(arg_83_0.music_data)
end

function MusicBox.setSelectPlaylist(arg_84_0, arg_84_1, arg_84_2)
	if not arg_84_0.music_data then
		return 
	end
	
	if not arg_84_1 then
		return 
	end
	
	arg_84_2 = arg_84_2 or {}
	arg_84_2.is_shuffle = arg_84_2.is_shuffle or false
	arg_84_0.music_data.select = {}
	arg_84_0.music_data.select.album_id = arg_84_2.album_id or arg_84_0:getSelectedAlbumID()
	arg_84_0.music_data.select.is_shuffle = arg_84_2.is_shuffle
	arg_84_0.music_data.select.playlist = arg_84_1
	
	arg_84_0.onSetSelectPlaylist(arg_84_0.music_data.select.playlist)
end

function MusicBox.getTargetAlbumTitle(arg_85_0)
	local var_85_0 = arg_85_0:getAlbumTitle(arg_85_0:getTargetAlbumID())
	
	if var_85_0 ~= "" then
		return var_85_0
	end
	
	local var_85_1 = arg_85_0:getTargetSong()
	
	if not var_85_1 then
		return ""
	end
	
	return arg_85_0:getAlbumTitle(var_85_1.album)
end

function MusicBox.getTargetAlbumImage(arg_86_0)
	local var_86_0 = arg_86_0:getAlbumImage(arg_86_0:getTargetAlbumID())
	
	if var_86_0 ~= "" then
		return var_86_0
	end
	
	local var_86_1 = arg_86_0:getTargetSong()
	
	if not var_86_1 then
		return ""
	end
	
	return arg_86_0:getAlbumImage(var_86_1.album)
end

function MusicBox.getTargetAlbumID(arg_87_0)
	if not arg_87_0.music_data then
		return arg_87_0.DEFAULT_ALBUM_ID
	end
	
	if not arg_87_0.music_data.target then
		return arg_87_0.DEFAULT_ALBUM_ID
	end
	
	return arg_87_0.music_data.target.album_id or arg_87_0.DEFAULT_ALBUM_ID
end

function MusicBox.getTargetPlaylist(arg_88_0)
	if not arg_88_0.music_data then
		return arg_88_0:getAlbumSongs(arg_88_0.DEFAULT_ALBUM_ID)
	end
	
	if not arg_88_0.music_data.target then
		return arg_88_0:getAlbumSongs(arg_88_0.DEFAULT_ALBUM_ID)
	end
	
	return arg_88_0.music_data.target.playlist or arg_88_0:getAlbumSongs(arg_88_0.DEFAULT_ALBUM_ID)
end

function MusicBox.getTargetPlaylistLength(arg_89_0)
	return #arg_89_0:getTargetPlaylist()
end

function MusicBox.isTargetPlaylistShuffle(arg_90_0)
	if not arg_90_0.music_data then
		return false
	end
	
	if not arg_90_0.music_data.target then
		return false
	end
	
	arg_90_0.music_data.target.is_shuffle = arg_90_0.music_data.target.is_shuffle or false
	
	return arg_90_0.music_data.target.is_shuffle
end

function MusicBox.shufflePlaylist(arg_91_0)
	if arg_91_0:isInvalidTrack() then
		return 
	end
	
	local var_91_0 = arg_91_0:getTargetSong()
	
	if not var_91_0 then
		return 
	end
	
	local var_91_1 = arg_91_0:getTargetPlaylist()
	
	table.shuffle(var_91_1)
	
	local var_91_2 = 1
	
	for iter_91_0, iter_91_1 in pairs(var_91_1) do
		if iter_91_1.id == var_91_0.id then
			var_91_2 = iter_91_0
			
			break
		end
	end
	
	var_91_1[1], var_91_1[var_91_2] = var_91_1[var_91_2], var_91_1[1]
	
	arg_91_0:setTargetPlaylist(var_91_1)
	arg_91_0:setTargetTrack(1)
	
	arg_91_0.music_data.target.is_shuffle = true
	
	arg_91_0:setSelectPlaylist(arg_91_0:getTargetPlaylist(), {
		is_shuffle = true,
		album_id = arg_91_0:getTargetAlbumID()
	})
	arg_91_0:save()
end

function MusicBox.getSong(arg_92_0, arg_92_1)
	if not arg_92_0.music_data then
		return 
	end
	
	return arg_92_0.music_data.all_songs[arg_92_1]
end

function MusicBox.setBestAlbumSortOption(arg_93_0, arg_93_1)
	if not arg_93_0.vars then
		return 
	end
	
	arg_93_0.vars.best_album_sort_type = arg_93_1
	
	arg_93_0:setSelectPlaylist(arg_93_0:getAlbumSongs(arg_93_0.BEST_ALBUM_ID), {
		is_shuffle = false,
		album_id = arg_93_0.BEST_ALBUM_ID
	})
end

function MusicBox.getBestAlbumSortType(arg_94_0)
	if not arg_94_0.vars then
		return "prev_fav"
	end
	
	return arg_94_0.vars.best_album_sort_type or "prev_fav"
end

function MusicBox.setAlbum(arg_95_0, arg_95_1)
	if not arg_95_0.vars then
		return 
	end
	
	arg_95_0:setSelectPlaylist(arg_95_0:getAlbumSongs(arg_95_1), {
		is_shuffle = false,
		album_id = arg_95_1
	})
	arg_95_0.onSetAlbum(arg_95_1)
end

function MusicBox.getSelectedAlbumID(arg_96_0)
	if not arg_96_0.vars then
		return ""
	end
	
	return arg_96_0.music_data.select.album_id or ""
end

function MusicBox.getSelectPlaylist(arg_97_0)
	return arg_97_0.music_data.select.playlist
end

function MusicBox.getSelectTrack(arg_98_0, arg_98_1)
	if not arg_98_1 then
		return 
	end
	
	local var_98_0 = arg_98_0:getSelectPlaylist()
	
	if not var_98_0 then
		return 
	end
	
	for iter_98_0, iter_98_1 in pairs(var_98_0) do
		if arg_98_1 == iter_98_1.id then
			return iter_98_0
		end
	end
end

function MusicBox.getSelectedAlbumSongs(arg_99_0)
	return arg_99_0:getAlbumSongs(arg_99_0:getSelectedAlbumID())
end

function MusicBox.isBestAlbumSelected(arg_100_0)
	return arg_100_0:getSelectedAlbumID() == "best"
end

function MusicBox.isFavoriteAlbumSelected(arg_101_0)
	return arg_101_0:getSelectedAlbumID() == arg_101_0.FAVORITE_ALBUM_ID
end

function MusicBox.isMyAlbumSelected(arg_102_0)
	return arg_102_0:isMyAlbumID(arg_102_0:getSelectedAlbumID())
end

function MusicBox.isMyAlbumID(arg_103_0, arg_103_1)
	if not arg_103_1 then
		return false
	end
	
	return string.starts(arg_103_1, MusicBox.MY_ALBUM_ID_PREFIX)
end

function MusicBox.getMyAlbumIndex(arg_104_0, arg_104_1)
	return to_n(string.sub(arg_104_1, -1))
end

function MusicBox.getDefaultMyAlbumName(arg_105_0, arg_105_1)
	local var_105_0 = arg_105_0:getAllAlbums()
	
	for iter_105_0, iter_105_1 in pairs(var_105_0) do
		if iter_105_1.album_id == arg_105_0:getMyAlbumID(arg_105_1) then
			return iter_105_1.album_title
		end
	end
end

function MusicBox.toggleFavorite(arg_106_0, arg_106_1)
	if not arg_106_1 then
		return 
	end
	
	query(arg_106_0:isFavoriteSong(arg_106_1) and "unfavorite_music" or "favorite_music", {
		music_id = arg_106_1
	})
end

function MusicBox.getMyAlbumName(arg_107_0, arg_107_1)
	local var_107_0 = arg_107_0:getMyAlbum(arg_107_1)
	
	if not var_107_0.album_name then
		return arg_107_0:getDefaultMyAlbumName(arg_107_1)
	end
	
	if string.trim(var_107_0.album_name) == "" then
		return arg_107_0:getDefaultMyAlbumName(arg_107_1)
	end
	
	return var_107_0.album_name
end
