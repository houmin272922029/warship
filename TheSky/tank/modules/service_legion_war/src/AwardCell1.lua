--[[
	跨服军团战
	Author: 
]]

local AwardCell1 = qy.class("AwardCell1", qy.tank.view.BaseView, "service_legion_war/ui/AwardCell1")

local userModel = qy.tank.model.UserInfoModel
local service = qy.tank.service.ServiceLegionWarService
local model = qy.tank.model.ServiceLegionWarModel

function AwardCell1:ctor(delegate)
    AwardCell1.super.ctor(self)
    self:InjectView("score")
    self:InjectView("Btimg")
    self:InjectView("textimg")
    self:InjectView("awardlist")
    self:OnClick("Btimg",function()
        if self.btflag == 1 then
        	qy.hint:show("已领取")
    	elseif self.btflag == 2 then
    		service:drawAward2(self.type,self.index,function (  )
                delegate:callback()
            end)
		else
			qy.hint:show("未达成")
		end
    end,{["isScale"] = false})
    self.type = delegate.type
    self.data = delegate.data
    self.servicedata = {}
    self.record = 0
    if self.type == 3 then
        self.servicedata = model.personal_achieve_award
        self.record = model.personal_record
    else
        self.servicedata = model.legion_achieve_award_arry
        self.record = model.legion_record
    end
end

function AwardCell1:render(_idx)
	self.index = _idx
   	self.awardlist:removeAllChildren()
	local award = self.data[tostring(_idx)].award
	for i=1,#award do
        local item = qy.tank.view.common.AwardItem.createAwardView(award[i] ,1)
        self.awardlist:addChild(item)
        item:setPosition(165 + 120*(i - 1), 57)
        item:setScale(0.7)
        item.name:setVisible(false)
    end
    self.score:setString(self.data[tostring(_idx)].record)
    if self.record < self.data[tostring(_idx)].record then
        self.btflag = 3
        self.Btimg:loadTexture("Resources/common/button/anniuhui.png",1)
        self.textimg:loadTexture("Resources/common/txt/weidacheng.png",1)
    else
        local ff = model:getawardtype(self.type,_idx)--判断是否领取过了
        if ff then
            self.Btimg:loadTexture("Resources/common/button/btn_4.png",1)
            self.textimg:loadTexture("service_legion_war/res/yilingqu.png",1)
            self.btflag = 1
        else
            self.Btimg:loadTexture("Resources/common/button/btn_3.png",1)
            self.textimg:loadTexture("Resources/common/txt/lingqu1.png",1)
            self.btflag =2
        end
    end
end

function AwardCell1:onEnter()
  
end

function AwardCell1:onExit()
    
end

return AwardCell1
