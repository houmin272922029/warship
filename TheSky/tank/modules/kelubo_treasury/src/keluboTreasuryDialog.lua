--[[--
--克虏伯
--Author: Fu.Qiang
--Date: 2016-07-04
--]]--


local keluboTreasuryDialog = qy.class("keluboTreasuryDialog", qy.tank.view.BaseDialog, "kelubo_treasury/ui/Dialog")

local model = qy.tank.model.KeluboTreasuryModel
local service = qy.tank.service.KeluboTreasuryService
local userinfoModel = qy.tank.model.UserInfoModel
local NumberUtil = qy.tank.utils.NumberUtil
function keluboTreasuryDialog:ctor(delegate)
    keluboTreasuryDialog.super.ctor(self)

	self:InjectView("bg")
    self:InjectView("Text_time")
	self:InjectView("Text_time1")
	self:InjectView("Text_time2")
    self:InjectView("Text_time3")
    self:InjectView("Sprite_ps")
    self:InjectView("Text_cz_1")
    self:InjectView("Text_f_1")
    self:InjectView("Text_cz_2")
    self:InjectView("Text_f_2")
    self:InjectView("Text_cz_3")
    self:InjectView("Text_f_3")
    self:InjectView("Text_leichong")
    self:InjectView("Text_dangwei")
    self:InjectView("Button_gopay")
    self:InjectView("Button_close")

	self:OnClick(self.Button_close, function(sender)
        self:removeSelf()
    end,{["isScale"] = false})

    self:OnClick(self.Button_gopay, function(sender)
        self:removeSelf()
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.RECHARGE)
    end,{["isScale"] = false})

    if model.cash < model.award_list[1].cash then
        self.Sprite_ps:setScaleX(model.cash / model.award_list[1].cash * 0.33)
        self.Text_dangwei:setString("无")
    elseif model.cash < model.award_list[2].cash then
        self.Sprite_ps:setScaleX(0.33 + (model.cash - model.award_list[1].cash) / (model.award_list[2].cash - model.award_list[1].cash) * 0.33)
        self.Text_dangwei:setString("普通型红利")
        self.Text_dangwei:setColor(cc.c3b(89, 208, 89))
    elseif model.cash < model.award_list[3].cash then
        self.Sprite_ps:setScaleX(0.66 + (model.cash - model.award_list[2].cash) / (model.award_list[3].cash - model.award_list[2].cash) * 0.33)
        self.Text_dangwei:setString("经济型红利")
        self.Text_dangwei:setColor(cc.c3b(0, 178, 218))
    else 
        self.Sprite_ps:setScaleX(1)
        self.Text_dangwei:setString("豪华型红利")
        self.Text_dangwei:setColor(cc.c3b(255, 238, 48))
    end

    self.Text_leichong:setString(model.cash.."元")
    self.Text_cz_1:setString("充"..model.award_list[1].cash.."元")
    self.Text_cz_2:setString("充"..model.award_list[2].cash.."元")
    self.Text_cz_3:setString("充"..model.award_list[3].cash.."元")
    self.Text_f_1:setString("返"..model.award_list[1].combination.."钻")
    self.Text_f_2:setString("返"..model.award_list[2].combination.."钻")
    self.Text_f_3:setString("返"..model.award_list[3].combination.."钻")   

    --self.Text_time:setString(os.date("%d", model.end_time - model.start_time).."天")
    self.Text_time1:setString(os.date("%Y-%m-%d",model.start_time).."至"..os.date("%Y-%m-%d",model.end_time))
    self.Text_time2:setString(os.date("%Y-%m-%d",model.startAwardTime).."至"..os.date("%Y-%m-%d",model.endAwardTime))

end



function keluboTreasuryDialog:updateTime()
    if self.Text_time3 then
        local time = model.end_time - userinfoModel.serverTime
        if time > 0 then
            self.Text_time3:setString(NumberUtil.secondsToTimeStr(time, 9).."后充值期结束")
        else
            self.Text_time3:setString(qy.TextUtil:substitute(63035))
        end        
    end
end

function keluboTreasuryDialog:onEnter()
    self:updateTime()
    self.timeListener = qy.Event.add(qy.Runtime.TIMER_UPDATE,function(event)
        self:updateTime()
    end)
end

function keluboTreasuryDialog:onExit()
    qy.Event.remove(self.timeListener)
    self.timeListener = nil
end



return keluboTreasuryDialog