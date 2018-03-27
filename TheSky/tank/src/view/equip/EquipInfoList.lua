--[[--
    装备信息list
    Author: H.X.Sun
--]]--
local EquipInfoList = qy.class("EquipInfoList", qy.tank.view.BaseView)
local model = qy.tank.model.EquipModel

function EquipInfoList:ctor(delegate)
    EquipInfoList.super.ctor(self)
    self.size = delegate.size
    self:update(delegate.entity)
end

function EquipInfoList:update(entity)
    if not tolua.cast(self.dynamic_c,"cc.Node") then
		self.dynamic_c = cc.Layer:create()
		self.dynamic_c:setAnchorPoint(0,1)
		self.dynamic_c:setTouchEnabled(false)
	end
    local h = 0

    if entity:hasClear() then
        if not tolua.cast(self.clear,"cc.Node") then
            self.clear =  qy.tank.view.equip.Clearlist.new({["entity"] = entity})
            self.dynamic_c:addChild(self.clear)
        else
            self.clear:getParent():removeChild(self.clear)
            self.clear =  qy.tank.view.equip.Clearlist.new({["entity"] = entity})
            self.dynamic_c:addChild(self.clear)
        end
        self.clear:setPosition(0,h)
        h = h + self.clear:getHeight()
    elseif tolua.cast(self.clear,"cc.Node") then
        self.clear:getParent():removeChild(self.clear)
        self.clear = nil
    end
    if entity:hasClear() then
        if not tolua.cast(self.Cleartitle,"cc.Node") then
            self.Cleartitle =  qy.tank.view.equip.ClearInfoCell.new({["entity"] = entity})
            self.dynamic_c:addChild(self.Cleartitle)
        end
        self.Cleartitle:setPosition(0,h)
        h = h + self.Cleartitle:getHeight()
    elseif tolua.cast(self.Cleartitle,"cc.Node") then
        self.Cleartitle:getParent():removeChild(self.Cleartitle)
        self.Cleartitle = nil
    end
    if entity:getQuality() > 4 then
        if not tolua.cast(self.advance,"cc.Node") then
            self.advance = qy.tank.view.equip.AdvanceCell.new({["entity"] = entity})
            self.dynamic_c:addChild(self.advance)        
        else
            self.advance:update(entity)
        end
        self.advance:setPosition(0,h)
        h = h + self.advance:getHeight()
    elseif tolua.cast(self.advance,"cc.Node") then
        self.advance:getParent():removeChild(self.advance)
        self.advance = nil
    end


    if entity:hasReform() then
        if not tolua.cast(self.reform,"cc.Node") then
            self.reform =  qy.tank.view.equip.ReformCell.new({["entity"] = entity})
            self.dynamic_c:addChild(self.reform)
        else
            self.reform:update(entity)
        end
        self.reform:setPosition(0,h)
        h = h + self.reform:getHeight()
    elseif tolua.cast(self.reform,"cc.Node") then
        self.reform:getParent():removeChild(self.reform)
        self.reform = nil
    end

    if entity:hasAlloy() then
        if not tolua.cast(self.alloyList,"cc.Node") then
            self.alloyList =  qy.tank.view.equip.AlloyCell.new({["entity"] = entity})
            self.dynamic_c:addChild(self.alloyList)
        else
            self.alloyList:update(entity)
        end
        self.alloyList:setPosition(0,h - self.alloyList:getRemainHeight())
        h = h + self.alloyList:getHeight()
    elseif tolua.cast(self.alloyList,"cc.Node") then
        self.alloyList:getParent():removeChild(self.alloyList)
        self.alloyList = nil
    end

    if entity:getSuitID() ~= 0 and model:hasSixProper(entity:getSuitID()) then
        if not tolua.cast(self.suitCell2,"cc.Node") then
            self.suitCell2 =  qy.tank.view.equip.SuitCell2.new({["entity"] = entity})
            self.dynamic_c:addChild(self.suitCell2)
        else
            self.suitCell2:update(entity)
        end
        self.suitCell2:setPosition(0,h)
        h = h + self.suitCell2:getHeight()
    elseif tolua.cast(self.suitCell2,"cc.Node") then
        self.suitCell2:getParent():removeChild(self.suitCell2)
        self.suitCell2 = nil
    end

    if entity:getSuitID() ~= 0 then
        if not tolua.cast(self.suitList,"cc.Node") then
            self.suitList =  qy.tank.view.equip.SuitCell.new({["entity"] = entity})
            self.dynamic_c:addChild(self.suitList)
        else
            self.suitList:update(entity)
        end
        self.suitList:setPosition(0,h)
        h = h + self.suitList:getHeight()
    elseif tolua.cast(self.suitList,"cc.Node") then
        self.suitList:getParent():removeChild(self.suitList)
        self.suitList = nil
    end

    if not tolua.cast(self.baseInfo,"cc.Node") then
        self.baseInfo =  qy.tank.view.equip.EquipBaseInfo.new({["entity"] = entity})
        self.dynamic_c:addChild(self.baseInfo)
    else
        self.baseInfo:update(entity)
    end
    self.baseInfo:setPosition(0,h + self.baseInfo:getHeight())
    h = h + self.baseInfo:getHeight()

    self.dynamic_c:setContentSize(480,h)
	self.dynamic_c:setPosition(0,self.size.height - h)

    if not tolua.cast(self.infoList,"cc.Node") then
        self.infoList = cc.ScrollView:create()
        self:addChild(self.infoList)
        self.infoList:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        self.infoList:ignoreAnchorPointForPosition(false)
        self.infoList:setClippingToBounds(true)
        self.infoList:setBounceable(true)
        self.infoList:setAnchorPoint(0,1)
        self.infoList:setPosition(0,0)
        self.infoList:setViewSize(self.size)
        self.infoList:setContainer(self.dynamic_c)
    end
end

function EquipInfoList:showStrengEffert()
    if tolua.cast(self.baseInfo,"cc.Node") then
        self.baseInfo:showStrengEffert()
    end
end

return EquipInfoList
