--
-- Author: mingming
-- Date: 2015-08-14
--
local MessageModel = qy.class("MessageModel", qy.tank.model.BaseModel)

MessageModel.messageType = {
	["1"] = "remind_zbhd",
	["2"] = "remind_arena",
	["3"] = "remind_rare",
	["4"] = "remind_escort",
	["5"] = "remind_interservice",
}

function MessageModel:init()
	self.idx = 0
	self.List = {}
end

function MessageModel:getMessageList()
	return self.messageList
end

function MessageModel:setMessageList(list)
	table.sort(list, function(a, b) 
		return a.uptime > b.uptime
	end)
	self.List = list
end

function MessageModel:getNextMessage()
	self.idx = self.idx + 1
	self.idx = self.idx > #self.List and #self.List or self.idx
	return self.List[self.idx]
end

function MessageModel:testNextMessage()
	return self.idx + 1 <= #self.List
end

MessageModel:init()

return MessageModel