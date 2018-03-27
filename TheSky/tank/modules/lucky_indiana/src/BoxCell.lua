local BoxCell = qy.class("BoxCell", qy.tank.view.BaseView, "lucky_indiana.ui.BoxCell")

local model = qy.tank.model.OperatingActivitiesModel

function BoxCell:ctor(delegate)
   	BoxCell.super.ctor(self)

   	self:InjectView("bg")
   	self:InjectView("num") 
    self.delegate = delegate
    self:OnClickForBuilding1("bg", function()
        local seq = cc.Sequence:create(delay , cc.CallFunc:create(function()
        	print("mmmmm",self.touchType)
            if self.touchType == true  then
                delegate.callback(true)
                local delay = cc.DelayTime:create(0.3)
         		local dialog = require("lucky_indiana.src.AnotherawardDialog").new({
                    ["type"] = delegate.type,
                    ["data"] = delegate.data,
                    ["index"] = self.index,
                    ["callback"] = delegate.callback,
                    ["callback2"] = delegate.callback2,
                    ["callback3"] = delegate.callback3
                    })
       			dialog:show(true)
        	else
         		self.touchType = false
        	end
        end))
        self:runAction(seq)
      
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = true})
    self.delegate =delegate
    self.type = delegate.type
    self.data = delegate.data


end

function BoxCell:setData(_idx)
    self.index = _idx
    self.num:setString(self.data[tostring(_idx)].num)
      local data = {}
    if self.type == 1 then
        data = model.fussionlist.list
    else
        data = model.fissionlist.list
    end
    if data[tostring(_idx)].status == 0 then
         self.bg:loadTexture("lucky_indiana/res/xiangzi.png",1)
         self.bg:setColor(cc.c4b(100,100,100,255))
    elseif data[tostring(_idx)].status == 1 then
        self.bg:loadTexture("lucky_indiana/res/xiangzi.png",1)
        self.bg:setColor(cc.c4b(255,255,255,255))
    else
        self.bg:loadTexture("lucky_indiana/res/xiangzi2.png",1)
        self.bg:setColor(cc.c4b(255,255,255,255))
    end
end
function BoxCell:onEnter()

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
    self.eventDispatcher:addEventListenerWithSceneGraphPriority(self.listener,self.bg)

end

function BoxCell:onExit()
	self:getEventDispatcher():removeEventListener(self.listener)
end


return BoxCell
