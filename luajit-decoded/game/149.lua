DungeonExpedition = {}

function DungeonExpedition.create(arg_1_0, arg_1_1)
	if arg_1_0.vars and get_cocos_refid(arg_1_0.vars.layer) then
		arg_1_0:release()
	end
	
	arg_1_0.vars = {}
	arg_1_0.vars.layer = cc.Layer:create()
	arg_1_0.vars.bg = SpriteCache:getSprite("map/dungeon_expedition_bg.png")
	
	arg_1_0.vars.bg:setAnchorPoint(0.5, 0.5)
	arg_1_0.vars.bg:setPosition(100, 0)
	arg_1_0.vars.layer:addChild(arg_1_0.vars.bg)
	
	arg_1_0.vars.parent_wnd = arg_1_1
	
	arg_1_0:initUI()
	
	return arg_1_0.vars.layer
end

function DungeonExpedition.initUI(arg_2_0)
end

function DungeonExpedition.CheckNotification(arg_3_0)
	return CoopUtil:isShowBattleMenuRedDot()
end

function DungeonExpedition.release(arg_4_0)
	if arg_4_0.vars and get_cocos_refid(arg_4_0.vars.layer) then
		arg_4_0.vars.layer:removeFromParent()
		
		arg_4_0.vars = nil
	end
end
