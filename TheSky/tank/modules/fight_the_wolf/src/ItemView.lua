local ItemView = qy.class("ItemView", qy.tank.view.BaseView, "fight_the_wolf.ui.StorageCell")
local service = require("fight_the_wolf.src.Service")
local  Model = require("fight_the_wolf.src.Model")
function ItemView:ctor(delegate)
   	ItemView.super.ctor(self)
   	self:InjectView("Text_title")
   	self:InjectView("startBtn")
    self:InjectView("awardbg")
    self:InjectView("Image_8")
    self:InjectView("Image_4")

    --开始攻打
   	self:OnClick("startBtn", function()    
    service:getAward(self.copy_id,self.id,1,function(response)         
          delegate:callback()
    end)
    end,{["audioType"] = qy.SoundType.COMMON_CLICK, ["isScale"] = false})  		
end

function ItemView:render(data,_idx)--data是一条数据 _idx是选择的小怪下标1-6
  --判断是否被攻破
  local status = Model:getStatusByid(data.id)
  
  self.Image_8:setVisible(status == 1)
  self.startBtn:setVisible(status == 0)
  self.Image_4:setVisible(status == 0)
	self.Text_title:setString(data.name)
  self.index = _idx
  self.id = data.id
  self.copy_id = data.copy_id
  self.awardbg:removeAllChildren(true)
  local award = data.award
  
  --普通奖励
  for i=1,#award do
    local item = qy.tank.view.common.AwardItem.createAwardView(award[i] ,1)
      self.awardbg:addChild(item)
      item:setPosition(-50 + 100 * i, 50)
      item:setScale(0.8)
      item.fatherSprite:setSwallowTouches(false)
      item.name:setVisible(false)
  end
  --随机奖励
   local items = require("fight_the_wolf.src.Awarditem").new({
           ["ids"] = data.award_id,
    })
     self.awardbg:addChild(items)
     items:setPosition(-50 + (#award+ 1) * 100,38)
	 
end

return ItemView
