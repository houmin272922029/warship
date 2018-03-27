--[[
    购买
    Author: Aaron Wei
    Date: 2015-04-22 17:07:40
]]

local BuyDialog = qy.class("BuyDialog", qy.tank.view.BaseDialog, "junengpinhe/ui/BuyDialog")

local model = qy.tank.model.JuNengPinHeModel
local service = qy.tank.service.JuNengPinHeService
function BuyDialog:ctor(delegate)
    BuyDialog.super.ctor(self)
    self:setCanceledOnTouchOutside(true)

    self.entity = data

    -- 通用弹窗样式
    local style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(700, 400),
        position = cc.p(0, 0),
        offset = cc.p(0, 0),
        titleUrl = "Resources/common/title/junengpinhe_2.png",

        ["onClose"] = function()
            self:dismiss()
        end
    })
    self:addChild(style)

    -- 内容样式
    self:InjectView("panel")
    self:InjectView("name")
    self:InjectView("haveNum")
    self:InjectView("sellNum")
    self:InjectView("priceNum")
    self.panel:setLocalZOrder(1)
    self.delegate = delegate
    self.num = 1

    self:OnClick("minusBtn",function()
        self:__reduce(1)
    end)

    self:OnClick("minus10Btn",function()
        self:__reduce(10)
    end)

    self:OnClick("addBtn",function()
        self:__add(1)
    end)

    self:OnClick("add10Btn",function()
        self:__add(10)
    end)

    self:OnClick("cancelBtn",function()
        self:dismiss()
    end)

    self:OnClick("sureBtn",function()
        if self.num > 0 then
            qy.alert:show({"购买提示",{255,255,255}},"确定花费"..self.num*model:getNeed().."钻石购买聚能碎片礼包吗？",cc.size(450,250),{{qy.TextUtil:substitute(32003),3},{qy.TextUtil:substitute(32004),2}},function(tag)
                if tag == qy.TextUtil:substitute(32004) then

                    service:buy(function(data)
                        self.delegate:update()
                        self:dismiss()
                    end, self.num)
                end
            end)
        else
            qy.hint:show(qy.TextUtil:substitute(32005))
        end
    end)

    self.sellNum:setString(tostring(self.num))
    self.priceNum:setString(tostring(model:getNeed()))
end

function BuyDialog:__add(step)
    self:setNum(self.num+step)
end

function BuyDialog:__reduce(step)
    if self.num > step then
        self:setNum(self.num - step)
    else
        self:setNum(1)
    end
end

function BuyDialog:setNum(num)
    self.num = num
    self.sellNum:setString(tostring(num))
    self.priceNum:setString(tostring(num*model:getNeed()))
end

return BuyDialog
