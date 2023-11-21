LotaFogRenderer = {}

function LotaFogRenderer.init(arg_1_0, arg_1_1)
	LotaFogRenderer:close()
	
	arg_1_0.vars = {}
	arg_1_0.vars.parent_layer = arg_1_1
	
	local var_1_0 = LotaWhiteboard:get("map_min_x")
	local var_1_1 = LotaWhiteboard:get("map_max_x")
	local var_1_2 = LotaWhiteboard:get("map_min_y")
	local var_1_3 = LotaWhiteboard:get("map_max_y")
	
	arg_1_0.vars.map_min_x = var_1_0
	arg_1_0.vars.map_max_x = var_1_1
	arg_1_0.vars.map_min_y = var_1_2
	arg_1_0.vars.map_max_y = var_1_3
	arg_1_0.vars.width = var_1_1 - var_1_0
	arg_1_0.vars.height = var_1_3 - var_1_2
	arg_1_0.vars.render_width = VIEW_WIDTH
	arg_1_0.vars.render_height = VIEW_HEIGHT
	arg_1_0.vars.field_layer_x = LotaWhiteboard:get("field_layer_x")
	arg_1_0.vars.field_layer_y = LotaWhiteboard:get("field_layer_y")
	arg_1_0.vars.fog_layer_x = arg_1_1:getPositionX()
	arg_1_0.vars.fog_layer_y = arg_1_1:getPositionY()
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
	
	arg_1_1:addChild(arg_1_0.vars.render_layer)
end

function LotaFogRenderer.setVisibleUILayer(arg_2_0)
	SceneManager:getRunningUIScene():addChild(arg_2_0.vars.tex_map)
end

function LotaFogRenderer.createVgSightImages(arg_3_0)
	arg_3_0.vars.vg_sight_images = {}
	
	local var_3_0 = {
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
	
	for iter_3_0 = 0, 3 do
		local var_3_1 = {}
		local var_3_2 = "tile/vg_sight_" .. iter_3_0
		local var_3_3 = cc.Image:new()
		
		var_3_3:initWithImageFile(var_3_2 .. ".png")
		var_3_3:retain()
		
		local var_3_4 = cc.Image:new()
		
		var_3_4:initWithImageFile(var_3_2 .. "_half.png")
		var_3_4:retain()
		
		local var_3_5 = {
			normal = var_3_3,
			half = var_3_4,
			sz = var_3_0[iter_3_0]
		}
		
		arg_3_0.vars.vg_sight_images[iter_3_0] = var_3_5
	end
end

function LotaFogRenderer.createWriteableTexture(arg_4_0)
	local var_4_0 = 0
	local var_4_1 = 1
	local var_4_2 = 2
	local var_4_3 = 3
	local var_4_4 = 4
	local var_4_5 = 5
	
	arg_4_0.vars.writeable_texture = yuna2d.WritableTexture:create(1024, 1024, cc.TEXTURE2_D_PIXEL_FORMAT_A8, var_4_4, cc.c4b(0, 0, 0, 255))
	
	arg_4_0.vars.writeable_texture:setAntiAliasTexParameters()
	
	local var_4_6 = cc.Sprite:createWithTexture(arg_4_0.vars.writeable_texture)
	
	var_4_6:setAnchorPoint(0, 0)
	var_4_6:setScale(10.7)
	var_4_6:setPosition(0, 0)
	
	local var_4_7 = cc.Node:create()
	
	var_4_7:addChild(var_4_6)
	var_4_7:setPosition(-1070, 0)
	
	arg_4_0.vars.render_layer = var_4_7
	
	arg_4_0.vars.parent_layer:setPosition(0, 0)
end

function LotaFogRenderer.createCocosObjects(arg_5_0)
	arg_5_0.vars.tex_map = cc.RenderTexture:create(arg_5_0.vars.render_width, arg_5_0.vars.render_height, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
	
	arg_5_0.vars.tex_map:clear(0, 0, 0, 0)
	arg_5_0.vars.tex_map:retain()
	
	arg_5_0.vars.fog_layer = cc.Node:create()
	
	arg_5_0.vars.fog_layer:setContentSize(arg_5_0.vars.render_width, arg_5_0.vars.render_height)
	arg_5_0.vars.fog_layer:retain()
	arg_5_0.vars.tex_map:begin()
	arg_5_0.vars.fog_layer:visit()
	arg_5_0.vars.tex_map:endToLua()
	
	local var_5_0 = cc.RenderTexture:create(arg_5_0.vars.render_width, arg_5_0.vars.render_height, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
	
	var_5_0:clear(0, 0, 0, 255)
	
	arg_5_0.vars.render_layer = cc.Layer:create()
	
	arg_5_0.vars.render_layer:setOpacity(128)
	arg_5_0.vars.render_layer:addChild(var_5_0)
	
	arg_5_0.vars.draw_texture = var_5_0
	
	arg_5_0.vars.draw_texture:setOpacity(128)
	arg_5_0.vars.draw_texture:setName("DRAW_TEXTURE")
	arg_5_0.vars.draw_texture:getSprite():setAnchorPoint(0, 0.5)
end

function lfr_off()
	LotaFogRenderer:_off()
end

function LotaFogRenderer._off(arg_7_0)
	arg_7_0.vars.pst:setUniformFloat("u_dirAngle", 0)
	arg_7_0.vars.pst:setUniformFloat("u_perRange", 0)
	arg_7_0.vars.pst:setUniformFloat("u_maxRange", 0)
end

function LotaFogRenderer.programSet(arg_8_0)
	local var_8_0 = cc.GLProgramCache:getInstance():getGLProgram("tile_fog_debug")
	
	if var_8_0 then
		local var_8_1 = cc.GLProgramState:getOrCreateWithGLProgram(var_8_0)
		
		if var_8_1 then
			var_8_1:setUniformTexture("u_TexMask", arg_8_0.vars.tex_map:getSprite():getTexture())
			var_8_1:setUniformFloat("u_dirAngle", 14)
			var_8_1:setUniformFloat("u_perRange", 16)
			var_8_1:setUniformFloat("u_maxRange", 128)
			var_8_1:setUniformVec2("u_Resolution", {
				x = arg_8_0.vars.render_width,
				y = arg_8_0.vars.render_height
			})
			
			arg_8_0.vars.pst = var_8_1
			
			arg_8_0.vars.draw_texture:getSprite():setDefaultGLProgramState(var_8_1)
			arg_8_0.vars.draw_texture:getSprite():setGLProgramState(var_8_1)
		else
			print("NO STATES NO STATES NO STATES")
		end
	else
		print("BUG BUG BUG")
	end
end

function LotaFogRenderer.makeFogSprite(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7)
	local var_9_0 = arg_9_0.vars.sprite_hash_map[arg_9_4]
	
	if not var_9_0 or not var_9_0[arg_9_3] then
		local var_9_1 = SpriteCache:getSprite("tile/sample_white.png")
		
		if not var_9_0 then
			arg_9_0.vars.sprite_hash_map[arg_9_4] = {}
		end
		
		arg_9_0.vars.sprite_hash_map[arg_9_4][arg_9_3] = var_9_1
		
		arg_9_1:addChild(var_9_1)
	end
	
	arg_9_6 = arg_9_6 or 0.25
	
	local var_9_2 = arg_9_0.vars.sprite_hash_map[arg_9_4][arg_9_3]
	
	if not LotaWhiteboard:get("tile_y_scale") then
		local var_9_3 = 1
	end
	
	local var_9_4 = 1
	local var_9_5 = 0.25
	local var_9_6 = 1
	local var_9_7 = 1
	
	var_9_2:setScaleX(var_9_5 * var_9_4 * var_9_7)
	var_9_2:setScaleY(var_9_5 * var_9_6 * var_9_4)
	
	if arg_9_5 == LotaFogVisibilityEnum.NOT_DISCOVER then
		var_9_2:setOpacity(0)
	elseif arg_9_5 == LotaFogVisibilityEnum.DISCOVER then
		var_9_2:setOpacity(102)
	elseif arg_9_5 == LotaFogVisibilityEnum.VISIBLE then
		var_9_2:setOpacity(255)
	elseif arg_9_5 == nil then
		var_9_2:setOpacity(arg_9_7)
	end
	
	local var_9_8 = LotaWhiteboard:get("tile_width")
	local var_9_9 = LotaWhiteboard:get("tile_height")
	
	var_9_2:setLocalZOrder(arg_9_4 * 1)
	var_9_2:setPosition(arg_9_3 * (var_9_8 / 2) + arg_9_0.vars.field_position_gap_x, arg_9_4 * (var_9_9 / 2) + arg_9_0.vars.field_position_gap_y)
	
	return var_9_2
end

function LotaFogRenderer.updateRender(arg_10_0)
	if arg_10_0.vars and arg_10_0.vars.request_update_texture_map and arg_10_0.vars.shader_fog_mode then
		arg_10_0.vars.request_update_texture_map = nil
		
		arg_10_0:updateTextureMap()
	end
end

function LotaFogRenderer.isActive(arg_11_0)
	return arg_11_0.vars and get_cocos_refid(arg_11_0.vars.fog_layer) and get_cocos_refid(arg_11_0.vars.tex_map)
end

function LotaFogRenderer.updateTextureMap(arg_12_0)
	if not arg_12_0.vars or not get_cocos_refid(arg_12_0.vars.fog_layer) then
		return 
	end
	
	arg_12_0.vars.tex_map:beginWithClear(255, 255, 255, 0)
	arg_12_0.vars.fog_layer:visit()
	arg_12_0.vars.tex_map:endToLua()
end

function LotaFogRenderer.syncPosition(arg_13_0, arg_13_1, arg_13_2)
	if not arg_13_0.vars then
		return 
	end
	
	if arg_13_0.vars.shader_fog_mode then
		if not arg_13_0.vars or not get_cocos_refid(arg_13_0.vars.fog_layer) then
			return 
		end
		
		local var_13_0 = LotaCameraSystem:getCameraPos()
		local var_13_1, var_13_2 = LotaCameraSystem:getZoomPivotPos()
		local var_13_3 = var_13_0.x + var_13_1
		local var_13_4 = var_13_0.y + var_13_2
		
		arg_13_0.vars.render_layer:setPosition(-var_13_1, -var_13_2)
		
		local var_13_5 = LotaCameraSystem:getScale()
		
		arg_13_0.vars.fog_layer:setScale(var_13_5)
		
		local var_13_6 = var_13_3 + arg_13_0.vars.gap_x
		local var_13_7 = var_13_4 + arg_13_0.vars.gap_y
		
		arg_13_0.vars.fog_layer:setPosition(var_13_6, var_13_7)
		
		arg_13_0.vars.request_update_texture_map = true
	else
		local var_13_8 = LotaCameraSystem:getCameraPos()
		local var_13_9 = var_13_8.x
		local var_13_10 = var_13_8.y
		local var_13_11 = 304.41400304414003
		local var_13_12 = -190.2587519025875
		local var_13_13 = LotaCameraSystem:getScale()
		
		arg_13_0.vars.parent_layer:setPosition(var_13_9 + var_13_11 * var_13_13, var_13_10 + var_13_12 * var_13_13)
		arg_13_0.vars.parent_layer:setScale(var_13_13)
	end
end

function LotaFogRenderer.release(arg_14_0)
	for iter_14_0, iter_14_1 in pairs(arg_14_0.vars.sprite_hash_map) do
		for iter_14_2, iter_14_3 in pairs(iter_14_1 or {}) do
			iter_14_3:removeFromParent()
		end
	end
	
	if arg_14_0.vars.vg_sight_images then
		for iter_14_4, iter_14_5 in pairs(arg_14_0.vars.vg_sight_images) do
			iter_14_5.normal:release()
			iter_14_5.half:release()
		end
	end
	
	arg_14_0.vars.sprite_hash_map = {}
	
	arg_14_0:updateTextureMap()
end

function LotaFogRenderer.close(arg_15_0)
	if not arg_15_0.vars then
		return 
	end
	
	arg_15_0:release()
	
	if get_cocos_refid(arg_15_0.vars.tex_map) then
		arg_15_0.vars.tex_map:release()
	end
	
	if get_cocos_refid(arg_15_0.vars.fog_layer) then
		arg_15_0.vars.fog_layer:release()
	end
	
	if get_cocos_refid(arg_15_0.vars.draw_texture) then
		arg_15_0.vars.draw_texture:removeFromParent()
	end
	
	if get_cocos_refid(arg_15_0.vars.render_layer) then
		arg_15_0.vars.render_layer:removeFromParent()
	end
	
	arg_15_0.vars = nil
end

function LotaFogRenderer.uSAR(arg_16_0, arg_16_1, arg_16_2)
	for iter_16_0, iter_16_1 in pairs(arg_16_0.vars.sprite_hash_map) do
		for iter_16_2, iter_16_3 in pairs(iter_16_1 or {}) do
			iter_16_3:setScaleX(arg_16_1)
			iter_16_3:setScaleY(arg_16_2)
		end
	end
	
	arg_16_0:updateTextureMap()
end

function LotaFogRenderer.uSAP(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = LotaWhiteboard:get("tile_width")
	local var_17_1 = LotaWhiteboard:get("tile_height")
	
	for iter_17_0, iter_17_1 in pairs(arg_17_0.vars.sprite_hash_map) do
		for iter_17_2, iter_17_3 in pairs(iter_17_1 or {}) do
			iter_17_3:setPosition(iter_17_2 * (var_17_0 / 2) + arg_17_1, iter_17_0 * (var_17_1 / 2) + arg_17_2)
		end
	end
	
	arg_17_0:updateTextureMap()
end

function LotaFogRenderer.renderFogsOnShader(arg_18_0, arg_18_1)
	for iter_18_0 = 1, 9999 do
		local var_18_0 = arg_18_1:getFogDataByIdx(iter_18_0)
		
		if not var_18_0 then
			break
		end
		
		local var_18_1 = var_18_0:getVisibility()
		local var_18_2 = var_18_0:getPos()
		local var_18_3 = var_18_2.x
		local var_18_4 = var_18_2.y
		
		if var_18_1 == LotaFogVisibilityEnum.VISIBLE or var_18_1 == LotaFogVisibilityEnum.DISCOVER then
			arg_18_0:makeFogSprite(arg_18_0.vars.fog_layer, arg_18_1, var_18_3, var_18_4, var_18_1, 0.25)
			
			local var_18_5 = 255
			
			for iter_18_1, iter_18_2 in pairs(LotaUtil.MovablePaths) do
				local var_18_6 = LotaUtil:getAddedPosition(var_18_2, iter_18_2)
				
				if arg_18_1:getFogVisibility(var_18_6.x, var_18_6.y) == nil then
					local var_18_7 = 1
					
					if var_18_1 == LotaFogVisibilityEnum.DISCOVER then
						local var_18_8 = 0.5
					end
				end
			end
		end
		
		if var_18_1 then
			LotaObjectRenderer:updateColorByFog(var_18_3, var_18_4, var_18_1, arg_18_1)
			LotaMovableRenderer:updateColorByFog(var_18_3, var_18_4, var_18_1)
			LotaMinimapRenderer:updateFog(LotaTileMapSystem:getTileByPos({
				x = var_18_3,
				y = var_18_4
			}), var_18_1)
		end
	end
	
	arg_18_0:updateTextureMap()
end

function draw_tile(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6)
	local var_19_0 = 10
	local var_19_1 = 9.065420560747663
	
	arg_19_6 = arg_19_6 or 0
	
	local var_19_2 = 54
	local var_19_3 = arg_19_2 * (var_19_0 / 2) - arg_19_4 / 2 + 100
	local var_19_4 = 1024 - (arg_19_3 * (var_19_1 / 2) + arg_19_5 / 2 + var_19_2)
	local var_19_5 = 1
	local var_19_6 = var_19_3 / var_19_5
	local var_19_7 = var_19_4 / var_19_5
	
	arg_19_0:drawImage(var_19_6, var_19_7, arg_19_1)
end

function LotaFogRenderer.renderFogs(arg_20_0, arg_20_1)
	if not arg_20_0.vars then
		return 
	end
	
	if arg_20_0.vars.shader_fog_mode then
		arg_20_0:renderFogsOnShader(arg_20_1)
	else
		local var_20_0 = LotaFogSystem:getFogDiscoveredList()
		
		for iter_20_0, iter_20_1 in pairs(var_20_0) do
			if iter_20_1.updated_cnt > arg_20_0.vars.last_updated_cnt then
				local var_20_1 = arg_20_0.vars.vg_sight_images[iter_20_1.length]
				
				if var_20_1 then
					local var_20_2 = var_20_1.sz
					local var_20_3 = var_20_1.half
					
					if iter_20_1.level == LotaFogVisibilityEnum.VISIBLE then
						var_20_3 = var_20_1.normal
					end
					
					draw_tile(arg_20_0.vars.writeable_texture, var_20_3, iter_20_1.pos.x, iter_20_1.pos.y, var_20_2.width, var_20_2.height)
				else
					print("ERROR : NOT EXIST LENGTHT", iter_20_1.length)
				end
			end
		end
		
		arg_20_0.vars.last_updated_cnt = arg_20_1:getLastUpdatedCnt()
		
		for iter_20_2 = 1, 9999 do
			local var_20_4 = arg_20_1:getFogDataByIdx(iter_20_2)
			
			if not var_20_4 then
				break
			end
			
			local var_20_5 = var_20_4:getVisibility()
			local var_20_6 = var_20_4:getPos()
			local var_20_7 = var_20_6.x
			local var_20_8 = var_20_6.y
			
			if var_20_5 then
				LotaObjectRenderer:updateColorByFog(var_20_7, var_20_8, var_20_5, arg_20_1)
				LotaMovableRenderer:updateColorByFog(var_20_7, var_20_8, var_20_5)
				LotaMinimapRenderer:updateFog(LotaTileMapSystem:getTileByPos({
					x = var_20_7,
					y = var_20_8
				}), var_20_5)
			end
		end
	end
	
	LotaCameraSystem:objectCulling()
end
