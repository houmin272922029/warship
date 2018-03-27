--[[
    跨服战排名

]]
local ShowWar = qy.class("ShowWar", qy.tank.view.BaseView, "servicewar.ui.ShowWar")

local model = qy.tank.model.ServiceWarModel
-- local userinfo = qy.tank.model.UserInfoModel
local CurrenList = {}
local service = qy.tank.service.ServiceWarService

function ShowWar:ctor(delegate)
    ShowWar.super.ctor(self)
    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "servicewar/res/dianfengduijue.png",
        showHome = true,
        ["onExit"] = function()
            if delegate and delegate.dismiss then
                delegate.dismiss()
            end
        end
    })

    self.Nums = 0
    self:InjectView("detail")
    self:InjectView("server1")
    self:InjectView("server2")
    self:InjectView("server3")
    self:InjectView("name1")
    self:InjectView("name2")
    self:InjectView("name3")
    self:InjectView("left_btn")
    self:InjectView("right_btn")
    self:InjectView("content")
    self:InjectView("page")
    self:InjectView("num")
    self:InjectView("plusBtn")
    self:InjectView("left")
    self:InjectView("right")
    self:InjectView("Text_7")
    self:InjectView("Image_1")
    self:InjectView("Text_8")
    self:InjectView("changeFormationBtn")

    self.cpage = model.page
    self.MaxPageNum = model.datanum
 
    self.page:setString(model.cpage  .. " / " .. model.datanum)
    CurrenList = model.attend_list
    if model.userinfo.role == 200 then
        self.Text_7:setVisible(false)
        self.num:setVisible(false)
        self.plusBtn:setVisible(false)
    end

    self:OnClick("detail", function(sender)  
        service:WatchDetailList(CurrenList.kid, function()
            require("servicewar.src.WarDetail").new(self.delegate):show(true)
        end)
    end)

    self:OnClick("left_btn", function (sender)
        if #model.attend_list then
            if #model.attend_list  < 1 then
                return nil
            end
        end
        if model.cpage == 1 then
            qy.hint:show(qy.TextUtil:substitute(90077))
        end
        self:SetNextPage(1, true)
    end)

    self:OnClick("right_btn", function (sender)
        if #model.attend_list then
            if #model.attend_list  < 1 then
                return nil
            end
        end
        if model.cpage == model.datanum then
            qy.hint:show(qy.TextUtil:substitute(90078))
        end
        self:SetNextPage(1, false)
    end)

    self:OnClick("left", function(sender)
        if #model.attend_list then
            if model.cpage <= 10 then
               self:SetNextPage(model.cpage - 1, true)
            else
               self:SetNextPage(10, true)
            end

        end
        -- if model.cpage == model.datanum then
        --     self:SetNextPage(1, true)
        -- end
        if model.cpage
         == 1 then
            qy.hint:show(qy.TextUtil:substitute(90079))
        end
    end)

    self:OnClick("right", function(sender)
        if #model.attend_list then
            if model.cpage + 10 > model.datanum then
                -- qy.hint:show("点不动啦")
            end
        end
        if model.cpage == model.datanum then
            qy.hint:show(qy.TextUtil:substitute(90078))
        end
        if model.cpage < 10 then
            self:SetNextPage(model.datanum - model.cpage, false)
        else
            local x = model.cpage <= 9 and 10 or 10
            self:SetNextPage(x, false)
        end
        
    end)

    self:OnClick("plusBtn", function (sender)
        service:BuyBattleNum(200, function(data)
            local buyDialog = require("servicewar.src.BuyDialog").new(self, data)
            buyDialog:show(true)
        end)  
    end) 


    self:OnClick("Touch1", function (sender)
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXAMINE, model.service_top_list[1].kid, 1)
    end)

    self:OnClick("Touch2", function (sender)
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXAMINE, model.service_top_list[2].kid, 1)
    end)

    self:OnClick("Touch3", function (sender)
       qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXAMINE, model.service_top_list[3].kid, 1)
    end)

    self:OnClick("changeFormationBtn", function ( sender )
        qy.tank.command.GarageCommand:showFormationDialog(data)
    end)

    self.delegate = delegate

    self.content:addChild(self:createView())
    self:addChild(style)
    
end

function ShowWar:update()
    self.Nums = self.Nums + 1
    self.num:setString( model.userinfo.remaining)
end

function ShowWar:refersh()
    self.server1:setString(model.service_top_list[1].servicename)
    self.server2:setString(model.service_top_list[2].servicename)
    self.server3:setString(model.service_top_list[3].servicename)
    self.name1:setString(model.service_top_list[1].nickname)
    self.name2:setString(model.service_top_list[2].nickname)
    self.name3:setString(model.service_top_list[3].nickname)
    self.page:setString(model.cpage .. " / " .. model.datanum)
    self.num:setString(model.userinfo.remaining)
end

function ShowWar:createView()
    local tableView = cc.TableView:create(cc.size(680, 435))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(0, 70)
    tableView:setDelegate()
    
    self.selectIdx = 1

    local function numberOfCellsInTableView(tableView)
        return #model.attend_list
    end
    local function tableCellTouched(table, cell)
        self.selectIdx = cell:getIdx()
        local entity = model.attend_list[self.selectIdx + 1]
        -- if model.userinfo.role == 100 then  --参赛者
        --     if entity.is_hit == 100 and model.userinfo.remaining >= 1 then  --可攻打
        --         local service = qy.tank.service.ServiceWarService
        --               service:Battle(entity.kid, model.userinfo.currentranking, entity.currentranking, function(data)
        --               qy.tank.manager.ScenesManager:pushBattleScene()
        --         end)
        --     end
            
        -- elseif model.userinfo.role == 200 then  --普通用户
        --     if entity.is_bet == 200 then   --未押注
        --     function callBack(flag)
        --         if flag == "确认" then
        --             local service = qy.tank.service.ServiceWarService
        --                   service:Bet(entity.kid, function(data)
        --         end)
        --         end
        --     end
        --     local alertMesg = "\n每日只可押注一名玩家且不能更改,是否押注？"
        --     qy.alert:show({"押注提示", {255,255,255} }, alertMesg, cc.size(450, 220), {{"取消", 4}, {"确认", 5}}, callBack, "")
        --     end
        -- end
        -- local service = qy.tank.service.ServiceWarService
              -- service:UserInfo(entity.kid, function()
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXAMINE, entity.kid, 1)
        -- end)

    end

    local function cellSizeForTable(tableView, idx)
        return 500, 55
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("servicewar.src.RankCell").new(self)
            cell:addChild(item)
            cell.item = item
        end

        cell.item.idx = idx
        cell.item:setData(model.attend_list[idx + 1])
        return cell
    end
    tableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)

    tableView:reloadData()
    self.tableView = tableView
    return tableView
end


function ShowWar:nextRank(data)
    self.cpage = data.page
    CurrenList = data.attend_list
    self.MaxPageNum = data.maxpage
    self.tableView:reloadData()
    self.page:setString(self.cpage .. " / " .. self.MaxPageNum)
end

function ShowWar:SetNextPage(num, dircetion) --direction为true是⬅️，direction为true是右
    local function sendMeges(nextPageNum)
        local service = qy.tank.service.ServiceWarService
        service:getRankList(nextPageNum,function(data)
            self:nextRank(data)
      end)
    end
    if dircetion == true then
        if model.cpage - num > 0 then
           sendMeges(model.cpage - num)
        end
    else
        if model.cpage + num < model.datanum + 1 then
            sendMeges(model.cpage + num)
        end
    end
end
function ShowWar:onEnter()
    self:refersh()
    self.listener_1 = qy.Event.add(qy.Event.SERVICE_WAR,function(event)
        self.tableView:reloadData()
    end)
end

function ShowWar:onExit()
    qy.Event.remove(self.listener_1)
end

return ShowWar