SpriteCache = {}

function sprite_format_str(arg_1_0)
	local var_1_0 = string.gsub(string.reverse(arg_1_0), "%d+", function(arg_2_0)
		return "d" .. tostring(arg_2_0:len()) .. "0%"
	end, 1)
	
	return string.reverse(var_1_0)
end

function sprite_name_byindex(arg_3_0, arg_3_1)
	return string.format(sprite_format_str(arg_3_0), arg_3_1)
end

function SpriteCache.createFromAtlas(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = {}
	local var_4_1
	local var_4_2
	
	if string.ends(arg_4_1, ".sca") then
		print("load_sc_atlas : ", arg_4_1)
		
		local var_4_3 = load_sc_atlas(arg_4_1)
		
		arg_4_0.info = arg_4_0.info or {}
		
		for iter_4_0, iter_4_1 in pairs(var_4_3) do
			arg_4_0.info[iter_4_1] = arg_4_0.info[iter_4_1] or {}
			
			table.merge(arg_4_0.info[iter_4_1], {
				is_spine_atlas = true,
				name = iter_4_1
			})
		end
		
		return 
	end
	
	if string.ends(arg_4_1, ".atlas") then
		var_4_2 = true
		var_4_1 = parse_atlas(arg_4_1)
		
		if not var_4_1 then
			return var_4_0
		end
	end
	
	if string.ends(arg_4_1, ".plist") then
		var_4_1 = parse_plist(arg_4_1)
		
		if not var_4_1 then
			return var_4_0
		end
	end
	
	if not var_4_1 then
		return var_4_0
	end
	
	for iter_4_2, iter_4_3 in pairs(var_4_1) do
		local var_4_4 = arg_4_2 or Path.join(Path.dirname(arg_4_1), iter_4_2)
		local var_4_5 = cc.Director:getInstance():getTextureCache():addImage(var_4_4)
		
		if var_4_5 then
			for iter_4_4, iter_4_5 in pairs(iter_4_3) do
				if iter_4_5.rc and iter_4_5.sz then
					local var_4_6
					local var_4_7
					
					if var_4_2 then
						var_4_6 = cc.p((iter_4_5.rc.width - iter_4_5.sz.width) * 0.5 + iter_4_5.ox, (iter_4_5.rc.height - iter_4_5.sz.height) * 0.5 + iter_4_5.oy)
						
						if iter_4_5.r then
							var_4_6.x = -var_4_6.x
							var_4_6.y = -var_4_6.y
							var_4_7 = 180
						end
					else
						var_4_6 = cc.p(iter_4_5.ox, iter_4_5.oy)
					end
					
					local var_4_8 = cc.SpriteFrame:createWithTexture(var_4_5, iter_4_5.rc, iter_4_5.r, var_4_6, iter_4_5.sz)
					
					if var_4_8 then
						var_4_8["-rotation"] = var_4_7
						
						table.insert(var_4_0, iter_4_4)
						arg_4_0:addSpriteFrame(var_4_8, iter_4_4, var_4_2)
					end
				end
			end
		end
	end
	
	return var_4_0
end

function SpriteCache.load(arg_5_0, arg_5_1)
	return arg_5_0:createFromAtlas(arg_5_1)
end

function SpriteCache.addSpriteFrame(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_0.info = arg_6_0.info or {}
	arg_6_0.info[arg_6_2] = arg_6_0.info[arg_6_2] or {}
	
	table.merge(arg_6_0.info[arg_6_2], {
		name = arg_6_2,
		is_spine_atlas = arg_6_3
	})
	cc.SpriteFrameCache:getInstance():addSpriteFrame(arg_6_1, arg_6_2)
end

function SpriteCache.getFrameCount(arg_7_0, arg_7_1)
	return #arg_7_0:getFrames(arg_7_1)
end

function SpriteCache.getFrames(arg_8_0, arg_8_1)
	arg_8_0.frameinfo = arg_8_0.frameinfo or {}
	
	local var_8_0 = arg_8_0.frameinfo[arg_8_1]
	
	if var_8_0 and var_8_0.frames then
		return var_8_0.frames
	end
	
	local var_8_1 = sprite_format_str(arg_8_1)
	local var_8_2 = 0
	local var_8_3 = {}
	
	while true do
		var_8_2 = var_8_2 + 1
		
		local var_8_4 = string.format(var_8_1, var_8_2)
		
		spr = arg_8_0:getSprite(var_8_4)
		
		if not spr then
			break
		end
		
		var_8_3[var_8_2] = var_8_4
	end
	
	arg_8_0.frameinfo[arg_8_1] = arg_8_0.frameinfo[arg_8_1] or {}
	
	table.merge(arg_8_0.frameinfo[arg_8_1], {
		frames = var_8_3
	})
	
	return var_8_3
end

function SpriteCache.getFrameName(arg_9_0, arg_9_1)
	if arg_9_0.info and arg_9_0.info[arg_9_1] then
		return arg_9_1
	end
	
	local var_9_0 = arg_9_1
	local var_9_1
	
	if not string.find(arg_9_1, "/") then
		var_9_0 = "img/" .. arg_9_1
	end
	
	local var_9_2, var_9_3 = table.unpack(string.split(var_9_0, "?"))
	
	if not string.ends(var_9_2, ".png") and not string.ends(var_9_2, ".sct") and not string.ends(var_9_2, ".webp") then
		var_9_2 = var_9_2 .. ".png"
	end
	
	if var_9_3 and string.len(var_9_3) > 0 then
		return var_9_2 .. "?" .. var_9_3
	end
	
	return var_9_2
end

function SpriteCache.loadCache(arg_10_0)
	local var_10_0 = cc.FileUtils:getInstance():getStringFromFile("spritecache.txt")
	
	if var_10_0 == "" then
		return 
	end
	
	local var_10_1 = string.split(var_10_0, "\n")
	
	for iter_10_0, iter_10_1 in pairs(var_10_1) do
		local var_10_2 = string.trim(iter_10_1)
		local var_10_3 = arg_10_0:getSprite(var_10_2)
		
		if var_10_3 then
			var_10_3:retain()
		end
	end
end

function SpriteCache.getOrCreateSpriteFrame(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0:getFrameName(arg_11_1) or ""
	
	if var_11_0 == "" then
		Log.e("SpriteCache", "getSprite is no have sprite frame : " .. arg_11_1)
		
		return 
	end
	
	return cc.SpriteFrameCache:getInstance():getOrCreateSpriteFrame(var_11_0)
end

function SpriteCache.getSprite(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0
	
	if arg_12_2 then
		var_12_0 = arg_12_2:getSpriteFrame(arg_12_1)
	else
		var_12_0 = arg_12_0:getOrCreateSpriteFrame(arg_12_1)
	end
	
	if not var_12_0 then
		return 
	end
	
	local var_12_1 = cc.Sprite:createWithSpriteFrame(var_12_0)
	
	if var_12_1 then
		var_12_1:setName(arg_12_1)
		var_12_1:setRotation(var_12_0["-rotation"] or 0)
		
		return var_12_1
	end
end

function SpriteCache.getScale9Sprite(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0:getOrCreateSpriteFrame(arg_13_1)
	
	if not var_13_0 then
		return 
	end
	
	local var_13_1 = ccui.Scale9Sprite:createWithSpriteFrame(var_13_0)
	
	if var_13_1 then
		var_13_1:setName(arg_13_1)
		var_13_1:setRotation(var_13_0["-rotation"] or 0)
		
		return var_13_1
	end
end

function SpriteCache.setSpriteTexture(arg_14_0, arg_14_1, arg_14_2)
	if get_cocos_refid(arg_14_1) then
		local var_14_0 = arg_14_0:getOrCreateSpriteFrame(arg_14_2)
		
		if var_14_0 then
			if arg_14_1.setSpriteFrame then
				arg_14_1:setSpriteFrame(var_14_0)
				
				if var_14_0["-rotation"] then
					arg_14_1:setRotation(var_14_0["-rotation"])
				end
			elseif arg_14_1.loadTexture then
				arg_14_1:loadTexture(var_14_0)
			end
			
			if arg_14_1.programHandler then
				arg_14_1:programHandler()
			end
			
			return var_14_0
		end
	end
	
	if false then
	end
end

function SpriteCache.resetSprite(arg_15_0, arg_15_1, arg_15_2)
	if not arg_15_1 then
		return 
	end
	
	if type(arg_15_2) == "number" then
		local var_15_0 = arg_15_2
		
		arg_15_2 = sprite_name_byindex(arg_15_1:getName(), var_15_0)
	end
	
	return arg_15_0:setSpriteTexture(arg_15_1, arg_15_0:getFrameName(arg_15_2))
end

function SpriteCache.digit(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6)
	arg_16_6 = arg_16_6 or ".png"
	
	local var_16_0 = #arg_16_1
	local var_16_1 = arg_16_2 or 0
	
	if type(arg_16_2) == "number" then
		local var_16_2 = "%"
		
		if arg_16_4 then
			var_16_2 = var_16_2 .. "-"
		end
		
		if arg_16_5 then
			var_16_2 = var_16_2 .. "0"
		end
		
		local var_16_3 = var_16_2 .. var_16_0 .. "d"
		
		var_16_1 = string.format(var_16_3, arg_16_2)
	end
	
	local var_16_4 = string.len(var_16_1)
	local var_16_5 = 0
	
	for iter_16_0 = 1, var_16_0 do
		local var_16_6
		local var_16_7 = var_16_0 < var_16_4 and "9" or string.sub(var_16_1, iter_16_0, iter_16_0)
		
		if var_16_7 == "/" then
			var_16_7 = "_slash"
		end
		
		if var_16_7 ~= "" and var_16_7 ~= " " then
			local var_16_8 = (arg_16_3 .. var_16_7) .. arg_16_6
			
			if not get_cocos_refid(arg_16_1[iter_16_0]) then
				print("ERROR", var_16_8)
				
				return 
			end
			
			arg_16_1[iter_16_0]:setVisible(true)
			arg_16_0:setSpriteTexture(arg_16_1[iter_16_0], var_16_8)
		else
			arg_16_1[iter_16_0]:setVisible(false)
		end
	end
end

function SpriteCache.playCut(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6)
	local var_17_0 = 2
	
	if DEBUG.MOVIE_MODE then
		var_17_0 = 1
	end
	
	local var_17_1 = 80
	local var_17_2 = var_17_0 * MODEL_SCALE_FACTOR
	
	arg_17_0:load(arg_17_2)
	
	local var_17_3
	
	if type(arg_17_5) == "table" then
		var_17_3 = arg_17_5[#arg_17_5]
	else
		var_17_3 = arg_17_0:getFrameCount(arg_17_3) * var_17_1
	end
	
	local var_17_4 = arg_17_0:getSprite(arg_17_3)
	
	if not var_17_4 then
		print("[ERROR] playCut  no found file " .. arg_17_3)
		
		if arg_17_6 then
			UIAction:Add(CALL(resume), Battle, "battle")
		end
		
		return 
	end
	
	var_17_4:setScale(var_17_2)
	var_17_4:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	
	local var_17_5 = string.gsub(arg_17_2, ".atlas", "_f.sct")
	
	function var_17_4.programHandler(arg_18_0)
		local var_18_0 = cc.GLProgramCache:getInstance():getGLProgram("simple_blur")
		
		if var_18_0 then
			local var_18_1 = cc.Director:getInstance():getTextureCache():addImage(var_17_5)
			
			print(var_18_1)
			
			local var_18_2 = cc.GLProgramState:getOrCreateWithGLProgram(var_18_0)
			
			var_18_2:setUniformTexture("u_blurTexture", var_18_1)
			arg_18_0:setGLProgramState(var_18_2)
		end
	end
	
	arg_17_0:resetSprite(var_17_4, 1)
	UIAction:Add(ANI(var_17_3, arg_17_3, true, false, arg_17_5), var_17_4)
	
	if arg_17_6 then
		UIAction:Add(SEQ(DELAY(var_17_3), CALL(resume)), Battle, "battle")
	end
	
	if arg_17_4 then
		local var_17_6 = cc.Sprite:create("img/_black_s.png")
		
		var_17_6:setScaleX(DESIGN_WIDTH / 16)
		var_17_6:setScaleY(DESIGN_HEIGHT / 16)
		var_17_6:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
		var_17_6:setOpacity(0)
		UIAction:Add(SEQ(OPACITY(200, 0, 0.8), DELAY(var_17_3 - 200), OPACITY(200, 0.8, 0), REMOVE()), var_17_6, "battle")
		var_17_6:setLocalZOrder(999999888)
		arg_17_1:addChild(var_17_6)
	end
	
	arg_17_1:addChild(var_17_4)
	var_17_4:setLocalZOrder(999999999)
	
	return var_17_4, var_17_3
end

function SpriteCache.play(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6)
	if arg_19_6 then
		arg_19_0:load(arg_19_6)
	end
	
	arg_19_5 = arg_19_5 or {}
	
	if arg_19_5.tm == nil then
		arg_19_5.tm = 70
	end
	
	local var_19_0
	
	if arg_19_5.spr then
		print("!!!")
		
		var_19_0 = arg_19_5.spr
	else
		var_19_0 = arg_19_0:getSprite(arg_19_2)
		
		var_19_0:setPosition(arg_19_3, arg_19_4)
		arg_19_1:addChild(var_19_0)
	end
	
	local var_19_1 = arg_19_0:getFrames(arg_19_2)
	local var_19_2 = arg_19_5.frame or #var_19_1
	local var_19_3 = arg_19_5.act_name or "effect"
	
	if arg_19_5.delay then
		var_19_0:setVisible(false)
		Action:Add(SEQ(DELAY(arg_19_5.delay), SHOW(true), ANI(var_19_2 * arg_19_5.tm, var_19_1, arg_19_5.auto_remove, arg_19_5.loop, nil, arg_19_5.interval)), var_19_0, var_19_3, arg_19_5.list)
	else
		Action:Add(ANI(var_19_2 * arg_19_5.tm, var_19_1, arg_19_5.auto_remove, arg_19_5.loop, nil, arg_19_5.interval), var_19_0, var_19_3, arg_19_5.list)
	end
	
	return var_19_0
end
