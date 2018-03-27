--[[
限时秒杀
	
]]

local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "time_limit_spike.ui.MainDialog")

function MainDialog:ctor()
    MainDialog.super.ctor(self)
    self:setCanceledOnTouchOutside(true)
    self.model = require("time_limit_spike.src.Model")
    self.service = require("time_limit_spike.src.Service")

    self:InjectView("Button_9") --去充值按钮
    self:InjectView("Btn_Close")--关闭按钮
    self:InjectView("Button_6")
    self:InjectView("Button_7")
    self:InjectView("Button_8")
    self:InjectView("Hour_1")--倒计时
    self:InjectView("Hour_2")
    self:InjectView("Hour_3")
    self:InjectView("Node_2")
    self:InjectView("Node_3")
    self:InjectView("Node_1")
    self:InjectView("Image_1")--参加 文字
    self:InjectView("Image_2")
    self:InjectView("Image_3")
    self:InjectView("Image_12")--抽奖中 文字
    self:InjectView("Image_13")
    self:InjectView("Image_14")
    self:InjectView("Button_1")
    self:InjectView("Button_2")
    self:InjectView("Button_3")
    self:InjectView("Text_3")
    self:InjectView("Text_1")--期数
    self:InjectView("Nums_1")--参与人数
    self:InjectView("Nums_2")
    self:InjectView("Nums_3")
    self:InjectView("Text_34")
    self:InjectView("Times_1")
    self:InjectView("Times_2")
    self:InjectView("Times_3")
    self:InjectView("Texttime1")
    self:InjectView("Texttime2")
    self:InjectView("Texttime3")
    self:InjectView("People_1")
    self:InjectView("People_2")
    self:InjectView("People_3")
    self:InjectView("Text_num1")
    self:InjectView("Text_num2")
    self:InjectView("Text_num3")
    self:InjectView("Text_wu1")
    self:InjectView("Text_wu2")
    self:InjectView("Text_wu3")
    
    self:OnClick("Button_6",function (  )          
        self.service:getList(2,function (response)
            require("time_limit_spike.src.LuckyDialog").new(response):show(true)--幸运指挥官
        end)
    end)

    self:OnClick("Button_7",function (  )
        require("time_limit_spike.src.NoticeDialog").new():show()--秒杀预告
    end)

    self:OnClick("Button_8",function (  )
        self.service:getInfo(function ()
            self.service:getList(2,function (response)
            require("time_limit_spike.src.SuperDialog").new(self,response):show()--超级大奖
            end) 
        end)        
    end)

    for i=1,3 do
        self:OnClick("Button_"..i,function (  )
            print("777---777",self.date.current_list[i].id)
            self.service:getAward(1,self.date.current_list[i].id,function ( )
                 self.model:AddNum(i)
                 self:update(2)
            end)

        end)
    end

    self:OnClick("Btn_Close",function ( )
        self:removeSelf()
    end)

    self:OnClick("Button_9",function ( )
        self:removeSelf()
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.RECHARGE)--跳转到充值界面
    end)

    self:update(1)
    local x = self.model:GetYuGaoStatus()
     self.Button_7:setTouchEnabled(x == 0)
     self.Button_7:setBright(x == 0)
end  


function MainDialog:update(isRefresh)
    if self.model.data.current_list[1] ~= nil then
        if isRefresh == 1 then
        --倒计时
        if self.model.data.current_list[1].special == 0 then
            local time = self.model.data.current_list[1].last_seconds
            print("99999",time)--未知时间
            self:createTimer1(tonumber(1),tonumber(time))
        else
            self.time = self.model.data.current_list[1].last_seconds
            print("10101",time)--3000
            self:createTimer1(tonumber(2),tonumber(self.time))    
        end
        else
        end    

        --限时活动持续时间
        local startTime = os.date("%Y年%m月%d日",self.model.data.start_time)
        local endTime = os.date("%Y年%m月%d日",self.model.data.end_time)
        self.Text_3:setString(startTime..qy.TextUtil:substitute(52003)..endTime)

        self.date = self.model.data
        --限时期数
        self.Text_1:setString(self.date.current_list[1].stage)

        --参与人数跟总人数
        for a = 1,3 do
            self["Nums_"..a]:setString(self.date.current_list[a].current_join_times.."/"..self.date.current_list[a].max_join_times)
        end

        --参与次数
        for b=1,3 do
            self["Times_"..b]:setString(self.date.current_list[b].my_join_times)
        end

        --限时拥有次数
        self.Text_34:setString(self.date.last_join_times)

        --按钮状态以及文字显示 1 参加中   2 抽奖中
        local button_stattus = self.model:GetButtonStatus()
        print("000..000",button_stattus)
        for c = 1,3 do
            self["Button_"..c]:setTouchEnabled(button_stattus == 0)
            self["Button_"..c]:setBright(button_stattus == 0)
            self["Image_"..c]:setVisible(button_stattus == 0)
            self["Image_"..(c + 11)]:setVisible(button_stattus == 1)
        end


        --三个奖励显示
        for e=1,3 do
            self.data = self.model:GestAwardById(tonumber(self.date.current_list[e].id))                   
            local item = qy.tank.view.common.AwardItem.createAwardView(self.data[1].award[1] ,1)
            self["Node_"..e]:removeAllChildren(true)
            self["Node_"..e]:addChild(item)            
            item:setScale(0.8)
            item.fatherSprite:setSwallowTouches(false)
            item.name:setVisible(false)        
        end
    elseif self.model.data.current_list[1] == nil then
        self.date = self.model.data
        --限时拥有次数
        self.Text_34:setString(self.date.last_join_times)

        --限时活动持续时间
        local startTime = os.date("%Y年%m月%d日",self.model.data.start_time)
        local endTime = os.date("%Y年%m月%d日",self.model.data.end_time)
        self.Text_3:setString(startTime..qy.TextUtil:substitute(52003)..endTime)

        for c = 1,3 do
            self["Button_"..c]:setVisible(false)
            self["Image_"..c]:setVisible(false)
            self["Image_"..(c + 11)]:setVisible(false)
        end
        for i=1,3 do
            self["Texttime"..i]:setVisible(false)
            self["Hour_"..i]:setVisible(false)
            self["People_"..i]:setVisible(false)
            self["Nums_"..i]:setVisible(false)
            self["Text_num"..i]:setVisible(false)
            self["Times_"..i]:setVisible(false)
            self["Text_wu"..i]:setString("暂无秒杀")
            self["Node_"..i]:setVisible(false)
        end
        self.Text_1:setString("")

    end
end

--创建定时器1
function MainDialog:createTimer1(id,remainTime1)
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
function MainDialog:updateLeftTime(id,leftTime)
    if leftTime == 0 then        
        self:clearTimer()
        if id == 1 then
            print("走的1")
            for i = 1,3 do      
                self["Hour_"..i]:setString("00:00:00")
            end
            --self.model:AddButtonStatus()
            --self:update()
            self.service:getInfo(function (  )
                print("getInfo")
                self:update(1)
            end)
            --self:createTimer1(tonumber(2),tonumber(5))
        elseif id == 2 then
             print("走的2")
            -- self.model:SubButtonStatus()
            -- self:update()
            self.service:getInfo(function (  )
                print("getInfo")
                self:update(1)
            end)
        end
    else
       --local timeStr = qy.tank.utils.DateFormatUtil:toDateString(leftTime)
        if id == 1 then
            print("走的3")
            local timeStr = qy.tank.utils.DateFormatUtil:toDateString(leftTime)
            print("走的4",timeStr)
            for i = 1,3 do
                self["Hour_"..i]:setString(timeStr)
            end
        elseif id == 2 then
            print("走的22")
            for i = 1,3 do
                self["Hour_"..i]:setString("00:00:00")
            end
        end 
    end
end

-- 清除时钟
function MainDialog:clearTimer( )
    if self.timer1 ~= nil then
        self.timer1:stop()
    end       
    self.timer1 = nil
end
	
function MainDialog:onExit()
    self:clearTimer()
end


function MainDialog:onEnter()
    --self:createTimer1(tonumber(1),tonumber(3))
    --self:createTimer1(tonumber(2),tonumber(8))  
    print("000-999")  
end

return MainDialog

