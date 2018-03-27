--[[
    签到
    2016年07月26日17:42:39
]]
local GroupBattlesLayer = qy.class("GroupBattlesLayer", qy.tank.view.BaseDialog, "group_battles.ui.GroupBattlesLayer")

local model = qy.tank.model.GroupBattlesModel
local service = qy.tank.service.GroupBattlesService
function GroupBattlesLayer:ctor(delegate)
    GroupBattlesLayer.super.ctor(self)



    self:InjectView("Panel")
    self:InjectView("Battle_name")
    self:InjectView("Award_type")
    self:InjectView("Battle_name")
    self:InjectView("Times")
    self:InjectView("Translucent")
    self:InjectView("Txt_no_team")
    self:InjectView("Creat_time")

    self:InjectView("Btn_close")
    self:InjectView("Btn_creat")
    self:InjectView("Btn_chat")
    self:InjectView("Btn_leave")
    self:InjectView("Btn_Begin")
    self:InjectView("Btn_legion_invite")
    self:InjectView("Btn_world_invite")
    self:InjectView("Btn_add_times")
    self:InjectView("Btn_Help")

    self.status = 0
    self.create_team_CD = 0
    
    self:OnClick(self.Btn_close, function(sender)
        if model:getStatus() ~= 0 then
            self:showLeaveDialog(function()
                service:leaveTeam(function(data)

                end)  
                self:removeSelf()
            end)                      
        else 
            self:removeSelf()
        end
    end,{["isScale"] = false})

    self:OnClick(self.Btn_creat, function(sender)
        if self.create_team_CD <= 0 then
            service:creatTeam(function(data)
                self:update()

                if data.team_info then
                    self.create_team_CD = 10
                    self.timeListener = qy.Event.add(qy.Runtime.TIMER_UPDATE,function(event)
                        self:updateTime()
                    end)
                    self.Btn_legion_invite:setBright(true)
                    self.Btn_world_invite:setBright(true)
                end
            end, model:getCurrentSceneId()) 
        end
    end,{["isScale"] = false})

    self:OnClick(self.Btn_chat, function(sender)
        local ChatController = require("module.chat.Controller")
        ChatController:startController(ChatController.new())
    end,{["isScale"] = false})

    self:OnClick(self.Btn_leave, function(sender)
        self:showLeaveDialog(function()
            service:leaveTeam(function(data)
                self:update()
            end)
        end)        
    end,{["isScale"] = false})

    self:OnClick(self.Btn_Begin, function(sender)
        service:start() 
    end,{["isScale"] = false})

    self:OnClick(self.Btn_legion_invite, function(sender)
        if self.Btn_legion_invite:isBright() then
            service:invite(function(data)
                if data.status == 200 then
                    qy.hint:show("发送成功")
                    self.Btn_legion_invite:setBright(false)
                end
            end, "legion") 
        end
    end,{["isScale"] = false})

    self:OnClick(self.Btn_world_invite, function(sender)
        if self.Btn_world_invite:isBright() then
            service:invite(function(data)
                if data.status == 200 then
                    qy.hint:show("发送成功")
                    self.Btn_world_invite:setBright(false)
                end
            end, "world") 
        end
    end,{["isScale"] = false})

    self:OnClick(self.Btn_add_times, function(sender)
        if model.vip_buy_times <= 0 then
            qy.hint:show("升级VIP可购买更多次数")
        else 
            require("group_battles.src.BuyDialog").new(self):show(self)
        end
    end,{["isScale"] = false})


    self:OnClick(self.Btn_Help, function(sender)
        qy.tank.view.common.HelpDialog.new(27):show(true)
    end,{["isScale"] = false})

    self.Panel:addChild(self:__createList(), 1)       
    self.Panel:addChild(self:__createTeamList(), 1)

    self.Translucent:setLocalZOrder(2)
    self.Translucent:setSwallowTouches(true)

end




function GroupBattlesLayer:__createList()
    local tableView = cc.TableView:create(cc.size(500, 550))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(10, 15)
    tableView:setDelegate()

    local function numberOfCellsInTableView(tableView)
        return model:getTotalCheckPointSize()
    end

    local function cellSizeForTable(tableView,idx)
        return 250, 184
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("group_battles.src.GroupBattlesCell").new(self)
            cell:addChild(item)
            cell.item = item
        end

        cell.item:render(model:getTotalCheckPointsByIndex(idx+1), idx+1)

        
        return cell
    end

    local function tableAtTouched(table, cell)

    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableAtTouched,cc.TABLECELL_TOUCHED)

    tableView:reloadData()

    self.tableViewList = tableView
    

    return tableView
end




function GroupBattlesLayer:__createTeamList()
    local tableView = nil
    if model:getStatus() == 0 then
        tableView = cc.TableView:create(cc.size(430, 290))
        tableView:setPosition(528, 256)
    else
        tableView = cc.TableView:create(cc.size(430, 200))
        tableView:setPosition(528, 333)
    end
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    --tableView:setPosition(528, 258)
    tableView:setDelegate()

    local function numberOfCellsInTableView(tableView)
        if model:getStatus() == 0 then
            if #model:getTeamListByCurrent() > 0 then
                return #model:getTeamListByCurrent()
            else 
                self.Txt_no_team:setVisible(true)
                return 0
            end
        else 
            return 3
        end
    end

    local function cellSizeForTable(tableView,idx)
        return 430, 60
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("group_battles.src.GroupBattlesTeamCell").new(self)
            cell:addChild(item)
            cell.item = item
        end

        if model:getStatus() == 0 then
            cell.item:render(model:getTeamListByCurrent()[idx+1], idx+1)
            cell.item.entity = model:getTeamListByCurrent()[idx+1]
        else 
            cell.item:render(model:getTeamInfo()[idx+1], idx+1)
            cell.item.entity = model:getTeamInfo()[idx+1]
        end
        
        
        return cell
    end

    local function tableAtTouched(table, cell)
        if cell.item.entity and cell.item.entity.kid and cell.item.entity.kid ~= qy.tank.model.UserInfoModel.userInfoEntity.kid then
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXAMINE, cell.item.entity.kid)
        end
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableAtTouched,cc.TABLECELL_TOUCHED)

    self.teamInfoTable = tableView

    tableView:reloadData()

    return tableView
end



function GroupBattlesLayer:update()

    print("_____________________")
    print(model:getStatus())

    if model:getStatus() == 0 then
        self.Btn_legion_invite:setVisible(false)
        self.Btn_world_invite:setVisible(false)
        self.Btn_creat:setVisible(true)
        self.Btn_chat:setVisible(false)
        self.Btn_leave:setVisible(false)
        self.Btn_Begin:setVisible(false)
        self.Translucent:setVisible(false)

        self.Btn_legion_invite:setBright(true)
        self.Btn_world_invite:setBright(true)
    elseif model:getStatus() == 1 then
        self.Btn_legion_invite:setVisible(true)
        self.Btn_world_invite:setVisible(true)
        self.Btn_creat:setVisible(false)
        self.Btn_chat:setVisible(true)
        self.Btn_leave:setVisible(true)
        self.Btn_Begin:setVisible(true)
        self.Btn_Begin:setBright(false)
        self.Btn_Begin:setTouchEnabled(false)
        self.Translucent:setVisible(true)
    elseif model:getStatus() == 2 then
        self.Btn_legion_invite:setVisible(true)
        self.Btn_world_invite:setVisible(true)
        self.Btn_creat:setVisible(false)
        self.Btn_chat:setVisible(true)
        self.Btn_leave:setVisible(true)
        self.Btn_Begin:setVisible(true)
        self.Btn_Begin:setBright(true)
        self.Btn_Begin:setTouchEnabled(true)
        self.Translucent:setVisible(true)
    end


    local award = nil
    local check_point_info = model:getCheckPointByIndex(model:getCurrentSceneId())

    if model:getWeek() < 7 and model:getWeek() % 2 == 1 then
        self.Award_type:setString("周一，周三，周五掉落")
        award = check_point_info.award_1
    elseif model:getWeek() == 7 then
        self.Award_type:setString("周日掉落")
        award = check_point_info.award_3
    else
        self.Award_type:setString("周二，周四，周六掉落")
        award = check_point_info.award_2
    end


    if self.award then
        self.Panel:removeChild(self.award)
    end    
    self.award = qy.tank.view.common.AwardItem.createAwardView({["id"] = award[1].id, ["type"] = award[1].type, ["num"] = award[1].num}, 1)
    self.award:setPosition(870,180)
    self.award:showTitle(false)
    self.Panel:addChild(self.award)

    self.Battle_name:setString(check_point_info.name)

    self.Txt_no_team:setVisible(false)

    self.Times:setString(model.join_num)
    

    if self.status == 0 and model:getStatus() ~= 0 or self.status ~= model:getStatus() and model:getStatus() == 0 then
        self.Panel:removeChild(self.teamInfoTable)
        self.Panel:addChild(self:__createTeamList(), 1)
        self.status = model:getStatus()

    elseif self.status == model:getStatus() then
        self.teamInfoTable:reloadData()
    end

    local point = self.tableViewList:getContentOffset()
    self.tableViewList:reloadData()
    self.tableViewList:setContentOffset(point)
end

function GroupBattlesLayer:updateTime()
    if self.create_team_CD > 0 then
        self.create_team_CD = self.create_team_CD - 1
        self.Btn_creat:setBright(false)
        self.Btn_creat:setTouchEnabled(false)
        self.Creat_time:setVisible(true)
        self.Creat_time:setString(self.create_team_CD.."s")
    elseif self.create_team_CD <= 0 then
        qy.Event.remove(self.timeListener)
        self.Btn_creat:setBright(true)
        self.Btn_creat:setTouchEnabled(true)
        self.Creat_time:setVisible(false)
        self.create_team_CD = 0
    end
end

function GroupBattlesLayer:onEnter()
    self:update()

    self.listener_1 = qy.Event.add(qy.Event.GROUP_BATTLES,function(event)
        self:update()
    end)

    self.listener_2 = qy.Event.add(qy.Event.GROUP_BATTLES2,function(event)
        service:isTeam(function(data)
            self:update()
        end) 
    end)

    
end

function GroupBattlesLayer:onExit()
    qy.Event.remove(self.listener_1)
    qy.Event.remove(self.listener_2)
    qy.Event.remove(self.timeListener)

    self.listener_1 = nil
    self.listener_2 = nil
    self.timeListener = nil

    self.Btn_creat:setBright(true)
    self.Btn_creat:setTouchEnabled(true)
    self.Creat_time:setVisible(false)
    self.create_team_CD = 0
end


function GroupBattlesLayer:showLeaveDialog(callback)
    require("group_battles.src.LeaveDialog").new(self, callback):show(self)
end



return GroupBattlesLayer
