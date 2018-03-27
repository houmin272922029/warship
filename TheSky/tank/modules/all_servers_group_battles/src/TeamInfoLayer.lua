--[[
    跨服副本
]]
local TeamInfoLayer = qy.class("TeamInfoLayer", qy.tank.view.BaseDialog, "all_servers_group_battles.ui.TeamLayer")


function TeamInfoLayer:ctor(delegate)
    TeamInfoLayer.super.ctor(self)

    self.model = qy.tank.model.AllServersGroupBattlesModel
    self.service = qy.tank.service.AllServersGroupBattlesService
    self.delegate = delegate

    self:InjectView("bg")
    self:InjectView("Btn_close")
    self:InjectView("Btn_out")
    self:InjectView("Btn_begin")
    self:InjectView("Btn_ready")
    self:InjectView("Btn_ready_txt")


    for i = 1, 5 do
        self:InjectView("Node_"..i.."_"..i)

        self:InjectView("Img_people_"..i)
        self:InjectView("Text_name_"..i)
        self:InjectView("Text_server_name_"..i)
        self:InjectView("Text_level_"..i)
        self:InjectView("Text_power_"..i)

        self:InjectView("Btn_rem_"..i)   
        self:InjectView("Text_status_"..i)   
        self:InjectView("Img_lock_"..i)   
        self:InjectView("Img_wait_"..i)
    end
    

    self.status = 0
    
    for i = 2, 5 do 
        self:OnClick(self["Btn_rem_"..i], function(sender)
            self:juide()
            self.service:expelMember(function(data)     
                self:update()
            end, self.model.team_info.member_info[i].user_info.kid)
        end,{["isScale"] = false})
    end

    self:OnClick(self.Btn_begin, function(sender)
        self:juide()
        self.service:start(function(data)            
            qy.tank.model.WarGroupModel:setBattleAward(response.data.award)
            model:showBattle(response.data.battle)
        end)
    end,{["isScale"] = false})


    self:OnClick(self.Btn_out, function(sender)
        self:juide()
        if self.ready == 1 then
            qy.hint:show("请先取消准备")
        else
            qy.alert:show({"提示", {255, 255, 255}},"真的要退出队伍吗", cc.size(500,300),{{qy.TextUtil:substitute(46006),4},{qy.TextUtil:substitute(46007),5}},function(label)
                if label == qy.TextUtil:substitute(46007) then
                    self.service:leaveTeam(function(data)     
                        if self.model == nil or self.model.user_info.team_id == "" then
                            qy.hint:show("你离开了队伍")
                            delegate.viewStack:pop()
                        end
                    end)
                end
            end)            
        end
    end,{["isScale"] = false})


    self:OnClick(self.Btn_close, function(sender)
        self:juide()
        if self.ready == 1 then
            qy.hint:show("请先取消准备")
        else
            local num = 1
            print("返回了啊",#self.model.team_info.member_info)
            if self.model.team_info then
                num = #self.model.team_info.member_info
            end
            if num <= 1 then
                self.service:leaveTeam(function(data)     
                    delegate.viewStack:pop()
                end)
            else
                delegate.viewStack:pop()
            end
        end
    end,{["isScale"] = false})


    self:OnClick(self.Btn_ready, function(sender)
        self:juide()
        self.service:ready(function(data)     
            self:update()
        end)
    end,{["isScale"] = false})



    self:update()
end






function TeamInfoLayer:update()
    --if self.model.user_info.team_id == "" and self.model.type == 400 then
    

    for i = 2, 5 do
        if self.model.team_info.member_info and #self.model.team_info.member_info < i then
            self["Node_"..i.."_"..i]:setVisible(false)
            self["Img_lock_"..i]:setVisible(false)
            self["Img_wait_"..i]:setVisible(true)
        else
            self["Node_"..i.."_"..i]:setVisible(true)
            self["Img_lock_"..i]:setVisible(false)
            self["Img_wait_"..i]:setVisible(false)
        end
    end
    for i = self.model.totalscene_list[self.model.select_scene_id].max_member + 1, 5 do
        self["Node_"..i.."_"..i]:setVisible(false)
        self["Img_lock_"..i]:setVisible(true)
        self["Img_wait_"..i]:setVisible(false)
    end



    for i = 1, 5 do
        if self.model.team_info.member_info and #self.model.team_info.member_info >= i then
            self["Img_people_"..i]:setTexture(qy.tank.utils.UserResUtil.getRoleIconByHeadType(self.model.team_info.member_info[i].user_info.headicon))
            self["Text_server_name_"..i]:setString(self.model.team_info.member_info[i].user_info.server_name)
            self["Text_level_"..i]:setString(self.model.team_info.member_info[i].user_info.level)
            self["Text_power_"..i]:setString(self.model.team_info.member_info[i].user_info.fight_power)
            self["Text_name_"..i]:setString(self.model.team_info.member_info[i].user_info.nickname)

            if self["Text_status_"..i] then 
                if self.model.team_info.member_info[i].user_info.ready == 0 then
                    self["Text_status_"..i]:setString("未准备")
                    self["Text_status_"..i]:setColor(cc.c4b(0, 255, 0,255))
                else
                    self["Text_status_"..i]:setString("准备完毕")
                    self["Text_status_"..i]:setColor(cc.c4b(194, 125, 5,255))
                end

                if self.model.team_info.member_info[i].user_info.kid == qy.tank.model.UserInfoModel.userInfoEntity.kid then
                    self.ready = self.model.team_info.member_info[i].user_info.ready
                end 
            end
        end
    end


    if self.model.team_info.leader_kid == qy.tank.model.UserInfoModel.userInfoEntity.kid then
        self.ready = 0
        self.Btn_begin:setVisible(true)
        self.Btn_ready:setVisible(false)

        for i = 2, 5 do
            self["Btn_rem_"..i]:setVisible(true)
        end
    else
        for i = 2, 5 do
            self["Btn_rem_"..i]:setVisible(false)
        end

        self.Btn_begin:setVisible(false)
        self.Btn_ready:setVisible(true)

        if self.ready == 1 then 
            self.Btn_ready_txt:setTexture("all_servers_group_battles/res/quxiao.png")
        else
            self.Btn_ready_txt:setTexture("all_servers_group_battles/res/zhunbei.png")
        end
    end
    local num = self.model.user_info.today_attack_times[tostring(self.model.select_scene_id)]
    if num == nil or num == "" then
        num = 0
    elseif num > 3 then
        num = 3
    end
    --self.Text_times:setString(num.."次")


end



function TeamInfoLayer:onEnter()
    self:update()

    self.listener_1 = qy.Event.add(qy.Event.ALL_SERVERS_GROUP_BATTLES,function(event)
        self:update()        
        self:juide()
    end)
end



function TeamInfoLayer:onExit()
    qy.Event.remove(self.listener_1)

    self.listener_1 = nil
end


function TeamInfoLayer:juide()
    if self.model == nil or self.service == nil or self.model.user_info.team_id == ""  then
        qy.hint:show("你已被移除队伍")
        self.model.user_info.team_id = ""
        self.delegate.viewStack:pop()
        return
    end
end






return TeamInfoLayer
