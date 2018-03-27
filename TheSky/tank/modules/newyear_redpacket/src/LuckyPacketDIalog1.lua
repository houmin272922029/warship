

local LuckyPacketDIalog1 = qy.class("LuckyPacketDIalog1", qy.tank.view.BaseDialog, "newyear_redpacket/ui/LuckyPacketDIalog1")

local model = qy.tank.model.RedPacketModel
local service = qy.tank.service.RedPacketService

function LuckyPacketDIalog1:ctor(delegate)
    LuckyPacketDIalog1.super.ctor(self)
	self:InjectView("title")--名称
	self:InjectView("closeBt")
	self:InjectView("totalnum")
	self:InjectView("open")
	self:InjectView("Image_47")--输入框
	self:InjectView("miaoshu")--描述
	self:InjectView("headicon")
 
   
	self:OnClick("closeBt",function(sender)
        self:removeSelf()
    end)
    self:OnClick("open", function ( sender )
    	local numberstring = tonumber(self.accountTxt:getText())
        local checkStr = self.accountTxt:getText()
        local tempnum = 0
        if #checkStr > 0 then
            for i=1,#checkStr do
                local curByte = string.byte(checkStr, i)
                if curByte > 57 or curByte < 48 then
                    qy.hint:show("请输入数字")
                    return
                else
                	tempnum = numberstring
                end
            end
        else
            tempnum = 0
        end
     	--打开操作
     	if qy.tank.model.UserInfoModel.userInfoEntity.diamond < tempnum then
     		self:removeSelf()
     		qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.DIAMOND_NOT_ENOUGH)
     		return
     	end
     	

     	service:openluckyredpacket(delegate.range,self.data.type,self.data.id,tempnum,function ( datas )
			print("ssssssssssssss",json.encode(datas))
			if datas.status == 5 then
				qy.hint:show("很遗憾，开启红包失败，再接再厉！")
				if self.type == 2 then
					model.red_pack_list_system[delegate.id].total = datas.fail_total
				elseif self.type == 3 then
					model.red_pack_list_world[delegate.id].total = datas.fail_total
				else
					model.red_pack_list_legion[delegate.id].total = datas.fail_total
				end
				self.totalnum:setString(datas.fail_total)
			else
				if self.type == 2 then
					model.red_pack_list_system[delegate.id].status = datas.status
				elseif self.type == 3 then
					model.red_pack_list_world[delegate.id].status = datas.status
				else
					model.red_pack_list_legion[delegate.id].status = datas.status
				end
				delegate:callback()
				self:removeSelf()
				local dialog = require("newyear_redpacket.src.LuckyPacketDIalog2").new({
	 			["data"]= datas,
	 			["type"] = self.type
	 			})
 				dialog:show(true)
			end
		end)
    end)
    self.accountTxt = ccui.EditBox:create(cc.size(400, 60), "Resources/common/bg/c_12.bg")
    self.accountTxt:setPosition(205,30)
    self.accountTxt:setFontSize(24)
    self.accountTxt:setInputMode(6)
    self.accountTxt:setPlaceholderFontSize(22)
    -- self.accountTxt:setMaxLength(5)
   
    self.accountTxt:setPlaceHolder("填写投入金额")
    if self.accountTxt.setReturnType then
        self.accountTxt:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    end
    self.Image_47:addChild(self.accountTxt)
    self.data = delegate.data
    self.type = delegate.type
    self:update()

end
function LuckyPacketDIalog1:update()
    self.miaoshu:setString(self.data.content)
    self.totalnum:setString(self.data.total)
    if self.type == 2 then
     	self.title:setString("系统红包")
    else
     	self.title:setString(self.data.name.."的幸运红包")
    end
    local png = "Resources/user/icon_"..self.data.headicon..".png"
    print("头像啊",png)
    if self.data.headicon ~= "" then
    	self.headicon:loadTexture(png)
    end
end
function LuckyPacketDIalog1:onEnter()
     
end

function LuckyPacketDIalog1:onExit()
  
end


return LuckyPacketDIalog1
