local AwardDialog = qy.class("AwardDialog", qy.tank.view.BaseDialog, "god_worship.ui.AwardDialog")


function AwardDialog:ctor(callback)
   	AwardDialog.super.ctor(self)

    self.model = qy.tank.model.GodWorshipModel
    self.service = qy.tank.service.GodWorshipService

   	self.style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(520,330),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "god_worship/res/6.png",
        bgShow = false,

        ["onClose"] = function()            
            if callback then
              callback()
            end
            self:removeSelf()
        end
    })
    self:addChild(self.style)

   	self:InjectView("Bg")
    self:InjectView("Btn_get")
    self:InjectView("Img_yilingqu")

    self:OnClick("Btn_get", function()
        self.service:getAward(function(data)
            qy.tank.command.AwardCommand:add(data.award)
            qy.tank.command.AwardCommand:show(data.award)
            if callback then
              callback()
            end
            self:removeSelf()
        end, 2)
    end,{["isScale"] = false})


    self.award_1 = qy.AwardList.new({
        ["award"] = self.model.extends_data,
        ["cellSize"] = cc.size(120,180),
        ["type"] = 1,
        ["itemSize"] = 2,
        ["len"] = 4,
        ["hasName"] = false,
    })
    self.award_1:setPosition(50,280)
    self.Bg:addChild(self.award_1)

    if self.model.awarded > 0 then
        self.Btn_get:setVisible(false)
        self.Img_yilingqu:setVisible(true)
    end


    if self.model.times < 3 or self.model.awarded > 0 then
      self.Btn_get:setBright(false)
    else
      self.Btn_get:setBright(true)
    end
end

return AwardDialog
