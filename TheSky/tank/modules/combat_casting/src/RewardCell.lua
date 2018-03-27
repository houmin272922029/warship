--[[--

--]]--

local RewardCell = qy.class("RewardCell", qy.tank.view.BaseView, "combat_casting/ui/RewardCell")

local _moduleType = qy.tank.view.type.ModuleType.PAY_REBATE_VIP

function RewardCell:ctor(delegate)
    RewardCell.super.ctor(self)
    self.model = qy.tank.model.CombatCastingModel
    self.service = qy.tank.service.CombatCastingService

    self:InjectView("pay_num_txt")
    self:InjectView("hasReceive")
    self:InjectView("bg")
    self:InjectView("Txt")
    self:InjectView("Btn_get")

    self:OnClick("Btn_get", function(sender)
        if self.Btn_get:isBright() then
            self.service:getAward3(function(data)
                delegate:update()
                if data.award then
                    qy.tank.command.AwardCommand:add(data.award)
                    qy.tank.command.AwardCommand:show(data.award)         

                end
            end, self.idx)
        end
    end)
end




function RewardCell:render(data, idx)
    self.idx = idx
    if self.awardList then
        self.bg:removeChild(self.awardList)
    end

    self.awardList = qy.AwardList.new({
        ["award"] = data.award,
        ["cellSize"] = cc.size(120,180),
        ["type"] = 1,
        ["itemSize"] = 2,
        ["hasName"] = false,
    })
    self.awardList:setPosition(80,230)
    self.bg:addChild(self.awardList)

    self.pay_num_txt:setString("铸造"..data.times.."次")

	self:updateStatus(data, idx)
end





function RewardCell:updateStatus(data, idx)
    for i=1, #self.model.achieve_got do
        if self.model.achieve_got[i] == data.times then
            self.Btn_get:setVisible(false)
            self.hasReceive:setVisible(true)
            return 
        end
    end


    if data.times > self.model.click_times then
        self.Btn_get:setVisible(true)
        self.hasReceive:setVisible(false)
        self.Btn_get:setBright(false)
        return
    end


    self.Btn_get:setVisible(true)
    self.Btn_get:setBright(true)
    self.hasReceive:setVisible(false)

end

return RewardCell
