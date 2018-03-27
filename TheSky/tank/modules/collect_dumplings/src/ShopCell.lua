

local ShopCell = qy.class("ShopCell", qy.tank.view.BaseView, "collect_dumplings/ui/ShopCell")

local StorageModel = qy.tank.model.StorageModel
local service = qy.tank.service.CollectDumpingsService

function ShopCell:ctor(delegate)
    ShopCell.super.ctor(self)
    self.model = qy.tank.model.CollectDumpingsModel
    
    self:InjectView("text")
    self:InjectView("bt")--进度
    self:InjectView("awardlist1")--
    self:InjectView("awardlist2")

    self.data =  self.model.shoplist
 
    self:OnClick("bt", function(sender)
        local need = self.data[tostring(self.index)].award_need
        local tt = 0
        for k,v in pairs(need) do
            local id = v.id
            local neednum  = v.num
            local havenum = StorageModel:getPropNumByID(id)
            if neednum > havenum then
                tt = 1
                qy.hint:show("所需物品不足")
                break
            end
        end
        if tt == 0 then
            service:exchange(self.index,function (  )
                delegate:callback()
            end)
        end
    end)
  
end

function ShopCell:render(_idx)
    self.index = _idx
    local data = self.data[tostring(_idx)]
    
    self.awardlist1:removeAllChildren()
    self.awardlist2:removeAllChildren()
    for i=1,#data.award_need do
        local item = qy.tank.view.common.AwardItem.createAwardView(data.award_need[i] ,1)
        self.awardlist1:addChild(item)
        item:setPosition(50 + 75*(i - 1), 50)
        item:setScale(0.6)
        item.name:setVisible(false)
    end
    for i=1,#data.award do
        local item = qy.tank.view.common.AwardItem.createAwardView(data.award[i] ,1)
        self.awardlist2:addChild(item)
        item:setPosition(50 + 75*(i - 1), 50)
        item:setScale(0.6)
        item.name:setVisible(false)
    end
    local id = data.award[1].id
    --self.text:setString("包"..StorageModel:getPropNameByID(id))
    self.text:setString("兑换")
end

return ShopCell
