--[[
    
]]
local PurchaseDialog = qy.class("PurchaseDialog", qy.tank.view.BaseDialog, "view/shop/PurchaseDialog1")

local model = qy.tank.model.TasteWarModel

function PurchaseDialog:ctor(callback)
    PurchaseDialog.super.ctor(self)
 

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
    self.name:setVisible(false)
    self:InjectView("possessNum")
    self:InjectView("exchangeNum")
    self:InjectView("totalPrice")
    self:InjectView("priceIcon")
    self:InjectView("sellNode")
    self:InjectView("yongyou")
    self.yongyou:setVisible(false)
    self.possessNum:setVisible(false)
    self.panel:setLocalZOrder(1)
    self.delegate = delegate
    self.model = qy.tank.model.StorageModel
    self.num = 1
    self.type = type
    self.max_buy_limit = 30

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
        local numberstring = self.accountTxt:getText()
        if #numberstring > 0 then
            for i=1,#numberstring do
                local curByte = string.byte(numberstring, i)
                if curByte > 57 or curByte < 48 then
                    qy.hint:show("请输入数字")
                    return
                end
            end
            self.num = tonumber(self.accountTxt:getText())
        end
        
        if self.num then
            if self.num > 0 then
                callback(self.num)
                self:dismiss()
            else
                qy.hint:show(qy.TextUtil:substitute(31010))
            end
        else
            qy.hint:show("请输入数字")
        end
    end)

    self.userInfoEntity = qy.tank.model.UserInfoModel.userInfoEntity
    -- self.priceIcon:setSpriteFrame("taste_war/res/1.png")

    self.accountTxt = ccui.EditBox:create(cc.size(140, 60), "Resources/common/bg/c_12.bg")
    self.accountTxt:setPosition(110,29)
    self.accountTxt:setFontSize(30)
    self.accountTxt:setInputMode(6)
    self.accountTxt:setMaxLength(4)
    if self.accountTxt.setReturnType then
        self.accountTxt:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    end
    self.sellNode:addChild(self.accountTxt)



    self.accountTxt:registerScriptEditBoxHandler(function(eventType)
        if eventType == "began" then
            -- 当编辑框获得焦点并且键盘弹出的时候被调用
        elseif eventType == "ended" then
            -- 当编辑框失去焦点并且键盘消失的时候被调用
            self:setEditBoxNumber()
        elseif eventType == "changed" then
            -- 当编辑框的文本被修改的时候被调用
            -- self:setEditBoxNumber()
        elseif eventType == "return" then
            -- 当用户点击编辑框的键盘以外的区域，或者键盘的Return按钮被点击时所调用
            self:setEditBoxNumber()
        end
    end)
    self:setNum(1)
end

function PurchaseDialog:__add(step)
    local checkStr = self.accountTxt:getText()
    if #checkStr > 0 then
        self.num = tonumber(checkStr)
    end
    if self.num >= self.max_buy_limit then
        qy.hint:show(qy.TextUtil:substitute(31011))
    else
        if self.num <= self.max_buy_limit - step then
            -- 增加步进量
            self:setNum(self.num+step)
        else
            -- 设置为最大数量
            self:setNum(self.max_buy_limit)
        end
    end
end

function PurchaseDialog:__reduce(step)
    local checkStr = self.accountTxt:getText()
    if #checkStr > 0 then
        self.num = tonumber(checkStr)
    end
    if self.num > step then
        self:setNum(self.num - step)
    else
        self:setNum(1)
    end
end

function PurchaseDialog:setNum(num)
    self.num = num
    -- self.exchangeNum:setString(tostring(num))
    self.accountTxt:setText(self.num)
    --最后处理下
    local nums = self:getcosast(self.num)
    self.totalPrice:setString(nums)
end

function PurchaseDialog:setEditBoxNumber()
    local numberstring = tonumber(self.accountTxt:getText())
    local checkStr = self.accountTxt:getText()
    if #checkStr > 0 then
        for i=1,#checkStr do
            local curByte = string.byte(checkStr, i)
            if curByte > 57 or curByte < 48 then
                qy.hint:show("请输入数字")
                return
            end
        end
        if numberstring > self.max_buy_limit then
            self:setNum(self.max_buy_limit)
        else
            self:setNum(numberstring)
        end
    else
        self:setNum(1)
    end

end

function PurchaseDialog:getcosast( exec )
    local times = 0
    local init = 1
    local max = 20
    times = model.buy_num
    local cost = 0
    for i=1,exec do
        local calc = init + times
        calc = calc>max and max or calc
        cost = cost + calc
        times = times + 1
    end
    return cost
end

-- function PurchaseDialog:onEnter()
--     self.listener_1 = qy.Event.add(qy.Event.BONUS_TIME,function(event)
--         if self.accountTxt and self.accountTxt:getText() then
--             self:setEditBoxNumber()
--         end
--     end)
-- end

-- function PurchaseDialog:onExit()
--     qy.Event.remove(self.listener_1)
-- end

return PurchaseDialog
