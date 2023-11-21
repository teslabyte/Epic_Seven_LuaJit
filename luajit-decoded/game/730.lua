HTBFogRenderer = {}

function HTBFogRenderer.base_init(arg_1_0, arg_1_1, arg_1_2)
	HTBFogRenderer:close()
	
	arg_1_0.vars = {}
	arg_1_0.vars.parent_layer = arg_1_2
	
	local var_1_0 = HTBInterface:whiteboardGet(arg_1_1, "map_min_x")
	local var_1_1 = HTBInterface:whiteboardGet(arg_1_1, "map_max_x")
	local var_1_2 = HTBInterface:whiteboardGet(arg_1_1, "map_min_y")
	local var_1_3 = HTBInterface:whiteboardGet(arg_1_1, "map_max_y")
	
	arg_1_0.vars.map_min_x = var_1_0
	arg_1_0.vars.map_max_x = var_1_1
	arg_1_0.vars.map_min_y = var_1_2
	arg_1_0.vars.map_max_y = var_1_3
	arg_1_0.vars.width = var_1_1 - var_1_0
	arg_1_0.vars.height = var_1_3 - var_1_2
	arg_1_0.vars.render_width = VIEW_WIDTH
	arg_1_0.vars.render_height = VIEW_HEIGHT
	arg_1_0.vars.field_layer_x = HTBInterface:whiteboardGet(arg_1_1, "field_layer_x")
	arg_1_0.vars.field_layer_y = HTBInterface:whiteboardGet(arg_1_1, "field_layer_y")
	arg_1_0.vars.fog_layer_x = arg_1_2:getPositionX()
	arg_1_0.vars.fog_layer_y = arg_1_2:getPositionY()
	arg_1_0.vars.field_position_gap_x = 300
	arg_1_0.vars.field_position_gap_y = 387
	arg_1_0.vars.shader_mode = "edge"
	arg_1_0.vars.gap_x = 0
	arg_1_0.vars.gap_y = 0
	arg_1_0.vars.last_updated_cnt = 0
	arg_1_0.vars.sprite_hash_map = {}
	arg_1_0.vars.shader_fog_mode = false
	
	if arg_1_0.vars.shader_fog_mode then
		arg_1_0:createCocosObjects()
		arg_1_0:programSet()
	else
		arg_1_0:createVgSightImages()
		arg_1_0:createWriteableTexture()
	end
	
	arg_1_2:addChild(arg_1_0.vars.render_layer)
end

function HTBFogRenderer.base_makeFogSprite(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	local var_2_0 = arg_2_0.vars.sprite_hash_map[arg_2_4]
	
	if not var_2_0 or not var_2_0[arg_2_3] then
		local var_2_1 = SpriteCache:getSprite("tile/sample_white.png")
		
		if not var_2_0 then
			arg_2_0.vars.sprite_hash_map[arg_2_4] = {}
		end
		
		arg_2_0.vars.sprite_hash_map[arg_2_4][arg_2_3] = var_2_1
		
		arg_2_2:addChild(var_2_1)
	end
	
	arg_2_6 = arg_2_6 or 0.25
	
	local var_2_2 = arg_2_0.vars.sprite_hash_map[arg_2_4][arg_2_3]
	
	if not HTBInterface:whiteboardGet(arg_2_1, "tile_y_scale") then
		local var_2_3 = 1
	end
	
	local var_2_4 = 1
	local var_2_5 = 0.25
	local var_2_6 = 1
	local var_2_7 = 1
	
	var_2_2:setScaleX(var_2_5 * var_2_4 * var_2_7)
	var_2_2:setScaleY(var_2_5 * var_2_6 * var_2_4)
	
	if arg_2_5 == HTBFogVisibilityEnum.NOT_DISCOVER then
		var_2_2:setOpacity(0)
	elseif arg_2_5 == HTBFogVisibilityEnum.DISCOVER then
		var_2_2:setOpacity(102)
	elseif arg_2_5 == HTBFogVisibilityEnum.VISIBLE then
		var_2_2:setOpacity(255)
	elseif arg_2_5 == nil then
		var_2_2:setOpacity(arg_2_7)
	end
	
	local var_2_8 = HTBInterface:whiteboardGet(arg_2_1, "tile_width")
	local var_2_9 = HTBInterface:whiteboardGet(arg_2_1, "tile_height")
	
	var_2_2:setLocalZOrder(arg_2_4 * 1)
	var_2_2:setPosition(arg_2_3 * (var_2_8 / 2) + arg_2_0.vars.field_position_gap_x, arg_2_4 * (var_2_9 / 2) + arg_2_0.vars.field_position_gap_y)
	
	return var_2_2
end

function HTBFogRenderer.base_syncPosition(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	if not arg_3_0.vars then
		return 
	end
	
	if arg_3_0.vars.shader_fog_mode then
		if not arg_3_0.vars or not get_cocos_refid(arg_3_0.vars.fog_layer) then
			return 
		end
		
		local var_3_0 = HTBInterface:getCameraPos(arg_3_1)
		local var_3_1, var_3_2 = HTBInterface:getZoomPivotPos(arg_3_2)
		local var_3_3 = var_3_0.x + var_3_1
		local var_3_4 = var_3_0.y + var_3_2
		
		arg_3_0.vars.render_layer:setPosition(-var_3_1, -var_3_2)
		
		local var_3_5 = HTBInterface:getCameraScale(arg_3_3)
		
		arg_3_0.vars.fog_layer:setScale(var_3_5)
		
		local var_3_6 = var_3_3 + arg_3_0.vars.gap_x
		local var_3_7 = var_3_4 + arg_3_0.vars.gap_y
		
		arg_3_0.vars.fog_layer:setPosition(var_3_6, var_3_7)
		
		arg_3_0.vars.request_update_texture_map = true
	else
		local var_3_8 = HTBInterface:getCameraPos(arg_3_1)
		local var_3_9 = var_3_8.x
		local var_3_10 = var_3_8.y
		local var_3_11 = 304.41400304414003
		local var_3_12 = -190.2587519025875
		local var_3_13 = HTBInterface:getCameraScale(arg_3_3)
		
		arg_3_0.vars.parent_layer:setPosition(var_3_9 + var_3_11 * var_3_13, var_3_10 + var_3_12 * var_3_13)
		arg_3_0.vars.parent_layer:setScale(var_3_13)
	end
end

function HTBFogRenderer.base_renderFogsOnShader(arg_4_0, arg_4_1, arg_4_2)
	for iter_4_0 = 1, 9999 do
		local var_4_0 = arg_4_2:getFogDataByIdx(iter_4_0)
		
		if not var_4_0 then
			break
		end
		
		local var_4_1 = var_4_0:getVisibility()
		local var_4_2 = var_4_0:getPos()
		local var_4_3 = var_4_2.x
		local var_4_4 = var_4_2.y
		
		if var_4_1 == HTBFogVisibilityEnum.VISIBLE or var_4_1 == HTBFogVisibilityEnum.DISCOVER then
			arg_4_0:makeFogSprite(arg_4_0.vars.fog_layer, var_4_3, var_4_4, var_4_1, 0.25)
		end
		
		if var_4_1 then
			HTBInterface:onUpdateFogCallback(arg_4_1, var_4_3, var_4_4, var_4_1)
		end
	end
	
	arg_4_0:updateTextureMap()
end

function HTBFogRenderer.base_renderFogs(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	if not arg_5_0.vars then
		return 
	end
	
	if arg_5_0.vars.shader_fog_mode then
		arg_5_0:renderFogsOnShader(arg_5_4)
	else
		local var_5_0 = HTBInterface:getFogDiscoveredList(arg_5_1)
		
		for iter_5_0, iter_5_1 in pairs(var_5_0) do
			if iter_5_1.updated_cnt > arg_5_0.vars.last_updated_cnt then
				local var_5_1 = arg_5_0.vars.vg_sight_images[iter_5_1.length]
				
				if var_5_1 then
					local var_5_2 = var_5_1.sz
					local var_5_3 = var_5_1.half
					
					if iter_5_1.level == HTBFogVisibilityEnum.VISIBLE then
						var_5_3 = var_5_1.normal
					end
					
					draw_tile(arg_5_0.vars.writeable_texture, var_5_3, iter_5_1.pos.x, iter_5_1.pos.y, var_5_2.width, var_5_2.height)
				else
					print("ERROR : NOT EXIST LENGTHT", iter_5_1.length)
				end
			end
		end
		
		arg_5_0.vars.last_updated_cnt = arg_5_4:getLastUpdatedCnt()
		
		for iter_5_2 = 1, 9999 do
			local var_5_4 = arg_5_4:getFogDataByIdx(iter_5_2)
			
			if not var_5_4 then
				break
			end
			
			local var_5_5 = var_5_4:getVisibility()
			local var_5_6 = var_5_4:getPos()
			local var_5_7 = var_5_6.x
			local var_5_8 = var_5_6.y
			
			if var_5_5 then
				HTBInterface:onUpdateFogCallback(arg_5_2, var_5_7, var_5_8, var_5_5)
			end
		end
	end
	
	HTBInterface:objectCulling(arg_5_3)
end

function HTBFogRenderer.setVisibleUILayer(arg_6_0)
	SceneManager:getRunningUIScene():addChild(arg_6_0.vars.tex_map)
end

function HTBFogRenderer.createVgSightImages(arg_7_0)
	arg_7_0.vars.vg_sight_images = {}
	
	local var_7_0 = {
		[0] = {
			width = 12,
			height = 7
		},
		{
			width = 36,
			height = 20
		},
		{
			width = 60,
			height = 34
		},
		{
			width = 85,
			height = 48
		}
	}
	
	for iter_7_0 = 0, 3 do
		local var_7_1 = {}
		local var_7_2 = "tile/vg_sight_" .. iter_7_0
		local var_7_3 = cc.Image:new()
		
		var_7_3:initWithImageFile(var_7_2 .. ".png")
		var_7_3:retain()
		
		local var_7_4 = cc.Image:new()
		
		var_7_4:initWithImageFile(var_7_2 .. "_half.png")
		var_7_4:retain()
		
		local var_7_5 = {
			normal = var_7_3,
			half = var_7_4,
			sz = var_7_0[iter_7_0]
		}
		
		arg_7_0.vars.vg_sight_images[iter_7_0] = var_7_5
	end
end

function HTBFogRenderer.createWriteableTexture(arg_8_0)
	local var_8_0 = 0
	local var_8_1 = 1
	local var_8_2 = 2
	local var_8_3 = 3
	local var_8_4 = 4
	local var_8_5 = 5
	
	arg_8_0.vars.writeable_texture = yuna2d.WritableTexture:create(1024, 1024, cc.TEXTURE2_D_PIXEL_FORMAT_A8, var_8_4, cc.c4b(0, 0, 0, 255))
	
	arg_8_0.vars.writeable_texture:setAntiAliasTexParameters()
	
	local var_8_6 = cc.Sprite:createWithTexture(arg_8_0.vars.writeable_texture)
	
	var_8_6:setAnchorPoint(0, 0)
	var_8_6:setScale(10.7)
	var_8_6:setPosition(0, 0)
	
	local var_8_7 = cc.Node:create()
	
	var_8_7:addChild(var_8_6)
	var_8_7:setPosition(-1070, 0)
	
	arg_8_0.vars.render_layer = var_8_7
	
	arg_8_0.vars.parent_layer:setPosition(0, 0)
end

function HTBFogRenderer.createCocosObjects(arg_9_0)
	arg_9_0.vars.tex_map = cc.RenderTexture:create(arg_9_0.vars.render_width, arg_9_0.vars.render_height, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
	
	arg_9_0.vars.tex_map:clear(0, 0, 0, 0)
	arg_9_0.vars.tex_map:retain()
	
	arg_9_0.vars.fog_layer = cc.Node:create()
	
	arg_9_0.vars.fog_layer:setContentSize(arg_9_0.vars.render_width, arg_9_0.vars.render_height)
	arg_9_0.vars.fog_layer:retain()
	arg_9_0.vars.tex_map:begin()
	arg_9_0.vars.fog_layer:visit()
	arg_9_0.vars.tex_map:endToLua()
	
	local var_9_0 = cc.RenderTexture:create(arg_9_0.vars.render_width, arg_9_0.vars.render_height, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
	
	var_9_0:clear(0, 0, 0, 255)
	
	arg_9_0.vars.render_layer = cc.Layer:create()
	
	arg_9_0.vars.render_layer:setOpacity(128)
	arg_9_0.vars.render_layer:addChild(var_9_0)
	
	arg_9_0.vars.draw_texture = var_9_0
	
	arg_9_0.vars.draw_texture:setOpacity(128)
	arg_9_0.vars.draw_texture:setName("DRAW_TEXTURE")
	arg_9_0.vars.draw_texture:getSprite():setAnchorPoint(0, 0.5)
end

function HTBFogRenderer._off(arg_10_0)
	arg_10_0.vars.pst:setUniformFloat("u_dirAngle", 0)
	arg_10_0.vars.pst:setUniformFloat("u_perRange", 0)
	arg_10_0.vars.pst:setUniformFloat("u_maxRange", 0)
end

function HTBFogRenderer.programSet(arg_11_0)
	local var_11_0 = cc.GLProgramCache:getInstance():getGLProgram("tile_fog_debug")
	
	if var_11_0 then
		local var_11_1 = cc.GLProgramState:getOrCreateWithGLProgram(var_11_0)
		
		if var_11_1 then
			var_11_1:setUniformTexture("u_TexMask", arg_11_0.vars.tex_map:getSprite():getTexture())
			var_11_1:setUniformFloat("u_dirAngle", 14)
			var_11_1:setUniformFloat("u_perRange", 16)
			var_11_1:setUniformFloat("u_maxRange", 128)
			var_11_1:setUniformVec2("u_Resolution", {
				x = arg_11_0.vars.render_width,
				y = arg_11_0.vars.render_height
			})
			
			arg_11_0.vars.pst = var_11_1
			
			arg_11_0.vars.draw_texture:getSprite():setDefaultGLProgramState(var_11_1)
			arg_11_0.vars.draw_texture:getSprite():setGLProgramState(var_11_1)
		else
			print("NO STATES NO STATES NO STATES")
		end
	else
		print("BUG BUG BUG")
	end
end

function HTBFogRenderer.updateRender(arg_12_0)
	if arg_12_0.vars and arg_12_0.vars.request_update_texture_map and arg_12_0.vars.shader_fog_mode then
		arg_12_0.vars.request_update_texture_map = nil
		
		arg_12_0:updateTextureMap()
	end
end

function HTBFogRenderer.isActive(arg_13_0)
	return arg_13_0.vars and get_cocos_refid(arg_13_0.vars.fog_layer) and get_cocos_refid(arg_13_0.vars.tex_map)
end

function HTBFogRenderer.updateTextureMap(arg_14_0)
	if not arg_14_0.vars or not get_cocos_refid(arg_14_0.vars.fog_layer) then
		return 
	end
	
	arg_14_0.vars.tex_map:beginWithClear(255, 255, 255, 0)
	arg_14_0.vars.fog_layer:visit()
	arg_14_0.vars.tex_map:endToLua()
end

function HTBFogRenderer.release(arg_15_0)
	for iter_15_0, iter_15_1 in pairs(arg_15_0.vars.sprite_hash_map) do
		for iter_15_2, iter_15_3 in pairs(iter_15_1 or {}) do
			iter_15_3:removeFromParent()
		end
	end
	
	if arg_15_0.vars.vg_sight_images then
		for iter_15_4, iter_15_5 in pairs(arg_15_0.vars.vg_sight_images) do
			iter_15_5.normal:release()
			iter_15_5.half:release()
		end
	end
	
	arg_15_0.vars.sprite_hash_map = {}
	
	arg_15_0:updateTextureMap()
end

function HTBFogRenderer.close(arg_16_0)
	if not arg_16_0.vars then
		return 
	end
	
	arg_16_0:release()
	
	if get_cocos_refid(arg_16_0.vars.tex_map) then
		arg_16_0.vars.tex_map:release()
	end
	
	if get_cocos_refid(arg_16_0.vars.fog_layer) then
		arg_16_0.vars.fog_layer:release()
	end
	
	if get_cocos_refid(arg_16_0.vars.draw_texture) then
		arg_16_0.vars.draw_texture:removeFromParent()
	end
	
	if get_cocos_refid(arg_16_0.vars.render_layer) then
		arg_16_0.vars.render_layer:removeFromParent()
	end
	
	arg_16_0.vars = nil
end
