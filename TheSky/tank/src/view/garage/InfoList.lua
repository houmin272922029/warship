--[[
	坦克信息列表通用组件
	Author: Aaron Wei
	Date: 2015-11-09 11:19:09
]]

local InfoList = qy.class("InfoList", qy.tank.view.BaseView, "view/garage/InfoList")

local model = qy.tank.model.AdvanceModel
function InfoList:ctor(data, data2)
    self:InjectView("Name")
    self:InjectView("Num1")
    self:InjectView("Num2")
    self:InjectView("jiantou")

    self.talentMap = {qy.TextUtil:substitute(40024),qy.TextUtil:substitute(40025),qy.TextUtil:substitute(40026),qy.TextUtil:substitute(40027),qy.TextUtil:substitute(40028),qy.TextUtil:substitute(40029),qy.TextUtil:substitute(40030)} 

    self.Name:setString(self.talentMap[tonumber(data2.name)])
    self.Num1:setString(data and data.level or qy.TextUtil:substitute(40031))
    self.Num2:setString(data2 and data2.level or qy.TextUtil:substitute(40031))
    self:addJiantouAnimate()
end

function InfoList:addJiantouAnimate()
    local item = self.jiantou
    local func0 = cc.DelayTime:create(0.2)

    local func1 = cc.CallFunc:create(function()
        item:setSpriteFrame("Resources/common/img/jiantou3.png")
    end)

    local func2 = cc.DelayTime:create(0.2)

    local func3 = cc.CallFunc:create(function()
        item:setSpriteFrame("Resources/common/img/jiantou4.png")
    end)

    local func4 = cc.DelayTime:create(0.2)

    local func5 = cc.CallFunc:create(function()
        item:setSpriteFrame("Resources/common/img/jiantou1.png")
    end)

    local func6 = cc.DelayTime:create(0.2)

    local func7 = cc.CallFunc:create(function()
        item:setSpriteFrame("Resources/common/img/jiantou2.png")
    end)

    local seq = cc.Sequence:create(func0, func1, func2, func3, func4, func5, func6, func7)

    item:runAction(cc.RepeatForever:create(seq))
end

return InfoList
