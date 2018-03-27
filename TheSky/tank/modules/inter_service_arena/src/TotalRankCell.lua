local TotalRankCell = qy.class("TotalRankCell", qy.tank.view.BaseView, "inter_service_arena.ui.TotalRankCell")

function TotalRankCell:ctor(delegate)
   	TotalRankCell.super.ctor(self)

    self:InjectView("Img_stage")
    self:InjectView("Img_stage_num")
    self:InjectView("Img_user_icon")
    self:InjectView("Image_rank")
    
    self:InjectView("Text_name")
    self:InjectView("Text_server")
    self:InjectView("Text_lv")
    self:InjectView("Text_legion_name")
    self:InjectView("Text_rank")
    self:InjectView("Text_rank2")
    self:InjectView("Text_power")

    self.model = qy.tank.model.InterServiceArenaModel
end

function TotalRankCell:render(data, idx)
    
    self.Text_power:setString(data.fight_power)
    self.Text_name:setString(data.nickname)
    self.Text_lv:setString("LV."..data.level)

    self.Img_user_icon:loadTexture(qy.tank.utils.UserResUtil.getRoleIconByHeadType(data.headicon))

    local icon, num = self.model:getStageIcon(data.stage)
    self.Img_stage:loadTexture("inter_service_arena/res/stage_name2_".. icon ..".png",0)
    if num and num > 0 then
        self.Img_stage_num:setVisible(true)
        self.Img_stage_num:loadTexture("inter_service_arena/res/stage_num2_".. num ..".png",0)
        self.Img_stage:setPositionX(515)
    else
        self.Img_stage_num:setVisible(false)
        self.Img_stage:setPositionX(535)
    end

    if data.rank < 4 then
        self.Text_rank:setVisible(false)
        self.Image_rank:setVisible(true)
        self.Image_rank:loadTexture("inter_service_arena/res/".. data.rank .."nd_1.png",0)
    else
        self.Text_rank:setVisible(true)
        self.Image_rank:setVisible(false)
        self.Text_rank:setString(data.rank)
    end

    if string.len(data.legion_name) > 0 then
        self.Text_legion_name:setString(data.legion_name)
    else
        self.Text_legion_name:setString(qy.TextUtil:substitute(90202))
    end

    self.Text_rank2:setString(qy.TextUtil:substitute(50023, data.current_rank))

    local server = string.sub(data.server, 2)
    if server == "youke" then
        self.Text_server:setString(qy.TextUtil:substitute(90297)..qy.TextUtil:substitute(90296))
    else
        self.Text_server:setString(server..qy.TextUtil:substitute(90296))
    end

end

return TotalRankCell
