--[[
--成长基金
--Author: mingming
--Date:
]]

local ItemView = qy.class("Attribute", qy.tank.view.BaseView, "view/operatingActivities/growthFund/ItemView")

function ItemView:ctor(delegate)
    ItemView.super.ctor(self)

    self:InjectView("Level")
    self:InjectView("Num")
    self:InjectView("Btn_get")
    self:InjectView("hasGot")
    self:InjectView("TitleBtn")
    
	-- local data = delegate.data
 --    for i = 1, 3 do
 --    	self:InjectCustomView("Item" .. i, qy.tank.view.common.TankItem2, data[i])
    	-- self["Item" .. i]:setVisible(false)
 --    end

 --    self:setData(data)

    local view = qy.tank.view.common.AwardItem.createAwardView({["type"] = 1, ["num"] = 1},1)
    view:setScale(0.8)
    view:setPosition(300, 55)
    view.name:setVisible(false)
    self.Diamond = view
    self:addChild(view)

  	self:OnClick("Btn_get", function()
        --qy.QYPlaySound.stopMusic()
        if self.entity.status == 1 then
            qy.hint:show(qy.TextUtil:substitute(63005))
        else
            if qy.tank.model.OperatingActivitiesModel.is_have_buy then
                if self.entity:levelEnough() then     
                    if delegate and delegate.onReward then
                        delegate.onReward(self)
                    end
                else
                    qy.hint:show(qy.TextUtil:substitute(63006))
                end
            else
                qy.hint:show(qy.TextUtil:substitute(63007))
            end
        end
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})
end

function ItemView:setData(data, hasBuy)
	self.entity = data
    self.hasBuy = hasBuy
	self:update()
end

function ItemView:update()
    self.Level:setSpriteFrame("Resources/growthFund/" .. self.entity.title_icon .. ".png")
    -- self.Num:setString(data.diamond)
    self.Diamond.num:setString(self.entity.diamond)

    self.Btn_get:setBright((self.hasBuy and self.entity:levelEnough()) and self.entity.status ~= 1)
    if (self.hasBuy and self.entity:levelEnough()) and self.entity.status ~= 1 then
        self.TitleBtn:setSpriteFrame("Resources/common/txt/lingqu.png")
    else
        self.TitleBtn:setSpriteFrame("Resources/common/txt/weidacheng.png")
    end

    self:setButton()
end

function ItemView:setButton()
    self.Btn_get:setVisible(self.entity.status ~= 1)
    self.hasGot:setVisible(self.entity.status == 1)
end

return ItemView