

local MedalCell = qy.class("MedalCell", qy.tank.view.BaseView, "medal/ui/MedalCell")

local service = qy.tank.service.MedalService
local garageModel = qy.tank.model.GarageModel
local  model = qy.tank.model.MedalModel
local StorageModel = qy.tank.model.StorageModel
local userInfoModel = qy.tank.model.UserInfoModel

function MedalCell:ctor(delegate)
    MedalCell.super.ctor(self)
    self.delegate = delegate
    self:InjectView("bg")
    self:InjectView("huangbian")
    self:InjectView("title")
    self:OnClickForBuilding1("bg",function ( sender )
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
    self.data = model.localmedalcfg
end

function MedalCell:render(_idx,index)
	self.index = _idx
	if _idx == index then
		self.huangbian:setVisible(true)
	else
		self.huangbian:setVisible(false)
	end
	self.title:setString(self.data[tostring(_idx)].name)
	local staly = self.data[tostring(_idx)].medal_colour
	local color = qy.tank.utils.ColorMapUtil.qualityMapColorFor3b(staly)
	self.title:setColor(color)

end
function MedalCell:onEnter()
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

function MedalCell:onExit()
    self:getEventDispatcher():removeEventListener(self.listener)
end


return MedalCell
