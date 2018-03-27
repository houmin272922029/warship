

local MainView = qy.class("MainView", qy.tank.view.BaseDialog, "lucky_turntable/ui/MainView")

local model = qy.tank.model.LuckyTurntableModel
local service = qy.tank.service.LuckyTurntableService
local StorageModel = qy.tank.model.StorageModel
local Position = {
    ["1"] = cc.p(443,446),
    ["2"] = cc.p(517,372),
    ["3"] = cc.p(517,291),
    ["4"] = cc.p(440,225),
    ["5"] = cc.p(360,217),
    ["6"] = cc.p(284,291),
    ["7"] = cc.p(284,372),
    ["8"] = cc.p(360,447),
}

function MainView:ctor(delegate)
    MainView.super.ctor(self)
	self:InjectView("closeBt")
	self:InjectView("opentenBt")
    self:InjectView("num1")
    self:InjectView("num2")
    self:InjectView("beginBt")
    self:InjectView("jiantou")
    self:InjectView("idimg")
    self:InjectView("bg")
    self:InjectView("needidimg")
    self.jiantou:setLocalZOrder(2)
    self.beginBt:setLocalZOrder(3)
	self:OnClick("closeBt", function(sender)
        if self.touchflag == 1 then
            self:removeSelf()
        end 
    end)
    self:OnClick("opentenBt", function(sender)
        if self.touchflag == 1 then
            if self.Num1 <= 0 then
                qy.hint:show(qy.Config.props[tostring(model.id)].name.."不足")
                return
            end
            if self.Num2 <= 0 then
                qy.hint:show(qy.Config.props[tostring(model.need_id)].name.."不足")
                return
            end 
            service:openTenAward(model.id,function ( )
                self:updateziyuan()
            end)
        end
    end)
    self:OnClick("beginBt", function(sender)
        if self.touchflag == 1 then
            if self.Num1 <= 0 then
                qy.hint:show(qy.Config.props[tostring(model.id)].name.."不足")
                return
            end
            if self.Num2 <= 0 then
                qy.hint:show(qy.Config.props[tostring(model.need_id)].name.."不足")
                return
            end 
            service:openAward(model.id,function ( datas )
                self.Num1 = self.Num1 - 1 
                self.Num2 = self.Num2 - 1
                self:update()
                local x = 1
                if datas.truntable[1]%8 == 0 then
                    x = 8
                else
                    x = datas.truntable[1]%8
                end
                self:showeffet(x)
                self.award = datas.award
            end)
        end
    end,{["isScale"] = false})
    self.Num1 = StorageModel:getPropNumByID(model.id)
    self.Num2 = StorageModel:getPropNumByID(model.need_id)
    self.idimg:loadTexture("props/"..model.id..".png",0)
    self.needidimg:loadTexture("props/"..model.need_id..".png",0)
    self.touchflag = 1
    self.award = {}
    self:update()
    self:initAward()
  
end
function MainView:updateziyuan(  )
    if self.Num1 >= 10 and self.Num2 >= 10 then
        self.Num1 = self.Num1 - 10
        self.Num2 = self.Num2 - 10
    elseif self.Num1 < 10 and self.Num2 >= 10 then
        self.Num2 = self.Num2 - self.Num1
        self.Num1 = 0
    elseif self.Num1 >= 10 and self.Num2 < 10 then
        self.Num1 = self.Num1 - self.Num2
        self.Num2 = 0
    else
        if self.Num1 <= self.Num2 then
            self.Num2 = self.Num2 - self.Num1
            self.Num1 = 0
        else
            self.Num1 = self.Num1 - self.Num2
            self.Num2 = 0
        end
    end
    self:update()
end
function MainView:initAward(  )
    local data = model.list
    for i=1,8 do
        local item = qy.tank.view.common.AwardItem.createAwardView(data[i].award[1] ,1)
        self.bg:addChild(item)
        item:setLocalZOrder(1)
        item:setPosition(Position[tostring(i)])
        item:setScale(0.6)
        -- item:setRotation(22.5 *i)
        item.name:setVisible(false)
    end
    
end
function MainView:showeffet( num )
    self.touchflag = 0
    local action = cc.RotateTo:create(2.0, 360*5)
    local action1 = cc.RotateTo:create(0.8, 360*2)
    local delay = cc.DelayTime:create(1)
    local actionback = function (  )
        self.touchflag = 1
        qy.tank.command.AwardCommand:add(self.award)
        qy.tank.command.AwardCommand:show(self.award)
    end
    local Rotatenum = math.random((num-1)* 45+5,num*45-5)
    print("旋转的角度",Rotatenum)
    local action2 = cc.RotateTo:create(Rotatenum*0.3/45, 360+Rotatenum) 
    self.jiantou:runAction(cc.Sequence:create(action,action1,action2,delay,cc.CallFunc:create(actionback)))
end
function MainView:update(  )
    self.num1:setString(self.Num1 < 0 and 0 or self.Num1)
    self.num2:setString(self.Num2 < 0 and 0 or self.Num2)
end
function MainView:onEnter()
     
end

function MainView:onExit()
end


return MainView
