--[[
	排行
	Author: H.X.Sun
]]
local RankDialog = qy.class("RankDialog", qy.tank.view.BaseDialog, "war_aid/ui/RankDialog")

function RankDialog:ctor(param)
   	RankDialog.super.ctor(self)
    self:InjectView("BG")
    self:InjectView("Rank")
    self.param = param

    self.style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(750,540),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "war_aid/res/aid_title.png",
        ["onClose"] = function()
            self:dismiss()
        end
    })
    self:addChild(self.style, -1)
    self.model = qy.tank.model.OperatingActivitiesModel

    self.BG:addChild(self:createView())
    local rank = param.data.my_rank == 0 and qy.TextUtil:substitute(90116) or param.data.my_rank
    self.Rank:setString(rank)
end

function RankDialog:createView()
    local tableView = cc.TableView:create(cc.size(720, 360))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(-20, 5)
    local rank_list = self.param.data.rank_list

    local function numberOfCellsInTableView(tableView)
        return 20
    end

    local function cellSizeForTable(tableView,idx)
        return 720, 50
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.operatingActivities.war_aid.RankItem.new()
            cell:addChild(item)
            cell.item = item
        end

        cell.item:setData({
            ["data"] = rank_list[idx + 1],
            ["award"] = self.model:getAidRankData(self.param.cur_aid, idx + 1),
            ["idx"] = idx + 1,
            ["cur_aid"] = self.param.cur_aid,
        })
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
