--[[
    道具出售弹框
    Author: Aaron Wei
    Date: 2015-04-22 17:07:40
]]

local PropSaleDialog = qy.class("PropSaleDialog", qy.tank.view.BaseDialog, "view/storage/PropSaleDialog")

function PropSaleDialog:ctor(data,callback)
    PropSaleDialog.super.ctor(self)
    self:setCanceledOnTouchOutside(true)

    self.entity = data

    -- 通用弹窗样式
    local style = qy.tank.view.style.DialogStyle5.new({
        size = cc.size(700,400),
        position = cc.p(0,0),
        offset = cc.p(0,0),

        -- ["onClose"] = function()
        --     self:dismiss()
        -- end
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
    self.model = qy.tank.model.StorageModel
    self.num = 1
    self.price = self.num*self.entity.price

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
            local content = qy.TextUtil:substitute(32001)..self.entity.name.."x"..self.num
            qy.alert:show({qy.TextUtil:substitute(32002),{255,255,255}},content,cc.size(450,250),{{qy.TextUtil:substitute(32003),3},{qy.TextUtil:substitute(32004),2}},function(tag)
                if tag == qy.TextUtil:substitute(32004) then
                    callback(self.entity.id,self.num)
                    self:dismiss()
                end
            end)
        else
            qy.hint:show(qy.TextUtil:substitute(32005))
        end
    end)

    self.name:setString(self.entity.name)
    self.name:setTextColor(self.entity:getTextColor())
    self.haveNum:setString(tostring(self.entity.num))
    self.sellNum:setString(tostring(self.num))
    self.priceNum:setString(tostring(self.price))
end

function PropSaleDialog:__add(step)
    if self.num >= self.entity.num then
        qy.hint:show(qy.TextUtil:substitute(32006))
    else
        if self.num <= self.entity.num - step then
            -- 增加步进量
            self:setNum(self.num+step)
        else
            -- 设置为最大数量
            self:setNum(self.entity.num)
        end
    end
end

function PropSaleDialog:__reduce(step)
    if self.num > step then
        self:setNum(self.num - step)
    else
        self:setNum(1)
    end
end

function PropSaleDialog:setNum(num)
    self.num = num
    self.sellNum:setString(tostring(num))
    self.priceNum:setString(tostring(num*self.entity.price))
end

return PropSaleDialog
