--[[--
--]]--


local Dialog = qy.class("Dialog", qy.tank.view.BaseDialog, "battlefield_supply/ui/Layer")


local userinfoModel = qy.tank.model.UserInfoModel
local NumberUtil = qy.tank.utils.NumberUtil
function Dialog:ctor(delegate)
    Dialog.super.ctor(self)

    self.model = qy.tank.model.BattleFieldSupplyModel
    self.service = qy.tank.service.BattleFieldSupplyService

	self:InjectView("bg")
    self:InjectView("Btn_1")
	self:InjectView("Btn_2")
	self:InjectView("Btn_3")
    self:InjectView("Sprite_1")
    self:InjectView("Sprite_2")
    self:InjectView("Sprite_3")
    self:InjectView("Text_time")
    self:InjectView("Text_1")
    self:InjectView("Text_2")
    self:InjectView("Text_3")
    self:InjectView("Title_1")
    self:InjectView("Title_2")
    self:InjectView("Title_3")
    self:InjectView("putong1")
    self:InjectView("putong2")
    self:InjectView("putong3")
    self:InjectView("Btn_close")

	self:OnClick(self.Btn_close, function(sender)
        self:removeSelf()
    end,{["isScale"] = false})



    for i = 1, 3 do 
        self:OnClick(self["Btn_"..i], function(sender)
            if self.model.cash_id == 0 then
                local txt = (i == 1 and "普通型" or i == 2 and "经济型" or i == 3 and "豪华型")

                qy.alert:show({"提示", {255,255,255}}, "是否购买"..txt.."补给", cc.size(450 , 260), {{qy.TextUtil:substitute(46006), 4}, {qy.TextUtil:substitute(46007) , 5}}, function(flag)
                    if flag == qy.TextUtil:substitute(46007) then
                        self.service:buy(function(data)
                            self:update()
                            if data.cash_id and data.cash_id ~= 0 then
                                qy.hint:show("购买成功")
                            end
                        end, i)
                    end
                end,"")
                
            end
        end,{["isScale"] = false})


        self.award_1 = qy.AwardList.new({
            ["award"] = self.model.award_list[i].award,
            ["cellSize"] = cc.size(65,180),
            ["type"] = 1,
            ["itemSize"] = 3,
            ["hasName"] = false,
        })
        self.award_1:setPosition(50,315)
        self["putong"..i]:addChild(self.award_1)
    end

    self.Text_1:setString(self.model.award_list[1].desc)
    self.Text_2:setString(self.model.award_list[2].desc)
    self.Text_3:setString(self.model.award_list[3].desc)
    self.Title_1:setString(self.model.award_list[1].name)
    self.Title_2:setString(self.model.award_list[2].name)
    self.Title_3:setString(self.model.award_list[3].name)

    self:update()

end

function Dialog:update()
    if self.model.cash_id and self.model.cash_id ~= 0 then
        self.Btn_1:setBright(false)
        self.Btn_2:setBright(false)
        self.Btn_3:setBright(false)
        self["Sprite_"..self.model.cash_id]:setTexture("battlefield_supply/res/yigoumai.png")
    end
end



function Dialog:updateTime()
    if self.Text_time then
        self.Text_time:setString(self.model:getRemainTime())
    end
end


function Dialog:onEnter()
    self:update()

    self:updateTime()
    self.timeListener = qy.Event.add(qy.Runtime.TIMER_UPDATE,function(event)
        self:updateTime()
    end)
end

function Dialog:onExit()
    qy.Event.remove(self.timeListener)
    self.timeListener = nil
end




return Dialog