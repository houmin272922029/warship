local handBookDialog = qy.class("handBookDialog", qy.tank.view.BaseDialog, "passenger.ui.handBookDialog")

local PassengerModel = qy.tank.model.PassengerModel
function handBookDialog:ctor(data)
   	handBookDialog.super.ctor(self)
   	self:setCanceledOnTouchOutside(true)
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

    self:InjectView("rank")
    self:InjectView("passenger")
    self:InjectView("name")
    self:InjectView("position")
    self:InjectView("atk")
    self:InjectView("def")
    self:InjectView("hp")
    self:InjectView("info")

    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/item/common_item.plist")
    self.rank:setSpriteFrame("Resources/common/item/k" .. data.quality .. ".png")
    self.passenger:loadTexture("res/passenger/" .. data.id .. ".jpg")
    self.name:setString(data.name)
    self.name:setColor(qy.tank.utils.ColorMapUtil.qualityMapColor(data.quality or 1))
    self.position:setString(data.type == 1 and ("将领("..PassengerModel.typeNameList[data.type .. ""])..")" or  PassengerModel.typeNameList[data.type .. ""])
    self.atk:setString(data.attack > 0 and ("+" .. data.attack) or "无")
    self.def:setString(data.defense > 0 and ("+" .. data.defense) or "无")
    self.hp:setString(data.blood > 0 and ("+" .. data.blood) or "无")
    local tujian_type = tonumber(data.tujian_type)
    if tujian_type == 6 or tujian_type == 9 or tujian_type == 10 or tujian_type == 11 or tujian_type == 12 or tujian_type == 13 then
        self.info:setString(PassengerModel.tujianTypeNameList[data.tujian_type .. ""] .. " +" .. (data.tujian_val or 0).."%")
    else
        self.info:setString(PassengerModel.tujianTypeNameList[data.tujian_type .. ""] .. " +" .. (data.tujian_val or 0))
    end
end

function handBookDialog:onEnter()
    
end

function handBookDialog:onExit()

end

return handBookDialog