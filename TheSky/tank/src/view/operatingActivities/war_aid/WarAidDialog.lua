--[[
	战地援助
	Author: H.X.Sun
]]

local WarAidDialog = qy.class("WarAidDialog", qy.tank.view.BaseDialog, "war_aid/ui/WarAidDialog")

-- 移动动作
local NOT_MOVE = 0   -- 不移动
local MOVE_RIGHT = 1 -- 右移
local MOVE_LEFT = 2  -- 左移
-- 移动后的位置
local POS_LEFT = 1  -- 左
local POS_MID = 2   -- 中
local POS_RIGHT = 3 -- 右
-- 请求接口的动作
local ACTION_AID = 1  -- 援助
local ACTION_GIFT = 2 -- 开礼包

function WarAidDialog:ctor(delegate)
    WarAidDialog.super.ctor(self)
    self:InjectView("container")
    self:InjectView("aid_num")
    self:InjectView("move_bg")
    self:InjectView("gift_icon")
    self:InjectView("gift_num")
    self:InjectView("aid_num")
    self:InjectView("end_time")

    local style = qy.tank.view.style.DialogStyle1.new({
		size = cc.size(830,580),
		position = cc.p(0,0),
		offset = cc.p(0,0),
		titleUrl = "war_aid/res/war_aid_title.png",
    })
	self:addChild(style, -1)
    self.closeBtn = style.closeBtn
    style.closeBtn:getParent():removeChild(style.closeBtn)
    self.container:addChild(self.closeBtn)
    self.closeBtn:setPosition(430,290)

    self.position = {cc.p(-280,135),cc.p(0, 103),cc.p(280,135)}
    self.scaleData = {1,0.6}
    self.opacityData = {255, 125}
    self.zOrder = {30,10}
    self.move_pos = self.move_bg:getParent():convertToWorldSpace(cc.p(self.move_bg:getPositionX(), self.move_bg:getPositionY()))
    self.model = qy.tank.model.OperatingActivitiesModel
    local service = qy.tank.service.OperatingActivitiesService
    self.aid_info_list = {
        [self.model.GROUND_AID_ACTION] = {["title"]=qy.TextUtil:substitute(90118), ["id"]=1,["prop_id"]=56},
        [self.model.COAST_AID_ACTION] = {["title"]=qy.TextUtil:substitute(90119), ["id"]=2,["prop_id"]=57},
        [self.model.AIR_AID_ACTION] = {["title"]=qy.TextUtil:substitute(90200), ["id"]=3,["prop_id"]=58},
    }

    for i = 1, 4 do
        -- icon_ 3 个
        self:InjectView("icon_"..i)
        -- arrow_ 2 个
        self:InjectView("arrow_"..i)
        -- num_ 4 个
        self:InjectView("num_"..i)
        self["num_"..i]:setLocalZOrder(30)
        -- btn_ 4 个
        self:OnClick("btn_"..i, function()
            if self.model:isEndOfWarAid() then
                qy.hint:show("活动已结束请尽快打开援助大礼")
                return
            elseif self.prop_num_arr[i] < 1 then
                qy.hint:show(qy.TextUtil:substitute(90201))
                return
            end

            service:doWarAidAction({
                ["type"] = ACTION_AID,
                ["id"] = self.aid_info_list[self._curAid].id,
                ["box"] = i
            },function()
                self:__showEffert()
                self:__showSelect()
                self:__updatePropNum()
            end)
        end)
    end
    self.arrow_pos_1 = self.arrow_1:getParent():convertToWorldSpace(cc.p(self.arrow_1:getPositionX(), self.arrow_1:getPositionY()))
    self.arrow_pos_2 = self.arrow_2:getParent():convertToWorldSpace(cc.p(self.arrow_2:getPositionX(), self.arrow_2:getPositionY()))

    self.iconList = {self.icon_3,self.icon_1,self.icon_2}
    local va = 0
    for i = 1, #self.iconList do
        va = i % 2 + 1
        self.iconList[i]:setPosition(self.position[i])
        self.iconList[i]:setScale(self.scaleData[va])
        self.iconList[i]:setOpacity(self.opacityData[va])
    end

    self:OnClick(self.closeBtn,function()
        self:dismiss()
    end)

    self:OnClick("shop_btn",function()
        if self.model:isEndOfWarAid() then
            qy.hint:show("活动已结束请尽快打开援助大礼")
            return
        end
        qy.tank.view.operatingActivities.war_aid.ShopDialog.new({
            ["callback"] = function()
                self:__updatePropNum()
            end
        }):show(true)
    end)

    self:OnClick("rank_btn",function()
        if self.info.rank.rank_list and #self.info.rank.rank_list > 0 then
            qy.tank.view.operatingActivities.war_aid.RankDialog.new({
                ["data"] = self.info.rank,
                ["cur_aid"] = self._curAid,
            }):show(true)
        else
            qy.hint:show(qy.TextUtil:substitute(90202)..self.aid_info_list[self._curAid].title..qy.TextUtil:substitute(90203))
        end
    end)

    self:OnClick("gift_btn",function()
        print("git_btn git_btn git_btn")
        if self.itemData and self.itemData.callback then
            self.itemData.callback()
        end
    end,{["isScale"]=false})

    self:OnClick("open_btn",function()
        -- 正常选择数量使用
        local useDialog = qy.tank.view.storage.PropUseDialog.new(self.itemData.entity,function(_id,_num)
            service:doWarAidAction({
                ["type"] = ACTION_GIFT,
                ["id"] = self.aid_info_list[self._curAid].id,
                ["num"] = _num,
            },function(data)
                self:__showSelect()
                qy.tank.command.AwardCommand:show(data.award)
            end)
        end)
        useDialog:show(true)
    end)

    self:__touchLogic()
    self:__createAidList()
    self:__updatePropNum()
    self:__showSelect()
end

function WarAidDialog:__createAidList()

    local aidList = qy.AwardList.new({
        ["award"] = self.model:getAidData(),
        ["hasName"] = true,
        ["len"] = 4,
        ["type"] = 1,
        ["cellSize"] = cc.size(128,180),
        ["itemSize"] = 1,
    })
    aidList:updateNamePosition(3)
    self.container:addChild(aidList)
    aidList:setPosition(-190,55)
end

function WarAidDialog:__updatePropNum()
    self.prop_num_arr = self.model:getPropNumArr()
    for i = 1, 4 do
        self["num_"..i]:setString(self.prop_num_arr[i])
    end
end

function WarAidDialog:__touchLogic()
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

function WarAidDialog:getAction(_p1, _p2)
    -- move_bg size w:761 h:241
    if _p1.x<self.move_pos.x or _p1.y<self.move_pos.y or _p1.x>(self.move_pos.x+761) or _p1.y>(self.move_pos.y+241) then
        --不移动
        return NOT_MOVE
    elseif _p2.x - _p1.x > 50 then
        -- 向左移
        return MOVE_LEFT
    elseif _p1.x - _p2.x > 50 then
        -- 向右移
        return MOVE_RIGHT
    elseif _p2.x>self.arrow_pos_1.x and _p2.y>self.arrow_pos_1.y and _p2.x<(self.arrow_pos_1.x+101) and _p1.y<(self.arrow_pos_1.y+69) then
        return MOVE_RIGHT
    elseif _p2.x>self.arrow_pos_2.x and _p2.y>self.arrow_pos_2.y and _p2.x<(self.arrow_pos_2.x+101) and _p1.y<(self.arrow_pos_2.y+69) then
        return MOVE_LEFT
    else
        --不移动
        return NOT_MOVE
    end
end

function WarAidDialog:toAction(_action)
    local list = {}
    local entityT = {}

    -- list 1,2,3 表示 self.iconList 的下标
    -- anim 的第二个参数 1，2，3 表示左中右
    if _action == MOVE_RIGHT then
        --向右移
        list[1] = self.iconList[2]
        self:anim(list[1], POS_LEFT)
        list[3] = self.iconList[1]
        self:anim(list[3], POS_RIGHT)
        list[2] = self.iconList[3]
        self:anim(list[2], POS_MID)
        self.model:updateAidList(2,3,1)
    elseif _action == MOVE_LEFT then
        --向左移
        list[2] = self.iconList[1]
        self:anim(list[2], POS_MID)
        list[3] = self.iconList[2]
        self:anim(list[3], POS_RIGHT)
        list[1] = self.iconList[3]
        self:anim(list[1], POS_LEFT)
        self.model:updateAidList(3,1,2)
    end

    if _action > NOT_MOVE then
        self.iconList = list
    end
end

--[[
    动画
    param
        #cc.Node ui 运动UI
        #number endPos 左：1，中：2，右：3
]]--
function WarAidDialog:anim(ui, endPos)
    self:operaArrow(false)

    local va = endPos % 2 + 1
    ui:setLocalZOrder(self.zOrder[va])
    local move = cc.MoveTo:create(0.5, self.position[endPos])
    local fadeTo = cc.FadeTo:create(0.5, self.opacityData[va])
    local scaleTo = cc.ScaleTo:create(0.5, self.scaleData[va])
    local spawn1 = cc.Spawn:create(move,fadeTo)
    local spawn2 = cc.Spawn:create(scaleTo,spawn1)
    local callFunc = cc.CallFunc:create(function ()
        ui:setPosition(self.position[endPos])
        self:operaArrow(true)
        self:__showSelect()
    end)
    ui:runAction(cc.Sequence:create(spawn2, callFunc))
end

function WarAidDialog:__showEffert()
    if self.effertArr == nil then
        self.effertArr = ccs.Armature:create("ui_fx_zhiyuan")
        self.effertArr:setPosition(51,49)
        self.container:addChild(self.effertArr,999)
    end
    -- qy.QYPlaySound.playEffect(qy.SoundType.ROLE_UP)
    self.effertArr:getAnimation():playWithIndex(0)
end

function WarAidDialog:__showSelect()
    self._curAid = self.model:getCurAid()
    self.info = self.model:getWarAidInfo(self._curAid)
    -- self.gift_icon:setSpriteFrame("war_aid/res/gift_"..self._curAid..".png")
    self.itemData = qy.tank.view.common.AwardItem.getItemData({["type"]=14,["id"]=self.aid_info_list[self._curAid].prop_id,["num"]=self.info.gift})
    self.gift_icon:setTexture(self.itemData.icon)
    self.gift_num:setString(self.info.gift)
    self.aid_num:setString(qy.TextUtil:substitute(90204)..self.info.times..qy.TextUtil:substitute(90206))
end

function WarAidDialog:operaArrow(_flag)
    for i = 1, 2 do
        self["arrow_"..i]:setVisible(_flag)
    end
end

function WarAidDialog:updateTime()
    local time = self.model:getAidEndTime()
    if self.model:isEndOfWarAid() then
        self.end_time:setTextColor(cc.c4b(255,0,0,255))
        self.end_time:setString("领奖倒计时:"..time)
    else
        self.end_time:setString(qy.TextUtil:substitute(90205)..time)
    end
end

function WarAidDialog:onEnter()
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileByModules("war_aid/fx/ui_fx_zhiyuan")
    self.timeListener = qy.Event.add(qy.Runtime.TIMER_UPDATE,function(event)
        self:updateTime()
    end)
    self:updateTime()
end

function WarAidDialog:onExit()
    qy.tank.utils.cache.CachePoolUtil.removeArmatureFileByModules("war_aid/fx/ui_fx_zhiyuan")
    qy.Event.remove(self.timeListener)
	self.timeListener = nil
end

return WarAidDialog
