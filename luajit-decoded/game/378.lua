UnitBistro = {}

function UnitBistro.onPushBackButton(arg_1_0)
	UnitMain:setMode("Main")
end

function UnitBistro.create(arg_2_0)
end

function UnitBistro.onEnter(arg_3_0, arg_3_1, arg_3_2)
	Bistro:show(UnitMain.vars.base_wnd, {
		herobelt = UnitMain.vars.unit_dock.wnd
	})
end

function UnitBistro.onLeave(arg_4_0, arg_4_1)
	print(arg_4_1)
	Bistro:close()
end
