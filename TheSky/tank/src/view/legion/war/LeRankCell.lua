--[[
	军团排名cell
	Author: H.X.Sun
]]

local LeRankCell = qy.class("LeRankCell", qy.tank.view.BaseView, "legion_war/ui/LeRankCell")

function LeRankCell:ctor(params)
    LeRankCell.super.ctor(self)
    self:InjectView("rank_pic")
    self:InjectView("rank_txt")
    self:InjectView("score_bg")
    self:InjectView("score_txt")
    self:InjectView("bg")
    self:InjectView("legion_name")
    self.model = qy.tank.model.LegionWarModel
end

function LeRankCell:render(cell_data)
    local data = self.model:getLegionRankData(cell_data.idx,cell_data.tab_idx)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("legion_war/res/legion_war.plist")
    if cell_data.idx < 4 then
        self.rank_pic:setVisible(true)
        self.rank_txt:setString("")
        self.rank_pic:setSpriteFrame("legion_war/res/c_t_"..cell_data.idx..".png")
        self.bg:setSpriteFrame("legion_war/res/c_b_"..cell_data.idx..".png")
        self.bg:setVisible(true)
    else
        self.rank_txt:setString(cell_data.idx)
        self.rank_pic:setVisible(false)
        self.bg:setVisible(false)
    end
    if data then
        self.score_bg:setVisible(cell_data.has_score)
        self.legion_name:setString(data.name)
        if cell_data.has_score then
            if cell_data.tab_idx == 3 then
                self.score_txt:setString(self.model:formattPoint(data.score))
            else
                self.score_txt:setString(self.model:formattScore(data.score))
            end
        end
        if self.model:getMyLegionId() == data.legion_id then
            self.legion_name:setTextColor(cc.c4b(2, 204, 253, 255))
            self.rank_txt:setTextColor(cc.c4b(2, 204, 253, 255))
        else
            self.legion_name:setTextColor(cc.c4b(255, 255, 255, 255))
            self.rank_txt:setTextColor(cc.c4b(255, 255, 255, 255))
        end
    else
        self.legion_name:setString(qy.TextUtil:substitute(53011))
        self.score_bg:setVisible(false)
    end
end

return LeRankCell
