--[[--
--2048
--Author: Fu.Qiang
--Date: 2016-07-04
--]]--


local Dialog = qy.class("Dialog", qy.tank.view.BaseDialog, "activity_2048/ui/Dialog")

local model = qy.tank.model.Activity2048Model
local service = qy.tank.service.Activity2048Service
function Dialog:ctor(delegate)
    Dialog.super.ctor(self)

    self:InjectView("bg")
    self:InjectView("Text_silver")
    self:InjectView("Text_max_silver")
    self:InjectView("Text_time")
    self:InjectView("Text_max_score")
    self:InjectView("Text_score")
    self:InjectView("Text_consume")
    self:InjectView("Text_hammer_times")

    self:InjectView("Sprite_hammer")
    self:InjectView("Sprite_action")    

    self:InjectView("Button_save")
    self:InjectView("Button_hammer")
    self:InjectView("Button_close")

    self:InjectView("Node_end")
    self:InjectView("Sprite_8")
    self:InjectView("Text_score2")
    self:InjectView("Button_begin2")
    self:InjectView("Text_times2")

    self:InjectView("Node_begin")
    self:InjectView("Button_begin")
    self:InjectView("Text_times")

    self:InjectView("Node_game")

       

    self:OnClick(self.Button_save, function(sender)    
        if not self.game_2048:isPauseGame() and not self.game_2048.game_over then  
            service:getAward(function(data)
                if data.status == 100 then
                    qy.hint:show(qy.TextUtil:substitute(90255))
                    self:removeSelf()
                end
            end, {["type"] = 300, ["schedule"] = self.game_2048:getNumList()})
        end
    end,{["isScale"] = false})


    self:OnClick(self.Button_begin2, function(sender)
        if model.game_remain_num > 0 then
            service:getAward(function(data)
                self.Node_begin:setVisible(false)
                self.Node_end:setVisible(false)
                self.game_2048:initGame()
                self:update()
            end, {["type"] = 500})
        end
    end,{["isScale"] = false})


    self:OnClick(self.Button_begin, function(sender)
        if model.game_remain_num > 0 then
            service:getAward(function(data)
                self.Node_begin:setVisible(false)
                self.game_2048:resumeGame()
                self:update()
            end, {["type"] = 500})
        end
    end,{["isScale"] = false})


    self:OnClick(self.Button_close, function(sender)
        self:removeSelf()
    end,{["isScale"] = false})


    self.Text_time:setString(os.date("%Y-%m-%d %H:%M:%S",model.end_time))



    self:OnClick(self.Button_hammer, function(sender)
        if not self.game_2048.game_over and not self.game_2048:isPauseGame() and self.game_2048:getScore() > 6 and model.hammer_pay_remain_num > 0 then
            service:getAward(function(data)
                if data.status == 100 then       
                    qy.hint:show(qy.TextUtil:substitute(90254))

                    self.Sprite_hammer:setVisible(true)
                    self.Sprite_hammer:stopAllActions()
                    self.Sprite_hammer:runAction(cc.RepeatForever:create(
                        cc.Sequence:create(cc.RotateTo:create(0, 15), 
                                            cc.DelayTime:create(0.3), 
                                            cc.RotateTo:create(0, -15), 
                                            cc.DelayTime:create(0.3))))

                            self.game_2048:openHammerModel(function(pos)                            
                                self.Sprite_hammer:stopAllActions()
                                self.Sprite_hammer:retain()
                                self.Sprite_hammer:getParent():removeChild(self.Sprite_hammer)
                                self.Sprite_hammer:setPosition(cc.p(pos.x + 100, pos.y))
                                self.Sprite_hammer:setRotation(45)
                                self.game_2048.bg:addChild(self.Sprite_hammer, 2)
                                self.Button_hammer:setTouchEnabled(false)

                                self.Sprite_hammer:runAction(cc.Sequence:create(cc.DelayTime:create(0.3), cc.RotateTo:create(0.1, -45), cc.DelayTime:create(0.1), cc.CallFunc:create(function()
                                    self.Button_hammer:setTouchEnabled(true)
                                    self.game_2048:stopHammerModel()

                                    self.Sprite_hammer:setVisible(false)
                                    self.Sprite_hammer:retain()
                                    self.Sprite_hammer:getParent():removeChild(self.Sprite_hammer)
                                    self.Sprite_hammer:setPosition(cc.p(215, 205))
                                    self.bg:addChild(self.Sprite_hammer)
                                end)))
                            end)

                    self:update()
                end
            end, {["type"] = 200})
        end

    end,{["isScale"] = false})


    self:OnClick("Button_help", function()
        qy.tank.view.common.HelpDialog.new(33):show(true)
    end, {["isScale"] = false})

    self:OnClick("Button_ranking", function()        
        service:getRankList(function(data)
            require("activity_2048.src.RankDialog").new(self):show()
        end)
    end)


    self.lose_back = function()
        self.game_2048:pauseGame()
        local max_integral = model.max_integral
        service:getAward(function(data)
            self.Node_end:setVisible(true)   
            if self.game_2048:getScore() > max_integral then
                self.Sprite_8:setVisible(true)
                self.Text_score2:setVisible(true)
                self.Text_score2:setString(self.game_2048:getScore())
            else
                self.Sprite_8:setVisible(false)
                self.Text_score2:setVisible(false)
            end            

            self:update()
        end, {["type"] = 400, ["game_start_sign"] = model.game_start_sign, ["integral"] = self.game_2048:getScore()})
    end


    self.num_back = function(num_table)
        self.game_2048:pauseGame()
        service:getAward(function(data)
            self.Sprite_action:stopAllActions()
            self.Sprite_action:runAction(cc.Sequence:create(cc.Repeat:create(cc.Sequence:create(cc.DelayTime:create(0.1), cc.FadeTo:create(0, 255), cc.DelayTime:create(0.1), cc.FadeTo:create(0, 0)), 4), cc.CallFunc:create(function()
                if data.award and #data.award > 0 then
                    qy.tank.command.AwardCommand:add(data.award)
                    qy.tank.command.AwardCommand:show(data.award, {["isShowHint"] = false, ["callback"] = function()
                        self.game_2048:resumeGame()
                    end})
                else
                    self.game_2048:resumeGame()
                end
            end)))               

            self:update()
        end, {["type"] = 100, ["val"] = num_table})
    end

    self.update_callback = function()
        qy.QYPlaySound.playEffect(qy.SoundType.SWITCH_CHAPTER)
        self.Text_score:setString(self.game_2048:getScore())
    end


    self.game_2048 = require("activity_2048.src.Game2048").new(self, "activity_2048/res/number_", cc.size(99, 99), 6, 65536, self.lose_back, model.award_list, self.num_back, self.update_callback)
    self.game_2048:initGame(model.schedule)    
    self.Node_game:addChild(self.game_2048, 1)

    if model.schedule["1"] == nil then
        self.game_2048:pauseGame()
        self.Node_begin:setVisible(true)    
    else
        self.Node_begin:setVisible(false)    
    end

    self:update()
end


function Dialog:update()
    if model.hammer_pay_remain_num == 2 then
        self.Text_hammer_times:setString("2 / 2")
        self.Text_consume:setString("50")
    else
        self.Text_hammer_times:setString(model.hammer_pay_remain_num .. " / 2")
        self.Text_consume:setString("100")
    end

    self.Text_score:setString(self.game_2048:getScore())
    self.Text_silver:setString(model.get_silver)
    self.Text_max_silver:setString(model.max_silver)
    self.Text_max_score:setString(model.max_integral)

    self.Text_times:setString(model.game_remain_num.."/"..model.game_num)
    self.Text_times2:setString(model.game_remain_num.."/"..model.game_num)

    if model.game_remain_num == 0 then
        self.Button_begin:setBright(false)
        self.Button_begin2:setBright(false)
    else
        self.Button_begin:setBright(true)
        self.Button_begin2:setBright(true)
    end
end



return Dialog