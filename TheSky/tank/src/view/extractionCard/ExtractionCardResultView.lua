-- 抽卡结果
local ExtractionCardResultView = qy.class("ExtractionCardResultView", qy.tank.view.BaseView, "view/extractionCard/ExtractionCardResultView")

function ExtractionCardResultView:ctor(delegate)
    ExtractionCardResultView.super.ctor(self)

    self.userModel = qy.tank.model.UserInfoModel
    self.model = qy.tank.model.ExtractionCardModel
    self.storeModel = qy.tank.model.StorageModel
    self.service = qy.tank.service.ExtractionCardService
    self.delegate = delegate
    self.awardArr = delegate.data
    self.isTen = delegate.isTen
    self.side = delegate.side
    self:InjectView("titleTen")
    self:InjectView("closeBtn")
    self:InjectView("returnBtn")
    self:InjectView("titleItem")
    self:InjectView("titleCard")
    self:InjectView("diamondTxt")
    self:InjectView("needTxt")
    self:InjectView("replayBtn")
    self:InjectView("itemIcon")
    self:InjectView("itemIcon1")
    self:InjectView("diamondIcon")
    self:InjectView("diamondIcon1")
    self.isPlaying = false
    self:OnClick("closeBtn", function(sender)
        self.delegate:dismiss()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})
    self:OnClick("returnBtn", function(sender)
        self.delegate:dismiss()
        qy.GuideManager:next(994)
    end,{["audioType"] = qy.SoundType.BTN_CLOSE})
    self:OnClick("replayBtn", function(sender)
        self:getCards()
    end)
    if self.side == 1 then
        self.itemIcon:setVisible(true)
        self.diamondIcon:setVisible(false)
        self.itemIcon1:setVisible(true)
        self.diamondIcon1:setVisible(false)
        if self.isTen then
            self.needTxt:setString("10")
        else
            self.needTxt:setString("1")
        end
    else
        self.diamondIcon:setVisible(true)
        self.itemIcon:setVisible(false)
        self.diamondIcon1:setVisible(true)
        self.itemIcon1:setVisible(false)
        if self.isTen then
            self.needTxt:setString("2700")
        else
            self.needTxt:setString("288")
        end

    end

    self:dealAwards()
end

function ExtractionCardResultView:dealAwards()
    -- self.isPlaying = true
    self:updateUserInfo()
    self.replayBtn:setEnabled(false)
    self.titleTen:setVisible(false)
    self.titleItem:setVisible(false)
    self.titleCard:setVisible(false)
    if self.awardArr == nil or #self.awardArr==0 then return end
    local item
    local x = 0
    local y = 0
    if self.itemContainer ~=nil then
        self:removeChild(self.itemContainer , true)
    end
    self.itemContainer = cc.Node:create()
    self:addChild(self.itemContainer)

    if #self.awardArr >1 then
        self.itemContainer:setPosition(qy.winSize.width/2 - 400 , 480)
        for i=1,  #self.awardArr do
            item = self:dealSingAward(self.awardArr[i] , true)
            x =   (i-1)%5 * 200
            y =  - math.floor((i-1)/5) * 200
            if self.awardArr[i].type ~=11 then
                y =  - math.floor((i-1)/5) * 200 - 5
            end

            -- item:setPosition(x , y)
            self.itemContainer:addChild(item)
            self:runSingleCard(item , cc.p(500,qy.winSize.height ) , cc.p(x,y) , i*0.2 , i == #self.awardArr and true or false)
        end
        self.titleTen:setVisible(true)
        -- self:titleAction(self.titleTen)
        -- self.titleTen:setColor(cc.c3b(255,255,255))
    else
        item = self:dealSingAward(self.awardArr[1] , false)
        self.itemContainer:setPosition(qy.winSize.width/2  , qy.winSize.height/2 + 50)
        self.itemContainer:addChild(item)
        -- self.isPlaying = false
        self.replayBtn:setEnabled(true)
    end
end

function ExtractionCardResultView:dealSingAward(data , isTen)
    if data == nil then return nil end
    local item = nil
    local type = 1
    local scale = 1.3
    if data.type == 11 then
        type = 2
        if isTen == true then
            scale = 0.5
        end
    end
    if isTen == false then
        if type == 2 then
            self.titleCard:setVisible(true)
            -- self:titleAction(self.titleCard)
        else
            self.titleItem:setVisible(true)
            -- self:titleAction(self.titleItem)
        end
    end

    local rewardItem = qy.tank.view.common.AwardItem.createAwardView(data , type , scale)

    if type ==2 and rewardItem~=nil and isTen == true then
        local title = rewardItem:getTitle()
        local name = cc.Label:createWithTTF(title,qy.res.FONT_NAME_2, 20.0,cc.size(300,0),1)
         name:enableOutline(cc.c4b(0,0,0,255),1)
         name:setAnchorPoint(0.5,1)
         name:setTextColor(rewardItem:getColor())
         name:setPosition(0,-75)
         rewardItem:addChild(name)
         rewardItem:showTitle(false)
    end

    if isTen == false then
        self:playAction(rewardItem)
    end
    return rewardItem
end

function ExtractionCardResultView:titleAction(title)
    -- title:runAction()
    local delay = cc.DelayTime:create(0.3)
    local func1 = cc.ScaleTo:create(0.2, 1.5)
    local func2 = cc.ScaleTo:create(0.1, 0.9)
    local func3 = cc.ScaleTo:create(0.05, 1)

    local seq = cc.Sequence:create(func1, func2, func3)
    title:runAction(seq)
end

function ExtractionCardResultView:playAction(node)
    local x = node:getPositionX()
    local y = node:getPositionY()
    local time = 0.4

    node:setPosition(x - 700, y + 400)
    node:setVisible(true)
    node:setScale(0.3)
    -- node:setOpacity(0)
    local scale = cc.ScaleTo:create(time, 1) --  缩放
    -- local fadeIn = cc.FadeOut:create(0.15) -- 渐入
    local scale2 = cc.ScaleTo:create(0.1,1.7)
    local spawn = cc.Spawn:create(scale, cc.MoveTo:create(time, cc.p(x, y)))
    local delay = cc.DelayTime:create(0.1)
    local scale3 = cc.ScaleTo:create(0.3,1) --  缩放
    local seq = cc.Sequence:create(delay, scale2, spawn, scale3)
    node:runAction(spawn)
end
--更新用户数据
function ExtractionCardResultView:updateUserInfo()
   if self.side == 1 then
        local item = self.storeModel:getEntityByID(10)
        local num = item == nil and 0 or item.num
        self.diamondTxt:setString(num)
   else
        self.diamondTxt:setString(self.userModel.userInfoEntity:getDiamondStr())
   end

end

-- 调取接口
function ExtractionCardResultView:getCards()
    -- if self.isPlaying == true then return end -- 如果抽卡正在播放动画，则不允许再次抽卡
    -- self.isPlaying = true
    local param = {}
    local type = self.isTen and 2 or 1
    param["type"] = type
    if self.side == 1 then
        local num = type == 2 and 10 or 1
        if self.storeModel:enough(10, num) then
            if #qy.tank.model.GarageModel.totalTanks >= 500 then
                qy.hint:show(qy.TextUtil:substitute(90308))
                self.replayBtn:setEnabled(true)
            else
                self.service:getCardsType1(param,function(data)
                    if data.is_max_num and data.is_max_num >= 1 then
                        self.replayBtn:setEnabled(true)
                        qy.hint:show(qy.TextUtil:substitute(90308))
                        return
                    end

                    if type == 1 then
                        self.storeModel:remove(10 , 1)

                    end
                    if type == 2 then
                        self.storeModel:remove(10 , 10)
                    end
                    self:dealResult(data)
                end)
            end
        else
            self.isPlaying = false
            qy.hint:show(qy.TextUtil:substitute(12001))

            local entity = qy.tank.model.PropShopModel:getShopPropsEntityById(7)
            local buyDialog = qy.tank.view.shop.PurchaseDialog.new(entity,function(num)
                local service = qy.tank.service.ShopService
                service:buyProp(entity.id,num,function(data)
                    -- service = nil
                    -- -- self:updateResource()
                    if data and data.consume then
                        qy.hint:show(qy.TextUtil:substitute(12002).."x"..data.consume.num)
                    end

                    self:updateUserInfo()
                    -- self:showDetailInfo(self.model.list[self.selectIdx])
                end)
            end)
            buyDialog:show(true)
        end
    else
        if #qy.tank.model.GarageModel.totalTanks >= 500 then
                qy.hint:show(qy.TextUtil:substitute(90308))
                self.replayBtn:setEnabled(true)
        else            
            self.service:getCardsType2(param,function(data)
                if data.is_max_num and data.is_max_num >= 1 then
                    self.replayBtn:setEnabled(true)
                    qy.hint:show(qy.TextUtil:substitute(90308))
                    return
                end
                self:dealResult(data)
            end)
        end
    end
end

function ExtractionCardResultView:dealResult(data)
    self.awardArr = data.award
    qy.tank.command.AwardCommand:add(data.award)

    self:dealAwards()
    -- self:updateUserInfo()

end

--卡片儿飞
function ExtractionCardResultView:runSingleCard( card , startPoint , endPoint ,delayTime , isEnd)
    card:setScale(0.1)
    card:setPosition(startPoint)
    local runTime = 0.5
    local fadeIn = cc.FadeIn:create(runTime) -- 渐入
    local rotate = cc.RotateBy:create(runTime,360) -- 旋转
    local scale = cc.ScaleTo:create(runTime,1) --  缩放
    local max = 100
    function getRandom()
        local randomNum = max*math.random() - max*math.random()
        return randomNum
    end
    local bezier ={
            startPoint,--起始点
            cc.p(getRandom(),getRandom()),--控制点
            endPoint--结束点
        }
        local bezierTo = cc.BezierTo:create(runTime, bezier)
        local spawn = cc.Spawn:create(fadeIn , rotate , scale , bezierTo)
        local delay = cc.DelayTime:create(delayTime)
        local seq = cc.Sequence:create(delay , spawn,cc.CallFunc:create(function()
            if isEnd then
                -- self.isPlaying = false
                self.replayBtn:setEnabled(true)
            end
        end))
        card:runAction(seq)
end

function ExtractionCardResultView:onEnter()
    --新手引导：注册控件
    qy.GuideCommand:addUiRegister({
        {["ui"] = self.returnBtn, ["step"] = {"SG_55"}},
    })
end

function ExtractionCardResultView:onExit()
    --新手引导：移除控件注册
    qy.GuideCommand:removeUiRegister({"SG_55"})
end

return ExtractionCardResultView
