PetAniDirector = {}

local var_0_0 = {
	{
		idle = {
			time_random_min = -1000,
			time_random_max = 1000,
			time = 1500,
			use_random = true
		},
		camping = {
			time = 5000
		},
		move = {
			speed = 100,
			x_vector_min = 0.5,
			time = 1200,
			reverse_percent = 50
		},
		collision_wait = {
			time = 300
		},
		collision = {
			time = 600,
			speed = 100
		}
	},
	{
		idle = {
			time_random_min = -500,
			time_random_max = 500,
			time = 700,
			use_random = true
		},
		camping = {
			time = 5000
		},
		move = {
			speed = 150,
			x_vector_min = 0.5,
			time = 1300,
			reverse_percent = 50
		},
		collision_wait = {
			time = 300
		},
		collision = {
			time = 300,
			speed = 100
		}
	},
	{
		idle = {
			time_random_min = -6000,
			time_random_max = 1000,
			time = 2500,
			use_random = true
		},
		camping = {
			time = 5000
		},
		move = {
			speed = 50,
			x_vector_min = 0.5,
			time = 500,
			reverse_percent = 50
		},
		collision_wait = {
			time = 300
		},
		collision = {
			time = 1200,
			speed = 100
		}
	}
}

function PetAniDirector.init(arg_1_0, arg_1_1)
	arg_1_0.vars = {}
	arg_1_0.vars.pet_anis = {}
	arg_1_0.vars.origin_position = {}
	
	for iter_1_0, iter_1_1 in pairs(arg_1_1) do
		arg_1_0:addPet(iter_1_1, iter_1_0)
	end
end

local function var_0_1(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_0
	local var_2_1 = math.max(arg_2_1, var_2_0)
	
	return (math.min(arg_2_2, var_2_1))
end

function PetAniDirector.addPet(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	if arg_3_0.vars.pet_anis[arg_3_2] then
		Log.e("ALREADY EXISTS PET ANIMATION.")
	end
	
	local var_3_0 = VIEW_WIDTH / DESIGN_WIDTH
	local var_3_1 = {
		top = 120,
		height = 400,
		width = 871 * var_3_0,
		left = 80 - VIEW_BASE_LEFT
	}
	local var_3_2 = arg_3_1.node
	local var_3_3 = math.random(-30, 30)
	local var_3_4 = math.random(-15, 15)
	local var_3_5, var_3_6 = var_3_2:getPosition()
	
	if arg_3_0.vars.origin_position[arg_3_2] then
		var_3_5, var_3_6 = arg_3_0.vars.origin_position[arg_3_2].x, arg_3_0.vars.origin_position[arg_3_2].y
	else
		arg_3_0.vars.origin_position[arg_3_2] = {
			x = var_3_5,
			y = var_3_6
		}
	end
	
	local var_3_7 = var_3_5 * var_3_0
	local var_3_8 = var_3_6 - 80
	local var_3_9 = var_3_7 + var_3_3
	local var_3_10 = var_3_8 + var_3_4
	local var_3_11 = var_0_1(var_3_9, 180, 871 * var_3_0 - 100)
	local var_3_12 = var_0_1(var_3_10, 200, 280)
	
	var_3_2:setPosition(var_3_11, var_3_12)
	
	local var_3_13 = math.floor(math.random(1, #var_0_0))
	local var_3_14 = table.clone(var_0_0[var_3_13])
	local var_3_15 = arg_3_1.pet:isAnimationMovable()
	local var_3_16 = var_0_1(var_3_11 + 100 * var_3_0, 80, 871 * var_3_0)
	
	var_3_1.left, var_3_1.width = var_0_1(var_3_11 - 100 * var_3_0, 80, 871 * var_3_0), var_3_16
	var_3_1.height = 320
	var_3_1.top = 160
	
	if not var_3_15 then
		var_3_14.idle.camping = true
		var_3_14.idle.begin_camping = true
		var_3_14.camping.loop = true
	end
	
	arg_3_0.vars.pet_anis[arg_3_2] = PET_ANI_CONTROLLER:create(arg_3_1.pet, arg_3_1.model, arg_3_1.node, arg_3_1.info_node, arg_3_1.slot_idx, var_3_1, var_3_14)
	
	if arg_3_0.vars.ambient_color then
		arg_3_0.vars.pet_anis[arg_3_2]:setAmbientColor(arg_3_0.vars.ambient_color)
	end
	
	if arg_3_3 then
		arg_3_0.vars.pet_anis[arg_3_2]:playAddAnimation()
	end
end

function PetAniDirector.addEffect(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_0.vars.pet_anis[arg_4_1]
	
	if not var_4_0 then
		return 
	end
	
	var_4_0:addEffect(arg_4_2)
end

function PetAniDirector.focus(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = arg_5_0.vars.pet_anis[arg_5_1]
	
	if not var_5_0 then
		return 
	end
	
	var_5_0:focus(arg_5_2, arg_5_3)
	
	return var_5_0:getPosition(arg_5_3)
end

function PetAniDirector.test(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0.vars.pet_anis[1]
	
	if not var_6_0 then
		return 
	end
	
	var_6_0:test(arg_6_1, arg_6_2)
end

function PetAniDirector.showTestText(arg_7_0)
	for iter_7_0, iter_7_1 in pairs(arg_7_0.vars.pet_anis) do
		iter_7_1:showTestText()
	end
end

function PetAniDirector.getBoundingBox(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.vars.pet_anis[arg_8_1]
	
	if not var_8_0 then
		return 
	end
	
	return var_8_0:getBoundingBox()
end

function PetAniDirector.focusOut(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0.vars.pet_anis[arg_9_1]
	
	if not var_9_0 then
		return 
	end
	
	var_9_0:deFocus(arg_9_2)
end

function PetAniDirector.setAmbientColor(arg_10_0, arg_10_1)
	arg_10_0.vars.ambient_color = arg_10_1
	
	for iter_10_0, iter_10_1 in pairs(arg_10_0.vars.pet_anis) do
		iter_10_1:setAmbientColor(arg_10_1)
	end
end

function PetAniDirector.pause(arg_11_0)
	for iter_11_0, iter_11_1 in pairs(arg_11_0.vars.pet_anis) do
		iter_11_1:pause()
		iter_11_1:setVisible(false)
	end
end

function PetAniDirector.resume(arg_12_0)
	for iter_12_0, iter_12_1 in pairs(arg_12_0.vars.pet_anis) do
		iter_12_1:resume()
		iter_12_1:setVisible(true)
	end
end

function PetAniDirector.remove(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0.vars.pet_anis[arg_13_1]
	
	if not var_13_0 then
		return 
	end
	
	var_13_0:remove()
	
	arg_13_0.vars.pet_anis[arg_13_1] = nil
end
