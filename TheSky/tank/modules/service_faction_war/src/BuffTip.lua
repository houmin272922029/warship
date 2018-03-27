local BuffTip = qy.class("BuffTip", qy.tank.view.BaseDialog, "service_faction_war/ui/BuffTip")


function BuffTip:ctor(delegate)
    BuffTip.super.ctor(self)
    self.delegate = delegate
    self:setCanceledOnTouchOutside(true)
end
function BuffTip:onEnter()
    
end

function BuffTip:onExit()
    
end


return BuffTip