--[[--
  合金Controller
  Author: H.X.Sun
--]]
local AlloyController = qy.class("AlloyController", qy.tank.controller.BaseController)

function AlloyController:ctor(delegate)
	AlloyController.super.ctor(self)
	self.viewStack = qy.tank.widget.ViewStack.new()
	self.viewStack:addTo(self)

    local AlloyModel = qy.tank.model.AlloyModel

    --关闭
    local function __dismiss(isRemove)
        self.viewStack:pop()
        if isRemove then
            self.viewStack:removeFrom(self)
            self:finish()
        end
    end

    local function __showTips(num, callFunc)
        function callBack(flag)
            if flag == qy.TextUtil:substitute(41007) then
                if callFunc then
                    callFunc()
                else
                    __dismiss(false)
                end
            end
        end
        local msg = {
            {id=1,color={255,255,255},alpha=255,text=qy.TextUtil:substitute(41008),font=qy.res.FONT_NAME_2,size=24},
            {id=2,color={208,17,17},alpha=255,text="EXP" .. math.abs(num),font=qy.res.FONT_NAME_2,size=24},
            {id=3,color={255,255,255},alpha=255,text=qy.TextUtil:substitute(41009),font=qy.res.FONT_NAME_2,size=24},
        }
        qy.alert:show({qy.TextUtil:substitute(41010), {255,255,255}}, msg, cc.size(520,260),{{qy.TextUtil:substitute(41011) , 4}, {qy.TextUtil:substitute(41012), 5}} ,callBack)
    end

    --显示列表
    local function __showEmbeddedList(_alloyId, _type, _equipEntity)
        if AlloyModel:getUnSelectNumByIndex(_alloyId) > 0 then
            --_type 1:该位置没嵌入合金 2:该位置已嵌入合金 3：合金升级
            self.viewStack:push(require("alloy.src.AlloyList").new({
                ["dismiss"] = function()
                    if AlloyModel.OPNE_LISTT_2 == _type then
                        self.viewStack:popToRoot()
                    else
                        __dismiss(false)
                    end
                end,
                ["alloyId"] = _alloyId,
                ["type"] = _type,
                ["equipEntity"] = _equipEntity,
                ["showTips"] = function (num)
                    __showTips(num)
                end
            }))
        else
            local _str = AlloyModel:getAttributeNameByAlloyId(_alloyId)
            if _type == AlloyModel.OPNE_LISTT_1 then
                _str = qy.TextUtil:substitute(41013).. _str ..qy.TextUtil:substitute(41005)
            elseif _type == AlloyModel.OPNE_LISTT_2 then
                _str = qy.TextUtil:substitute(41014).._str ..qy.TextUtil:substitute(41005)
            else
                _str = qy.TextUtil:substitute(41015).._str..qy.TextUtil:substitute(41005)
            end
            qy.hint:show(_str)
        end
    end

    --显示升级视图
    local function __showEmbeddedView(_alloyId,_equipEntity)
        self.viewStack:push(require("alloy.src.EmbeddedView").new({
            ["dismiss"] = function()
                __dismiss(false)
            end,
            ["alloyId"] = _alloyId,
            ["equipEntity"] = _equipEntity,
            ["showEmbeddedList"] = function ()
                __showEmbeddedList(_alloyId, AlloyModel.OPNE_LISTT_3,_equipEntity)
            end,
            ["showTips"] = function (num, callFunc)
                __showTips(num, callFunc)
            end
        }))
    end

    --显示预览视图
    local function __showPreview(_alloyEntity, _equipEntity)
        self.viewStack:push(require("alloy.src.Preview").new({
            ["dismiss"] = function()
                __dismiss(false)
            end,
            ["alloyId"] = _alloyEntity.alloy_id,
            ["equipEntity"] = _equipEntity,
            ["showEmbeddedList"] = function ()
                __showEmbeddedList(_alloyEntity.alloy_id, AlloyModel.OPNE_LISTT_2, _equipEntity)
            end,
            ["showEmbeddedView"] = function ()
                __showEmbeddedView(_alloyEntity.alloy_id,_equipEntity)
            end
        }))
    end

	self.viewStack:push(require("alloy.src.MainView").new({
        ["dismiss"] = function()
            __dismiss(true)
        end,
        ["showEmbeddedList"] = function (_alloyId, _type, _equipEntity)
            __showEmbeddedList(_alloyId, _type, _equipEntity)
        end,
        ["showPreview"] = function (_alloyEntity, _equipEntity)
            __showPreview(_alloyEntity, _equipEntity)
        end,
    }))
end

return AlloyController