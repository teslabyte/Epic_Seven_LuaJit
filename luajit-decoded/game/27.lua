Text = {}
TEXT_TABLE = TEXT_TABLE or {}
Text.tmp_texts = {
	err_no_clan = "기사단에 가입되지 않았습니다.",
	sk_source_lack = "#res# #num# 부족",
	waiting_for_stove_api_retry = "Waiting for STOVE API. Please try again. (#code#)",
	error_stove_api_retry = "STOVE API Error. Please try again. (#api# - #code#)",
	sk_source_cost = "#res# #num# 소모",
	sk_source_gain = "#res# #num# 획득",
	equip_swap_desc = "장비 교체시 #cost# 골드가 소모됩니다.\n교체하시겠습니까?",
	sk_source_maxcost = "#res# 최대 #max_num# 소모 (#num)"
}
Text.kr_postposition = {
	{
		"(은/는)",
		"은",
		"는"
	},
	{
		"(이/가)",
		"이",
		"가"
	},
	{
		"(과/와)",
		"과",
		"와"
	},
	{
		"(을/를)",
		"을",
		"를"
	},
	{
		"(으/)",
		"으",
		""
	}
}

function T(arg_1_0, arg_1_1, arg_1_2)
	return Text:getText(arg_1_0, arg_1_1, arg_1_2)
end

local function var_0_0(arg_2_0)
	if arg_2_0 > 240 then
		return 4
	elseif arg_2_0 > 225 then
		return 3
	elseif arg_2_0 > 192 then
		return 2
	end
end

local function var_0_1(arg_3_0, arg_3_1, arg_3_2)
	assert(type(arg_3_0) == "string")
	
	local var_3_0 = {}
	local var_3_1 = 0
	local var_3_2
	
	for iter_3_0 = arg_3_1, arg_3_2 do
		local var_3_3 = string.byte(arg_3_0, iter_3_0)
		
		if var_3_1 == 0 then
			table.insert(var_3_0, var_3_2)
			
			var_3_1 = var_3_3 < 128 and 1 or var_3_3 < 224 and 2 or var_3_3 < 240 and 3 or var_3_3 < 248 and 4 or error("invalid UTF-8 character sequence")
			var_3_2 = bit.band(var_3_3, 2^(8 - var_3_1) - 1)
		else
			var_3_2 = bit.bor(bit.lshift(var_3_2, 6), bit.band(var_3_3, 63))
		end
		
		var_3_1 = var_3_1 - 1
	end
	
	return var_3_2
end

local function var_0_2(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_1
	local var_4_1
	local var_4_2
	local var_4_3
	local var_4_4
	local var_4_5
	
	while var_4_0 > 1 do
		local var_4_6 = arg_4_0:sub(var_4_0, var_4_0)
		local var_4_7 = string.byte(var_4_6)
		local var_4_8 = var_4_7 >= 48 and var_4_7 <= 57
		
		if not (var_4_7 < 128 and not var_4_8) then
			if var_4_8 then
				local var_4_9 = var_4_7 - 48
				
				return var_4_9 ~= 2 and var_4_9 ~= 4 and var_4_9 ~= 5 and var_4_9 ~= 9
			else
				local var_4_10
				local var_4_11 = var_4_0 - 1
				
				while var_4_11 > 0 do
					var_4_10 = var_0_0(string.byte(arg_4_0:sub(var_4_11, var_4_11)))
					
					if var_4_10 then
						break
					end
					
					var_4_11 = var_4_11 - 1
				end
				
				if not var_4_10 then
					return 
				end
				
				var_4_0 = var_4_0 - (var_4_10 - 1)
				
				if var_4_10 == 3 then
					local var_4_12 = var_0_1(arg_4_0, var_4_11, var_4_11 + var_4_10 - 1)
					
					if var_4_12 < 44032 or var_4_12 > 55203 then
						return 
					end
					
					return (var_4_12 - 44032) % 28 ~= 0
				end
			end
		end
		
		var_4_0 = var_4_0 - 1
	end
	
	return true
end

local function var_0_3(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0
	
	if var_0_2(arg_5_0, arg_5_1 - 1) then
		var_5_0 = arg_5_3[2]
	else
		var_5_0 = arg_5_3[3]
	end
	
	arg_5_0 = arg_5_0:sub(1, arg_5_1 - 1) .. var_5_0 .. arg_5_0:sub(arg_5_2 + 1, -1)
	
	return arg_5_0
end

function T_KR(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = T(arg_6_0, arg_6_1, arg_6_2)
	
	return PROC_KR(var_6_0)
end

function PROC_KR(arg_7_0)
	for iter_7_0 = 1, #Text.kr_postposition do
		local var_7_0 = Text.kr_postposition[iter_7_0]
		local var_7_1 = 1
		local var_7_2
		
		while true do
			local var_7_3
			
			var_7_1, var_7_3 = string.find(arg_7_0, var_7_0[1], var_7_1, true)
			
			if not var_7_1 then
				break
			end
			
			arg_7_0 = var_0_3(arg_7_0, var_7_1, var_7_3, var_7_0)
		end
	end
	
	return arg_7_0
end

DEBUG_TEXT_ID = nil

function Text.getText(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_1
	
	if type(arg_8_2) == "table" then
		arg_8_3 = arg_8_2
		arg_8_2 = nil
	end
	
	local var_8_1
	
	if TEXT_TABLE and TEXT_TABLE[arg_8_1] then
		arg_8_1 = TEXT_TABLE[arg_8_1]
	elseif arg_8_1 and string.find(arg_8_1, "^[%l_%d\\.]+$") then
		ResourceCollect:add("text@", arg_8_1)
		
		var_8_1 = DB("text", arg_8_1, "text") or Text.tmp_texts[arg_8_1]
		arg_8_1 = var_8_1 or arg_8_2 or arg_8_1
		
		local var_8_2 = string.find(string.sub(arg_8_1, -4), "{[0-9][0-9]?}")
		
		if var_8_2 then
			arg_8_1 = string.sub(arg_8_1, 0, -5 + (var_8_2 - 1))
		end
	end
	
	arg_8_1 = arg_8_1 or ""
	arg_8_1 = string.gsub(arg_8_1, "\\n", "\n")
	
	if PLATFORM == "win32" and not var_8_1 and arg_8_1 ~= "" then
		var_8_0 = var_8_0 or "nil"
		arg_8_1 = "@" .. var_8_0
		
		if arg_8_3 then
			arg_8_1 = arg_8_1 .. " " .. json.encode(arg_8_3)
		end
		
		if DEBUG.TEXT then
			Log.e(arg_8_1)
		end
	end
	
	if arg_8_3 then
		local var_8_3 = arg_8_1
		
		for iter_8_0, iter_8_1 in pairs(arg_8_3) do
			arg_8_1 = string.gsub(arg_8_1, "#" .. iter_8_0 .. "#", tostring(iter_8_1))
			
			if arg_8_2 and DEBUG.TEST_LOCAL then
				arg_8_1 = arg_8_1 .. "#" .. iter_8_0
			end
		end
		
		if getUserLanguage() == "ko" and string.find(var_8_3, "#.?.?%(") then
			arg_8_1 = PROC_KR(arg_8_1)
		end
	end
	
	if DEBUG_TEXT_ID then
		arg_8_1 = "@" .. (var_8_0 or "nil")
	end
	
	return arg_8_1
end

function Text.getSortName(arg_9_0, arg_9_1)
	local var_9_0 = getUserLanguage()
	
	if var_9_0 ~= "zht" and var_9_0 ~= "zhs" then
		return nil
	end
	
	local var_9_1 = DB("name_sort", arg_9_1, "name_sort")
	
	if var_9_1 then
		return var_9_1
	end
	
	local function var_9_2(arg_10_0)
		if string.starts(arg_10_0, "chrn_") and string.match(arg_10_0, "^chrn_[cdm]%d+$") then
			return true
		end
		
		if string.starts(arg_10_0, "ef") and string.match(arg_10_0, "^ef[wkarmh%d]%d+_name$") then
			return true
		end
		
		return false
	end
	
	if var_9_0 == "zht" then
		if not var_9_2(arg_9_1) and not string.match(arg_9_1, "^chrn_s%d%d%d%d$") then
			Log.e("sort_name", "No bopomofo data: " .. arg_9_1)
		end
		
		return nil
	end
	
	if var_9_0 == "zhs" then
		if not var_9_2(arg_9_1) and not string.match(arg_9_1, "^chrn_s%d%d%d%d$") then
			Log.e("sort_name", "No pinyin data: " .. arg_9_1)
		end
		
		return nil
	end
	
	Log.e("sort_name", "impossible: " .. arg_9_1)
	
	return nil
end

function Text.replace(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	return string.sub(arg_11_1, 0, arg_11_2 - 1) .. arg_11_4 .. string.sub(arg_11_1, arg_11_3 + 1, -1)
end
