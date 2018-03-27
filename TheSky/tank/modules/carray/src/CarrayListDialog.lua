local CarrayListDialog = qy.class("CarrayListDialog", qy.tank.view.BaseDialog, "carray.ui.CarrayListDialog")

local model = qy.tank.model.CarrayModel
function CarrayListDialog:ctor(delegate)
   	CarrayListDialog.super.ctor(self)

    -- 通用弹窗样式
    self:InjectView("Pages")
    local style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(830, 565),
        position = cc.p(0, 0),
        offset = cc.p(0, 0),
        titleUrl = "carray/res/zudueiyayun.png",

        ["onClose"] = function()
            self:dismiss()
        end
    })
    self:addChild(style)
    style:setLocalZOrder(-1)
    self.style = style

    self.view = {}
    for i = 1, 2 do
        for j = 1, 2 do
            local view = require("carray.src.CarrayItemView").new(self)
            view:setPosition(370 * (i - 1) + 40, 220 * (j - 1) + 70)
            style.bg:addChild(view)
            table.insert(self.view, view)
        end
    end

    self:OnClick("BtnRight", function()
        model:nextTeamPage()
        self:update()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self:OnClick("BtnLeft", function()
        model:preTeamPage()
        self:update()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self.delegate = delegate
    
    self.Pages:setString(model.teamPage .. "/" .. model.teamCount)

    self:update()
end

function CarrayListDialog:update()
    for i = 1, 4 do
        local idx = 4 * (model.teamPage -1) + i
        self.view[i]:setData(model.teamList["p_" .. idx], idx)
    end

    self.Pages:setString(model.teamPage .. "/5")
    self.delegate:update()
end

function CarrayListDialog:onEnter()
    if cc.UserDefault:getInstance():getStringForKey("carrayGuide", "") == "" then
        require("carray.src.SpeakDialog").new():show()
        cc.UserDefault:getInstance():setStringForKey("carrayGuide", "111")
    end
end

-- function CarryListDialog:createView()
-- 	local tableView = cc.TableView:create(cc.size(800, 395))
--     tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
--     tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
--     -- tableView:setSwallowTouches(false)
--     tableView:setPosition(0, 0)

--     -- local data = entity:getAttributelist()

--     local function numberOfCellsInTableView(tableView)
--         return 10
--     end

--     local function cellSizeForTable(tableView,idx)
--         return 800, 98
--     end

--     local function tableCellAtIndex(tableView, idx)
--         local cell = tableView:dequeueCell()
--         local item = nil
--         local label = nil
--         -- local data = model:getList(idx)
--         -- local height = model:getHeight(idx)
--         if nil == cell then
--             cell = cc.TableViewCell:new()
--             item = require("carray.src.RecordItemView").new()
--             cell:addChild(item)
--             cell.item = item
--         end

--         cell.item:setData(idx)
--         return cell
--     end

--     tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
--     tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
--     tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
--     tableView:reloadData()

--     return tableView
-- end

return CarrayListDialog
