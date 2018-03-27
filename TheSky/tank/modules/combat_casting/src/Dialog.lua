--[[--
--战备铸造
--]]--


local Dialog = qy.class("Dialog", qy.tank.view.BaseDialog, "combat_casting/ui/Layer")


local userModel = qy.tank.model.UserInfoModel
function Dialog:ctor(delegate)
    Dialog.super.ctor(self)
    self.model = qy.tank.model.CombatCastingModel
    self.service = qy.tank.service.CombatCastingService

	self:InjectView("bg")
	self:InjectView("LoadingBar")
    self:InjectView("Text_lv")
    self:InjectView("Text_num")
    self:InjectView("Text_consume")
    self:InjectView("Node_award")
    self:InjectView("Btn_get")
    self:InjectView("Btn_get10")
    self:InjectView("Btn_eat")
    self:InjectView("CheckBox")
    self:InjectView("Img_baoji")
    self:InjectView("Txt_time")
    for i = 1, 7 do        
        self:InjectView("Node_lv"..i)
    end

    self.flag = cc.UserDefault:getInstance():getBoolForKey(userModel.userInfoEntity.kid .."_combat_casting", false)
    self.flag2 = 0
    self.times = 1

	self:OnClick("Btn_close", function(sender)
        self:removeSelf()
    end,{["isScale"] = false})

    self:OnClick("Btn_get", function(sender)
        self.times = 1
        if self.Btn_get:isBright() then
            self.service:getAward(function(data)
                if data.user_activity_info.to_eat_award then
                    self.Btn_get:setBright(false)
                    self.Btn_get10:setBright(false)
                    self.Btn_eat:setBright(false)
                    if self.flag then
                        self.Btn_get:setBright(true)
                        self.Btn_eat:setBright(true)
                        self.Btn_get10:setBright(true)
                        self:update()
                    else
                        qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/ui/ui_fx_hanjie",function()
                            local effect = ccs.Armature:create("ui_fx_hanjie")
                            self.bg:addChild(effect)
                            effect:setPosition(450, 50)
                            effect:getAnimation():playWithIndex(0)

                            effect:runAction(cc.Sequence:create(cc.DelayTime:create(1.5), cc.CallFunc:create(function()
                                self.bg:removeChild(effect)
                                self.Btn_get:setBright(true)
                                self.Btn_eat:setBright(true)
                                self.Btn_get10:setBright(true)
                                self:update()
                            end)))
                        end)
                    end
                end
            end, 1, 1)
        end
    end,{["isScale"] = false})



    self:OnClick("Btn_get10", function(sender)
        self.times = 10
        if self.Btn_get:isBright() then
            if self.flag2 == 1 then
                self.service:getAward(function(data)
                    if data.user_activity_info.to_eat_award then
                        self:update()
                    end
                end, 10, self.flag2)
            else
                require("combat_casting.src.ConfirmDialog").new(function()
                    self.service:getAward(function(data)
                        if data.user_activity_info.to_eat_award then
                            self:update()
                        end
                    end, 10, self.flag2)
                end, self):show()
            end
        end
    end,{["isScale"] = false})
    

    
    self:OnClick("Btn_eat", function(sender)
        if self.Btn_eat:isBright() then
            self.service:getAward2(function(data)
                if data.award then
                    if self.guangquan then
                        self.guangquan:removeFromParent()
                        self.guangquan = nil
                    end

                    qy.tank.command.AwardCommand:add(data.award)
                    qy.tank.command.AwardCommand:show(data.award)
                    self:update()
                end
            end, 2)
        end
    end,{["isScale"] = false})   

    self:OnClick("Btn_help", function(sender)
        qy.tank.view.common.HelpDialog.new(39):show(true)
    end) 


    self:OnClick("Btn_rank", function(sender)        
        self.service:getAward2(function(data)
            require("combat_casting.src.CombatCastingRankDialog").new():show()
        end, 4)
    end) 



    self:OnClick("Btn_achievement", function(sender)       
        --self.service:getAward2(function(data)
            require("combat_casting.src.RewardDialog").new():show()
        --end, 4)
    end) 

    
    self:OnClick("Btn_help", function()
        qy.tank.view.common.HelpDialog.new(qy.tank.model.HelpTxtModel:getHelpDataByIndx(44)):show(true)
    end)


    for i = 1, #self.model.score_award do
        for j = 1, #self.model.score_award[i]["award"] do 
            self.award = qy.tank.view.common.AwardItem.createAwardView(self.model.score_award[i]["award"][j], 1)
            self.award:showTitle(false)
            self.award:setPosition((j - 1) * 160 + 35,20)
            self.award.fatherSprite:setSwallowTouches(false)
            self.award:setScale(0.6)
            self["Node_lv"..i]:addChild(self.award)
        end
    end


    self:OnClick("CheckBox", function(sender)
        self.flag = self.CheckBox:isSelected()
        cc.UserDefault:getInstance():setBoolForKey(userModel.userInfoEntity.kid .."_combat_casting", self.flag)
    end,{["isScale"] = false}) 

    self.CheckBox:setSelected(self.flag)
    

    self:update()
end



function Dialog:update()
    self.LoadingBar:setPercent(self.model.level < #self.model.score_award and (self.model.point - self.model.score_award[self.model.level].point) / (self.model.score_award[self.model.level + 1].point - self.model.score_award[self.model.level].point) * 100 or 100)
    self.Text_lv:setString("LV."..self.model.level)

    self.Node_award:removeAllChildren()
    if self.model.to_eat_award.type then
        self.award = qy.tank.view.common.AwardItem.createAwardView(self.model.to_eat_award, 1)
        self.award:showTitle(false)
        self.award:setPosition(34,28)
        self.award.fatherSprite:setSwallowTouches(false)
        self.award:setScale(0.6)
        self.Node_award:addChild(self.award)

        self.Btn_eat:setBright(true)

        for j = 1, #self.model.score_award[self.model.level]["award"] do 
            if self.model.score_award[self.model.level]["award"][j].type == self.model.to_eat_award.type 
                and self.model.score_award[self.model.level]["award"][j].num == self.model.to_eat_award.num
                and self.model.score_award[self.model.level]["award"][j].id == self.model.to_eat_award.id then

                
                if self.guangquan then
                    self.guangquan:removeFromParent()
                    self.guangquan = nil
                end

                qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/ui/ui_fx_taozhuang2",function()
                    self.guangquan = ccs.Armature:create("ui_fx_taozhuang2")
                    self.guangquan:setScale(0.6)
                    self.guangquan:setPosition((j - 1) * 160 + 35,20)
                    self["Node_lv"..self.model.level]:addChild(self.guangquan)
                    self.guangquan:getAnimation():playWithIndex(0)
                end)

                break
            end
        end
    else
        self.Btn_eat:setBright(false)
    end

    if self.model.add_point > 100 and self.times == 1 then        
        self.Img_baoji:loadTexture("boil_dumpling/res/baoji_"..(self.model.add_point / 100)..".png")
        self.model.add_point = 0
        self.Img_baoji:setVisible(true)
        self.Img_baoji:setScale(4)
        self.Img_baoji:setOpacity(100)
        self.Img_baoji:runAction(cc.Sequence:create(cc.Spawn:create(cc.ScaleTo:create(0.1, 1), cc.FadeTo:create(0.1, 255)), cc.DelayTime:create(0.4), cc.CallFunc:create(function()
            self.Img_baoji:setVisible(false)
        end)))
    end

    self.Text_num:setString(userModel.userInfoEntity:getDiamondStr())

end




function Dialog:updateTime()
    if self.Txt_time then
        if self.model:getRemainTime() == qy.TextUtil:substitute(63035) then
            self:update()
        end

        self.Txt_time:setString(self.model:getRemainTime())
    end
end


function Dialog:onEnter()
    self:updateTime()
    self.timeListener = qy.Event.add(qy.Runtime.TIMER_UPDATE,function(event)
        self:updateTime()
    end)
end


function Dialog:onExit()
    qy.Event.remove(self.timeListener)
    self.timeListener = nil
end


return Dialog