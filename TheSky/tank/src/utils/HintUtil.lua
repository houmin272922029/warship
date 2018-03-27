--[[--
    hiti uitil 用于飘多个图
    Author: H.X.Sun
    Date: 2015-05-21
--]]

local HintUtil = {}

local toastPool = {}
local pos = 0
local max_pos = 6

--[[--
--飘好几个图(例如：训练场突飞猛进飘图)
--]]
function HintUtil.showSomeImageToast(_data,_pos)
    local index = 1
    local function callback()
        if index <= #_data then
            local _toast = HintUtil.getToast(_data, index)
            -- qy.hint:showImageToast(_toast)
            qy.hint:showImageToast(_toast,1,1.5,_pos)
            index = index + 1
        end
    end

    local timer = qy.tank.utils.Timer.new(0.3,#_data,function()
        callback()
    end)
    timer:start()
end

function HintUtil.getToast(_data, index)
    pos = pos % max_pos + 1
    print("pos ========>>>>", pos)
    local params = {
            ["attributeImg"] = _data[index].url,
            ["numType"] = _data[index].type,
            ["value"] = _data[index].value,
            ["hasMark"] = 1,
            ["picType"] =  _data[index].picType,
            ["attributeImg2"] = _data[index].url2,
            ["isPrecent"] = _data[index].isPrecent -- 判断是否需要 %
        }
    if toastPool == nil or toastPool[pos] == nil or not tolua.cast(toastPool[pos],"cc.Node") then
        toastPool[pos] = qy.tank.widget.Attribute.new(params)
    else
        toastPool[pos]:render(params)
    end

    return toastPool[pos]
end

return HintUtil
