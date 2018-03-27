--[[
	集结号
	Author: H.X.Sun
]]

local AssemblyDialog = qy.class("AssemblyDialog", qy.tank.view.BaseDialog, "assembly/ui/AssemblyDialog")

local CARD_NUM = 6
local NumberUtil = qy.tank.utils.NumberUtil
local _ModuleType = qy.tank.view.type.ModuleType
local _userModel = qy.tank.model.UserInfoModel


function AssemblyDialog:ctor(delegate)
    AssemblyDialog.super.ctor(self)
    self.model = qy.tank.model.OperatingActivitiesModel
    local service = qy.tank.service.OperatingActivitiesService

    self:InjectView("container")
    self:InjectView("get_txt")
    self:InjectView("num_txt")
    self:InjectView("time_txt")
    self:InjectView("silver_txt")
    self:InjectView("diamond_txt")
    self:InjectView("energy_txt")
    self:InjectView("tip_txt")

    self:OnClick("close_btn", function(sender)
        self:dismiss()
    end)

    for i = 1, CARD_NUM do
        self:InjectView("card_"..i)
        self:OnClick("card_"..i, function(sender)
            if self.remain_num <= 0 then
                qy.hint:show(qy.TextUtil:substitute(42001))
                return
            end
            if self.isAnimStop then
                return
            end
            service:getCommonGiftAward(nil,_ModuleType.ASSEMBLY, true, function()
                local data = self.model:getAssemblyInfo()
                self.isAnimStop = true
                self:updateCostNum(data)
                self:playFx({
                    ["target"] = self["card_"..i],
                    ["award"] = data.award,
                    ["callFunc"] = function()
                        qy.tank.command.AwardCommand:show(data.award,{["critMultiple"] = data.double,["callback"] = function()
                            self:__showOther(i)
                        end})
                    end
                    })
            end, false)
        end,{["isScale"] = false})
    end
    self.awardArr = {}
end

function AssemblyDialog:__showOther(index)
    local data = self.model:getAssOtherAward()
    local _id = 1
    for i = 1, 6 do
        if i ~= index then
            _id = _id + 1,
            self:playFx({
                ["target"] = self["card_"..i],
                ["award"] = data[_id],
            })
        end
    end
end

function AssemblyDialog:updateTime(_end_time)
    local dis_time = _end_time -_userModel.serverTime
    local time_str = ""
    if dis_time > 0 then
        time_str = NumberUtil.secondsToTimeStr(dis_time, 8)
    else
        time_str = qy.TextUtil:substitute(42002)
    end
    self.time_txt:setString(qy.TextUtil:substitute(42003)..time_str)
end

function AssemblyDialog:updateCostNum(data)
    self.id = 1
    self.remain_num = data.left_times
    if data.max_times > data.today_times then
        self["silver_txt"]:setString(qy.TextUtil:substitute(42004, qy.InternationalUtil:getResNumString(data.silver)))
        self["diamond_txt"]:setString(qy.TextUtil:substitute(42004, qy.InternationalUtil:getResNumString(data.diamond)))
        self["energy_txt"]:setString(qy.TextUtil:substitute(42004, qy.InternationalUtil:getResNumString(data.energy)))
    else
        self["silver_txt"]:setString(qy.TextUtil:substitute(42005))
        self["diamond_txt"]:setString(qy.TextUtil:substitute(42005))
        self["energy_txt"]:setString(qy.TextUtil:substitute(42005))
    end
    self.num_txt:setString(qy.TextUtil:substitute(42006)..data.left_times)
    self.tip_txt:setString(qy.TextUtil:substitute(42007)..data.max_times..qy.TextUtil:substitute(42009))
    self.get_txt:setString(data.today_times)
end

function AssemblyDialog:__createItem(_f_ui,_pos,_data)
    local _item = qy.tank.view.common.AwardItem.createAwardView(_data,1)
    _item:setPosition(_pos)
    _f_ui:addChild(_item)
    table.insert(self.awardArr,_item)
end

function AssemblyDialog:playFx(params)
    local pos = cc.p(params.target:getPositionX(),params.target:getPositionY())
	local f_ui = params.target:getParent()
    params.target:setVisible(false)

	local fx = ccs.Armature:create("ui_fx_fanpai")
    fx:setScale(0.6)
    fx:setPosition(pos)
    f_ui:addChild(fx)
    fx:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
	    if movementType == ccs.MovementEventType.complete then
            self:__createItem(f_ui, pos, params.award[1])
            if params.callFunc then
                params.callFunc()
            end
	    	fx:getParent():removeChild(fx)
	    	fx = nil
            if #self.awardArr == CARD_NUM then
                local time = qy.tank.utils.Timer.new(1.5,1,function()
                    if self.isViewOpen then
                        self:reset()
                        self.isAnimStop = false
                    end
                end)
                time:start()
            end
	    end
    end)
    fx:getAnimation():playWithIndex(0)
end

function AssemblyDialog:reset()
    for i = 1, #self.awardArr do
        self.awardArr[i]:getParent():removeChild(self.awardArr[i])
    end
    for i = 1, CARD_NUM do
        self["card_"..i]:setVisible(true)
    end
    self.awardArr = {}
end

function AssemblyDialog:onEnter()
    qy.tank.utils.cache.CachePoolUtil.addArmatureFile("fx/".. qy.language .."/ui/ui_fx_fanpai")
    self.isViewOpen = true
    local data = self.model:getAssemblyInfo()
    self:updateCostNum(data)
    self:updateTime(data.end_time)

    self.timeListener = qy.Event.add(qy.Runtime.TIMER_UPDATE,function(event)
        if data.end_time then
            self:updateTime(data.end_time)
        end
    end)
end

function AssemblyDialog:onExit()
    qy.tank.utils.cache.CachePoolUtil.removeArmatureFile("fx/".. qy.language .."/ui/ui_fx_fanpai")
    self.isViewOpen = false
	qy.Event.remove(self.timeListener)
	self.timeListener = nil
end

return AssemblyDialog
