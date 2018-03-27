--[[--
--]]--


local Dialog = qy.class("Dialog", qy.tank.view.BaseDialog, "battlefield_store/ui/Layer")


local userinfoModel = qy.tank.model.UserInfoModel
local NumberUtil = qy.tank.utils.NumberUtil
function Dialog:ctor(delegate)
    Dialog.super.ctor(self)

    self.model = qy.tank.model.BattleFieldStoreModel
    self.service = qy.tank.service.BattleFieldStoreService

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
    self:InjectView("Btn_close")

	self:OnClick(self.Btn_close, function(sender)
        self:removeSelf()
    end,{["isScale"] = false})



    for i = 1, 3 do 
        self:OnClick(self["Btn_"..i], function(sender)
            if self.model.cash_id == 0 then
                local txt = (i == 1 and "普通型" or i == 2 and "经济型" or i == 3 and "豪华型")

                qy.alert:show({"提示", {255,255,255}}, "是否进行"..txt.."储备", cc.size(450 , 260), {{qy.TextUtil:substitute(46006), 4}, {qy.TextUtil:substitute(46007) , 5}}, function(flag)
                    if flag == qy.TextUtil:substitute(46007) then
                        self.service:buy(function(data)
                            self:update()
                            if data.cash_id and data.cash_id ~= 0 then
                                qy.hint:show("储备成功")
                            end
                        end, i)
                    end
                end,"")
                
            end
        end,{["isScale"] = false})
    end


    --self.Text_time:setString(os.date("%d",self.model.end_time - userinfoModel.serverTime).."天")


    self.Text_1:setString("存入".. self.model.award_list[1].cash .."，一共获得".. self.model.award_list[1].combination .."钻石")
    self.Text_2:setString("存入".. self.model.award_list[2].cash .."，一共获得".. self.model.award_list[2].combination .."钻石")
    self.Text_3:setString("存入".. self.model.award_list[3].cash .."，一共获得".. self.model.award_list[3].combination .."钻石")

    self:update()

end

function Dialog:update()
    if self.model.cash_id and self.model.cash_id ~= 0 then
        self.Btn_1:setBright(false)
        self.Btn_2:setBright(false)
        self.Btn_3:setBright(false)
        self["Sprite_"..self.model.cash_id]:setTexture("battlefield_store/res/33.png")
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