--[[
    跨服军神榜
    Author: fq
    Date: 2016年12月23日13:55:09
]]

local MainView = qy.class("MainView", qy.tank.view.BaseView, "inter_service_arena.ui.MainView")


function MainView:ctor(delegate)
   	MainView.super.ctor(self)

    self.model = qy.tank.model.InterServiceArenaModel
    self.service = qy.tank.service.InterServiceArenaService

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

    self.delegate = delegate
    self.stage_num = self.model.stage_num
    self._end = false


    self:InjectView("bg")
    self:InjectView("rank_bg")
    self:InjectView("Img_stage")
    self:InjectView("Img_title_stage")
    self:InjectView("Img_title_stage_num")
    self:InjectView("Img_stage_num")
    self:InjectView("Img_stage_icon")
    self:InjectView("Image_5")
    self:InjectView("Img_jinji")
    self:InjectView("Img_hd")

    self:InjectView("Text_prompt")
    self:InjectView("Text_prompt2")
    self:InjectView("Text_rank")
    self:InjectView("Text_power")
    self:InjectView("Text_times")
    self:InjectView("Text_price")
    self:InjectView("Text_date")

    self:InjectView("Btn_formation")
    self:InjectView("Btn_rule")
    self:InjectView("Btn_combat")
    self:InjectView("Btn_award")
    self:InjectView("Btn_rank")
    self:InjectView("Btn_buy")
    self:InjectView("Btn_change")
    
    self:InjectView("bisaijiesu")
    self:InjectView("Node_1")

    self:InjectView("go_top")
    self:InjectView("go_down")

    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/ui/ui_fx_zhuangbeijinjie",function()
        local effect = ccs.Armature:create("ui_fx_zhuangbeijinjie")
        self.Image_5:addChild(effect)
        effect:setPosition(232, 320)
        effect:getAnimation():playWithIndex(0)
        self.Img_stage:setLocalZOrder(1)
    end)



    self:OnClick("Btn_formation", function()
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EMBATTLE)
    end,{["isScale"] = false})



    self:OnClick("Btn_rule", function()
        require("inter_service_arena.src.RuleDialog").new():show()
    end,{["isScale"] = false})

    self:OnClick("Btn_combat", function()
        self.service:battlelist(function(data)
            if delegate and delegate.Controller then
                delegate.Controller:showCombatView(data)
            end
        end, 200, 1)
    end,{["isScale"] = false})

    self:OnClick("Btn_reward", function()
        if delegate and delegate.Controller then
            delegate.Controller:showRewardView()
        end
    end,{["isScale"] = false})


    self:OnClick("Btn_rank", function()
        self.service:getRankList(function(data)
            if delegate and delegate.Controller then
                delegate.Controller:showTotalRankView(data)
            end
        end, 1, self.model.rank_list_page_size)
    end,{["isScale"] = false})


    self:OnClick("Btn_change", function()
        self.service:change(function(data)            
            self:updateTable()
            self:update()
        end)
    end,{["isScale"] = false})


    self:OnClick("Btn_king", function()
        qy.hint:show(qy.TextUtil:substitute(50001))
    end,{["isScale"] = false})


    self:OnClick("Img_stage_icon", function()
        require("inter_service_arena.src.RiseInRankRuleDialog").new():show()
    end,{["isScale"] = false})

    

    self:OnClick("Btn_buy", function()
        self.service:attendnumserver(function(data)
            self:update()
        end, 1)
    end,{["isScale"] = false})


    self:OnClick("go_top", function()
        self.tableView:setContentOffset(cc.p(0, (10 + #self.model.battle_list.list + 1 + #self.model.sweep_list) * -89 + 415), true)
    end,{["isScale"] = false})

    self:OnClick("go_down", function()
        self.tableView:setContentOffset(cc.p(0, 0), true)
    end,{["isScale"] = false})

    self.rank_bg:addChild(self:createTable())
    
end


function MainView:update()
    self.Text_times:setString(self.model.battle_num)
    --self.Text_price

    local icon, num = self.model:getStageIcon()

    self.Img_stage:loadTexture("inter_service_arena/res/stage_name2_".. icon ..".png",0)
    self.Img_title_stage:loadTexture("inter_service_arena/res/stage_name1_".. icon ..".png",0)
    self.Img_stage_icon:loadTexture("inter_service_arena/res/stage_icon_".. icon ..".png",0)

    if num and num > 0 then
        self.Img_stage_num:loadTexture("inter_service_arena/res/stage_num2_".. num ..".png",0)
        self.Img_title_stage_num:loadTexture("inter_service_arena/res/stage_num1_".. num ..".png",0)
        self.Img_stage_num:setVisible(true)
        self.Img_title_stage_num:setVisible(true)
        self.Img_title_stage:setPositionX(146)
    else
        self.Img_stage_num:setVisible(false)
        self.Img_title_stage_num:setVisible(false)
        self.Img_title_stage:setPositionX(163)
    end

    if self._end then
        self.Text_prompt:setString(qy.TextUtil:substitute(90309))
    else
        if self.model:getStageByStage().up_limit > 0 then
            self.Text_prompt:setString(qy.TextUtil:substitute(90294, self.model:getStageByStage().up_limit))
        else
            self.Text_prompt:setString(qy.TextUtil:substitute(90295))
        end
    end

    self.Text_rank:setString(qy.TextUtil:substitute(4003, self.model.stage_rank))

    self.Text_power:setString(qy.tank.model.UserInfoModel.userInfoEntity.fightPower)

    self.Text_times:setString(self.model.times)
    self.Text_price:setString(self.model.diamond_consume)

    if self.model.stage_num < self.stage_num then
        self.stage_num = self.model.stage_num
        require("inter_service_arena.src.RiseInRankDialog").new():show()
    end

    if self.model.stage_rank <= self.model:getStageByStage().up_limit then
        self.Img_jinji:setVisible(true)
    else
        self.Img_jinji:setVisible(false)
    end



    if self._end == false then
        self.tableView:setContentOffset(cc.p(0, 0)) 
    end

    self.Img_hd:setVisible(false)
    function judge_red()
        for i = 1, 19 do
            local data = self.model.stage_award[tostring(i)]
            if data == 0 and self.model.max_stage <= i then
                self.Img_hd:setVisible(true)
            end
        end
        for i = 1, #self.model.score_award do
            local data = self.model:getScoreAwardByScore(i)
            local source = data["source"]
            local lingqu = self.model.source_award[tostring(source)]
            if lingqu == 0 and self.model.source >= source then
                self.Img_hd:setVisible(true)
            end
        end
        local day = self.model:getTime()   
        if (self.model.day_7_get == 1 and tonumber(day) >= 7) or (self.model.day_14_get == 1 and tonumber(day) >= 14) then
            self.Img_hd:setVisible(true)
        end   
    end
    judge_red()

end




function MainView:createTable()
    local tableView = cc.TableView:create(cc.size(520, 415))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    -- tableView:setSwallowTouches(false)
    tableView:setPosition(1, 6)
    tableView:setDelegate()

    local function numberOfCellsInTableView(tableView)
        if self._end then
            return #self.model.kinglist.list
        else
            return 10 + #self.model.battle_list.list + 1 + #self.model.sweep_list
        end
    end

    local function cellSizeForTable(tableView,idx)
        return 500, 89
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("inter_service_arena.src.MainRankCell").new(self)
            cell:addChild(item)
            cell.item = item
        end

        local k_size = #self.model.kinglist.list
        local b_size = #self.model.battle_list.list
        local s_size = #self.model.sweep_list


        if self._end then
            cell.item:render(self.model.kinglist.list[idx+1], idx+1, "king")

            self.go_down:setVisible(false)
            self.go_top:setVisible(false)
        else
            if idx < k_size then
                cell.item:render(self.model.kinglist.list[idx+1], idx+1, "king")

            elseif idx < k_size + b_size then
                cell.item:render(self.model.battle_list.list[idx+1-k_size], idx+1-k_size, "battle")

            elseif idx == k_size + b_size then
                cell.item:render(self.model.user_list, idx+1, "user")

            elseif idx == k_size + b_size + s_size and s_size > 0 then
                cell.item:render(self.model.sweep_list[1], idx + 1, "sweep")
            end


            local point = tableView:getContentOffset()
            if point.y < -100 then
                self.go_down:runAction(cc.FadeTo:create(0.3, 255))
                self.go_top:runAction(cc.FadeTo:create(0.3, 0))
            else
                self.go_down:runAction(cc.FadeTo:create(0.3, 0))
                self.go_top:runAction(cc.FadeTo:create(0.3, 255))
            end
        end

        cell.item.idx = idx + 1
        return cell
    end

    local function tableAtTouched(table, cell)
        --#self.model.kinglist.list + #self.model.battle_list.list + 1 是自己
        if cell.item.idx ~= #self.model.kinglist.list + #self.model.battle_list.list + 1 and cell.item.idx > #self.model.kinglist.list and not self._end then
            self.service:userShow(function(data)
                if self.delegate and self.delegate.Controller then
                    self.delegate.Controller:showChallengeView(data, cell.item.entity, cell.item.idx == 10+ #self.model.battle_list.list + 2 and true or false)
                end
            end, cell.item.entity.ai_kid)
        elseif self._end or cell.item.idx <= #self.model.kinglist.list then
            if cell.item.entity then
                local kid = 0
                if cell.item.entity.server == "syouke" then
                    kid = cell.item.entity.ai_kid or 0
                else
                    kid = cell.item.entity.kid or 0
                    if kid ~= qy.tank.model.UserInfoModel.userInfoEntity and kid ~= 0 then
                        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXAMINE_AI,cell.item.entity.kid, 2)
                    end
                end
              
            end
        end
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableAtTouched,cc.TABLECELL_TOUCHED)

    tableView:reloadData()

    self.tableView = tableView

    return tableView
end


function MainView:updateTable()
    --local point = self.tableView:getContentOffset()

    self.tableView:reloadData()

    --self.tableView:setContentOffset(point) 

end



function MainView:onEnter()
    self.listener_1 = qy.Event.add(qy.Event.BACK_OF_BATTLE,function(event)
        self:updateTable()
        self:update()
    end)

    -- self.listener_2 = qy.Event.add(qy.Event.INTER_SERVICE_ARENA,function(event)
    --     self:update()
    --     self:updateTable()
    --     qy.hint:show(qy.TextUtil:substitute(90307))
    -- end)

    self:updateTime()
    self.timeListener = qy.Event.add(qy.Runtime.TIMER_UPDATE,function(event)
        self:updateTime()
    end)

    
    self:updateTable()
    self:update()
end

function MainView:onExit()
    qy.Event.remove(self.listener_1)
    qy.Event.remove(self.listener_2)
    qy.Event.remove(self.timeListener)
    self.timeListener = nil
end


function MainView:updateTime()
    if self.Text_date then
        local str = self.model:getEndTime()
        if str == qy.TextUtil:substitute(90300) then
            self.Node_1:setVisible(false)
            self.bisaijiesu:setVisible(true)
            self._end = true
            str = self.model:getStartTime()
        end
        self.Text_date:setString(str)
    end
end


return MainView
