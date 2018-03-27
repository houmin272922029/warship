local Cell = qy.class("Cell", qy.tank.view.BaseView, "all_servers_group_battles.ui.Cell")


function Cell:ctor(delegate)
	self.model = qy.tank.model.AllServersGroupBattlesModel

   	Cell.super.ctor(self)
    self.delegate = delegate

    self:InjectView("bg")
    self:InjectView("Img_selected")
    self:InjectView("Img_name")
    self:InjectView("Text_time")
    
    self.changeColorUi1 = {self.bg, self.Img_selected, self.Img_name, self.Text_time}

    for k = 1, #self.changeColorUi1 do
        qy.tank.utils.NodeUtil:darkNode(self.changeColorUi1[k],true)
    end


end

function Cell:render(_data, _idx)
    
    for k = 1, #self.changeColorUi1 do
        qy.tank.utils.NodeUtil:darkNode(self.changeColorUi1[k],true)
    end
    
    self.Img_name:setTexture("all_servers_group_battles/res/scene_".._data.id..".png")
    self.Text_time:setString(_data.open_time_discribe)
    local nums =  (self.model.select_scene_id > 4) and (self.model.select_scene_id - 4) or self.model.select_scene_id
    if _idx == nums then
    	self.Img_selected:setVisible(true)
    else
    	self.Img_selected:setVisible(false)
    end


    for i = 1, #self.model.today_scene_id do
    	if self.model.today_scene_id[i] == _data.id then
		    for k = 1, #self.changeColorUi1 do
		        qy.tank.utils.NodeUtil:darkNode(self.changeColorUi1[k],false)
		    end
		end
	end
    if _idx < 5 then
        self.bg:setTexture("all_servers_group_battles/res/10.jpg")
    else
        self.bg:setTexture("all_servers_group_battles/res/100.png")
    end
end

return Cell