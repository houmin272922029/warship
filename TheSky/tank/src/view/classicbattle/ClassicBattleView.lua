--[[
	经典战役
	Author: Aaron Wei
	Date: 2015-04-28 16:39:32
]]

local ClassicBattleView = qy.class("ClassicBattleView", qy.tank.view.BaseView, "view/classicbattle/ClassicBattleView")

function ClassicBattleView:ctor(delegate)
    ClassicBattleView.super.ctor(self)
    self.delegate = delegate
    self.userInfo = qy.tank.model.UserInfoModel.userInfoEntity
    self.model = qy.tank.model.ClassicBattleModel
    self.cardList = nil

    self:InjectView("resource")
    self.energyNode = qy.tank.view.common.EnergyNode.new()
    self.resource:addChild(self.energyNode)
    self.energyNode:setPosition(30, -20)

    self:InjectView("diamond")
    self:InjectView("tankImg")
    self:InjectView("helpBtn")
    self:InjectView("embattleBtn")
    self:InjectView("cardPanel")
    self:InjectView("refreshBtn")
    self:InjectView("refreshLabel")
    self:InjectView("refreshCost")
    self:InjectView("refreshDiamond")
    self:InjectView("fightPowerTitle")
    self:InjectView("count")

    -- self.fightPower = qy.tank.widget.Attribute.new({
    --     ["numType"] = 6, --num_6.png
    --     ["hasMark"] = 0, --0没有加减号，1:有 默认为0
    --     ["value"] = 0,
    -- })
    -- self.fightPower:setPosition(qy.winSize.width-400,50)
    -- self:addChild(self.fightPower)

    self.fightPower = qy.tank.view.common.FightPower.new()
    self.fightPower:setPosition(qy.winSize.width-400,48)
    self:addChild(self.fightPower)
    self.fightPower:update()

    -- for i = 1,5 do
    --     self:InjectView("heart_"..i)
    -- end

    self:OnClick("exitBtn", function(sender)
        if delegate and delegate.dismiss then
            delegate.dismiss()
        end
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self:OnClick("helpBtn", function(sender)
        qy.tank.view.common.HelpDialog.new(5):show(true)
    end)

    self:OnClick("embattleBtn", function(sender)
        qy.tank.command.GarageCommand:showFormationDialog()
    end)

    self:OnClick("refreshBtn", function(sender)
        local service = qy.tank.service.ClassicBattleService
        service:manualrefresh(function()
            self:renderBaseInfo()
            self:renderCardList()
        end)
    end)

    if not self.cardList or #self.cardList == 0 then
    	self.cardList = {}
		for i=1,3 do
			local card = qy.tank.view.classicbattle.ClassicBattleCard.new({
                ["fight"] = function(entity)
                    local node = require("csd.view.classicbattle.ClassicBattleTip").create()["root"]
                    node.typeDes = node:getChildByName("battleTypeDes")
                    node.des = node:getChildByName("battleDes")
                    qy.tank.utils.TextUtil:autoChangeLine(node.typeDes,cc.size(400,60))
                    qy.tank.utils.TextUtil:autoChangeLine(node.des,cc.size(360,60))
                    node.typeDes:setString(entity.typeDes)
                    node.des:setString(entity.story)

                    qy.alert:showWithNode({entity.name,{255, 255, 255}},node,cc.size(500,300),{{qy.TextUtil:substitute(7002),4},{qy.TextUtil:substitute(7003),5}},function(label)
                        if label == qy.TextUtil:substitute(7003) then
                            local service = qy.tank.service.ClassicBattleService
                            service:startfight(entity.id,function(response)
                                self:update()
                                qy.tank.manager.ScenesManager:pushBattleScene()
                                -- qy.tank.manager.ScenesManager:pushScene(qy.tank.view.scene.BattleScene.new())
                            end)
                        end
                    end)
                    node:setPosition(-200,-40)
                end
            })
			card:setPosition(-230+(i-1)*330,110)
			self.cardPanel:addChild(card)
			self.cardList[i] = card
		end
	end

    self:update()

end

function ClassicBattleView:onEnter()
    self.listener = qy.Event.add(qy.Event.BATTLE_AWARDS_SHOW,function(event)
        qy.tank.command.AwardCommand:add(event._usedata.award)
        qy.tank.command.AwardCommand:show(event._usedata.award)
        self:renderBaseInfo()
        self:renderCardList()
    end)
end

function ClassicBattleView:onExit()
    qy.Event.remove(self.listener)
end

function ClassicBattleView:onCleanup()
    print("ClassicBattleView:onCleanup")
    qy.tank.utils.cache.CachePoolUtil.removePlist("Resources/classicbattle/classicbattle",1)
    qy.tank.utils.cache.CachePoolUtil.removeTextureForKey("Resources/classicbattle/JDZ_1.jpg")
    qy.tank.utils.cache.CachePoolUtil.removeTextureForKey("Resources/classicbattle/JDZ_2.jpg")
end

function ClassicBattleView:renderBaseInfo()
    -- self:setHeartNum(self.model.red_heart_num)
    self.count:setString(tostring(self.model.red_heart_num))
	self.diamond:setString(tostring(self.userInfo:getDiamondStr()))
    -- self.fightPower:update(self.model.fight_power)
    self.fightPower:update()

    if self.model.is_free > 0 then
        -- self.refreshBtn:setTitleText("免费刷新")
        self.refreshLabel:setSpriteFrame("Resources/common/txt/mianfeishuaxin.png")
        self.refreshLabel:setPosition(85,33)
        self.refreshDiamond:setVisible(false)
        self.refreshCost:setVisible(false)
    else
        -- self.refreshBtn:setTitleText("刷新        ")
        self.refreshLabel:setSpriteFrame("Resources/common/txt/refresh.png")
        self.refreshLabel:setPosition(qy.InternationalUtil:getBattleResultViewRefreshLabelX(),33)
        self.refreshDiamond:setVisible(true)
        self.refreshCost:setVisible(true)
    end
end

function ClassicBattleView:renderCardList()
	for i = 1,3 do
		local card = self.cardList[i]
		card:render(self.model.cardList[i])
	end
end

function ClassicBattleView:update()
    self:renderBaseInfo()
    self:renderCardList()
end

-- function ClassicBattleView:setHeartNum(num)
--     local heart = nil
--     if self.heartList then
--         for i=1,#self.heartList do
--             heart = self.heartList[i]
--             if heart and heart:getParent() then
--                 heart:getParent():removeChild(heart)
--                 heart = nil
--             end
--         end
--     end

--     self.heartList = {}
--     for i=1,num do
--         heart = cc.Sprite:create("")
--         table.insert(self.heartList,heart)
--         heart:setPosition(290+i*35,684)
--         self:addChild(heart)
--     end
-- end

return ClassicBattleView
