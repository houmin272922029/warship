--[[
	骰子cell
	Author: H.X.Sun
]]

local BankCell = qy.class("BankCell", qy.tank.view.BaseView,"legion/ui/club/BankCell")

function BankCell:ctor(delegate)
    BankCell.super.ctor(self)
    self.model = qy.tank.model.LegionModel
    self.userModel = qy.tank.model.UserInfoModel
    self:InjectView("bg")
    self:InjectView("rank_txt")
    self:InjectView("num_txt")
    self:InjectView("name_txt")
end

function BankCell:update(data)
    self.rank_txt:setString(data.rank)
    if data.rank % 2 == 0 then
        self.bg:setVisible(true)
    else
        self.bg:setVisible(false)
    end
    self.name_txt:setString(data.name)
    self.num_txt:setString(data.score)
    if self.userModel.userInfoEntity.kid == data.kid then
        self.rank_txt:setTextColor(cc.c4b(252,224,0,255))
        self.name_txt:setTextColor(cc.c4b(252,224,0,255))
        self.num_txt:setTextColor(cc.c4b(252,224,0,255))
    else
        self.rank_txt:setTextColor(cc.c4b(255,255,255,255))
        self.name_txt:setTextColor(cc.c4b(255,255,255,255))
        self.num_txt:setTextColor(cc.c4b(255,255,255,255))
    end
end

return BankCell
