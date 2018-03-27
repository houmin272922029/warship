--[[--
飞跃基金
--]]--


local Dialog = qy.class("Dialog", qy.tank.view.BaseDialog, "leap_fund/ui/Layer")


local userModel = qy.tank.model.UserInfoModel
function Dialog:ctor(delegate)
    Dialog.super.ctor(self)
    self.model = qy.tank.model.LeapFundModel
    self.service = qy.tank.service.LeapFundService

	self:InjectView("bg")
	self:InjectView("Btn_buy")

    for i = 1, 8 do        
        self:InjectView("Node"..i)
        self:InjectView("Text_"..i)
        self:InjectView("Text2_"..i)
        self:InjectView("Btn_"..i)
        self:InjectView("Img_"..i)

        self["Text_"..i]:setString(self.model.score_award[i].level.."级")
        self["Text2_"..i]:setString("达到"..self.model.score_award[i].level.."级即可领取奖励")

        self:OnClick("Btn_"..i, function(sender)
            if self["Btn_"..i]:isBright() then
                self.service:getAward(function(data)
                    if data.award then
                        self:update()                    
                        qy.tank.command.AwardCommand:add(data.award)
                        qy.tank.command.AwardCommand:show(data.award)
                    end
                end, self.model.score_award[i].level)
            end
        end) 

        local award = qy.AwardList.new({
                ["award"] = {{["type"] = 1, ["num"] = self.model.score_award[i].diamond}},
                ["cellSize"] = cc.size(105,180),
                ["type"] = 1,
                ["len"] = 1,
                ["itemSize"] = 1,
                ["hasName"] = false,
            })
        award:setPosition(65,235)
        self["Node"..i]:addChild(award)
    end


	self:OnClick("Btn_close", function(sender)
        self:removeSelf()
    end,{["isScale"] = false})


    self:OnClick("Btn_buy", function(sender)
        local data = qy.tank.model.RechargeModel.data["tk198"]
            qy.tank.service.RechargeService:paymentBegin(data, function(flag, msg)
                if flag == 3 then
                    self.toast = qy.tank.widget.Toast.new()
                    self.toast:make(self.toast, qy.TextUtil:substitute(58001))
                    self.toast:addTo(qy.App.runningScene, 1000)
                elseif flag == true then
                    self.toast:removeSelf()
                    self.model.status = 1
                    self:update()
                    qy.hint:show(qy.TextUtil:substitute(58002))
                else
                    self.toast:removeSelf()
                    qy.hint:show(msg)
                end
            end)
    end,{["isScale"] = false})




    self:update()
end



function Dialog:update()
    if self.model.status == 1 then
        self.Btn_buy:setVisible(false)
    end


    for i = 1, 8 do
        print(self.model.receive[tostring(self.model.score_award[i].level)])
        if self.model.score_award[i].level <= userModel.userInfoEntity.level and self.model.status == 1 and self.model.receive[tostring(self.model.score_award[i].level)] ~= 1 then
            self["Btn_"..i]:setBright(true)
        else
            self["Btn_"..i]:setBright(false)
        end

        if self.model.receive[tostring(self.model.score_award[i].level)] ~= 1 then
            self["Img_"..i]:setTexture("leap_fund/res/lingqu1.png")
        else
            self["Img_"..i]:setTexture("leap_fund/res/yilingqu.png")
        end
    end
end



return Dialog