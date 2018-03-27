--[[
    战争图卷
    2016年07月26日17:42:39
]]
local WarPictureDialog = qy.class("WarPictureDialog", qy.tank.view.BaseDialog, "war_picture.ui.WarPictureDialog")

local model = qy.tank.model.WarPictureModel
local service = qy.tank.service.WarPictureService
function WarPictureDialog:ctor(delegate)
    WarPictureDialog.super.ctor(self)


    self.style = qy.tank.view.style.DialogStyle5.new({
        size = cc.size(1100,640),
        position = cc.p(0,0),
        offset = cc.p(0,0),

    })

    self:addChild(self.style , -1)

    self:InjectView("Picture")
    self:InjectView("ChickSelect")
    self:InjectView("Reward_bg")
    self:InjectView("Prestige_Num")
    self:InjectView("Picture_Num")

    self:InjectView("Btn_select")    
    self:InjectView("Btn_help")
    self:InjectView("Btn_reset_buy")
    self:InjectView("Btn_lock_buy")
    self:InjectView("Btn_Auto")
    self:InjectView("Btn_Lose")
    self:InjectView("Btn_Refresh")
    self:InjectView("Btn_Close")

    self:InjectView("R_times")
    self:InjectView("L_times")
    self:InjectView("Prestige")

    self:InjectView("Image_1")
    self:InjectView("Image_2")
    self:InjectView("Image_3")
    self:InjectView("Image_4")
    self:InjectView("Image_5")

    self:InjectView("LockCheckBox_1")
    self:InjectView("LockCheckBox_2")
    self:InjectView("LockCheckBox_3")
    self:InjectView("LockCheckBox_4")
    self:InjectView("LockCheckBox_5")   

    self:InjectView("Locking_1")
    self:InjectView("Locking_2")
    self:InjectView("Locking_3")
    self:InjectView("Locking_4")
    self:InjectView("Locking_5")     

    self:InjectView("Success_1")
    self:InjectView("Success_2")
    self:InjectView("Success_3")
    self:InjectView("Success_4")
    self:InjectView("Success_5")


    self:OnClick(self.LockCheckBox_1, function()        
        service:locking(function(data)            
            self:update()
        end, model:getLockingByIndex2(1), "p_1")
    end,{["isScale"] = false})

    self:OnClick(self.LockCheckBox_2, function()        
        service:locking(function(data)            
            self:update()
        end, model:getLockingByIndex2(2), "p_2")
    end,{["isScale"] = false})

    self:OnClick(self.LockCheckBox_3, function()        
        service:locking(function(data)            
            self:update()
        end, model:getLockingByIndex2(3), "p_3")
    end,{["isScale"] = false})

    self:OnClick(self.LockCheckBox_4, function()        
        service:locking(function(data)            
            self:update()
        end, model:getLockingByIndex2(4), "p_4")
    end,{["isScale"] = false})

    self:OnClick(self.LockCheckBox_5, function()        
        service:locking(function(data)            
            self:update()
        end, model:getLockingByIndex2(5), "p_5")
    end,{["isScale"] = false})




    self:OnClick(self.Btn_Close, function()
        self:removeSelf()
    end,{["isScale"] = false})


    self:OnClick(self.Btn_select, function()
        require("war_picture.src.WarPictureSelectDialog").new(self):show()
    end,{["isScale"] = false})


    self:OnClick(self.Btn_help, function()
        qy.tank.view.common.HelpDialog.new(26):show(true)
    end,{["isScale"] = false})


    self:OnClick(self.Btn_reset_buy, function()
        require("war_picture.src.BuyDialog").new("reset", self):show()
    end,{["isScale"] = false})


    self:OnClick(self.Btn_lock_buy, function()
        require("war_picture.src.BuyDialog").new("lock", self):show()
    end,{["isScale"] = false})


    self:OnClick(self.Btn_Auto, function()
        if self.Btn_Auto:isBright() then
            require("war_picture.src.CompleteDialog").new(self):show()
        end
    end,{["isScale"] = false})



    self:OnClick(self.Btn_Lose, function()
        if self.Btn_Lose:isBright() then
            qy.alert:show({qy.TextUtil:substitute(46004), {255,255,255}}, qy.TextUtil:substitute(90091), cc.size(450 , 260), {{qy.TextUtil:substitute(46006), 4}, {qy.TextUtil:substitute(46007) , 5}}, function(flag)
                if flag == qy.TextUtil:substitute(46007) then
                    service:reset(function(data)            
                        self:update()
                    end)
                end
            end,"")
        end
    end,{["isScale"] = false})



    self:OnClick(self.Btn_Refresh, function()
        if self.Btn_Refresh:isBright() then
            if model.update_num <= 0 then
                require("war_picture.src.BuyDialog").new("reset", self):show()
            elseif model.locking_num < model:getLockingNum() then
                require("war_picture.src.BuyDialog").new("lock", self):show()
            else 
                for i = 1, 5 do
                    if model:getMatchingById(i) and model:getLockingByIndex(i) == false then
                        qy.alert:show({qy.TextUtil:substitute(46004), {255,255,255}}, qy.TextUtil:substitute(90092), cc.size(450 , 260), {{qy.TextUtil:substitute(46006), 4}, {qy.TextUtil:substitute(46007) , 5}}, function(flag)
                            if flag == qy.TextUtil:substitute(46007) then
                                service:update(function(data)            
                                    self:update()
                                end)
                            end
                        end,"")
                        break
                    elseif i == 5 then
                        service:update(function(data)            
                            self:update()
                        end)
                    end
                end
            end
        end
    end,{["isScale"] = false})

    self:update()

end


function WarPictureDialog:update()
    if model.selected > 0 then
        if model.selected == 0 then
            self.Picture:loadTexture("war_picture/res/q1.jpg",0)
        else
            self.Picture:loadTexture("war_picture/res/"..model.selected.."/".."bg.jpg",0)           
        end

        self.Btn_select:setVisible(false)
        self.Btn_Auto:setBright(true)
        self.Btn_Lose:setBright(true)
        self.Btn_Refresh:setBright(true)
        self.Reward_bg:setVisible(true)

        self.Image_1:setVisible(true)
        self.Image_2:setVisible(true)
        self.Image_3:setVisible(true)
        self.Image_4:setVisible(true)
        self.Image_5:setVisible(true)

        self.Image_1:loadTexture(model:getImgPath(model.position["p_1"]),0)
        self.Image_2:loadTexture(model:getImgPath(model.position["p_2"]),0)
        self.Image_3:loadTexture(model:getImgPath(model.position["p_3"]),0)
        self.Image_4:loadTexture(model:getImgPath(model.position["p_4"]),0)
        self.Image_5:loadTexture(model:getImgPath(model.position["p_5"]),0)

        self.Success_1:setVisible(model:getMatchingById(1))
        self.Success_2:setVisible(model:getMatchingById(2))
        self.Success_3:setVisible(model:getMatchingById(3))
        self.Success_4:setVisible(model:getMatchingById(4))
        self.Success_5:setVisible(model:getMatchingById(5))

        self.Locking_1:setVisible(model:getLockingByIndex(1))
        self.Locking_2:setVisible(model:getLockingByIndex(2))
        self.Locking_3:setVisible(model:getLockingByIndex(3))
        self.Locking_4:setVisible(model:getLockingByIndex(4))
        self.Locking_5:setVisible(model:getLockingByIndex(5))

        self.Prestige_Num:setString(model.checkpointList[model.selected].award[1].num)
        self.Picture_Num:setString(model.selected)

    end
    self.R_times:setString(model.update_num)
    self.L_times:setString(model.locking_num)
    self.Prestige:setString(qy.tank.model.UserInfoModel.userInfoEntity.reputation)


    if model.status == 200 and model.award ~= 0 then

        self.Btn_Auto:setBright(false)
        self.Btn_Lose:setBright(false)
        self.Btn_Refresh:setBright(false)

        local awardCommand = qy.tank.command.AwardCommand
        awardCommand:add(model.award)
        function tpClose( ... )           

            self.timer = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
                self:reset()
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.timer)
            end,1.5,false)
        end
        awardCommand:show(model.award ,{["callback"] = tpClose, ["tipTxt"] = qy.TextUtil:substitute(90093)})       

    end

    if model.status == 300 then
        self:reset()
    end
end


function WarPictureDialog:onEnter()
    if model.status ~= 200 then
        self:update()
    end
end

function WarPictureDialog:reset()
    self.Image_1:setVisible(false)
    self.Image_2:setVisible(false)
    self.Image_3:setVisible(false)
    self.Image_4:setVisible(false)
    self.Image_5:setVisible(false)

    self.Success_1:setVisible(false)
    self.Success_2:setVisible(false)
    self.Success_3:setVisible(false)
    self.Success_4:setVisible(false)
    self.Success_5:setVisible(false)

    self.Locking_1:setVisible(false)
    self.Locking_2:setVisible(false)
    self.Locking_3:setVisible(false)
    self.Locking_4:setVisible(false)
    self.Locking_5:setVisible(false)

    self.Btn_select:setVisible(true)
    self.Reward_bg:setVisible(false)
    self:playMessageAnimation(self.ChickSelect)

    self.Btn_Auto:setBright(false)
    self.Btn_Lose:setBright(false)
    self.Btn_Refresh:setBright(false)

    self.Picture:loadTexture("war_picture/res/q1.jpg",0)
end


function WarPictureDialog:playMessageAnimation(node)
    if node:getNumberOfRunningActions() == 0 then
        local func1 = cc.FadeTo:create(1, 155)
        local func2 = cc.FadeTo:create(1, 255)
        local func3 = cc.ScaleTo:create(1, 1.3)
        local func4 = cc.ScaleTo:create(1, 1)

        node:runAction(cc.RepeatForever:create(cc.Sequence:create(func1, func2)))
        node:runAction(cc.RepeatForever:create(cc.Sequence:create(func3, func4)))
    end
end


function WarPictureDialog:onExit()
    if self.timer then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.timer)
    end
end

return WarPictureDialog
