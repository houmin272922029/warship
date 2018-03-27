local MainView = qy.class("MainView", qy.tank.view.BaseView, "carray.ui.MainView")

local model = qy.tank.model.CarrayModel
local service = qy.tank.service.CarrayService
function MainView:ctor(delegate)
   	MainView.super.ctor(self)
    self:InjectView("BG")
   	self:InjectView("BG2")
   	self:InjectView("Buttom")
   	self:InjectView("Num1")
   	self:InjectView("Num2")
   	self:InjectView("Pages")
    self:InjectView("Btn_choose")
    self:InjectView("Btn_carray")
    self:InjectView("arrowTip")  
    self:InjectView("Image_3") 
    self:InjectView("Time") 
    self:InjectView("TimeBg") 

    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "Resources/activity/title_legion_escort.png", 
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
        local dialog = require("carray.src.ChooseDialog").new(self)
        dialog:show()
    end,{["isScale"] = false})

    self:OnClick("Btn_carray", function()
        service:getTeamList(function()
            local dialog = require("carray.src.CarrayListDialog").new(self)
            dialog:show()
        end)
    end,{["isScale"] = false})

    self:OnClick("BtnRight", function()
        if model.page + 1 > model.count then
            qy.hint:show(qy.TextUtil:substitute(44017))
        else
            service:getlist({
                ["page"] = model:getNextPage(),
            },function()
              self:updateCars()
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
              self:updateCars()
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
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsyncByModules("carray/fx/fx_ui_yunche",function()
        for i = 1, #model.list do
            local car = require("carray.src.CarView").new(model.list[i], i, self)
            local sec = model.list[i].end_time - qy.tank.model.UserInfoModel.serverTime

            local div = 1 - sec / (60 * 15)
          -- print("飒飒的方法  " .. div .. "   " .. qy.tank.model.UserInfoModel.serverTime .. "  " .. sec)
            car:setPosition(div * (display.width - 50), 500 - 100 * i)
            -- car:setPosition(100, 500 - 100 * i)
            self:addChild(car)
            table.insert(self.carList, car)
        end
    end)
end

function MainView:initMap()
    if model.count > 0 and not self.mapMove then
        self.BG:setPositionX(0)
        self.BG2:setPositionX(1280)
        local time = 15
        local func1 = cc.MoveTo:create(time, cc.p(-1280, 612))
        local func2 = cc.CallFunc:create(function()
            self.BG:setPositionX(1280)
        end)
        local func3 = cc.MoveTo:create(time, cc.p(0, 612))

        local seq = cc.Sequence:create(func1, func2, func3)
        local action = cc.RepeatForever:create(seq)
        self.BG:runAction(action)

        local func4 = cc.MoveTo:create(time, cc.p(0, 612))

        local func5 = cc.MoveTo:create(time, cc.p(-1280, 612))

        local func6 = cc.CallFunc:create(function()
            self.BG2:setPositionX(1280)
        end)

        local seq2 = cc.Sequence:create(func4, func5, func6)
        local action2 = cc.RepeatForever:create(seq2)
        self.BG2:runAction(action2)
        self.mapMove = true

        self:showArrayTip()
    end
end

function MainView:update()
    self.Num1:setString(model.left_escort_times)
    self.Num2:setString(model.left_rob_times) 
    
    self:updateCars()
    self:initMap()
    self:updateStatus()
end

function MainView:updateStatus()
    self.arrowTip:setVisible(model.status == 1)
    if model.status == 1 then
        self:showArrayTip()
    end

    self.Btn_choose:setEnabled(model.status == 0)
    self.Btn_carray:setEnabled(model.status == 1 or model.status == 2)

    if model.count > 0 then
        self.Pages:setString(model.page)
    else
        self.Pages:setString("1")
    end
end

function MainView:showArrayTip()
    self.arrowTip:stopAllActions()
    local moveUp = cc.MoveBy:create(0.2, cc.p(0,10))
    local moveDown = cc.MoveBy:create(0.2, cc.p(0,-10))
    local seq = cc.Sequence:create(callFunc, moveUp, moveDown)
    self.arrowTip:runAction(cc.RepeatForever:create(seq))
end

function MainView:updateCars()
    for i, v in pairs(self.carList) do
        v:removeSelf()
    end
    self.carList = {}

    for i = 1, #model.list do
        local car = require("carray.src.CarView").new(model.list[i], i, self)

        local sec = model.list[i].end_time - qy.tank.model.UserInfoModel.serverTime

        local div = 1 - sec / (60 * 15)

        car:setPosition(div * (display.width - 50), 500 - 100 * i)
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

    self.listener_2 = qy.Event.add(qy.Event.BONUS_TIME,function(event)
        if model.status == 3 then
            self.TimeBg:setVisible(true)
            local time = model.endTime - qy.tank.model.UserInfoModel.serverTime
            if time < 0 then
                time = 0
            end
            self.Time:setString(qy.tank.utils.DateFormatUtil:toDateString(time, 5))
        else
            self.TimeBg:setVisible(false)
        end
    end)

    self:showMessage()  --这里不要用信号，信号处理会出问题
    qy.Event.dispatch(qy.Event.BONUS_TIME)
    self:initMap()
end

function MainView:showMessage()
    if model.award and model.award[1] then -- 押运成功
        local data = qy.tank.view.common.AwardItem.getItemData(model.award[1])
        data.type = 1
        performWithDelay(self, function()
            local tips = require("carray.src.TipsDialog").new()
            tips:addRichText(data)
            tips:show()
            model.remind_list = {}
            model.award = nil
        end, 0.5)
    else
        if #model.remind_list > 0 and model.remind_list[1].is_win then  -- 被人抢劫
            local data = model.remind_list[1]
            
            performWithDelay(self, function()
                local tips = require("carray.src.TipsDialog").new()
                tips:addRichText(data)
                tips:show()
                model.remind_list = {}
            end, 0.5)
        end
    end
end

function MainView:onExit()
    self.mapMove = false
    qy.Event.remove(self.listener_1)
    qy.Event.remove(self.listener_2)
    -- if self.effect then
    --     qy.tank.utils.cache.CachePoolUtil.removeArmatureFileByModules("fx/temp/ui_fx_jinjie1")
    --     self.effect:getParent():removeChild(self.effect, true)
    -- end
end

return MainView
