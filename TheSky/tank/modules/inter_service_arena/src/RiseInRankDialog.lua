local RiseInRankDialog = qy.class("RiseInRankDialog", qy.tank.view.BaseDialog, "inter_service_arena.ui.RiseInRankDialog")



function RiseInRankDialog:ctor(callback)
   	RiseInRankDialog.super.ctor(self)

    self.model = qy.tank.model.InterServiceArenaModel

   	self:InjectView("Img_stage_icon")
    self:InjectView("Text_name")
    self:InjectView("Text_txt")
    self:InjectView("Img_stage_name")
    self:InjectView("Img_stage_num")

    self:OnClick("Btn_confirm", function()
        self:dismiss()
    end,{["isScale"] = false})


    self.Text_name:setString(qy.tank.model.UserInfoModel.userInfoEntity.name)
    self.Text_txt:setString(qy.TextUtil:substitute(90301, self.model.stage_config[tostring(self.model.stage_num)].name))

    local icon, num = self.model:getStageIcon()

    self.Img_stage_icon:loadTexture("inter_service_arena/res/stage_icon_".. icon ..".png",0)
    self.Img_stage_name:loadTexture("inter_service_arena/res/stage_name2_".. icon ..".png",0)

    if num and num > 0 then
        self.Img_stage_num:loadTexture("inter_service_arena/res/stage_num2_".. num ..".png",0)
        self.Img_stage_num:setVisible(true)
        self.Img_stage_name:setPositionX(39 + (3 - num) * 5) 
    else
        self.Img_stage_num:setVisible(false)
        self.Img_stage_name:setPositionX(55)
    end
end



return RiseInRankDialog
