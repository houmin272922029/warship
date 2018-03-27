--[[
	宴会等待
	Author: H.X.Sun
]]

local WaitMsgCell = qy.class("WaitMsgCell", qy.tank.view.BaseView,"legion/ui/club/WaitMsgCell")

function WaitMsgCell:ctor(delegate)
    WaitMsgCell.super.ctor(self)
    self.model = qy.tank.model.LegionModel
    self:InjectView("name_txt")
    self:InjectView("level_txt")
    self:InjectView("open_txt")
end

function WaitMsgCell:update(_idx)
    local data = self.model:getPWaitMsgDataByIndex(_idx)

    if data then
        if self.model:getCommanderEntity():getPartyMasterId() == data.kid then
            self.open_txt:setString(qy.TextUtil:substitute(51043))
        else
            self.open_txt:setString("")
        end
        self.name_txt:setString(data.name)
        self.level_txt:setString(string.format("Lv.%s", data.level))
        self.name_txt:setTextColor(cc.c4b(254,228,139,255))
        self.level_txt:setVisible(true)
    else
        self.name_txt:setString(qy.TextUtil:substitute(51044))
        self.name_txt:setTextColor(cc.c4b(190,191,192,255))
        self.level_txt:setString("")
        self.open_txt:setString("")
    end
end

return WaitMsgCell
