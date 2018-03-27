

local ShopCell = qy.class("ShopCell", qy.tank.view.BaseView, "taste_war/ui/ShopCell")

local StorageModel = qy.tank.model.StorageModel
local service = qy.tank.service.TasteWarService

function ShopCell:ctor(delegate)
    ShopCell.super.ctor(self)
    self.model = qy.tank.model.TasteWarModel
    
    self:InjectView("name")
    self:InjectView("buyBt")--进度
    self:InjectView("enchange")--
    self:InjectView("awardbg")

    self.data =  self.model.shoplist
 
    self:OnClick("buyBt", function(sender)
        local need = self.data[tostring(self.index)].price
        if need > self.model.score then
            qy.hint:show("积分不足")
            return
        end
        service:exchange(self.index,function (  )
            delegate:callback()
        end)
        
    end)
  
end

function ShopCell:render(_idx)
    self.index = _idx
    local data = self.data[tostring(_idx)]
    self.awardbg:removeAllChildren()
    self["enchange"]:setString("兑换所需:"..data.price)
    local award = data.award[1]  
    local itemData = qy.tank.view.common.AwardItem.getItemData(award)
    local color = qy.tank.utils.ColorMapUtil.qualityMapColorFor3b(itemData.quality)
    self["name"]:setColor(color)
    self["name"]:setString(itemData.name)

    local item = qy.tank.view.common.AwardItem.createAwardView(award ,1)
    self.awardbg:addChild(item)
    item:setPosition(70 , 53)
    item:setScale(0.85)
    item.name:setVisible(false)
end

return ShopCell
