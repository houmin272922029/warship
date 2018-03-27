local BeginView = qy.class("BeginView", qy.tank.view.BaseView, "soldiers_war.ui.BeginView")

local model = qy.tank.model.SoldiersWarModel
local service = qy.tank.service.SoldiersWarService
function BeginView:ctor(delegate)
    
    BeginView.super.ctor(self)

    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "Resources/activity/title_soldier_battle.png", 
        showHome = false,
        ["onExit"] = function()
            delegate:finish()
        end
    })
    self:addChild(style)


    self:InjectView("tank")
    self:InjectView("times")
    self:InjectView("record")
    self:InjectView("begin")
    self:InjectView("continue")

    self:OnClick("begin_btn", function()
        if model.status == 1 then
            delegate:showScenelistView()
        else
            service:start(function(data)
                delegate:showScenelistView()
            end) 
        end
    end,{["isScale"] = false})

    self:OnClick("buy_btn", function()
        require("soldiers_war.src.BuyDialog").new(self):show(self)
    end,{["isScale"] = false})


    self:OnClick("Btn_help", function()
        qy.tank.view.common.HelpDialog.new(24):show(true)
    end, {["isScale"] = false})


    --local tank_id = model:getTankIdByCurrentId()
    local entity = qy.tank.entity.TankEntity.new(1)
    self.tank:loadTexture(entity:getImg())
    
end


function BeginView:update()
    self.times_num = model.left_buy_times + model.free_times
    self.times:setString(self.times_num .. qy.TextUtil:substitute(62010))
    self.record:setString(qy.TextUtil:substitute(67011)..model.max_id..qy.TextUtil:substitute(67012))

    

    if model.status == 1 then
        self.continue:setVisible(true)
        self.begin:setVisible(false)
    elseif model.status == 0 then
        self.continue:setVisible(false)
        self.begin:setVisible(true)
    end
end


function BeginView:onEnter()
    self.listener_1 = qy.Event.add(qy.Event.SOLDIERS_WAR,function(event)
        self:update()
    end)
    -- qy.Event.dispatch("SINGLE_HERO")
    self:update()
end

function BeginView:onExit()
    qy.Event.remove(self.listener_1)
end

return BeginView
