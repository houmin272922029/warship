

local Awarditem = qy.class("Awarditem", qy.tank.view.BaseView, "break_fireline/ui/Awarditem")


function Awarditem:ctor(delegate)
    Awarditem.super.ctor(self)
    self.model = qy.tank.model.BreakFireModel
    local service = qy.tank.service.OperatingActivitiesService
    self:InjectView("bg")
    self:InjectView("img")--进度
    self.types = delegate.types
    self:OnClick("bg", function(sender)
        require("break_fireline.src.Tip").new({
            ["num"] = delegate.num,
            ["types"] = delegate.types,
            ["callback"] = function ( data )
                delegate.callback(data)
            end
        }):show()
    end)
    self:update()
end

function Awarditem:update(  )
    if self.types == 2 then
        self.img:loadTexture("break_fireline/res/1.png",0)
        self.bg:loadTexture("break_fireline/res/type2.png",0)
    else
        self.img:loadTexture("break_fireline/res/yiwen.png",0)
        self.bg:loadTexture("break_fireline/res/type3.png",0)
    end
end

return Awarditem
