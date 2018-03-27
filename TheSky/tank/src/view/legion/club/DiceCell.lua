--[[
	骰子cell
	Author: H.X.Sun
]]

local DiceCell = qy.class("DiceCell", qy.tank.view.BaseView,"legion/ui/club/DiceCell")

function DiceCell:ctor(delegate)
    DiceCell.super.ctor(self)
    self:InjectView("rank_txt")
    self:InjectView("name_txt")
    self:InjectView("p_count")
    self:InjectView("reward_txt")
    self.model = qy.tank.model.LegionModel
    self.userModel = qy.tank.model.UserInfoModel
end

function DiceCell:update(data)
    self.rank_txt:setString(data.rank)
    self.name_txt:setString(data.name)
    self.p_count:setString(data.score)
    self.reward_txt:setString(data.dia_num)
    if self.userModel.userInfoEntity.kid == data.kid then
        self.name_txt:setTextColor(cc.c4b(252,224,0,255))
        self.rank_txt:setTextColor(cc.c4b(252,224,0,255))
        self.p_count:setTextColor(cc.c4b(252,224,0,255))
        self.reward_txt:setTextColor(cc.c4b(252,224,0,255))
    else
        self.name_txt:setTextColor(cc.c4b(255,255,255,255))
        self.rank_txt:setTextColor(cc.c4b(255,255,255,255))
        self.p_count:setTextColor(cc.c4b(255,255,255,255))
        self.reward_txt:setTextColor(cc.c4b(255,255,255,255))
    end
end

return DiceCell
