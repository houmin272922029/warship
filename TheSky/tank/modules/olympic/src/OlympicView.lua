--[[
	军奥会主界面
	Author: Aaron Weo
	Date: 2016-9-12 15:22:44
]]

local OlympicView = qy.class("OlympicView", qy.tank.view.BaseView, "olympic.ui.MainView")

function OlympicView:ctor(delegate)
	print("OlympicView:ctor")
    OlympicView.super.ctor(self)

    self:InjectView("scoreLabel")

    self.model = qy.tank.model.OlympicModel
    self.service = qy.tank.service.OlympicService
    self.views = {}
    self.currentView = nil

    self:InjectView("panel")

	self.delegate = delegate
	local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "olympic/res/title.png",
        ["onExit"] = function()
            if delegate and delegate.dismiss then
                delegate.dismiss()
            end
        end
    })
    self:addChild(style)

    self.tab = qy.tank.widget.TabButtonGroup.new("widget/TabButton1",{"军奥活动", "军奥排行","军奥商城"},cc.size(185,70),"h",function(idx)
        self:createContent(idx)
    end, 1)
    self.panel:addChild(self.tab)
    self.tab:setPosition(-390,315)
    self.tab:setLocalZOrder(4)

    self.panel:setSwallowTouches(false)

    self:OnClick("helpBtn",function(sender)
        qy.tank.view.common.HelpDialog.new(30):show(true)
    end, {["isScale"] = true})

    self.model.sourceLabel = self.scoreLabel
    self.scoreLabel:setString(self.model.source.." 积分")
end


function OlympicView:createContent(_idx)
    
    -- 移除当前视图
    if self.currentView then
        self.panel:removeChild(self.currentView)
    end

    -- 显示新视图
    local view = nil
    -- if not self.views[_idx] then
    --     if _idx == 1 then
    --         view = require("olympic.src.ActivityView").new()
    --         view:update()
    --         view:setPosition(-440,-280)
    --         self.panel:addChild(view)
    --         view:retain()
    --         self.views[_idx] = view
    --         self.currentView = view
    --     elseif _idx == 2 then
    --         self.service:rank_list(function()
    --            view = require("olympic.src.RankView").new()
    --            view:render()
    --            view:setPosition(-440,-260)
    --            self.panel:addChild(view)
    --            view:retain()
    --            self.views[_idx] = view
    --            self.currentView = view
    --         end)
    --     elseif _idx == 3 then
    --         self.service:shop(function()
    --             view = require("olympic.src.ShopView").new()
    --             view:setPosition(-440,-260)
    --             self.panel:addChild(view)
    --             view:retain()
    --             self.views[_idx] = view
    --             self.currentView = view
    --         end)
    --     end
    -- else
    --     view = self.views[_idx]
    --     view:update()
    --     self.panel:addChild(view)
    -- end

        if _idx == 1 then
            if not self.views[_idx] then
                view = require("olympic.src.ActivityView").new()
                view:setPosition(-440,-280)
                self.panel:addChild(view)
                view:retain()
                self.views[_idx] = view
            else
                view = self.views[_idx]
                if not view:getParent() then
                    self.panel:addChild(view)
                end
            end
            view:update()
            self.currentView = view
        elseif _idx == 2 then
            self.service:rank_list(function()
                if not self.views[_idx] then
                   view = require("olympic.src.RankView").new()
                   view:setPosition(-440,-260)
                   self.panel:addChild(view)
                   view:retain()
                   self.views[_idx] = view
                else
                    view = self.views[_idx]
                    if not view:getParent() then
                        self.panel:addChild(view)
                    end
                end
                view:render()
                self.currentView = view
            end)
        elseif _idx == 3 then
            self.service:shop(function()
                if not self.views[_idx] then
                    view = require("olympic.src.ShopView").new()
                    view:setPosition(-440,-260)
                    self.panel:addChild(view)
                    view:retain()
                    self.views[_idx] = view
                else
                    view = self.views[_idx]
                    if not view:getParent() then
                        self.panel:addChild(view)
                    end
                end
                view:render()
                self.currentView = view
            end)
        end

    -- 改变状态赋值
    self.currentView = view
    self.idx = idx
    self:update()
end

function OlympicView:update()
    self.scoreLabel:setString(self.model.source.." 积分")
end

function OlympicView:onEnter()
	print("OlympicView:onEnter")
end

function OlympicView:onEnterFinish()
	print("OlympicView:onEnterFinish")
end

function OlympicView:onExit()
	print("OlympicView:onExit")
end

function OlympicView:onExitStart()
	print("OlympicView:onExitStart")
end

function OlympicView:onCleanup()
	print("OlympicView:onCleanup")
    -- for i=1,3 do
    --     local view = self.views[i]
    --     if tolua.cast(view,"cc.Node") then
    --         view:release()
    --     end
    -- end
end

return OlympicView
