--[[
	军团大厅
	Author: H.X.Sun
]]

local HallView = qy.class("HallView", qy.tank.view.BaseView, "legion/ui/basic/HallView")

local service = qy.tank.service.LegionService
local RedDotModel = qy.tank.model.RedDotModel
local InternationalUtil = qy.tank.utils.InternationalUtil

function HallView:ctor(delegate)
    HallView.super.ctor(self)
    local head = qy.tank.view.legion.HeadCell.new({
        ["onExit"] = delegate.dismiss,
        ["showLine"] = true,
        ["titleUrl"] = "legion/res/juntuan.png",
    })
    self:addChild(head,10)
    self.delegate = delegate
    self.model = qy.tank.model.LegionModel

    self:InjectView("post_name")
    self:InjectView("audit_node")
    self:InjectView("rank_node")
    self:InjectView("legion_node")
    self:InjectView("mail_btn")

    self.tab = qy.tank.widget.TabButtonGroup.new("widget/TabButton1",{qy.TextUtil:substitute(50042), qy.TextUtil:substitute(50043),qy.TextUtil:substitute(50044)},cc.size(190,67),"h",function(idx)
        self:createContent(idx)
    end, 1)
    self:addChild(self.tab)
    self.tab:setPosition(110,qy.winSize.height-140)
    self.tab:setLocalZOrder(4)

    self:OnClick("mail_btn",function()
        delegate.chooseMail()
    end)
end

function HallView:dealWithMailBtn(flag)
    if InternationalUtil:hasLegionMail() then
        self.mail_btn:setVisible(flag)
    end
end

function HallView:updatePost()
    self.post_name:setString(self.model:getCommanderEntity():getPostName())
    if self.model:getCommanderEntity():canAudit() then
        self.tab.btns[3]:setVisible(true)
    else
        self.tab.btns[3]:setVisible(false)
    end
    self:dealWithMailBtn(self.model:getCommanderEntity():canAudit())
end

function HallView:__createBasicView()
    if not tolua.cast(self.postView,"cc.Node") then
        self.postView = qy.tank.view.legion.basic.PostRankList.new({
            ["updatePost"] = function()
                self:updatePost()
            end,
            ["onExit"] = function()
                self.delegate.dismiss(true)
            end
        })
        self.rank_node:addChild(self.postView)
        self.postView:setPosition(-208,-346)
    else
        self.postView:update()
    end

    if not tolua.cast(self.rIntroView,"cc.Node") then
        self.rIntroView = qy.tank.view.legion.basic.IntroduceCell.new({
            ["callback"] = function (  )
                self.rankView = {}
            end,
            ["isModify"] = true
        })
        self.rank_node:addChild(self.rIntroView)
        self.rIntroView:setPosition(-536,-346)
        self.rIntroView:render(self.model:getHisLegion())
    else
        self.rIntroView:render(self.model:getHisLegion())
    end
end

function HallView:createContent(_idx)
    if _idx == 2 then
        --排行榜
        self.legion_node:setVisible(true)
        self.rank_node:setVisible(false)
        self.audit_node:setVisible(false)

        if not tolua.cast(self.rankView,"cc.Node") then
            service:getLegionList({["page"] = 1},function()

                if not tolua.cast(self.lIntroView,"cc.Node") then
                    self.lIntroView = qy.tank.view.legion.basic.IntroduceCell.new()
                    self.legion_node:addChild(self.lIntroView)
                    self.lIntroView:setPosition(-536,-346)
                end

                self.rankView = qy.tank.view.legion.basic.LegionRankList.new({
                    ["type"] = self.model.IS_WATCH,
                    ["updateIntro"] = function(entity)
                        if self.lIntroView then
                            self.lIntroView:render(entity)
                        end
                    end
                })
                self.legion_node:addChild(self.rankView)
                self.rankView:setPosition(-208,-346)
            end)
        end
    elseif _idx == 1 then
        --基本信息
        self.legion_node:setVisible(false)
        self.rank_node:setVisible(true)
        self.audit_node:setVisible(false)

        if self.model:getMListHasRefresh() then
            if tolua.cast(self.postView,"cc.Node") then
                self.postView:getParent():removeChild(self.postView)
            end

            if tolua.cast(self.rIntroView,"cc.Node") then
                self.rIntroView:getParent():removeChild(self.rIntroView)
            end

            service:getMemberList(function()
                self.model:setMListHasRefresh(false)
                self:__createBasicView()
            end, function()
                self:__createBasicView()
            end, function()
                self:__createBasicView()
            end)
        else
            self:__createBasicView()
        end
    else
        --审核列表
        self.legion_node:setVisible(false)
        self.rank_node:setVisible(false)
        self.audit_node:setVisible(true)

        if not tolua.cast(self.aduitView,"cc.Node") then
            service:getApplyList(self.model:getCommanderEntity().legion_id,function()
                self.aduitView = qy.tank.view.legion.basic.AuditList.new()
                self.audit_node:addChild(self.aduitView)
                self.aduitView:setPosition(0,-346)
            end)
        end
    end
end

function HallView:onEnter()
    self:updatePost()
    qy.RedDotCommand:addSignal({
        [qy.RedDotType.LE_T_APPLY] = self.tab.btns[3],
    })
    qy.RedDotCommand:emitSignal(qy.RedDotType.LE_T_APPLY, RedDotModel:getLegionAppluRed())
end

function HallView:onExit()
    qy.RedDotCommand:removeSignal({
        qy.RedDotType.LE_T_APPLY,
    })
end

return HallView
