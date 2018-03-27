local ChallengeView = qy.class("ChallengeView", qy.tank.view.BaseView, "inter_service_arena.ui.ChallengeView")


function ChallengeView:ctor(delegate)
   	ChallengeView.super.ctor(self)

    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "Resources/activity/title_inter_service_arena.png", 
        showHome = false,
        ["onExit"] = function()
            if delegate and delegate.dismiss then
                delegate.dismiss()
            end         
        end
    })
    self:addChild(style)

    self.model = qy.tank.model.InterServiceArenaModel
    self.service = qy.tank.service.InterServiceArenaService

    --data1 user.show请求返回数据，坦克列表
    --data2 防守方排位信息
    self.delegate = delegate
    self.data = delegate.data
    self.data2 = delegate.data2
    self.can_sweep = delegate.can_sweep

    self:InjectView("bg")
    self:InjectView("Node_1")
    self:InjectView("Node_2")

    self:InjectView("Img_stage_icon1")
    self:InjectView("Text_username1")
    self:InjectView("Text_servername1")
    self:InjectView("Text_power1")
    self:InjectView("Img_stage_name1")
    self:InjectView("Img_stage_num1")

    self:InjectView("Img_stage_icon2")
    self:InjectView("Text_username2")
    self:InjectView("Text_servername2")
    self:InjectView("Text_power2")
    self:InjectView("Img_stage_name2")
    self:InjectView("Img_stage_num2")

    self:InjectView("Btn_challenge")
    self:InjectView("Btn_challenge5")
    self:InjectView("Text_challenge5")
    self:InjectView("Img_challenge5")


    self:OnClick("Btn_challenge", function()
        if self.model.times > 0 then
            self.service:battle(function(data)
                qy.tank.model.BattleModel:init(data.fight_result)
                qy.tank.manager.ScenesManager:pushBattleScene()
            end, self.data2.rank)
        else
            require("inter_service_arena.src.BuyDialog").new(function()
                self.service:battle(function(data)
                    qy.tank.model.BattleModel:init(data.fight_result)
                    qy.tank.manager.ScenesManager:pushBattleScene()
                end, self.data2.rank)
            end):show()            
        end
    end,{["isScale"] = false})


    self:OnClick("Btn_challenge5", function()
        if self.model.times >= 5 then
            self.service:sweep(function(data)
                require("inter_service_arena.src.ContinuousChallengeDialog").new(self.data2):show()
                self:update()
            end, self.data2.rank)
        else
            self.service:attendnumserver(function(data)
                if data.pay then
                    self.service:sweep(function(data)
                        require("inter_service_arena.src.ContinuousChallengeDialog").new(self.data2):show()
                        self:update()
                    end, self.data2.rank)
                end
            end, self.model.sweep_need_times)
        end
    end,{["isScale"] = false})



    if not self.can_sweep then
        self.Btn_challenge5:setVisible(false)
        self.Text_challenge5:setVisible(false)
        self.Img_challenge5:setVisible(false)
        self.Btn_challenge:setPositionX(qy.winSize.width/2)
    end

    self.Node_1:addChild(self:__createList(qy.tank.model.GarageModel.formation, "left"))
    self.Node_2:addChild(self:__createList(self.data.tank_list, "right"))
    print("____________")
    print(#qy.tank.model.GarageModel.formation)
    print(#self.data.tank_list)

    self.Text_username1:setString(qy.tank.model.UserInfoModel.userInfoEntity.name)
    self.Text_username2:setString(self.data.user_info.nickname)

    self.Text_power1:setString(qy.tank.model.UserInfoModel.userInfoEntity.fightPower)
    self.Text_power2:setString(self.data2.fight_power)

    local server = string.sub(self.model.user_list.server, 2)
    self.Text_servername1:setString("("..server..qy.TextUtil:substitute(90296)..")")
    local server2 = string.sub(self.data2.server, 2)
    if server2 == "youke" then
        self.Text_servername2:setString("("..qy.TextUtil:substitute(90297)..qy.TextUtil:substitute(90296)..")")
    else
        self.Text_servername2:setString("("..server2..qy.TextUtil:substitute(90296)..")")
    end



    local function function1()
        local icon, num = self.model:getStageIcon()

        self.Img_stage_icon1:loadTexture("inter_service_arena/res/stage_icon_".. icon ..".png",0)
        self.Img_stage_name1:loadTexture("inter_service_arena/res/stage_name2_".. icon ..".png",0)

        if num and num > 0 then
            self.Img_stage_num1:loadTexture("inter_service_arena/res/stage_num2_".. num ..".png",0)
            self.Img_stage_num1:setVisible(true)
            self.Img_stage_name1:setPositionX(39 + (3 - num) * 5)
        else
            self.Img_stage_num1:setVisible(false)
            self.Img_stage_name1:setPositionX(55)
        end
    end
    
    local function function2()
        local icon, num = self.model:getStageIcon(self.data2.stage)

        self.Img_stage_icon2:loadTexture("inter_service_arena/res/stage_icon_".. icon ..".png",0)
        self.Img_stage_name2:loadTexture("inter_service_arena/res/stage_name2_".. icon ..".png",0)

        if num and num > 0 then
            self.Img_stage_num2:loadTexture("inter_service_arena/res/stage_num2_".. num ..".png",0)
            self.Img_stage_num2:setVisible(true)
            self.Img_stage_name2:setPositionX(39 + (3 - num) * 5)
        else
            self.Img_stage_num2:setVisible(false)
            self.Img_stage_name2:setPositionX(55)
        end
    end

    function1()
    function2()

end


function ChallengeView:update()
    if self.model.sweep_need_times == 0 then
        self.Text_challenge5:setVisible(false)
        self.Img_challenge5:setVisible(false)
    elseif self.can_sweep then
        self.Text_challenge5:setVisible(true)
        self.Img_challenge5:setVisible(true)
    end

    self.Text_challenge5:setString(self.model.sweep_need_diamond)
end


function ChallengeView:__createList(data, type)
    local tableView = cc.TableView:create(cc.size(400, 360))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setTouchEnabled(false)
    tableView:setPosition(0, 0)
    tableView:setDelegate()

    local function numberOfCellsInTableView(tableView)
        return 3
    end

    local function cellSizeForTable(tableView,idx)
        return 400, 120
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("inter_service_arena.src.TankCell").new(self)            
            cell:addChild(item)
            cell.item = item
        end

        cell.item:render(data, idx+1, type)
        
        return cell
    end

    local function tableAtTouched(table, cell)

    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableAtTouched,cc.TABLECELL_TOUCHED)

    tableView:reloadData()

    return tableView
end


function ChallengeView:onEnter()
    self.listener_1 = qy.Event.add(qy.Event.BACK_OF_BATTLE,function(event)
        self.delegate.dismiss()
    end)
    self:update()
end

function ChallengeView:onExit()
    qy.Event.remove(self.listener_1)
end


return ChallengeView
