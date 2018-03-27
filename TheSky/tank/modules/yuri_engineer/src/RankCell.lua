local RankCell = qy.class("RankCell", qy.tank.view.BaseView, "yuri_engineer.ui.RankCell")

function RankCell:ctor(delegate)
   	RankCell.super.ctor(self)

    self:InjectView("bg")
    self:InjectView("Image_rank")
    self:InjectView("Text_rank")
    self:InjectView("Text_name")
    self:InjectView("Text_power")
end

function RankCell:render(data, idx)
    self.entity = data
    self.Image_rank:setVisible(false)
    self.Text_rank:setVisible(true)

    if idx == 1 then
        self.bg:loadTexture("yuri_engineer/res/11-di.png",0)
    elseif idx == 2 then
        self.bg:loadTexture("yuri_engineer/res/22-di.png",0)
    elseif idx == 3 then
        self.bg:loadTexture("yuri_engineer/res/33-di.png",0)
    else
        self.bg:loadTexture("yuri_engineer/res/33-di.png",0)
    end

    if data.rank < 4 then
        self.Text_rank:setVisible(false)
        self.Image_rank:setVisible(true)
        self.Image_rank:loadTexture("yuri_engineer/res/".. data.rank .."nd.png",0)
    end

    self.Text_rank:setString(data.rank)
    self.Text_name:setString("【"..data.server.."】"..data.nickname)
    self.Text_power:setString(data.share)


end

return RankCell
