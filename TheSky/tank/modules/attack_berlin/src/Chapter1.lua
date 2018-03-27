local Chapter1 = qy.class("Chapter1", qy.tank.view.BaseView, "attack_berlin.ui.Chapter1")

local model = qy.tank.model.AttackBerlinModel
local service = qy.tank.service.AttackBerlinService

function Chapter1:ctor(delegate)
   	Chapter1.super.ctor(self)

    self:InjectView("bt")
   	self:InjectView("yigongpo")
   	self:InjectView("btimg")
   	self:InjectView("name")
    
    self:OnClickForBuilding1("bt", function()
        local seq = cc.Sequence:create(delay , cc.CallFunc:create(function()
            if self.touchType == true  then
                local delay = cc.DelayTime:create(0.3)
                service:inToGeneral(delegate.datas.id,function (  )
                    require("attack_berlin.src.SimpleDialog").new({
                    ["data"] = delegate.datas,
                    ["callback"] = function (  )
                        delegate:callback()
                    end
                }):show()
                end)
            else
                self.touchType = false
            end
        end))
        self:runAction(seq)
    end,{["isScale"] = false})
    self.data = delegate.datas
    self.bt:setSwallowTouches(false)
    self:update()
end



function Chapter1:update()
  	self.name:setString(self.data.name)
    local status = self.data.status-- model:getAttackstatus(self.data.id)
  	self.yigongpo:setVisible(status == 1)
    if status == 1 then
        qy.tank.utils.NodeUtil:darkNode(self.btimg,true)
    else
       qy.tank.utils.NodeUtil:darkNode(self.btimg,false)
    end
end
function Chapter1:onEnter()

  self.listener = cc.EventListenerTouchOneByOne:create()
    local function onTouchBegan(touch, event)
        self.touchPoint1 = touch:getLocation()
        self.touchType = true
        return true
    end

    local function onTouchMoved(touch, event)
        return true
    end
    local function onTouchCancel(touch, event)
        self.touchType = false
        return false
    end

    local function onTouchEnded(touch, event)
        self.touchPoint2 = touch:getLocation()
        if math.abs(self.touchPoint1.y - self.touchPoint2.y) <=5 then
            self.touchType = true
        else
            self.touchType = false
        end
        return true

    end

    self.listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
    self.listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED)
    self.listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED)
    self.eventDispatcher = self:getEventDispatcher()
    self.eventDispatcher:addEventListenerWithSceneGraphPriority(self.listener,self.bt)

end
function Chapter1:onExit()
  self:getEventDispatcher():removeEventListener(self.listener)
end

return Chapter1