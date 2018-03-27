--[[--
--tip util 用于生成一个tip
--Author: H.X.Sun
--Date: 2015-05-21
--]]

local TipUtil = {}

--[[--
--创建tip内容
--]]
function TipUtil.createTipContent(params)
    local tip = nil
    local awardType = qy.tank.view.type.AwardType
    if params.type == awardType.TANK or params.type == awardType.TANK_FRAGMENT then
        --战车
        local entity = nil 
        if type(params.entity) == "table" then
            entity = params.entity
        else
            -- print("params.entity ===" .. qy.json.encode(params.entity))
            entity = qy.tank.entity.TankEntity.new(params.entity)
        end
        tip = qy.tank.view.tip.TankTip.new(entity)
    elseif params.type == awardType.EQUIP or params.type == awardType.EQUIP_FRAGMENT then
        --装备或装备碎片
         local entity = params.entity
        tip = qy.tank.view.tip.EquipTip.new(entity, params.type)
    elseif params.type == awardType.MEDAL then
        --勋章的啊
        print("勋章的tip",json.encode(params.entity))
        local num = table.nums(params.entity)
        print("勋章的num",num)
        if num == 0 then
            tip = qy.tank.view.tip.GeneralTip.new({
                ["icon"] = qy.tank.view.BaseItem.new({
                    ["fatherImg"] = params.bg,
                    ["childImg"] = params.icon,
                    ["offset"] = cc.p(56.5,56.5)
                }),
                -- ["color"] = params.bg,
                ["icons"] = params.icon,
                ["name"] = params.name,
                ["intro"] = params.intro,
                ["nameTextColor"] = params.nameTextColor,
                ["iconScale"] = params.iconScale,
            })
        else
            tip = qy.tank.view.tip.MedalTip.new({
                ["data"] = params.entity
                })
        end
    elseif params.type == awardType.FITTINGS then
        --配件
        local num = table.nums(params.entity)
        if num == 0 then
            tip = qy.tank.view.tip.PartTip1.new({
                ["id"] = params.id,
            })
        else
            tip = qy.tank.view.tip.PartTip.new(params.entity)
        end
    elseif params.type == awardType.TYPE_SOUL then
        local attr1 = params.entity:getAttr1()
        if params.entity.soulType == 5 or params.entity.soulType == 6 or params.entity.soulType == 7 or params.entity.soulType == 8 or params.entity.soulType == 4 or params.entity.soulType == 9 then
            attr1.num = attr1.num / 10 .. "%"
        end
        local intro 
        if params.quality >= 6 then
            local list  = params.entity.deputy_attr
            local intros = ""
            if #list == 0 then
                intros = "\n".."副属性:???"
            else
                for i=1,#list do
                    local type1 = list[i].type
                    local intro1 = qy.tank.model.SoulModel:getAnother(type1,params.entity.level)
                    intros = intros.."\n"..intro1
                end
                qy.tank.model.SoulModel.flag = false
            end
            intro = "主属性:"..attr1.name .. "+" .. attr1.num .."\n"..intros
        else
            intro = "主属性:"..attr1.name .. "+" .. attr1.num
        end
        tip = qy.tank.view.tip.GeneralTip.new({
            ["icon"] = qy.tank.view.BaseItem.new({
                ["fatherImg"] = params.bg,
                ["childImg"] = params.icon,
                ["offset"] = cc.p(56.5,56.5)
            }),
            -- ["color"] = params.bg,
            ["name"] = params.entity.name .. " Lv." .. params.entity.level,
            ["intro"] = intro,
            ["nameTextColor"] = params.nameTextColor,
        })
    elseif params.type == awardType.PASSENGER or params.type == awardType.PASSENGER_FRAGMENT then
        --乘员 乘员碎片
        local entity = params.entity
        tip = qy.tank.view.tip.PassengerTip.new(entity, params.type)
    else
        --一般tip
        tip = qy.tank.view.tip.GeneralTip.new({
            ["icon"] = qy.tank.view.BaseItem.new({
                ["fatherImg"] = params.bg,
                ["childImg"] = params.icon,
                ["offset"] = cc.p(56.5,56.5)
            }),
            -- ["color"] = params.bg,
            ["icons"] = params.icon,
            ["name"] = params.name,
            ["intro"] = params.intro,
            ["nameTextColor"] = params.nameTextColor,
            ["iconScale"] = params.iconScale,
        })

    end
           
    return tip
end

return TipUtil