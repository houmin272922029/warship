--[[
	加入 & 创建 军团
	Author: H.X.Sun
]]

local JoinView = qy.class("JoinView", qy.tank.view.BaseView, "legion/ui/basic/JoinView")

function JoinView:ctor(delegate)
    JoinView.super.ctor(self)
    local head = qy.tank.view.legion.HeadCell.new({
        ["onExit"] = function()
            delegate.dismiss(false)
        end,
        ["showLine"] = true,
        ["titleUrl"] = "legion/res/juntuan.png",
    })
    self:addChild(head,10)
    self:InjectView("create_node")
    self:InjectView("join_node")
    self:InjectView("cin_bg")
    self:InjectView("jin_bg")
    self.model = qy.tank.model.LegionModel
    local service = qy.tank.service.LegionService

    self.tab = qy.tank.widget.TabButtonGroup.new("widget/TabButton1",{qy.TextUtil:substitute(50047), qy.TextUtil:substitute(50048)},cc.size(190,67),"h",function(idx)
        self:createContent(idx)
    end, 1)
    self:addChild(self.tab)
    self.tab:setPosition(110,qy.winSize.height-140)
    self.tab:setLocalZOrder(4)

    self:OnClick("create_btn", function(sender)
        if self:__createNameSuccess() then
            service:createLegion(self.createName:getText(),function()
                qy.hint:show(qy.TextUtil:substitute(50049))
                delegate.dismiss(true)
            end)
        end
    end)
    self:OnClick("search_btn", function(sender)
        local _val = self.search:getText()
        if _val == "" then
            qy.hint:show(qy.TextUtil:substitute(50050))
            return
        end
        service:getLegionList({["legion_name"] = _val},function()
            -- self.rankView:setSearchStatus(true)
            self.rankView:update()
        end)
    end)
end

function JoinView:createContent(_idx)
    if _idx == 1 then
        self.join_node:setVisible(true)
        self.create_node:setVisible(false)
        if tolua.cast(self.createName,"cc.Node") then
            self.createName:getParent():removeChild(self.createName)
        end

        if not tolua.cast(self.introView,"cc.Node") then
            self.introView = qy.tank.view.legion.basic.IntroduceCell.new()
            self.join_node:addChild(self.introView)
            self.introView:setPosition(-536,-346)
        end

        if not tolua.cast(self.rankView,"cc.Node") then
            self.rankView = qy.tank.view.legion.basic.LegionRankList.new({
                ["type"] = self.model.IS_OPERATE,
                ["updateIntro"] = function(entity)
                    if self.introView then
                        self.introView:render(entity)
                    end
                end
            })
            self.join_node:addChild(self.rankView)
            self.rankView:setPosition(-208,-346)
		end

        if not tolua.cast(self.search,"cc.Node") then
            self.search = ccui.EditBox:create(cc.size(350, 80), "Resources/common/bg/c_12.bg")
            self.search:setPosition(190,25)
           	self.search:setFontSize(24)
            self.search:setPlaceHolder(qy.TextUtil:substitute(50051))
           	self.search:setPlaceholderFontSize(24)
           	self.search:setInputMode(6)
            if self.search.setReturnType then
                self.search:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
            end
            self.jin_bg:addChild(self.search)
        end
    else
        self.join_node:setVisible(false)
        self.create_node:setVisible(true)

        if tolua.cast(self.search,"cc.Node") then
            self.search:getParent():removeChild(self.search)
        end

        if not tolua.cast(self.createName,"cc.Node") then
            self.createName = ccui.EditBox:create(cc.size(400, 80), "Resources/common/bg/c_12.bg")
            self.createName:setPosition(215,25)
           	self.createName:setFontSize(24)
            self.createName:setPlaceHolder(qy.TextUtil:substitute(50052))
           	self.createName:setPlaceholderFontSize(24)
           	self.createName:setInputMode(6)
            if self.createName.setReturnType then
                self.createName:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
            end
            self.cin_bg:addChild(self.createName)
        end
    end

end

function JoinView:__createNameSuccess()
	local val = self.createName:getText()
    if string.find(val, " ") then
        qy.hint:show(qy.TextUtil:substitute(50053))
        return false
    end
	local space = string.find(val,"%s")
	if space then
		if space == string.len(val) then
			val = string.sub(val, 0, space-1)
			self.roleName:setText(val)
		else
			qy.hint:show(qy.TextUtil:substitute(50053))
			return false
		end
	end

	if val == nil or val == "" then
		qy.hint:show(qy.TextUtil:substitute(50054))
		return false
	end

	return true
end


return JoinView
