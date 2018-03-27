-- local MainDialog = qy.tank.module.BaseUI.class("MainDialog", "pub.ui.MainDialog")
local AchievementRewardDialog = qy.class("AchievementRewardDialog", qy.tank.view.BaseDialog, "pub.ui.AchievementRewardDialog")

local model = qy.tank.model.OperatingActivitiesModel
local service = qy.tank.service.OperatingActivitiesService
function AchievementRewardDialog:ctor(delegate)
    AchievementRewardDialog.super.ctor(self)

    self.delegate = delegate
     -- 通用弹窗样式
    local style = qy.tank.view.style.DialogStyle2.new({
        size = cc.size(760,515),   
        position = cc.p(0,0),
        offset = cc.p(0,0), 
        bgOpacity = 200,
        titleUrl = "Resources/common/title/ganbeichengjiujiangli.png",

        ["onClose"] = function()
            self:dismiss()
        end
    })
    self:addChild(style, -1)

    -- self:InjectView("Bg")
    self:InjectView("Times")

    style:changeHeadBgSize(90)
    -- self:InjectView("Buttom")

    -- self.Buttom:setLocalZOrder(7)

    -- self:OnClick("Close", function()
    --     self:dismiss()
    -- end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    style.bg:addChild(self:createView())

    self.Times:setString(model.pubTotalTimes)
end

function AchievementRewardDialog:createView()
    local tableView = cc.TableView:create(cc.size(715, 400))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(20, 10)

    local data = model:getRank()

    local function numberOfCellsInTableView(tableView)
        return table.nums(model.pubAchieveList)
    end

    local function cellSizeForTable(tableView, idx)
        return 715, 150
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil
        -- local data = model:getList(idx)
        -- local height = model:getHeight(idx)
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("pub.src.RewardItem").new({
                ["onReward"] = function(entity, callback)
                    service:pubAchieveReward(entity.times, function(reData)
                        qy.tank.command.AwardCommand:add(reData.award)
                        qy.tank.command.AwardCommand:show(reData.award)
                        table.insert(model.pubAchieveGetList, tostring(entity.times))
                        entity.status = 2
                        self.delegate:update()
                        callback()
                    end,false)
                end,
            })
            cell:addChild(item)
            cell.item = item
        end

        cell.item:setData(model:pubAtAchieveId(idx))
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()

    return tableView
end

return AchievementRewardDialog
