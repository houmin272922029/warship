local SceneListView = qy.class("SceneListView", qy.tank.view.BaseView, "soul_road.ui.SceneListView")

local model = qy.tank.model.SoulRoadModel
local soulModel = qy.tank.model.SoulModel
local service = qy.tank.service.SoulRoadService
function SceneListView:ctor(delegate, idx)
   	SceneListView.super.ctor(self)

    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "Resources/activity/title_soul_road.png", 
        showHome = true,
        ["onExit"] = function()
            delegate.viewStack:pop()
        end
    })
    self:addChild(style)

   	self:InjectView("CheckPointList")
   	self:InjectView("Name")
   	self:InjectView("Level")
   	self:InjectView("Num")
   	self:InjectView("Soul_num")
   	self:InjectView("Soul_name")
   	self:InjectView("Attr")
    self:InjectView("Attr2")
   	self:InjectView("Times")
    self:InjectView("Image_2")
   	-- self:InjectView("Resource1")
   	-- self:InjectView("Resource2")
   	-- self:InjectView("IsMy")
   	-- self:InjectView("Name")
   	-- self:InjectView("NameBg")
   	-- self:InjectView("Btn_view")
    self.list = {}

    self:OnClick("Btn_fight", function()
        service:attack(self.selectItem.entity.checkpoint_id, function(data)
            qy.tank.manager.ScenesManager:pushBattleScene()
        end)
    end,{["isScale"] = false})

    -- self:OnClick("Btn_home", function()
    --    delegate:finish()
    -- end,{["isScale"] = false})

    self:OnClick("Btn_buy", function()
        require("soul_road.src.BuyDialog").new(self):show()
    end,{["isScale"] = false})

    self:OnClick("Btn_award", function()
        if model.complete > 0 then
            if model.is_draw_daily_award ~= 1 then
                require("soul_road.src.DailyRewardsDialog").new(self):show()
            else
                qy.hint:show(qy.TextUtil:substitute(67013))
            end
        else
            qy.hint:show(qy.TextUtil:substitute(67015))
        end
    end,{["isScale"] = false})

    self:OnClick("Btn_autofight", function()
        require("soul_road.src.AutoFightDialog").new(self.selectItem.entity):show()
    end,{["isScale"] = false})

    self:OnClick("Btn_soul", function()
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.SOUL)
    end,{["isScale"] = false})

    self:OnClick("Btn_lineup", function()
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EMBATTLE)
    end,{["isScale"] = false})

    self.idx = idx
    self.current = model.current_scene == idx

    self.CheckPointList:addChild(self:createView())

    if not self.current then
        self:select(model:getCheckPointByScene(self.idx)[1])
    end

    -- self:update()

    -- if model.current_scene == idx then
    --     self.current = true
    -- else

    -- end
    -- self:initCar()
    -- self:setData(delegate)
end

function SceneListView:createView()
    local tableView = cc.TableView:create(cc.size(350, 580))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    -- tableView:setSwallowTouches(false)
    tableView:setPosition(8, 5)
    tableView:setDelegate()

    -- self.tanks = {}
    local data = model:getCheckPointByScene(self.idx)

    local function numberOfCellsInTableView(tableView)
        return #data
    end

    local function cellSizeForTable(tableView,idx)
        return 350, 165
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil
 
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("soul_road.src.CheckPointView").new(self)
            cell:addChild(item)
            cell.item = item
            -- if idx == 0 then
            --     cell.item.light:setVisible(true)
            --     -- self.selectTank = cell
            -- end
            if not self.current and idx == 0  then
                self.selectItem = cell.item
            end
            table.insert(self.list, cell)
        end

        cell.item:render(data[idx+1], self.idx)
        cell.item.entity = data[idx+1]

        if self.current and data[idx+1].checkpoint_id == model.current then
            self.selectItem = cell.item
            self:select(cell.item.entity)
            -- self:switchTo(idx)
        end
        cell.item.idx = idx + 1
        return cell
    end

    local function tableAtTouched(table, cell)
        if cell.item.entity.checkpoint_id <= model.current then
            self.selectItem = cell.item
            self:select(cell.item.entity)
        else
            qy.hint:show(qy.TextUtil:substitute(67016))
        end
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableAtTouched,cc.TABLECELL_TOUCHED)
    
    tableView:reloadData()

    self.tankViewList = tableView

    return tableView
end

function SceneListView:select(data)
    for i, v in pairs (self.list) do
        v.item.Light:setVisible(false)
    end

    if self.selectItem then
        self.selectItem.Light:setVisible(true)
    end
    self.Name:setString(data.name)
    self.Num:setString(qy.TextUtil:substitute(67017) .. data.checkpoint_id .. ":")
    self.Level:setString("Lv." .. data.level)
    if model.complete + 1 == data.checkpoint_id then
        self.Soul_num:setString(qy.TextUtil:substitute(67018) .. data.first_num .. qy.TextUtil:substitute(67019))
    else
        self.Soul_num:setString(qy.TextUtil:substitute(67018) .. data.num)
    end
    if data.drop_award[1] then
        local  item = qy.tank.view.common.AwardItem.getItemData(data.drop_award[1])
        if not self.itemView then
            local view = qy.tank.view.common.ItemIcon.new()  
            view:setPosition(230, 148)
            
            self.itemView = view
            self.Image_2:addChild(view)
        else
            self.itemView:setVisible(true)
        end

        self.itemView:setData(item)
        self.itemView.num:setVisible(false)
        self.itemView.name:setVisible(false)

        self.Soul_name:setString(item.name .. "  Lv.1")
        self.Soul_name:setVisible(true)

        local attr1 = item.entity:getAttr1()
        if item.entity.soulType == 5 or item.entity.soulType == 6 or item.entity.soulType == 7 or item.entity.soulType == 8 or item.entity.soulType == 4 then
            attr1.num = attr1.num / 10 .. "%"
        end
        
        self.Attr:setString(attr1.name .. "+" .. attr1.num)
        self.Attr:setVisible(true)
        self.Attr2:setVisible(true)
    else
        self.Soul_name:setVisible(false)
        self.Attr:setVisible(false)
        self.Attr2:setVisible(false)
        if self.itemView then
            self.itemView:setVisible(false)
        end
    end
end

function SceneListView:update(idx)

    self.Times:setString(model.left_free_times + model.left_buy_times)
    if idx then
        self:switchTo(idx)
    end

    local data = model:getCheckPointByScene(self.idx)

    if data[#data].checkpoint_id < model.current and data[#data].checkpoint_id == model.complete then
        performWithDelay(self, function()
            -- qy.hint:show(qy.TextUtil:substitute(67020))
        end, 0.2) 
    end
end

function SceneListView:switchTo(idx)
    local data = model:getCheckPointByScene(self.idx)
    if self.selectItem then
        self:select(data[idx])
    end

    -- self.tankViewList:getMinOff
    self.tankViewList:setContentOffset(cc.p(0, math.min(-165 * (#data - idx) + 410,  self.tankViewList:maxContainerOffset().y)), false)
end

function SceneListView:onEnter()
    self.tankViewList:reloadData()
    self:update(model:getCurrentIdx(self.idx))

    self.listener_1 = qy.Event.add(qy.Event.SOUL_ROAD,function(event)
        self:update()
    end)
end

function SceneListView:onExit()
    qy.Event.remove(self.listener_1)
end

return SceneListView
