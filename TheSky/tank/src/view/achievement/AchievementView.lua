--[[
--图鉴
--Author: mingming
--Date:
]]

local AchievementView = qy.class("AchievementView", qy.tank.view.BaseView, "view/achievement/AchievementView")

local model = qy.tank.model.AchievementModel
function AchievementView:ctor(delegate)
	AchievementView.super.ctor(self)
    self:InjectView("Panel_1")
	local info = qy.tank.view.achievement.InfoView.new()
	local winSize = cc.Director:getInstance():getWinSize()
	info:setPosition(120, -445)
	self.Panel_1:addChild(info)
    self.Panel_1:addChild(self:createTableView())
end

function AchievementView:createTableView()
	local tableView = cc.TableView:create(cc.size(900, 400))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(-5, -410)

    local data = model.achievementList

    local function numberOfCellsInTableView(tableView)
        return model:getAchievementNum()
    end

    local function cellSizeForTable(tableView, idx)
        return 900, model:getAchievementHeight(idx)
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil
        -- local data = model:getList(idx)
        -- local height = model:getHeight(idx)
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.achievement.AchievementItemView.new({
                ["onUpgrade"] = function(sender, dialog)
                    qy.tank.service.AchievementService:upgrade(sender.entity,function()
                        sender:update()
                        dialog:update()
                        dialog:play()
                    end)
                end,
                ["callback"] = function(entity)
                    if not tableView:isTouchMoved() then
                        qy.tank.view.tip.TankTip2.new(entity):show()
                    end
                end,
            })
            cell:addChild(item)
            cell.item = item
        end

        cell.item:setData(data[idx + 1], model:getAchievementHeight(idx))
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()

    return tableView
end

function AchievementView:update()

end
function AchievementView:onExit()
    -- cc.Director:getInstance():getTextureCache():removeAllTextures()
end

return AchievementView