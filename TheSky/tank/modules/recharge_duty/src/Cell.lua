

local Cell = qy.class("Cell", qy.tank.view.BaseView, "recharge_duty/ui/Cell")


function Cell:ctor(delegate)
    Cell.super.ctor(self)

    self.model = qy.tank.model.RechargeDutyModel
    self.service = qy.tank.service.RechargeDutyService
    self.delegate = delegate

    self:InjectView("Text_1")
    self:InjectView("Text")
    self:InjectView("Img_yilingqu")
    self:InjectView("Btn")
    self:InjectView("bg")

    self.Img_yilingqu:setVisible(false)

  
end

function Cell:render(data, idx)
    if self.award_1 then
        self.bg:removeChild(self.award_1)
        self.award_1 = nil
    end
    self.type = _type

    self.award_1 = qy.AwardList.new({
            ["award"] = data.award,
            ["cellSize"] = cc.size(95,180),
            ["type"] = 1,
            ["len"] = 5,
            ["itemSize"] = 2,
            ["hasName"] = false,
    })
    self.award_1:setPosition(70,240)
    self.bg:addChild(self.award_1)

    self.Text_1:setString(data.desc)

    self.Btn:setVisible(true)
    self.Img_yilingqu:setVisible(false)

    if self.model.list[tostring(idx)].status == -1 then
        self.Btn:setVisible(false)
        self.Img_yilingqu:setVisible(true)
    elseif self.model.list[tostring(idx)].status == 0 then        
        if data.type == 2 then
            self.Text:setString("充值")
            self:OnClick("Btn", function(sender)
                self:pay(data.args, function()
                    self.model.list[tostring(idx)].status = 1
                    self.delegate:updateList()
                end)                
            end)
        end
    elseif self.model.list[tostring(idx)].status == 1 then
        self.Text:setString("领取")
        self:OnClick("Btn", function(sender)
            self.service:getAward(function()                
                qy.tank.command.AwardCommand:add(data.award)
                qy.tank.command.AwardCommand:show(data.award)
                self.model.list[tostring(idx)].status = -1
                self.delegate:updateList()
            end, idx)
        end)
    elseif self.model.list[tostring(idx)].status == 2 then        
        self.Text:setString("已过期")
        self:OnClick("Btn", function(sender) 
            qy.hint:show("已过期")
        end)
    end


end



function Cell:pay(str, callback)
    local data = qy.tank.model.RechargeModel.data[str]

    qy.tank.service.RechargeService:paymentBegin(data, function(flag, msg)
        if flag == 3 then
            self.toast = qy.tank.widget.Toast.new()
            self.toast:make(self.toast, qy.TextUtil:substitute(58001))
            self.toast:addTo(qy.App.runningScene, 1000)
        elseif flag == true then
            self.toast:removeSelf()
            self.service:get(function(data)                     
                callback()
            end)
            qy.hint:show(qy.TextUtil:substitute(58002))
        else
            self.toast:removeSelf()
            qy.hint:show(msg)
        end
    end)
end

return Cell
