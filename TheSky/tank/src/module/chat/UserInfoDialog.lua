local UserInfoDialog = qy.class("UserInfoDialog", qy.tank.view.BaseDialog, "view.chat.UserInfoDialog")

local DialogStyle5 = qy.tank.view.style.DialogStyle5
local UserResUtil = qy.tank.utils.UserResUtil

function UserInfoDialog:ctor(user, listener)
    UserInfoDialog.super.ctor(self)
    self:setCanceledOnTouchOutside(true)

    local style = DialogStyle5.new({
        size = cc.size(564,300),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        -- ["onClose"] = function()
        --     self:dismiss()
        -- end
    })
    self:addChild(style , -1)

    self:OnClick("Btn_private", function()
        self:dismiss()
        listener.onPrivate(user)
    end)

    self:OnClick("Btn_email", function()
        self:dismiss()
        listener.onEmail(user)
    end)

    self:OnClick("Btn_info", function()
        self:dismiss()
        listener.onInfo(user)
    end)

    self:OnClick("Btn_block", function()
        listener.onBlock(user)
    end)

    self:OnClick("Btn_battle", function()
        self:dismiss()
        listener.onBattle(user)
    end)

    self:InjectView("Text_name")
    self:InjectView("Text_level")
    self:InjectView("Image_icon")
    self:InjectView("Text_1_0_0_0")
    print(json.encode(user))
    self.Text_name:setString(user.name or "")
    self.Text_level:setString(user.level or "0")
    self.Image_icon:loadTexture(UserResUtil.getRoleIconByHeadType(user.icon))
    self.Text_1_0_0_0:setString(user.login_name or qy.TextUtil:substitute(90019))
end

return UserInfoDialog
