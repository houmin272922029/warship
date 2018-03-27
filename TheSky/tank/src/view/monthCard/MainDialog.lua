--[[
    月卡
    Author: mingming
    Date: 2015-08-21 16:28:15
]]

local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "view/monthCard/MainDialog")

local model = qy.tank.model.OperatingActivitiesModel
local service = qy.tank.service.OperatingActivitiesService
function MainDialog:ctor(entity)
    model:monthCardInit()
    MainDialog.super.ctor(self)

    self:setCanceledOnTouchOutside(true)
    self:InjectView("Node_1")
    self:InjectView("Node_2")
    self:InjectView("Buy1")
    self:InjectView("Buy2")
    self:InjectView("Btn_buy1")
    self:InjectView("Btn_buy2")
    self:InjectView("Info1")
    self:InjectView("Info2")
    self:InjectView("hasGot1")
    self:InjectView("hasGot2")

    self:OnClick("Close", function()
        --qy.QYPlaySound.stopMusic()
       self:dismiss()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self:OnClick("Btn_buy1", function()
        --qy.QYPlaySound.stopMusic()
        local status = model:atMonthCardStatus(1)
        if status == 1 then
            -- self:dismiss()
            -- qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.RECHARGE)
            self:buyCard("yk30")
        elseif status == 2 or status == 4 then
            local aType = qy.tank.view.type.ModuleType
            service:getCommonGiftAward(1, aType.MONTH_CARD,false, function(reData)
                -- self:updataGiftNum()
                -- tableView:reloadData()
                model.monthCardStatus1 = 3
                if model.monthCardDays1 then
                    model.monthCardDays1 = model.monthCardDays1 - 1
                end
                self:update()
            end)
        elseif status == 3 or status == 5 then
            --todo
            qy.hint:show(qy.TextUtil:substitute(23001))
        end
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self:OnClick("Btn_buy2", function()
        --qy.QYPlaySound.stopMusic()
        local status = model:atMonthCardStatus(2)
        if status == 1 then
            -- self:dismiss()
            -- qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.RECHARGE)
            self:buyCard("yk98")
        elseif status == 2 or status == 4 then
            local aType = qy.tank.view.type.ModuleType
            service:getCommonGiftAward(2, aType.MONTH_CARD,false, function(reData)
                -- self:updataGiftNum()
                -- tableView:reloadData()
                model.monthCardStatus2 = 3
                if model["monthCardDays2"] then
                    model["monthCardDays2"] = model["monthCardDays2"] - 1
                end
                self:update()
            end)
        elseif status == 3 or status == 5 then
            --todo
            qy.hint:show(qy.TextUtil:substitute(23001))
        end
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self:createReward()
    self:update()
end

function MainDialog:createReward()
    for i = 1, 2 do
        local reward = model:atMonthCardAward(i)

        local item = qy.tank.view.common.ItemIcon.new()
        local data = model:atMonthCardDiamond(i)
        item:setData(data)
        item:setScale(0.85)
        item:setPositionX(50)

        item.name:setVisible(qy.InternationalUtil:isShowMailName())
        self["Node_" .. i]:addChild(item)

        for p, q in pairs(reward) do
            local item = qy.tank.view.common.ItemIcon.new()
            item:setData(q)
            item.name:setVisible(qy.InternationalUtil:isShowMailName())
            item:setScale(0.85)
            item:setPositionX(50 + 100 * p)
            self["Node_" .. i]:addChild(item)
        end
    end
end

function MainDialog:update()
    for i = 1, 2 do
        local status = model:atMonthCardStatus(i)

        self["Btn_buy" .. i]:setBright(status ~= 3 and status ~= 5)

        local imgstatus = status == 1 and "4" or 5
        if tonumber(imgstatus) == 4 then
            self["Buy" .. i]:loadTexture("Resources/common/txt/goumai.png",1)
        else
            self["Buy" .. i]:loadTexture("Resources/common/txt/lingqu.png",1)
        end

        if status == 1 then
            self["Info" .. i]:setString(qy.TextUtil:substitute(23002))
        elseif status == 4 or status == 5 then
            self["Info" .. i]:setString(qy.TextUtil:substitute(23003))
        else
            if model["monthCardDays" .. i] then
                self["Info" .. i]:setString(qy.TextUtil:substitute(23004) .. model["monthCardDays" .. i] .. qy.TextUtil:substitute(23005))
            end
        end
    end

    local status1 = model:atMonthCardStatus(1)
    if status1 == 3 or status1 == 5 then
        self.Btn_buy1:setVisible(false)
        self.hasGot1:setVisible(true)
        self.Buy1:setVisible(false)
    else
        self["Btn_buy1"]:setVisible(true)
        self.hasGot1:setVisible(false)
        self.Buy1:setVisible(true)
    end

    local status2 = model:atMonthCardStatus(2)
    if status2 == 3 then
        self.Btn_buy2:setVisible(false)
        self.hasGot2:setVisible(true)
        self.Buy2:setVisible(false)
    else
        self.Btn_buy2:setVisible(true)
        self.hasGot2:setVisible(false)
        self.Buy2:setVisible(true)
    end
end

function MainDialog:buyCard(idx)
    local data = qy.tank.model.RechargeModel.data[idx]
    qy.tank.service.RechargeService:paymentBegin(data, function(flag, msg)
        if flag == 3 then
            self.toast = qy.tank.widget.Toast.new()
            self.toast:make(self.toast, qy.TextUtil:substitute(23006))
            self.toast:addTo(qy.App.runningScene, 1000)
        elseif flag == true then
            self.toast:removeSelf()
            local id = idx == "yk98" and 2 or 1
            model["monthCardStatus" .. id] = 2
            model["monthCardDays" .. id] = 30
            self:update()
            qy.hint:show(qy.TextUtil:substitute(23007))
        else
            self.toast:removeSelf()
            qy.hint:show(msg)
        end
    end)
end
function MainDialog:onExit()
    -- cc.Director:getInstance():getTextureCache():removeAllTextures()
end

return MainDialog


