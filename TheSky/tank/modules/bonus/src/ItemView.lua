local ItemView = qy.class("ItemView", qy.tank.view.BaseView, "bonus.ui.ItemView")

local model = qy.tank.model.OperatingActivitiesModel
local service = qy.tank.service.OperatingActivitiesService
function ItemView:ctor(delegate)
   	ItemView.super.ctor(self)
    self:InjectView("Day")
    self:InjectView("Advance")
    self:InjectView("Price1")
    self:InjectView("Price2")
    self:InjectView("Btn_text")
    self:InjectView("Button_1")
    self:InjectView("hasGot")
   

   	self:OnClick("Button_1", function()
        if self.status == 1 then
            delegate:removeSelf()
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.RECHARGE)
        elseif self.status == 2 then
            service:getCommonGiftAward(self.data.day, qy.tank.view.type.ModuleType.BONUS,false, function(data)
                self.data.idx = self.data.idx + 7
                self:update()
            end)
        elseif self.status == 3 then
            qy.hint:show(qy.TextUtil:substitute(43001))
        end
    end,{["isScale"] = false})
end

function ItemView:setData(data)
	self.Day:setString(qy.TextUtil:substitute(43002) .. " " .. data.day .. " " ..qy.TextUtil:substitute(43003))
	self.Advance:setString(qy.TextUtil:substitute(43004).." " .. model.bonusDay .. "/" .. data.day)
	self.Price1:setString(data.old_price)
	self.Price2:setString(data.price)

	local item = qy.tank.view.common.AwardItem.createAwardView(data.award[1] ,1)
    self:addChild(item)
    item:setPosition(70, 60)
    item:setScale(0.8)
    item.name:setVisible(false)

    self.data = data
    self:update()
end

function ItemView:update()
    self.Button_1:setBright(self.data.idx <= 7)
    self.hasGot:setVisible(false)
    if self.data.day <= model.bonusDay then
        self.Btn_text:setSpriteFrame("Resources/common/txt/goumai.png")
        self.Button_1:loadTextureNormal("Resources/common/button/btn_4.png", 1)
        self.Button_1:loadTexturePressed("Resources/common/button/anniulan02.png", 1)
        -- self.Button_1:setSpriteFrame(frame)
        self.status = 2
    else
        self.Btn_text:setSpriteFrame("Resources/common/txt/qianwang.png")
        self.Button_1:loadTextureNormal("Resources/common/button/btn_3.png", 1)
        self.Button_1:loadTexturePressed("Resources/common/button/anniuhong02.png", 1)
        
        self.status = 1
    end

    if self.data.idx > 7 then
        self.status = 3
        self.Button_1:setVisible(false)
        self.hasGot:setVisible(true)
    else
        self.Button_1:setVisible(true)
    end
end

return ItemView
