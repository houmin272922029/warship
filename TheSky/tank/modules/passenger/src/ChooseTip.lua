
local ChooseTip = qy.class("ChooseTip", qy.tank.view.BaseDialog, "passenger.ui.ChooseTip")

local PassengerService = qy.tank.service.PassengerService
local model = qy.tank.model.StorageModel
local PassengerModel = qy.tank.model.PassengerModel

function ChooseTip:ctor(delegate)
   	ChooseTip.super.ctor(self)
   	self:setCanceledOnTouchOutside(true)
    self.data = delegate.data
    self.delegate= delegate
    self:InjectView("chooselist")
    self:InjectView("Panel_1")
    self:InjectView("Panel_2")
    self:OnClick("Panel_1", function()
        self:removeSelf()
    end,{["isScale"] = false})
    self:OnClick("Panel_2", function()
        self:removeSelf()
    end,{["isScale"] = false})
    self.chooselist:setScrollBarEnabled(false)
    self:createlist()
end
  
function ChooseTip:createlist(  )
    local num = #self.data
    local cellH = 92
    local listH = 280
    if num > 12 then
        listH = cellH * math.ceil(num / 4)
    end
   
    -- print("========",num)
    -- print("============高度"..listH)
    -- setInnerContainerSize(cc.size(430,300))
    self.chooselist:setInnerContainerSize(cc.size(430,listH))
    for i, v in pairs(self.data) do
        self["item3" .. i] = qy.tank.view.common.ItemIcon.new()
        self["item3" .. i]:setPosition(105 * math.ceil((i - 1) % 4) + 65, listH-42 - 95 * math.floor((i - 1) / 4 ))
        self.chooselist:addChild(self["item3" .. i])
        local data = qy.tank.view.common.AwardItem.getItemData(v)
        data.beganFunc = function(sender)
        
        end
        data.callback = function()
            self.delegate.callback(v)
             self:removeSelf()
        end
        self["item3" .. i]:setData(data)
        self["item3" .. i]:setScale(0.8)
        self["item3" .. i]:getParent():setLocalZOrder(0)
        self["item3" .. i].name:setString(PassengerModel.typeNameList[v.passengerType ..""])
        self["item3" .. i]:setNameAnchorPoint(0,1)
        self["item3" .. i]:setHorizontalAlignment()
        self["item3" .. i].childSprite:setScale(0.8)
        self["item3" .. i]:setVisible(true)
        self["item3" .. i]:setTitlePosition(5)
        if self["item3" .. i].num then
            self["item3" .. i].num:setString(v.iscomplete == 200 and (v.num.."/"..typeNumList[v.quality .. ""]) or ("Lv."..v.level))
        end
   
    end
end

function ChooseTip:onEnter()
    
end

function ChooseTip:onExit()

end

return ChooseTip