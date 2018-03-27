

local Cell = qy.class("Cell", qy.tank.view.BaseView, "login_fund/ui/Cell")


function Cell:ctor(delegate)
    Cell.super.ctor(self)

    self.model = qy.tank.model.LoginFundModel
    self.service = qy.tank.service.LoginFundService
    self.delegate = delegate

    self:InjectView("Text_1")
    self:InjectView("Text_2")--进度
    self:InjectView("Img_yilingqu")
    self:InjectView("Btn_get")
    self:InjectView("bg")

    self.Img_yilingqu:setVisible(false)

  
end

function Cell:render(idx, data, _type)
    if self.award_1 then
        self.bg:removeChild(self.award_1)
        self.award_1 = nil
    end
    self.type = _type


    self.award_1 = qy.AwardList.new({
            ["award"] = data,
            ["cellSize"] = cc.size(100,180),
            ["type"] = 1,
            ["itemSize"] = 2,
            ["hasName"] = false,
    })
    self.award_1:setPosition(80,240)
    self.bg:addChild(self.award_1)

    self.Text_1:setString("登录"..idx.."天")
    self.Text_2:setString(tostring(self.model.list[tostring(self.type)]["curr_day"]).."/"..idx )

    local num = self.model.list[tostring(self.type)]["award_status"][tostring(idx)]["status"] 
    if num == -1 then
        self.Img_yilingqu:setVisible(true)
        self.Btn_get:setVisible(false)
    elseif num == 0 then        
        self.Img_yilingqu:setVisible(false)
        self.Btn_get:setVisible(true)
        self.Btn_get:setBright(false)
    elseif num == 1 then        
        self.Img_yilingqu:setVisible(false)
        self.Btn_get:setVisible(true)
        self.Btn_get:setBright(true)
    end

    self:OnClick("Btn_get", function(sender)
            self.service:buy(function(data)
                if data.award then
                    self.Img_yilingqu:setVisible(true)
                    self.Btn_get:setVisible(false)

                    self.model.list[tostring(self.type)]["award_status"][tostring(idx)]["status"] = -1

                    qy.tank.command.AwardCommand:add(data.award)
                    qy.tank.command.AwardCommand:show(data.award)
                end
            end, self.type, idx)
    end)
    
end

return Cell
