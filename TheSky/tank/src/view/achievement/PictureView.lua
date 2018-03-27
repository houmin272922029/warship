--[[
--图鉴
--Author: mingming
--Date:
]]

local PictureView = qy.class("PictureView", qy.tank.view.BaseView, "view/achievement/PictureView")

local model = qy.tank.model.AchievementModel
PictureView.enableCallback = true

function PictureView:ctor(delegate)
    PictureView.super.ctor(self)
    self:InjectView("Panel_1")
    self:InjectView("Panel_2")
    self:InjectView("Num")
    self:InjectView("TotalNUm")

    -- self:createTouch()

    self:createTable1()
    self:createTable2()
    self.Num:setString(qy.TextUtil:substitute(1022) .. table.nums(model.openPicList) .. "/ " .. table.nums(model.totalPicList))
    -- self.TotalNUm:setString("/ " .. table.nums(model.totalPicList))
end

-- 图鉴列表
function PictureView:createTable1()
    -- local allHeight = model:getAllHeight()

    -- local scrollView = ccui.ScrollView:create()
    -- scrollView:setTouchEnabled(true)
    -- scrollView:setContentSize(605, 400)
    -- scrollView:setDirection(ccui.ScrollViewDir.vertical)
    -- scrollView:setPosition(0, 30)
    -- scrollView:setInnerContainerSize(cc.size(TOTAL_WIDTH, allHeight))
    -- -- self.enableCallback = true
    -- -- scrollView:addChild(self.voidNode)
    -- scrollView:addEventListener(function(sender, eventype)
    --     if eventype == ccui.ScrollviewEventType.scrolling then
    --         self.enableCallback = false
    --     elseif eventype == ccui.ScrollviewEventType.scrollStop then  -- 滚动停止事件
    --         self.enableCallback = true
    --     end
    -- end)

    -- -- self.
    -- self.Panel_1:addChild(scrollView)

    -- local delHeigth = 0
    -- for i = 1, table.nums(model._types) do
    --     local v = model._types[tostring(i)]
    --     local item = qy.tank.view.achievement.PictureItemView.new({
    --         ["callback"] = function(entity)
    --             if self.enableCallback then
    --                 qy.tank.view.tip.TankTip2.new(entity):show()
    --             end
    --         end,
    --     })

    --     local height = model:getHeight(v)
    --     delHeigth = delHeigth + height
    --     item:setPositionY(allHeight - delHeigth)
    --     item:setData(model:getList(v), height, v)
    --     scrollView:addChild(item)
    -- end


    local tableView = cc.TableView:create(cc.size(605, 350))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(0, 30)
    self.Panel_1:addChild(tableView)
    -- tableView:addChild(layer)
    tableView:setDelegate()

    local data = model.picFinalList

    local function numberOfCellsInTableView(tableView)
        return table.nums(data)
    end

    local function cellSizeForTable(tableView,idx)
        return 200, 143
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil
        -- local data = model:getList(idx)
        -- local height = model:getHeight(idx)
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.achievement.PictureFragment.new({
                ["callback"] = function(entity)
                    if not tableView:isTouchMoved() then
                        qy.tank.view.tip.TankTip2.new(entity):show()
                    end
                end,
                ["data"] = data[idx + 1],
            })
            cell:addChild(item)
            cell.item = item
        end
        cell.item:setData(data[idx + 1], idx)
        return cell
    end

    local function touchAtCell(tableView, cell)

    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(touchAtCell,cc.TABLECELL_TOUCHED)

    tableView:reloadData()

    return tableView
end

-- 属性加成列表
function PictureView:createTable2()
    local tableView = cc.TableView:create(cc.size(300, 280))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(0, 70)
    self.Panel_2:addChild(tableView)
    -- tableView:addChild(layer)
    tableView:setDelegate()

    local function numberOfCellsInTableView(tableView)
        return table.nums(model.picAttribute)
    end

    local function cellSizeForTable(tableView,idx)
        return 300, 40
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil
        -- local data = model:getList(idx)
        -- local height = model:getHeight(idx)
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.achievement.Attribute.new({

            })
            cell:addChild(item)
            cell.item = item
        end
        cell.item:setData(model.onlyPicAttr[idx + 1], idx)
        return cell
    end

    local function touchAtCell(tableView, cell)

    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(touchAtCell,cc.TABLECELL_TOUCHED)

    tableView:reloadData()
    self.tableView2 = tableView
    return tableView
end

function PictureView:update()
    self.tableView2:reloadData()
end

-- function PictureView:createTouch()
--     self.listener = cc.EventListenerTouchOneByOne:create()
--     local function onTouchBegan(touch, event)
--         print("==========begin")
--         -- self.touchPoint = self.panel:convertToNodeSpace(touch:getLocation())
--         return true
--     end

--     local function onTouchMoved(touch, event)
--         print("==========move")
--         -- self.touchPoint = self.panel:convertToNodeSpace(touch:getLocation())
--         return true
--     end

--     local function onTouchEnded(touch, event)
--         print("==========end")
--         -- self.touchPoint = self.panel:convertToNodeSpace(touch:getLocation())
--         -- if self.currentTank then
--         --     self:jude()
--         --     self:endDrag()
--         -- end
--         return true
--     end

--     self.listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
--     self.listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED)
--     self.listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED)
--     self.listener:setSwallowTouches(false)
--     self.eventDispatcher = self:getEventDispatcher()
--     self.eventDispatcher:addEventListenerWithSceneGraphPriority(self.listener,self)
--     -- self.eventDispatcher:setPriority(self.listener, 100)
-- end
function PictureView:onExit()
    -- cc.Director:getInstance():getTextureCache():removeAllTextures()
end

return PictureView
