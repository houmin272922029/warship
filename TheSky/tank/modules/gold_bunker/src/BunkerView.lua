local BunkerView = qy.tank.module.BaseUI.class("BunkerView", "gold_bunker.ui.BunkerView")

local Model = require("gold_bunker.src.Model")
local BunkerItem = require("gold_bunker.src.BunkerItem")
local RewardsDialog = require("gold_bunker.src.RewardsDialog")

ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("gold_bunker/fx/ui_fx_dboos.pvr.ccz",
                                                               "gold_bunker/fx/ui_fx_dboos.plist",
                                                               "gold_bunker/fx/ui_fx_dboos.xml", function() end)

function BunkerView:ctor()
    BunkerView.super.ctor(self)

    self.ui.dianti1_4:setPositionX(200 + (display.width - 1080))

    local levelLabel = ccui.TextAtlas:create("1", "gold_bunker/fx/level_number.png", 26, 25, '0')
    levelLabel:setPosition(71, 320)
    levelLabel:addTo(self.ui.jiaoxiang2_18)

    self.ui.levelLabel = levelLabel

    self:createTableView()
end

function BunkerView:createTableView()
    local tableView = cc.TableView:create(display.size)
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:addTo(self, -1)

    local level_count = Model:getLevelCount()

    local function numberOfCellsInTableView(tableView)
        return level_count + 2
    end

    local function cellSizeForTable(tableView, idx)
        return display.width, 260
    end

    local function tableCellAtIndex(tableView, idx)
        return (tableView:dequeueCell() or BunkerItem.new()):setLevel(idx, level_count)
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:setTouchEnabled(false)
    tableView:reloadData()

    if Model:getInitData().current_id > 3 then
        local y = tableView:minContainerOffset().y + ((Model:getInitData().current_id - 4) * 260) + 62
        tableView:setContentOffset(cc.p(0, y))
    end

    self._tableView = tableView
end

function BunkerView:setCurreltLevel(level)
    local y = self._tableView:minContainerOffset().y + ((level - 1) * 260) + 62
    self._tableView:setContentOffsetInDuration(cc.p(0, y), 0.8)

    self.ui.levelLabel:setString(level)
    self.ui.progress:setPercent(level / Model:getLevelCount() * 100)
end

function BunkerView:onEnter()
    self.ui.highest:setString(qy.TextUtil:substitute(46001) .. Model:getInitData().max_id)
    print(Model:getInitData().current_id)
    print(Model:getLevels()[Model:getInitData().current_id])
    print(Model:getLevels()[Model:getInitData().current_id].first_award)
    print(Model:getLevels()[Model:getInitData().current_id].first_award[1].num)

    self.ui.Img_award:loadTexture(qy.tank.utils.AwardUtils.getAwardIconByType(Model:getLevels()[Model:getInitData().current_id].first_award[1].type))
    self.ui.first_reward:setString("x" .. Model:getLevels()[Model:getInitData().current_id].first_award[1].num)

    self.ui.times_2:setSpriteFrame("gold_bunker/res/" .. (Model:getInitData().checkpoint_times > 1 and "xin" or "xin1") .. ".png")

    local moveUp = cc.MoveBy:create(0.2, cc.p(0,10))
    local moveDown = cc.MoveBy:create(0.2, cc.p(0,-10))
    local seq = cc.Sequence:create(moveUp, moveDown)
    self.ui.arrow:stopAllActions()
    self.ui.arrow:setPosition(725.50, 249)
    self.ui.arrow:runAction(cc.RepeatForever:create(seq))
end

function BunkerView:onEnterFinish()
    -- 两次挑战失败了，反回主界面
    if Model:getInitData().status == 0 then
        self:finish()
    else
        self:setCurreltLevel(Model:getInitData().current_id)
    end
end

return BunkerView
