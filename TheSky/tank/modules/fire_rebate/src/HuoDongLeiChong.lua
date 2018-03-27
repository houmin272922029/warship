--[[--
    
--]]--

local HuoDongLeiChong = qy.class("HuoDongLeiChong", qy.tank.view.BaseView, "fire_rebate/ui/HuoDongLeiChong")

function HuoDongLeiChong:ctor(delegate)
    HuoDongLeiChong.super.ctor(self)
    self.model = qy.tank.model.FireRebateModel
    self.dataCf = self.model:ReturnActivityCf()
    self:InjectView("qiandaobtn")
    self:InjectView("BG")
    self:InjectView("RechageNum")
    self:InjectView("Panel_1")
    self.BG:setVisible(false)
    self:createTableView()

    self:UpdateDate()
end

function HuoDongLeiChong:render(idx)

end

function HuoDongLeiChong:createTableView()

    local widt = 738
    local tableView = cc.TableView:create(cc.size(widt,326))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setAnchorPoint(0,0)
    tableView:ignoreAnchorPointForPosition(false)
    local function numberOfCellsInTableView(tablev)
        local num = table.nums(self.dataCf)
        return num
    end

    local function cellSizeForTable(table, idx)
        return widt, 140
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("fire_rebate.src.RechageGiftCell").new({
                ["updateList"] = function()
                    tableView:reloadData()
                end,
                ["CloseParentFun"] = function()
                    self.CloseParentFun()
                end
            })
            cell:addChild(item)
            cell.item = item
        end
        local num = idx + 1
        cell.item:render(num,self.dataCf[num..""])
        return cell
    end
    tableView:setPosition(263,113)
    tableView:setPosition(0,0)

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()

    self._tableView = tableView

    if self._tableView == nil then
        print("================nil=====")
        return
    end
    self.Panel_1:addChild( self._tableView,999 )
end

-- 

function HuoDongLeiChong:UpdateDate(  )
    local ConNum = self.model:GetActivityConNum()
    self.RechageNum:setString( "当前已充:"..ConNum.."元" )

    -- 次数用完了   你要买次数撒  
    if ConNum <= 0 then

    end
end



return HuoDongLeiChong