--[[
	用户信息cell
	Author: H.X.Sun
]]

local UserCell = qy.class("UserCell", qy.tank.view.BaseView, "legion_war/ui/UserCell")

local UserResUtil = qy.tank.utils.UserResUtil
local userModel = qy.tank.model.UserInfoModel

function UserCell:ctor(params)
    UserCell.super.ctor(self)
    self:InjectView("icon_head")
    self:InjectView("angle_sp")
    self:InjectView("user_name")
    self:InjectView("bar")
    self:InjectView("win_txt")
    self:InjectView("legion_name")
    -- self.user_name:setString(params.i)
end


function UserCell:render(data)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("legion_war/res/legion_war.plist")
    self.icon_head:setTexture(UserResUtil.getRoleIconByHeadType(data.headicon))
    self.user_name:setString(data.name)
    self.legion_name:setString(data.legion_name)
    if data.isWin() then
        self.win_txt:setString(qy.TextUtil:substitute(53037, data.round))
        self.angle_sp:setSpriteFrame("legion_war/res/shengli.png")
    else
        self.win_txt:setString("")
        self.angle_sp:setSpriteFrame("legion_war/res/shibai.png")
    end

    if userModel.userInfoEntity.kid == data.kid then
        self.user_name:setTextColor(cc.c4b(45,220,0,255))
    else
        self.user_name:setTextColor(cc.c4b(255,255,255,255))
    end
end

return UserCell
