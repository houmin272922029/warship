--[[
    跨服战况
]]
local WarDetail = qy.class("WarDetail", qy.tank.view.BaseDialog, "servicewar.ui.WarDetail")

local model = qy.tank.model.ServiceWarModel
local datalist = {}

function WarDetail:ctor(delegate)
    WarDetail.super.ctor(self)
    self:InjectView("btn_close")
    self:InjectView("content")
    self:InjectView("page")
    self:InjectView("leftBtn")
    self:InjectView("rightBtn")
    self:InjectView("left")
    self:InjectView("right")

    self:OnClick("btn_close", function()
        self:removeSelf()
    end,{["isScale"] = false})

    self:OnClick("leftBtn", function()
        if #model.list then
            if #model.list  < 1 then
                return nil
            end

        end
        if model.pages == 1 then
            qy.hint:show(qy.TextUtil:substitute(90077))
        end
            self:SetNextPage(1, true)
    end)

    self:OnClick("rightBtn", function()
        if #model.list then
            if #model.list  < 1 then
                return nil
            end
        end
        if model.pages == model.Maxpage then
            qy.hint:show(qy.TextUtil:substitute(90078))
        end
            self:SetNextPage(1, false)
    end)

    self:OnClick("left", function()
        if #model.list then
            if model.pages  <= 10 then
                self:SetNextPage(model.pages - 1, true)
            else
                self:SetNextPage(10, true)
            end
        end
        if model.pages == 1 then
            qy.hint:show(qy.TextUtil:substitute(90079))
        end
            
    end)

    self:OnClick("right", function()
        if #model.list then
            -- self:SetNextPage(10, false)
        end
        if model.pages == model.Maxpage then
            qy.hint:show(qy.TextUtil:substitute(90078))
        end
        if model.pages  <= 10 then
             self:SetNextPage(10, false)
        else
            -- local x = model.pages <= 10 and 9 or 9
            local x = model.Maxpage - model.pages
            self:SetNextPage(x, false)
        end
    end)
    datalist = model.list
    self.delegate = delegate
    self.page:setString(model.pages .. "/" .. model.Maxpage)
    self.content:addChild(self:createView())
end

function WarDetail:createView()
    local tableView = cc.TableView:create(cc.size(635, 450))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(20, 60)
    tableView:setDelegate()
    self.selectIdx = 1

    local function numberOfCellsInTableView(tableView)
        return #datalist
    end

    local function tableCellTouched(table, cell)
        self.selectIdx = cell:getIdx()
        local entity = datalist[self.selectIdx + 1]
        local service = qy.tank.service.ServiceWarService
              service:WatchDetail(entity.id, function(data)
              qy.tank.manager.ScenesManager:pushScene(qy.tank.view.scene.BattleScene.new())    
        end)
    end
    
    local function cellSizeForTable(tableView, idx)
        return 650, 85
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("servicewar.src.WarDetailCell").new(self.delegate)
            cell:addChild(item)
            cell.item = item
        end
        cell.item.idx = idx
        cell.item:setData(datalist[idx + 1])
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

function WarDetail:nextRank(data)
  self.data = data
  self.cpage = data.page
  datalist = data.list
  self.MaxPageNum = data.maxpage
  self.page:setString(self.cpage .. "/" .. self.MaxPageNum)

  self.tableView:reloadData()

end

function WarDetail:SetNextPage(num, dircetion) 
    local function sendMeges(nextPageNum)
    print("*********nextPageNum***********",nextPageNum)
        local service = qy.tank.service.ServiceWarService
              service:WatchDetailList(nextPageNum,function(data)
               self:nextRank(data)
      end)
    end
    if dircetion == true then
        if model.pages - num > 0 then
           sendMeges(model.pages - num)
        end
    else
        if model.pages + num < model.Maxpage + 1 then
            sendMeges(model.pages + num)


        end
    end
end
function WarDetail:onEnter()
    
end

function WarDetail:onExit()
    
end
return WarDetail
