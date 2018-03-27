--[[
    军演战况
]]
local WarDetail = qy.class("WarDetail", qy.tank.view.BaseDialog, "server_exercise.ui.WarDetail")

local model = qy.tank.model.ServerExerciseModel
local service = qy.tank.service.ServerExerciseService
local datalist = {}

function WarDetail:ctor(delegate)
    WarDetail.super.ctor(self)


    local style = qy.tank.view.style.DialogStyle2.new({
        size = cc.size(600,510),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "server_exercise/res/zhanbao2.png",--ranking_title

        ["onClose"] = function()
            self:dismiss()
        end
    })
    style:setPositionY(-20)
    self:addChild(style,-1)

    self:InjectView("mypannel")
    -- self:InjectView("allpannel")
    self:InjectView("page")
    self:InjectView("leftBtn")
    self:InjectView("rightBtn")
    self:InjectView("left")
    self:InjectView("right")
    self:InjectView("mybattle")
    self:InjectView("mybattleimage")
    self:InjectView("allbattle")
    self:InjectView("allbattleimage")
    --进来默认显示我的战报
    self:updatemyBt(false)
    self:updateallBt(true)
    
    self.type = 200 --100代表所有，200代表我的
    self:OnClick("mybattle", function()
        service:WatchDetailList(200,1,4,function ( )
            self:updatemyBt(false)
            self:updateallBt(true)
            self.type = 200
            self:nextRank()
        end)
    end)
    self:OnClick("allbattle", function()
        service:WatchDetailList(100,1,4,function ( data )
            self:updatemyBt(true)
            self:updateallBt(false)
            self.type = 100
            self:nextRank()
        end)
    end)
    self:OnClick("leftBtn", function()
        if #model.list then
            if #model.list  < 1 then
                return nil
            end

        end
        if model.pages == 1 then
            qy.hint:show(qy.TextUtil:substitute(90077))
            return
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
        if model.pages == 1 then
            qy.hint:show(qy.TextUtil:substitute(90079))
            return
        end
        if #model.list then
            if model.pages  <= 10 then
                self:SetNextPage(model.pages - 1, true)
            else
                self:SetNextPage(10, true)
            end
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
    if model.Maxpage == 0 then 
        self.page:setString("0/0")
    else
        self.page:setString(model.pages .. "/" .. model.Maxpage)
    end
    self.mypannel:addChild(self:createView())
end
function WarDetail:updatemyBt( type )
    self.mybattle:setTouchEnabled(type)
    self.mybattle:setEnabled(type)
    if type then
        self.mybattleimage:loadTexture("server_exercise/res/mybattle1.png",1)
    else
        self.mybattleimage:loadTexture("server_exercise/res/mybattle2.png",1)
    end
end
function WarDetail:updateallBt( type )
    self.allbattle:setTouchEnabled(type)
    self.allbattle:setEnabled(type)
    if type then
        self.allbattleimage:loadTexture("server_exercise/res/allbattle1.png",1)
    else
        self.allbattleimage:loadTexture("server_exercise/res/allbattle2.png",1)
    end
end
function WarDetail:createView()
    local tableView = cc.TableView:create(cc.size(520, 270))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(0, 10)
    tableView:setDelegate()
    self.selectIdx = 1

    local function numberOfCellsInTableView(tableView)
        return #datalist
    end

    local function tableCellTouched(table, cell)
        self.selectIdx = cell:getIdx()
        print("dianji")
        local entity = datalist[self.selectIdx + 1]
        local service = qy.tank.service.ServerExerciseService
              service:WatchDetail(entity.id, function(data)

              qy.tank.manager.ScenesManager:pushScene(qy.tank.view.scene.BattleScene.new())    
        end)
    end
    
    local function cellSizeForTable(tableView, idx)
        return 520, 65
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("server_exercise.src.WarDetailCell").new(self.delegate)
            cell:addChild(item)
            cell.item = item
        end
        cell.item.idx = idx
        cell.item:setData(self.type,datalist[idx + 1])
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

function WarDetail:nextRank()
print("页码",model.pages.."ssss",model.Maxpage)
  self.cpage = model.pages
  if model.Maxpage == 0 then
    self.cpage=0
  end
  datalist = model.list
  self.MaxPageNum = model.Maxpage
  self.page:setString(self.cpage .. "/" .. self.MaxPageNum)

  self.tableView:reloadData()

end

function WarDetail:SetNextPage(num, dircetion) 
    local function sendMeges(nextPageNum)
    print("*********nextPageNum***********",nextPageNum)
        
    service:WatchDetailList(self.type,nextPageNum,4,function(data)
        self:nextRank()
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
