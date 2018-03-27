--[[
	经典战役卡
	Author: Your Name
	Date: 2015-04-29 16:13:40
]]

local ClassicBattleCard = qy.class("ClassicBattleCard", qy.tank.view.BaseView, "view/classicbattle/ClassicBattleCard")

function ClassicBattleCard:ctor(delegate) 
    ClassicBattleCard.super.ctor(self)
    self.delegate = delegate

    self:InjectView("battleName")
    self:InjectView("img")                                      
    self:InjectView("story")
    self:InjectView("power")
    self:InjectView("startBtn")
    -- self:InjectView("energy")
    self:InjectView("star")
    qy.tank.utils.TextUtil:autoChangeLine(self.story , cc.size(255 , 70))

    for i = 1,5 do
        self:InjectView("star"..i)
    end

    for i = 1,3 do
        self:InjectView("iconBG"..i)
        self:InjectView("icon"..i)
    end

    self:OnClick("startBtn",function(sender)
    	if delegate and delegate.fight then
            delegate.fight(self.entity)
        end
    end)
end

function ClassicBattleCard:render(entity)
    self.entity = entity
    local function setStar(num)
        for i=1,5 do
            local star = self["star"..i] 
            star:setVisible(i<=num)
        end
        self.star:setPositionX(0-num*20)
    end
	if entity then
        self.battleName:setFontName(qy.res.FONT_NAME)
        self.battleName:setString(entity.name)
        self.battleName:enableOutline(cc.c4b(0,0,0,255),1)

        self.img:setTexture(entity.battle_img)
        self.story:setString(entity.story)

        self.power:setFontName(qy.res.FONT_NAME)
        self.power:setString(qy.TextUtil:substitute(7001, entity.power))
        self.power:setColor(entity.color)
        self.power:enableOutline(cc.c4b(0,0,0,255),1)

		-- self.energy:setString(entity.energy)
		setStar(entity.star)

        if not tolua.cast(self.awardList,"cc.Node") then 
            self.awardList = qy.AwardList.new({
                ["award"] = entity.awards_show,
                ["hasName"] = false,
                ["type"] = 1,
                ["cellSize"] = cc.size(90,100),
                ["itemSize"] = 2, 
            })
            self:addChild(self.awardList)
            self.awardList:setPosition(-90,-15)
        else
            self.awardList:update(entity.awards_show)
        end
	end
end

return ClassicBattleCard
