
local Tip2 = qy.class("Tip2", qy.tank.view.BaseDialog, "medal/ui/Tip2")


function Tip2:ctor(delegate)
    Tip2.super.ctor(self)
    self.delegate = delegate
    self:setCanceledOnTouchOutside(true)
end
function Tip2:onEnter()
    
end

function Tip2:onExit()
    
end


return Tip2
