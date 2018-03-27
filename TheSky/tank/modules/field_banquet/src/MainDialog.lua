--[[
	
]]

local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "field_banquet.ui.MainDialog")

function MainDialog:ctor()
    MainDialog.super.ctor(self)
    self.model = qy.tank.model.FieldBanquetModel
    self.service = qy.tank.service.FieldBanquetService

    self:InjectView("Btn_close")
    self:InjectView("Node_4") --今日最佳商品
    self:InjectView("Txt_num")  --购物卡数量
    self:InjectView("Btn_refresh")  --右下角的刷新按钮
    self:InjectView("Btn_shop")  
    self:InjectView("Btn_banquet")  
    self:InjectView("Bnt_jieshao") 

    self:InjectView("Text_3")  
    self:InjectView("Txt_g")
    self:InjectView("Txt_time")  
    for i=1,3 do
        self:InjectView("Node_"..i) --放置三个奖励
        self:InjectView("Txt_comsumption_my_"..i) --我当前消耗的钻石
        self:InjectView("Txt2_comsumption_all_"..i)  --需要消耗的总钻石 然后才能解锁
        self:InjectView("Button_"..i)  --三个购买的按钮
        self:InjectView("Btn_jihuo_"..i) --三个激活按钮
        self:InjectView("Btn_refresh_"..i)  --三个刷新按钮
        self:InjectView("Text_baoji_"..i)  --三个暴击百分比文字
        self:InjectView("Txt_zuanshi_"..i) --三个需要消耗钻石文字
        self:InjectView("Txt_huiji_"..i) --三个购买按钮需要消耗的钻石
        self:InjectView("Showqing_"..i) --三个售罄图片
        self:InjectView("Txt_comsumption_all_"..i) --三个总消耗
        self:InjectView("Text_wenzi_"..i)
    end

    self:OnClick("Btn_close",function (  )
        self:removeSelf()
    end)

    self:OnClick("Btn_shop",function (  )
        self.model:set_page1()
        self:set_page()
        self:set_button_color()
        self:setShop()
    end)

    self:OnClick("Btn_banquet",function (  )
        self.model:set_page2()
        self:set_page()
        self:set_button_color()
        self:setHuiji()
    end)

    self:OnClick("Btn_refresh",function (  ) --刷新三个奖励显示的按钮
        self.service:getRefresh("refresh_shop",function (  )
            self:setShop()
        end)
    end)

    self:OnClick("Bnt_jieshao", function()
        qy.tank.view.common.HelpDialog.new(55):show(true)
    end)

    for i=1,3 do
        self:OnClick("Button_"..i, function()
            self.service:getAward("buy",i,function (  )
                local id = self.model.data.user_activity_data.list[tostring(i)].config_id
                local data = self.model:getAward(id)
                self:setShop()
            end)
        end,{["isScale"] = false})

        self:OnClick("Btn_refresh_"..i,function (  )
            self.service:getRefresh2("refresh_attr",i,function (  )
                self:setHuiji()
            end,{["isScale"] = false})
        end)

        self:OnClick("Btn_jihuo_"..i,function (  )
            self.service:getJihuo("active_attr",i,function (  )
                qy.hint:show("此属性已经激活")
                self:setHuiji()
            end,{["isScale"] = false})
        end)
    end
    self:set_page()
    self:set_button_color()
    self:setShop()
    self:setZuijia()
end

--最佳商品
function MainDialog:setZuijia(  )
    local id = self.model.data.user_activity_data.day
    local list = self.model:getZuijia(id)
    local item = qy.tank.view.common.AwardItem.createAwardView(list[1].award[1] ,1)
    self.Node_4:addChild(item)
    item:setScale(0.7)
    item.fatherSprite:setSwallowTouches(false)
    item.name:setVisible(false)
end

function MainDialog:set_button_color(  )
    local status = self.model.interface
    self.Btn_shop:setBright(status == 1)
    self.Btn_banquet:setBright(status == 0)
end
-- id 0 显示商店   1 显示设宴
function MainDialog:set_page()
    local status = self.model.interface
    --商店应该显示的东西
    for i=1,3 do
        self["Button_"..i]:setVisible(status == 0)

        self["Btn_jihuo_"..i]:setVisible(status == 1)
        self["Text_wenzi_"..i]:setVisible(status == 1)
        
    end
    self.Text_3:setVisible(status == 0)
    self.Btn_refresh:setVisible(status == 0)
    self.Node_4:setVisible(status == 0)
end

--宴会界面
--消耗的徽记 Txt_comsumption_my_1 ，拥有的徽记 Txt_num ,所需消耗总徽记 Txt_comsumption_all_1 Txt2_comsumption_all_2
function MainDialog:setHuiji(  )
    local data = self.model.data
    self.Txt_num:setString(data.user_activity_data.point)
    for i=1,3 do
        local price = self.model.data.attr_position_level[tostring(i)]
        self["Txt_comsumption_all_"..i]:setString(price)
        self["Txt2_comsumption_all_"..i]:setString("已消耗:")
        self["Txt_comsumption_my_"..i]:setString(data.user_activity_data.total_desc_point)
        self["Txt_zuanshi_"..i]:setString("徽记X"..data.active_attr_desc_point)
        if self.model.data.user_activity_data.attr[tostring(i)] then
            local id = self.model.data.user_activity_data.attr[tostring(i)].config_id
            local data = self.model:getattr(id)
            self:set_attr_type(i,data.attr_type,data.attr_num,data.quality)
        end
        local status = self.model.data.user_activity_data.total_desc_point >= price  and 1 or 0
        --local status = 600 > price  and 1 or 0
        self["Text_wenzi_"..i]:setVisible(status == 0)
        self["Btn_jihuo_"..i]:setVisible(status == 1)

        if self.model.data.user_activity_data.attr[tostring(i)] then
            local button_status = self.model.data.user_activity_data.attr[tostring(i)].is_active
            self["Btn_jihuo_"..i]:setTouchEnabled(button_status == 0)
            self["Btn_jihuo_"..i]:setBright(button_status == 0)
            self["Btn_refresh_"..i]:setTouchEnabled(button_status == 0)
            self["Btn_refresh_"..i]:setBright(button_status == 0)
        end
    end
end

--商城界面
--购买所需徽记 Txt_huiji_1
function MainDialog:setShop(  )
    local data = self.model.data
    self.Txt_num:setString(data.user_activity_data.point)
    for i=1,3 do
        self["Node_"..i]:removeAllChildren(true)
    end
    for i=1,3 do
        local id = self.model.data.user_activity_data.list[tostring(i)].config_id
        local data = self.model:getAward(id)

        local item = qy.tank.view.common.AwardItem.createAwardView(data.award[1] ,1)
        self["Node_"..i]:addChild(item)
        item:setScale(0.8)
        item.fatherSprite:setSwallowTouches(false)
        item.name:setVisible(false)
        self["Txt_huiji_"..i]:setString("徽记X"..data.price)

        local status = self.model.data.user_activity_data.list[tostring(i)].is_get --0
        self["Showqing_"..i]:setVisible(status == 1) 
        --self["Node_"..i]:setVisible(status == 0)
        self["Button_"..i]:setTouchEnabled(status == 0)
        self["Button_"..i]:setBright(status == 0)
    end
    
end

function MainDialog:set_attr_type(idx,id,num,quality)
    local Txt_attr_type = ""
    local attr_num = 0
    if id == 1 then
        Txt_attr_type = "攻击"
        attr_num = num
    elseif id == 2 then
        Txt_attr_type = "防御"
        attr_num = num
    elseif id == 3 then
        attr_num = num
        Txt_attr_type = "生命"
    elseif id == 4 then
        attr_num = num
        Txt_attr_type = "穿深"
    elseif id == 5 then
        attr_num = num
        Txt_attr_type = "穿深抵抗"
    elseif id == 6 then
        Txt_attr_type = "命中"
        attr_num = num / 10
    elseif id == 7 then
        Txt_attr_type = "闪避"
        attr_num = num / 10
    elseif id == 8 then
        Txt_attr_type = "暴击率"
        attr_num = num / 10
    elseif id == 9 then
        Txt_attr_type = "暴击减免"
        attr_num = num / 10
    elseif id == 10 then
        Txt_attr_type = "暴击伤害"
        attr_num = num / 10
    elseif id == 11 then
        Txt_attr_type = "暴击伤害减免"
        attr_num = num / 10
    end
    if id <= 5 then
        self["Text_baoji_"..idx]:setString(Txt_attr_type.."+"..attr_num)
        if quality ==  2 then
            self["Text_baoji_"..idx]:setColor(cc.c3b(46, 190, 83))
        elseif quality == 3 then
            self["Text_baoji_"..idx]:setColor(cc.c3b(36, 174, 242))
        elseif quality == 4 then
            self["Text_baoji_"..idx]:setColor(cc.c3b(172, 54, 249))
        elseif quality == 5 then
            self["Text_baoji_"..idx]:setColor(cc.c3b(255, 153, 0))
        elseif quality == 6 then
            self["Text_baoji_"..idx]:setColor(cc.c3b(255, 0,0))
        end
    else
        self["Text_baoji_"..idx]:setString(Txt_attr_type.."+"..attr_num.."%")
        if quality ==  2 then
            self["Text_baoji_"..idx]:setColor(cc.c3b(46, 190, 83))
        elseif quality == 3 then
            self["Text_baoji_"..idx]:setColor(cc.c3b(36, 174, 242))
        elseif quality == 4 then
            self["Text_baoji_"..idx]:setColor(cc.c3b(172, 54, 249))
        elseif quality == 5 then
            self["Text_baoji_"..idx]:setColor(cc.c3b(255, 153, 0))
        elseif quality == 6 then
            self["Text_baoji_"..idx]:setColor(cc.c3b(255, 0,0))
        end
    end

    
end

--创建定时器1
function MainDialog:createTimer1()
     local enttime = self.model.end_time
     local starttime = self.model.start_time
     local remainTime1 = enttime - starttime
      
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
function MainDialog:updateLeftTime(leftTime)
    if leftTime == 0 then        
        self:clearTimer()
        self.Txt_time:setString(""..leftTime)
    else
       local timeStr = qy.tank.utils.DateFormatUtil:toDateString1(leftTime , 1)
        self.Txt_time:setString(timeStr)
    end
end

-- 清除时钟
function MainDialog:clearTimer( )
    if self.timer1 ~=nil then
        self.timer1:stop()
    end       
    self.timer1 = nil
end

function MainDialog:onExit()
    self:clearTimer()
end

function MainDialog:onEnter(  )
    self:createTimer1()
end

return MainDialog

