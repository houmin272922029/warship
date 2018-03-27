

local LuckyPacketDIalog2 = qy.class("LuckyPacketDIalog2", qy.tank.view.BaseDialog, "newyear_redpacket/ui/LuckyPacketDialog2")

local model = qy.tank.model.RedPacketModel
local service = qy.tank.service.RedPacketService

function LuckyPacketDIalog2:ctor(delegate)
    LuckyPacketDIalog2.super.ctor(self)
	self:InjectView("title")--名称
	self:InjectView("closeBt")
	self:InjectView("totalnum")
	self:InjectView("miaoshu")--描述
	self:InjectView("headicon")
	self:InjectView("headicon2")--领取人的头像
	self:InjectView("lingquname")--领取人的名字
	self:InjectView("totalnums")--金额总数
	self:InjectView("allnum")--总尝试次数
	self:InjectView("chushinum")--初始金额
	self:InjectView("lingqunum")--领取人尝试次数
	self:InjectView("Image_10")
	self:InjectView("Text_19")
	self:InjectView("Image_44")
	self:InjectView("totalnum")
 
   
	self:OnClick("closeBt", function(sender)
        self:removeSelf()
    end)
    self.data = delegate.data
    self.type = delegate.type
    self:update()

end
function LuckyPacketDIalog2:update(  )
	if self.type == 2 then
		self.title:setString("系统的幸运红包")
		self.Text_19:setVisible(false)
		self.Image_44:setVisible(false)
		self.totalnum:setVisible(false)
	else
		self.Text_19:setVisible(true)
		self.Image_44:setVisible(true)
		self.totalnum:setVisible(true)
		self.title:setString(self.data.sender_name.."的幸运红包")
	end
	self.miaoshu:setString(self.data.content)
	self.totalnum:setString(self.data.shard_diamond)
	self.lingquname:setString(self.data.clist.name)
	self.totalnums:setString(self.data.clist.diamond)
	self.allnum:setString(self.data.clist.total_times)
	self.chushinum:setString(self.data.clist.init)
	self.lingqunum:setString(self.data.clist.try_times)
	local png = "Resources/user/icon_"..self.data.sender_headicon..".png"
    if self.data.headicon ~= "" then
    	self.headicon:loadTexture(png)
    end
    if  self.data.clist.name == "" then
    	self.lingquname:setString("无")
    	self.headicon2:setVisible(false)
    	self.Image_10:setVisible(false)
    else
    	self.headicon2:setVisible(true)
    	self.Image_10:setVisible(true)
    	if self.data.clist.headicon ~= nil then
    		local png = "Resources/user/icon_"..self.data.clist.headicon..".png"
    		self.headicon2:setVisible(true)
    		self.headicon2:loadTexture(png)
    	else
    		self.headicon2:setVisible(false)
    	end
    	
    end
end

function LuckyPacketDIalog2:onEnter()
     
end

function LuckyPacketDIalog2:onExit()
  
end


return LuckyPacketDIalog2
