--[[
	菜单cell
	Author: H.X.Sun
]]

local FarmGetCell = qy.class("FarmGetCell", qy.tank.view.BaseView, "legion/ui/club/FarmGetCell")

local service = qy.tank.service.LegionService
local AwardType = qy.tank.view.type.AwardType
local AwardUtils = qy.tank.utils.AwardUtils

function FarmGetCell:ctor(delegate)
    FarmGetCell.super.ctor(self)
    self:InjectView("title_txt")
    self:InjectView("cost_txt")
    self:InjectView("get_txt")
    self:InjectView("coin")
    self:InjectView("btn")
    self.model = qy.tank.model.LegionModel
    self.userModel = qy.tank.model.UserInfoModel

    self:OnClick("btn",function()
        if self.model.isGetFarm then
            qy.hint:show(qy.TextUtil:substitute(51014))
        elseif self.model:getRemainNum() <= 0 then
            qy.hint:show(qy.TextUtil:substitute(51015))
        else
            service:getFarmGet(self.data.tag,function()
                qy.hint:show(qy.TextUtil:substitute(51013, self.data.name))
                delegate.update()
            end)
        end
    end)
end

function FarmGetCell:update(i)
    local data = self.model:getFarmDataByIdx(i)
    self.data = data
    if self.model.isGetFarm or self.model:getRemainNum() <= 0 then
        self.btn:setBright(false)
    else
        self.btn:setBright(true)
    end
    if data then
        self["title_txt"]:setString(data.name)
        local color = self.model:getColorByIdx(1,data.color)
        self["title_txt"]:setTextColor(color)
        -- self["get_txt"]:setString("获得军团建设度" .. data.legion_exp .. "，功勋" ..data.contribution)
        self["get_txt"]:setString(qy.TextUtil:substitute(51016, data.legion_exp))
        self["coin"]:setTexture(AwardUtils.getAwardIconByType(data.cost_type,2))
        if data.cost_type == AwardType.DIAMOND then
            self["coin"]:setScale(1.2)
        else
            self["coin"]:setScale(0.5)
        end
        local _cost_num = 0
        if data.cost_type == AwardType.SILVER then
            _cost_num = data.cost_num * self.userModel.userInfoEntity.level
        else
            _cost_num = data.cost_num
        end
        self["cost_txt"]:setString(qy.InternationalUtil:getResNumString(_cost_num))
    end
end


return FarmGetCell
