--[[
--乘员tip
]]

local PassengerTip = qy.class("PassengerTip", qy.tank.view.BaseDialog, "view/tip/PassengerTip")
local PassengerModel = qy.tank.model.PassengerModel
local cfg = qy.Config.passenger

function PassengerTip:ctor(entity, _awardType)
    PassengerTip.super.ctor(self)

    self.style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(680,420),
        position = cc.p(0,20),
        offset = cc.p(0,0), 
        titleUrl = "Resources/common/title/chengyuanjianjie.png",
        ["onClose"] = function()
            self:dismiss()
        end
    }) 
    self:addChild(self.style , -1)
    local data = entity
    self:InjectView("rank")
    self:InjectView("passenger")
    self:InjectView("name")
    self:InjectView("position")
    self:InjectView("atk")
    self:InjectView("def")
    self:InjectView("hp")
    self:InjectView("info")
    self:InjectView("Text_6")
    self:InjectView("suipian")

    self.suipian:setVisible(_awardType == 26)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/item/common_item.plist")
    self.rank:setSpriteFrame("Resources/common/item/k" .. data.quality .. ".png")
    self.passenger:loadTexture("res/passenger/" .. data.id .. ".jpg")
    self.name:setString(data.name)
    self.name:setColor(qy.tank.utils.ColorMapUtil.qualityMapColor(data.quality or 1))
    self.position:setString(data.type == 1 and (qy.TextUtil:substitute(90059)..PassengerModel.typeNameList[data.type .. ""]..")") or  PassengerModel.typeNameList[data.type .. ""])
    self.atk:setString(data.attack > 0 and ("+" .. data.attack) or qy.TextUtil:substitute(90060))
    self.def:setString(data.defense > 0 and ("+" .. data.defense) or qy.TextUtil:substitute(90060))
    self.hp:setString(data.blood > 0 and ("+" .. data.blood) or qy.TextUtil:substitute(90060))
    local tujian_type = tonumber(cfg[data.id..""].tujian_type)
    local tujian_val = tonumber(cfg[data.id..""].tujian_val)
    if tujian_type ~= 0 or tujian_val ~= 0 then
        self.Text_6:setString( qy.TextUtil:substitute(90061))
        if tujian_type == 6 or tujian_type == 9 or tujian_type == 10 or tujian_type == 11 or tujian_type == 12 or tujian_type == 13 then
            self.info:setString(PassengerModel.tujianTypeNameList[tujian_type..""] .. " +" .. (tujian_val or 0).."%")
        else
            self.info:setString(PassengerModel.tujianTypeNameList[tujian_type..""] .. " +" .. (tujian_val or 0))
        end
    else
        self.Text_6:setString( qy.TextUtil:substitute(90062))
        self.info:setString("  +"..cfg[data.id..""].exp)
    end
end

return PassengerTip