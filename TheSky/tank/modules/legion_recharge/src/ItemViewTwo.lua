--[[
	
	
]]

local ItemViewTwo = qy.class("ItemViewTwo", qy.tank.view.BaseDialog, "legion_recharge.ui.ItemViewTwo")

function ItemViewTwo:ctor(delegate)
    self.model = qy.tank.model.LegionRechargeModel
    self.service = qy.tank.service.LegionRechargeService

    self:InjectView("Yilingqu")
    self:InjectView("Btn_pick")
    self:InjectView("Lingqu")
    self:InjectView("Text_1")
    self:InjectView("Btn_pick")
    for i=1,4 do
        self:InjectView("Node_"..i)
    end

    self.my_recharge = self.model.data.user_activity_data.recharge
    self.my_contribution = self.model.data.user_activity_data.contribution
    self:OnClick("Btn_pick",function (  )
        print("选择的id",self.idx)
        self.service:getAward(self.idx,function (  )
            self.model:changeget_log(self.idx)
              delegate:callback()
        end)
    end)
   
end

function ItemViewTwo:render(data,idx)--idx从 1 开始
    self.idx = idx
    self.Text_1:setString("全军团充值额度达到"..data.cash.."元，即可领取")
    for i=1,4 do
      self["Node_"..i]:removeAllChildren(true)
    end

    for i=1,#data.award do
    local item = qy.tank.view.common.AwardItem.createAwardView(data.award[i] ,1)
      
      self["Node_"..i]:addChild(item)
      item:setScale(0.6)
      item.fatherSprite:setSwallowTouches(false)
      item.name:setVisible(false)
    end

    self:getStatus(idx)
end
-- 0 置灰  1 未领取  2 已领取
function ItemViewTwo:getStatus( idx)
    local is_status = self.model:getStatus(idx)
    self.Yilingqu:setVisible(is_status == 2)
    self.Lingqu:setVisible(is_status == 1 or is_status == 0)
    self.Btn_pick:setTouchEnabled(is_status ~= 0)
    self.Btn_pick:setBright(is_status ~= 0)
end

return ItemViewTwo

