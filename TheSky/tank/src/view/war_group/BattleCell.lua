--[[
	群战-战斗列表-战斗阵型
	Author: H.X.Sun
]]

local BattleCell = qy.class("BattleCell", qy.tank.view.BaseView, "war_group/ui/BattleCell")

local T_1 = 0.3
local T_2 = 0.2
local T_3 = 0.2
local T_4 = 0.3
local ENTER_TIME = 0.5
local WAIT_TIME = 0.1

local GarageModel = qy.tank.model.GarageModel
local userModel = qy.tank.model.UserInfoModel
local GroupWarManager = qy.tank.manager.GroupWarManager

function BattleCell:ctor(params)
    BattleCell.super.ctor(self)
    self:InjectView("name_txt")
    self:InjectView("tank_node")
    self:InjectView("bar_bg")
    self:InjectView("bar_frame")
    self:InjectView("me_tip")
    self:InjectView("name_txt")
    self:InjectView("win_txt")
    self:InjectView("container")
    self.container:setPosition(params.enter_width,0)
    self.container:setVisible(false)
    self.win_txt:setString("")
    for i = 1, 6 do
        self:InjectView("tank_"..i)
    end

    self.bar_frame:setLocalZOrder(5)
    self.bar = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("war_group/res/b_5.png"))
    self.bar:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.bar:setMidpoint(cc.p(0,0))
    self.bar:setBarChangeRate(cc.p(1, 0))
    self.bar:setScaleX(2.5)
    self.bar:setPosition(102,10.5)
    self.bar_bg:addChild(self.bar)
    self.bar:setPercentage(100)

    self.model = qy.tank.model.WarGroupModel
    if params.view == 1 then
        self.tank_node:setFlippedX(true)
    end
    self.moveDis = params.moveDis
    self.showEffert = params.showEffert
    self.effertW = params.effertW
    self.enter_width = params.enter_width
end

--普通进场
function BattleCell:showBattle(data,prefix)
    self.data = data
    self.track = data.track
    self._prefix = prefix
    self:reset(data.battle_data,function()
        self:battleAnim()
    end)
end

function BattleCell:dealEnd(data,isWin)
    local function hideTank()
        self.container:runAction(cc.Sequence:create(cc.DelayTime:create(0.4),cc.CallFunc:create(function()
            self.container:setVisible(false)
            self.container:setPosition(self.enter_width,0)
        end)))
    end

    if isWin then
        if self.model:getWinMax() == data[self._prefix .. "_win_times"] then
            self.model:setUserFormation(self._prefix,self.track,0)
            self.model:removeFromMemberList(self._prefix,data[self._prefix .. "_kid"])
            self.win_txt:setString(data[self._prefix .. "_win_times"] ..qy.TextUtil:substitute(64001))
            hideTank()
        else
            self.model:setUserFormation(self._prefix,self.track,data[self._prefix .. "_kid"])
            self.win_txt:setString(data[self._prefix .. "_win_times"] ..qy.TextUtil:substitute(64002))
        end
    else
        self.model:removeFromMemberList(self._prefix,data[self._prefix .. "_kid"])
        hideTank()
        self.model:setUserFormation(self._prefix,self.track,0)
    end
end

function BattleCell:battleAnim()
    local battle_data = self.data.battle_data
    local round = #battle_data.fight_data.fight - self.model:getTrackRound(self.track) + 1
    local function proFunc()
        local blood_per = battle_data.fight_data.fight[round][self._prefix .. "_blood"] / battle_data.fight_data[self._prefix .. "_max_blood"] * 100
        local to = cc.ProgressTo:create(T_3+T_2,blood_per)
        local seq2 = cc.Sequence:create(to,cc.CallFunc:create(function()
            if self.model:getTrackRound(self.track) > 1 then
                -- 没到最后一轮
                local dis_blood = battle_data.fight_data.fight[round][self._prefix .. "_hurt"]
                self.win_txt:setString("-"..dis_blood)
            else
                --最后一轮
                if self._prefix == self.model.LEFT_KEY then
                    if battle_data.is_win == 1 then
                        -- 左边战斗胜利
                        self:dealEnd(battle_data,true)
                    else
                        -- 左边战斗失败 -- 从列表移除
                        self:dealEnd(battle_data,false)
                    end
                elseif self._prefix == self.model.RIGHT_KEY then
                    if battle_data.is_win == 0 then
                        -- 右边战斗胜利
                        self:dealEnd(battle_data,true)
                    else
                        self:dealEnd(battle_data,false)
                    end
                end
            end
            self.win_txt:runAction(cc.Sequence:create(cc.MoveBy:create(0.5,cc.p(0,40))))
        end),cc.DelayTime:create(0.6),cc.CallFunc:create(function()
            self:dealDeathTank(battle_data.fight_data.fight[round][self._prefix .. "_die"])
            self.win_txt:setPosition(137,69)
            self.win_txt:setString("")
            if self._prefix == self.model.RIGHT_KEY then
                print("GroupWarManager:next(self.track)====>>>>",self.track)
                GroupWarManager:next(self.track)
            end
        end))
        self.bar:runAction(seq2)
    end

    local move1 = cc.MoveBy:create(T_1,cc.p(self.moveDis,0))
    local move2 = cc.MoveBy:create(T_2,cc.p(-self.moveDis,0))
    local move3 = cc.MoveBy:create(T_3,cc.p(self.moveDis,0))
    local move4 = cc.MoveBy:create(T_4,cc.p(-self.moveDis,0))
    local func = cc.CallFunc:create(function()
        if self.showEffert then
            if self.effertArr == nil then
                self.effertArr = ccs.Armature:create("ui_fx_warboom")
                self.effertArr:setPosition(self.effertW,100)
                self:addChild(self.effertArr,999)
            end

            self.effertArr:getAnimation():playWithIndex(0)
        end
        proFunc()
    end)
    local spawn = cc.Spawn:create(move1,func)
    local seq = cc.Sequence:create(cc.DelayTime:create(WAIT_TIME),move1,move2,spawn,move2)
    self.tank_node:runAction(seq)
end

function BattleCell:dealDeathTank(data)
    local index
    for i = 1, #data do
        index = data[i].pos
        self["tank_"..index]:setTexture("Resources/common/bg/c_12.png")
    end
end

function BattleCell:reset(data,callback)
    if data then
        self.container:setVisible(true)
        if userModel.userInfoEntity.kid == data[self._prefix .. "_kid"] then
            self.me_tip:setVisible(true)
            self.name_txt:setTextColor(cc.c4b(2, 204, 253, 255))
        else
            self.name_txt:setTextColor(cc.c4b(255, 255, 255, 255))
            self.me_tip:setVisible(false)
        end
        self.tank_node:setPosition(137,95)
        self.name_txt:setString(data[self._prefix .. "_name"])

        local blood_per = data[self._prefix .. "_blood"] / data.fight_data[self._prefix .. "_max_blood"] * 100
        self.bar:setPercentage(blood_per)
        self.win_txt:setString("")
        local tank_id,icon
        if self.last_kid == nil or self.last_kid ~= data[self._prefix .. "_kid"] then
            self.last_kid = data[self._prefix .. "_kid"]
            for i = 1, 6 do
                tank_id = data[self._prefix .. "_tank"][tostring(i)]
                if tank_id == nil or tank_id == 0 then
                    icon = "Resources/common/bg/c_11.png"
                else
                    icon = GarageModel:getLittleIconByTankId(tank_id)
                end
                self["tank_"..i]:setTexture(icon)
            end
        end
        local move = cc.MoveTo:create(ENTER_TIME,cc.p(0,0))
        self.container:runAction(cc.Sequence:create(cc.Sequence:create(move, cc.CallFunc:create(function()
            if callback then
                callback()
            end
        end))))
    else
        self.container:setVisible(false)
    end

end


return BattleCell
