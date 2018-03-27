local TeamCell = qy.class("TeamCell", qy.tank.view.BaseView, "all_servers_group_battles.ui.TeamCell")


function TeamCell:ctor(delegate)
	self.model = qy.tank.model.AllServersGroupBattlesModel    
    self.service = qy.tank.service.AllServersGroupBattlesService

   	TeamCell.super.ctor(self)
    self.delegate = delegate

    for i = 2, 5 do
        self:InjectView("Img_people_"..i)
        self:InjectView("Text_name_"..i)
        self:InjectView("Img_lock_"..i)
        self:InjectView("Text_wait_"..i)
        self:InjectView("Text_server_name_"..i)        
    end

    self:InjectView("Img_captain")
    self:InjectView("Text_captain_name")
    self:InjectView("Text_captain_server_name")
    self:InjectView("Btn_join")
    self:InjectView("Img_full")

    self:OnClick(self.Btn_join, function(sender)
        if self.Btn_join:isBright() then
            self.service:joinTeam(function(data)
                delegate.callback()
            end, self.team_id)
        end
    end,{["isScale"] = false})    
end



function TeamCell:render(_data, _idx)
    self.team_id = _data.team_id
    for i = #_data.member_info + 1, 5 do
        self["Img_people_"..i]:setVisible(false)
        self["Text_name_"..i]:setVisible(false)
        self["Img_lock_"..i]:setVisible(false)
        self["Text_wait_"..i]:setVisible(true)
    end
    for i = self.model.totalscene_list[self.model.select_scene_id].max_member + 1, 5 do
        self["Img_people_"..i]:setVisible(false)
        self["Text_name_"..i]:setVisible(false)
        self["Img_lock_"..i]:setVisible(true)
        self["Text_wait_"..i]:setVisible(false)
    end

    if #_data.member_info == self.model.totalscene_list[self.model.select_scene_id].max_member then
        self.Btn_join:setVisible(false)
        self.Img_full:setVisible(true)
    else
        self.Btn_join:setVisible(true)
        self.Img_full:setVisible(false)
    end


    for i = 1, #_data.member_info do
        if _data.member_info[i].user_info.kid == _data.leader_kid then
            self.Img_captain:setTexture(qy.tank.utils.UserResUtil.getRoleIconByHeadType(_data.member_info[i].user_info.headicon))
            self.Text_captain_name:setString(_data.member_info[i].user_info.nickname)            
            self.Text_captain_server_name:setString(_data.member_info[i].user_info.server_name)
        else
            self["Img_people_"..i]:setVisible(true)
            self["Text_name_"..i]:setVisible(true)
            self["Img_lock_"..i]:setVisible(false)
            self["Text_wait_"..i]:setVisible(false)
            self["Img_people_"..i]:setTexture(qy.tank.utils.UserResUtil.getRoleIconByHeadType(_data.member_info[i].user_info.headicon))
            self["Text_name_"..i]:setString(_data.member_info[i].user_info.nickname)
            self["Text_server_name_"..i]:setString(_data.member_info[i].user_info.server_name)
        end
    end

    if self.model.user_info.team_id ~= "" and self.model.team_info then
        self.Btn_join:setBright(false)
    else
        self.Btn_join:setBright(true)
    end

end

return TeamCell