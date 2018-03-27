local RankDialog = qy.class("RankDialog", qy.tank.view.BaseDialog, "earth_soul.ui.RankDialog")

local model = qy.tank.model.OperatingActivitiesModel
function RankDialog:ctor(delegate)
   	RankDialog.super.ctor(self)
    self:InjectView("BG")
    self:InjectView("Rank")
    -- self:InjectView("Attack")
    -- self:InjectView("Level")

    self.style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(765,550),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "earth_soul/res/9.png",
        ["onClose"] = function()
            self:dismiss()
        end
    })
    self:addChild(self.style)
    self.style:setLocalZOrder(-1)
    self.style:setPositionY(-15)
    self:InjectView("Time1")
    self:InjectView("Time2")

   	self:OnClick("Btn_close", function()
        self:removeSelf()
    end,{["isScale"] = false})

    self:OnClick("Btn_help", function()
        qy.tank.view.common.HelpDialog.new(qy.tank.model.HelpTxtModel:getHelpDataByIndx(21)):show(true)
    end,{["isScale"] = false})

    self.BG:addChild(self:createView())
    local rank = model.earthSoulMyRank == 0 and "未上榜" or model.earthSoulMyRank 
    self.Rank:setString(rank)
end

function RankDialog:createView()
    local tableView = cc.TableView:create(cc.size(720, 360))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    -- tableView:setSwallowTouches(false)
    tableView:setPosition(-20, 5)
    local data = qy.Config.earth_soul_rank

    local function numberOfCellsInTableView(tableView)
        return table.nums(data)
    end

    local function cellSizeForTable(tableView,idx)
        return 720, 50
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil
        -- local data = model:getList(idx)
        -- local height = model:getHeight(idx)
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("earth_soul.src.RankItem").new(self)
            cell:addChild(item)
            cell.item = item
        end

        cell.item:setData(data[tostring(idx + 1)], idx)
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()

    return tableView
end

-- function RankDialog:setTime()
--     self.Time1:setString(os.date("%Y.%m.%d %H:%M:%S", model.recahrgeDoyenBeginTime) .."   至   " .. os.date("%Y.%m.%d %H:%M:%S", model.rechargeDoyenEndTime))
--     self.Time2:setString(os.date("%Y.%m.%d %H:%M:%S", model.rechargeDoyenAwardBeginTime) .."   至   " .. os.date("%Y.%m.%d %H:%M:%S", model.rechargeDoyenAwardEndTime))
-- end

return RankDialog
