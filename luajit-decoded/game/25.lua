FORMULA = {}
FORMULA.List = {}
FORMULA.mainStat = {}
FORMULA.subStat = {}

function FORMULA.List.max_hp(arg_1_0, arg_1_1, arg_1_2)
	return (50 + arg_1_1.int * 1.4) * (arg_1_2.lv / 3 + 1) * (1 + (arg_1_2.grade - 1) * 0.075)
end

function FORMULA.List.att(arg_2_0, arg_2_1, arg_2_2)
	return arg_2_1.bra * 0.6 * (arg_2_2.lv / 6 + 1) * (1 + (arg_2_2.grade - 1) * 0.075)
end

function FORMULA.List.bonus_att(arg_3_0, arg_3_1, arg_3_2)
	return 0
end

function FORMULA.List.def(arg_4_0, arg_4_1, arg_4_2)
	return (30 + arg_4_1.fai * 0.3) * (arg_4_2.lv / 8 + 1) * (1 + (arg_4_2.grade - 1) * 0.075)
end

function FORMULA.List.con(arg_5_0, arg_5_1, arg_5_2)
	return 1
end

function FORMULA.List.dodge(arg_6_0, arg_6_1, arg_6_2)
	return 0
end

function FORMULA.List.cri(arg_7_0, arg_7_1, arg_7_2)
	return 0.15
end

function FORMULA.List.cri_res(arg_8_0, arg_8_1, arg_8_2)
	return 0
end

function FORMULA.List.speed(arg_9_0, arg_9_1, arg_9_2)
	return 60 + arg_9_1.des / 1.6
end

function FORMULA.List.res(arg_10_0, arg_10_1, arg_10_2)
	return 0
end

function FORMULA.List.power_max_hp(arg_11_0, arg_11_1, arg_11_2)
	return arg_11_0.max_hp + arg_11_0.max_hp * arg_11_2.lv * 0.025 + arg_11_0.max_hp * arg_11_2.power * 0.05
end

function FORMULA.List.power_att(arg_12_0, arg_12_1, arg_12_2)
	return arg_12_0.att + arg_12_0.att * arg_12_2.lv * 0.08 + arg_12_0.att * arg_12_2.power * 0.05
end

function FORMULA.List.power_def(arg_13_0, arg_13_1, arg_13_2)
	return arg_13_0.def + arg_13_0.def * arg_13_2.lv * 0.01 + arg_13_0.def * arg_13_2.power * 0.05
end

function FORMULA.List.power_speed(arg_14_0, arg_14_1, arg_14_2)
	return arg_14_0.speed + arg_14_0.speed * (arg_14_2.lv - 40) * 0.004 * arg_14_2.power
end

function FORMULA.List.power_cri(arg_15_0, arg_15_1, arg_15_2)
	return arg_15_0.cri + arg_15_0.cri * arg_15_2.lv * 0.01 + arg_15_0.cri * arg_15_2.power * 0.05
end

function FORMULA.List.power_res(arg_16_0, arg_16_1, arg_16_2)
	return arg_16_0.res + arg_16_0.res * arg_16_2.lv * 0.01 + arg_16_0.res * arg_16_2.power * 0.05
end

function FORMULA.List.cri_dmg(arg_17_0, arg_17_1, arg_17_2)
	return 1.5
end

function FORMULA.List.pen(arg_18_0, arg_18_1, arg_18_2)
	return 0
end

function FORMULA.List.smite(arg_19_0, arg_19_1, arg_19_2)
	return 0.3
end

function FORMULA.List.smite_dmg(arg_20_0, arg_20_1, arg_20_2)
	return 1.3
end

function FORMULA.List.stun(arg_21_0, arg_21_1, arg_21_2)
	return 2
end

function FORMULA.List.redu(arg_22_0, arg_22_1, arg_22_2)
	return 0
end

function FORMULA.List.acc(arg_23_0, arg_23_1, arg_23_2)
	return 0
end

function FORMULA.List.coop(arg_24_0, arg_24_1, arg_24_2)
	return 0.03
end

function FORMULA.hit(arg_25_0, arg_25_1)
	return arg_25_0.con - arg_25_1.dodge
end

function FORMULA.dmg(arg_26_0, arg_26_1)
	return math.floor((arg_26_0.att + arg_26_0.bonus_att) * 2 * 980 / (1050 + 3.5 * arg_26_1.def))
end

function FORMULA.weak_dodge_rate(arg_27_0, arg_27_1)
	return 0.5
end

function FORMULA.weak_cri_rate(arg_28_0, arg_28_1)
	return 0.15
end

function FORMULA.weak_smite_rate(arg_29_0, arg_29_1)
	return 0.5
end

function FORMULA.weak_inc_dmg(arg_30_0, arg_30_1)
	return 1.1
end

function FORMULA.weak_dec_dmg(arg_31_0, arg_31_1)
	return 1
end

function FORMULA.apply(arg_32_0, arg_32_1)
	return 1 - arg_32_1.res + arg_32_0.acc
end

function FORMULA.calcStatus(arg_33_0, arg_33_1)
	local var_33_0 = {}
	
	var_33_0.max_hp = FORMULA.List.max_hp(var_33_0, arg_33_0, arg_33_1)
	var_33_0.att = FORMULA.List.att(var_33_0, arg_33_0, arg_33_1)
	var_33_0.bonus_att = FORMULA.List.bonus_att(var_33_0, arg_33_0, arg_33_1)
	var_33_0.def = FORMULA.List.def(var_33_0, arg_33_0, arg_33_1)
	var_33_0.con = FORMULA.List.con(var_33_0, arg_33_0, arg_33_1)
	var_33_0.dodge = FORMULA.List.dodge(var_33_0, arg_33_0, arg_33_1)
	var_33_0.cri = FORMULA.List.cri(var_33_0, arg_33_0, arg_33_1)
	var_33_0.cri_res = FORMULA.List.cri_res(var_33_0, arg_33_0, arg_33_1)
	var_33_0.speed = FORMULA.List.speed(var_33_0, arg_33_0, arg_33_1)
	var_33_0.res = FORMULA.List.res(var_33_0, arg_33_0, arg_33_1)
	var_33_0.power_max_hp = FORMULA.List.power_max_hp(var_33_0, arg_33_0, arg_33_1)
	var_33_0.power_att = FORMULA.List.power_att(var_33_0, arg_33_0, arg_33_1)
	var_33_0.power_def = FORMULA.List.power_def(var_33_0, arg_33_0, arg_33_1)
	var_33_0.power_speed = FORMULA.List.power_speed(var_33_0, arg_33_0, arg_33_1)
	var_33_0.power_cri = FORMULA.List.power_cri(var_33_0, arg_33_0, arg_33_1)
	var_33_0.power_res = FORMULA.List.power_res(var_33_0, arg_33_0, arg_33_1)
	var_33_0.cri_dmg = FORMULA.List.cri_dmg(var_33_0, arg_33_0, arg_33_1)
	var_33_0.pen = FORMULA.List.pen(var_33_0, arg_33_0, arg_33_1)
	var_33_0.smite = FORMULA.List.smite(var_33_0, arg_33_0, arg_33_1)
	var_33_0.smite_dmg = FORMULA.List.smite_dmg(var_33_0, arg_33_0, arg_33_1)
	var_33_0.stun = FORMULA.List.stun(var_33_0, arg_33_0, arg_33_1)
	var_33_0.redu = FORMULA.List.redu(var_33_0, arg_33_0, arg_33_1)
	var_33_0.acc = FORMULA.List.acc(var_33_0, arg_33_0, arg_33_1)
	var_33_0.coop = FORMULA.List.coop(var_33_0, arg_33_0, arg_33_1)
	
	return FORMULA.clampStatus(FORMULA.normalizeStatus(var_33_0))
end

function FORMULA.normalizeStatus(arg_34_0)
	arg_34_0.max_hp = math.floor(arg_34_0.max_hp)
	arg_34_0.att = math.floor(arg_34_0.att)
	arg_34_0.bonus_att = math.floor(arg_34_0.bonus_att)
	arg_34_0.def = math.floor(arg_34_0.def)
	arg_34_0.speed = math.floor(arg_34_0.speed)
	arg_34_0.power_max_hp = math.floor(arg_34_0.power_max_hp)
	arg_34_0.power_att = math.floor(arg_34_0.power_att)
	arg_34_0.power_def = math.floor(arg_34_0.power_def)
	arg_34_0.power_speed = math.floor(arg_34_0.power_speed)
	arg_34_0.stun = math.floor(arg_34_0.stun)
	
	return arg_34_0
end

function FORMULA.clampStatus(arg_35_0)
	arg_35_0.max_hp = math.max(1, arg_35_0.max_hp)
	arg_35_0.att = math.max(1, arg_35_0.att)
	arg_35_0.def = math.max(0, arg_35_0.def)
	arg_35_0.con = math.max(0, arg_35_0.con)
	arg_35_0.dodge = math.max(0, arg_35_0.dodge)
	arg_35_0.cri = math.min(1, math.max(0, arg_35_0.cri))
	arg_35_0.cri_res = math.min(1, math.max(-1, arg_35_0.cri_res))
	arg_35_0.speed = math.max(1, arg_35_0.speed)
	arg_35_0.res = math.max(0, arg_35_0.res)
	arg_35_0.power_max_hp = math.max(1, arg_35_0.power_max_hp)
	arg_35_0.power_att = math.max(1, arg_35_0.power_att)
	arg_35_0.power_def = math.max(0, arg_35_0.power_def)
	arg_35_0.power_speed = math.max(1, arg_35_0.power_speed)
	arg_35_0.power_cri = math.max(0, arg_35_0.power_cri)
	arg_35_0.power_res = math.max(0, arg_35_0.power_res)
	arg_35_0.cri_dmg = math.min(3.5, math.max(0, arg_35_0.cri_dmg))
	arg_35_0.coop = math.min(0.3, math.max(0, arg_35_0.coop))
	
	return arg_35_0
end

local var_0_0 = {}

var_0_0.cri = 1
var_0_0.cri_res = 1
var_0_0.cri_dmg = 3.5
var_0_0.coop = 0.3

function FORMULA.getStatLimit(arg_36_0)
	if not arg_36_0 then
		return nil
	end
	
	return var_0_0[arg_36_0]
end

function FORMULA.isMoreThanStatLimit(arg_37_0, arg_37_1)
	if not arg_37_0 or not arg_37_1 then
		return false
	end
	
	if FORMULA.getStatLimit(arg_37_0) and arg_37_1 >= FORMULA.getStatLimit(arg_37_0) then
		return true
	end
	
	return false
end

function FORMULA.calcOverStatus(arg_38_0)
	local var_38_0 = {}
	
	for iter_38_0, iter_38_1 in pairs(arg_38_0) do
		if FORMULA.getStatLimit(iter_38_0) then
			iter_38_1 = round(iter_38_1, 3)
			
			local var_38_1 = round(FORMULA.getStatLimit(iter_38_0), 3)
			
			if var_38_1 < iter_38_1 then
				var_38_0[iter_38_0] = iter_38_1 - var_38_1
			end
		end
	end
	
	return var_38_0
end
