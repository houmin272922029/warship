

local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "recruit_supply/ui/MainDialog")

local model = qy.tank.model.OperatingActivitiesModel
local service = qy.tank.service.OperatingActivitiesService
function MainDialog:ctor(delegate)
    MainDialog.super.ctor(self)
	self:InjectView("closeBt")
	self:InjectView("time")--时间
	self:InjectView("titleimg")
	self:InjectView("awardbg")
	self:InjectView("moneyimg")
	self:InjectView("yilingqu")
	self:InjectView("Btimg")
	self.yilingqu:setVisible(false)
	self:InjectView("BuyBt")
	for i=1,4 do
        self:InjectView("shuoming"..i)
    end
    for i=1,3 do
        self:InjectView("Bt"..i)
        self:InjectView("dian"..i)
        self["dian"..i]:setVisible(false)
    end
    self:OnClick("Bt1",function ( sender )
    	self:choosedayBt(1)
    end)
     self:OnClick("Bt2",function ( sender )
    	self:choosedayBt(2)
    end)
    self:OnClick("Bt3",function ( sender )
    	self:choosedayBt(3)
    end)
    self:OnClick("BuyBt",function ( sender )
    	if self.flag == 0 then
    		local id = self.data[self.chooseday].amount
    		print(id)
    		local data = qy.tank.model.RechargeModel.data[id]
    		print(data)
    		qy.tank.service.RechargeService:paymentBegin(data, function(flag, msg)
                if flag == 3 then
                    self.toast = qy.tank.widget.Toast.new()
                    self.toast:make(self.toast, qy.TextUtil:substitute(58001))
                    self.toast:addTo(qy.App.runningScene, 1000)
                elseif flag == true then
                    self.toast:removeSelf()
                    -- table.insert(model.newYearSupplyRecharge, self.key)
                    model.recruitsupplylist[self.chooseday].status = 1
                    self:updateBt(self.chooseday)--充值成功走刷新逻辑
                    self:updatehongdian()
                    qy.hint:show(qy.TextUtil:substitute(58002))
                else
                    self.toast:removeSelf()
                    qy.hint:show(msg)
                end
            end) 
		else
			service:getCommonGiftAward(self.chooseday, "recruit_supply",false, function(reData)
                model.recruitsupplylist[self.chooseday].status = -1
                self:updateBt(self.chooseday)
                self:updatehongdian()
            end)
		end
    end)
    self:OnClick("closeBt", function(sender)
        self:removeSelf()
    end)
    self.data = model.recruitsupplycfg
	self.chooseday = model:getRecruitday()
	self.flag = 0
	self:update(self.chooseday)
	self:updatehongdian()
	self:updateDayBt(self.chooseday)


end
function MainDialog:updatehongdian(  )
	local data = model.recruitsupplylist
	for i=1,3 do
		if data[i].status == 1 then
			self["dian"..i]:setVisible(true)
		else
			self["dian"..i]:setVisible(false)
		end
	end
end
function MainDialog:update( flag )
	local datas = self.data[flag]
	-- print("============",json.encode(datas))
	if flag == 1 then
		self.titleimg:loadTexture("recruit_supply/res/12.png",1)
		self.moneyimg:setSpriteFrame("recruit_supply/res/6.png")
	elseif flag == 2 then
		self.titleimg:loadTexture("recruit_supply/res/13.png",1)
		self.moneyimg:setSpriteFrame("recruit_supply/res/7.png")
	else
		self.titleimg:loadTexture("recruit_supply/res/14.png",1)
		self.moneyimg:setSpriteFrame("recruit_supply/res/8.png")
	end
	for i=1,4 do
		self["shuoming"..i]:setString(datas["desc_"..i])
	end
	self.awardbg:removeAllChildren()
	local data = datas.award
	for i=1,#data do
	 	local item = qy.tank.view.common.AwardItem.createAwardView(data[i] ,1)
	    self.awardbg:addChild(item)
	    item:setPosition( 120*i -40, 60)
	    item.name:setVisible(false)
	end
	self:updateBt(flag)

end
function MainDialog:updateBt( flag )
	local data = model.recruitsupplylist[flag]
	if data.status == 0 then
		self.yilingqu:setVisible(false)
		self.BuyBt:setVisible(true)
		self.Btimg:setSpriteFrame("Resources/common/txt/goumai2.png")
		self.flag = 0
	elseif data.status == 1 then
		self.yilingqu:setVisible(false)
		self.BuyBt:setVisible(true)
		self.Btimg:setSpriteFrame("Resources/common/txt/lingqu2.png")
		self.flag = 1
	else
		self.yilingqu:setVisible(true)
		self.BuyBt:setVisible(false)
	end
end
function MainDialog:choosedayBt( day )
	if self.chooseday ~= day then
		self.chooseday = day
		self:updateDayBt(day)
		self:update(day)
	end
end
function MainDialog:updateDayBt(day)
	for i=1,3 do
		if i == day then
			self["Bt"..i]:loadTexture("recruit_supply/res/a1.png",1)
		else
			self["Bt"..i]:loadTexture("recruit_supply/res/a.png",1)
		end
	end
end

function MainDialog:onEnter()
	if model.recruitsupplyendtime - qy.tank.model.UserInfoModel.serverTime <= 0 then
         self.time:setString("活动已结束")
    else
    	self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(model.recruitsupplyendtime - qy.tank.model.UserInfoModel.serverTime, 7))
    	self.listener_1 = qy.Event.add(qy.Event.BONUS_TIME,function(event)
        self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(model.recruitsupplyendtime - qy.tank.model.UserInfoModel.serverTime, 7))
        if model.recruitsupplyendtime - qy.tank.model.UserInfoModel.serverTime <= 0 then
         	self.time:setString("活动已结束")
     	end
    end)
    end
 
    
end

function MainDialog:onExit()
    qy.Event.remove(self.listener_1)
  
end


return MainDialog
