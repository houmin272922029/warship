--[[
    兑换
    Author: Aaron Wei
	Date: 2015-06-01 15:51:39
]]
local ExchangeDialog = qy.class("ExchangeDialog", qy.tank.view.BaseDialog, "view/shop/PurchaseDialog")

--[[
	{["name"],
	["haveNum"],
	["num"],
	["min"],
	["max"],
	["price"]}
]]
function ExchangeDialog:ctor(data,callback)
    ExchangeDialog.super.ctor(self)

	-- for k,v in data do
	-- 	self[k] = v
	-- end
	if data then
		self.goodsName = data.goodsName or ""
		self.goodsNum = data.goodsNum or 0
		self.num = data.num or 1
		self.min = data.min or 1
		self.max = data.max or nil
		self.price = data.price or nil
        -- self.priceIcon = data.priceIcon or nil
	end
    -- 通用弹窗样式
    local style = qy.tank.view.style.DialogStyle3.new({
        size = cc.size(600,400),   
        position = cc.p(0,0),
        offset = cc.p(0,0), 
        
        ["onClose"] = function()
            self:dismiss()
        end
    })
    self:addChild(style)

    -- 内容样式
    self:InjectView("panel")
    self:InjectView("name")
    self:InjectView("possessNum")
    self:InjectView("exchangeNum")
    self:InjectView("totalPrice")
    self:InjectView("priceIcon")

    self.panel:setLocalZOrder(1)
    self.delegate = delegate
    self.model = qy.tank.model.StorageModel
    -- self.haveNum = qy.tank.model.StorageModel:getPropNumByID(self.entity.shop_id)

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
    end,{["audioType"] = qy.SoundType.BTN_CLOSE})

    self:OnClick("sureBtn",function()
        if self.num > 0 then
            callback(self.num)
            self:dismiss()
        else
            qy.hint:show(qy.TextUtil:substitute(8030))
        end
    end,{["audioType"] = qy.SoundType.BTN_CLOSE})

    self.name:setString(self.goodsName)
    self.possessNum:setString(tostring(self.goodsNum))
    self.exchangeNum:setString(tostring(self.num))
    self.totalPrice:setString(tostring(self.price*self.num))
    -- self.priceIcon:setTexture(tostring(self.priceIcon))
end

function ExchangeDialog:__add(step)
    if self.num >= self.max then
        qy.hint:show(qy.TextUtil:substitute(8031))
    else
        if self.num <= self.max - step then
            -- 增加步进量
            self:setNum(self.num+step)
        else
            -- 设置为最大数量
            self:setNum(self.max)
        end
    end
end

function ExchangeDialog:__reduce(step)
    if self.num > step then
        self:setNum(self.num - step)
    else
        self:setNum(self.min)
    end
end

function ExchangeDialog:setNum(num)
    self.num = num
    self.exchangeNum:setString(tostring(self.num))
    self.totalPrice:setString(tostring(self.price*self.num))
end

return ExchangeDialog
