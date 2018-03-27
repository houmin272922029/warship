--[[
	观看比赛cell
	Author: H.X.Sun
]]

local WatchCell = qy.class("WatchCell", qy.tank.view.BaseView, "legion_war/ui/WatchCell")

local model = qy.tank.model.LegionWarModel

function WatchCell:ctor(params)
    WatchCell.super.ctor(self)
    self:InjectView("title")
    self:InjectView("bg")
    local service = qy.tank.service.LegionWarService
    local command = qy.tank.command.LegionCommand
    local moduleType = qy.tank.view.type.ModuleType
    local userModel = qy.tank.model.UserInfoModel

    local combat_list = {}

    for i = 1, 12 do
        --军团名 12个
        self:InjectView("legion_"..i)
        self["legion_"..i]:setString("")
        --线 6条
        if i < 7 then
            self:InjectView("line_"..i)
            self["line_"..i]:setVisible(false)
        end
        --输赢角标 10个
        if i < 11 then
            self:InjectView("angle_"..i)
            self["angle_"..i]:setTexture("Resources/common/bg/c_12.png")
        end

        --查看战报按钮 8个
        if i < 9 then
            self:InjectView("watch_btn_"..i)
            self["watch_btn_"..i]:setVisible(false)
        end
        --排名tip 4个
        if i < 5 then
            self:InjectView("rank_tip_"..i)
            self["rank_tip_"..i]:setVisible(false)
        end
    end

    self.final_stage = model:getStageForFinal() or 1
    self.title:setSpriteFrame("legion_war/res/b"..self.final_stage..".png")

    self.watchCombatData = model:getWatchCombatData()
    local data
    if self.watchCombatData then
        data = self.watchCombatData.legion_list
        for i = 1, #data do
            self["legion_"..i]:setString(data[i])
        end

        self.combat_list = self.watchCombatData.combat_list

        data = self.watchCombatData.angle_list
        for i = 1, #data do
            self:showAngle(i, data[i])
        end

        data = self.watchCombatData.crown_list
        for i = 1, #data do
            self["rank_tip_"..i]:setVisible(data[i])
        end
    end

    for i = 1, 8 do
        self:OnClick("watch_btn_" ..i,function()
            if self.combat_list[tostring(i)] then
                command:viewRedirectByModuleType(moduleType.WAR_GROUP,{["war_key"] = self.combat_list[tostring(i)]})
            else
                qy.hint:show(qy.TextUtil:substitute(53040))
            end
        end)
    end
end

function WatchCell:showAngle(_idx, _status)
    if _status == 1 then
        self["angle_".._idx]:setSpriteFrame("legion_war/res/shengli.png")
    else
        self["angle_".._idx]:setSpriteFrame("legion_war/res/shibai.png")
    end
end

function WatchCell:showAmin()
    if self.final_stage == 1 then
        for i = 1, 4 do
            if self.combat_list[tostring(i)] then
                self["watch_btn_"..i]:setVisible(true)
                self:breatheAnim(self["watch_btn_"..i],true)
            end
        end

    elseif self.final_stage == 2 then
        for i = 1, 6 do
            if self.combat_list[tostring(i)] then
                self["watch_btn_"..i]:setVisible(true)
                if i > 4 then
                    self:breatheAnim(self["watch_btn_"..i],true)
                end
            end
        end
        for i = 1, 6 do
            self["line_"..i]:setVisible(true)
        end
    else
        for i = 1, 8 do
            if self.combat_list[tostring(i)] then
                self["watch_btn_"..i]:setVisible(true)
                if i > 6 and model:getLastTab() == 1 then
                    self:breatheAnim(self["watch_btn_"..i],true)
                end
            end
        end
        for i = 1, 6 do
            self["line_"..i]:setVisible(true)
        end
    end
end

function WatchCell:breatheAnim(ui,isPlay)
    if isPlay then
        local scaleSmall = cc.ScaleTo:create(1.2,1)
        local scaleBig = cc.ScaleTo:create(1.2,1.2)
        local FadeIn = cc.FadeTo:create(1.2, 255)
        local FadeOut = cc.FadeTo:create(1.2, 200)
        local spawn1 = cc.Spawn:create(scaleSmall,FadeOut)
        local spawn2 = cc.Spawn:create(scaleBig,FadeIn)
        local seq = cc.Sequence:create(spawn1, spawn2)
        ui:runAction(cc.RepeatForever:create(seq))
    else
        ui:stopAllActions()
        ui:setScale(1)
        ui:setOpacity(255)
    end
end

function WatchCell:onEnter()
    self:showAmin()
end

return WatchCell
