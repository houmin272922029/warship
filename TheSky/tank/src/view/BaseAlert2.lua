local BaseAlert2 = qy.class("BaseAlert2", qy.tank.view.BaseDialog, "view/alert/BaseAlert2")

function BaseAlert2:ctor(delegate)
    BaseAlert2.super.ctor(self)

    self.delegate = delegate
    self:InjectView("close")
   

    self:OnClick(self.close, function()
        qy.tank.manager.ScenesManager:showLoginScene()
    end)

  
end


return BaseAlert2
