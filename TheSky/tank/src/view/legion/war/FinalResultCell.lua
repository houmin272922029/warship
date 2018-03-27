--[[
	赛果cell
	Author: H.X.Sun
]]

local FinalResultCell = qy.class("FinalResultCell", qy.tank.view.BaseView, "legion_war/ui/FinalResultCell")

local userModel = qy.tank.model.UserInfoModel
local service = qy.tank.service.LegionWarService
local NumberUtil = qy.tank.utils.NumberUtil

function FinalResultCell:ctor(params)
    FinalResultCell.super.ctor(self)
    self.model = qy.tank.model.LegionWarModel
    local command = qy.tank.command.LegionCommand
    local moduleType = qy.tank.view.type.ModuleType
    self.params = params

    self:InjectView("btn")
    self:InjectView("open_time")
    for i = 1, 6 do
        self:InjectView("legion_"..i)
        self:InjectView("img_"..i)
        self["img_"..i]:setVisible(false)
        if i < 4 then
            self:InjectView("cell_"..i)
            self:InjectView("title_"..i)
        end
    end
    self:OnClick("btn",function()
        if self.war_key then
            command:viewRedirectByModuleType(moduleType.WAR_GROUP,{["war_key"] = self.war_key,["callback"] = function()
                self:breatheAnim(self.btn,false)
            end})
        else
            qy.hint:show(qy.TextUtil:substitute(53003))
        end
    end)
    self.hasSendMsg = false
    -- self:update()
end

function FinalResultCell:breatheAnim(ui,isPlay)
    if isPlay then
        local scaleSmall = cc.ScaleTo:create(1.2,0.9)
        local scaleBig = cc.ScaleTo:create(1.2,1)
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

function FinalResultCell:dealEnterBtn(att_lid,def_lid)
    if tonumber(att_lid) and tonumber(def_lid) then
        if tonumber(att_lid) > 0 and tonumber(def_lid) > 0 then
            self.war_key = att_lid .. "-" .. def_lid
            self.btn:setVisible(true)
            return
        end
    end
    self.war_key = nil
    self.btn:setVisible(false)
end

function FinalResultCell:dealWinTip(data,index)
    if data then
        self["img_"..(index*2-1)]:setVisible(true)
        self["img_"..(index*2)]:setVisible(true)
        if data.is_win == 1 then
            self["img_"..(index*2-1)]:setSpriteFrame("legion_war/res/shengli.png")
            self["img_"..(index*2)]:setSpriteFrame("legion_war/res/shibai.png")
        else
            self["img_"..(index*2-1)]:setSpriteFrame("legion_war/res/shibai.png")
            self["img_"..(index*2)]:setSpriteFrame("legion_war/res/shengli.png")
        end
    else
        self["img_"..(index*2-1)]:setVisible(false)
        self["img_"..(index*2)]:setVisible(false)
    end
end

function FinalResultCell:update()
    self._finalStage = self.model:getStageForFinal()
    local data
    for i = 1, 3 do
        if i <= self._finalStage then
            data = self.model:getMyFinalResultData(i)
            if data then
                self["cell_"..i]:setVisible(true)
                self:updateLegionName(i*2-1,data.att_legion_name)
                self:updateLegionName(i*2,data.def_legion_name)
                if i == self._finalStage then
                    self:dealEnterBtn(data.att_legion_id,data.def_legion_id)
                end
                if i == 3 then
                    if data.sIndex == 1 then
                        self.title_3:setString(qy.TextUtil:substitute(53004))
                    else
                        self.title_3:setString(qy.TextUtil:substitute(53005))
                    end
                end
            else
                self["cell_"..i]:setVisible(false)
                self:dealEnterBtn()
            end
            self:dealWinTip(data,i)
        else
            self["cell_"..i]:setVisible(false)
        end
    end
end

function FinalResultCell:updateLegionName(_idx,value)
    if value == "" then
        value = qy.TextUtil:substitute(53006)
    end
    self["legion_".._idx]:setString(value)
end

function FinalResultCell:updateTime()
    local time = self.model:getOpenTime() - userModel.serverTime
    if time < 0 then
        self.open_time:setString(qy.TextUtil:substitute(53007))
        if not self.hasSendMsg then
            self.hasSendMsg = true
            service:get(false,function()
                self.hasSendMsg = false
                if self.model:getLegionWarInfoEntity():getGameAction() == self.model.ACTION_PLAY then
                    self:update()
                    self:breatheAnim(self.btn,true)
                    if self.params and self.params.updateTitle then
                        self.params.updateTitle()
                    end
                    self:dealWinTip(nil,self._finalStage)
                elseif self.params and self.params.callback then
                    self.params.callback()
                end
            end)
        end
    else
        if self._finalStage == 3 then
            self.open_time:setString(qy.TextUtil:substitute(53008, NumberUtil.secondsToTimeStr(time, 2)))
        else
            self.open_time:setString(qy.TextUtil:substitute(53009, NumberUtil.secondsToTimeStr(time, 2)))
        end
    end
end

function FinalResultCell:onEnter()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("legion_war/res/legion_war.plist")
    self:update()
    self.timeListener = qy.Event.add(qy.Runtime.TIMER_UPDATE,function(event)
        self:updateTime()
    end)
end

function FinalResultCell:onExit()
    qy.Event.remove(self.timeListener)
	self.timeListener = nil
end

return FinalResultCell
