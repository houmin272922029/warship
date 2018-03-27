local MainView = qy.class("MainView", qy.tank.view.BaseDialog, "searchTreasure.ui.MainView")

local model = qy.tank.model.OperatingActivitiesModel
local service = qy.tank.service.OperatingActivitiesService
function MainView:ctor(delegate)
   	MainView.super.ctor(self)
    self.delegate = delegate
    self:InjectView("BG")
    self:InjectView("Text_1")
    self:InjectView("Text_2")
    self:InjectView("Text_4")
    self:InjectView("Text_11")
    self:InjectView("Button_1")
    self:InjectView("Button_2")
    self:InjectView("Button_3")
    self:InjectView("Button_4")
    self:InjectView("Button_5")
    self:InjectView("Button_5")
    self:InjectView("Button_6")
    self:InjectView("Button_7")
    self:InjectView("Button_8")
    self:InjectView("Button_9")
    self:InjectView("Button_10")
    self:InjectView("Text1_1")
    self:InjectView("Text1_2")
    self:InjectView("Text1_3")
    self:InjectView("Text1_4")
    self:InjectView("Text1_5")
    self:InjectView("Text1_6")
    self:InjectView("Text1_7")
    self:InjectView("rank1")
    self:InjectView("rank2")
    self:InjectView("rank3")
    self:InjectView("rank4")
    self:InjectView("rank5")
    self:InjectView("count_1")
    self:InjectView("count_2")
    self:InjectView("count_3")
    self:InjectView("count_4")
    self:InjectView("count_5")
    self:InjectView("Panel_2")
    self:InjectView("enterRank")
    self:InjectView("progressBg")
    self:InjectView("zuanshi")
    self:InjectView("zuanshicishu")
    self:InjectView("hd_icon")
    self:InjectView("Sprite_7")
    self.BG:setPositionX(display.width / 2)
    self:setTime()
    self:initLayer()
    self:initContentAward()
    self:initButton()
    self:OnClick("enterRank", function(sender)
        local dialog = require("searchTreasure.src.rankAwardView").new({["data"] = model.treasureAwardList[sender:getTag()]})
        dialog:show()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self:OnClick("Panel_2", function()
        self:removeSelf()
    end,{["isScale"] = false})
end



function MainView:setTime()
    
    if model.endTime - qy.tank.model.UserInfoModel.serverTime <= 0 then
        self.Text_1:setString("活动已结束，请尽快领取排行奖励")
        self.Text_2:setString(os.date("%Y.%m.%d %H:%M:%S", model.endTime) .."-" .. os.date("%Y.%m.%d %H:%M:%S", model.endTime + 172800))
    else
        self.Text_1:setString(os.date("%Y.%m.%d %H:%M:%S", model.beginTime) .."-" .. os.date("%Y.%m.%d %H:%M:%S", model.endTime))
        self.Text_2:setString(os.date("%Y.%m.%d %H:%M:%S", model.endTime) .."-" .. os.date("%Y.%m.%d %H:%M:%S", model.endTime + 172800))
    end
end

function MainView:initLayer()
    
    self.Text_11:setString(qy.TextUtil:substitute(47002).. model.free_times..qy.TextUtil:substitute(45005))
    if model.free_times > 0 then
        self.Sprite_7:initWithSpriteFrameName("Resources/common/txt/mianfei.png")
        self.zuanshicishu:setVisible(false)
        self.zuanshi:setVisible(false)
        self.Text_11:setVisible(true)
    else
        self.Sprite_7:setTexture("searchTreasure/res/tansuoyici.png")
        self.Text_11:setVisible(false)
        self.zuanshicishu:setVisible(true)
        self.zuanshi:setVisible(true)
    end
    
    self.Text_4:setString(model.times .. " " ..qy.TextUtil:substitute(57009))
    for i=1, 7 do
        self["Button_" .. i]:stopAllActions()
        if i > #(model.timesAwardList) then
            self["Button_" .. i]:setVisible(false)
        else
            local progressBgWidth = 493 / #(model.timesAwardList)
            self["Button_" .. i]:setPositionX(self.progressBg:getPositionX() + progressBgWidth * (i ))
            self["Text1_" .. i]:setString(model.timesAwardList[i].times)

            -- 宝箱状态
            if model.times >= model.timesAwardList[i].times then
                if model.award_list == nil or table.keyof(model.award_list, model.timesAwardList[i].ID) == nil then
                    self["Button_" .. i]:loadTextureNormal("searchTreasure/res/20.png")
                    self["Button_" .. i]:loadTexturePressed("searchTreasure/res/20.png")
                    -- 宝箱摇晃动作
                    self["Button_" .. i]:stopAllActions()
                    local func1 = cc.RotateTo:create(0.1, -8)
                    local func2 = cc.RotateTo:create(0.1, 8)
                    local func3 = cc.RotateTo:create(0.1, -8)
                    local func4 = cc.RotateTo:create(0.1, 8)
                    local func5 = cc.RotateTo:create(0.1, -8)
                    local func6 = cc.RotateTo:create(0.1, 8)
                    local func7 = cc.RotateTo:create(0.05, 0)
                    local func10 = cc.ScaleTo:create(0.1, 1.1)
                    local func11 = cc.ScaleTo:create(0.1, 1)
                    local delay = cc.DelayTime:create(0.8)

                    local seq = cc.Sequence:create(func10, func1, func2, func3, func4, func5, func6, func7, func11, delay)
                    local func9 = cc.RepeatForever:create(seq)
                    self["Button_" .. i]:runAction(func9)
                else
                    self["Button_" .. i]:loadTextureNormal("searchTreasure/res/6.png")
                    self["Button_" .. i]:loadTexturePressed("searchTreasure/res/6.png")
                end
            else
                self["Button_" .. i]:loadTextureNormal("searchTreasure/res/7.png")
                self["Button_" .. i]:loadTexturePressed("searchTreasure/res/7.png")
            end
        end
    end

    -- 前五排名
    for i=1,5 do
        if model.searchRankList[i] then
            self["rank" .. i]:setVisible(true)
            self["rank" .. i]:setString(i .. ". ".. model.searchRankList[i].nickname)
            self["count_" .. i]:setString(model.searchRankList[i].cost)
        else
            self["rank" .. i]:setVisible(false)
        end
    end

    -- 进度条 
    self.bar = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("searchTreasure/res/8.png"))
    self.bar:setAnchorPoint(0,0)
    self.bar:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.bar:setMidpoint(cc.p(0,0))
    self.bar:setBarChangeRate(cc.p(1, 0))
    self.bar:setPosition(1, 4)
    self.progressBg:addChild(self.bar, 8)
    local nums = 0
    if model.times > model.timesAwardList[6].times then
        nums = (model.times - model.timesAwardList[6].times) * 0.428 + 1028
    elseif model.times > model.timesAwardList[5].times then
        nums = (model.times - model.timesAwardList[5].times) * 0.571 + 20*8.57 + 30*5.71 + 50*3.428 + 100 * 1.714 + 300 *0.571
    elseif model.times > model.timesAwardList[4].times then
        nums = (model.times - model.timesAwardList[4].times) * 0.571 + 20*8.57 + 30*5.71 + 50*3.428 + 100 * 1.714
    elseif model.times > model.timesAwardList[3].times then
        nums = (model.times - model.timesAwardList[3].times) * 1.714 + 20*8.57 + 30*5.71 + 50*3.428
    elseif model.times > model.timesAwardList[2].times then
        nums = (model.times - model.timesAwardList[2].times) * 3.428 + 20*8.57 + 30*5.71
    elseif model.times > model.timesAwardList[1].times then
        nums = (model.times - model.timesAwardList[1].times) * 5.71 + 20*8.57
    else
        nums = (model.times) * 8.57
    end
    self.bar:setPercentage(nums / model.timesAwardList[#(model.timesAwardList)].times * 100)

    -- 排行榜上的红点
    if model.endTime - qy.tank.model.UserInfoModel.serverTime <= 0  and model.myrank > 0 then
        if model.rank_award_get == 0 then
        else
            self.hd_icon:setVisible(false)
        end
    else
        self.hd_icon:setVisible(false)
    end

    
end

function MainView:initButton()
    self:OnClick("Button_1", function()
        local dialog = require("searchTreasure.src.showAward").new({["idx"] = 1})
        dialog:show()
    end,{["isScale"] = false})
    self:OnClick("Button_2", function()
        local dialog = require("searchTreasure.src.showAward").new({["idx"] = 2})
        dialog:show()
    end,{["isScale"] = false})
    self:OnClick("Button_3", function()
        local dialog = require("searchTreasure.src.showAward").new({["idx"] = 3})
        dialog:show()
    end,{["isScale"] = false})
    self:OnClick("Button_4", function()
        local dialog = require("searchTreasure.src.showAward").new({["idx"] = 4})
        dialog:show()
    end,{["isScale"] = false})
    self:OnClick("Button_5", function()
        local dialog = require("searchTreasure.src.showAward").new({["idx"] = 5})
        dialog:show()
    end,{["isScale"] = false})
    self:OnClick("Button_6", function()
        local dialog = require("searchTreasure.src.showAward").new({["idx"] = 6})
        dialog:show()
    end,{["isScale"] = false})
    self:OnClick("Button_7", function()
        local dialog = require("searchTreasure.src.showAward").new({["idx"] = 7})
        dialog:show()
    end,{["isScale"] = false})
    self:OnClick("Button_8", function()
        self:GetAwardByTypeAndNums(1, model.free_times > 0 and 0 or 1)
    end,{["isScale"] = false})
    self:OnClick("Button_9", function()
        self:GetAwardByTypeAndNums(1, 10)
    end,{["isScale"] = false})
    self:OnClick("Button_10", function()
        self:GetAwardByTypeAndNums(1, 50)
    end,{["isScale"] = false})
end

function MainView:playAction(reData)
    -- 闪烁的光圈
    for i=8, 10 do
        self["Button_" .. i]:setEnabled(false)
    end
    self:OnClick("Panel_2", function()
        
    end,{["isScale"] = false})
    self.enterRank:setEnabled(false)

    if self.pubBg then
    else
        self.pubBg = cc.Sprite:createWithSpriteFrameName("searchTreasure/res/19.png") 
        self.BG:addChild(self.pubBg, 12)
        self.pubBg:setScale(1.2)
        self.pubBg:setPosition(90 + 106 * (2), 170 + 90*(2))
    end

    local seq = cc.Sequence:create(
        cc.CallFunc:create(function()
            self.pubBg:runAction(cc.Sequence:create(cc.DelayTime:create(0.01), cc.CallFunc:create(function()
                qy.QYPlaySound.playEffect(qy.SoundType.OPEN_MENU)
                self.pubBg:setPosition(90 + 106 * (2), 170 + 90*(2))
            end)))
        end),
        cc.CallFunc:create(function()
            self.pubBg:runAction(cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(function()
                local x = math.random(1, 15)
                self.pubBg:setPosition(90 + 106 * (x%5), 170+360 - 90*(math.ceil(x/5)))
                qy.QYPlaySound.playEffect(qy.SoundType.OPEN_MENU)
            end)))
        end),
        cc.CallFunc:create(function()
            self.pubBg:runAction(cc.Sequence:create(cc.DelayTime:create(0.2), cc.CallFunc:create(function()
                local x = math.random(1, 15)
                self.pubBg:setPosition(90 + 106 * (x%5), 170+360 - 90*(math.ceil(x/5)))
                qy.QYPlaySound.playEffect(qy.SoundType.OPEN_MENU)
            end)))
        end),
        cc.CallFunc:create(function()
            self.pubBg:runAction(cc.Sequence:create(cc.DelayTime:create(0.3), cc.CallFunc:create(function()
                local x = math.random(1, 15)
                self.pubBg:setPosition(90 + 106 * (x%5), 170+360 - 90*(math.ceil(x/5)))
                qy.QYPlaySound.playEffect(qy.SoundType.OPEN_MENU)
            end)))
        end),
        cc.CallFunc:create(function()
            self.pubBg:runAction(cc.Sequence:create(cc.DelayTime:create(0.4), cc.CallFunc:create(function()
                local x = math.random(1, 15)
                self.pubBg:setPosition(90 + 106 * (x%5), 170+360 - 90*(math.ceil(x/5)))
                qy.QYPlaySound.playEffect(qy.SoundType.OPEN_MENU)
            end)))
        end),
        cc.CallFunc:create(function()
            self.pubBg:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(function()
                local x = math.random(1, 15)
                self.pubBg:setPosition(90 + 106 * (x%5), 170+360 - 90*(math.ceil(x/5)))
                qy.QYPlaySound.playEffect(qy.SoundType.OPEN_MENU)
            end)))
        end),
        cc.CallFunc:create(function()
            self.pubBg:runAction(cc.Sequence:create(cc.DelayTime:create(0.6), cc.CallFunc:create(function()
                local x = math.random(1, 15)
                self.pubBg:setPosition(90 + 106 * (x%5), 170+360 - 90*(math.ceil(x/5)))
                qy.QYPlaySound.playEffect(qy.SoundType.OPEN_MENU)
            end)))
        end),
        cc.CallFunc:create(function()
            self.pubBg:runAction(cc.Sequence:create(cc.DelayTime:create(0.7), cc.CallFunc:create(function()
                local x = math.random(1, 15)
                self.pubBg:setPosition(90 + 106 * (x%5), 170+360 - 90*(math.ceil(x/5)))
                qy.QYPlaySound.playEffect(qy.SoundType.OPEN_MENU)
            end)))
        end),
        cc.CallFunc:create(function()
            self.pubBg:runAction(cc.Sequence:create(cc.DelayTime:create(0.8), cc.CallFunc:create(function()
                local x = math.random(1, 15)
                self.pubBg:setPosition(90 + 106 * (x%5), 170+360 - 90*(math.ceil(x/5)))
                qy.QYPlaySound.playEffect(qy.SoundType.OPEN_MENU)
            end)))
        end),
        cc.CallFunc:create(function()
            self.pubBg:runAction(cc.Sequence:create(cc.DelayTime:create(0.9), cc.CallFunc:create(function()
                local x = math.random(1, 15)
                self.pubBg:setPosition(90 + 106 * (x%5), 170+360 - 90*(math.ceil(x/5)))
                qy.QYPlaySound.playEffect(qy.SoundType.OPEN_MENU)
            end)))
        end),
        cc.CallFunc:create(function()
            self.pubBg:runAction(cc.Sequence:create(cc.DelayTime:create(1), cc.CallFunc:create(function()
                local x = math.random(1, 15)
                self.pubBg:setPosition(90 + 106 * (x%5), 170+360 - 90*(math.ceil(x/5)))
                qy.QYPlaySound.playEffect(qy.SoundType.OPEN_MENU)
            end)))
        end),
        cc.CallFunc:create(function()
            self.pubBg:runAction(cc.Sequence:create(cc.DelayTime:create(1.1), cc.CallFunc:create(function()
                local x = math.random(1, 15)
                self.pubBg:setPosition(90 + 106 * (x%5), 170+360 - 90*(math.ceil(x/5)))
                qy.QYPlaySound.playEffect(qy.SoundType.OPEN_MENU)
            end)))
        end),
        cc.CallFunc:create(function()
            self.pubBg:runAction(cc.Sequence:create(cc.DelayTime:create(1.2), cc.CallFunc:create(function()
                local x = math.random(1, 15)
                self.pubBg:setPosition(90 + 106 * (x%5), 170+360 - 90*(math.ceil(x/5)))
                qy.QYPlaySound.playEffect(qy.SoundType.OPEN_MENU)
            end)))
        end),
        cc.CallFunc:create(function()
            self.pubBg:runAction(cc.Sequence:create(cc.DelayTime:create(1.3), cc.CallFunc:create(function()
                local x = math.random(1, 15)
                self.pubBg:setPosition(90 + 106 * (x%5), 170+360 - 90*(math.ceil(x/5)))
                qy.QYPlaySound.playEffect(qy.SoundType.OPEN_MENU)
            end)))
        end),
        cc.CallFunc:create(function()
            self.pubBg:runAction(cc.Sequence:create(cc.DelayTime:create(1.4), cc.CallFunc:create(function()
                local x = math.random(1, 15)
                self.pubBg:setPosition(90 + 106 * (x%5), 170+360 - 90*(math.ceil(x/5)))
                qy.QYPlaySound.playEffect(qy.SoundType.OPEN_MENU)
            end)))
        end),
        cc.CallFunc:create(function()
            self.pubBg:runAction(cc.Sequence:create(cc.DelayTime:create(1.5), cc.CallFunc:create(function()
                local x = math.random(1, 15)
                self.pubBg:setPosition(90 + 106 * (x%5), 170+360 - 90*(math.ceil(x/5)))
                qy.QYPlaySound.playEffect(qy.SoundType.OPEN_MENU)
            end)))
        end),
        cc.CallFunc:create(function()
            self.pubBg:runAction(cc.Sequence:create(cc.DelayTime:create(1.6), cc.CallFunc:create(function()
                local x = math.random(1, 15)
                self.pubBg:setPosition(90 + 106 * (x%5), 170+360 - 90*(math.ceil(x/5)))
                qy.QYPlaySound.playEffect(qy.SoundType.OPEN_MENU)
            end)))
        end),
        cc.CallFunc:create(function()
            self.pubBg:runAction(cc.Sequence:create(cc.DelayTime:create(1.7), cc.CallFunc:create(function()
                local x = math.random(1, 15)
                self.pubBg:setPosition(90 + 106 * (x%5), 170+360 - 90*(math.ceil(x/5)))
                qy.QYPlaySound.playEffect(qy.SoundType.OPEN_MENU)
            end)))
        end),
        cc.CallFunc:create(function()
            self.pubBg:runAction(cc.Sequence:create(cc.DelayTime:create(1.8), cc.CallFunc:create(function()
                self.pubBg:setPosition(90 + 106 * (2), 170 + 90*(2))
                qy.QYPlaySound.playEffect(qy.SoundType.OPEN_MENU)
            end)))
        end),
        cc.CallFunc:create(function()
            self.pubBg:runAction(cc.Sequence:create(cc.DelayTime:create(2.0), cc.CallFunc:create(function()
                qy.tank.command.AwardCommand:show(reData.award,{["critMultiple"] = reData.weight})
                self.enterRank:setEnabled(true)
                for i=8, 10 do
                    self["Button_" .. i]:setEnabled(true)
                end
                self:OnClick("Panel_2", function()
                    self:removeSelf()
                end,{["isScale"] = false})
                self:initLayer()
                qy.QYPlaySound.playEffect(qy.SoundType.OPEN_MENU)
            end)))
        end)
    )
    
    self.BG:runAction(seq)
end
function MainView:initContentAward()
    local awardData = model.treasureAwardList
    for i=1, #awardData do
        local x = i >=8 and (i + 1) or i
        
        local item = qy.tank.view.common.AwardItem.createAwardView(awardData[i].award[1] ,1)
        self.BG:addChild(item, 10)
        item:setPosition(90 + 106 * (x%5 == 0 and (4) or (x%5 - 1)), 170+360 - 90*(math.ceil(x/5)))
        item:setScale(0.8)
        item.name:setVisible(false)
    end

    -- 中间问号
    local pubFlag1 = cc.Sprite:createWithSpriteFrameName("Resources/common/item/item_bg_6.png") 
    self.BG:addChild(pubFlag1, 10)
    pubFlag1:setScale(0.8)
    pubFlag1:setPosition(90 + 106 * (2), 170 + 90*(2))
    local pubFlag = cc.Sprite:createWithSpriteFrameName("searchTreasure/res/1.png") 
    self.BG:addChild(pubFlag, 11)
    pubFlag:setPosition(90 + 106 * (2), 170 + 90*(2))
end

function MainView:GetAwardByTypeAndNums(type, nums)
        local aType = qy.tank.view.type.ModuleType
        service:getCommonGiftAward({
            ["type"] = type,
            ["times"] = nums,
            ["activity_name"] = aType.SEARCH_TREASURE
        }, aType.SEARCH_TREASURE,false, function(reData)
            self:initLayer()
            self:playAction(reData)
        end,false)
end

function MainView:onEnter()
    self.listener_1 = qy.Event.add(qy.Event.SEARCH_TREASURE,function(event)
        self:initLayer()
    end)
end

function MainView:onExit()
    qy.Event.remove(self.listener_1)
end
return MainView