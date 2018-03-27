local RecordDialog = qy.class("RecordDialog", qy.tank.view.BaseDialog, "attack_berlin.ui.RecordDialog")


local model = qy.tank.model.AttackBerlinModel
local service = qy.tank.service.AttackBerlinService
function RecordDialog:ctor(delegate)
   	RecordDialog.super.ctor(self)
   	self:InjectView("titleimg")
    self:InjectView("listbg")
    self:InjectView("closeBt")

    self:OnClick("closeBt", function()
        self:removeSelf()
    end,{["isScale"] = false})
    self.types = delegate.types
    self.data = {}
    self.award_id = 0
    self.delegate = delegate
    self:updatetitle()
    self.listbg:addChild(self:__createList())

end
function RecordDialog:updatetitle(  )
	if self.types == 1 then
		self.titleimg:setTexture("attack_berlin/res/fenpeijilu.png")
        self.data = model.loglist
    elseif self.types == 2 then
        self.titleimg:setTexture("attack_berlin/res/zhanbao.png")
        self.data = model.combatlist
    elseif self.types == 3 then
        self.data = model.memberlist
        self.award_id = self.delegate.award_id
        self.titleimg:setTexture("attack_berlin/res/juntuanjiangli_1.png")
	end
end
function RecordDialog:__createList()
    local tableView = cc.TableView:create(cc.size(440, 425))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(10, 8)
    tableView:setDelegate()
    local function numberOfCellsInTableView(tableView)
        return #self.data
    end

    local function cellSizeForTable(tableView,idx)
        return 440, 95
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            if self.types == 1 or self.types == 3 then
                item = require("attack_berlin.src.RecordCell").new({
                    ["data"] = self.data,
                    ["types"] = self.types,
                    ["award_id"] = self.award_id,
                    ["callback"] = function (  )
                        self:removeSelf()
                    end
                    })
            else
                item = require("attack_berlin.src.DetialCell").new({
                    ["data"] = self.data,
                    ["types"] = self.types,
                    })
            end
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


return RecordDialog
