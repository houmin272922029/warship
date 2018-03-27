--[[
	群战-战斗
	Author: H.X.Sun
]]

local BattleView = qy.class("BattleView", qy.tank.view.BaseView, "war_group/ui/BattleView")
-- local MOVE_W = qy.winSize.width/2-550
local MOVE_W = -20
local ENTER_W = 250

function BattleView:ctor(delegate)
    print("MOVE_W====>>>",MOVE_W)
    BattleView.super.ctor(self)
    self:InjectView("left_node")
    self:InjectView("right_node")
    self:InjectView("btn")
    self:InjectView("bg")
    self.btn:setLocalZOrder(10)

    self:OnClick("btn",function()
        delegate.dismiss()
    end)

    self.delegate = delegate
    self.model = qy.tank.model.WarGroupModel

    if self.model:getBattleType() == self.model.BATTLE_GROUP_BATTLES then
        -- 多人副本
        self.bg:setTexture("war_group/res/bg_2.jpg")
        self.btn:setVisible(false)
    elseif self.model:getBattleType() == self.model.BATTLE_ATTACKBERLIN then
        self.bg:setTexture("war_group/res/bg_2.jpg")
        self.btn:setVisible(true)
    else
        -- 军团战
        self.bg:setTexture("war_group/res/bg_1.jpg")
        self.btn:setVisible(true)
    end
end

function BattleView:onEnter()
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileByModules("war_group/fx/ui_fx_warboom")

    if self.attFormation == nil then
        self.attFormation = {}
        for i = 1, 3 do
            self.attFormation[i] = qy.tank.view.war_group.BattleCell.new({
                ["view"]=1,
                ["moveDis"] = MOVE_W,
                ["showEffert"] = true,
                ["effertW"] = qy.winSize.width/2-270,
                ["enter_width"] = -ENTER_W,
            })
            self.attFormation[i]:setPosition(270,650-208*i)
            self.left_node:addChild(self.attFormation[i])
        end
    end

    if self.defFormation == nil then
        self.defFormation = {}
        for i = 1, 3 do
            self.defFormation[i] = qy.tank.view.war_group.BattleCell.new({
                ["view"]=2,
                ["moveDis"] = -MOVE_W,
                ["showEffert"] = false,
                ["enter_width"] = ENTER_W,
            })
            self.defFormation[i]:setPosition(-544,650-208*i)
            self.right_node:addChild(self.defFormation[i])
        end
    end

    if not tolua.cast(self.leftList,"cc.Node") then
        self.leftList = qy.tank.view.war_group.BattleList.new({["_prefix"] = self.model.LEFT_KEY})
        self.leftList:setPosition(10,81)
        self.left_node:addChild(self.leftList)
    end

    if not tolua.cast(self.rightList,"cc.Node") then
        self.rightList = qy.tank.view.war_group.BattleList.new({["_prefix"] = self.model.RIGHT_KEY})
        self.rightList:setPosition(-287,81)
        self.right_node:addChild(self.rightList)
    end

    qy.tank.manager.GroupWarManager:start(self)
    self.nextListener = qy.Event.add(qy.Event.WAR_GROUP_FIELD,function(event)
        qy.tank.manager.GroupWarManager:start(self)
    end)
    self.endListener = qy.Event.add(qy.Event.WAR_GROUP_END,function(event)
        qy.tank.view.war_group.BattleResultDialog.new({
            ["callback"] = self.delegate.dismiss,
            ["name"] = self.model.win_legion_name,
        }):show(true)
    end)
end

function BattleView:exchangePosition(data)
    local pos_x = 0
    if self.model.LEFT_KEY == data.prefix then
        pos_x = 270
    else
        pos_x = -544
    end

    self[data.prefix.."Formation"][data.track]:setPosition(pos_x,650-208*data.last_track)
    local temp = self[data.prefix.."Formation"][data.track]
    self[data.prefix.."Formation"][data.track] = self[data.prefix.."Formation"][data.last_track]
    self[data.prefix.."Formation"][data.last_track] = temp


    local move1 = cc.MoveBy:create(0.3,cc.p(0,-208*(data.track - data.last_track)))
    local seq = cc.Sequence:create(move1,cc.CallFunc:create(function()
        self:showBattle(data)
    end))
    self[data.prefix.."Formation"][data.track]:runAction(seq)
end

function BattleView:showBattle(data)
    self.attFormation[data.track]:showBattle(data,self.model.LEFT_KEY)
    self.defFormation[data.track]:showBattle(data,self.model.RIGHT_KEY)
end

function BattleView:updateMemberList()
    self.leftList:update()
    self.rightList:update()
end

function BattleView:play(data)
    if data.has_Move then
        self:exchangePosition(data)
    else
        self:showBattle(data)
    end
end

function BattleView:playNextRound(track)
    self.attFormation[track]:battleAnim()
    self.defFormation[track]:battleAnim()
end

function BattleView:next(index)
    self.leftList:update()
    self.rightList:update()

    local _data = self.model:getBattleDataByIndex(index)
    if _data then
        self:play(_data,index)
    end
end


function BattleView:onExit()
    qy.Event.remove(self.nextListener)
    qy.Event.remove(self.endListener)
	self.nextListener = nil
    self.endListener = nil
    qy.tank.utils.cache.CachePoolUtil.removeArmatureFileByModules("war_group/fx/ui_fx_warboom")
end

return BattleView
