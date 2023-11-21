function MsgHandler.get_music_box_info(arg_1_0)
	if not arg_1_0 then
		return 
	end
	
	if arg_1_0.res ~= "ok" then
		return 
	end
	
	if not MusicBox:isValid() then
		MusicBox:init()
	end
	
	MusicBox:setServerData(arg_1_0)
	MusicBox:load()
	
	if SceneManager:getCurrentSceneName() == "arena_net_lounge" then
		ArenaNetMusicBox:show({
			service = ArenaNetLounge.vars.service,
			cur_bgm_id = ArenaNetLounge.vars.bgm_id,
			callback = function(arg_2_0)
				ArenaNetLounge:onChangeBGM(arg_2_0)
			end
		})
	end
end

function MsgHandler.favorite_music(arg_3_0)
	MusicBox:updateFavorite(arg_3_0)
end

function MsgHandler.unfavorite_music(arg_4_0)
	MusicBox:updateFavorite(arg_4_0)
end

function MsgHandler.set_album_info(arg_5_0)
	if MusicBoxAlbumEditorUI:isShow() then
		MusicBoxAlbumEditorUI:close()
	end
	
	if not arg_5_0 then
		return 
	end
	
	if arg_5_0.res ~= "ok" then
		return 
	end
	
	MusicBox:setMyAlbumFromServer(arg_5_0.album_info)
	MusicBox:setAlbum(MusicBox:getMyAlbumID(arg_5_0.album_number))
	MusicBoxUI:updateMusicUI()
	MusicBoxUI:updateAlbumList()
end

function MsgHandler.replace_album_list(arg_6_0)
	if not arg_6_0 then
		return 
	end
	
	if arg_6_0.res ~= "ok" then
		return 
	end
	
	MusicBox:setMyAlbumFromServer(arg_6_0.album_info)
	
	local var_6_0 = MusicBox:getMyAlbumID(arg_6_0.album_number)
	
	MusicBox:setSelectPlaylist(MusicBox:getAlbumSongs(var_6_0), {
		album_id = var_6_0
	})
	
	if var_6_0 == MusicBox:getSelectedAlbumID() then
		local var_6_1 = MusicBox:getSelectTrack(MusicBox:getTargetSongID())
		
		if var_6_1 then
			MusicBox:setTrack(var_6_1)
		end
	end
end

function MsgHandler.edit_album_list(arg_7_0)
	if not arg_7_0 then
		return 
	end
	
	if arg_7_0.res ~= "ok" then
		return 
	end
	
	MusicBox:setMyAlbumFromServer(arg_7_0.album_info)
	
	if MusicBox:isMyAlbumSelected() then
		local var_7_0 = MusicBox:getMyAlbumID(arg_7_0.album_number)
		
		if MusicBox:getSelectedAlbumID() == var_7_0 then
			MusicBox:setSelectPlaylist(MusicBox:getAlbumSongs(var_7_0), {
				album_id = var_7_0
			})
		end
	end
end
