--[[
	黑名单cell
	Date: 2016-06-16
--]]
local BlackListItem = qy.class("BlackListItem", qy.tank.view.BaseView, "view/setting/BlackListItem")
local service = qy.tank.service.BlackListService
local model = qy.tank.model.BlackModel

function BlackListItem:ctor(delegate)
	self:InjectView("Name")
	self:InjectView("Level")
	self:InjectView("Button_1")
	self:OnClick("Button_1", function()
		service:getBlackList(
            self.kid, 200,function(reData)
            	qy.hint:show(qy.TextUtil:substitute(90034))
                model:init(reData.list)
                self:update()
        end)
    end,{["isScale"] = false})
end

function BlackListItem:update()
	qy.Event.dispatch(qy.Event.GROUP_PURCHASE)
end

function BlackListItem:render(data)
	
	self.kid = data.kid
	self.Name:setString(data.nickname)
	self.Level:setString("Lv. " .. data.level)
end

return BlackListItem