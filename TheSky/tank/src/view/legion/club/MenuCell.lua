--[[
	菜单cell
	Author: H.X.Sun
]]

local MenuCell = qy.class("MenuCell", qy.tank.view.BaseView, "legion/ui/club/MenuCell")

function MenuCell:ctor(delegate)
    MenuCell.super.ctor(self)
    self:InjectView("bg")
    self:InjectView("lock_status")
    self.model = qy.tank.model.LegionModel
end

function MenuCell:render(data)
    if data then
        local _str = "legion/res/club/" .. data.e_name .. "_pic.png"
        if cc.SpriteFrameCache:getInstance():getSpriteFrame(_str) then
            self.bg:setSpriteFrame(_str)
        end
        if data.open_level <= self.model:getHisLegion().level then
            self.lock_status:setSpriteFrame("legion/res/club/unlock_pic.png")
        else
            self.lock_status:setSpriteFrame("legion/res/club/lock_pic.png")
        end
    end
end

function MenuCell:unhightLight()
    self.bg:setScale(1)
end

function MenuCell:hightLight()
    self.bg:setScale(0.95)
end

return MenuCell
