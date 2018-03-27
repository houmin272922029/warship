--[[
	战狼归来
	
]]

local RushPurchaseDialog = qy.class("RushPurchaseDialog", qy.tank.view.BaseDialog, "fight_the_wolf.ui.MainDialog")

function RushPurchaseDialog:ctor()
    RushPurchaseDialog.super.ctor(self)
    self:setCanceledOnTouchOutside(true)
    self.model = require("fight_the_wolf.src.Model")
    self.service = require("fight_the_wolf.src.Service")
    --更行总体数据
    --self.userInfo = qy.tank.model.UserInfoModel
 
    
	self:InjectView("Close")
	self:InjectView("Text_1")
	self:InjectView("Button_1")
	self:InjectView("Button_2")
    self:InjectView("Button_3")
    self:InjectView("Button_4")
    self:InjectView("Button_5")
    self:InjectView("Button_6")
    
	self:OnClick("Close", function()
		self:onExit()
        self:removeSelf()
    end,{["audioType"] = qy.SoundType.COMMON_CLICK, ["isScale"] = false})	
    print("战狼归来")
    --界面六个按钮点击事件
    for i=1,6 do
        self:OnClick("Button_"..i, function(sender)
            require("fight_the_wolf.src.MainDialog1").new(i,{
                ["Callback"] = function (id)
                    print("这个是大关卡按钮变灰的回调函数",id)
                    for i=1,6 do
                        self["Button_"..i]:setTouchEnabled(i==id+1)
                        self["Button_"..i]:setBright(i==id+1)
                    end                               
                end
                }):show(true)
        end,{["isScale"] = false})
    end

    --self["Button_".."6"]:setVisible(false)
    local received = self.model.extendsdata
    --进来判断哪个按钮应该显示
    for i=1,6 do
        self["Button_"..i]:setTouchEnabled(i==#received+1)
        self["Button_"..i]:setBright(i==#received+1)
    end    
end

function RushPurchaseDialog:render()
   local startTime = os.date(qy.TextUtil:substitute(61001),self.model.start_time)
    local endTime = os.date(self.model.end_time)
    self:createTimer1()
end

--创建定时器1
function RushPurchaseDialog:createTimer1()
	local endTime = os.date(self.model.end_time)
	local endTime2 = os.date("%Y.%m.%d",self.model.end_time)
	local currentTime=os.time()
    local remainTime1 =endTime-currentTime
      
    if remainTime1 <=0 then 
        self:clearTimer()
        self:updateLeftTime(0)
        return
    end

    if self.timer1 == nil then
        self.timer1 = qy.tank.utils.Timer.new(1,remainTime1,function(leftTime)
            self:updateLeftTime(leftTime)
        end)
        self.timer1:start()
    end
    self:updateLeftTime(remainTime1)
end

--更新剩余时间
function RushPurchaseDialog:updateLeftTime(leftTime)
    if leftTime == 0 then        
        self:clearTimer()
        self.Text_1:setString(""..leftTime)
    else
       local timeStr = qy.tank.utils.DateFormatUtil:toDateString1(leftTime , 1)
        self.Text_1:setString(timeStr)
    end
end

-- 清除时钟
function RushPurchaseDialog:clearTimer( )
    if self.timer1 ~=nil then
        self.timer1:stop()
    end       
    self.timer1 = nil
end

function RushPurchaseDialog:onExit()
	self:clearTimer()
end


function RushPurchaseDialog:onEnter()
    print("RushPurchaseDialog================")
    self:createTimer1()
    
end

return RushPurchaseDialog

