local CombatCell = qy.class("CombatCell", qy.tank.view.BaseView, "inter_service_arena.ui.CombatCell")

function CombatCell:ctor(delegate)
   	CombatCell.super.ctor(self)

    self:InjectView("Img_stage")
    self:InjectView("Img_stage_num")
    self:InjectView("Img_user_icon")
    
    self:InjectView("Text_name")
    self:InjectView("Text_server")
    self:InjectView("Text_lv")
    self:InjectView("Img_change")
    self:InjectView("Btn_show")
    self:InjectView("Btn_share")    
    self:InjectView("Image_win")

    self.model = qy.tank.model.InterServiceArenaModel
    self.service = qy.tank.service.InterServiceArenaService


    self:OnClick("Btn_show", function()
        self.service:findbattle(function(data)
            qy.tank.model.BattleModel:init(data.fight_result)
            qy.tank.manager.ScenesManager:pushBattleScene()
        end, self.id)
    end,{["isScale"] = false})


    self:OnClick("Btn_share", function()
        if self.model.send_num > 0 then
            self.service:send(function(data)
                print(data)
                print(data.status)
                if data.status == 100 then
                    qy.hint:show(qy.TextUtil:substitute(90303))
                end
            end, self.id)
        else
            qy.hint:show(qy.TextUtil:substitute(90304))
        end
    end,{["isScale"] = false})
end

function CombatCell:render(data, idx)
    self.id = data.id
    
    self.Text_name:setString(data.username)
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

    local server = string.sub(data.servername, 2)
    if server == "youke" then
        self.Text_server:setString(qy.TextUtil:substitute(90297)..qy.TextUtil:substitute(90296))
    else
        self.Text_server:setString(server..qy.TextUtil:substitute(90296))
    end


    if qy.tank.model.UserInfoModel.userInfoEntity.kid == data.kid then
        if data.is_up == 1 then
            self.Img_change:loadTexture("inter_service_arena/res/shangsheng.png",0)
            self.Img_change:setVisible(true)
        elseif data.is_up == 0 then
            self.Img_change:setVisible(false)
        end
    elseif qy.tank.model.UserInfoModel.userInfoEntity.kid == data.rivalid then
        if data.is_up == 1 then
            self.Img_change:loadTexture("inter_service_arena/res/xiajiang.png",0)
            self.Img_change:setVisible(true)
        elseif data.is_up == 0 then
            self.Img_change:setVisible(false)
        end
    end


    if data.status == 1 then
        self.Image_win:loadTexture("inter_service_arena/res/win.png",0)
    else
        self.Image_win:loadTexture("inter_service_arena/res/lose.png",0)
    end

    
end

return CombatCell
