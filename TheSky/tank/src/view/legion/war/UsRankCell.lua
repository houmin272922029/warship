--[[
	个人排名cell
	Author: H.X.Sun
]]

local UsRankCell = qy.class("UsRankCell", qy.tank.view.BaseView, "legion_war/ui/UsRankCell")

local userModel = qy.tank.model.UserInfoModel

function UsRankCell:ctor(params)
    UsRankCell.super.ctor(self)
    self:InjectView("rank_pic")
    self:InjectView("rank_txt")
    self:InjectView("legion_name")
    self:InjectView("user_name")
    self:InjectView("win_txt")
    self.model = qy.tank.model.LegionWarModel
end

function UsRankCell:render(cell_data)
    local data = self.model:getUserRankData(cell_data.idx,cell_data.tab_idx)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("legion_war/res/legion_war.plist")
    if cell_data.idx < 4 then
        self.rank_pic:setVisible(true)
        self.rank_txt:setString("")
        self.rank_pic:setSpriteFrame("legion_war/res/c_t_"..cell_data.idx..".png")
    else
        self.rank_txt:setString(cell_data.idx)
        self.rank_pic:setVisible(false)
    end
    self.win_txt:setTextColor(self.model:getColorByRank(cell_data.idx))
    self.user_name:setString(data.name)
    self.legion_name:setString(data.legion_name)
    self.win_txt:setString(qy.TextUtil:substitute(53038, data.score))

    if userModel.userInfoEntity.kid == data.kid then
        self.rank_txt:setTextColor(cc.c4b(2, 204, 253, 255))
        self.user_name:setTextColor(cc.c4b(2, 204, 253, 255))
    else
        self.rank_txt:setTextColor(cc.c4b(255, 255, 255, 255))
        self.user_name:setTextColor(cc.c4b(255, 255, 255, 255))
    end
end

return UsRankCell
