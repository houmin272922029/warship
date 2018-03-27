local Choose = qy.class("Choose", qy.tank.view.BaseView, "lucky_draw.ui.Choose")

local service = qy.tank.service.LuckyDrawService
local model = qy.tank.model.LuckyDrawModel

function Choose:ctor(delegate)
   	Choose.super.ctor(self)
end
return Choose