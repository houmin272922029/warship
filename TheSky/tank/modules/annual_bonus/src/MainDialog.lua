

local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "annual_bonus/ui/MainDialog")

local service = qy.tank.service.OperatingActivitiesService

function MainDialog:ctor(delegate)
    MainDialog.super.ctor(self)
    self.model = qy.tank.model.OperatingActivitiesModel
	self:InjectView("closebt")
	self:InjectView("time")--时间
	self:InjectView("yilingqu")
	self:InjectView("lingqu")
	self:InjectView("bg")
	self.yilingqu:setVisible(false)
	
    self:OnClick("closebt",function ( sender )
    	self:removeSelf()
    end)
    self:OnClick("lingqu",function ( sender )
 	    service:getCommonGiftAward(1, qy.tank.view.type.ModuleType.ANNUAL_BONUS,false, function(data)
            self.yilingqu:setVisible(true)
    		self.lingqu:setVisible(false)
        end)
    end)
	local data = self.model.annual_bonuslist["1"].award
	for i=1,#data do
	 	local item = qy.tank.view.common.AwardItem.createAwardView(data[i] ,1)
	    self.bg:addChild(item)
	    item:setPosition(190 + 130*i , 230)
	    item.name:setVisible(false)
	end
	if self.model.annual_bonus_status == 1 then
		self.yilingqu:setVisible(false)
    	self.lingqu:setVisible(true)
	else
		self.yilingqu:setVisible(true)
    	self.lingqu:setVisible(false)
	end
	local starttime  = self.model.annual_bonus_starttime
	local endtime  = self.model.annual_bonus_endtime
	self.time:setString(starttime.month.."."..starttime.day.."-"..endtime.month.."."..endtime.day.."期间,每天登录游戏都可直接领取以下奖励!")

end

return MainDialog
