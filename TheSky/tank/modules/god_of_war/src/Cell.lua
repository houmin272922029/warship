local Cell = qy.class("Cell", qy.tank.view.BaseView, "god_of_war/ui/Cell")

local model = qy.tank.model.GodWarModel
function Cell:ctor(delegate)
   	Cell.super.ctor(self)
   	cc.SpriteFrameCache:getInstance():addSpriteFrames("god_of_war/res/godwar.plist")
   	self:InjectView("bg")
    self:InjectView("img")
    self:InjectView("bt")
 	self:OnClick("bt",function ( sender ) 
        local seq = cc.Sequence:create(delay , cc.CallFunc:create(function()
            if self.touchType == true  then
            	local delay = cc.DelayTime:create(0.3)
 				delegate.callback(self.index)
        	else
         		self.touchType = false
        	end
        end))
        self:runAction(seq)
    end)
    self.bt:setSwallowTouches(false)


end
function Cell:render(_idx ,slectid)
	self.index = _idx
	
	if _idx == slectid then
		self.bg:setSpriteFrame("god_of_war/res/cellbg1.png")
		local png = "god_of_war/res/a".._idx..".png"
		self.img:loadTexture(png,1)
	else
		self.bg:setSpriteFrame("god_of_war/res/cellbg2.png")
		local png = "god_of_war/res/s".._idx..".png"
		self.img:loadTexture(png,1)
	end
end
function Cell:onEnter()

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

function Cell:onExit()
	self:getEventDispatcher():removeEventListener(self.listener)
end



return Cell