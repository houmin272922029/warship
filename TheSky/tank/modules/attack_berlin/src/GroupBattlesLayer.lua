--[[
    签到
    2016年07月26日17:42:39
]]
local GroupBattlesLayer = qy.class("GroupBattlesLayer", qy.tank.view.BaseView, "attack_berlin.ui.GroupBattlesLayer")

local model = qy.tank.model.AttackBerlinModel
local service = qy.tank.service.AttackBerlinService
function GroupBattlesLayer:ctor(delegate,delegate1)
    GroupBattlesLayer.super.ctor(self)
    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "attack_berlin/res/weigongbolin.png",
        ["onExit"] = function()
            if model:getStatus() ~= 0 then
                self:showLeaveDialog(function()
                    service:leaveTeam(function(data)
                        model:initdata()
                        qy.Event.dispatch(qy.Event.ATTACKBERLIN2)
                        self:removeSelf()
                    end)
                end)
            else
                model:initdata()
                qy.Event.dispatch(qy.Event.ATTACKBERLIN2)
                self:removeSelf()
            end
        end
    })
    self:addChild(style, 10)
    self:InjectView("Panel")
    self:InjectView("Battle_name")
    self:InjectView("Award_type")
    self:InjectView("Battle_name")
    self:InjectView("times")
    self:InjectView("Translucent")
    self:InjectView("Txt_no_team")
    self:InjectView("Creat_time")

    self:InjectView("Btn_close")
    self:InjectView("Btn_creat")
    self:InjectView("Btn_chat")
    self:InjectView("Btn_leave")
    self:InjectView("Btn_Begin")
    self:InjectView("Btn_legion_invite")
    self:InjectView("Btn_add_times")
    self:InjectView("refreshBt")
    self:InjectView("Btn_Begin_0")
    self:InjectView("awardbg")

    self.status = 0
    self.create_team_CD = 0
    
    self:OnClick(self.Btn_Begin_0, function(sender)
        require("attack_berlin.src.Tip1").new({
            ["awards"] = delegate.data.clearance_award,
            ["ids"] = delegate.data.award_id,
            ["types"] = 2,
            }):show()
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
                end
            end, self.chapterdata[self.selectid].copy_id,self.chapterdata[self.selectid].id) 
        end
    end,{["isScale"] = false})

    self:OnClick(self.Btn_chat, function(sender)
        -- self:setVisible(false)
        self.ischatback = 1
        local ChatController = require("module.chat.Controller").new()
        ChatController:startController(ChatController.new())
        -- self:addChild(ChatController)
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
                qy.hint:show("发送成功")
            end, "legion") 
        end
    end,{["isScale"] = false})

    self:OnClick(self.Btn_add_times, function(sender)
        require("attack_berlin.src.BuyDialog").new({
            ["types"] = 2,
            ["callback"] = function (  )
                self:updateTimes()
            end
            }):show()
    end,{["isScale"] = false})


    self:OnClick("helpBt",function()
        qy.tank.view.common.HelpDialog.new(50):show(true)
    end)
    self:updateTimes()
    self.selectid =0
    self.ischatback = 0
    self.delegate = delegate
    self.chapterdata = model:getListBysceneid1(delegate.data.id)
    for k,v in pairs(self.chapterdata) do
        if v.id == model.default_id then
            self.selectid = k
        end
    end
    model:setscenceid(model.default_id)
    self.Panel:addChild(self:__createList(), 1)       
    self.Panel:addChild(self:__createTeamList(), 1)

    -- self.Translucent:setLocalZOrder(2)
    -- self.Translucent:setSwallowTouches(true)

end
function GroupBattlesLayer:updateTimes(  )
    self.times:setString(model.times2.."次")
end



function GroupBattlesLayer:__createList()
    local tableView = cc.TableView:create(cc.size(320, 535))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(120, 30)
    tableView:setDelegate()

    local function numberOfCellsInTableView(tableView)
        return #self.chapterdata
    end

    local function cellSizeForTable(tableView,idx)
        return 320, 155
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("attack_berlin.src.GroupBattlesCell").new({
                ["data"] = self.chapterdata,
                })
            cell:addChild(item)
            cell.item = item

        end
        cell.idx = idx + 1
        cell.item:render(idx+1,self.selectid )

        
        return cell
    end

    local function tableAtTouched(table, cell)
        if self.selectid == cell.idx then
            return
        end
        local status = model:getElitestatus(self.chapterdata[cell.idx].id)
        if status == "success" then
            qy.hint:show("该关卡已被攻破")
            return
        end
         if status == "fail" then
            qy.hint:show("该关卡已撤离")
            return
        end
        if model:getStatus() ~= 0 then
            qy.hint:show("退出队伍后方可切换关卡")
            return
        end
        self.selectid  =  cell.idx
        -- print("mmmmmmmmmmmmmmmm",cell.idx)
        -- print("nnnnnnnnnnnn",self.chapterdata[cell.idx].id)
        for k,v in pairs(model.scene_list) do
            if v.scene_id  == self.chapterdata[cell.idx].id then
                -- print("===========ooooooo",json.encode(v))
                model:update(v)
            end
        end
        model:setscenceid(self.chapterdata[self.selectid].id)
        self:update()
        local listCurY = self.tableViewList:getContentOffset().y
        self.tableViewList:reloadData()
        self.tableViewList:setContentOffset(cc.p(0,listCurY))
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableAtTouched,cc.TABLECELL_TOUCHED)

    tableView:reloadData()

    self.tableViewList = tableView
    
    if self.selectid > 4 and self.selectid <= 8 then
        self.tableViewList:setContentOffset(cc.p(0,-200))
    end
    if self.selectid > 8  then
        self.tableViewList:setContentOffset(cc.p(0,0))
    end
    return tableView
end




function GroupBattlesLayer:__createTeamList()
    local tableView = nil
     self.Txt_no_team:setVisible(false)
    if model:getStatus() == 0 then
        tableView = cc.TableView:create(cc.size(430, 290))
        tableView:setPosition(488, 260)
    else
        tableView = cc.TableView:create(cc.size(430, 200))
        tableView:setPosition(488, 355)
    end
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    --tableView:setPosition(528, 258)
    tableView:setDelegate()
    local selectid = 0
    for k,v in pairs(self.chapterdata) do
        if k == self.selectid then
            selectid = v.id
        end
    end
    local function numberOfCellsInTableView(tableView)
        if model:getStatus() == 0 then
            -- print("hahahapppp",#model:getTeamListByCurrent(selectid))
            if #model:getTeamListByCurrent(selectid) > 0 then
                -- print("hahaha",#model:getTeamListByCurrent(selectid))
                return #model:getTeamListByCurrent(selectid)
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
            item = require("attack_berlin.src.GroupBattlesTeamCell").new(self)
            cell:addChild(item)
            cell.item = item
        end

        -- if model:getStatus() == 0 then
        --     cell.item:render(model:getTeamListByCurrent(selectid)[idx+1], idx+1)
        --     cell.item.entity = model:getTeamListByCurrent(selectid)[idx+1]
        -- else 
        --     -- print("////////",json.encode(model:getTeamInfo()))
        cell.item:render(model:getTeamInfo()[idx+1], idx+1,self)
        cell.item.entity = model:getTeamInfo()[idx+1]
        -- end
        
        
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
        self.Btn_creat:setVisible(true)
        self.Btn_chat:setVisible(false)
        self.Btn_leave:setVisible(false)
        self.Btn_Begin:setVisible(false)

        self.Btn_legion_invite:setBright(true)
    elseif model:getStatus() == 1 then
        self.Btn_legion_invite:setVisible(true)
        self.Btn_creat:setVisible(false)
        self.Btn_chat:setVisible(true)
        self.Btn_leave:setVisible(true)
        self.Btn_Begin:setVisible(true)
        self.Btn_Begin:setBright(false)
        self.Btn_Begin:setTouchEnabled(false)
    elseif model:getStatus() == 2 then
        self.Btn_legion_invite:setVisible(true)
        self.Btn_creat:setVisible(false)
        self.Btn_chat:setVisible(true)
        self.Btn_leave:setVisible(true)
        self.Btn_Begin:setVisible(true)
        self.Btn_Begin:setBright(true)
        self.Btn_Begin:setTouchEnabled(true)
    end

    self.awardbg:removeAllChildren(true)
    local awards = self.chapterdata[self.selectid].award
    for i=1,#awards do
        local item = qy.tank.view.common.AwardItem.createAwardView(awards[i], 1)
        item:setPosition(-20+ 100 *i,45)
        item:showTitle(false)
        item:setScale(0.8)
        self.awardbg:addChild(item)
    end
    -- local items = require("attack_berlin.src.Awarditem").new({
    --       ["ids"] = self.chapterdata[self.selectid].award_id,
    --       ["types"] = 1
    -- })
    -- self.awardbg:addChild(items)
    -- items:setPosition(-20 + (#awards + 1) * 100,45)
    self:updateTimes()

    
    self.Panel:removeChild(self.teamInfoTable)
    self.Panel:addChild(self:__createTeamList(), 1)

    -- local listCurY = self.tableViewList:getContentOffset().y
    -- self.Panel:removeChild(self.tableViewList)
    -- self.Panel:addChild(self:__createList(), 1) 
    -- self.tableViewList:setContentOffset(cc.p(0,listCurY))

end
function GroupBattlesLayer:update1(  )
    self.chapterdata = model:getListBysceneid1(self.delegate.data.id)
    for k,v in pairs(self.chapterdata) do
        if v.id == model.default_id then
            self.selectid = k
        end
    end
    model:setscenceid(self.chapterdata[self.selectid].id)
    for k,v in pairs(model.scene_list) do
        if v.scene_id  == self.chapterdata[self.selectid].id then
            model:update(v)
        end
    end
    local listCurY = self.tableViewList:getContentOffset().y
    self.tableViewList:reloadData()
    self.tableViewList:setContentOffset(cc.p(0,listCurY))
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
    if self.ischatback == 1 then
        self.ischatback = 0
        if self.tableViewList then
            local listCurY = self.tableViewList:getContentOffset().y
            self.tableViewList:reloadData()
            self.tableViewList:setContentOffset(cc.p(0,listCurY))
        end
    else
        self:update1()
    end
    self:update()
    self.listener_1 = qy.Event.add(qy.Event.ATTACKBERLIN,function(event)
        self:update()
    end)
    self.listener_2 = qy.Event.add(qy.Event.ATTACKBERLIN3,function(event)
        -- self:update1()
        local listCurY = self.tableViewList:getContentOffset().y
        self.tableViewList:reloadData()
        self.tableViewList:setContentOffset(cc.p(0,listCurY))
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
    require("attack_berlin.src.LeaveDialog").new(self, callback):show(self)
end



return GroupBattlesLayer
