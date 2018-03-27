--[[
	群战-结果
	Author: H.X.Sun
]]

local BattleResultDialog = qy.class("BattleResultDialog", qy.tank.view.BaseDialog, "war_group/ui/BattleResultDialog")

function BattleResultDialog:ctor(delegate)
    BattleResultDialog.super.ctor(self)
    self:InjectView("bg")
    self:InjectView("award_node")
    self:InjectView("title")
    local model = qy.tank.model.WarGroupModel

    if model:getBattleType() == model.BATTLE_GROUP_BATTLES then
        -- 多人副本
        if model:isAttackWin() then
            self.title:setString("获得奖励")
            self.title:setPosition(0,57)
            self.bg:setSpriteFrame("war_group/res/win_2.png")
        else
            self.title:setString("重整军备，向胜利前进！")
            self.title:setPosition(0,0)
            self.bg:setSpriteFrame("war_group/res/failure_2.png")
        end

        local award = model:getBattleAward()
        if award and #award > 0 then
            local awardList = qy.AwardList.new({
                ["award"] = award,
                ["cellSize"] = cc.size(160,180),
                ["itemSize"] = 1,
            })
            self.award_node:addChild(awardList)
            awardList:setPosition(-160,160)
        end
    elseif model:getBattleType() == model.BATTLE_ATTACKBERLIN then
        if model:isAttackWin() then
            self.bg:setSpriteFrame("war_group/res/win_2.png")
        else
            self.title:setString("重整军备，向胜利前进！")
            self.title:setPosition(0,0)
            self.bg:setSpriteFrame("war_group/res/failure_2.png")
        end
    else
        -- 军团战
        self.award_node:removeAllChildren()
        self.bg:setSpriteFrame("war_group/res/win_1.png")
        local richTxt = ccui.RichText:create()
        richTxt:ignoreContentAdaptWithSize(false)
        richTxt:setContentSize(500, 50)
        richTxt:setAnchorPoint(0.5,0.5)
        local stringTxt1 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, qy.TextUtil:substitute(64003) , qy.res.FONT_NAME, 24)
        richTxt:pushBackElement(stringTxt1)
        local stringTxt2 = ccui.RichElementText:create(2, cc.c3b(2, 204, 253), 255, delegate.name , qy.res.FONT_NAME, 24)
        richTxt:pushBackElement(stringTxt2)
        local stringTxt3 = ccui.RichElementText:create(3, cc.c3b(255,255,255), 255, qy.TextUtil:substitute(64004) , qy.res.FONT_NAME, 24)
        richTxt:pushBackElement(stringTxt3)
        richTxt:setPosition(447,175)

        self.bg:addChild(richTxt)
    end

    self:OnClick("btn",function()
        self:dismiss()
        delegate.callback()
    end)


end


return BattleResultDialog
