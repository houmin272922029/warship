--[[
    loading
    Author: H.X.Sun
    Date: 2015-08-26
--]]
local Loading = qy.class("Loading", qy.tank.view.BaseDialog, "view/common/Loading")

function Loading:ctor(delegate)
	Loading.super.ctor(self)
	self.isPopup = false
	--审核屏蔽
	if qy.isAudit and qy.product == "sina" then
		self:InjectView("loading_img_1")
		self.loading_img_1:setTexture("Resources/common/bg/appstore_load.jpg")
	end
end


function Loading:onEnter()
	self.loadListener = qy.Event.add(qy.Event.SCENE_LOAD_HIDE,function(event)
		self:dismiss()
    end)
end

function Loading:onExit()
	qy.Event.remove(self.loadListener)
	self.loadListener = nil
end

return Loading
