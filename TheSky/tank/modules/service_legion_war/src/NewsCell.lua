--[[
	跨服军团战
	Author: 
]]
-- 本军团的喵卡超人进攻了【s1】狂战军团的打死你个龟孙，获得军团战绩10000点。

-- 防守成功战报：本军团的xxx成功防守住【s2】xxx军团的xxx。
-- 防守失败战报：本军团的xxx不敌【s2】xxx军团的xxx的进攻。
-- 防守下阵战报：本军团的xxx被【s2】xxx军团的xxx的进攻，被迫下阵。


local NewsCell = qy.class("NewsCell", qy.tank.view.BaseView, "service_legion_war/ui/NewsCell")

local userModel = qy.tank.model.UserInfoModel
local service = qy.tank.service.ServiceLegionWarService
local model = qy.tank.model.ServiceLegionWarModel

function NewsCell:ctor(delegate)
    NewsCell.super.ctor(self)
    self:InjectView("Text")
    self.Text:setVisible(false)
    self:InjectView("bg")
    self:InjectView("CheckBt")
    self:OnClick("CheckBt",function()
        qy.tank.service.LegionWarService:showCombat(self.data[self.index].combat_id,function(data)
	        qy.tank.manager.ScenesManager:pushScene(qy.tank.view.scene.BattleScene.new())  
	    end)
    end)
    self._type = delegate.type--1为进攻战报
    self.data = delegate.data
end

function NewsCell:render(_idx)
	self.index = _idx
    if self._type == 1 then
        self:setData1(_idx)
    else
        self:setData2(_idx)
    end
    
   
end
function NewsCell:setData1(_idx)
    local userModel = qy.tank.model.UserInfoModel
    local kid = userModel.userInfoEntity.kid
    local data = self.data[_idx]
    if tolua.cast(self.richText,"cc.Node") then
        self.bg:removeChild(self.richText)
        self.richText = nil
    end
    self.richText = ccui.RichText:create()
    self.richText:setPosition(350, 60)
    self.richText:setAnchorPoint(0.5, 0.5)
    self.richText:ignoreContentAdaptWithSize(false)
    self.richText:setContentSize(cc.size(620, 80))

    local extratable1 = qy.TextUtil:StringSplit(data.def_server,"s",false,false)

    local info1 = self:makeText("本军团的", cc.c3b(255, 253, 221))
    local info2 = self:makeText(data.att_nickname, cc.c3b(238, 221, 86))
    local info3 = self:makeText("进攻了", cc.c3b(255, 253, 221))
    local info4 = self:makeText("【".. extratable1[1] .. "服 】", cc.c3b(22, 176, 245))
    local info5 = self:makeText(data.def_legion_name, cc.c3b(238, 221, 86))
    local info6 = self:makeText("军团的", cc.c3b(255, 253, 221))
    local info7 = self:makeText(data.def_nickname, cc.c3b(22, 176, 245))
    local info8 = self:makeText(",获得军团战绩", cc.c3b(255, 253, 221))
    local info9 = self:makeText(data.att_record, cc.c3b(238, 221, 86))
    local info10 = self:makeText("点,", cc.c3b(255, 253, 221))
    local info11 = self:makeText("消耗对手", cc.c3b(255, 253, 221))
    local info12 = self:makeText(data.def_ammo, cc.c3b(238, 221, 86))
    local info13 = self:makeText("点弹药储备.", cc.c3b(255, 253, 221))

    self.richText:pushBackElement(info1)
    self.richText:pushBackElement(info2)
    self.richText:pushBackElement(info3)
    self.richText:pushBackElement(info4)
    self.richText:pushBackElement(info5)
    self.richText:pushBackElement(info6)
    self.richText:pushBackElement(info7)
    self.richText:pushBackElement(info8)
    self.richText:pushBackElement(info9)
    self.richText:pushBackElement(info10)
    self.richText:pushBackElement(info11)
    self.richText:pushBackElement(info12)
    self.richText:pushBackElement(info13)

    self.bg:addChild(self.richText)
end
function NewsCell:setData2( _idx )
    local data = self.data[_idx]
    local isoff = data.is_off
    local iswin = data.is_win
    if tolua.cast(self.richText,"cc.Node") then
        self.bg:removeChild(self.richText)
        self.richText = nil
    end
    self.richText = ccui.RichText:create()
    self.richText:setPosition(350, 60)
    self.richText:setAnchorPoint(0.5, 0.5)
    self.richText:ignoreContentAdaptWithSize(false)
    self.richText:setContentSize(cc.size(620, 80))
    local extratable = qy.TextUtil:StringSplit(data.att_server ,"s",false,false)
    local info1 = self:makeText("本军团的", cc.c3b(255, 253, 221))
    local info2 = self:makeText(data.def_nickname, cc.c3b(238, 221, 86))
    local info3 = self:makeText("成功防守住", cc.c3b(255, 253, 221))
    local info4 = self:makeText("【".. extratable[1] .. "服 】", cc.c3b(22, 176, 245))
    local info5 = self:makeText(data.att_legion_name, cc.c3b(238, 221, 86))
    local info6 = self:makeText("军团的", cc.c3b(255, 253, 221))
    local info7 = self:makeText(data.att_nickname, cc.c3b(22, 176, 245))
    local info8 = self:makeText("的进攻。", cc.c3b(255, 253, 221))
    local info9 = self:makeText("的进攻。", cc.c3b(255, 253, 221))
    local info10 = self:makeText("不敌", cc.c3b(255, 253, 221))
    if iswin == 1 then
        self.richText:pushBackElement(info1)
        self.richText:pushBackElement(info2)
        self.richText:pushBackElement(info10)
        self.richText:pushBackElement(info4)
        self.richText:pushBackElement(info5)
        self.richText:pushBackElement(info6)
        self.richText:pushBackElement(info7)
    else
        self.richText:pushBackElement(info1)
        self.richText:pushBackElement(info2)
        self.richText:pushBackElement(info3)
        self.richText:pushBackElement(info4)
        self.richText:pushBackElement(info5)
        self.richText:pushBackElement(info6)
        self.richText:pushBackElement(info7)
    end
    if isoff == 1 then
        self.richText:pushBackElement(info9)
    else
        self.richText:pushBackElement(info8)
    end

    self.bg:addChild(self.richText)

end
function NewsCell:makeText(text, color)
    return ccui.RichElementText:create(1, color or display.COLOR_WHITE, 255, text, qy.res.FONT_NAME_2, 22)
end
function NewsCell:onEnter()
  
end

function NewsCell:onExit()
    
end

return NewsCell
