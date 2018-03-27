--[[
--创建角色
--Author: H.X.Sun
--Date: 2015-06-27
]]

local CreateRole = qy.class("CreateRole", qy.tank.view.BaseView, "view/guide/noviceGuide/CreateRole")

function CreateRole:ctor(delegate)
    CreateRole.super.ctor(self)
	self:InjectView("panel")
	self:InjectView("container")
    self:InjectView("randomNameBtn")
	self.panel:setContentSize(qy.winSize.width, qy.winSize.height)
    local glview = cc.Director:getInstance():getOpenGLView()

	self.roleX = {-393,-131,131,393}
	self.roleY = 418
	self.headIcon = 1
	self.bigScale = 0.98
	self.smallScale = 0.88

	self.model =qy.tank.model.GuideModel

	self:OnClick("confirmBtn", function(sender)
		if self:__canBeNextStep() then
			self:createTipsLogic()
			local _val = self.roleName:getText()
			qy.tank.service.GuideService:createRoleName(_val, "head_" .. self.headIcon, function ()
				qy.tank.manager.ScenesManager:showMainScene()
				qy.GuideManager:next(24)
			end,function ()
				self:removeTips()
			end,function ()
				self:removeTips()
			end)
		end
	end)

	for i = 1, 4 do
		self:InjectView("roleNode_" .. i)
		if i == self.headIcon then
			self["roleNode_" .. i]:setScale(self.bigScale)
		else
			self["roleNode_" .. i]:setScale(self.smallScale)
		end
		self:InjectView("roleBg_" .. i)
		self:InjectView("frame_" .. i)
		self:OnClick("roleBg_" .. i, function(sender)
			if self.headIcon ~= i then
				self:showRoleSelected(i)
			end
		end,{["isScale"] = false})
	end
	self:showRoleSelected(self.headIcon)

	self:OnClick("randomNameBtn", function(sender)
		local _val = self.model:getRandomName(self.headIcon)
		self.roleName:setText(_val)
    end)

	self.roleName = ccui.EditBox:create(cc.size(280, 80), "Resources/common/bg/c_12.bg")
    self.roleName:setPosition(10,163)
   	self.roleName:setFontSize(23)
    self.roleName:setPlaceHolder(qy.TextUtil:substitute(15001))
   	self.roleName:setPlaceholderFontSize(23)
   	self.roleName:setInputMode(6)
    self.roleName:setFont(qy.res.FONT_NAME_2, 22)
    if self.roleName.setReturnType then
        self.roleName:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    end
    self.container:addChild(self.roleName)

    local function editboxEventHandler(eventType)
        if eventType == "began" then
            -- 当编辑框获得焦点并且键盘弹出的时候被调用
            self.randomNameBtn:setTouchEnabled(false)
        elseif eventType == "ended" then
            -- 当编辑框失去焦点并且键盘消失的时候被调用
            self.randomNameBtn:setTouchEnabled(true)
        elseif eventType == "changed" then
            -- 当编辑框的文本被修改的时候被调用
        elseif eventType == "return" then
            -- 当用户点击编辑框的键盘以外的区域，或者键盘的Return按钮被点击时所调用
            self.randomNameBtn:setTouchEnabled(true)
        end
    end
    self.roleName:registerScriptEditBoxHandler(editboxEventHandler)
end

function CreateRole:showRoleSelected(_i)
	self["roleNode_" .. self.headIcon]:stopAllActions()
	if self.headIcon ~= _i then
		self["roleNode_" .. self.headIcon]:setScale(self.smallScale)
		self["frame_" .. self.headIcon]:setSpriteFrame("Resources/guide/xsyd_00014.png")
		self["roleNode_" .. self.headIcon]:setPosition(self.roleX[self.headIcon],self.roleY)
	end
	self.headIcon = _i
	self["roleNode_" .. self.headIcon]:setScale(self.bigScale)
	self["frame_" .. self.headIcon]:setSpriteFrame("Resources/guide/xsyd_0001.png")

 	local moveUp = cc.MoveBy:create(1.5, cc.p(0, 5))
 	local moveDown = cc.MoveBy:create(1.5, cc.p(0, -5))
    local seq = cc.Sequence:create(moveUp,moveDown)
    self["roleNode_" .. self.headIcon]:runAction(cc.RepeatForever:create(seq))
end

function CreateRole:__canBeNextStep()
	local val = self.roleName:getText()
	local space = string.find(val,"%s")
	if space then
		if space == string.len(val) then
			val = string.sub(val, 0, space-1)
			self.roleName:setText(val)
		else
			qy.hint:show(qy.TextUtil:substitute(15002))
			return false
		end
	end

	if val == nil or val == "" then
		qy.hint:show(qy.TextUtil:substitute(15003))
		return false
	elseif qy.tank.utils.String.getLengthWithStr(val) > self.model:getNickNameLength() then
		qy.hint:show(qy.TextUtil:substitute(15004))
		return false
	end

	return true
end

function CreateRole:createTipsLogic()
	self.createTips = qy.tank.view.guide.noviceGuide.CreateRoleTips.new()
	self:addChild(self.createTips, 50)
end

function CreateRole:removeTips()
	self:removeChild(self.createTips)
	self.createTips = nil
end

return CreateRole
