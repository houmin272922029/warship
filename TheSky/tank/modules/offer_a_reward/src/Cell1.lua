local Cell1 = qy.class("Cell1", qy.tank.view.BaseView, "offer_a_reward.ui.Cell1")

local model = qy.tank.model.OfferARewardModel
local service = qy.tank.service.OfferARewardService
local userinfoModel = qy.tank.model.UserInfoModel
local NumberUtil = qy.tank.utils.NumberUtil

function Cell1:ctor(delegate)
   	Cell1.super.ctor(self)

    self:InjectView("Text_task_name")
    self:InjectView("Text_boss_name")
    self:InjectView("Text_time")
    self:InjectView("Text_status")
    self:InjectView("Text_complete_num")
    self:InjectView("Text_complete_num_5")
    self:InjectView("Img_status")
    self:InjectView("Btn_complete")
    self:InjectView("Btn_complete_5")

    self.parent = delegate    
    self.prompt_list = {"休息中", "整顿中", "侦查中", "检查装备中", "和路人打探中", "快速前进中", "全速前进中", "探索军火库", "路途休息中"}
    self.prompt_list2 = {40, 30, 15, 25, 10, 10, 8, 40, 25}
end

function Cell1:render(data, idx)
    self.idx = idx
    data.reward = model:getRewardById(data.id)
    data.reward_intell_content = model:getRewardContent()
    data.reward_intell_consume = model:getRewardConsumeById(data.information_id)
    
    self.Text_task_name:setString(data.reward.title)
    self.Text_boss_name:setString(data.reward.commander)
    self.Text_complete_num:setString(data.reward.diamond)
    self.Text_complete_num_5:setString(data.reward.diamond * 5)

    self.Img_status:runAction(self:updateAction())

    self.data = data

    self:OnClick(self.Btn_complete, function()
        if self.data.end_time >= userinfoModel.serverTime then
            self:completeDialog(1, data.reward.diamond)
        end
    end,{["isScale"] = false})

    self:OnClick(self.Btn_complete_5, function()
        if self.data.end_time >= userinfoModel.serverTime then
            self:completeDialog(5, data.reward.diamond * 5)
        end
    end,{["isScale"] = false})


    if data.reward.quality == 1 then
        self.Text_task_name:setColor(cc.c3b(255, 255, 255))
    elseif data.reward.quality == 2 then
        self.Text_task_name:setColor(cc.c3b(46, 190, 83))
    elseif data.reward.quality == 3 then
        self.Text_task_name:setColor(cc.c3b(36, 174, 242))
    elseif data.reward.quality == 4 then
        self.Text_task_name:setColor(cc.c3b(172, 54, 249))
    elseif data.reward.quality == 5 then
        self.Text_task_name:setColor(cc.c3b(255, 153, 0))
    end
end

function Cell1:updateTime()
    if self.Text_time then
        self.Text_time:setString(self:getRemainTime())
        if self.data.end_time - userinfoModel.serverTime > 30 then
            self.Text_time:setColor(cc.c3b(46, 190, 83))--绿色
        else
            self.Text_time:setColor(cc.c3b(255, 0, 0))--红色
        end

        self:updateStatus()
    end
end

function Cell1:onEnter()
    self:updateTime()
    self.timeListener = qy.Event.add(qy.Runtime.TIMER_UPDATE,function(event)
        self:updateTime()
    end)
end

function Cell1:onExit()
    if self.timeListener then
        qy.Event.remove(self.timeListener)
        self.timeListener = nil
    end
end


function Cell1:getRemainTime()
    if self.data.end_time ~= nil and self.data.end_time >= userinfoModel.serverTime then
        local time = self.data.end_time - userinfoModel.serverTime
        return NumberUtil.secondsToTimeStr(time, 6)
    else
        qy.Event.remove(self.timeListener)
        self.timeListener = nil

        service:get(function(data)
            --require("offer_a_reward.src.CompleteDialog").new(model:getFinish()):show()
            self.parent:update()
        end)

        return "完成"
    end
end


function Cell1:completeDialog(times, price)
    qy.alert:show({qy.TextUtil:substitute(46004), {255,255,255}}, "是否花费"..price.."钻石立即完成悬赏？", cc.size(450 , 260), {{qy.TextUtil:substitute(46006), 4}, {qy.TextUtil:substitute(46007) , 5}}, function(flag)
        if flag == qy.TextUtil:substitute(46007) then

                print("ddddddddddd")
                print(self.idx - 1)

            service:finish(function(data)
                self.parent:update()

                if data.award ~= nil then
                    qy.tank.command.AwardCommand:add(data.award)
                    qy.tank.command.AwardCommand:show(data.award)
                end
            end, self.idx-1, times) 
        end
    end,"")

end


function Cell1:updateStatus()
    self.prompt_num = self.prompt_num + 1
    if self.prompt_num > 3 then
        self.prompt_num = 1
    end

    -- if self.prompt_num == 1 then
    --     self.Text_status:setString(self.prompt_current..".")
    -- elseif self.prompt_num == 2 then
    --     self.Text_status:setString(self.prompt_current.."..")
    -- elseif self.prompt_num == 3 then
    --     self.Text_status:setString(self.prompt_current.."...")
    -- end
    self.Text_status:setString(self.prompt_current)
end


function Cell1:updateAction()
    local num = math.random(1, 9)
    self.prompt_current = self.prompt_list[num]
    self.prompt_num = 1
    local func1 = cc.ScaleTo:create(0, 0, 1)
    local func2 = cc.ScaleTo:create(self.prompt_list2[num], 1, 1)
    local func3 = cc.CallFunc:create(function() 
        self.Img_status:runAction(self:updateAction())
        self:updateStatus()
    end)

    
    return cc.Sequence:create(func1, func2, func3)
end

return Cell1