


local CheckAllView = qy.class("CheckAllView", qy.tank.view.BaseDialog,"server_exercise/ui/CheckAllView")

local model = qy.tank.model.ServerExerciseModel

function CheckAllView:ctor(delegate)
	CheckAllView.super.ctor(self)
  self.delegate = delegate
   -- 通用弹窗样式
  self.style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(700,570),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "server_exercise/res/chenghao.png",--ranking_title

        ["onClose"] = function()
            self:dismiss()
        end
  })
  self.style:setPositionY(-50)
  self:addChild(self.style,-1)
  	 
  -- self:__createList()
  self:InjectView("list")
  self.list1 = self:__createList()
  self.list:addChild(self.list1)
  	

  
end
function CheckAllView:__createList()
    local tableView = cc.TableView:create(cc.size(670, 480))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(8,-15)
    tableView:setDelegate()
    
   
    -- self.roomList = cc.TableView:create(cc.size(qy.winSize.width+88,537))
    -- self.roomList:setDirection(cc.TABLEVIEW_FILL_TOPDOWN)
    -- self.roomList:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    -- self.roomList:setAnchorPoint(0,0.5)
    -- self.roomList:setPosition(-90,100)

    -- self.style:addChild(tableView,1)
  

    local function numberOfCellsInTableView(table)
        return  #model.configlist
    end

    local function cellSizeForTable(tableView, idx)
        return 655, 120
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("server_exercise.src.TitleCell").new()
            cell:addChild(item)
            cell.item = item
        end
        cell.item.idx = idx
        cell.item:render(idx+1)
        return cell
    end
    local function tableAtTouched(table, cell)

    end
    local function tableCellTouched(table,cell)
        
    end

     tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
     tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
     tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
     tableView:registerScriptHandler(tableAtTouched,cc.TABLECELL_TOUCHED)
     tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
     tableView:reloadData()
     return tableView
  
end


return CheckAllView