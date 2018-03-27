--[[
    跨服副本
]]
local BeginView = qy.class("BeginView", qy.tank.view.BaseDialog, "all_servers_group_battles.ui.Layer")


function BeginView:ctor(delegate)
    BeginView.super.ctor(self)

    self.model = qy.tank.model.AllServersGroupBattlesModel
    self.service = qy.tank.service.AllServersGroupBattlesService


    for i = 1, 5 do
        self:InjectView("Text_"..i)
    end

    self:InjectView("bg1")
    self:InjectView("bg2")
    self:InjectView("Text_times")
    self:InjectView("Btn_find")
    self:InjectView("Btn_creat")
    self:InjectView("Btn_help")
    self:InjectView("Btn_back")
    self:InjectView("Node_award")
    self:InjectView("Btn_close")
    self:InjectView("Img_title")


    self:InjectView("normalBt")
    self:InjectView("hardBt")

    

    self.status = 0
    
    self:OnClick(self.Btn_close, function(sender)
        self.model.modeltype = 1
        self.model.select_scene_id = 0
        if self.model.team_info then
            self.model.team_info.team_id = ""
        end
        delegate:finish()
    end,{["isScale"] = false})


    self:OnClick(self.Btn_find, function(sender)
        delegate:showTeamListView(self.model.select_scene_id)
    end,{["isScale"] = false})
    
    self:OnClick(self.Btn_creat, function(sender)
        self.service:creatTeam(function(data)
            delegate:showTeamInfoView()
        end,self.model.select_scene_id)
    end,{["isScale"] = false})


    self:OnClick(self.Btn_back, function(sender)
        delegate:showTeamInfoView()
    end,{["isScale"] = false})


    self:OnClick(self.Btn_help, function(sender)
        qy.tank.view.common.HelpDialog.new(46):show(true)
    end,{["isScale"] = false})

    self:OnClick(self.normalBt, function(sender)
         if self.model.user_info.team_id ~= "" and self.model.team_info then
            qy.hint:show("您已加入部队,不能切换模式")
            return
        end
        -- self.model.select_scene_id = self.model.select_scene_id - 4
        self.model:updatescecid()
        self:updateBt(1)
    end,{["isScale"] = false})

    self:OnClick(self.hardBt, function(sender)
        if self.model.user_info.team_id ~= "" and self.model.team_info then
            qy.hint:show("您已加入部队,不能切换模式")
            return
        end
        self.model.select_scene_id = self.model.select_scene_id + 4
        self:updateBt(2)
    end,{["isScale"] = false})

    self:updateBt(self.model.modeltype)
    -- self:update()
    
end
function BeginView:updateBt( num )
    if self.bg1:getChildByTag(999) then
        self.bg1:removeChildByTag(999,true)
    end
    self.model.modeltype = num
    self.normalBt:setBright(num == 2)
    self.hardBt:setBright(num == 1)
    self.normalBt:setTouchEnabled(num == 2)
    self.hardBt:setTouchEnabled(num == 1)
    if num == 1 then
        self.bg2:setTexture("all_servers_group_battles/res/1.jpg")
        self.bg1:loadTexture("all_servers_group_battles/res/7.png",0)
        -- self.bg2:setPosition(653, 310)
    else
        self.bg2:setTexture("all_servers_group_battles/res/k_bg.png")
        self.bg1:loadTexture("all_servers_group_battles/res/k_bg_big.png",0)
        -- self.bg2:setPosition(653, 313)
    end
    self.bg1:addChild(self:__createList(),1,999) 
    self:update()
end



function BeginView:__createList()
    local tableView = cc.TableView:create(cc.size(322, 600))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(13, 13)
    tableView:setDelegate()
    local data = {}
    if self.model.modeltype == 1 then
        data = self.model.scene_list
    else
        data = self.model.scene_list1
    end
    local function numberOfCellsInTableView(tableView)
        return #data
    end

    local function cellSizeForTable(tableView,idx)
        return 322, 150
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("all_servers_group_battles.src.Cell").new(self)
            cell:addChild(item)
            cell.item = item
        end

        cell.item:render(data[idx + 1], idx+1)
        cell.idx = idx+1
        
        return cell
    end

    local function tableAtTouched(table, cell)
        for i = 1, #self.model.today_scene_id do
            local scene_id = 0
            if self.model.modeltype == 1 then
                scene_id = self.model.select_scene_id 
            else
               scene_id = self.model.select_scene_id - 4
            end
            -- print("self.model.select_scene_id",self.model.select_scene_id)
            -- print("+++++++++++",scene_id)
            -- print("cell.idx",cell.idx)
            -- print("=========",self.model.today_scene_id[i])
            local aa = self.model.modeltype == 2 and cell.idx + 4 or cell.idx
            if self.model.today_scene_id[i] == aa and scene_id ~= cell.idx then
                if (self.model.user_info == nil or self.model.user_info.team_id == "") then
                    local scene_id = 0
                    if self.model.modeltype == 1 then
                        self.model.select_scene_id = cell.idx
                    else
                       self.model.select_scene_id = cell.idx + 4
                    end
                    self:update(1)
                else
                    qy.hint:show("您已加入其他副本的部队")
                end
            end
        end
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableAtTouched,cc.TABLECELL_TOUCHED)

    tableView:reloadData()

    self.tableViewList = tableView
        

    return tableView
end




function BeginView:update(flag)
    -- local nums = (self.model.select_scene_id > 8 ) and (self.model.select_scene_id - 4) or 
    self.Img_title:setTexture("all_servers_group_battles/res/scene_"..self.model.select_scene_id..".png")
    if self.model.select_scene_id then
        if self.award then
            self.Node_award:removeChild(self.award)
        end
        print("===================",self.model.select_scene_id)
        self.award = qy.AwardList.new({
            ["award"] = self.model.totalscene_list[self.model.select_scene_id].award,
            ["cellSize"] = cc.size(98,180),
            ["type"] = 1,
            ["len"] = 4,
            ["itemSize"] = 2,
            ["hasName"] = false,
        })
        self.award:setPosition(45,225)
        self.Node_award:addChild(self.award)
    end

    for i = 1, 5 do
        local str = self.model.totalscene_list[self.model.select_scene_id]["scene_info_"..i]
        self["Text_"..i]:setString(str)
    end

    print(self.model.user_info.team_id)
    if self.model.user_info.team_id ~= "" and self.model.team_info then
        self.Btn_creat:setVisible(false)
        self.Btn_back:setVisible(true)
    else
        self.Btn_creat:setVisible(true)
        self.Btn_back:setVisible(false)
    end
    if flag == 1 then
        local listCurY = self.tableViewList:getContentOffset().y
        self.tableViewList:reloadData()
        self.tableViewList:setContentOffset(cc.p(0,listCurY))
    else
        self.tableViewList:reloadData()
    end

    
    local num = self.model.user_info.today_attack_times[tostring(self.model.select_scene_id)]
    if num == nil or num == "" then
        num = 0
    elseif type(num) == "number" and num > 3 then
        num = 3
    end
    if self.model.modeltype == 1 then
        self.Text_times:setString(num.."/3次")
    else
        self.Text_times:setString(num.."/1次")
    end
   

end

function BeginView:onEnter()
    self:update()

    self.listener_1 = qy.Event.add(qy.Event.ALL_SERVERS_GROUP_BATTLES,function(event)
        self:update()
    end)

    self.listener_2 = qy.Event.add(qy.Event.ALL_SERVERS_GROUP_BATTLES2,function(event)
        service:isTeam(function(data)
            self:update()
        end) 
    end)    
end



function BeginView:onExit()
    qy.Event.remove(self.listener_1)
    qy.Event.remove(self.listener_2)

    self.listener_1 = nil
    self.listener_2 = nil

end


function BeginView:showLeaveDialog(callback)
    require("group_battles.src.LeaveDialog").new(self, callback):show(self)
end



return BeginView
