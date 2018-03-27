

local LeaderboardItem = qy.class("LeaderboardItem", qy.tank.view.BaseView, "endless_war/ui/LeaderboardItem")

local StorageModel = qy.tank.model.StorageModel
local service = qy.tank.service.EndlessWarService

function LeaderboardItem:ctor(delegate)
    LeaderboardItem.super.ctor(self)
    self.model = qy.tank.model.EndlessWarModel
    
    self:InjectView("rank")
    self:InjectView("backgroup")--
    self:InjectView("name")--
    self:InjectView("level")

    self.data =  self.model.ranklist
 
    self.rankLabel = ccui.TextAtlas:create("300", "endless_war/fx/level_number.png", 26, 25, '0')
    self.rankLabel:setAnchorPoint(0.5, 0.5)
    self.rankLabel:setPosition(68, 25)
    self.rankLabel:addTo(self.rank)

    self.levelLabel = ccui.TextAtlas:create("300", "endless_war/fx/rank_number.png", 37, 36, '0')
    self.levelLabel:setPosition(630.00, 48)
    self.levelLabel:addTo(self)
  
end

function LeaderboardItem:render(_idx)
    if  _idx < 4 then
        self.rank:setVisible(false)
        self.backgroup:setSpriteFrame("endless_war/res/".._idx.."s.png")
    else
        self.rank:setVisible(true)
        self.backgroup:setSpriteFrame("endless_war/res/4s.png")
        self.rankLabel:setString(_idx)
    end
    self.name:setString(self.data[_idx].nickname)
    self.level:setString("")
    -- self.level:setString(self.data[_idx].nickname)
    self.levelLabel:setString(self.data[_idx].checkpoint )
end

return LeaderboardItem
