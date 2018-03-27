--[[--
	alloy
	Author: H.X.Sun
--]]--

local AlloyCell = qy.class("AlloyCell", qy.tank.view.BaseView, "alloy/ui/AlloyCell")

function AlloyCell:ctor(params)
	self:InjectView("icon")
	self:InjectView("name")
	self:InjectView("level")
	self:InjectView("desc")
	self:InjectView("btn")
	self:InjectView("select_btn")
	self:InjectView("txt")
	self:InjectView("tick")
	self.tick:setVisible(false)
	self.model = qy.tank.model.AlloyModel
	self.params = params
	local service =require("alloy.src.AlloyService")

	if params.type == self.model.OPNE_LISTT_3 then
		--升级
		self.btn:setVisible(false)
		self.select_btn:setVisible(true)
		self:OnClick("select_btn",function()
			params.selectIdx()
    	end,{["isScale"] = false})
	else
		self.btn:setVisible(true)
		self.select_btn:setVisible(false)
		if params.type == self.model.OPNE_LISTT_1 then
			--嵌入
			self.txt:setSpriteFrame("alloy/res/qianru.png")
		else
			--更换
			self.txt:setSpriteFrame("alloy/res/genghuan.png")
		end
		self:OnClick("btn",function()
    		service:embed({
    			["equipEntity"] = self.data.equipEntity,
    			["alloyEntity"] = self.entity,
    		},function ()
    			qy.tank.utils.HintUtil.showSomeImageToast(self.model:getAddAttribute(self.entity.alloy_id),cc.p(qy.winSize.width / 2, qy.winSize.height * 0.7))
    			params.dismiss()
    		end)
    	end)
	end
end

function AlloyCell:updateTick(callBack)
	if self.model:isUpSelect(self.index) then
		-- print("取消打钩=============>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
		self.tick:setVisible(false)
		self.model:setUpUnselectStatus(self.index)  
		callBack()  		
	elseif #self.model:getUpSelectStatus() < 5 then
		-- print("打钩=============>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
		self.tick:setVisible(true)
		self.model:setUpSelectStatus(self.index)  
		callBack()  		
	else
		qy.hint:show(qy.TextUtil:substitute(41006))  		
	end
end

function AlloyCell:render(_index, data)
	local _alloyId = data.alloyId
	self.entity = self.model:getUnSelectEntityByIndex(_alloyId,_index)
	self.index = _index
	self.data = data
	if self.entity then
		self.icon:setTexture(self.entity:getIcon())
		self.name:setString(self.entity:getName())
		self.name:setTextColor(self.entity:getColor())
		self.level:setTextColor(self.entity:getColor())
		self.level:setString("Lv."..self.entity.level)
		self.level:setVisible(qy.language == "cn")
		if self.params.type == self.model.OPNE_LISTT_3 then
			self.desc:setString("EXP:"..self.entity:getTotoalExp())
			if self.model:isUpSelect(self.index) then
				-- print("初始==================选中")
				self.tick:setVisible(true)
			else
				-- print("初始==================不选中")
				self.tick:setVisible(false)
			end
		else
			self.desc:setString(self.entity:getAttributeDesc())
		end
	end
end

return AlloyCell