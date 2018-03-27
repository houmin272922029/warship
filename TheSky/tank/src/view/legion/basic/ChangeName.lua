--[[
    改名
    Author: liajian
	Date: 2015-06-29 18:10:18
]]

local ChangeName = qy.class("ChangeName", qy.tank.view.BaseDialog, "legion/ui/basic//ChangeName")

local userModel = qy.tank.model.UserInfoModel
 local service = qy.tank.service.LegionService


function ChangeName:ctor(delegate)
    ChangeName.super.ctor(self)

    -- 内容样式
    self.model = qy.tank.model.LegionModel
    self:InjectView("legionname")
    self:InjectView("imputbg")
    self:InjectView("cancelBt")
    self:InjectView("okBt")
    self:InjectView("xiaohaotext")
    self:InjectView("xiaohao")
    self:InjectView("Image_7")--消耗的钻石数
    self:InjectView("havenum")

    self:OnClick("cancelBt", function(sender)
    	self:removeSelf()
    end)

    self:OnClick("okBt", function(sender)
        local checkStr = self.accountTxt:getText()
        if #checkStr <= 0 then
            qy.hint:show("请输入名称")
            return
        end
        local function callBack(flag)
            if qy.TextUtil:substitute(37011) == flag then
                service:changeName(checkStr,function(data)
                    qy.hint:show("修改成功")
                    delegate.callback(checkStr)
                    self:removeSelf()
                end) 
            end
        end
        self.accountTxt:setText("")
        qy.alert:show(qy.TextUtil:substitute(37032),  "确认修改名称？", cc.size(560,250), {{qy.TextUtil:substitute(37015) , 4},{qy.TextUtil:substitute(37011) , 5} }, callBack, {})
    end)
    self.legionname:setString(self.model:getHisLegion().name)
    self.havenum:setString(userModel.userInfoEntity.diamond)
    self.accountTxt = ccui.EditBox:create(cc.size(160, 40), "Resources/common/bg/c_12.bg")
    self.accountTxt:setPosition(84,26)
    self.accountTxt:setFontSize(22)
    self.accountTxt:setInputMode(6)
    self.accountTxt:setPlaceholderFontSize(22)
    self.accountTxt:setMaxLength(5)
   
    self.accountTxt:setPlaceHolder("请输入新名称")
    if self.accountTxt.setReturnType then
        self.accountTxt:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    end
    self.imputbg:addChild(self.accountTxt)
    self.Image_7:setVisible(self.model.can_set_name_free == 0)
    if self.model.can_set_name_free == 0 then
        self.xiaohaotext:setPosition(cc.p(72,41))
        self.xiaohao:setString(self.model.set_name_cost)
    else
        self.xiaohaotext:setPosition(cc.p(107,41))
        self.xiaohao:setString("本次免费")
    end
end

return ChangeName

