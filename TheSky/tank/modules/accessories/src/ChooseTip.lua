


local ChooseTip = qy.class("ChooseTip", qy.tank.view.BaseDialog, "accessories/ui/ChooseTip")

local model = qy.tank.model.FittingsModel
local service = qy.tank.service.FittingsService
function ChooseTip:ctor(delegate)
    ChooseTip.super.ctor(self)

    self:InjectView("closeBt")
    self:InjectView("partinfo")
    self:InjectView("okBt")
    self:InjectView("chooselist")
    

    self:OnClick("closeBt",function()
        self:removeSelf()
    end,{["isScale"] = false})

    self:OnClick("okBt",function()
        delegate.callback(self.index)
        self:removeSelf()
    end,{["isScale"] = false})
    self.data = delegate.data
    self.index = 1
    self:createList()
 
end
function ChooseTip:createList()
    self.propList = cc.TableView:create(cc.size(370,450))
    self.propList:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.propList:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.propList:setPosition(0,10)
    self.chooselist:addChild(self.propList)
    self.propList:setDelegate()
    self.cellArr1 = {}
    
    local num = #self.data
    local function numberOfCellsInTableView(table)
        return math.ceil(num/3)
    end

    local function cellSizeForTable(tableView, idx)
        return 370, 120
    end

    local function tableCellAtIndex(cTable, idx)
        local cell = cTable:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item =  require("accessories.src.PropCellList2").new({
                ["data"] = self.data,
                ["callback"] = function(index)
                    self.index = index
                    local listCurY = self.propList:getContentOffset().y
                    self.propList:reloadData()
                    self.propList:setContentOffset(cc.p(0,listCurY))
                    self:showSelectProp()
                end,
                ["isMoved"] = function ()
                    return cTable:isTouchMoved()
                end
            })
            cell:addChild(item)
            cell.item = item
            table.insert(self.cellArr1,cell)
        end
        cell.item:render(idx,self.index)
        return cell
    end

    self.propList:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.propList:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    self.propList:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)

    self.propList:reloadData()
    self:showSelectProp()
end
function ChooseTip:showSelectProp( idx )
    self.partinfo:removeAllChildren(true)
    local data = self.data[self.index]
    local node = require("accessories.src.Partinfo").new({
        ["data"] = data
        })
    node:setPosition(cc.p(140,188))
    self.partinfo:addChild(node)
end


return ChooseTip
