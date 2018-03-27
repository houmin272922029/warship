--[[
	限时秒杀
	
]]

local LuckyCell = qy.class("LuckyCell", qy.tank.view.BaseView, "time_limit_spike.ui.LuckyCell")

function LuckyCell:ctor()
    LuckyCell.super.ctor(self)

    self:InjectView("Image_1")
    self:InjectView("Text_1")
    self:InjectView("Text_2")
    self:InjectView("Text_3")
    self:InjectView("Node_1")

    self.model = require("time_limit_spike.src.Model")
    self.service = require("time_limit_spike.src.Service")

end  
	
function LuckyCell:render(data,idx)
        self.Text_3:setString(data.join_times)
        self.Text_1:setString(""..data.server.." "..data.nickname)
        self.Text_2:setString(data.stage)
        self.Node_1:removeAllChildren(true)
        if data.award ~=nil then
            for i = 1,#data.award do    
                local item = qy.tank.view.common.AwardItem.createAwardView(data.award[1] ,1)

                self.Node_1:addChild(item)
                item:setScale(0.7)
                item.fatherSprite:setSwallowTouches(false)
                item.name:setVisible(false)
            end 
        end
        
end  

function LuckyCell:onExit()

end


function LuckyCell:onEnter()

    
end

return LuckyCell

