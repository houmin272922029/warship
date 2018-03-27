local MainView = qy.class("MainView", qy.tank.view.BaseView, "singlehero.ui.MainView")

local model = qy.tank.model.SingleHeroModel
local service = qy.tank.service.SingleHeroService
function MainView:ctor(delegate)
   	MainView.super.ctor(self)

    self:InjectView("Tank")
    self:InjectView("Btn_add")
    self:InjectView("Btn_Rank")
    self:InjectView("Num1")
    self:InjectView("Num2")
    self:InjectView("Times")

    self:OnClick("Btn_add", function()
        qy.tank.command.GarageCommand:showSelectedTankListDialog(false, function(uid)
            service:lineup(uid, function()
                self:update()
                qy.tank.command.GarageCommand:hideTankListDialog()
            end)
        end)
    end,{["isScale"] = false})

    self:OnClick("Btn_Close", function()
        delegate:finish()
    end,{["isScale"] = false})

    self:OnClick("Btn_list", function()
        if model.tank_unique_id > 0 then
            delegate:showList()
        else
            qy.hint:show(qy.TextUtil:substitute(62008))
        end
    end,{["isScale"] = false})

    self:OnClick("Btn_buy", function()
        delegate:showBuy()
    end,{["isScale"] = false})

    self:OnClick("Btn_Rank", function()
        delegate:showRank()
    end,{["isScale"] = false})

    self:playMessageAnimation(self.Btn_add)
end


function MainView:update()
    self.Num1:setString(qy.tank.model.UserInfoModel.userInfoEntity.diamond or 0)
    self.Num2:setString(qy.tank.model.UserInfoModel.userInfoEntity.soul_fragment or 0)
    local times = model.buy_times + model.left_free_times
    self.Times:setString(qy.TextUtil:substitute(62009) .. times .. qy.TextUtil:substitute(62010))

    if model.tank_unique_id > 0 then
        local entity = qy.tank.model.GarageModel:getEntityByUniqueID(model.tank_unique_id)
        self.Tank:setTexture(entity:getImg())
        self.Btn_add:setOpacity(0)
        self.Btn_add:stopAllActions()
        self.Btn_add:setScale(2)
        self.Btn_add:setScaleX(5)
    end
end

function MainView:playMessageAnimation(node)
    if node:getNumberOfRunningActions() == 0 then
        local func1 = cc.FadeTo:create(1, 210)
        local func2 = cc.FadeTo:create(1, 255)
        local func3 = cc.ScaleTo:create(1, 1.1)
        local func4 = cc.ScaleTo:create(1, 1)
        local func5 = cc.DelayTime:create(0.5)

        node:runAction(cc.RepeatForever:create(cc.Sequence:create(func1, func2, func5)))
        node:runAction(cc.RepeatForever:create(cc.Sequence:create(func4, func3, func5)))
    end
end

function MainView:onEnter()
    self.listener_1 = qy.Event.add(qy.Event.SINGLE_HERO,function(event)
        self:update()
    end)
    -- qy.Event.dispatch("SINGLE_HERO")
    self:update()
end

function MainView:onExit()
    qy.Event.remove(self.listener_1)
end

return MainView
