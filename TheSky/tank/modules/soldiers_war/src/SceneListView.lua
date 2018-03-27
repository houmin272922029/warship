local SceneListView = qy.class("SceneListView", qy.tank.view.BaseView, "soldiers_war.ui.SceneListView")

local model = qy.tank.model.SoldiersWarModel
local service = qy.tank.service.SoldiersWarService
function SceneListView:ctor(delegate)
   	SceneListView.super.ctor(self)

    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "Resources/activity/title_soldier_battle.png",
        showHome = false,
        ["onExit"] = function()
            delegate.viewStack:pop()
        end
    })
    self:addChild(style)

   	self:InjectView("CheckPointList")
   	self:InjectView("Name")
   	self:InjectView("Strength")
   	self:InjectView("Num")
   	self:InjectView("Times")
    self:InjectView("tank_img")
    self:InjectView("Chest_bg")
    self:InjectView("scrollView")
    self:InjectView("ps_bg")
    self:InjectView("LoadingBar")
    self:InjectView("Tank")
    self:InjectView("Begin")
    self:InjectView("Continue")

    self.viewStack = delegate.viewStack

    self:OnClick("bagin_btn", function()
        service:chanllenge(model.current_id,function(data)
            qy.tank.manager.ScenesManager:pushBattleScene()
        end)
    end,{["isScale"] = false})





    self:OnClick("buy_btn", function()
        require("soldiers_war.src.BuyDialog").new(self):show(self)
    end,{["isScale"] = false})

    self:OnClick("formation_btn", function()
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EMBATTLE)
    end,{["isScale"] = false})

    self:OnClick("end_btn", function()
         service:reset(function(data)
            delegate.viewStack:pop()
        end)
    end,{["isScale"] = false})


    self:OnClick("Btn_help", function()
        qy.tank.view.common.HelpDialog.new(24):show(true)
    end, {["isScale"] = false})

    self.chest_list = {}

    self.cp_data = model:getCheckPointsById()
    self.chest_data = model:getChest()

    self.CheckPointList:addChild(self:createCheckPointView(), -1)
    self.CheckPointList:setLocalZOrder(1)
    self.CheckPointList:setSwallowTouches(true)
    self:createChestView()


    if model.award and model.current_times == 0 then
        qy.tank.command.AwardCommand:add(model.award)
        qy.tank.command.AwardCommand:show(model.award)
        model.award = nil
    end
end

function SceneListView:createCheckPointView()
    local tableView = cc.TableView:create(cc.size(445, 545))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    -- tableView:setSwallowTouches(false)
    tableView:setPosition(10, 17)
    tableView:setDelegate()

    local function numberOfCellsInTableView(tableView)
        return #self.cp_data
    end

    local function cellSizeForTable(tableView,idx)
        return 445, 145
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("soldiers_war.src.CheckPointView").new(self)
            cell:addChild(item)
            cell.item = item
        end

        cell.item:render(self.cp_data[idx+1], self.idx)
        cell.item.entity = self.cp_data[idx+1]

        if model.current_id and self.cp_data[idx+1].checkpoint_id == model.current_id and model.max_id ~= model.checkpoint_size then
            cell.item.selected_bg:setVisible(true)

        elseif (model.current_id and tonumber(self.cp_data[idx+1].checkpoint_id) < tonumber(model.current_id)) or model.max_id == model.checkpoint_size then
            cell.item.completed:setVisible(true)
            cell.item.Sprite_11:setVisible(true)
            cell.item.tank_icon.fatherSprite:setColor(cc.c3b(70, 70, 70))

        end

        cell.item.idx = idx + 1
        return cell
    end

    local function tableAtTouched(table, cell)
        print(1)
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableAtTouched,cc.TABLECELL_TOUCHED)

    tableView:reloadData()

    self.tankViewList = tableView

    return tableView
end



function SceneListView:createChestView()

    local size_width = 100 * #self.chest_data + 39
    local node = cc.Node:create()
    node:setContentSize(cc.size(size_width, 139))
    self.scrollView:setInnerContainerSize(cc.size(size_width, 139))
    self.scrollView:addChild(node)

    for i, v in pairs(self.chest_data) do
        item = require("soldiers_war.src.ChestView").new(self, i)
        item:setPosition(61 + 100 * (i - 1), 0)

        node:addChild(item)

        table.insert(self.chest_list, item)
    end


    self.ps_bg = ccui.ImageView:create()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("soldiers_war/res/Plist.plist")
    self.ps_bg:loadTexture("soldiers_war/res/9.png",1)
    self.ps_bg:setScale9Enabled(true)
    self.ps_bg:setAnchorPoint(0, 0.5)
    self.ps_bg:setContentSize(cc.size(size_width - 30, 38))
    self.ps_bg:setPosition(0, 116)
    self.ps_bg:setCapInsets(cc.rect(181,12,189,14))
    node:addChild(self.ps_bg)

    self.LoadingBar = ccui.LoadingBar:create()
    self.LoadingBar:loadTexture("soldiers_war/res/11.jpg")
    self.LoadingBar:ignoreContentAdaptWithSize(false)
    self.LoadingBar:setDirection(0)
    self.LoadingBar:setPercent(0)
    self.LoadingBar:setAnchorPoint(0, 0.5)
    self.LoadingBar:setPosition(7, 20)
    self.LoadingBar:setContentSize(cc.size(size_width - 10 - 30, 30)) --10是进度条与背景长度的偏移， 33是为了最后一关的点正好指向进度条结尾
    self.ps_bg:addChild(self.LoadingBar, -1)

    self:updateChest()

end


function SceneListView:updateChest()
    for i, v in pairs(self.chest_data) do
        local item = self.chest_list[i]
        local callback = function(data)
            require("soldiers_war.src.ChestDetailsDialog").new(data):show()
        end

        local cp_id = tonumber(v.checkpoint_id)

        if cp_id < model.current_id or model.max_id == model.checkpoint_size then
            item:render(v, "open", callback)
        elseif cp_id - model.current_id < 10 then
            item:render(v, "current", callback)
        else
            item:render(v, "", callback)
        end
    end

    self.LoadingBar:setPercent((model.current_id - 1) / model.checkpoint_size * 100)
end




function SceneListView:switchTo()
    local idx = model:getCurrentIdx()
    self.tankViewList:setContentOffset(cc.p(0, math.min(-145 * (5 - idx) + 395,  self.tankViewList:maxContainerOffset().y)), false)


    if model.current_id > 40 then
        self.scrollView:scrollToPercentHorizontal((61 + 100 * (model.current_id)) / (61 + 100 * (model.checkpoint_size)) * 100, 0, false)
    end
end



function SceneListView:update()
    self.cp_data = model:getCheckPointsById()
    self.tankViewList:reloadData()

    self.Times:setString(model.free_times + model.left_buy_times)

    self:switchTo()

    self:updateChest()

    local tank_id = model:getTankIdByCurrentId()
    local entity = qy.tank.entity.TankEntity.new(tank_id)
    self.Tank:loadTexture(entity:getImg())

    local data = model:atCheckpoint()
    self.Name:setString("LV."..data.level)
    self.Num:setString(qy.TextUtil:substitute(67011)..data.checkpoint_id..qy.TextUtil:substitute(67012))


    -- service:getFightPower(function(data)
    --     if self.Strength then
    --         self.Strength:setString(qy.TextUtil:substitute(4005).."："..data.fight_power)
    --     end
    -- end, model.current_id)
    self.Strength:setString(qy.TextUtil:substitute(4005).."："..data.fight_power)

    if model.current_times > 0 then
        self.Begin:setVisible(false)
        self.Continue:setVisible(true)
    else
        self.Begin:setVisible(true)
        self.Continue:setVisible(false)
    end


end


function SceneListView:onEnter()
    self:update()

    self.listener_1 = qy.Event.add(qy.Event.soldiers_war,function(event)
        self:update()
    end)

     self.listener_1 = qy.Event.add(qy.Event.BACK_OF_BATTLE,function(event)
        if model.status == 0 then
            self.viewStack:pop()
        end
    end)

end

function SceneListView:onExit()
    qy.Event.remove(self.listener_1)
end

return SceneListView
