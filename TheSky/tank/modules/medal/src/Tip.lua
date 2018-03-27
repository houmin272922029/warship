
local Tip = qy.class("Tip", qy.tank.view.BaseDialog, "medal/ui/Tip")


function Tip:ctor(delegate)
    Tip.super.ctor(self)
    self.delegate = delegate
    self:setCanceledOnTouchOutside(true)
end
function Tip:onEnter()
    
end

function Tip:onExit()
    
end


return Tip
