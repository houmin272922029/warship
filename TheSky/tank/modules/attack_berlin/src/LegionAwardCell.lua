local LegionAwardCell = qy.class("LegionAwardCell", qy.tank.view.BaseView, "attack_berlin.ui.LegionAwardCell")


local model = qy.tank.model.AttackBerlinModel
local service = qy.tank.service.AttackBerlinService
function LegionAwardCell:ctor(delegate)
   	LegionAwardCell.super.ctor(self)
    for i=1,2 do
        self:InjectView("nums"..i)
        self:InjectView("awardbg"..i)
        self:InjectView("bt"..i)
        self:InjectView("bg"..i)
        self:InjectView("slect"..i)
    end
    -- self:OnClick("bg1", function()
      
    -- end,{["isScale"] = false})
    -- self:OnClick("bg2", function()
    --     local aa = (self.index-1)*2 +2
    --     service:checkSendMember(function (  )
    --         require("attack_berlin.src.RecordDialog").new({
    --         ["types"] = 3,
    --         ["award_id"] = self.data[aa].award_id,
    --         }):show()
    --     end)
    -- end,{["isScale"] = false})
    self:OnClickForBuilding1("bt1", function()
        local seq = cc.Sequence:create(delay , cc.CallFunc:create(function()
            if self.touchType == true and model.is_leader == 1 then
                local delay = cc.DelayTime:create(0.3)
                local aa = (self.index-1)*2 +1
                -- service:checkSendMember(function (  )
                --     require("attack_berlin.src.RecordDialog").new({
                --         ["types"] = 3,
                --         ["award_id"] = self.data[aa].award_id,
                --     }):show()
                -- end)
                model.slectid = aa
                delegate:callback()
            else
                self.touchType = false
            end
        end))
        self:runAction(seq)
    end,{["isScale"] = false})
    self:OnClickForBuilding1("bt2", function()
        local seq = cc.Sequence:create(delay , cc.CallFunc:create(function()
            if self.touchType == true and  model.is_leader == 1 then
                local delay = cc.DelayTime:create(0.3)
                local aa = (self.index-1)*2 +2
                -- service:checkSendMember(function (  )
                --     require("attack_berlin.src.RecordDialog").new({
                --         ["types"] = 3,
                --         ["award_id"] = self.data[aa].award_id,
                --     }):show()
                -- end)
                model.slectid = aa
                delegate:callback()
            else
                self.touchType = false
            end
        end))
        self:runAction(seq)
    end,{["isScale"] = false})
    self.delegate = delegate
    self.data = model.total_awards
   	self.totalnum = delegate.num
end

function LegionAwardCell:render(_idx,nums)
    self.awardbg1:removeAllChildren(true)
    self.awardbg2:removeAllChildren(true)
    self.slect1:setVisible(false)
    self.slect2:setVisible(false)
	self.index = _idx
    local data = model.total_awards
	local x = (_idx-1)*2 
	if _idx == self.totalnum then
		if nums == 0 then
			self.bg1:setVisible(true)
			self.bg2:setVisible(true)
            for i=1,2 do
                local award = self.data[x + i].award
                local item = qy.tank.view.common.AwardItem.createAwardView(award ,1,nil,false,function ( ... )
                    -- body
                end)
                self["awardbg"..i]:addChild(item)
                item:setPosition(45 , 45)
                item:setScale(0.75)
                item.name:setVisible(false)
                item.num:setVisible(false)
                item.fatherSprite:setSwallowTouches(false)
                self["nums"..i]:setString("X"..award.num)
                self["slect"..i]:setVisible(x + i == model.slectid and model.is_leader == 1)
            end

		else
			self.bg1:setVisible(true)
			self.bg2:setVisible(false)
            self.slect2:setVisible(false)
            local award = self.data[x + 1].award
            local item = qy.tank.view.common.AwardItem.createAwardView(award ,1,nil,false,function ( ... )
                    -- body
                end)
            self.awardbg1:addChild(item)
            item:setPosition(45 , 45)
            item:setScale(0.75)
            item.name:setVisible(false)
            item.num:setVisible(false)
            item.fatherSprite:setSwallowTouches(false)
            self["nums1"]:setString("X"..award.num)
            self["slect1"]:setVisible(x + 1 == model.slectid and model.is_leader == 1)
		end
	else
		for i=1,2 do
        	self["bg"..i]:setVisible(true)
            local award = self.data[x + i].award
            local item = qy.tank.view.common.AwardItem.createAwardView(award ,1,nil,false,function ( ... )
                    -- body
                end)
            self["awardbg"..i]:addChild(item)
            item:setPosition(45 , 45)
            item:setScale(0.75)
            item.name:setVisible(false)
            item.num:setVisible(false)
            item.fatherSprite:setSwallowTouches(false)
            self["nums"..i]:setString("X"..award.num)
            self["slect"..i]:setVisible(x + i == model.slectid and model.is_leader == 1)
    	end
	end
   
end
function LegionAwardCell:onEnter()

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
    self.eventDispatcher:addEventListenerWithSceneGraphPriority(self.listener,self.bt1)

end
function LegionAwardCell:onExit()
  self:getEventDispatcher():removeEventListener(self.listener)
end


return LegionAwardCell
