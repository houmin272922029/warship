--[[
    充值 cell
    Author: H.X.Sun
    Date: 2015-09-09
--]]
local RechargeItem = qy.class("RechargeItem", qy.tank.view.BaseView, "view/recharge/RechargeItem")

local model = qy.tank.model.RechargeModel
local loginModel = qy.tank.model.LoginModel

function RechargeItem:ctor(delegate)
    RechargeItem.super.ctor(self)

    self.delegate = delegate

    self:InjectView("bg")
    self:InjectView("diamond_icon")
    self:InjectView("desTxt")
    self:InjectView("price")
    self:InjectView("diamond_txt")
    self:InjectView("right_corner")
    self:InjectView("tips")
    self:InjectView("left_corner")

    self.diamondH = self.diamond_txt:getPositionY()
    self.diamondW = self.diamond_txt:getContentSize().width
    self.bgW = self.bg:getContentSize().width

    self:OnClickForBuilding("bg", function(sender)
        if not delegate:isTouchMoved() then
            self:clickLogic()
            -- if qy.product == "local" or qy.product == "develop" then
            --     self:clickLogic()
            -- else
            --     qy.hint:show("充值功能，暂未开放")
            -- end
        end
    end,{["isScale"] = false})
    self.bg:setSwallowTouches(false)
    self.diamondNum = qy.tank.widget.Attribute.new({
        ["numType"] = 17,
        ["hasMark"] = 0,
        ["value"] = 12,
    })
    self.bg:addChild(self.diamondNum)
end

--商品点击
function RechargeItem:clickLogic()
    qy.tank.service.RechargeService:paymentBegin(self.data, function(flag, msg)
        if flag == 3 then
            self.toast = qy.tank.widget.Toast.new()
            self.toast:make(self.toast, qy.TextUtil:substitute(27001))
            self.toast:addTo(qy.App.runningScene, 1000)
        elseif flag == true then
            self.toast:removeSelf()
            self:update()
            if qy.language == "en" then
                if loginModel:getPlayerInfoEntity().is_visitor == 1 then
                    local dialog = require("view/recharge/ShowDialog").new()
                    dialog:show()
                end
            end
            qy.hint:show(qy.TextUtil:substitute(27002))
        else
            self.toast:removeSelf()
            qy.hint:show(msg)
        end
    end)
end

function RechargeItem:render(data)
    self.data = data

    if data.right_txt and data.right_txt ~= "" then
        self.right_corner:setVisible(true)
        self.tips:setString(data.right_txt)
    else
        self.right_corner:setVisible(false)
    end
    self.diamond_icon:setSpriteFrame("Resources/recharge/diamond_" .. data.icon .. ".png")
    self.price:setString((qy.language == "cn" and  "￥" or "$").. data.cash)

    self:update()
    self:updateDiamond()
    if qy.isAudit then
        self.right_corner:setVisible(false)
        if data.product_id == "yk68" or data.product_id == "yk25" then
            self.desTxt:setVisible(false)
        end
    end
end

function RechargeItem:updateDiamond()
    self.diamondNum:update(self.data.gem)
    local _vW = self.diamondNum.valueLabel:getContentSize().width
    local _hW = (self.bgW - self.diamondW - _vW) / 2
    self.diamondNum:setPosition(_hW, self.diamondH)
    self.diamond_txt:setPosition(_hW + _vW, self.diamondH)
end

function RechargeItem:update()
    local isFirstPay = model:isFirstPayment(self.data.product_id)

    if self.data.left_icon > 0 then
        if tostring(self.data.type) == "1" and (not isFirstPay) then
            self.left_corner:setVisible(false)
        else
            self.left_corner:setVisible(true)
            self.left_corner:setSpriteFrame("Resources/recharge/corner_" .. self.data.left_icon .. ".png")
        end
    else
        self.left_corner:setVisible(false)
    end
    if isFirstPay then
        self.desTxt:setString(self.data.desc)
        self.desTxt:setVisible(true)
    else
        self.desTxt:setVisible(false)
    end
end

return RechargeItem
