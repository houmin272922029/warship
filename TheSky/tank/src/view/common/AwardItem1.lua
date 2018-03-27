--[[
    奖品item
    Author: H.X.Sun
    Date: 2015-05-05

    此类用于奖励的表现：
        data：服务器的奖励数据
        viewType：界面类型 1：itemIcon 2: card
        bgScale：背景的缩放尺寸,可以为nil,默认为1
        showDetail:点击后是否显示明细   默认 true
        callback：点击item回调, 可以为nil

    用法：
        awardItem = qy.tank.view.common.AwardItem.createAwardView(award[i],1, callBack, 1)
        awardCard= qy.tank.view.common.AwardItem.createAwardView(award[i],2, callBack, 1)

        --需要进行位置的设定
        self.itemList:addChild(awardItem)
        x = (awardItem:getWidth()+60)*(i-1)
        awardItem:setPosition(x,0)

        后端策划定义的type 1~ 100000 (大于0)
        前端定义的type -1 ~ -10000 (小于0)
]]
---冲破火线活动用的，策划让改变背景所有道具用统一的背景
local AwardItem1 = {}

local _UserInfoModel = qy.tank.model.UserInfoModel

-- expandArr：扩展参数，table
function AwardItem1.createAwardView(data, viewType, bgScale , showDetail , callback, expandArr)
    local itemData = AwardItem1.getItemData(data,showDetail, bgScale,callback)
    local awardType = qy.tank.view.type.AwardType
    itemData.expandArr = expandArr
    if viewType == 1 or viewType == "1" then
        if data.type == awardType.TANK or data.type == awardType.TANK_FRAGMENT then
            return qy.tank.view.common.TankItem.new(itemData)
        else
            return qy.tank.view.common.ItemIcon.new(itemData)
        end
    elseif viewType == 2 or viewType == "2" then
        return qy.tank.view.common.ItemCard.new(itemData)
    end
end

function AwardItem1.getItemData(data,showDetail, bgScale, callback)
    local itemData = {}
    local entity = nil
    local awardType = qy.tank.view.type.AwardType
    if data.type == awardType.DIAMOND then
        --钻石
        itemData.bg = "Resources/common/item/newcommon.png"
        itemData.icon = qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        itemData.num = data.num
        itemData.name = qy.TextUtil:substitute(8001)
        --itemData.iconScale = 1
        itemData.intro = qy.TextUtil:substitute(8002)
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(1)
        itemData.quality = 1
    elseif data.type == awardType.ENERGY then
        --体力
        itemData.bg = "Resources/common/item/item_bg_3.png"
        itemData.icon = qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        itemData.num = data.num
        itemData.name = qy.TextUtil:substitute(8003)
        --itemData.iconScale = 1
        itemData.intro = qy.TextUtil:substitute(8004)
        itemData.quality = 3
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(1)
    elseif data.type == awardType.SILVER then

        --银币
        itemData.bg = "Resources/common/item/item_bg_1.png"
        itemData.icon = qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        if data.id == 1 then
          --策划配表：当银币的id等于1时，实际的银币数= 表中的num * 用户等级
          itemData.num = data.num * _UserInfoModel.userInfoEntity.level
        else
          itemData.num = data.num
        end
        itemData.name = qy.TextUtil:substitute(8005)
        --itemData.iconScale = 1.5
        itemData.intro = qy.TextUtil:substitute(8006)
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(1)
        itemData.quality = 1
    elseif data.type == awardType.EXP_CARD then
        --战车经验卡
        itemData.bg = "Resources/common/item/item_bg_3.png"
        itemData.icon = qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        itemData.num = data.num
        itemData.name = qy.TextUtil:substitute(8007)
        --itemData.iconScale = 1
        itemData.intro = qy.TextUtil:substitute(8008)
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(3)
        itemData.quality = 3
    elseif data.type == awardType.TECHNOLOGY_HAMMER then
        --科技书
        itemData.bg =  "Resources/common/item/item_bg_3.png"
        itemData.icon =  qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        -- itemData.num = data.num
        if data.id == 1 then
          --策划配表：当银币的id等于1时，实际的银币数= 表中的num * 用户等级
          itemData.num = data.num * _UserInfoModel.userInfoEntity.level
        else
          itemData.num = data.num
        end
        itemData.name = qy.TextUtil:substitute(8009)
        --itemData.iconScale = 1
        itemData.intro = qy.TextUtil:substitute(8010)
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(3)
        itemData.quality = 3
    elseif data.type == awardType.BLUE_IRON  then
        --蓝铁
        itemData.bg =  "Resources/common/item/item_bg_3.png"
        itemData.icon =  qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        itemData.num = data.num
        itemData.name = qy.TextUtil:substitute(8011)
        --itemData.iconScale = 1
        itemData.intro = qy.TextUtil:substitute(8012)
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(3)
        itemData.quality = 3
    elseif data.type == awardType.PURPLE_IRON then
        --紫铁
        itemData.bg =  "Resources/common/item/item_bg_4.png"
        itemData.icon =  qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        itemData.num = data.num
        itemData.name = qy.TextUtil:substitute(8013)
        --itemData.iconScale = 1
        itemData.intro = qy.TextUtil:substitute(8014)
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(4)
        itemData.quality = 4
    elseif data.type == awardType.ORANGE_IRON then
        --橙铁
        -- itemData.bg =  "Resources/common/item/item_bg_5.png"
        itemData.icon =  qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        itemData.num = data.num
        itemData.name = qy.TextUtil:substitute(8015)
        itemData.intro = qy.TextUtil:substitute(8016)
        --itemData.iconScale = 1
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(5)
        itemData.quality = 5
    elseif data.type == awardType.EXPEDITION_COINS then
        --远征币
        -- itemData.bg =  "Resources/common/item/item_bg_3.png"
        itemData.icon =  qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        itemData.num = data.num
        itemData.name = qy.TextUtil:substitute(8017)
        --itemData.iconScale = 1
        itemData.intro = qy.TextUtil:substitute(8018)
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(3)
        itemData.quality = 3
    elseif data.type == awardType.WHISKY then
        --威士忌
        -- itemData.bg =  "Resources/common/item/item_bg_3.png"
        itemData.icon =  qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        itemData.num = data.num
        itemData.name = qy.TextUtil:substitute(8019)
        --itemData.iconScale = 1
        itemData.intro = qy.TextUtil:substitute(8020)
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(3)
        itemData.quality = 3
    elseif data.type == awardType.PRESTIGE then
        --威望
        -- itemData.bg =  "Resources/common/item/item_bg_3.png"
        itemData.icon =  qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        itemData.num = data.num
        itemData.name = qy.TextUtil:substitute(8021)
        --itemData.iconScale = 1
        itemData.intro = qy.TextUtil:substitute(8022)
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(3)
        itemData.quality = 3
    elseif data.type == awardType.BATTLE_ACHIEVEMENT then
        --对决积分
        -- itemData.bg =  "Resources/common/item/item_bg_4.png"
        itemData.icon =  qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        itemData.num = data.num
        itemData.name = "对决积分"
        --itemData.iconScale = 1
        itemData.intro = "对决积分可在跨服商城兑换物资，为全服玩家发放奖励"
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(4)
        itemData.quality = 4
    elseif data.type == awardType.PASSENGER then
        --乘员
        local staticData = qy.Config.passenger
        local data2 = staticData[tostring(data.id or data.passenger_id)]

        entity = qy.tank.entity.PassengerEntity.new(data, data2)
        local quality = data.quality or data2.quality

        -- itemData.bg =  quality and "Resources/common/item/item_bg_" .. quality ..".png" or "Resources/common/item/item_bg_" .. 1 ..".png"
        itemData.icon =  qy.tank.utils.AwardUtils.getAwardIconByType(data.type, data2)
        itemData.num = data.num or 1
        itemData.name = data2.name
        itemData.intro = ""
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(quality)
        itemData.quality = quality
        itemData.entity = data2
    elseif data.type == awardType.PASSENGER_FRAGMENT then
        --乘员碎片
        local staticData = qy.Config.passenger
        local data2 = staticData[tostring(data.id or data.passenger_id)]

        entity = qy.tank.entity.PassengerEntity.new(data, data2)
        local quality = data.quality or data2.quality

        -- itemData.bg =  "Resources/common/item/item_bg_" .. quality ..".png"
        itemData.icon =  qy.tank.utils.AwardUtils.getAwardIconByType(data.type, data2)
        itemData.num = data.num
        itemData.name = data2.name .. qy.TextUtil:substitute(8023)
        itemData.intro = ""
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(quality)
        itemData.quality = quality
        itemData.entity = data2
    elseif data.type == awardType.TANK then
        --战车
        if data.tank == nil then
            if data.tank_id == nil then
                data.tank_id = data.id
            end
            if data.isOther == true then
                entity = qy.tank.entity.OtherTankEntity.new(data.tank_id,data.monster_type) -- 查看资料
            else
                entity = qy.tank.entity.TankEntity.new(data.tank_id,data.monster_type)
            end
        else
            if data.isOther == true then
                entity = data.tank -- 查看资料
            else
                local tankData = data.tank
                if data.tank.__type == "entity" then
                    entity = data.tank
                else
                    entity = qy.tank.entity.TankEntity.new(data.tank,data.monster_type)
                end
            end
        end

        itemData.entity = entity
        itemData.name = entity.name
        itemData.quality = entity.quality
    elseif data.type == awardType.EQUIP then
        --装备
        if data.equip == nil then
            if data.equip_id == nil then
                data.equip_id = data.id
            end
            entity = qy.tank.entity.EquipEntity.new(data.equip_id)
        else
            entity = qy.tank.entity.EquipEntity.new(data.equip)
        end

        -- itemData.bg =  entity:getIconBg()
        itemData.icon =  entity:getIcon()
        itemData.num =  1
        itemData.name =  entity:getName()
        --itemData.iconScale = 1
        itemData.intro = ""
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(entity:getQuality())
        itemData.entity = entity
        itemData.quality = entity:getQuality()
    elseif data.type == awardType.EQUIP_FRAGMENT then
        --装备碎片
        if data.equip_id == nil then
            data.equip_id = data.id
        end
        entity =  qy.tank.entity.EquipEntity.new(data.equip_id)
        -- itemData.bg =  entity:getIconBg()
        itemData.icon =  entity:getIcon()
        itemData.num =  data.num
        itemData.name =  entity:getName() .. qy.TextUtil:substitute(8023)
        --itemData.iconScale = 1
        itemData.intro = ""
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(entity:getQuality())
        itemData.entity = entity
        itemData.quality = entity:getQuality()
    elseif data.type == awardType.STORAGE then
        --道具
        --print(qy.json.encode(data))∂∂
        entity = qy.tank.entity.PropsEntity.new(data)
        --print("entity==" .. entity.id)
        -- itemData.bg =  entity:getIconBG()
        itemData.icon =  entity:getIcon()
        itemData.num =  entity:getNum()
        itemData.name =  entity.name
        itemData.id = entity.id
        --itemData.iconScale = 1
        itemData.intro = entity.desc

        itemData.nameTextColor = entity:getTextColor()
        itemData.quality = entity.quality
        itemData.entity = entity
    elseif data.type == awardType.USER_EXP then --客户端自定义的type
        --指挥官经验
        -- itemData.bg =  "Resources/common/item/item_bg_3.png"
        itemData.icon =  qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        itemData.num = data.num
        itemData.name = qy.TextUtil:substitute(8024)
        --itemData.iconScale = 1
        itemData.intro = ""
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(1)
        itemData.quality = 1
    elseif data.type == awardType.ALLOY_1 or data.type == awardType.ALLOY_2 or data.type == awardType.ALLOY_3 then
        --攻击合金--防御合金--生命合金
        entity = qy.tank.entity.AlloyEntity.new(data.alloy or data)

        -- itemData.bg =  "Resources/common/item/item_bg_1.png"
        itemData.icon =  entity:getIcon()
        itemData.num =  data.num
        itemData.name =  entity:getName()
        itemData.intro = entity:getAttributeDesc()..qy.TextUtil:substitute(8025)
        itemData.nameTextColor = entity:getColor()
        itemData.entity = entity
        itemData.quality  = 1
    elseif data.type == awardType.ADVANCE_MATERAIL then
        -- itemData.bg = "Resources/common/item/item_bg_4.png"
        itemData.icon = qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        itemData.num = data.num
        itemData.name = qy.TextUtil:substitute(8026)
        --itemData.iconScale = 1.5
        itemData.intro = qy.TextUtil:substitute(8027)
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(4)
        itemData.quality  = 4

        -- itemData.bg = "Resources/common/item/item_bg_3.png"
        -- itemData.icon = qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        -- itemData.num = data.num
        -- itemData.name = "进阶材料"
        -- --itemData.iconScale = 1
        -- itemData.intro = ""
        -- itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(5)
    elseif data.type == awardType.TYPE_SOUL then
        local staticData = qy.Config.soul

        local data2 = staticData[tostring(data.id or data.soul_id)]

        entity = qy.tank.entity.SoulEntity.new(data, data2)
        local quality = data.quality or data2.quality
        -- itemData.bg = "Resources/common/item/item_bg_" .. quality .. ".png"
        itemData.icon = qy.tank.utils.AwardUtils.getAwardIconByType(data.type, data2)
        itemData.num = data.num
        itemData.name = data.name or data2.name
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(quality)
        itemData.quality  = quality
        itemData.entity = entity
    elseif data.type == awardType.TYPE_SOUL_FRAGMENT then
        -- itemData.bg = "Resources/common/item/item_bg_4.png"
        itemData.icon = qy.tank.utils.AwardUtils.getAwardIconByType(data.type)

        itemData.num = data.num
        itemData.name = qy.TextUtil:substitute(8028)
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(4)
        itemData.quality  = 1
    elseif data.type == awardType.RAFFLE_TICKET then
        -- 兑奖券
        -- itemData.bg = "Resources/common/item/item_bg_4.png"
        itemData.icon = qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        itemData.num = data.num
        itemData.name = "国庆券"
        itemData.intro = "已经忍不住要为祖国庆生了！国庆券可在军资整备奖券商店中兑换各种军用物资。"
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(4)
        itemData.quality = 4
    elseif data.type == awardType.REPUTATION then
        -- 声望
        -- itemData.bg = "Resources/common/item/item_bg_6.png"
        itemData.icon = qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        itemData.num = data.num
        itemData.name = "声望"
        itemData.intro = "指挥官100级可在战车工厂兑换声望坦克"
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(6)
        itemData.quality = 6
    elseif data.type == awardType.BEAT_ENEMY_SOURE then
        -- 暴打敌营积分
        -- itemData.bg = "Resources/common/item/item_bg_4.png"
        itemData.icon = qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        itemData.num = data.num
        itemData.name = "暴打积分"
        itemData.intro = ""
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(4)
        itemData.quality = 4
        showDetail = false
        callback = nil
    elseif data.type == awardType.ARENA_COIN then
        -- 声望
        -- itemData.bg = "Resources/common/item/item_bg_4.png"
        itemData.icon = qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        itemData.num = data.num
        itemData.name = "角斗币"
        itemData.intro = "角斗币描述策划还没出"
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(4)
        itemData.quality = 4

    elseif data.type == awardType.MILITARY_EXPLOIT then
        -- 声望
        -- itemData.bg = "Resources/common/item/item_bg_4.png"
        itemData.icon = qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        itemData.num = data.num
        itemData.name = "军功"
        itemData.intro = "军功可用于进修军衔"
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(4)
        itemData.quality = 4
    elseif data.type == awardType.JUNENG_SUIPIAN1 then
        -- 聚能拼合碎片1
        -- itemData.bg = "Resources/common/item/item_bg_4.png"
        itemData.icon = qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        itemData.num = data.num
        itemData.name = "聚能拼合碎片1"
        itemData.intro = "可在聚能拼合活动中获得丰厚物资"
        itemData.iconScale = 0.6
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(4)
        itemData.quality = 4
    elseif data.type == awardType.JUNENG_SUIPIAN2 then
        -- 聚能拼合碎片2
        -- itemData.bg = "Resources/common/item/item_bg_4.png"
        itemData.icon = qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        itemData.num = data.num
        itemData.name = "聚能拼合碎片2"
        itemData.intro = "可在聚能拼合活动中获得丰厚物资"
        itemData.iconScale = 0.6
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(4)
        itemData.quality = 4
    elseif data.type == awardType.JUNENG_SUIPIAN3 then
        -- 聚能拼合碎片3
        -- itemData.bg = "Resources/common/item/item_bg_4.png"
        itemData.icon = qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        itemData.num = data.num
        itemData.name = "聚能拼合碎片3"
        itemData.intro = "可在聚能拼合活动中获得丰厚物资"
        itemData.iconScale = 0.6
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(4)
        itemData.quality = 4
    elseif data.type == awardType.JUNENG_SUIPIAN4 then
        -- 聚能拼合碎片4
        -- itemData.bg = "Resources/common/item/item_bg_4.png"
        itemData.icon = qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        itemData.num = data.num
        itemData.name = "聚能拼合碎片4"
        itemData.intro = "可在聚能拼合活动中获得丰厚物资"
        itemData.iconScale = 0.6
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(4)
        itemData.quality = 4
    elseif data.type == awardType.TANK_FRAGMENT then
        --战车碎片
        entity = qy.tank.entity.OtherTankEntity.new(data.id,data.monster_type) -- 查看资料
        itemData.entity = entity
        itemData.name = entity.name..qy.TextUtil:substitute(8023)
        itemData.num = data.num
        itemData.isFragment = true
        itemData.quality = entity.quality
    elseif data.type == awardType.CERAMICS_ARMOR then
        -- 陶瓷装甲
        -- itemData.bg = "Resources/common/item/item_bg_4.png"
        itemData.icon = qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        itemData.num = data.num
        itemData.name = "陶瓷装甲"
        itemData.intro = qy.TextUtil:substitute(90271)
        itemData.iconScale = 0.6
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(4)
        itemData.quality = 4
    elseif data.type == awardType.FUSION_CRYSTAL then
        -- 聚变水晶
        -- itemData.bg = "Resources/common/item/item_bg_5.png"
        itemData.icon = qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        itemData.num = data.num
        itemData.name = "聚变水晶"
        itemData.intro = "夺宝券夺宝中产出的珍贵道具，可以在核能商店兑换稀有物品。"
        itemData.iconScale = 1
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(5)
        itemData.quality = 5
    elseif data.type == awardType.FISSION_CRYSTAL then
        -- 裂变水晶
        -- itemData.bg = "Resources/common/item/item_bg_4.png"
        itemData.icon = qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        itemData.num = data.num
        itemData.name = "裂变水晶"
        itemData.intro = "钻石夺宝中产出的珍贵道具，可以在核能商店兑换稀有物品。"
        itemData.iconScale = 1
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(4)
        itemData.quality = 4
    elseif data.type == awardType.GCRRT then
        -- 日耀徽章
        -- itemData.bg = "Resources/common/item/item_bg_6.png"
        itemData.icon = qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        itemData.num = data.num
        itemData.name = "日耀徽章"
        itemData.intro = "只有传奇指挥官才能获得的稀有徽章，可以在日耀商店兑换物品。"
        itemData.iconScale = 1
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(6)
        itemData.quality = 6
    elseif data.type == awardType.SCERT then
        -- 月华徽章
        -- itemData.bg = "Resources/common/item/item_bg_5.png"
        itemData.icon = qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        itemData.num = data.num
        itemData.name = "月华徽章"
        itemData.intro = "只有传奇指挥官才能获得的稀有徽章，可以在月华商店兑换物品。"
        itemData.iconScale = 1
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(5)
        itemData.quality = 5
    elseif data.type == awardType.HANDBOOK then
        -- 升级手册
        -- itemData.bg = "Resources/common/item/item_bg_3.png"
        itemData.icon = qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        itemData.num = data.num
        itemData.name = "进修手册"
        itemData.intro = "乘员进修必备道具，可提升乘员百分比属性"
        itemData.iconScale = 1
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(3)
        itemData.quality = 3
    elseif data.type == awardType.FINE_IRON then
        -- 精铁
        -- itemData.bg = "Resources/common/item/item_bg_4.png"
        itemData.icon = qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        itemData.num = data.num
        itemData.name = "铸铁"
        itemData.intro = "一种特殊制造的金属，可用于精炼坦克配件"
        itemData.iconScale = 1.2
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(4)
        itemData.quality = 4
    elseif data.type == awardType.SMELTING then
        --熔炼积分
        -- itemData.bg = "Resources/common/item/item_bg_4.png"
        itemData.icon = qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        itemData.num = data.num
        itemData.name = "熔炼积分"
        itemData.intro = "配件熔炼获得的积分，可用于配件商店购买配件"
        itemData.iconScale = 1
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(4)
        itemData.quality = 4
    elseif data.type == awardType.VIP_EXP then
        -- vip经验
        -- itemData.bg = "Resources/common/item/item_bg_5.png"
        itemData.icon = qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        itemData.num = data.num
        itemData.name = "VIP经验"
        itemData.intro = ""
        itemData.iconScale = 1
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(5)
        itemData.quality = 5
    elseif data.type == awardType.MEDAL then
        local staticData = qy.Config.medal_card
        local id = 1
        if data.id then
            id = data.id
        else
            id = data.medal.medal_id
        end
        local data2 = staticData[id..""]

        local quality =  data2.medal_colour
        local parm = {}
        parm["foreign_id"] = data2.foreign_id
        parm["position"] = data2.position
        -- itemData.bg = "Resources/common/item/item_bg_" .. quality .. ".png"
        itemData.icon = qy.tank.utils.AwardUtils.getAwardIconByType(data.type, parm)
        itemData.num = data.num
        itemData.name = data2.name
        itemData.intro = "属性:???"
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(quality)
        itemData.quality  = quality
        local entity1 = {}
        if data.id then
        else
            entity1 = data.medal
        end
        itemData.entity = entity1
    elseif data.type == awardType.FITTINGS then
        local staticData = qy.Config.fittings
        local id = 1
        if data.id then
            id = data.id
        else
            id = data.fittings.fittings_id
        end
        local data2 = staticData[id..""]

        local quality =  data2.quality
        local ids = data2.fittings_type
        -- itemData.bg = "Resources/common/item/item_bg_" .. quality .. ".png"
        itemData.id = id
        itemData.icon = qy.tank.utils.AwardUtils.getAwardIconByType(data.type, ids)
        itemData.num = data.num
        itemData.name = data2.name
        itemData.intro = "属性:???"
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(quality)
        itemData.quality  = quality
        local entity1 = {}
        if data.id then
        else
            entity1 = data.fittings
        end
        itemData.entity = entity1
    elseif data.type == awardType.AFLIQUID then
        -- 重铸液
        -- itemData.bg = "Resources/common/item/item_bg_4.png"
        itemData.icon = qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        itemData.num = data.num
        itemData.name = "重铸液"
        itemData.intro = "可用于勋章重铸，重铸可洗练勋章属性类型及品质。"
        itemData.iconScale = 1
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(4)
        itemData.quality = 4
    elseif data.type == awardType.EXLIQUID then
        -- 精铸液
        -- itemData.bg = "Resources/common/item/item_bg_5.png"
        itemData.icon = qy.tank.utils.AwardUtils.getAwardIconByType(data.type)
        itemData.num = data.num
        itemData.name = "精铸液"
        itemData.intro = "用于勋章精铸，精铸不会改变属性类型，每次精铸属性必涨。"
        itemData.iconScale = 1
        itemData.nameTextColor = qy.tank.utils.ColorMapUtil.qualityMapColor(5)
        itemData.quality = 5
    end
    itemData.bg = "Resources/common/item/newcommon.png"
    -- itemData.iconScale = 0.8
    itemData.type = data.type

    if tonumber(bgScale) then
        itemData.bgScale = tonumber(bgScale)
    else
        itemData.bgScale = 1
    end

    if showDetail == nil then
        showDetail = true
    end

    if showDetail then
    --TODO:这里是调用点击显示细节的地方 , 交由其他类去处理
        itemData.callback = function ()
            if data.type == awardType.STORAGE and (entity.extra_tip and entity.extra_tip[1]) then
                qy.alert:showTip(qy.tank.utils.TipUtil.createTipContent(AwardItem.getItemData(entity.extra_tip[1])))
            else
                local itemData = qy.tank.view.common.AwardItem.getItemData(data,1)
                qy.alert:showTip(qy.tank.utils.TipUtil.createTipContent(itemData))
            end

        end
    else
        itemData.callback = callback
    end
    return itemData
end
return AwardItem1
