local Buff2Tip = qy.class("Buff2Tip", qy.tank.view.BaseDialog, "service_faction_war/ui/Buff2Tip")


function Buff2Tip:ctor(delegate)
    Buff2Tip.super.ctor(self)
    self.delegate = delegate
    self:setCanceledOnTouchOutside(true)
end
function Buff2Tip:onEnter()
    
end

function Buff2Tip:onExit()
    
end


return Buff2Tip