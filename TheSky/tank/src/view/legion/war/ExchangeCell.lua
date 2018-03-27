--[[
	兑换cell
	Author: H.X.Sun
]]

local ExchangeCell = qy.class("ExchangeCell", qy.tank.view.BaseView, "legion_war/ui/ExchangeCell")

local AwardItem = qy.tank.view.common.AwardItem

function ExchangeCell:ctor(params)
    ExchangeCell.super.ctor(self)
    local service = qy.tank.service.LegionWarService
    self.model = qy.tank.model.LegionWarModel

    self:InjectView("bg")
    self:InjectView("angle_icon")
    self:InjectView("num_txt")
    self:InjectView("btn")
    self:OnClick("btn",function()
        if self.remain_num > 0 then
            service:shopBuy(self.index,self.id, function()
                self:render(self.index)
                if params and params.updateProps then
                    params.updateProps()
                end
            end)
        else
            qy.hint:show(qy.TextUtil:substitute(53001))
        end
    end)
end

function ExchangeCell:render(index)
    local data = self.model:getShopDataByIdx(index)
    if data then
        cc.SpriteFrameCache:getInstance():addSpriteFrames("legion_war/res/legion_war.plist")
        self.id = data.id
        self.index = index
        self.remain_num = data.remain_num
        self.num_txt:setString(qy.TextUtil:substitute(53002, data.remain_num))
        if data.label == 3 then
            self.angle_icon:setVisible(false)
        else
            self.angle_icon:setSpriteFrame("legion_war/res/angle_icon_"..data.label..".png")
            self.angle_icon:setVisible(true)
        end
        if data.remain_num > 0 then
            self.btn:setBright(true)
        else
            self.btn:setBright(false)
        end

        if not tolua.cast(self.awardList,"cc.Node") then
            self.awardList = qy.AwardList.new({
                ["award"] = data.award,
                ["hasName"] = false,
                ["type"] = 1,
                ["cellSize"] = cc.size(345,100),
            })
            self.bg:addChild(self.awardList)
            self.awardList:setPosition(200,170)
        else
            self.awardList:update(data.award)
        end
    end
end

return ExchangeCell
