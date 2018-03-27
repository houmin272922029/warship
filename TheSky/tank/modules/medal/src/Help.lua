

local Help = qy.class("Help", qy.tank.view.BaseDialog, "medal/ui/Help")

function Help:ctor(delegate)
    Help.super.ctor(self)
    self.delegate = delegate
    self:InjectView("bg")
    self:InjectView("pannel")
    self:InjectView("title")
    -- self:OnClick("bg",function ( sender )
    --     self:dismiss()
    -- end)
    self:OnClickForBuilding1("bg",function ( sender )
       self:dismiss()
    end)
end
function Help:onEnter()
    
end

function Help:render(_idx)

end
function Help:onExit()
    
end


return Help
