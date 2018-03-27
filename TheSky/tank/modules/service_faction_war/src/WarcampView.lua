-- 

local WarcampView = qy.class("WarcampView", qy.tank.view.BaseView, "service_faction_war/ui/WarcampView")

    -- 移动动作
    local NOT_MOVE = 0   -- 不移动
    local MOVE_RIGHT = 1 -- 右移
    local MOVE_LEFT = 2  -- 左移
    -- 移动后的位置
    local POS_LEFT = 1  -- 左
    local POS_MID = 2   -- 中
    local POS_RIGHT = 3 -- 右
    local icontexttype = {["1"]="专政，暴力，绝对忠诚。自由意志是人类最大的谎言，只有绝对的统治，才是走向未来的唯一标准！",["2"]="世间平衡皆由我等掌控，轴心代表邪恶，自由代表谎言，只有绝对的平衡才是这乱世的生存之道！",["3"]="消灭轴心暴政，自由属于同盟！为了自由，同盟会不惜一切代价，哪怕是失去生命！"}

local model = qy.tank.model.ServerFactionModel
local service = qy.tank.service.ServerFactionService

function WarcampView:ctor(delegate)
    WarcampView.super.ctor(self)

    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "service_faction_war/res/title.png", 
        showHome = false,
        ["onExit"] = function()
            delegate:finish()
        end
    })
    self:addChild(style)
    self.delegate = delegate

    for i=1,3 do
        self:InjectView("icon_"..i)
        self:InjectView("iconimg"..i)
        self["icon_"..i].id = i
        -- arrow_ 2 个
        self:InjectView("arrow_"..i)
        self:InjectView("tuijian"..i)
    end
    self.tuijian1:setVisible(false)
    self.tuijian3:setVisible(false)
    self:InjectView("icontext")
    self:InjectView("move_bg")
    self:InjectView("Up_btn")
    self:InjectView("Sprite_2")
    self:InjectView("Button_10")

    self:OnClick("Up_btn",function (  )
        service:chooseCamp(self.slectid,function (  )
            delegate:showMianView()
        end)
    end)

    self:OnClick("arrow_1",function (  )
        self:toAction(MOVE_LEFT)
    end)

    self:OnClick("arrow_2",function (  )
        self:toAction(MOVE_RIGHT)
    end)
    self.big = self.icon_3:getPositionX() - self.icon_1:getPositionX()
    self.small = self.icon_3:getPositionX() - self.icon_2:getPositionX()
    self.position1 = {self.icon_1:getPositionX(),self.icon_1:getPositionY()}
    self.position2 = {self.icon_2:getPositionX(),self.icon_2:getPositionY()}
    self.position3 = {self.icon_3:getPositionX(),self.icon_3:getPositionY()}
   
    self.tuijianid = model.proposalCamp
    self.slectid = self.tuijianid
    if self.tuijianid == 1 then
        self.imageList = {"b","a","c"}
    elseif self.tuijianid == 2 then
        self.imageList = {"a","b","c"}
    else
        self.imageList = {"a","c","b"}
    end
    self.iconList = {self.icon_1,self.icon_2,self.icon_3}
    
    self:__touchLogic()
    self:update_icon1()
    self:update_icon2()
    self:update_icon3()
    self.icontext:setString(icontexttype[tostring(self.slectid)])
    fragmes = display.newFrames("service_faction_war/res/"..self.imageList[2].."%d.png",1,6)
    local animation = display.newAnimation(fragmes,0.1)
    self.legionSignAction = self.icon_2:playAnimationForever(animation)
end

function WarcampView:__touchLogic()
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    local function onTouchBegan(touch, event)
        self.began_p = cc.Director:getInstance():convertToGL(touch:getLocationInView())
        return true
    end

    local function onTouchEnded(touch, event)
        self.end_p = cc.Director:getInstance():convertToGL(touch:getLocationInView())
        local _action =  self:getAction(self.began_p, self.end_p)
        self:toAction(_action)

        return true
    end

    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener,self)
end

function WarcampView:getAction(_p1, _p2)
    
    if _p2.x - _p1.x > 50 then
        print("向右移动1")
        -- 向左移 2
        return MOVE_RIGHT
    elseif _p1.x - _p2.x > 50 then
        print("向左移动1")
        -- 向右移v1
        return MOVE_LEFT
    else
        --不移动v 0
        return NOT_MOVE
    end
end

function WarcampView:toAction(_action)
    if _action == 0 then
        return
    end
    
    for i=1,3 do
        self.iconList[i]:stopAllActions()        
    end

    local list = {}
    local imageList = {}

    -- list 1,2,3 表示 self.iconList 的下标
    -- anim 的第二个参数 1，2，3 表示左中右
    if _action == MOVE_LEFT then --1
    print("向左移动2")

        list[3] = self.iconList[1]
        self:anim(list[3], POS_RIGHT,_action)
        list[1] = self.iconList[2]
        self:anim(list[1], POS_LEFT,_action)
        list[2] = self.iconList[3]
        self:anim(list[2], POS_MID,_action)
    elseif _action == MOVE_RIGHT then --2
        print("向右移动2")
        list[2] = self.iconList[1]
        self:anim(list[2], POS_MID,_action)
        list[3] = self.iconList[2]
        self:anim(list[3], POS_RIGHT,_action)
        list[1] = self.iconList[3]
        self:anim(list[1], POS_LEFT,_action)
    end
    if _action > NOT_MOVE then
        self.iconList = list
    end
    
    local temp 
    if self.iconList[2] == self.icon_1 then
        temp = self.imageList[1]
    elseif self.iconList[2] == self.icon_2 then
        temp = self.imageList[2]
    else
        temp = self.imageList[3]
    end 
    if temp =="a" then
        self.slectid = 1
    elseif temp == "b" then
        self.slectid = 2
    else
        self.slectid = 3
    end
    self.icontext:setString(icontexttype[tostring(self.slectid)])
    -- self.tuijian:setVisible(self.slectid == self.tuijianid)
    
end

function WarcampView:anim(ui,id,_action)
    self:operaArrow(false)
     
if _action == MOVE_RIGHT then --优异
    if id > 1 then
        if id == 2 then
            scale = cc.ScaleTo:create(0.5,1.25)
            fade = cc.FadeTo:create(0.5,1000)
            move = cc.MoveTo:create(0.5,cc.p(self.position2[1],self.position2[2]))
        elseif id == 3 then
            scale = cc.ScaleTo:create(0.5,1)
            fade = cc.FadeTo:create(0.5,100)
            move = cc.MoveTo:create(0.5,cc.p(self.position3[1],self.position3[2]))
        end
        
        local spawn1 = cc.Spawn:create(move,fade)
        local spawn2 = cc.Spawn:create(scale,spawn1)

        local callFunc = cc.CallFunc:create(function ()
            self:operaArrow(true)
            self:showDongHua(self.iconList[2])

        end)
        ui:runAction(cc.Sequence:create(spawn2, callFunc))
    else
        local move = cc.MoveTo:create(0.5,cc.p(self.position1[1],self.position1[2]))
        local fade = cc.FadeTo:create(0.5,100)
        local scale = cc.ScaleTo:create(0.5,1)
        local spawn1 = cc.Spawn:create(move,fade)
        local spawn2 = cc.Spawn:create(scale,spawn1)
       
        local callFunc = cc.CallFunc:create(function ()
            self:operaArrow(true)
            self:showDongHua(self.iconList[2])
        end)
        ui:runAction(cc.Sequence:create(spawn2, callFunc))
    end
else
    if id <3 then
        if id == 1 then
            scale = cc.ScaleTo:create(0.5,1)
            fade = cc.FadeTo:create(0.5,100)
            move = cc.MoveTo:create(0.5,cc.p(self.position1[1],self.position1[2]))      
        elseif id == 2 then
            scale = cc.ScaleTo:create(0.5,1.25)
            fade = cc.FadeTo:create(0.5,1000)
            move = cc.MoveTo:create(0.5,cc.p(self.position2[1],self.position2[2]))  
        end            
        local spawn1 = cc.Spawn:create(move,fade)
        local spawn2 = cc.Spawn:create(scale,spawn1)
       
        local callFunc = cc.CallFunc:create(function ()
            self:operaArrow(true)
            self:showDongHua(self.iconList[2])
        end)
        ui:runAction(cc.Sequence:create(spawn2, callFunc))
    else
        local move = cc.MoveTo:create(0.5,cc.p(self.position3[1],self.position3[2]))  
        local fade = cc.FadeTo:create(0.5,100)
        local scale = cc.ScaleTo:create(0.5,1)
        local spawn1 = cc.Spawn:create(move,fade)
        local spawn2 = cc.Spawn:create(scale,spawn1)
       
        local callFunc = cc.CallFunc:create(function ()
            self:operaArrow(true)
            self:showDongHua(self.iconList[2])
        end)
        ui:runAction(cc.Sequence:create(spawn2, callFunc))
    end
end
    
end

function WarcampView:operaArrow(is_true)
    self.arrow_1:setVisible(is_true)
    self.arrow_2:setVisible(is_true)
end

function WarcampView:showDongHua(ui)
    if ui == self.icon_1 then
        self:update_icon2()
        self:update_icon3()
        fragmes = display.newFrames("service_faction_war/res/"..self.imageList[1].."%d.png",1,6)
    elseif ui == self.icon_2 then
        self:update_icon1()
        self:update_icon3()
        fragmes = display.newFrames("service_faction_war/res/"..self.imageList[2].."%d.png",1,6)
    elseif ui == self.icon_3 then
        self:update_icon1()
        self:update_icon2()
        fragmes = display.newFrames("service_faction_war/res/"..self.imageList[3].."%d.png",1,6)
    end
    local animation = display.newAnimation(fragmes,0.1)
    self.legionSignAction = ui:playAnimationForever(animation)
end

function WarcampView:update_icon1(  )
    local sprite1 = cc.Sprite:createWithSpriteFrameName("service_faction_war/res/"..self.imageList[1].."1"..".png")
    self.icon_1:setSpriteFrame(sprite1:getSpriteFrame()) 
    self.iconimg1:loadTexture("service_faction_war/res/"..self.imageList[1]..".png",1) 
end

function WarcampView:update_icon2(  )   
    local sprite2 = cc.Sprite:createWithSpriteFrameName("service_faction_war/res/"..self.imageList[2].."1"..".png")
    self.icon_2:setSpriteFrame(sprite2:getSpriteFrame())
    self.iconimg2:loadTexture("service_faction_war/res/"..self.imageList[2]..".png",1) 
end

function WarcampView:update_icon3(  ) 
    local sprite3 = cc.Sprite:createWithSpriteFrameName("service_faction_war/res/"..self.imageList[3].."1"..".png")
    self.icon_3:setSpriteFrame(sprite3:getSpriteFrame())
    self.iconimg3:loadTexture("service_faction_war/res/"..self.imageList[3]..".png",1) 
end


return WarcampView
