local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "lucky_draw.ui.MainDialog")

local service = qy.tank.service.LuckyDrawService
local model = qy.tank.model.LuckyDrawModel
local activity = qy.tank.view.type.ModuleType
local endY = -40
function MainDialog:ctor(delegate)
   	MainDialog.super.ctor(self)
    self:InjectView("BG")
   	self:InjectView("oneBt1")
   	self:InjectView("oneBt2")
    self:InjectView("oneBt3")
    self:InjectView("Time")
    self:InjectView("rankBt")
   	self:InjectView("Button_start")
   	self:InjectView("shuoming")
    self:InjectView("icon")
    self:InjectView("freetime")
    self:InjectView("beginimg")
    self:InjectView("endBt")
    self:InjectView("huafei")
    self.huafei:setString("x100")
    self.endBt:setVisible(false)
    self:OnClick("Btn_close", function()
        if not self.isPlaying1 and not self.isPlaying2 and not self.isPlaying3 then -- 锁
            self:removeSelf()
        end
    end,{["isScale"] = false})
    self:OnClick("oneBt1", function()
        if self.isPlaying1 and self.btflag1 then
            self.btflag1 = false
            self:stop(1)
        end
    end,{["isScale"] = false})
    self:OnClick("oneBt2", function()
        if self.isPlaying2 and self.btflag2 then
            self.btflag2 = false
            self:stop(2)
        end
    end,{["isScale"] = false})
    self:OnClick("oneBt3", function()
       if self.isPlaying3 and self.btflag3 then
        self.btflag3 = false
            self:stop(3)
        end
    end,{["isScale"] = false})
    self:OnClick("endBt", function()
       if self.isPlaying1 or self.isPlaying2 or self.isPlaying3 then
            self:stop(1)
            self:stop(2)
            self:stop(3)
        end
    end,{["isScale"] = false})

    self:OnClick("Button_start", function()
        if not self.isPlaying1 and not self.isPlaying2 and not self.isPlaying3 then -- 锁
        
            service:satrt( function(reData)
                model.last_free_times = model.last_free_times -1
                self.Button_start:setVisible(false)
                self.endBt:setVisible(true)
                if reData.award then
                    self.endaward = reData.award
                    print("最后的奖励",json.encode(self.endaward))
                end
                self:updateicon()
                self.types1 = 1
                self.types2 = 1
                self.types3 = 1
                self.playend1 = 1
                self.playend2 = 1
                self.playend3 = 1
                self:play()
            end)
        end  
       
    end,{["isScale"] = false})
     self:OnClick("rankBt", function()
        if not self.isPlaying1 and not self.isPlaying2 and not self.isPlaying3 then -- 锁
            service:getranklist( function(reData)
                require("lucky_draw.src.CombatCastingRankDialog").new():show()
            end)
        end
    end,{["isScale"] = false})
    self:OnClick("shuoming", function()
        if not self.isPlaying1 and not self.isPlaying2 and not self.isPlaying3 then -- 锁
            qy.tank.view.common.HelpDialog.new(52):show(true)
        end
    end,{["isScale"] = false})
    local award = {["type"] = 1,["num"] = 20}
    for i = 1, 9 do
        local data = model.awardList
        local indexa = math.random(1,#data)
        local item = qy.tank.view.common.AwardItem.createAwardView(data[indexa].award[1], 1)
        if i <= 3 then
             item:setPosition( 165,492 - i * 85)
        elseif (i >3 and i<= 6) then
            item:setPosition( 400,492 - (i-3) * 85)
        else
            item:setPosition( 635,492 - (i-6) * 85)
        end
        item.num:setVisible(false)
        item:showTitle(false)
        item:setScale(0.7)
        self["item" .. i] = item
        self.BG:addChild(item)
    end
    self.totalflag = true
    self.btflag1 = true
    self.btflag2 = true
    self.btflag3 = true
    self.speed1 = 1100
    self.speed2 = 1100
    self.speed3 = 1100
    self.types1 = 1
    self.types2 = 1
    self.types3 = 1
    self.playend1 = 1
    self.playend2 = 1
    self.playend3 = 1
    self.endaward = {}
    self:updateicon()
end
function MainDialog:updateicon(  )
    self.icon:setVisible(model.last_free_times <= 0)
    self.freetime:setVisible(model.last_free_times > 0)
    self.freetime:setString("免费次数:"..model.last_free_times)
end
function MainDialog:stop( i )
    self["types"..i] = 2
end

function MainDialog:play(data)
    self.data = data
    
    for i = 1, 9 do
        self["item" .. i]:setVisible(false)
    end
    for i=1,3 do
        self["isPlaying"..i] = true
        if self["clip"..i] then
            self["clip"..i]:removeSelf()
        end

        self["node1"..i] = self:getNode(1)
        self["x"..i] = self["node1"..i]:getPositionX()
        self["y"..i] = self["node1"..i]:getPositionY()
        -- print("===================",self["positions1"..i])
        local func1 = cc.CallFunc:create(function()
            self["node1"..i]:removeSelf()
            self:play1(i,1)
        end)
        local func2 = cc.MoveTo:create(math.abs(endY-self["y"..i])/self["speed"..i], cc.p(self["x"..i], endY))
        local seq = cc.Sequence:create(func2,  func1)
        self["node1"..i]:runAction(seq)
        local position = self.Button_start:getParent():convertToWorldSpace(cc.p(self.Button_start:getPositionX(),self.Button_start:getPositionY()))


        self["node2"..i] = self:getNode(2)
        self["positions2"..i] = self["node2"..i]:getPositionY()
        local func3 = cc.CallFunc:create(function()
            self["node2"..i]:removeSelf()
            self:play2(i,1)
        end)
        local func4 = cc.MoveTo:create(math.abs(endY-self["positions2"..i])/self["speed"..i], cc.p(self["x"..i], endY))
        local seq = cc.Sequence:create(func4,  func3)
        self["node2"..i]:runAction(seq)

        self["node3"..i] = self:getNode(3)
        self["positions3"..i] = self["node3"..i]:getPositionY()
        local func5 = cc.CallFunc:create(function()
            self["node3"..i]:removeSelf()
            self:play3(i,1)
        end)
        local func6 = cc.MoveTo:create(math.abs(endY-self["positions3"..i])/self["speed"..i], cc.p(self["x"..i], endY))
        local seq = cc.Sequence:create(func6,  func5)
        self["node3"..i]:runAction(seq)

        self["node4"..i] = self:getNode(4)
        self["positions4"..i] = self["node4"..i]:getPositionY()
        local func7= cc.CallFunc:create(function()
            self["node4"..i]:removeSelf()
            self:play4(i,1)
        end)
        local func8 = cc.MoveTo:create(math.abs(endY-self["positions4"..i])/self["speed"..i], cc.p(self["x"..i], endY))
        local seq = cc.Sequence:create(func8,  func7)
        self["node4"..i]:runAction(seq)

        self["sprite2"..i] = cc.Sprite:create("lucky_draw/res/hhh1.png")
        self["sprite2"..i]:setPosition(position.x - 117 + (i -1)*233 , position.y + 247)
        self["sprite2"..i]:addChild(self["node1"..i])
        self["sprite2"..i]:addChild(self["node2"..i])
        self["sprite2"..i]:addChild(self["node3"..i])
        self["sprite2"..i]:addChild(self["node4"..i])
        for m=1,3 do
            local mm = (i -1)*3 + m
            self["kuang"..mm]= require("lucky_draw.src.Choose").new()
            self["kuang"..mm]:setPosition(cc.p(89,-40 + 85*m))
            self["kuang"..mm]:setVisible(false)
            self["sprite2"..i]:addChild(self["kuang"..mm])
        end
        self["awardnode"..i]= self:getendNode(i)
        self["awardnode"..i]:setVisible(false)
        self["sprite2"..i]:addChild(self["awardnode"..i])


        local sprite = cc.Sprite:create("lucky_draw/res/111.jpg")
        self["clip"..i] = cc.ClippingNode:create()
        self["clip"..i]:setInverted(false)
        self["clip"..i]:setAlphaThreshold(100)
        self:addChild(self["clip"..i])
        self["clip"..i]:addChild(self["sprite2"..i] )
        sprite:setPosition(self["sprite2"..i]:getPositionX(), self["sprite2"..i]:getPositionY())
        self["clip"..i]:setStencil(sprite)
    end
   
end
function MainDialog:playend( i )
    if self["playend"..i] == 1 then
        self["playend"..i] = 2
        self["awardnode"..i]:setVisible(true)
        -- self["node1"..i] = self:getNode(1)
        -- self["sprite2"..i]:addChild(self["node1"..i])
        local func1 = cc.CallFunc:create(function()
            print("++++++晚上")
            self["isPlaying"..i] = false
            self["btflag"..i] = true
            self:update()
        end)
        local y = self["awardnode"..i]:getPositionY()
        local func2 = cc.MoveTo:create(math.abs(-270-y)/self["speed"..i], cc.p(0, -270))
        local seq = cc.Sequence:create(func2, cc.DelayTime:create(0.3), func1)
        self["awardnode"..i]:runAction(seq)
    end
end
function MainDialog:play1( i ,types)
        local aa = i
        self["node1"..i] = self:getNode(1)
        self["sprite2"..i]:addChild(self["node1"..i])
        local func1 = cc.CallFunc:create(function()
            if self["types"..i] == 1 then
                self["node1"..i]:removeSelf()
                self:play1(aa,1)
            else
                self["node1"..i]:removeSelf()
                self:playend(i)
            end
        end)
        local func2 = cc.MoveTo:create(math.abs(endY-self["y"..i])/self["speed"..i], cc.p(self["x"..i], endY))
        local seq = cc.Sequence:create(func2,  func1)
        self["node1"..i]:runAction(seq)
end
function MainDialog:play2( i ,types)
        local aa = i
        self["node2"..i] = self:getNode(1)
        self["sprite2"..i]:addChild(self["node2"..i])
        self["positions2"..i]= self["node2"..i]:getPositionY()
        local func1 = cc.CallFunc:create(function()
            if self["types"..i] == 1 then
                self["node2"..i]:removeSelf()
                self:play2(aa,1) 
            else
                self["node2"..i]:removeSelf()
                self:playend(i)
            end
        end)
        local func2 = cc.MoveTo:create(math.abs(endY-self["positions2"..i])/self["speed"..i], cc.p(self["x"..i], endY))
        local seq = cc.Sequence:create(func2,  func1)
        self["node2"..i]:runAction(seq)
end
function MainDialog:play3( i,types )
        local aa = i
        self["node3"..i] = self:getNode(1)
        self["sprite2"..i]:addChild(self["node3"..i])
        self["positions3"..i]= self["node3"..i]:getPositionY()
        local func1 = cc.CallFunc:create(function()
            if self["types"..i] == 1 then
                self["node3"..i]:removeSelf()
                self:play3(aa,1)
            else
                self["node3"..i]:removeSelf()
                self:playend(i)
            end
        end)
        local func2 = cc.MoveTo:create(math.abs(endY -self["positions3"..i])/self["speed"..i], cc.p(self["x"..i], endY))
        local seq = cc.Sequence:create(func2,  func1)
        self["node3"..i]:runAction(seq)
end
function MainDialog:play4( i,types )
        local aa = i
        self["node4"..i] = self:getNode(1)
        self["sprite2"..i]:addChild(self["node4"..i])
        self["positions4"..i]= self["node4"..i]:getPositionY()
        local func1 = cc.CallFunc:create(function()
            if self["types"..i] == 1 then
                self["node4"..i]:removeSelf()
                self:play4(aa,1)
            else
                self["node4"..i]:removeSelf()
                self:playend(i)
            end
        end)
        local func2 = cc.MoveTo:create(math.abs(endY -self["positions4"..i])/self["speed"..i], cc.p(self["x"..i], endY))
        local seq = cc.Sequence:create(func2,  func1)
        self["node4"..i]:runAction(seq)
end
function MainDialog:getendNode( i )
     local node = cc.Node:create()
        for j = 1, 3 do
            local data = model.awardList
            local endaward = model.machine_result[tostring(i)]
            local indexa = endaward[tostring(j)]
            local item
            item = qy.tank.view.common.AwardItem.createAwardView(data[indexa].award[1], 1)
            item:showTitle(false)
            item:setScale(0.7)
            item:setPosition( 88, 315 + 85 * (j - 1))
            item.num:setVisible(false)
            node:addChild(item)
        end
    return node
end

function MainDialog:getNode(_inde)
    local data = model.awardList
    local indexa = math.random(1,#data)
    local item = qy.tank.view.common.AwardItem.createAwardView(data[indexa].award[1], 1,nil, false)
    item:showTitle(false)
    item:setScale(0.7)
    item.num:setVisible(false)
    item:setPosition( 88, 320+ 90 * (_inde - 1))
    return item
end
function MainDialog:update()
    if not self.isPlaying1 and not self.isPlaying2 and not self.isPlaying3 then
        --显示边框
        for k,v in pairs(model.cool_info) do
            if v.type == 1 then
                self.kuang1:setVisible(true)
                self.kuang4:setVisible(true)
                self.kuang7:setVisible(true)
            elseif v.type == 2 then
                self.kuang2:setVisible(true)
                self.kuang5:setVisible(true)
                self.kuang8:setVisible(true)
            elseif v.type == 3 then
                self.kuang3:setVisible(true)
                self.kuang6:setVisible(true)
                self.kuang9:setVisible(true)
            elseif v.type == 4 then
                self.kuang1:setVisible(true)
                self.kuang5:setVisible(true)
                self.kuang9:setVisible(true)
            else
                self.kuang3:setVisible(true)
                self.kuang5:setVisible(true)
                self.kuang7:setVisible(true)
            end
        end
        if #model.cool_info == 0 then
            self.Button_start:setVisible(true)
            self.endBt:setVisible(false)
        else
            for i=1,9 do
                local actions = {}
                for j=1,3 do
                    local action = cc.FadeOut:create(0.2)--淡出
                    local action2 = cc.FadeIn:create(0.2)--淡入
                    local callback = cc.CallFunc:create(function()
                        self["kuang"..i]:setOpacity(0)
                    end)
                    table.insert(actions, action)
                    table.insert(actions, callback)
                    table.insert(actions, action2)
                end
                local endcallback = cc.CallFunc:create(function()
                    if i == 9 then
                        self.Button_start:setVisible(true)
                        self.endBt:setVisible(false)
                        qy.tank.command.AwardCommand:show1(self.endaward)
                        self.endaward = {}
                    end
                end)
                table.insert(actions, endcallback)
                self["kuang"..i]:runAction(cc.Sequence:create(actions))
            end
        end
       
     
    end
end
function MainDialog:onEnter()
    self.Time:setString(os.date("%Y-%m-%d", model.start_time) .."  至  " .. os.date("%Y-%m-%d", model.end_time))
    -- local time = (model.end_time - qy.tank.model.UserInfoModel.serverTime)< 0 and 0 or (model.end_time - qy.tank.model.UserInfoModel.serverTime)
    -- if time <= 0 then
    --     self.Time:setString(qy.TextUtil:substitute(42002))
    -- else
    --     self.Time:setString(qy.tank.utils.DateFormatUtil:toDateString(time, 7))
    -- end
    -- self.listener_1 = qy.Event.add(qy.Event.BONUS_TIME,function(event)
    --     local time = (model.end_time - qy.tank.model.UserInfoModel.serverTime)< 0 and 0 or (model.end_time - qy.tank.model.UserInfoModel.serverTime)
    --     if time <= 0 then
    --         self.Time:setString(qy.TextUtil:substitute(42002))
    --     else
    --         self.Time:setString(qy.tank.utils.DateFormatUtil:toDateString(time, 7))
    --     end
    -- end)
end

function MainDialog:onExit()
    -- qy.Event.remove(self.listener_1)
end

return MainDialog
