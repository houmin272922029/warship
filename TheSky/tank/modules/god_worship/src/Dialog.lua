--[[--
--战神膜拜
--]]--


local Dialog = qy.class("Dialog", qy.tank.view.BaseDialog, "god_worship/ui/Layer")



function Dialog:ctor(delegate)
    Dialog.super.ctor(self)
    self.model = qy.tank.model.GodWorshipModel
    self.service = qy.tank.service.GodWorshipService

	self:InjectView("bg")
	self:InjectView("Img_isget")
    self:InjectView("Img_get")
    self:InjectView("Img_box")
    self:InjectView("Text_name")
    self:InjectView("Text_jindu")
    self:InjectView("Text_mobai")
    self:InjectView("Text_yimobai")
    self:InjectView("Btn_mobai")

    self.flag = true


	self:OnClick("Btn_close", function(sender)
        self:removeSelf()
    end,{["isScale"] = false})

    self:OnClick("Img_get", function(sender)
        require("god_worship.src.AwardDialog").new():show(function()
            self:update()
        end)
    end,{["isScale"] = false})
    
    self:OnClick("Btn_mobai", function(sender)
        self.service:getAward(function(data)
            if data.award then
                qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/ui/ui_fx_yinbi",function()
                    local effect = ccs.Armature:create("ui_fx_yinbi")
                    self.bg:addChild(effect)
                    effect:setPosition(-250, 580)
                    effect:getAnimation():playWithIndex(0)

                    effect:runAction(cc.Sequence:create(cc.DelayTime:create(1.5), cc.CallFunc:create(function()
                        self.bg:removeChild(effect)

                        qy.tank.command.AwardCommand:add(data.award)
                        qy.tank.command.AwardCommand:show(data.award)
                        self:update()
                    end)))
                end)
            end
        end, 1)
    end,{["isScale"] = false})    

    self:update()
end



function Dialog:update()
   local data_data_data = self.model.data_data
    self.Text_jindu:setString(self.model.times.." / "..3)
    if self.model.awarded > 0 then
        self.Img_isget:setVisible(true)
    else
        self.Img_isget:setVisible(false)
    end

    local server = string.sub(self.model.userinfo.server, 2)
    if self.model.game == "tankandroid" then
        self.Text_name:setString(data_data_data.activity_info.strongest_champion.server.." "..data_data_data.activity_info.strongest_champion.nickname)
    else
        self.Text_name:setString("【"..server..qy.TextUtil:substitute(90296).."】 "..self.model.userinfo.nickname)
    end



    if self.model.times >= 3 and self.model.awarded == 0 then
        self.Img_box:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.RotateTo:create(0.1, -10), cc.RotateTo:create(0.1, 10))))
    else
        self.Img_box:stopAllActions()
    end

    if self.model.worship == 0 then 
        self.Btn_mobai:setBright(true)
        self.Text_mobai:setVisible(true)
        self.Text_yimobai:setVisible(false)
    else
        self.Btn_mobai:setBright(false)
        self.Text_mobai:setVisible(false)
        self.Text_yimobai:setVisible(true) 
    end
end
function Dialog:onExit()
    -- cc.Director:getInstance():getTextureCache():removeAllTextures()
end


return Dialog