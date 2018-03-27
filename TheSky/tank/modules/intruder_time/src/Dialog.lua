--[[--
--]]--


local Dialog = qy.class("Dialog", qy.tank.view.BaseDialog, "intruder_time/ui/Layer")


local userinfoModel = qy.tank.model.UserInfoModel
local NumberUtil = qy.tank.utils.NumberUtil
function Dialog:ctor(delegate)
    Dialog.super.ctor(self)

    self.model = qy.tank.model.IntruderTimeModel
    self.service = qy.tank.service.IntruderTimeService


    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "intruder_time/res/44.png", 
        showHome = false,
        ["onExit"] = function()
            self:removeSelf()
        end
    })
    self:addChild(style)

    self:InjectView("bg")
    self:InjectView("Text_times1")
    self:InjectView("Text_times2")
    self:InjectView("Text_time")
    self:InjectView("Text_name")
    self:InjectView("Btn_award")
    self:InjectView("Btn_go")
    self:InjectView("Btn_help")
    self:InjectView("Btn_help1")
    self:InjectView("Image_2")
    self:InjectView("Node")
    self:InjectView("Img_tank")

    self.timeListener = nil



	self:OnClick(self.Btn_go, function(sender)
        self.service:fight(function(data)
            qy.tank.model.BattleModel:init(data.fight_result)
            qy.tank.manager.ScenesManager:pushBattleScene()
        end,self.model.intruder.unique)
    end,{["isScale"] = false})


    self:OnClick(self.Btn_help, function(sender)
        self.service:share(function(data)
            self:update()
        end,self.model.intruder.unique)
    end,{["isScale"] = false})


    self:OnClick(self.Btn_award, function(sender)
        require("intruder_time.src.AwardDialog").new():show()
    end,{["isScale"] = false})

    self:OnClick(self.Btn_help1, function(sender)        
        qy.tank.view.common.HelpDialog.new(42):show(true)
    end,{["isScale"] = false})


    self:update()


end

function Dialog:update()
    self.Text_times1:setString(self.model.repulse.." / 3")
    self.Text_times2:setString(self.model.help.." / 3")

    if self.model.intruder.id then

        if not self.timeListener then
            self:updateTime()
            self.timeListener = qy.Event.add(qy.Runtime.TIMER_UPDATE,function(event)
                self:updateTime()
            end)        
        end

        self.Node:setVisible(true)
        self.Image_2:setVisible(false)
        print(self.model.monster_list[self.model.intruder.id].icon)
        self.Img_tank:setTexture("tank/img/img_t"..self.model.monster_list[self.model.intruder.id].icon..".png")
        self.Text_name:setString(self.model.monster_list[self.model.intruder.id].checkpoint_name)

        local quality = self.model.monster_list[self.model.intruder.id].quality
        if quality == 2 then
            self.Text_name:setColor(qy.tank.utils.ColorMapUtil.qualityMapColor(2))
        elseif quality == 3 then
            self.Text_name:setColor(qy.tank.utils.ColorMapUtil.qualityMapColor(3))
        elseif quality == 4 then
            self.Text_name:setColor(qy.tank.utils.ColorMapUtil.qualityMapColor(4))
        elseif quality == 5 then
            self.Text_name:setColor(qy.tank.utils.ColorMapUtil.qualityMapColor(5))
        end
    else
        self.Node:setVisible(false)
        self.Image_2:setVisible(true)
    end
end


function Dialog:updateTime()
    if self.Text_time and self.model.intruder.die_time then
        if self.model.intruder.die_time - userinfoModel.serverTime > 0 then
            self.Text_time:setString(NumberUtil.secondsToTimeStr(self.model.intruder.die_time - userinfoModel.serverTime,6))
        else
            self.service:get(function(data)
                self:update()
            end)

            if self.timeListener then
                qy.Event.remove(self.timeListener)
                self.timeListener = nil
            end
        end
    end   

end


function Dialog:onEnter( ... )
    self.listener_1 = qy.Event.add(qy.Event.BACK_OF_BATTLE,function(event)
        self:update()
    end)
end



function Dialog:onExit()
    if self.timeListener then
        qy.Event.remove(self.timeListener)
        self.timeListener = nil
    end

    qy.Event.remove(self.listener_1)
end






return Dialog