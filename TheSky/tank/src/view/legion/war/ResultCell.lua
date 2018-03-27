--[[
	赛果cell
	Author: H.X.Sun
]]

local ResultCell = qy.class("ResultCell", qy.tank.view.BaseView, "legion_war/ui/ResultCell")

local userModel = qy.tank.model.UserInfoModel
local NumberUtil = qy.tank.utils.NumberUtil

function ResultCell:ctor(params)
    ResultCell.super.ctor(self)
    self:InjectView("title_txt")
    self:InjectView("cell_1")
    self:InjectView("cell_2")
    self:InjectView("vs_icon")
    self:InjectView("tip_txt")
    self:InjectView("light")
    self:InjectView("left_me_tip")
    self:InjectView("right_me_tip")

    self.model = qy.tank.model.LegionWarModel
    self.infoEntity = self.model:getLegionWarInfoEntity()
    local service = qy.tank.service.LegionWarService

    local cell_width
    local userPosX = {}
    if self.model:getLastTab() == 1 then
        cell_width = 624
        userPosX[1] = -250
        userPosX[2] = 108
        -- self.tip_txt:setVisible(false)
    else
        userPosX[1] = -360
        userPosX[2] = 218
        cell_width = 956
        -- self.tip_txt:setVisible(true)
    end
    self.right_me_tip:setPosition(cell_width,104.5)
    self.tip_txt:setString("")
    self.cell_2:setContentSize(cc.size(cell_width,150))
    self.cell_1:setContentSize(cc.size(cell_width,94))
    self.light:setContentSize(cc.size(cell_width,94))
    self.vs_icon:setPosition(cell_width/2,88)
    self.title_txt:setPosition(cell_width/2,47)
    --255
    self.userArr = {}
    for i = 1, 2 do
        self.userArr[i] = qy.tank.view.legion.war.UserCell.new({["i"] = i})
        self.vs_icon:addChild(self.userArr[i])
        self.userArr[i]:setPosition(userPosX[i], -35)
    end

    self:OnClick("watch_btn",function()
        service:showCombat(self.combat_id,function()
            qy.tank.manager.ScenesManager:pushBattleScene()
        end)
    end)
end

function ResultCell:render(_idx)
    local data = self.model:getResultDataByIdx(_idx)
    self.idx = _idx
    print("data.has_title====>>>",data.has_title)

    if data.has_title then
        self.cell_1:setVisible(true)
        self.cell_2:setVisible(false)
        self.title_txt:setString(self.model:getCombatTitle() .. data.title)
        if self.model:getLastTab() == 2 then
            self.tip_txt:setString(data.content)
        else
            self.tip_txt:setString("")
        end
    else
        self.cell_1:setVisible(false)
        self.cell_2:setVisible(true)
        self:isMyResult(data.att_kid,data.def_kid)

        self.combat_id = data.combat_id
        --攻击方
        self.userArr[1]:render({
            ["name"] = data.att_name,
            ["kid"] = data.att_kid,
            ["legion_name"] = data.att_legion_name,
            ["isWin"] = function()
                if data.is_win == 1 then
                    return true
                else
                    return false
                end
            end,
            ["round"] = data.round,
            ["headicon"] = data.att_headicon,
        })
        --受击方
        self.userArr[2]:render({
            ["name"] = data.def_name,
            ["kid"] = data.def_kid,
            ["legion_name"] = data.def_legion_name,
            ["isWin"] =  function()
                if data.is_win == 1 then
                    return false
                else
                    return true
                end
            end,
            ["round"] = data.round,
            ["headicon"] = data.def_headicon,
        })

    end
end

function ResultCell:isMyResult(att_kid,def_kid)
    if userModel.userInfoEntity.kid == att_kid then
        self.left_me_tip:setVisible(true)
        self.right_me_tip:setVisible(false)
    elseif userModel.userInfoEntity.kid == def_kid then
        self.left_me_tip:setVisible(false)
        self.right_me_tip:setVisible(true)
    else
        self.left_me_tip:setVisible(false)
        self.right_me_tip:setVisible(false)
    end
end

function ResultCell:updateTime()
    if self.model:getLastTab() == 1 then
        if self.model:getJoinNum() > 0 then
            local time = self.model:getOpenTime() - userModel.serverTime
            if time > 0 then
                self.title_txt:setString(qy.TextUtil:substitute(53009, NumberUtil.secondsToTimeStr(time, 2)))
            else
                self.title_txt:setString(qy.TextUtil:substitute(53024))
            end
        else
            self.title_txt:setString(qy.TextUtil:substitute(53025))
        end
    end
end

function ResultCell:onEnter()
    if self.idx == 1 and self.model:getLastTab() == 1 then
        self.timeListener = qy.Event.add(qy.Runtime.TIMER_UPDATE,function(event)
            self:updateTime()
        end)
    end
    self:updateTime()
end

function ResultCell:onExit()
    qy.Event.remove(self.timeListener)
	self.timeListener = nil
end

return ResultCell
