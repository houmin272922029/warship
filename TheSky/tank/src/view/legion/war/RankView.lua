--[[
	排行榜
	Author: H.X.Sun
]]

local RankView = qy.class("RankView", qy.tank.view.BaseView, "legion_war/ui/RankView")

function RankView:ctor(delegate)
    RankView.super.ctor(self)
    local head = qy.tank.view.legion.war.HeadCell.new({
        ["onExit"] = delegate.dismiss,
    })
    self:addChild(head,10)
    self.delegate = delegate
    self.model = qy.tank.model.LegionWarModel

    self:InjectView("home_node")
    self:InjectView("t_info")
    self:InjectView("legion_rank")
    self:InjectView("legion_score")
    self:InjectView("my_rank")
    self:InjectView("point_title")
    self:InjectView("legion_point")

    self.tab = qy.tank.widget.TabButtonGroup.new("widget/TabButton1",{qy.TextUtil:substitute(53018), qy.TextUtil:substitute(53019),qy.TextUtil:substitute(53020),qy.TextUtil:substitute(53021)},cc.size(190,67),"h",function(idx)
        self:createContent(idx)
    end, 1)
    self:addChild(self.tab)
    self.tab:setPosition(qy.winSize.width/2-475,qy.winSize.height-140)
    self.tab:setLocalZOrder(4)
end

function RankView:createContent(_idx)
    if not tolua.cast(self.leList,"cc.Node") then
        self.leList = qy.tank.view.legion.war.LeRankList.new({["view"] = 2})
        self.home_node:addChild(self.leList)
        self.leList:setPosition(-488,-207)
    end
    if not tolua.cast(self.usList,"cc.Node") then
        self.usList = qy.tank.view.legion.war.UsRankList.new({["view"] = 2})
        self.home_node:addChild(self.usList)
        self.usList:setPosition(-150,-207)
    end
    self.leList:update(_idx)
    self.usList:update(_idx)
    if _idx == 3 then
        self.point_title:setVisible(true)
    else
        self.point_title:setVisible(false)
    end
    local data = self.model:getTotalRankData()
    if _idx == 1 then
        self.legion_rank:setString(data.sum.s_my_legion_rank)
        self.legion_score:setString(data.sum.s_my_legion_score)
        self.my_rank:setString(data.sum.s_my_rank)
        self.legion_point:setString(data.sum.s_my_legion_point)
    elseif _idx == 2 then
        self.legion_rank:setString(data.one.s_my_legion_rank)
        self.legion_score:setString(data.one.s_my_legion_score)
        self.my_rank:setString(data.one.s_my_rank)
        self.legion_point:setString(data.one.s_my_legion_point)
    elseif _idx == 3 then
        self.legion_rank:setString(data.two.s_my_legion_rank)
        self.legion_score:setString(data.two.s_my_legion_score)
        self.my_rank:setString(data.two.s_my_rank)
        self.legion_point:setString(data.two.s_my_legion_point)
    else
        self.legion_rank:setString(data.three.s_my_legion_rank)
        self.legion_score:setString(data.three.s_my_legion_score)
        self.my_rank:setString(data.three.s_my_rank)
        self.legion_point:setString(data.three.s_my_legion_point)
    end
end

function RankView:onEnter()

end

function RankView:onExit()

end

return RankView
