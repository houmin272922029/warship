

local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "happy_nationalday/ui/MainDialog")

local model = qy.tank.model.OperatingActivitiesModel
local service = qy.tank.service.OperatingActivitiesService
function MainDialog:ctor(delegate)
    MainDialog.super.ctor(self)
	self:InjectView("closeBt")
	self:InjectView("titleimg")
	self:InjectView("awardbg")
	self:InjectView("yigoumai")
	self:InjectView("BuyBt")
	self:InjectView("getBt")
    self:OnClick("BuyBt",function ( sender )
		local id = model.happy_nationallist["1"].price
		local data = qy.tank.model.RechargeModel.data[id]
		qy.tank.service.RechargeService:paymentBegin(data, function(flag, msg)
            if flag == 3 then
                self.toast = qy.tank.widget.Toast.new()
                self.toast:make(self.toast, qy.TextUtil:substitute(58001))
                self.toast:addTo(qy.App.runningScene, 1000)
            elseif flag == true then
                self.toast:removeSelf()
                model.nationaldaystatus = 1
                self:update()--充值成功走刷新逻辑
                qy.hint:show(qy.TextUtil:substitute(58002))
            else
                self.toast:removeSelf()
                qy.hint:show(msg)
            end
        end) 
    end)
    self:OnClick("closeBt", function(sender)
        self:removeSelf()
    end)
    self:OnClick("getBt", function(sender)
        service:getCommonGiftAward(1,"happy_festival",false, function(reData)
            model.nationaldaystatus = 2
            self:update()
        end)
    end)
    for i=1,#model.happy_nationallist["1"].award do
    	local award = model.happy_nationallist["1"].award[i]
    	local item = qy.tank.view.common.AwardItem.createAwardView(award, 1)
        item:setPosition( 115 *i -50,65)
        item:showTitle(false)
        item:setScale(0.9)
		item.fatherSprite:setSwallowTouches(false)
        self.awardbg:addChild(item,99,99)
    end
     
    self:update()
end
function MainDialog:update(  )
	self.BuyBt:setVisible(model.nationaldaystatus == 0)
	self.yigoumai:setVisible(model.nationaldaystatus == 2)
	self.getBt:setVisible(model.nationaldaystatus == 1)
end


return MainDialog
