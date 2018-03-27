local LegionAwardDIalog = qy.class("LegionAwardDIalog", qy.tank.view.BaseDialog, "attack_berlin.ui.LegionAwardDIalog")


local model = qy.tank.model.AttackBerlinModel
local service = qy.tank.service.AttackBerlinService
function LegionAwardDIalog:ctor(delegate)
   	LegionAwardDIalog.super.ctor(self)

     local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "attack_berlin/res/weigongbolin.png",
        ["onExit"] = function()
           self:removeSelf()
        end
    })
    self:addChild(style, 13)
   	self:InjectView("awardbg")
    self:InjectView("listbg")
    self:InjectView("listbg1")
    self:InjectView("recordBt")
    self:InjectView("getBt")
    -- self:InjectView("closeBt")

    -- self:OnClick("closeBt", function()
    --     self:removeSelf()
    -- end,{["isScale"] = false})
    self:OnClick("recordBt", function()
        service:checklog(function (  )
            require("attack_berlin.src.RecordDialog").new({
            ["types"] = 1,
            }):show()
        end)
       
    end,{["isScale"] = false})

    self:OnClick("getBt", function()
        service:getAward(function (  )
            model.my_awardslist = {}
            self:update()
        end)
    end,{["isScale"] = false})

    self.listbg:addChild(self:__createList())
    self.listbg1:addChild(self:__createRankList())
    self:update()
end
function LegionAwardDIalog:__createList()
    local tableView = cc.TableView:create(cc.size(440, 340))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(12, 8)
    tableView:setDelegate()
    local num = #model.total_awards
    local function numberOfCellsInTableView(tableView)
        return math.ceil(num/2)
    end

    local function cellSizeForTable(tableView,idx)
        return 440, 100
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("attack_berlin.src.LegionAwardCell").new({
                ["num"] = math.ceil(num/2),
                ["callback"] = function (  )
                    self:update()
                    local listCurY = self.tableViewList:getContentOffset().y
                    self.tableViewList:reloadData()
                    self.tableViewList:setContentOffset(cc.p(0,listCurY))  
                end
                })
            cell:addChild(item)
            cell.item = item
        end

        cell.item:render( idx+1,num%2)

        
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
function LegionAwardDIalog:update()

    local award = model.my_awardslist
    self.awardbg:removeAllChildren(true)
    for i=1,#award do
        local item = qy.tank.view.common.AwardItem.createAwardView(award[i].award ,1)
        self.awardbg:addChild(item)
        item:setPosition(-40 + 95 * i, 50)
        item:setScale(0.75)
        item.name:setVisible(false)
    end
    if award[1] then
        self.getBt:setTouchEnabled(true)
        self.getBt:setBright(true)
    else
        self.getBt:setTouchEnabled(false)
        self.getBt:setBright(false)
    end
 
end
function LegionAwardDIalog:__createRankList()
    local tableView = cc.TableView:create(cc.size(520, 460))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(2, 10)
    tableView:setDelegate()
    local function numberOfCellsInTableView(tableView)
        return #model.cansendlist
    end

    local function cellSizeForTable(tableView,idx)
        return 515, 100
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("attack_berlin.src.RankCell").new({
                ["data"] = model.cansendlist,
                ["callback"] = function (  )
                    local listCurY = self.tableViewrankList:getContentOffset().y
                    self.listbg1:removeAllChildren(true)
                    self.listbg1:addChild(self:__createRankList())
                    self.tableViewrankList:setContentOffset(cc.p(0,listCurY))  
                end
                })
            cell:addChild(item)
            cell.item = item
        end

        cell.item:render( idx+1)

        
        return cell
    end

    local function tableAtTouched(table, cell)

    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableAtTouched,cc.TABLECELL_TOUCHED)

    tableView:reloadData()

    self.tableViewrankList = tableView
    

    return tableView
end
function LegionAwardDIalog:onEnter()
    self.listener_1 = qy.Event.add(qy.Event.ATTACKBERLIN1,function(event)
        self:update()
        self.listbg:removeAllChildren(true)
        self.listbg:addChild(self:__createList())
    end)    
end

function LegionAwardDIalog:onExit()
    qy.Event.remove(self.listener_1)
    self.listener_1 = nil
 
end


return LegionAwardDIalog
