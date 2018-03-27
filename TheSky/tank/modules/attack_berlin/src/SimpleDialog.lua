local SimpleDialog = qy.class("SimpleDialog", qy.tank.view.BaseDialog, "attack_berlin.ui.SimpleDialog")


local model = qy.tank.model.AttackBerlinModel
local service = qy.tank.service.AttackBerlinService
function SimpleDialog:ctor(delegate)
   	SimpleDialog.super.ctor(self)
    -- self:setCanceledOnTouchOutside(true)
   	self:InjectView("nums")
    self:InjectView("addBt")
    self:InjectView("refreshBt")
    self:InjectView("awardBt")
    self:InjectView("listbg")
    self:InjectView("closeBt")

    self:OnClick("closeBt", function()
        qy.Event.dispatch(qy.Event.ATTACKBERLIN2)
        self:removeSelf()
    end,{["isScale"] = false})
  	self:OnClick("refreshBt", function()
        service:inToGeneral(delegate.data.id,function (  )
             self:update()
        end)
    end,{["isScale"] = false})

    self:OnClick("awardBt", function()
 		require("attack_berlin.src.Tip1").new({
            ["awards"] = delegate.data.clearance_award,
            ["ids"] = delegate.data.award_id,
            ["types"] = 2,
            }):show()
    end,{["isScale"] = false})
    self:OnClick("addBt", function()
         require("attack_berlin.src.BuyDialog").new({
            ["types"] = 1,
            ["callback"] = function (  )
                self:updatetime()
            end
            }):show()
    end,{["isScale"] = false})
    self.delegate = delegate
    self:updatetime()
    self.data = model:getListBysceneid(delegate.data.id)
    self.listbg:addChild(self:__createList())

end
function SimpleDialog:updatetime(  )
    self.nums:setString("当前挑战次数："..model.times1.."次")
end
function SimpleDialog:__createList()
    local tableView = cc.TableView:create(cc.size(950, 450))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(5, 10)
    tableView:setDelegate()
    local function numberOfCellsInTableView(tableView)
        return #self.data
    end

    local function cellSizeForTable(tableView,idx)
        return 950, 125
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("attack_berlin.src.SimpleCell").new({
                ["data"] = self.data,
                ["callback"] = function (  )
                    self.delegate:callback()
                    self:update()
                    self:updatetime()
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

    self.tableViewList = tableView
    

    return tableView
end
function SimpleDialog:update(  )
    local listCurY = self.tableViewList:getContentOffset().y
    self.tableViewList:reloadData()
    self.tableViewList:setContentOffset(cc.p(0,listCurY))
end


return SimpleDialog
