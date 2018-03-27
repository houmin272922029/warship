--[[
	
	限时秒杀
]]

local SuperDialog = qy.class("SuperDialog", qy.tank.view.BaseDialog, "time_limit_spike.ui.SuperDialog")

function SuperDialog:ctor(delegete,response)
    SuperDialog.super.ctor(self)
    self:setCanceledOnTouchOutside(false)
    self.model = require("time_limit_spike.src.Model")
    self.service = require("time_limit_spike.src.Service")

    self.response = response

    self:InjectView("Node_2")
    self:InjectView("Button_1")
    self:InjectView("Text_2")--拥有次数
    
    
    self:InjectView("Image_3")
    self:InjectView("Image_4")
    
    self:InjectView("Text_1")

    self:InjectView("Text_3")
    self:InjectView("Text_4")
    self:InjectView("Text_5")
    self:InjectView("Text_6")
    self:InjectView("Text_7")
    self:InjectView("Text_8")
    self:InjectView("Text_9")
    self:InjectView("Text_10")

    self.style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(500,480),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "time_limit_spike/res/16.png",

        ["onClose"] = function()
            self:removeSelf()
        end
    })
    self:addChild(self.style,-1)

    self:OnClick("Button_1",function ( )
        self.service:getAward(1,self.date.current_big_list[1].id,function ( )
             self.model:SubNum(4)
             self:updata()
             delegete:update(2)
        end)
    end)

    -- self:updata()
          
   --倒计时
   if self.model.data.current_big_list[1] ~= nil then
        if self.model.data.current_big_list[1].special == 0 then
            local time = self.model.data.current_big_list[1].last_seconds
            print("99999",time)--未知时间
            self:createTimer1(tonumber(1),tonumber(time))
        else
            self.time = self.model.data.current_big_list[1].last_seconds
            print("10101",time)--3000
            self:createTimer1(tonumber(2),tonumber(self.time))    
        end
    elseif self.model.data.current_big_list[1] == nil then
        
    end
    self:updata()
 
end 

function SuperDialog:updata( )
    if self.model.data.current_big_list[1] ~= nil then
    

        self.date = self.model.data
        --限时拥有次数
        self.Text_2:setString(self.date.last_join_times)

        --参与人数跟总人数            
        self.Text_4:setString(self.date.current_big_list[1].current_join_times.."/"..self.date.current_big_list[1].max_join_times)
           
        --按钮状态以及文字显示 1 参加中   2 抽奖中
        local button_stattus = self.model:GetSuperButtonStatus()
        
        self.Button_1:setTouchEnabled(button_stattus == 0)
        self.Button_1:setBright(button_stattus == 0)
        self.Image_3:setVisible(button_stattus == 0)
        self.Image_4:setVisible(button_stattus == 1)

        self.Text_8:setString(self.date.current_big_list[1].my_join_times)

        self.Node_2:removeAllChildren(true)
        self.award = self.model:GestAwardById2(tonumber(self.date.current_big_list[1].id))
        local item = qy.tank.view.common.AwardItem.createAwardView(self.award[1].award[1] ,1)
        self.Node_2:addChild(item)            
        item:setScale(0.8)
        item.fatherSprite:setSwallowTouches(false)
        item.name:setVisible(false)

    elseif self.model.data.current_big_list[1] == nil then
        for i=1,8 do
            self["Text_"..i]:setVisible(false)
        end
        self.Button_1:setVisible(false)
        for i=3,4 do
            self["Image_"..i]:setVisible(false)
        end

        print("11111000",#self.response)
        for i = 1,#self.response do
            if self.response[i].type == 2 then
                if self.response[i].kid ~= 0 then
                    self.Text_9:setString(self.response[i].server.." "..self.response[i].nickname)
                    self.Text_10:setString("参与次数: "..self.response[i].join_times)               
                   for i = 1,#self.response[i].award do    
                        local item = qy.tank.view.common.AwardItem.createAwardView(self.response[i].award[1] ,1)
                        self.Node_2:removeAllChildren(true)
                        self.Node_2:addChild(item)
                        item:setScale(0.8)
                        item.fatherSprite:setSwallowTouches(false)
                        item.name:setVisible(false)
                    end
                elseif self.response[i].kid == 0 then
                    self.Text_10:setString("无人参加")
                    self.Node_2:setVisible(false)
                end     
            end
        end

    end
               
end 
--创建定时器1
function SuperDialog:createTimer1(id,remainTime1)
    -- local endTime = os.date(self.model.end_time)
    -- local currentTime=os.time()
    --local remainTime1 = 3
      
    if remainTime1 <= 0 then 
        self:clearTimer()
        self:updateLeftTime(id,0)
        return
    end

    if self.timer1 == nil then
        self.timer1 = qy.tank.utils.Timer.new(1,remainTime1,function(leftTime)
            self:updateLeftTime(id,leftTime)
        end)
        self.timer1:start()
    end

    self:updateLeftTime(id,remainTime1)
end

--更新剩余时间
function SuperDialog:updateLeftTime(id,leftTime)
    if leftTime == 0 then        
        self:clearTimer()
        if id == 1 then      
            self.Text_6:setString("00:00:00")
            self.model:AddSuperButtonStatus()
            self:updata()
        elseif id == 2 then
            self.service:getList(2,function (response)
                self:Refresh(response)
            end)          
        end
    else
       if id == 1 then
            print("走的3")
            local timeStr = qy.tank.utils.DateFormatUtil:toDateString(leftTime)
            print("走的4",timeStr)
            self.Text_6:setString(timeStr)
        elseif id == 2 then
            self.Text_6:setString("00:00:00")
        end  
    end
end

-- 清除时钟
function SuperDialog:clearTimer( )
    if self.timer1 ~= nil then
        self.timer1:stop()
    end       
    self.timer1 = nil
end

function SuperDialog:Refresh(response)
    for i=1,8 do
            self["Text_"..i]:setVisible(false)
        end
        self.Button_1:setVisible(false)
        for i=3,4 do
            self["Image_"..i]:setVisible(false)
        end
    for i = 1,#response do
        if response[i].type == 2 then
            if response[i].kid ~= 0 then
                self.Text_9:setString(response[i].server.." "..response[i].nickname)
                self.Text_10:setString("参与次数: "..response[i].join_times)               
                for i = 1,#response[i].award do    
                    local item = qy.tank.view.common.AwardItem.createAwardView(response[i].award[1] ,1)
                    self.Node_2:removeAllChildren(true)
                    self.Node_2:addChild(item)
                    item:setScale(0.8)
                    item.fatherSprite:setSwallowTouches(false)
                    item.name:setVisible(false)
                end 
            elseif response[i].kid == 0 then
                self.Text_10:setString("无人参加")
                self.Node_2:setVisible(false)
            end
        end
    end
end
	
function SuperDialog:onExit()
    self:clearTimer()
end


function SuperDialog:onEnter()
        -- if self.model.data.current_big_list[1].special == 0 then
        --     local time = self.model.data.current_big_list[1].last_seconds
        --     print("99999",time)--未知时间
        --     self:createTimer1(tonumber(1),tonumber(time))
        -- else
        --     self.time = self.model.data.current_big_list[1].last_seconds
        --     print("10101",time)--3000
        --     --self:createTimer1(tonumber(2),tonumber(self.time))    
        -- end
    
end

return SuperDialog

