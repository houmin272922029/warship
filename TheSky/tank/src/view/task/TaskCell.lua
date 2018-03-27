--[[
    任务
    Author: H.X.Sun
    Date: 2015-05-11
]]

local TaskCell = qy.class("TaskCell", qy.tank.view.BaseView, "view/task/TaskCell")

function TaskCell:ctor(delegate)
    TaskCell.super.ctor(self)

	self.delegate = delegate
	self:InjectView("bg")
	self:InjectView("icon")
	self:InjectView("content")
	self:InjectView("toBtn")
	self:InjectView("times")
	self:InjectView("info")
	self:InjectView("name")
	self:InjectView("receiveTips")
	self:InjectView("cornerSprite")
	for i = 1, 2 do
		self:InjectView("icon_" .. i)
		self:InjectView("award_" .. i)
	end

	self:OnClick("toBtn", function(sender)
     	self:toCurrentTask()
    end)
end

--[[--
--刷新
--]]
function TaskCell:render(entity, idx) 
	if entity then
		self.icon:setTexture(entity:getIcon())
		self.name:setString(entity:getTaskName())
		-- self.name:setPosition(-400 + self.name:getStringLength() * 13, 30)
		self.content:setString(entity:getContent())
		self.times:setString(entity.complete_times .. "/" ..entity:getNeedCompleteTimes())
		local award = entity:getAward()
		self.viewId = entity:getViewId()
		for i = 1, 2 do
			if award[i] then
				self["icon_" .. i]:setVisible(true)
				self["icon_" .. i]:setTexture(qy.tank.utils.AwardUtils.getAwardIconByType(award[i].type, award[i].id))
				if award[i].type == -1 then
					self["icon_" .. i]:setScale(0.8)
				else
					self["icon_" .. i]:setScale(0.6)
				end
				self["award_" .. i]:setString("x " .. award[i].num)
			else
				self["icon_" .. i]:setVisible(false)
				self["award_" .. i]:setString("")
			end
		end
		self.status = entity.status
		if entity.status == 0 then
			-- self.bg:setColor(cc.c4b(150,150,150,255))
			self.receiveTips:setVisible(false)
			self.toBtn:setVisible(true)
			self.times:setVisible(true)
			-- self.bg:setTouchEnabled(false)
		else
			-- self.bg:setColor(cc.c4b(255,255,255,255))
			self.receiveTips:setVisible(true)
			self.toBtn:setVisible(false)
			self.times:setVisible(false)
			-- self.bg:setTouchEnabled(true)
		end

		if entity.category_:get() == 3 then
			self.cornerSprite:setVisible(true)
		else
			self.cornerSprite:setVisible(false)
		end
	end
end

function TaskCell:hightLight()
	self.bg:setColor(cc.c4b(100,100,100,255))
	self.info:setOpacity(180)
    self.bg:setScale(0.95)
    self.info:setScale(0.95)
end

function TaskCell:unhightLight()
	self.bg:setColor(cc.c4b(150,150,150,255))
	 
	self.bg:setColor(cc.c4b(255,255,255,255))
	self.info:setOpacity(255)
    self.bg:setScale(1)
    self.info:setScale(1)
end

--[[--
--前往当前任务
--]]
function TaskCell:toCurrentTask()
	print("viewId==" .. self.viewId)
	qy.tank.utils.ModuleUtil.viewRedirectByViewId(self.viewId,function ()
		if self.delegate.closeView then
			self.delegate.closeView()
		end
	end)
	
end

return TaskCell
