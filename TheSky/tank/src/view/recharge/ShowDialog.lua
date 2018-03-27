local ShowDialog = qy.class("ShowDialog", qy.tank.view.BaseDialog, "view/recharge/ShowDialog")

function ShowDialog:ctor(delegate)
	ShowDialog.super.ctor(self)
	self.delegate = delegate
    self:InjectView("Button_1")

	self.style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(600,300),
        position = cc.p(0,0),
        offset = cc.p(4,0), 

        ["onClose"] = function()
            self:dismiss()
        end
    }) 
    self.style.title_bg:setVisible(false)
    self:addChild(self.style , -1)

    self:OnClick("Button_1", function()
    	qy.tank.utils.SDK:bindAccount(function()
            qy.hint:show("Facebook account bind successful")
            self:removeSelf()
        end,function()
            self:removeSelf()
        end)
   	end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})
end


return ShowDialog