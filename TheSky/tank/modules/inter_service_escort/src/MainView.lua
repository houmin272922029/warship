local MainView = qy.class("MainView", qy.tank.view.BaseView, "inter_service_escort.ui.MainView")

local model = qy.tank.model.InterServiceEscortModel
local service = qy.tank.service.InterServiceEscortService
function MainView:ctor(delegate)
   	MainView.super.ctor(self)
    self:InjectView("BG")
   	self:InjectView("BG2")
   	self:InjectView("Buttom")
   	self:InjectView("Num1")
   	self:InjectView("Num2")
   	self:InjectView("Pages")
    self:InjectView("Btn_choose")
    self:InjectView("icon_hd")
    self:InjectView("Btn_carray")
    self:InjectView("Image_3") 
    self:InjectView("Time") 
    self:InjectView("TimeBg") 

    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "inter_service_escort/res/kuafu.png", 
        showHome = false,
        ["onExit"] = function()
            delegate:finish()
        end
    })
    self:addChild(style)

    self.Buttom:setLocalZOrder(5)
    self.Image_3:setLocalZOrder(5)
    self.Btn_choose:setLocalZOrder(5)
    self.Btn_carray:setLocalZOrder(5)

   	self:OnClick("Btn_message", function()
        -- service:getLog(function()
        --     local dialog = require("carray.src.RecordDialog").new(self, delegate)
        --     dialog:show()
        -- end)
        delegate:showRecord(self)

    end,{["isScale"] = false})

    self:OnClick("Btn_choose", function()
        if self.Btn_choose:isBright() then
            local dialog = require("inter_service_escort.src.ChooseDialog").new(self)
            dialog:show()
        end
    end,{["isScale"] = false})

    self:OnClick("Btn_carray", function()
        if self.refresh_time <= 0 then
            service:get(function()
                self:update()
            end)            
            self.refresh_time = 10            
        else
            qy.hint:show("您点的太快了")
        end
    end,{["isScale"] = false})

    self:OnClick("BtnRight", function()
        if model.page + 1 > model.count then
            qy.hint:show(qy.TextUtil:substitute(44017))
        else
            service:getlist({
                ["page"] = model:getNextPage(),
            },function()
              self:update()
            end)  
        end
    end,{["isScale"] = false})

    self:OnClick("BtnLeft", function()
        if model.page <= 1 then
            qy.hint:show(qy.TextUtil:substitute(44018))
        else
            service:getlist({
                ["page"] = model:getPrePage(),
            },function()
              self:update()
            end)
        end
    end,{["isScale"] = false})

    self.TimeBg:setVisible(false)
    self.carList = {}
    self:initCars()
    self:initMap()

    self:updateStatus()
    self.Num1:setString(model.left_escort_times)
    self.Num2:setString(model.left_rob_times)
end

function MainView:initCars()
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsyncByModules("inter_service_escort/fx/fx_ui_yunche",function()
        for i = 1, #model.list do
            local car = require("inter_service_escort.src.CarView").new(model.list[i], i, self)
            local sec = model.list[i].end_time - qy.tank.model.UserInfoModel.serverTime

            local div = 1 - sec / (model:atRescoursById(model.list[i].goods_id).time)
            -- print("飒飒的方法  " .. div .. "   " .. qy.tank.model.UserInfoModel.serverTime .. "  " .. sec)
            car:setPosition(div * (display.width - 50), 600 - 65 * i)
            -- car:setPosition(100, 500 - 100 * i)
            self:addChild(car)
            table.insert(self.carList, car)
        end
    end)
end

function MainView:initMap()
    if #model.list > 0 and not self.mapMove then
        self.BG:setPositionX(0)
        self.BG2:setPositionX(1280)
        local time = 15
        local func1 = cc.MoveTo:create(time, cc.p(-1280, 712))
        local func2 = cc.CallFunc:create(function()
            self.BG:setPositionX(1280)
        end)
        local func3 = cc.MoveTo:create(time, cc.p(0, 712))

        local seq = cc.Sequence:create(func1, func2, func3)
        local action = cc.RepeatForever:create(seq)
        self.BG:runAction(action)

        local func4 = cc.MoveTo:create(time, cc.p(0, 712))

        local func5 = cc.MoveTo:create(time, cc.p(-1280, 712))

        local func6 = cc.CallFunc:create(function()
            self.BG2:setPositionX(1280)
        end)

        local seq2 = cc.Sequence:create(func4, func5, func6)
        local action2 = cc.RepeatForever:create(seq2)
        self.BG2:runAction(action2)
        self.mapMove = true

    end
end

function MainView:update()
    self.Num1:setString(model.left_escort_times)
    self.Num2:setString(model.left_rob_times) 
    
    self:updateCars()
    self:initMap()
    self:updateStatus()

    if model.log_new == 1 then
        self.icon_hd:setVisible(true)
    else
        self.icon_hd:setVisible(false)
    end
end

function MainView:updateStatus()   
    if model.count > 0 then
        self.Pages:setString(model.page)
    else
        self.Pages:setString("1")
    end
end


function MainView:updateCars()
    for i, v in pairs(self.carList) do
        self:removeChild(v)
    end
    self.carList = {}

    for i = 1, #model.list do
        local car = require("inter_service_escort.src.CarView").new(model.list[i], i, self)

        local sec = model.list[i].end_time - qy.tank.model.UserInfoModel.serverTime

        local div = 1 - sec / (model:atRescoursById(model.list[i].goods_id).time)

        car:setPosition(div * (display.width - 50), 600 - 65 * ((i - 1) % 8 + 1))
        -- car:setPosition(100, 500 - 100 * i)
        self:addChild(car)
        table.insert(self.carList, car)
    end
end

function MainView:makeText(text, color)
    return ccui.RichElementText:create(1, color or display.COLOR_WHITE, 255, text, qy.res.FONT_NAME, 22)
end

function MainView:onEnter()
    self.listener_1 = qy.Event.add(qy.Event.CARRAY,function(event)
        self:showMessage()
    end)


    self.refresh_time = 0
    self.listener_2 = qy.Event.add(qy.Event.BONUS_TIME,function(event)
        if model.status == 1 then
            self.TimeBg:setVisible(true)
            local time = model.endTime - qy.tank.model.UserInfoModel.serverTime
            if time < 0 then
                time = 0
            end
            self.Time:setString(qy.tank.utils.DateFormatUtil:toDateString(time, 5))
        else
            self.TimeBg:setVisible(false)
        end

        self.refresh_time = self.refresh_time - 1

        local hour = os.date("%H", qy.tank.model.UserInfoModel.serverTime)
        local time1 = qy.tank.model.UserInfoModel.serverTime
        -- if (hour == "11" or hour == "21") and model.status == 0 and model.left_escort_times > 0 then
        --     self.Btn_choose:setBright(true)//test
        -- else
        --     self.Btn_choose:setBright(true)
        -- end
        if ((time1 > model.appoint_time[1].start_time and time1 < model.appoint_time[1].end_time ) or (time1 > model.appoint_time[2].start_time and time1 < model.appoint_time[2].end_time )) and model.status == 0 and model.left_escort_times > 0 then
            self.Btn_choose:setBright(true)
        else
            self.Btn_choose:setBright(false)
        end
    end)


    self:update()
    qy.Event.dispatch(qy.Event.BONUS_TIME)
    self:initMap()
end

function MainView:showMessage()
    -- if model.award and model.award[1] then -- 押运成功
    --     local data = qy.tank.view.common.AwardItem.getItemData(model.award[1])
    --     data.type = 1
    --     performWithDelay(self, function()
    --         local tips = require("inter_service_escort.src.TipsDialog").new()
    --         tips:addRichText(data)
    --         tips:show()
    --         model.remind_list = {}
    --         model.award = nil
    --     end, 0.5)
    -- else
    --     if #model.remind_list > 0 and model.remind_list[1].is_win then  -- 被人抢劫
    --         local data = model.remind_list[1]
            
    --         performWithDelay(self, function()
    --             local tips = require("inter_service_escort.src.TipsDialog").new()
    --             tips:addRichText(data)
    --             tips:show()
    --             model.remind_list = {}
    --         end, 0.5)
    --     end
    -- end
end

function MainView:onExit()
    self.mapMove = false
    qy.Event.remove(self.listener_1)
    qy.Event.remove(self.listener_2)
    qy.Event.remove(self.listener_3)
    -- if self.effect then
    --     qy.tank.utils.cache.CachePoolUtil.removeArmatureFileByModules("fx/temp/ui_fx_jinjie1")
    --     self.effect:getParent():removeChild(self.effect, true)
    -- end
end

return MainView
