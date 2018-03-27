--[[
    补给
    Author: H.X.Sun
    Date: 2015-04-29
]]

local SupplyInfoCell = qy.class("SupplyInfoCell", qy.tank.view.BaseView, "view/supply/SupplyDialog")

function SupplyInfoCell:ctor(delegate)
    SupplyInfoCell.super.ctor(self)

    self:InjectView("tipsList")
    self:InjectView("tipsContinue")
    self:InjectView("supplyBtn")
    self:InjectView("supplyBtnTxt")
    self:InjectView("topInfo")
    self:InjectView("redDot")
    self:InjectView("content")
    self:InjectView("closeBtn")

    self:InjectView("tankName")
    self:InjectView("tankIcon")
    self:InjectView("describe")
    self:InjectView("awardInfo")
    -- qy.tank.utils.TextUtil:autoChangeLine(self.describe , cc.size(440 , 140))
    self.supplyInfoAnim = false

    self.model = qy.tank.model.SupplyModel
    self.buttonTxtChange = false
    self.topInfo:setPosition(2, -258)
    self:showSupplyInfo()

    -- self:OnClick("closeBtn", function (sendr)
    --     self:dismiss()
    --     qy.GuideManager:next()
    -- end,{["audioType"] = qy.SoundType.BTN_CLOSE})

    self:OnClick("supplyBtn", function (sendr)
        if self.supplyInfoAnim then
            return
        end
        if self.model:getRemainSupplyNum() > 0 or qy.tank.model.UserInfoModel.userInfoEntity.diamond >= self.model:getStrongSupplyConsume()then
            local service = qy.tank.service.SupplyService
            service:supplyOperation(nil,function(data)
                -- self:showOrHideSupplyInfoView(false)
                self:supplyLogic()
                self:updateList()
                qy.GuideManager:next(12345432)
            end)
        else
            -- qy.alert:show({"提示" ,{255,255,255} } ,
            --     {{id=1,color={255,255,255},alpha=255,text="钻石不足，请充值",font="Arial",size=20}} ,
            --     cc.size(420 , 200) ,{{"关闭" , 4} , {"确认" , 5} } , function(flag)
            --         if flag == "确认" then
            --             delegate.callback()
            --             qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.RECHARGE)
            --         end
            --     end)
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.DIAMOND_NOT_ENOUGH)
        end
    end,{["audioType"] = qy.SoundType.SUPPLY_CLICK_TIPS})
end

--[[--
--点击补给按钮逻辑
--]]
function SupplyInfoCell:supplyLogic()
    self:showOrHideSupplyInfoView(false)
    self:createDescribeView()
end

--[[--
--描述界面
--]]
function SupplyInfoCell:createDescribeView()
    self.tankName:setString(self.model:getTankName())
    self.tankIcon:setTexture(self.model:getSupplyIcon())
    self.describe:setString(self.model:getDescribe())
    if self.awardView == nil then
        self.awardView = qy.tank.view.supply.SupplyAwardCell.new(self)
        self.awardInfo:addChild(self.awardView)
    end
    self.awardView:render(self.model:isSpecialEvent())
end

--[[--
--补给介绍界面
--@param #boolean flag 是否正在显示
--]]
function SupplyInfoCell:showOrHideSupplyInfoView(flag)
    self.supplyInfoAnim = true
    self.topInfo:stopAllActions()
    self.topInfo:setPosition(2, -258)
    local jumpTo = cc.JumpTo:create(0.2, cc.p(2, 267), 30, 0.5)
    local delay = cc.DelayTime:create(0.2)
    local callFunc = cc.CallFunc:create(function ()
        if self.awardView ~= nil then
            self.awardView:showSealAnim(self.model:isSpecialEvent())
        end
        self.supplyInfoAnim = false
    end)
    self.topInfo:runAction(cc.Sequence:create(jumpTo, delay, callFunc))
end

--[[--
--停止呼吸动画
--]]
-- function SupplyInfoCell:stopBreatheAnim()
--     self.tipsContinue:stopAllActions()
--     self.tipsContinue:setScale(1)
--     self.tipsContinue:setOpacity(255)
-- end

--[[--
--呼吸动画
--@param ui 控件
--]]
-- function SupplyInfoCell:breatheAnim(ui)
--     if ui then
--         local scaleSmall = cc.ScaleTo:create(1.2,0.9)
--         local scaleBig = cc.ScaleTo:create(1.2,1)
--         local FadeIn = cc.FadeTo:create(1.2, 255)
--         local FadeOut = cc.FadeTo:create(1.2, 125)
--         local spawn1 = cc.Spawn:create(scaleSmall,FadeOut)
--         local spawn2 = cc.Spawn:create(scaleBig,FadeIn)
--         local seq = cc.Sequence:create(spawn1, spawn2)
--         ui:runAction(cc.RepeatForever:create(seq))
--     end
-- end

--[[--
--显示补给详情
--]]
function SupplyInfoCell:showSupplyInfo()
    self:showBtnTxt(self.model:getRemainSupplyNum())
    self:createTipsText()
    self:updateList()
end

--[[
--显示按钮名称
--@param #number supplyNum 剩余补给次数
--]]
function SupplyInfoCell:showBtnTxt(supplyNum)
    if supplyNum > 0 then
        self.supplyBtnTxt:setSpriteFrame("Resources/common/txt/buji.png")
        self.redDot:setVisible(true)
    else
        self.supplyBtnTxt:setSpriteFrame("Resources/common/txt/qiangbu.png")
        self.redDot:setVisible(false)
    end
end

--[[--
--提示信息
--]]
function SupplyInfoCell:createTipsText()
    self.tipsListTable = {}
    self.changeText = nil
    local content = {
        [1] = {[1] = qy.TextUtil:substitute(33001) .. "  ", [2] = qy.TextUtil:substitute(33002), [3] = qy.TextUtil:substitute(33003), [4] = qy.TextUtil:substitute(33004)},
        [2] = {[1] = qy.TextUtil:substitute(33005) .. "  ", [2] = qy.TextUtil:substitute(33006), [3] = qy.TextUtil:substitute(33007)},
        [3] = {[1] = qy.TextUtil:substitute(33008) .. "  ", [2] = qy.TextUtil:substitute(33009) .. "  ", [3] = "50/50"}
    }
    self.color = {cc.c3b(253, 225, 143),cc.c3b(255, 255, 255),cc.c3b(254, 182, 36),cc.c3b(255, 255, 255)}
    for i = 1, 3 do
        local richTxt = ccui.RichText:create()
        richTxt:ignoreContentAdaptWithSize(false)
        richTxt:setContentSize(500, 30)
        if qy.cocos2d_version ~= qy.COCOS2D_3_7_1 then
            richTxt:setAnchorPoint(1, 0)
        end
        for j = 1, 4 do
            if content[i][j] then
                local stringTxt = ccui.RichElementText:create( j, self.color[j], 255, content[i][j] , qy.res.FONT_NAME_2, qy.InternationalUtil:getSupplyInfoCellFontSize())
                richTxt:pushBackElement(stringTxt)
            end
        end
        table.insert(self.tipsListTable, richTxt)
        self.tipsList:addChild(richTxt)
        richTxt:setPosition(265 + 250,85 - 33 * i)
    end
end

--[[--
--更新提示语
--]]
function SupplyInfoCell:updateList()
    local richTxt = self.tipsListTable[3]
    if not self.buttonTxtChange and self.model:getRemainSupplyNum() == 0 then
        self:showBtnTxt(-1)
        self.buttonTxtChange = true
        richTxt:removeElement(2)
        richTxt:removeElement(1)
        local stringTxt1 = ccui.RichElementText:create(2, self.color[2], 255, qy.TextUtil:substitute(33010) , qy.res.FONT_NAME_2, qy.InternationalUtil:getSupplyInfoCellFontSize())
        richTxt:pushBackElement(stringTxt1)
        local icon = ccui.RichElementImage:create(3, self.color[4], 255, "Resources/common/icon/coin/1a.png")
        richTxt:pushBackElement(icon)
        local stringTxt2 = ccui.RichElementText:create(2, self.color[2], 255, "x 1" , qy.res.FONT_NAME_2, qy.InternationalUtil:getSupplyInfoCellFontSize())
        richTxt:pushBackElement(stringTxt2)
    end

    if self.model:getRemainSupplyNum() > 0 then
        --通过index删除richTxt的节点 从0开始
        richTxt:removeElement(2)
    else
        richTxt:removeElement(3)
    end
    local str = self.model:getSupplyTxt()
    local stringTxt = ccui.RichElementText:create(3, self.color[3], 255, str , qy.res.FONT_NAME_2, qy.InternationalUtil:getSupplyInfoCellFontSize())
    richTxt:pushBackElement(stringTxt)
end

function SupplyInfoCell:onEnter()
end

function SupplyInfoCell:onExit()
end

return SupplyInfoCell
