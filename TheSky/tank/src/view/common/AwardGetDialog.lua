--[[
    道具获得
]]
local AwardGetDialog = qy.class("AwardGetDialog", qy.tank.view.BaseDialog, "view/common/AwardGetDialog")

function AwardGetDialog:ctor(delegate)
    AwardGetDialog.super.ctor(self)
	self.award = delegate.award
    self.isPub = delegate.isPub
	self:OnClick("closeBtn", function()
        self:dismiss()
        if delegate.callback~=nil then
            delegate.callback()
        end
        qy.GuideManager:next(992)
    end,{["audioType"] = qy.SoundType.BTN_CLOSE})
	self:InjectView("container")
	self:InjectView("bg")
	self:InjectView("bg2")
	self:InjectView("top")
	self:InjectView("closeBtn")
    self:InjectView("scrollView")
    self.scrollView:setVisible(false)
    self.top:setLocalZOrder(20)
	self.bg:setContentSize(qy.winSize.width, qy.winSize.height)
	self:__createAwardView()
end

function AwardGetDialog:__createAwardView()
    self.awardList = qy.AwardList.new({
        ["award"] = self.award,
        ["isPub"] = self.isPub
    })
    if #self.award < 4 then
		--一行奖励
        self.awardList:setPosition(-238,200)
		self.container:addChild(self.awardList)
	else
         -- 动态容器
        if not tolua.cast(self.dynamic_c,"cc.Node") then
            self.dynamic_c = cc.Layer:create()
            self.dynamic_c:setAnchorPoint(0,1)
        end
        local h = self.awardList:getHeight()
        self.scrollView:setVisible(true)

        self.dynamic_c:addChild(self.awardList)
        self.dynamic_c:setContentSize(800,h)
        self.dynamic_c:setPosition(160,h + 100)
        self.scrollView:addChild(self.dynamic_c)
        self.scrollView:setInnerContainerSize(cc.size(800,h))
	end
end

function AwardGetDialog:onEnter()
	--新手引导：注册控件
	qy.GuideCommand:addUiRegister({
        {["ui"] = self.closeBtn, ["step"] = {"SG_123"}},
    })
end

function AwardGetDialog:onExit()
	--新手引导：移除控件注册
    qy.GuideCommand:removeUiRegister({"SG_123"})
end

return AwardGetDialog
