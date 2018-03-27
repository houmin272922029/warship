--[[
    Date: 2015-04-22 17:07:40
]]

local TechnologyDetailNewSelectDialog = qy.class("TechnologyDetailNewSelectDialog", qy.tank.view.BaseDialog, "view/technology/TechnologyDetailNewSelectDialog")

local model = qy.tank.model.TechnologyModel
function TechnologyDetailNewSelectDialog:ctor(delegate)
    TechnologyDetailNewSelectDialog.super.ctor(self)
    self:setCanceledOnTouchOutside(true)

    -- 通用弹窗样式
    local style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(820, 430),
        position = cc.p(0, 0),
        offset = cc.p(0, 0),
        titleUrl = "Resources/common/title/wuzhuangcishu.png",

        ["onClose"] = function()
            self:dismiss()
        end
    })
    self:addChild(style, -1)

    self:OnClick("Image_1",function()
        delegate(1)
        self:removeSelf()
    end)

    self:OnClick("Image_2",function()
        if self.armed_times < 5 then            
            qy.hint:show(qy.TextUtil:substitute(90253))
        else
            delegate(5)
            self:removeSelf()
        end
    end)

    self:OnClick("Image_3",function()
        if self.armed_times < 5 then            
            qy.hint:show(qy.TextUtil:substitute(90253))
        else
            delegate(10)
            self:removeSelf()
        end
    end)


    self:InjectView("Text_5")
    self:InjectView("Text_10")

    self.armed_times = qy.tank.model.VipModel:getTechnologyBuyTimes()[qy.tank.model.UserInfoModel.userInfoEntity.vipLevel]
    self.times_5 = qy.tank.model.VipModel:getTechnology5Level()
    self.times_10 = qy.tank.model.VipModel:getTechnology10Level()


    if self.armed_times < 10 then
        self.Text_10:setString(qy.TextUtil:substitute(90252,self.times_10))
    end

    if self.armed_times < 5 then
        self.Text_5:setString(qy.TextUtil:substitute(90252,self.times_5))
    end

end


return TechnologyDetailNewSelectDialog
