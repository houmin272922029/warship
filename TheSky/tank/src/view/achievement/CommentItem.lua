--[[
--图鉴
--Author: mingming
--Date:
]]

local CommentItem = qy.class("CommentItem", qy.tank.view.BaseView, "view/achievement/CommentItem")

function CommentItem:ctor(delegate)
    CommentItem.super.ctor(self)

    self:InjectView("Service")
    self:InjectView("Name")
    self:InjectView("Good")
    self:InjectView("Content")
    self:InjectView("Button_nice")
    self:InjectView("Nice_num")
    self:InjectView("Time")
    self:InjectView("Image_1")

    self:OnClick("Button_nice", function()
        --qy.QYPlaySound.stopMusic()
        if delegate and delegate.onNice then
            delegate.onNice(self)
        end
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})
    self.Content:getVirtualRenderer():setMaxLineWidth(450)
end

function CommentItem:setData(data, idx)
    self.entity = data
    if idx >= 3 then
        self.Good:setVisible(false)
    else
        self.Good:setVisible(true)
    end

    local id = idx % 2 == 0 and 6 or 7
    self:update()
end

function CommentItem:update()
    local serviceEntity = qy.tank.model.LoginModel:getDistrictById(self.entity.sec)
    self.Service:setString(serviceEntity.name .. " " .. serviceEntity.s_name)
    self.Name:setString(self.entity.nickname)
    self.Content:setString(self.entity.comment)
    -- self.Good:setVisible()
    self.Nice_num:setString(self.entity.niceNum)
    self.Time:setString(os.date(qy.TextUtil:substitute(1012), self.entity.time))
end

return CommentItem