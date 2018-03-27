--[[--
--克虏伯
--Author: Fu.Qiang
--Date: 2016-07-04
--]]--


local JuNengPinHeDialog = qy.class("JuNengPinHeDialog", qy.tank.view.BaseDialog, "junengpinhe/ui/Dialog")

local model = qy.tank.model.JuNengPinHeModel
local service = qy.tank.service.JuNengPinHeService
function JuNengPinHeDialog:ctor(delegate)
    JuNengPinHeDialog.super.ctor(self)
    self.action_status = false

    local style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(850, 580),
        position = cc.p(0, 0),
        offset = cc.p(0, 0),
        bgShow = false,
        titleUrl = "Resources/common/title/junengpinhe_1.png",

        ["onClose"] = function()
            self:removeSelf()
        end
    })

    self:addChild(style)

    self:InjectView("bg")
    self:InjectView("Btn_suipian_1")
    self:InjectView("Btn_suipian_2")
    self:InjectView("Btn_suipian_3")
    self:InjectView("Btn_suipian_4")
    self:InjectView("Btn_pinhe")
    self:InjectView("Btn_buy")
    self:InjectView("node")

    self:InjectView("Text_supian_1")
    self:InjectView("Text_supian_2")
    self:InjectView("Text_supian_3")
    self:InjectView("Text_supian_4")

    self:InjectView("Text_time")

    self.Btn_suipian_1:setTouchEnabled(false)
    self.Btn_suipian_2:setTouchEnabled(false)
    self.Btn_suipian_3:setTouchEnabled(false)
    self.Btn_suipian_4:setTouchEnabled(false)

    self:playMessageAnimation(true)

    self:OnClick(self.Btn_pinhe, function(sender)
        if model:getSuiPianFlag() then
            service:pinhe(function(data)
                self.Btn_suipian_1:setVisible(false)
                self.Btn_suipian_2:setVisible(false)
                self.Btn_suipian_3:setVisible(false)
                self.Btn_suipian_4:setVisible(false)

                self.Btn_pinhe:setVisible(false)

                qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/ui/ui_fx_juhe",function()
                    local effect = ccs.Armature:create("ui_fx_juhe")
                    self.node:addChild(effect, 1)
                    effect:setPosition(0.5, 0.5)
                    effect:getAnimation():playWithIndex(0)
                    effect:runAction(cc.Sequence:create(cc.DelayTime:create(1), cc.CallFunc:create(function()
                        self.node:removeChild(effect)

                        self.Btn_suipian_1:setVisible(true)
                        self.Btn_suipian_2:setVisible(true)
                        self.Btn_suipian_3:setVisible(true)
                        self.Btn_suipian_4:setVisible(true)

                        self.Btn_pinhe:setVisible(true)

                        self:update()

                        qy.tank.command.AwardCommand:add(data.award)
                        qy.tank.command.AwardCommand:show(data.award, {["isShowHint"] = false})
                    end)))
                end)
            end)
        else
            qy.hint:show("碎片不足，请参加黄金地堡或购买碎片礼包")
        end 
    end,{["isScale"] = false})

    self:OnClick(self.Btn_buy, function(sender)
        require("junengpinhe.src.BuyDialog").new(self):show(self)
    end,{["isScale"] = false})


    self:update()

end


function JuNengPinHeDialog:update()

    if model:getNum1() > 0 then
        self.Btn_suipian_1:setBright(true)
        self.Text_supian_1:setColor(cc.c3b(0, 255, 0))
    else
        self.Btn_suipian_1:setBright(false)
        self.Text_supian_1:setColor(cc.c3b(255, 0, 0))
    end

    if model:getNum2() > 0 then
        self.Btn_suipian_2:setBright(true)
        self.Text_supian_2:setColor(cc.c3b(0, 255, 0))
    else
        self.Btn_suipian_2:setBright(false)
        self.Text_supian_2:setColor(cc.c3b(255, 0, 0))
    end

    if model:getNum3() > 0 then
        self.Btn_suipian_3:setBright(true)
        self.Text_supian_3:setColor(cc.c3b(0, 255, 0))
    else
        self.Btn_suipian_3:setBright(false)
        self.Text_supian_3:setColor(cc.c3b(255, 0, 0))
    end

    if model:getNum4() > 0 then
        self.Btn_suipian_4:setBright(true)
        self.Text_supian_4:setColor(cc.c3b(0, 255, 0))
    else
        self.Btn_suipian_4:setBright(false)
        self.Text_supian_4:setColor(cc.c3b(255, 0, 0))
    end

    self.Text_supian_1:setString(model:getNum1())
    self.Text_supian_2:setString(model:getNum2())
    self.Text_supian_3:setString(model:getNum3())
    self.Text_supian_4:setString(model:getNum4())

    self:playMessageAnimation(model:getSuiPianFlag())
end



function JuNengPinHeDialog:playMessageAnimation(boolean)
    if boolean and self.action_status == false then 
        local func1 = cc.FadeTo:create(1, 210)
        local func2 = cc.FadeTo:create(1, 255)
        local func3 = cc.ScaleTo:create(1, 1.2)
        local func4 = cc.ScaleTo:create(1, 1)
        local func5 = cc.DelayTime:create(0.5)

        self.Btn_pinhe:runAction(cc.RepeatForever:create(cc.Sequence:create(func1, func2, func5)))
        self.Btn_pinhe:runAction(cc.RepeatForever:create(cc.Sequence:create(func4, func3, func5)))

        self.action_status = true
    elseif boolean == false then
        self.Btn_pinhe:stopAllActions()

        self.action_status = false
    end
end



function JuNengPinHeDialog:updateTime()
    if self.Text_time then
        self.Text_time:setString(model:getRemainTime())
    end
end

function JuNengPinHeDialog:onEnter()
    self:updateTime()
    self.timeListener = qy.Event.add(qy.Runtime.TIMER_UPDATE,function(event)
        self:updateTime()
    end)
end

function JuNengPinHeDialog:onExit()
    qy.Event.remove(self.timeListener)
    self.timeListener = nil
end



return JuNengPinHeDialog