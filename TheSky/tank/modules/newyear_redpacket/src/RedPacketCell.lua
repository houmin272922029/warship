

local RedPacketCell = qy.class("SystemCell", qy.tank.view.BaseView, "newyear_redpacket/ui/RedPacketCell")

local model = qy.tank.model.RedPacketModel
local service = qy.tank.service.RedPacketService

function RedPacketCell:ctor(delegate)
    RedPacketCell.super.ctor(self)
	for i=1,4 do
        self:InjectView("bg"..i)
        self:InjectView("Text"..i)
        self:InjectView("guoqi"..i)
        self:InjectView("name"..i)
        self:InjectView("miaoshu"..i)
        self:InjectView("Image"..i)
        self:InjectView("kai"..i)
    end
    self.data = delegate.data
    self.type = delegate.type--2 系统 3 世界 4 军团
    -- local aa = (self.index-1)*4 +2
    self.totalnum = delegate.num
    self.delegate = delegate
    
    self:OnClickForBuilding1("bg1",function ( sender )
    	local aa = (self.index-1)*4 +1
    	print("==================",aa)
    	local seq = cc.Sequence:create(delay , cc.CallFunc:create(function()
	        if self.touchType == true  then
	        	local delay = cc.DelayTime:create(0.3)
	        	self:ClickRedPacket(aa)
	    	else
	     		self.touchType = false
	    	end
    	end))
        self:runAction(seq)
    end)
    self:OnClickForBuilding1("bg2",function ( sender )
    	local aa = (self.index-1)*4 +2
    	print("==================",aa)
    	local seq = cc.Sequence:create(delay , cc.CallFunc:create(function()
	        if self.touchType == true  then
	        	local delay = cc.DelayTime:create(0.3)
	        	self:ClickRedPacket(aa)
	    	else
	     		self.touchType = false
	    	end
    	end))
        self:runAction(seq)
    end)
    self:OnClickForBuilding1("bg3",function ( sender )
    	local aa = (self.index-1)*4 +3
    	print("==================",aa)
    	local seq = cc.Sequence:create(delay , cc.CallFunc:create(function()
    		local delay = cc.DelayTime:create(0.3)
	        if self.touchType == true  then
	        	self:ClickRedPacket(aa)
	    	else
	     		self.touchType = false
	    	end
    	end))
        self:runAction(seq)
    end)
    self:OnClickForBuilding1("bg4",function ( sender )
    	local aa = (self.index-1)*4 + 4
    	print("==================",aa)
    	local seq = cc.Sequence:create(delay , cc.CallFunc:create(function()
	        if self.touchType == true  then
	        	local delay = cc.DelayTime:create(0.3)
	        	self:ClickRedPacket(aa)
	    	else
	     		self.touchType = false
	    	end
    	end))
        self:runAction(seq)
    end)

 

end
function RedPacketCell:ClickRedPacket( id )
	local data = {}
	local range = 0
	if self.type == 2 then
		data = model.red_pack_list_system
		range = 0
	elseif self.type == 3 then
		data = model.red_pack_list_world
		range = 1
	else
		data = model.red_pack_list_legion
		range = 2
	end
	if data[id].type == 3 then
		if data[id].status == 0 then
			local dialog = require("newyear_redpacket.src.LuckyPacketDIalog1").new({
	 			["data"]= data[id],
	 			["type"] = self.type,
	 			["range"] = range,
	 			["id"] = id,
				["callback"] = function ( )
					self.delegate:callback()
			end
	 		})
 			dialog:show(true)
		else
			--查看详情界面
			-- print("幸运红包打开接口")
			service:openluckyredpacket(range,data[id].type,data[id].id,0,function ( datas )
				-- print("ssssssssssssss",json.encode(datas))
				local dialog = require("newyear_redpacket.src.LuckyPacketDIalog2").new({
	 			["data"]= datas,
	 			["type"] = self.type
	 			})
 				dialog:show(true)
			end)
		end
	 
	else
		--请求服务器操作
		print("其他红包打开接口")
		service:openredpacket(range,data[id].type,data[id].id,function ( datas )
			print("ssssssssssssss",json.encode(datas))
			if self.type == 2 then
				model.red_pack_list_system[id].status = datas.status
			elseif self.type == 3 then
				model.red_pack_list_world[id].status = datas.status
			else
				model.red_pack_list_legion[id].status = datas.status
			end
			self.delegate:callback()
			local dialog = require("newyear_redpacket.src.SystemPacketDialog").new({
	 			["data"]= datas,
	 			["type"] = self.type,
	 			["redtype"]= data[id].type,
	 			["content"] = data[id].content
	 		})
 			dialog:show(true)
		end)
	end
end
function RedPacketCell:render(_idx,num)
    self.index = _idx
	local x = (_idx-1)*4
	local tempnum = 0
	if _idx == self.totalnum then
		if num == 0  then
			for i=1,4 do
				self["bg"..i]:setVisible(true)
			end
			tempnum =  4
		elseif num == 1 then
			self.bg1:setVisible(true)
			for i=2,4 do
				self["bg"..i]:setVisible(false)
			end
			tempnum = 1
		elseif num == 2 then
			tempnum = 2
			self.bg1:setVisible(true)
			self.bg2:setVisible(true)
			self.bg3:setVisible(false)
			self.bg4:setVisible(false)
		else
			for i=1,3 do
				self["bg"..i]:setVisible(true)
			end
			tempnum = 3
			self.bg4:setVisible(false)
		end
		
	else
		for i=1,4 do
			self["bg"..i]:setVisible(true)
		end
		tempnum = 4
	end
	for i=1,tempnum do
		self["miaoshu"..i]:setString(self.data[x+i].content)
		if self.type == 2 then
			if self.data[x+i].status == 0  then
				self["name"..i]:setString("开")
				self["kai"..i]:setVisible(true)
				self["Image"..i]:setVisible(false)
				self["Text"..i]:setVisible(false)
			else
				self["name"..i]:setString("系 统")
				self["Text"..i]:setVisible(true)
				self["kai"..i]:setVisible(false)
				self["Image"..i]:setVisible(true)
			end
		else
			if self.data[x+i].status == 0  then
				self["name"..i]:setString("开")
				self["Text"..i]:setVisible(false)
				self["kai"..i]:setVisible(true)
				self["Image"..i]:setVisible(false)
			else
				self["name"..i]:setString(self.data[x+i].name)
				self["Text"..i]:setVisible(true)
				self["kai"..i]:setVisible(false)
				self["Image"..i]:setVisible(true)
			end
		end
		if self.data[x+i].status == 2 or self.data[x+i].status == 3 then
			self["guoqi"..i]:setVisible(true)
		else
			self["guoqi"..i]:setVisible(false)
		end
		local red_pack_type  = model:GetRedPacketcolor( self.data[x+i].total)
		if red_pack_type == 1 then
			self["bg"..i]:loadTexture("newyear_redpacket/res/zibao.png",1)
		elseif red_pack_type == 2 then
			self["bg"..i]:loadTexture("newyear_redpacket/res/huangbaoa.png",1)
		else
			self["bg"..i]:loadTexture("newyear_redpacket/res/hongbao.png",1)
		end
	end
end
function RedPacketCell:onEnter()
     self.listener = cc.EventListenerTouchOneByOne:create()
    local function onTouchBegan(touch, event)
        self.touchPoint1 = touch:getLocation()
        self.touchType = true
        return true
    end

    local function onTouchMoved(touch, event)
        return true
    end
    local function onTouchCancel(touch, event)
        self.touchType = false
        return false
    end

    local function onTouchEnded(touch, event)
        self.touchPoint2 = touch:getLocation()
        if math.abs(self.touchPoint1.y - self.touchPoint2.y) <=5 then
            self.touchType = true
        else
            self.touchType = false
        end
        return true

    end

    self.listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
    self.listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED)
    self.listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED)
    self.eventDispatcher = self:getEventDispatcher()
    self.eventDispatcher:addEventListenerWithSceneGraphPriority(self.listener,self.bg1)
end

function RedPacketCell:onExit()
  	self:getEventDispatcher():removeEventListener(self.listener)

end


return RedPacketCell
