--[[
    改名
    Author: liajian
	Date: 2015-06-29 18:10:18
]]

local ChangeName = qy.class("ChangeName", qy.tank.view.BaseDialog, "view/common/ChangeName")

local userModel = qy.tank.model.UserInfoModel
 local service = qy.tank.service.StorageService


function ChangeName:ctor(delegate)
    ChangeName.super.ctor(self)

    -- 内容样式
    self:InjectView("name")
    self:InjectView("imputbg")
    self:InjectView("cancelBt")
    self:InjectView("okBt")
    self:OnClick("cancelBt", function(sender)
    	self:removeSelf()
    end)

    self:OnClick("okBt", function(sender)
        local checkStr = self.accountTxt:getText()
         if #checkStr <= 0 then
            qy.hint:show("请输入昵称")
            return
         end
         local function callBack(flag)
            if qy.TextUtil:substitute(37011) == flag then
                service:use3(150,1,checkStr,function(data)
                    qy.hint:show("修改成功")
                    self:removeSelf()
                end) 
            end
        end
        self.accountTxt:setText("")
        qy.alert:show(qy.TextUtil:substitute(37032),  "确认修改昵称？", cc.size(560,250), {{qy.TextUtil:substitute(37015) , 4},{qy.TextUtil:substitute(37011) , 5} }, callBack, {})
      
    end)
    self.name:setString(userModel.userInfoEntity.name)
    self.accountTxt = ccui.EditBox:create(cc.size(200, 40), "Resources/common/bg/c_12.bg")
    self.accountTxt:setPosition(100,23)
    self.accountTxt:setFontSize(24)
    self.accountTxt:setInputMode(6)
    self.accountTxt:setPlaceholderFontSize(24)
    self.accountTxt:setMaxLength(7)
   
    self.accountTxt:setPlaceHolder("请输入新昵称")
    if self.accountTxt.setReturnType then
        self.accountTxt:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    end
    self.imputbg:addChild(self.accountTxt)
end

return ChangeName

