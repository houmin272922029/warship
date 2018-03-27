local GroupBattlesTeamCell = qy.class("GroupBattlesTeamCell", qy.tank.view.BaseView, "group_battles.ui.GroupBattlesTeamCell")

local model = qy.tank.model.GroupBattlesModel
local service = qy.tank.service.GroupBattlesService

function GroupBattlesTeamCell:ctor(delegate)
   	GroupBattlesTeamCell.super.ctor(self)

    self:InjectView("Leader")
    self:InjectView("Name")
    self:InjectView("Btn")
    self:InjectView("Txt_shenqing")
    self:InjectView("Txt_yichu")
    self:InjectView("Level")
    self:InjectView("Txt_no_teammate")
    self.delegate = delegate

end

function GroupBattlesTeamCell:render(data, _idx)

    if data ~= nil then
        self.Name:setVisible(true)
        self.Level:setVisible(true)
        self.Txt_no_teammate:setVisible(false)

        self.Name:setString(data.nickname)
        self.Level:setString("LV"..data.level)

        if model:getStatus() == 0 then

            self.Btn:setVisible(true)
            self.Txt_shenqing:setVisible(true)
            self.Txt_yichu:setVisible(false)

            self:OnClick(self.Btn, function(sender)
                service:joinTeam(function(data)
                    self.delegate:update()
                end, data.team_name, model:getCurrentSceneId()) 
            end,{["isScale"] = false})

        elseif model:getStatus() == 1 or data.kid == qy.tank.model.UserInfoModel.userInfoEntity.kid then
            self.Btn:setVisible(false)
        else 
            self.Btn:setVisible(true)        
            self.Txt_yichu:setVisible(true)

            self:OnClick(self.Btn, function(sender)
                service:removeTeam(function(data)
                    self.delegate:update()
                end, data.kid) 
            end,{["isScale"] = false})
        end

        if data.role == 100 then
            self.Leader:setVisible(true)
        else
            self.Leader:setVisible(false)
        end
    else 
        self.Name:setVisible(false)
        self.Level:setVisible(false)
        self.Leader:setVisible(false)
        self.Btn:setVisible(false)
        self.Txt_no_teammate:setVisible(true)
    end

    

end

return GroupBattlesTeamCell