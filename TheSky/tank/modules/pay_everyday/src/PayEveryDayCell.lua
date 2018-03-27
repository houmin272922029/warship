--[[--
--
--Author: Fu.Qiang
--Date: 2016-07-04
--]]--

local PayEveryDayCell = qy.class("PayEveryDayCell", qy.tank.view.BaseView, "pay_everyday/ui/Cell")

function PayEveryDayCell:ctor(delegate, callback)
    PayEveryDayCell.super.ctor(self)
    self.model = qy.tank.model.PayEveryDayModel
    self.service = qy.tank.service.PayEveryDayService

    self:InjectView("bg")
    self:InjectView("Text")
    self:InjectView("Txt_num")
    self:InjectView("Txt_need")
    self:InjectView("Btn_get")
    self:InjectView("Txt_chongzhi")
    self:InjectView("Txt_lingqu")
    self:InjectView("Img_yilingqu")

    self.parent = delegate
    self.callback = callback
end

function PayEveryDayCell:sendMsg(chooseIdx)
    local id = self.data.cash
    if chooseIdx then
        id = self.data.cash .. "-" .. chooseIdx
    end
    local service = qy.tank.service.OperatingActivitiesService
    service:getCommonGiftAward(id, _moduleType, true, function(reData)
        self.model:upRebateDataVipStaByIdx(self.idx)
        self:updateStatus(2)
    end)
end

function PayEveryDayCell:render(data)
    if data.is_get == 100 then
        self.Btn_get:setVisible(true)
        self.Img_yilingqu:setVisible(false)
        self.Text:setVisible(false)
        self.Txt_need:setVisible(false)
        self.Txt_lingqu:setVisible(true)
        self.Txt_chongzhi:setVisible(false)
    elseif data.is_get == 200 then
        self.Btn_get:setVisible(false)
        self.Img_yilingqu:setVisible(true)
        self.Text:setVisible(false)
        self.Txt_need:setVisible(false)
        self.Txt_lingqu:setVisible(false)
        self.Txt_chongzhi:setVisible(false)
    elseif data.is_get == 300 then
        self.Btn_get:setVisible(true)
        self.Img_yilingqu:setVisible(false)
        self.Text:setVisible(true)
        self.Txt_need:setVisible(true)
        self.Txt_lingqu:setVisible(false)
        self.Txt_chongzhi:setVisible(true)

        self.Txt_need:setString(data.cash - self.model:getCash())
    end

    self.Txt_num:setString(data.cash)

    if self.awardList then
        self.bg:removeChild(self.awardList)
    end


    self.awardList = qy.AwardList.new({
        ["award"] = data.award,
        ["cellSize"] = cc.size(105,150),
        ["type"] = 1,
        ["len"] = 5,
        ["itemSize"] = 2,
        ["hasName"] = false,
    })
    self.awardList:setPosition(75,225)
    self.bg:addChild(self.awardList)



    self:OnClick(self.Btn_get, function(sender)
        if data.is_get == 300 then
            self.callback()
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.RECHARGE)
        elseif data.is_get == 100 then
            self.service:getAward(function(data)
                qy.tank.command.AwardCommand:add(data.award)
                qy.tank.command.AwardCommand:show(data.award,{["isShowHint"]=false})

                data.is_get = 200
                self.Btn_get:setVisible(false)
                self.Img_yilingqu:setVisible(true)
                self.Text:setVisible(false)
                self.Txt_lingqu:setVisible(false)
                self.Txt_chongzhi:setVisible(false)
            end, 100, data.cash)
        end
    end)
end



return PayEveryDayCell
