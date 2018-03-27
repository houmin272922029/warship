local MainRankCell = qy.class("MainRankCell", qy.tank.view.BaseView, "inter_service_arena.ui.MainRankCell")

function MainRankCell:ctor(delegate)
   	MainRankCell.super.ctor(self)

    self:InjectView("bg")
    self:InjectView("Image_rank")
    self:InjectView("Image_king")
    self:InjectView("Text_rank")
    self:InjectView("Text_name")
    self:InjectView("Text_server")
    self:InjectView("Text_power")
end

function MainRankCell:render(data, idx, _type)
    self.entity = data
    self.Image_king:setVisible(false)
    self.Image_rank:setVisible(false)
    self.Text_rank:setVisible(true)

    if _type == "king" then
        self.bg:loadTexture("inter_service_arena/res/11-di.png",0)
        self.Image_king:setVisible(true)
        if idx < 4 then
            self.Text_rank:setVisible(false)
            self.Image_rank:setVisible(true)
            self.Image_rank:loadTexture("inter_service_arena/res/".. idx .."nd_1.png",0)
        end
    elseif _type == "battle" then
        self.bg:loadTexture("inter_service_arena/res/44-di.png",0)
    elseif _type == "sweep" then
        self.bg:loadTexture("inter_service_arena/res/22-di.png",0)
    else
        self.bg:loadTexture("inter_service_arena/res/33-di.png",0)
    end

    self.Text_rank:setString(data.current_rank)
    self.Text_name:setString(data.nickname)
    self.Text_power:setString(data.fight_power)

    local server = string.sub(data.server, 2)
    if server == "youke" then
        self.Text_server:setString(qy.TextUtil:substitute(90297)..qy.TextUtil:substitute(90296))
    else
        self.Text_server:setString(server..qy.TextUtil:substitute(90296))
    end

end

return MainRankCell
