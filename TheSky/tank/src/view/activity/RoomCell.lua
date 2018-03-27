--[[
    作战室 cell
    Author: H.X.Sun
    Date: 2015-04-18
]]

local RoomCell = qy.class("RoomCell", qy.tank.view.BaseView, "view/activity/RoomCell")

function RoomCell:ctor(idx)
    RoomCell.super.ctor(self)

    self.model = qy.tank.model.BattleRoomModel
    self.userModel = qy.tank.model.UserInfoModel
    self.RedDotModel = qy.tank.model.RedDotModel
    self:InjectView("bg")
    self:InjectView("name")
    self:InjectView("des_1")
    self:InjectView("frame")
    self:InjectView("redDot")
end

function RoomCell:render(idx)
    local name = self.model:getRoomNameByIdx(idx)
    local data = self.model:getRoomDataByName(name)

    if cc.SpriteFrameCache:getInstance():getSpriteFrame("Resources/activity/title_"..name..".png") then
        self.name:setSpriteFrame("Resources/activity/title_"..name..".png") 
        self.bg:setTexture("Resources/activity/img_"..name..".jpg")
    end

    if data.open_level then
        self.des_1:setString(qy.TextUtil:substitute(70041, data.open_level))
    end

    self.frame:removeAllChildren()
    if data.desArr and (data.desArr.txt and #data.desArr.txt > 0) then
        local richTxt = ccui.RichText:create()
        richTxt:ignoreContentAdaptWithSize(false)
        richTxt:setContentSize(243, 100)
        print("...---------"..json.encode(data.desArr.txt))
        for j = 1, #data.desArr.txt do
            local stringTxt = ccui.RichElementText:create(j, data.desArr.color[j], 255, data.desArr.txt[j] , qy.res.FONT_NAME_2, 24)
            richTxt:pushBackElement(stringTxt)
        end
        self.frame:addChild(richTxt)
        if qy.cocos2d_version ~= qy.COCOS2D_3_7_1 then
            richTxt:setAnchorPoint(1, 0)
            richTxt:setPosition(274,46)
        else
            richTxt:setPosition(279,56)
        end
    end

    self.redDot:setVisible(self.RedDotModel:isRoomCellHasDot(name))
end

return RoomCell
