


local ScreenDialog = qy.class("ScreenDialog", qy.tank.view.BaseDialog, "accessories/ui/ScreenDialog")

local model = qy.tank.model.FittingsModel
local service = qy.tank.service.FittingsService
local qulitylist = {}
local typelist = {}
function ScreenDialog:ctor(delegate)
    ScreenDialog.super.ctor(self)

    self:InjectView("cancelBt")
    self:InjectView("okBt")
    for i=1,2 do
        self:InjectView("allbt"..i)
        self:InjectView("allbtbg"..i)
        self["allbtbg"..i]:setVisible(false)
    end
    for i=1,13 do
        self:InjectView("bt"..i)
        self:InjectView("btbg"..i)
        self["btbg"..i]:setVisible(false)
    end

    self:OnClick("cancelBt",function()
        self:removeSelf()
    end)
    self:OnClick("okBt",function()
    	if self.choose1 == 0 and self.choose2 == 0 and #typelist== 0 and #qulitylist== 0 then
    		qulitylist = {}
			typelist = {}
    		self:removeSelf()
    		return
    	end
    	if self.choose1 == 0 and  #typelist== 0 then
    		qy.hint:show("请勾选种类")
    		return
    	end
    	if self.choose2 == 0 and  #qulitylist== 0 then
    		qy.hint:show("请勾选品质")
    		return
    	end
    	if self.choose1 == 1 then
    		if self.choose2 == 1 then
    			delegate.callback(1,1)
			else
				delegate.callback(1,qulitylist)
			end
    	else
    		if self.choose2 == 1 then
    			delegate.callback(typelist,1)
			else
				delegate.callback(typelist,qulitylist)
			end
    	end
    	qulitylist = {}
		typelist = {}
        self:removeSelf()
    end)
     self:OnClick("allbt1",function()
        if self.choose1 == 0 then
            self.choose1 = 1
        else
            self.choose1 = 0
        end
        self.allbtbg1:setVisible(self.choose1 == 1)
    end,{["isScale"] = false})
    self:OnClick("allbt2",function()
        if self.choose2 == 0 then
            self.choose2 = 1
        else
            self.choose2 = 0
        end
        self.allbtbg2:setVisible(self.choose2 == 1)
    end,{["isScale"] = false})
	for i=1,13 do
	  	self:OnClick("bt"..i,function()
	  		if i <= 8 then
	  			self:touch( i )
  			else
  				self:touch1( i-7)
  			end
        	
    	end,{["isScale"] = false})
	end
	self.choose1 = 0
	self.choose2 = 0
    
      

end
function ScreenDialog:touch( id )
	local num = 0
	for i=1,#typelist do
		if typelist[i] == id then
			num = 1
			table.remove(typelist, i)
			break
		end
	end
	if num == 0 then
		table.insert(typelist,id)
	end
	local nums = 0
	for i=1,#typelist do
		if typelist[i] == id then
			nums = 1
			break
		end
	end
	self["btbg"..id]:setVisible(nums == 1)
end
function ScreenDialog:touch1(id )
		local num = 0
	for i=1,#qulitylist do
		if qulitylist[i] == id then
			num = 1
			table.remove(qulitylist, i)
			break
		end
	end
	if num == 0 then
		table.insert(qulitylist,id)
	end
	local nums = 0
	for i=1,#qulitylist do
		if qulitylist[i] == id then
			nums = 1
			break
		end
	end
	local aaa = id + 7
	self["btbg"..aaa]:setVisible(nums == 1)
end


return ScreenDialog
