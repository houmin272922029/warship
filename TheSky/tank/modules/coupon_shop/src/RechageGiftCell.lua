--[[--
    
--]]--

local RechageGiftCell = qy.class("LoginGiftCell", qy.tank.view.BaseView, "fire_rebate/ui/RechageGiftCell")

function RechageGiftCell:ctor(delegate)
    RechageGiftCell.super.ctor(self)
    self.model = qy.tank.model.FireRebateModel
    self.service = qy.tank.service.FireRebateService
    self:InjectView("toReceiveBtn")
    self:InjectView("hasReceive")
    self:InjectView("bg")
    self:InjectView("Lingqu")
    self:InjectView("Rechage")
    self:InjectView("Num")

    local activity = qy.tank.view.type.ModuleType

    self:OnClick("toReceiveBtn",function(sender)
        if self.mState == 1 then -- 领东西
            self.service:GetgetawardData(3,self.mIndex,function ( data )
                self.model:SetActivityAddState(self.mIndex)
                self:render(self.mIndex,self.mItemData)
                qy.tank.command.AwardCommand:add(data.award)
                qy.tank.command.AwardCommand:show(data.award,{["critMultiple"] = data.weight})
            end)
        else
            delegate.CloseParentFun()
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.RECHARGE)
        end
    end)

end

function RechageGiftCell:render(idx,data)

    self.Num:setString("累计充值"..data.cash.."元")
    
    if self.awardList then
        self.bg:removeChild(self.awardList)
    end


    self.awardList = qy.AwardList.new({
        ["award"] = data.award,
        ["itemSize"] = 3,
        ["len"] = 4, 
        ["type"] = 1,
        ["cellSize"] = cc.size(120,100)
    })
    self.awardList:setPosition(60,170)
    self.bg:addChild(self.awardList)

    local State = self.model:GetActivityAddState(idx)
    if State == 1 then      -- 可以领取
        self.hasReceive:setVisible(false)
        self.Lingqu:loadTexture("Resources/common/txt/lingqu.png",1)
        self.toReceiveBtn:setVisible(true)
        self.toReceiveBtn:setTouchEnabled(true)
        self.toReceiveBtn:setBright(true)
        self.Lingqu:setContentSize(56, 21)

    elseif State == 0 then  -- 去充值
        self.Lingqu:loadTexture("fire_rebate/res/quchongzhi.png",1)
        self.toReceiveBtn:setVisible(true)
        self.hasReceive:setVisible(false)
        self.Lingqu:setContentSize(60, 24)
        if self.model:GetSurplusTiemsState() then
            self.toReceiveBtn:setTouchEnabled(false)
            self.toReceiveBtn:setBright(false)
        end
    else                    -- 已经领取
        self.hasReceive:setVisible(true)
        self.toReceiveBtn:setVisible(false)
    end
    self.mState = State
    self.mIndex = idx
    self.mItemData = data

end

return RechageGiftCell