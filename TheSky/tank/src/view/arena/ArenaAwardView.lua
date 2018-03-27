--[[
	竞技场五连抽
	Author: Aaron Wei
	Date: 2015-05-25 16:58:36
]]

local ArenaAwardView = qy.class("ArenaAwardView", qy.tank.view.BaseView, "view/arena/ArenaAwardView")

function ArenaAwardView:ctor(delegate)
    ArenaAwardView.super.ctor(self)

    self.delegate = delegate
    self.model = qy.tank.model.ArenaModel
    self.awards = delegate.awards
    self.show_awards = delegate.show_awards

    self:InjectView("panel")
    self:OnClick("panel",function()
    	if delegate and delegate.dismiss then
    	    delegate.dismiss()
        end
    end,{["isScale"] = false})
    self.panel:setTouchEnabled(false)
    qy.Event.dispatch(qy.Event.SHARE_SHOP)
end

function ArenaAwardView:onEnter()
    qy.tank.utils.cache.CachePoolUtil.addArmatureFile("fx/".. qy.language .."/ui/ui_fx_fanpai")

    if not tolua.cast(self.awardList,"cc.Node") then
        self.awardList = qy.AwardList.new({
            ["award"] = {},
            -- ["award"] = self.show_awards,
            ["hasName"] = false,
            ["type"] = 1,
            ["cellSize"] = cc.size(205,100),
            ["itemSize"] = 1,
            ["len"] = 5
        })
        self.panel:addChild(self.awardList)
        self.awardList:setPosition(230,460)
    end

    self.cards = {}
    self.timer = qy.tank.utils.Timer.new(0.15,5,function()
        local card  = qy.tank.view.arena.ArenaAwardCard.new({
            ["onClick"] = function(idx)
                for i=1,5 do
                    self.cards[i].card:setTouchEnabled(false)
                end

                table.insert(self.show_awards,idx,self.awards[1])

                self.awardList:update(self.show_awards)
                self.delay = qy.tank.utils.Timer.new(1,1,function()
                    for i=1,5 do
                        if i ~= idx then
                            self.cards[i]:playFx()
                        end
                    end
                    local award_delay = qy.tank.utils.Timer.new(1,1,function()
                        self.panel:setTouchEnabled(true)
                        qy.tank.command.AwardCommand:show(self.awards)
                        
                    end)
                    award_delay:start()
                end)
                self.delay:start()
            end
        })
        card.idx = self.timer.currentCount
        local x,y = 230+(self.timer.currentCount-1)*205,370
        card:setOpacity(0)
        -- card:setPosition(x+(self.timer.currentCount-3)*200,y+500)
        card:setPosition(640,y+500)
        card:setScale(1.5)
        self.panel:addChild(card)
        table.insert(self.cards,card)

        local fade1 = cc.FadeIn:create(0.5)
        local move1 = cc.MoveTo:create(0.2,cc.p(x,y))
        local move2 = cc.EaseExponentialInOut:create(cc.MoveTo:create(0.5,cc.p(x,y)))
        local scale1 = cc.ScaleTo:create(0.2,0.5)
        local scale2 = cc.ScaleTo:create(0.1,1.5)
        local scale3 = cc.ScaleTo:create(0.1,0.9)
        local sound = cc.CallFunc:create(function()
            qy.QYPlaySound.playEffect(qy.SoundType.SWITCH_CHAPTER)
        end)

        local seq1 = cc.Sequence:create(sound,scale1,scale2,scale3)
        local spawn1 = cc.Spawn:create(fade1,move1,seq1)
        card:runAction(cc.Sequence:create(spawn1,cc.CallFunc:create(function()
            if card.idx >= 5 then
                for j=1,5 do
                    local item = self.cards[j]
                    item.card:setTouchEnabled(true)
                end
            end
        end)))

    end)
    self.timer:start()
end

function ArenaAwardView:onExit()
end

function ArenaAwardView:onCleanup()
    print("ArenaAwardView:onCleanup")
end

return ArenaAwardView
