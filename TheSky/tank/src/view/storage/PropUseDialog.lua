--[[
    道具选择弹框
    Author: Aaron Wei
    Date: 2015-04-21 20:57:02
]]

local PropUseDialog = qy.class("PropUseDialog", qy.tank.view.BaseDialog, "view/storage/PropUseDialog")

function PropUseDialog:ctor(data,callback)
    PropUseDialog.super.ctor(self)
    -- self:setCanceledOnTouchOutside(true)

    self.entity = data

    -- 通用弹窗样式
    local style = qy.tank.view.style.DialogStyle5.new({
        size = cc.size(700,340),
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
    self:InjectView("useNum")
    self:InjectView("sellNode")
    self.panel:setLocalZOrder(1)
    self.model = qy.tank.model.StorageModel
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
        local num = self.accountTxt:getText()
        if #num > 0 then
            for i=1,#num do
                local curByte = string.byte(num, i)
                if curByte > 57 or curByte < 48 then
                    qy.hint:show("请输入数字")
                    return
                end
            end
            self.num = tonumber(self.accountTxt:getText())
        end
        
        if self.num then
            if self.num > 0 then
                callback(self.entity.id,self.num)
                self:dismiss()
            else
                qy.hint:show(qy.TextUtil:substitute(80011))
            end
        else
            qy.hint:show("请输入数字")
        end
    end)

    self.name:setString(self.entity.name)
    self.name:setTextColor(self.entity:getTextColor())
    self.haveNum:setString(tostring(self.entity.num))
    self.useNum:setString("1")

    self.accountTxt = ccui.EditBox:create(cc.size(140, 60), "Resources/common/bg/c_12.bg")
    self.accountTxt:setPosition(115,29)
    self.accountTxt:setFontSize(30)
    self.accountTxt:setInputMode(6)
    self.accountTxt:setMaxLength(3)
    if self.accountTxt.setReturnType then
        self.accountTxt:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    end
    self.sellNode:addChild(self.accountTxt)

    self.accountTxt:setText(self.num)


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
end

function PropUseDialog:__add(step)
    local checkStr = self.accountTxt:getText()
    if #checkStr > 0 then
        self.num = tonumber(checkStr)
    end
    if self.entity.max_use_limit == 0 then
        if self.num >= self.entity.num then
            qy.hint:show(qy.TextUtil:substitute(80012))
        else
            if self.num <= self.entity.num - step then
                -- 增加步进量
                self:setNum(self.num+step)
            else
                -- 设置为最大数量
                self:setNum(self.entity.num)
            end
        end
    else
        if self.entity.num > self.entity.max_use_limit then
            if self.num >= self.entity.max_use_limit then
                qy.hint:show(qy.TextUtil:substitute(80013))
            else
                if self.num <= self.entity.max_use_limit - step then
                    self:setNum(self.num+step)
                else
                    self:setNum(self.entity.max_use_limit)
                end
            end
        else
            if self.num >= self.entity.num then
                qy.hint:show(qy.TextUtil:substitute(80012))
            else
                if self.num <= self.entity.num - step then
                    self:setNum(self.num+step)
                else
                    self:setNum(self.entity.num)
                end
            end
        end
    end
end

function PropUseDialog:__reduce(step)
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

function PropUseDialog:setNum(num)
    self.num = num
    self.accountTxt:setText(self.num)
    self.useNum:setString(tostring(num))
end

function PropUseDialog:setEditBoxNumber()
    local numberstring = tonumber(self.accountTxt:getText()) or 1
    local checkStr = self.accountTxt:getText()
    if #checkStr > 0 then
        for i=1,#checkStr do
            local curByte = string.byte(checkStr, i)
            if curByte > 57 or curByte < 48 then
                qy.hint:show("请输入数字")
                return
            end
        end
    end

    if numberstring <= tonumber(self.entity.num) then
        self:setNum(numberstring)
    else
        self:setNum(self.entity.num)
    end
end

return PropUseDialog
