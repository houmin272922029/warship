local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog)

function MainDialog:ctor(delegate)
   	MainDialog.super.ctor(self)
    -- self:InjectView("BG")
   	-- self:InjectView("BG2")
   	-- self:InjectView("Pages")
    -- self:InjectView("Btn_choose")
    -- self:InjectView("Btn_carray")
    -- self:InjectView("arrowTip") 
    cc.SpriteFrameCache:getInstance():addSpriteFrames("head_treasure/res/res.plist") 

    local style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(925, 555),   
        position = cc.p(0, 0),
        offset = cc.p(0, 0),
        titleUrl = "head_treasure/res/yuanshoubaozang.png",
        
        ["onClose"] = function()
            self:removeSelf()
        end
    })
    self:addChild(style)
    style:setLocalZOrder(-1)
    self.style = style

   

    local view = require("head_treasure.src.MainDialog2").new(self)
    style.bg:addChild(view)
    local x = (display.width - 1080) / 2 
    view:setPosition(-80 - x, -80)

     local digview = require("head_treasure.src.DigView").new()
    digview:setVisible(false)
    self:addChild(digview)

    self.digview = digview

    -- self.Buttom:setLocalZOrder(5)

    -- self:OnClick("Btn_choose", function()
    --     local dialog = require("carray.src.ChooseDialog").new(self)
    --     dialog:show()
    -- end,{["isScale"] = false})

end

return MainDialog
