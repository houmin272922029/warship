local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog)

function MainDialog:ctor(delegate)
   	MainDialog.super.ctor(self)
    -- self:InjectView("BG")
   	-- self:InjectView("BG2")
   	-- self:InjectView("Pages")
    -- self:InjectView("Btn_choose")
    -- self:InjectView("Btn_carray")
    -- self:InjectView("arrowTip")  

    local style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(905, 505),   
        position = cc.p(0, 0),
        offset = cc.p(0, 0),
        titleUrl = "iron_mine/res/jingtiekuangmai.png",
        
        ["onClose"] = function()
            self:removeSelf()
        end
    })
    self:addChild(style)
    style:setLocalZOrder(-1)
    self.style = style

    local view = require("iron_mine.src.MainDialog2").new()
    style.bg:addChild(view)
    local x = (display.width - 1080) / 2 
    view:setPosition(-100 - x, -120)

    

    -- self.Buttom:setLocalZOrder(5)

    -- self:OnClick("Btn_choose", function()
    --     local dialog = require("carray.src.ChooseDialog").new(self)
    --     dialog:show()
    -- end,{["isScale"] = false})

end

return MainDialog
