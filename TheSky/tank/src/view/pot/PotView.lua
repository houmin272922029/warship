-- 大锅饭

local PotView = qy.class("PotView", qy.tank.view.BaseView, "view/pot/PotView")

function PotView:ctor(delegate)
    PotView.super.ctor(self)

    self.delegate = delegate
    self.userModel = qy.tank.model.UserInfoModel
    self.model = qy.tank.model.PotModel
    self:InjectView("pots")
    self:InjectView("pot1")
    self:InjectView("pot2")
    self:InjectView("pot3")
    self:InjectView("pot4")
    self:InjectView("pot5")
    self:InjectView("say1")
    self:InjectView("say2")
    self:InjectView("say3")
    self:InjectView("say4")
    self:InjectView("say5")
    self:InjectView("chicken")
    self:InjectView("energy")
    -- self:InjectView("clickArea")
    self:InjectView("tips1")
    self:InjectView("tips2")
    self:InjectView("BG")
    self:InjectView("sayContent1")

    self.sayContent1:getVirtualRenderer():setMaxLineWidth(190)
    
    self.service = qy.tank.service.PotService
    self.potPrepareComplete = false
    self.potAnnimationDone = false
    self.isRuning = false
    -- self.clickArea:setContentSize(qy.winSize.width, qy.winSize.height)

    self.BG:setSwallowTouches(false)
    self:OnClick("BG", function(sender)
        if self.isRuning == true then return end
        local param1 = {}
        local  status = self.model.status
        if status == 0 then
            delegate.dismiss()
        elseif status == 2 then
            -- self.say3:setVisible(true)
            self.sayContent1:setString(self.model.says["3"])
            if self.potPrepareComplete == true then
                if self.potAnnimationDone ~= true then
                    self:runPots(true)
                end
            else
                -- self.say4:setVisible(true)
                self.sayContent1:setString(self.model.says["4"])
                self:potStart()
            end
            self:updataAll()
            
        elseif status == 3 then
            delegate.dismiss()
        end              
    end, {["isScale"] = false})

    self:OnClick("chicken", function(sender)
        local param1 = {}
            self.service:eat(param1,function(data)
                qy.hint:show(qy.TextUtil:substitute(24003))
                self:updataAll()
            end)
    end)
    
    self:initPotClick()
    self:updataAll()
    -- qy.tank.utils.ScreenShotUtil:takePoto("potPoto" , true , function(poto)
    --     self.Bg:addChild(poto)
    --     poto:setScale(1.12)
    -- end)
end

function PotView:initPotClick()
    local list = self.model:getAwardList()
    if #list >= 5 then
        for i = 1, 5 do
            self:InjectCustomView("pot" .. i, qy.tank.view.pot.PotPoint, self) 
            self["pot" .. i]:upReward(list[i])
        end
    end

    -- local close1 = self:getUnitByPointNameAndUnitName("pot1"  , "close")
    -- local close2 = self:getUnitByPointNameAndUnitName("pot2"  , "close")
    -- local close3 = self:getUnitByPointNameAndUnitName("pot3"  , "close")
    -- local close4 = self:getUnitByPointNameAndUnitName("pot4"  , "close")
    -- local close5 = self:getUnitByPointNameAndUnitName("pot5"  , "close")

    -- self:OnClick(close1, function(sender)
    --     local open = self:getUnitByPointNameAndUnitName("pot1"  , "open")
    --     close1:setVisible(false)
    --     open:setVisible(true)
    --     self:getAward()
    -- end)

    -- self:OnClick(close2, function(sender)
    --     local open = self:getUnitByPointNameAndUnitName("pot2"  , "open")
    --     close2:setVisible(false)
    --     open:setVisible(true)
    --     self:getAward()
    -- end)

    -- self:OnClick(close3, function(sender)
    --     local open = self:getUnitByPointNameAndUnitName("pot3"  , "open")
    --     close3:setVisible(false)
    --     open:setVisible(true)
    --     self:getAward()
    -- end)

    -- self:OnClick(close4, function(sender)
    --     local open = self:getUnitByPointNameAndUnitName("pot4"  , "open")
    --     close4:setVisible(false)
    --     open:setVisible(true)
    --     self:getAward()
    -- end)
    
    -- self:OnClick(close5, function(sender)
    --     local open = self:getUnitByPointNameAndUnitName("pot5"  , "open")
    --     close5:setVisible(false)
    --     open:setVisible(true)
    --     self:getAward()
    -- end)

end

function PotView:getAward( )
    -- self.clickArea:setVisible(true)
    self.BG:setTouchEnabled(true)
    self.service:getAward(param1,function(data)
        qy.tank.command.AwardCommand:add(data.award)
        qy.tank.command.AwardCommand:show(data.award)
        self.isRuning = false
        self:updataAll()
    end)
end

function PotView:updataAll()
    local  status = self.model.status
    if status == nil then return end
    self.chicken:setVisible(false)
    self.energy:setVisible(false)
    self.pots:setVisible(false)
    -- self.say1:setVisible(false)
    -- self.say2:setVisible(false)
    -- self.say3:setVisible(false)
    -- self.say4:setVisible(false)
    -- self.say5:setVisible(false)
    self.tips1:setVisible(false)
    -- self.clickArea:setVisible(false)
    self.BG:setTouchEnabled(false)
    if status == 0 then
        self.sayContent1:setString(self.model.says["1"])
        -- self.clickArea:setVisible(true)
        self.BG:setTouchEnabled(true)
    elseif status == 1 then 
        self.chicken:setVisible(true)
        self.energy:setVisible(true)
        self.sayContent1:setString(self.model.says["1"])
        self.tips1:setVisible(true)
        self:runChicken(true)
    elseif status == 2 then
        self:runChicken(false)
        -- self.clickArea:setVisible(true)
        self.BG:setTouchEnabled(true)
        -- self.say2:setVisible(true)
        self.sayContent1:setString(self.model.says["2"])
        self.pots:setVisible(true)
        if self.potPrepareComplete == false then 
            self:preparePot()
        end
        
    elseif status == 3 then 
        -- self.say5:setVisible(true)
        self.sayContent1:setString(self.model.says["5"])
        -- self.clickArea:setVisible(true)
        self.BG:setTouchEnabled(true)
        self.pots:setVisible(true)
        -- self:runPots(true)
    end

    local size = self.sayContent1:getContentSize()
    self.say1:setContentSize(size.width + 40, size.height + 60)
end

function PotView:preparePot()
    
    -- local open = nil
    -- local close = nil
    -- local itemContainer = nil
    -- local list = self.model:getAwardList()
    -- local awardItem = nil
    self.startPosArr  = {}
    
    for i=1, 5 do
        -- open = self:getUnitByPointNameAndUnitName("pot"..i  , "open")
        -- close = self:getUnitByPointNameAndUnitName("pot"..i  , "close")
        -- open:setVisible(true)
        -- close:setVisible(false)
        -- itemContainer = self:getUnitByPointNameAndUnitName("pot"..i  , "itemContainer")
        -- awardItem = qy.tank.view.common.AwardItem.createAwardView(list[i] , 1 , 1)
        -- itemContainer:removeAllChildren(true)
        -- itemContainer:addChild(awardItem)
        -- itemContainer:setVisible(false)
        -- local pot =  self:findViewByName("pot"..i)
        local potX = self["pot" .. i]:getPositionX()
        local potY = self["pot" .. i]:getPositionY()
        self.startPosArr[i] = cc.p(potX , potY)
        self["pot" .. i]:setPosition(5.50,0)
    end

end

-- function PotView:removeAllAwardItem()
--     for i=1,5 do
--         local itemContainer = self:getUnitByPointNameAndUnitName("pot"..i  , "itemContainer")
--         itemContainer:removeAllChildren(true)
--     end
-- end

-- --在资源中获取某一pot中某一资源名称。
-- function PotView:getUnitByPointNameAndUnitName(potName , unitName)
--     local pot = self:findViewByName(potName)
--     if pot==nil then
--         return nil
--     end

--     local unit = nil
--         pot:enumerateChildren("//" .. unitName, function(ret)
--             unit = ret
--         end)
--     return unit
-- end
-- －－－－－－－－－－－－ 各种动作 －－－－－－－

-- 鸡动
function PotView:runChicken(run)
    if not run then
        self.chicken:stopAllActions() 
        return
    end

    local func1 = cc.EaseSineInOut:create(cc.MoveTo:create(1,cc.p(6.50,-160.50)))
    local func2 = cc.EaseSineInOut:create(cc.MoveTo:create(1,cc.p(6.50,-180.50)))

    local seq = cc.Sequence:create(func1, func2)
    local forever = cc.RepeatForever:create(seq)

    self.chicken:runAction(forever) 

    -- function moveTop()
    --     local ease = cc.EaseSineInOut:create(cc.MoveTo:create(1,cc.p(6.50,-160.50)))
    --     local seq = cc.Sequence:create(ease,cc.CallFunc:create(function()
    --         moveDown()
    --     end))
    --     self.chicken:runAction(seq) 
    -- end

    -- function moveDown( )
    --     local ease = cc.EaseSineInOut:create(cc.MoveTo:create(1,cc.p(6.50,-180.50)))
    --     local seq = cc.Sequence:create(ease,cc.CallFunc:create(function()
    --         moveTop()
    --     end))
    --     self.chicken:runAction(seq) 
    -- end
    
    -- moveTop()
end

--发盘子
function PotView:potStart()
    local arr = self.startPosArr
    local i = 0
    local runTime = 0.1
    function  playStart()
        self.isRuning = true
        i = i+1
         if i >5 then 
            for k=1,5 do
                self["pot" .. k].itemContainer:setVisible(true)
                -- local itemContainer = self:getUnitByPointNameAndUnitName("pot"..k  , "itemContainer")
                -- itemContainer:setVisible(true)
            end
            self.potPrepareComplete = true
            self.isRuning = false
        else       
            -- local pot  =  self:findViewByName("pot"..i)   
            local p =  arr[i]
            local ease = cc.EaseSineInOut:create(cc.MoveTo:create(runTime,p))
            local seq = cc.Sequence:create(ease,cc.CallFunc:create(function()
                    playStart()                          
            end))
            self["pot" .. i]:runAction(seq) 
        end
          
    end
    playStart()
end

--锅动
function PotView:runPots(run)
    -- local arr = self.startPosArr
    -- local arr1 = {}
    -- while #arr1<5 do 
    --     local index = math.ceil(#arr*math.random())
    --     local myIndex = #arr1+1
    --     if arr[index]~=nil then
    --         arr1[myIndex] = arr[index]
    --         arr[index] = nil
    --     end
    -- end
    -- self.startPosArr = arr1
    
    for i=1,5 do
        self:runSinglePot(run  , i)
    end
end

function PotView:runSinglePot(run , index)
    
    -- local potItem = self:getUnitByPointNameAndUnitName("pot"..index  , "itemContainer")
    local potItem = self["pot" .. index].itemContainer

    if not run then
        potItem:stopAllActions()
        self["pot" .. index]:stopAllActions()
        return
    end

    function moveIn()
        self.isRuning = true
        potItem:setScale(1)
        potItem:setPosition(0,140.5)
        local runTime = 0.5
        local fadeIn = cc.FadeIn:create(runTime) -- 渐入
        local rotate = cc.RotateBy:create(runTime,720) -- 旋转
        local scale = cc.ScaleTo:create(runTime,0.1) --  缩放

        local bezier ={
            cc.p(0,140.50),--起始点
            cc.p(-250,30),--控制点
            cc.p(0,0)--结束点
        }
        local bezierTo = cc.BezierTo:create(runTime, bezier)
        local spawn = cc.Spawn:create(fadeIn , rotate , scale , bezierTo)
        local seq = cc.Sequence:create(spawn,cc.CallFunc:create(function()
            -- local open = self:getUnitByPointNameAndUnitName("pot"..index  , "open")
            -- local close = self:getUnitByPointNameAndUnitName("pot"..index  , "close")
            self["pot" .. index].open:setVisible(false)
            self["pot" .. index].close:setVisible(true)
            playPotAnnimation(index)
        end))
        potItem:runAction(seq)

    end

    function playPotAnnimation(potIndex)
        -- local pot =  self:findViewByName("pot"..potIndex)
        local pot = self["pot" .. potIndex]
        local potX = pot:getPositionX()
        local potY = pot:getPositionY()
        local p = self.startPosArr[potIndex]
        local runTime = 0.5
        local bezier ={
            p,--起始点
            cc.p(5.50,200),--控制点
            p--结束点
        }
        local bezierTo = cc.BezierTo:create(runTime, bezier) 
        local seq = cc.Sequence:create(bezierTo,cc.CallFunc:create(function()
            local ease = cc.EaseSineInOut:create(cc.MoveTo:create(runTime,cc.p(potX,potY)))
            local seq1 = cc.Sequence:create(ease,cc.CallFunc:create(function()
                 self:PotAnnimationDone()
                 
            end))
            pot:runAction(seq1)    
        end))
        pot:runAction(seq)
    end

    moveIn()
end

function PotView:PotAnnimationDone()
    self.isRuning = false
    -- self:removeAllAwardItem()
    self.potAnnimationDone = true
    -- self.clickArea:setVisible(false)
    -- self.clickArea:setVisible(false)
end
function PotView:onExit()
    -- cc.Director:getInstance():getTextureCache():removeAllTextures()
end
	

return PotView