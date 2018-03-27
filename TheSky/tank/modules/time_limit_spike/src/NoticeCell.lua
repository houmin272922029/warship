--[[
	
	限时秒杀
]]

local NoticeCell = qy.class("NoticeCell", qy.tank.view.BaseView, "time_limit_spike.ui.NoticeCell")

function NoticeCell:ctor()
    NoticeCell.super.ctor(self)

    self.model = require("time_limit_spike.src.Model")
    self.service = require("time_limit_spike.src.Service")

    self:InjectView("Text_1")
    self:InjectView("Node_1")
    self:InjectView("Node_2")
    self:InjectView("Node_3")


  
 
end 

function NoticeCell:render(data1,data2,data3,idx)
    print("999===9994",data1)
    for k,v in pairs(data1) do
        print(k,v)
    end
    local date1 = data1.id
    local date2 = data2.id
    local date3 = data3.id
    local list = {}
    table.insert(list,date1)
    table.insert(list,date2)
    table.insert(list,date3)

    self.Text_1:setString(data1.stage)
    --三个奖励显示
    for e = 1,3 do
        self.data = self.model:GestAwardById(list[e])    
        local item = qy.tank.view.common.AwardItem.createAwardView(self.data[1].award[1] ,1)
        self["Node_"..e]:removeAllChildren() 
        self["Node_"..e]:addChild(item)            
        item:setScale(0.7)
        item.fatherSprite:setSwallowTouches(false)
        item.name:setVisible(false)
    end
end  

	
function NoticeCell:onExit()

end


function NoticeCell:onEnter()

    
end

return NoticeCell

