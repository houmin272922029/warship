local ItemView = qy.class("ItemView", qy.tank.view.BaseView, "daily_snap_up.ui.ItemView")
local service = require("daily_snap_up.src.Service")
--local service = qy.tank.service.OperatingActivitiesService
local  Model = require("daily_snap_up.src.Model")
local NodeUtil = qy.tank.utils.NodeUtil
function ItemView:ctor(countpersonal,countbuy,delegate)
   	ItemView.super.ctor(self)
   	self.count = countpersonal+countbuy
    self.countpersonal = countpersonal
    self.countbuy = countbuy
   	self:InjectView("Buybtn")
   	self:InjectView("Title_name")
   	self:InjectView("Text_4")
   	self:InjectView("Text_2")
    self:InjectView("Text_3")
    --self:InjectView("Text_5")
   	self:InjectView("Sprite_3")
   	self:InjectView("Sprite_1")
   	self:InjectView("Sprite_2")
    self:InjectView("Sprite_4")
    self:InjectView("Image_1")
    self:InjectView("Text_1")
    self:InjectView("Text_surplus")
    --self:InjectView("Text_value")
    self:InjectView("Text_hour")
    self:InjectView("Image_2")
    self.sta = 1
    --奖品内容显示 触摸事件
    self:OnClickForBuilding("Image_2",function( )
      require("daily_snap_up.src.Tip").new(self.data.id,self.id):show()
    end)

    --开始够买
   	self:OnClick("Buybtn", function()       
      print("点击购买")
      local id = "tk"..self.data.price --self.data.price --价格
      local Rechargdata = qy.tank.model.RechargeModel.data[id]
      qy.tank.service.DailywelfareService:paymentBegin(Rechargdata, function(flag, msg)
          if flag == 3 then
              self.toast = qy.tank.widget.Toast.new()
              self.toast:make(self.toast, qy.TextUtil:substitute(58001))
              self.toast:addTo(qy.App.runningScene, 1000)
          elseif flag == true then
              self.toast:removeSelf()
              --充值成功走刷新逻辑
              qy.hint:show(qy.TextUtil:substitute(58002))
              --弹出奖励                              
                  if self.id == 1 then
                    print("走个人的")
                    Model:updatePersonal(self.data.id)
                  elseif self.id == 2 then
                    self.sta = 2
                    print("走抢购")
                    Model:updateBuy(self.data.id)
                    Model:updateBuyedList(self.data.id)
                  end
                    qy.tank.command.AwardCommand:add(self.data.award)
                    qy.tank.command.AwardCommand:show(self.data.award,{["isShowHint"]=false})--当只有一个奖励的时候也要弹窗显示   
                    delegate:callback()
          else
              self.toast:removeSelf()
              qy.hint:show(msg)                    
          end
      end,self.id,self.data.id) 
    end,{["audioType"] = qy.SoundType.COMMON_CLICK, ["isScale"] = false})    
end

function ItemView:render(data,idx,id)--id 1为个人 2为抢购    
    self.id = id
    self.index = idx
    self.data = data
    self.Text_3:setVisible(id == 2)
    self.Text_hour:setVisible(id == 2)
    self.Text_surplus:setVisible(id == 2)
    self.Text_4:setString(data.price.."元")
    self:createTimer1()
    self.Sprite_4:setVisible(id == 2)
    self.Title_name:setString(data.title)
    local Sprite=cc.Sprite:create("daily_snap_up/res/"..data.icon..".jpg")
    self.Sprite_1:setSpriteFrame(Sprite:getSpriteFrame())
    if id == 1 then
      self.Text_hour:setVisible(false)
      self.Sprite_3:setVisible(data.type == 2)
      self.Text_2:setVisible(data.type == 2)
      self.Text_2:setString("火爆")
      local status = Model:getstatusBy(data.id)
      self.Image_1:setVisible(status == 1)
      for i = 1,3 do
         NodeUtil:darkNode(self["Sprite_"..i], status == 1)
      end
      self.Buybtn:setTouchEnabled(status == 0)
      self.Buybtn:setBright(status == 0) 
    else      
      self.Sprite_3:setVisible(false)
      self.Image_1:setVisible(false)
      self.Text_2:setVisible(data.type == 1)
      self.Text_2:setString("抢购")
      for i = 1,3 do
           NodeUtil:darkNode(self["Sprite_"..i],false)
      end
      
      local status = Model:GetBuyStatusById(data.id)
      local nums = data.num - Model:getnumsByid(data.id)
      
      print("status111",status)
      if nums <= 0 then
          self.Text_surplus:setString(""..0)
          self.Buybtn:setTouchEnabled(false)
          self.Buybtn:setBright(false) 
          self.Text_hour:setVisible(false)
      else
          self.Text_surplus:setString(""..nums)
          self.Buybtn:setTouchEnabled(status == 0 )
          self.Buybtn:setBright(status == 0 ) 
          -- self.Text_hour:setVisible(status == 0)
          local timenums = self:getstatus()
          if status == 1 then
              self.Text_hour:setVisible(false)
          else
              self.Text_hour:setVisible(timenums > 0)
          end
      end 
      -- if self.remain > 0 then --剩余时间
      --   self.Text_surplus:setString(""..nums)
      --   self.Buybtn:setTouchEnabled(true)
      --   self.Buybtn:setBright(true)
      -- elseif nums <= 0 then   --剩余数量
      --   self.Text_surplus:setString(""..0)
      --   self.Buybtn:setTouchEnabled(false)
      --   self.Buybtn:setBright(false)
      -- else
      --   self.Text_surplus:setString(""..nums)
      --   self.Buybtn:setTouchEnabled(status == 0 )
      --   self.Buybtn:setBright(status == 0 )
      -- end 

              
    end   
end
function ItemView:getstatus(  )
   if self.data.hour ~= nil then
        ent_time = self.data.hour
    else
        ent_time = 0
    end

    local time1 = os.date("*t",Model.current_time)
    local endTime = ent_time * 3600 
    local currentTime = time1.hour * 3600 + time1.min * 60 + time1.sec
    local remainTime1 = endTime - currentTime
    --local remainTime1 = 1505121000 - Model.current_time --1505120745
    return remainTime1
end
--创建定时器1
function ItemView:createTimer1()    
    if self.data.hour ~= nil then
        ent_time = self.data.hour
    else
        ent_time = 0
    end

    local time1 = os.date("*t",Model.current_time)
    local endTime = ent_time * 3600 
    local currentTime = time1.hour * 3600 + time1.min * 60 + time1.sec
    local remainTime1 = endTime - currentTime
    --local remainTime1 = 1505121000 - Model.current_time
    -- self.remain = remainTime1
    
      
    if remainTime1 <= 0 then 
        self:clearTimer()
        self:updateLeftTime(0)
        self.Text_hour:setVisible(false)
        return
    end

    if self.timer1 == nil then
        self.timer1 = qy.tank.utils.Timer.new(1,remainTime1,function(leftTime)
            -- Model.current_time = Model.current_time + 1
            self:updateLeftTime(leftTime)
        end)
        self.timer1:start()
    end
    self:updateLeftTime(remainTime1)
end

--更新剩余时间
function ItemView:updateLeftTime(leftTime)
    if leftTime == 0 then        
        self:clearTimer()
        self.Text_hour:setVisible(false)
        
    else
       --local timeStr = qy.tank.utils.DateFormatUtil:toDateString1(leftTime,1)
        local timeStr = self:toDateString1(leftTime,1)
        self.Text_hour:setString(timeStr.."后开启")
    end
end

-- 清除时钟
function ItemView:clearTimer( )
    if self.timer1 ~= nil then
        self.timer1:stop()
    end       
    self.timer1 = nil
end

--时间显示的类型
function ItemView:toDateString1(t,type)
    local timeStr
    local time = t
    local day = math.floor(time/3600/24) .. ""
    time = time%(3600*24)
    local hour =   math.floor(time/3600) .. ""
    time = time%3600
    local min = math.floor(time/60) .. ""
    time = time%60
    local sec = time .. ""
    if string.len(hour) == 1 then
        hour = "0" .. hour
    end
    if string.len(min) == 1 then
        min = "0" .. min
    end
    if string.len(sec) == 1 then
        sec = "0" .. sec
    end
    if type == nil then 
        timeStr = day .. ":" .. hour .. ":" .. min .. ":" .. sec
    elseif type ==1 then
        --timeStr = day .. qy.TextUtil:substitute(70014) .. hour .. qy.TextUtil:substitute(70015) .. min .. qy.TextUtil:substitute(70016) .. sec .. qy.TextUtil:substitute(70017)
          timeStr = hour .. qy.TextUtil:substitute(70015) .. min .. qy.TextUtil:substitute(70016) .. sec .. qy.TextUtil:substitute(70017)
    elseif type == 2 then
        timeStr = day .. "d" .. hour .. "h" .. min .. "m" .. sec .. "s"
    end
    return timeStr
end

function ItemView:onExit()
  self:clearTimer()
end

function ItemView:onEnter()
  -- self:createTimer1()      
end

return ItemView
