--[[--
--]]--
local Dialog = qy.class("Dialog", qy.tank.view.BaseDialog, "yuri_engineer/ui/Layer")

local md5 = require("utils.Md5Util")

function Dialog:ctor(delegate)
    Dialog.super.ctor(self)
    self.model = qy.tank.model.YuriEngineerModel
    self.service = qy.tank.service.YuriEngineerService

	self:InjectView("bg")
	self:InjectView("Btn_close")
    self:InjectView("Btn_help")
    self:InjectView("Btn_go20")
    self:InjectView("Btn_begin")
    self:InjectView("Btn_go_best")
    self:InjectView("Btn_again")
    self:InjectView("Img_over")
    self:InjectView("Btn_rank")

    self:InjectView("Text_num")
    self:InjectView("Text_diamond")
    self:InjectView("Text_silver")
    self:InjectView("Text_2")
    self:InjectView("Text_3")
    self:InjectView("Text_4")
    self:InjectView("Text_5")
    self:InjectView("Text_6")
    self:InjectView("Text_7")
    self:InjectView("Text_8")
    self:InjectView("Text_9")
    self:InjectView("Text_10")
    self:InjectView("Text_11")
    self:InjectView("Text_checkpoint")    
    self:InjectView("Text_award_num")
    self:InjectView("Img_p")
    self:InjectView("Img_x2")

    self:InjectView("Node_begin")
    self:InjectView("Node_1")
    self:InjectView("Node_2")
    self:InjectView("Node_3")
    self:InjectView("Node_4")
    self:InjectView("Node_Touch")

    self:InjectView("bridge")

    
	self:OnClick("Btn_close", function(sender)
        self:removeSelf()
    end,{["isScale"] = false})

    self:OnClick("Btn_begin", function(sender)
        if self.model.today_times < 5 then
            self.service:startGame(function()
                self:start(0)
                self:next()
            end, 0)
        else
            qy.hint:show("今天的次数已经用光了哦")
        end
    end)


    self:OnClick("Btn_again", function(sender)
        self:openEndDialog()
    end,{["isScale"] = false})



    self:OnClick("Btn_go_best", function(sender)
        if self.model.today_times < 5 then
            self.service:startGame(function()
                self:start(self.model.best_max)
                self:next()
            end, 1)
        else
            qy.hint:show("今天的次数已经用光了哦")
        end
    end)


    self:OnClick("Btn_go20", function(sender)
        if self.model.today_times < 5 then
            self.service:startGame(function()
                self:start(20)
                self:next()
            end, 20)
        else
            qy.hint:show("今天的次数已经用光了哦")
        end
    end)

    self:OnClick("Btn_rank", function(sender)
        self.service:getRank(function()
            require("yuri_engineer.src.RankDialog").new():show()
        end)
    end)




    self:OnClick("Btn_help", function()
        qy.tank.view.common.HelpDialog.new(qy.tank.model.HelpTxtModel:getHelpDataByIndx(41)):show(true)
    end)


    


    self.game_start = false
    self.game_pause = false
    self.checkpoint = 0
    self.bridge_max_lenght = 300
    self.bridge_min_lenght = 100
    self.road_max_lenght = 200
    self.road_min_lenght = 50
    

    self.road_1_lenght = 150
    self.road_2_lenght = 120
    self.bridge_lenght = 165    

    self:initData()


    self.Img_1 = ccui.Scale9Sprite:create("yuri_engineer/res/222.png")
    self.Img_1:setCapInsets(cc.rect(22,27,25,29))
    self.Img_1:setAnchorPoint(0.5, 1)
    self.Img_1:setPosition(0, 106.5)
    self.Img_1:setContentSize(cc.size(169, 83))
    self.Node_1:addChild(self.Img_1, -1)

    self.Img_2 = ccui.Scale9Sprite:create("yuri_engineer/res/222.png")
    self.Img_2:setCapInsets(cc.rect(22,27,25,29))
    self.Img_2:setAnchorPoint(0.5, 1)
    self.Img_2:setPosition(0, 106.5)
    self.Img_2:setContentSize(cc.size(139, 83))
    self.Node_2:addChild(self.Img_2, -1)

    self:addTouchEvent()
    self:addMan()
    self:update()
end


function Dialog:initData()
    self.award_list = {}
    self.award_list.checkpoint = 0
    self.double = {}
    self.double2 = {}
    self.bridge_add = true
end


function Dialog:openEndDialog()
    local param = {}
    param.checkpoint = self.checkpoint
    param.callback = function()
        self:initData()
        self:update()
    end
    self.game_start = false
    self.game_pause = true

    self.service:endGame(function()
        require("yuri_engineer.src.EndDialog").new(param):show()
    end, (self.checkpoint - 1).."|"..md5.sumhexa((self.checkpoint - 1).."a5f043cda0ab6aa1d076bdb0073bce6d"), self.double2)    
end

function Dialog:update()
    self.Node_1:setPosition(cc.p(200, 0))
    self.Node_2:setVisible(true)
    self.Node_2:setPosition(cc.p(200 + self.road_1_lenght / 2 + self.bridge_lenght + self.road_2_lenght / 2, 0))

    if self.man then
        self.man:setPosition(self.road_1_lenght / 2 - 60, 102)
    end

    self.bridge:setPercent(0)
    self.bridge:setPosition(cc.p(self.road_1_lenght / 2 - 5, 105))
    self.bridge:setRotation(-90)

    self.Img_1:setContentSize(cc.size(self.road_1_lenght + 19, 83))
    self.Img_2:setContentSize(cc.size(self.road_2_lenght + 19, 83))

    if self.game_start == false then
        self.Node_begin:setVisible(true)
        self.Node_3:setVisible(false)
    else
        self.Node_begin:setVisible(false)
        self.Node_3:setVisible(true)
    end

    self.Btn_again:setVisible(false)
    self.Img_over:setVisible(false)

    --self.Text_1:setString(self.model.today_best)
    self.Text_2:setString(self.model.best_max)
    for i = 1, #self.model.record do
        local _type = tostring(self.model.record[i].type)
        local already = self.model.record[i].already
        local max_num = self.model.record[i].max_num
        if _type == "1" then
            self.Text_5:setString(already)
            self.Text_3:setString(max_num)
        elseif _type == "3" then
            self.Text_6:setString(already)
            self.Text_4:setString(max_num)
        elseif _type == "28" then
            self.Text_10:setString(already)
            self.Text_9:setString(max_num)
        end
    end
    self.Text_7:setString(self.award_list["1"] or 0)
    self.Text_8:setString(self.award_list["3"] or 0)
    self.Text_11:setString(self.award_list["28"] or 0)

    self.Text_checkpoint:setString(self.checkpoint - 1)
    

    self.Text_num:setString(((5 - self.model.today_times) < 0 and 0 or (5 - self.model.today_times)).."/5")


    if self.model.best_max >= 20 then
        self.Btn_go20:setVisible(true)
    else
        self.Btn_go20:setVisible(false)
    end


    if self.model.best_max >= 1 then
        self.Btn_go_best:setVisible(true)
    else
        self.Btn_go_best:setVisible(false)
    end

    if self.checkpoint > 0 then
        self.Text_award_num:setString("X"..self.model.award_list[(self.checkpoint - 1) % 50 + 1].award[1].num)
        
        if self.Img_award then
            self.Node_4:removeChild(self.Img_award)
            self.Img_award = nil
        end
        self.Img_award = ccui.ImageView:create()
        self.Img_award:loadTexture("Resources/common/icon/coin/"..self.model.award_list[(self.checkpoint - 1) % 50 + 1].award[1].type..".png")
        self.Img_award:setPosition(cc.p(0, 170))
        self.Img_award:setScale(0.5)
        self.Node_4:addChild(self.Img_award)

        self.Node_4:stopAllActions()
        self.Node_4:setPosition(cc.p(0, 0))
        self.Node_4:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.MoveBy:create(0.5, cc.p(0, 5)), cc.MoveBy:create(0.5, cc.p(0, -5)))))
    else
        self.Node_2:setVisible(false)
    end

    self.Text_award_num:setPosition(cc.p(0, 132))

    self.Img_x2:setVisible(false)

    

    local silver = qy.tank.model.UserInfoModel.userInfoEntity.silver
    if silver > 9999999 then
        self.Text_silver:setString(math.floor(silver/10000).."W")
    else
        self.Text_silver:setString(silver)
    end
   
    self.Text_diamond:setString(qy.tank.model.UserInfoModel.userInfoEntity.diamond)



end


function Dialog:addMan()
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/ui/ui_fx_gongchengshi",function()
        self.man = ccs.Armature:create("ui_fx_gongchengshi")
        self.Node_1:addChild(self.man)
        self.man:setPosition(self.road_1_lenght / 2 - 60, 102)
        self.man:getAnimation():playWithIndex(0)
    end)
end


function Dialog:addTouchEvent()
    self.listener = cc.EventListenerTouchOneByOne:create()
    local function onTouchBegan(touch, event)        
        local speed = math.random(2, 3)

        if self.game_start == false or self.game_pause == true then
            return true
        end

        if self.timer1 == nil then
            self.timer1 = qy.tank.utils.Timer.new(0.02, 9999, function(leftTime)
                if self.bridge_add then
                    self.bridge:setPercent(self.bridge:getPercent() + speed)
                    if self.bridge:getPercent() >= 100 then
                        self.bridge:setPercent(100)
                        self.bridge_add = false
                    end
                else
                    self.bridge:setPercent(self.bridge:getPercent() - speed)
                    if self.bridge:getPercent() <= 0 then
                        self.bridge:setPercent(0)
                        self.bridge_add = true
                    end
                end
            end)
            self.timer1:start()
        end
        return true
    end

    local function onTouchMoved(touch, event)
    end

    local function onTouchEnded(touch, event)
        if self.game_start == false or self.game_pause == true then
            return
        end

        if self.timer1 ~= nil then
            self.timer1:stop()
            self:run()
        end
        self.timer1 = nil        
    end

    self.listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
    self.listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED)
    self.listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED)
    self.eventDispatcher = self:getEventDispatcher()
    self.eventDispatcher:addEventListenerWithSceneGraphPriority(self.listener,self.Node_Touch)
    -- eventDispatcher:addEventListenerWithFixedPriority(listener,-1)
end



function Dialog:run()
    self.game_pause = true
    self.bridge:runAction(cc.Sequence:create(cc.RotateTo:create(0.3, 0), cc.CallFunc:create(function()
        self.man:getAnimation():playWithIndex(1)

        local num = self:judge()
        if num == 0 then
            self.man:runAction(cc.Sequence:create(cc.MoveBy:create((self.bridge_lenght + self.road_2_lenght) / 300, cc.p(self.bridge_lenght + self.road_2_lenght, 0)), cc.CallFunc:create(function()
                self.man:getAnimation():playWithIndex(0)                
                self.Node_2:runAction(cc.Sequence:create(cc.MoveBy:create(0.3, cc.p(-self.bridge_lenght - self.road_2_lenght, 0))))
                self.Node_1:runAction(cc.Sequence:create(cc.MoveBy:create(0.3, cc.p(-self.bridge_lenght - self.road_2_lenght, 0)), cc.CallFunc:create(function()
                    self:next()
                end)))
            end)))
        elseif num == 1 then
            self.man:runAction(cc.Sequence:create(cc.MoveBy:create((self.bridge_lenght) / 300, cc.p(self.bridge_lenght2 + 60, 0)), cc.CallFunc:create(function()
                self.man:getAnimation():playWithIndex(0)

                self.man:runAction(cc.MoveBy:create(0.3, cc.p(0, -250)))
                self.bridge:runAction(cc.Sequence:create(cc.RotateTo:create(0.3, 45), cc.CallFunc:create(function()
                    self:lose()
                end)))
            end)))
        else
            self.man:runAction(cc.Sequence:create(cc.MoveBy:create(num / 300, cc.p(num + 100, 0)), cc.CallFunc:create(function()
                self.man:getAnimation():playWithIndex(0)

                self.man:runAction(cc.Sequence:create(cc.MoveBy:create(0.3, cc.p(0, -250)), cc.CallFunc:create(function()
                    self:lose()
                end)))
            end)))
        end
        if math.floor(math.abs(self.bg:getPositionX())) == 1280 then
            self.bg:setPosition(cc.p(0, 0))
        end
        self.bg:runAction(cc.MoveBy:create((self.bridge_lenght) / 300, cc.p(-64, 0)))
    end)))
end


function Dialog:next()
    self.checkpoint = self.checkpoint + 1


    self.road_1_lenght = self.road_2_lenght
    self.road_2_lenght = math.random(self.road_min_lenght, self.road_max_lenght)
    self.bridge_lenght = math.random(self.bridge_min_lenght, self.bridge_max_lenght)   
    
    self:getAward()
    self:update()
    

    local x, y = self.Node_2:getPosition()
    self.Node_2:setPosition(cc.p(qy.winSize.width, 0))
    self.Node_2:runAction(cc.Sequence:create(cc.MoveTo:create(0.3, cc.p(x, y)), cc.CallFunc:create(function()
        self.game_start = true
        self.game_pause = false
    end)))
end


function Dialog:judge()
    self.bridge_lenght2 = self.bridge:getPercent() * 474 / 100    

    if self.bridge_lenght2 < self.bridge_lenght then
        return 1
    elseif self.bridge_lenght2 - 5 > self.bridge_lenght + self.road_2_lenght then
        return self.bridge_lenght2 - 5
    else
        if math.abs(self.bridge_lenght2 - 5 - self.bridge_lenght - self.road_2_lenght / 2) < 5 then
            self.double[tostring(self.checkpoint)] = true
            table.insert(self.double2, self.checkpoint)
            self.Img_p:setOpacity(100)
            self.Img_p:runAction(cc.Sequence:create(cc.FadeTo:create(0.3, 255), cc.DelayTime:create(0.2), cc.CallFunc:create(function()
                self.Img_p:setOpacity(0)            
            end)))
            self.Text_award_num:setString("X"..self.model.award_list[(self.checkpoint - 1) % 50 + 1].award[1].num * 2)
            self.Text_award_num:runAction(cc.Sequence:create(cc.ScaleTo:create(0.3, 1.3), cc.ScaleTo:create(0.3, 1)))

            self.Img_award:setPosition(-22, 170)
            self.Img_x2:setVisible(true)
        else
            self.Img_award:runAction(cc.MoveBy:create(0.1, cc.p(0, 120)))
            self.Text_award_num:runAction(cc.MoveBy:create(0.1, cc.p(0, 120)))
        end

        return 0
    end
end


function Dialog:lose()
    self.game_start = false
    self.game_pause = true

    self.Img_over:setVisible(true)
    self.Btn_again:setVisible(true)
    self.Btn_again:setSwallowTouches(true)
end


function Dialog:start(checkpoint)
    self.game_start = true
    self.game_pause = false

    self.Img_over:setVisible(false)
    self.Btn_again:setVisible(false)
    self.Node_begin:setVisible(false)
    self.Node_3:setVisible(true)
    self.checkpoint = checkpoint
end


function Dialog:getAward()    
    for i = self.award_list["checkpoint"] + 1, self.checkpoint - 1 do
        local award = self.model.award_list[(i - 1) % 50 + 1].award[1]      
        print(i)  

        if not self.award_list[tostring(award.type)] then
            self.award_list[tostring(award.type)] = (self.double[tostring(i)] and award.num * 2 or award.num)
        else
            self.award_list[tostring(award.type)] = self.award_list[tostring(award.type)] + (self.double[tostring(i)] and award.num * 2 or award.num)
        end

        self.award_list["checkpoint"] = i
    end
end
function Dialog:onExit()
    -- cc.Director:getInstance():getTextureCache():removeAllTextures()
end








return Dialog