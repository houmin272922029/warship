local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "lucky_cat.ui.MainDialog")

local service = qy.tank.service.OperatingActivitiesService
local model = qy.tank.model.OperatingActivitiesModel
local activity = qy.tank.view.type.ModuleType
function MainDialog:ctor(delegate)
   	MainDialog.super.ctor(self)
    self:InjectView("BG")
   	self:InjectView("Time2")
   	self:InjectView("Num1")
   	self:InjectView("Num2")
    self:InjectView("Num3")
    self:InjectView("Time")
    self:InjectView("Node_1")
   	self:InjectView("Button_start")
   	-- self:InjectView("Pages")
    -- self:InjectView("Btn_choose")
    -- self:InjectView("Btn_carray")
    -- self:InjectView("arrowTip")  

    self:OnClick("Btn_close", function()
        -- service:getCommonGiftAward(1, activity.IRON_MINE,false, function(reData)
        --     self:showAction(1)
        -- end, true, 1)
        self:removeSelf()
    end,{["isScale"] = false})

    self:OnClick("Button_start", function()
        if not self.isPlaying then -- 锁
            service:getCommonGiftAward(nil, activity.LUCKY_CAT,false, function(reData)
                self:play(reData)
            end, false, nil, true)
        end  
        -- self:play()
        -- self:play2()
    end,{["isScale"] = false})

    for i = 1, 5 do
        local item = ccui.TextAtlas:create()
        local info = qy.tank.utils.NumPicUtils.getNumPicInfoByType(23)
        item:setProperty("0", info.numImg, info.width, info.height,"0")
        item:setPosition(95 * i + 310, 310)
        self["item" .. i] = item
        self.BG:addChild(item)
    end

    self.day = ccui.TextAtlas:create()
    self.day:setPosition(585, 490)
    self.BG:addChild(self.day)

    self.BG:addChild(self:createView())
    self:setNum()

    local time1 = os.date(qy.TextUtil:substitute(56001), model.luckyStartTime)
    local time2 = os.date(qy.TextUtil:substitute(56001), model.luckyEndTime)
    self.Time:setString(time1 .. "-" .. time2)
    self.x = self.Node_1:getPositionX()
    self.y = self.Node_1:getPositionY()
end

function MainDialog:play(data)
    self.isPlaying = true
    for i = 1, 5 do
        self["item" .. i]:setVisible(false)
    end

    if self.clip1 then
        self.clip1:removeSelf()
    end

    local node = self:getNode(data)
    local func1 = cc.CallFunc:create(function()
        self:play2()
        self:update()
        qy.tank.command.AwardCommand:add(data.award)
        qy.tank.command.AwardCommand:show(data.award,{["critMultiple"] = data.weight})

        self.isPlaying = false
    end)
    local func2 = cc.MoveTo:create(2.5, cc.p(0, self.y - 2620))
    local func3 = cc.MoveTo:create(0.05, cc.p(0, self.y - 2590))
    local seq = cc.Sequence:create(func2, func3, func1)
    node:runAction(seq)

    local position = self.Button_start:getParent():convertToWorldSpace(cc.p(self.Button_start:getPositionX(),self.Button_start:getPositionY()))

    self.sprite2 = cc.Sprite:create("lucky_cat/res/qq11.jpg")
    self.sprite2:setPosition(position.x -8 , position.y + 193)
    self.sprite2:addChild(node)

    local sprite = cc.Sprite:create("lucky_cat/res/111.jpg")
    self.clip1 = cc.ClippingNode:create()
    self.clip1:setInverted(false)
    self.clip1:setAlphaThreshold(100)
    self:addChild(self.clip1)
    self.clip1:addChild(self.sprite2)
    sprite:setPosition(self.sprite2:getPositionX(), self.sprite2:getPositionY())

    self.clip1:setStencil(sprite)
end

-- function MainDialog:play(data)
--     self.isPlaying = true
--     local num = "00000" .. tostring(data.award[1].num)
--     -- local num = "000006636"
--     -- local time = 0
--     -- for i = 1, 5 do
--     --     local j = math.random(1, 10)
--     --     local func1 = cc.CallFunc:create(function()
--     --         self["item" .. i]:setString(10 - j)  

--     --         if time > i * 3 + 1 and (10 - j) == tonumber(string.sub(num, string.len(num) - 5 + i, -6 + i)) then
--     --             self["item" .. i]:stopAllActions()
--     --             self["item" .. i]:setString(10 - j)
--     --             if i == 5 then
--     --                 qy.tank.command.AwardCommand:show(data.award,{["critMultiple"] = data.weight})
--     --                 self:update()
--     --                 self.isPlaying = false
--     --                 self:play2()
--     --             end
--     --         end

--     --         j = j + 1
--     --         if j > 10 then
--     --             j = 1
--     --             time = time + 1
--     --         end      
--     --     end)

--     --     local delay = cc.DelayTime:create(0.1)

--     --     local seq = cc.Sequence:create(func1, delay)
--     --     local action = cc.RepeatForever:create(seq)

--     --     self["item" .. i]:runAction(action)
--     -- end
-- end

function MainDialog:getNode(data)
    local node = cc.Node:create()

    local num = data and "00000" .. tostring(data.award[1].num) or "000003126"
    for i = 1, 5 do
        -- self["item" .. i] = {}
        local height = math.random(3, 5) * 50 + 100
        for j = 1, 15 do
            local num2 = math.random(0, 9)
            local item = ccui.TextAtlas:create()
            local info = qy.tank.utils.NumPicUtils.getNumPicInfoByType(23)
            if j == 15 then
                item:setProperty(string.sub(num, string.len(num) - 5 + i, -6 + i), info.numImg, info.width, info.height,"0")
                item:setPosition(95 * (i - 1) + 55, 350 + 150 * (j - 1))
            else
                item:setProperty(num2, info.numImg, info.width, info.height,"0")
                item:setPosition(95 * (i - 1) + 55, height + 150 * (j - 1))
            end

            node:addChild(item)
        end
    end

    return node
end

function MainDialog:createView()
    local tableView = cc.TableView:create(cc.size(300, 250))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    -- tableView:setSwallowTouches(false)
    tableView:setTouchEnabled(false)
    tableView:setPosition(20, -50)

    local data = model.luckyCatLog

    local function numberOfCellsInTableView(tableView)
        return #data
    end

    local function cellSizeForTable(tableView,idx)
        return 300, 30
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil
        -- local data = model:getList(idx)
        -- local height = model:getHeight(idx)
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("lucky_cat.src.ItemView").new()
            cell:addChild(item)
            cell.item = item
        end

        cell.item:setData(model.luckyCatLog[idx + 1])
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()
    self.tableView = tableView

    return tableView
end

function MainDialog:setTime()
    local time = model.luckyEndTime - qy.tank.model.UserInfoModel.serverTime
    if time < 0 then
        time = 0
    end
    self.Time2:setString(qy.tank.utils.DateFormatUtil:toDateString(time, 6))

    local info = qy.tank.utils.NumPicUtils.getNumPicInfoByType(23)

    local day = math.floor(time / 86400)
    self.day:setProperty(day, info.numImg, info.width, info.height,"0")
    self.day:setScale(0.7)
end

function MainDialog:update()
    self.tableView:reloadData()

    self:setNum()
end

function MainDialog:setNum()
    local times = model.luckyCatTimes + 1
    times = times > 8 and 8 or times
    local data = qy.Config.lucky_cat[tostring(times)]
    self.Num1:setString(data.max_diamond)
    self.Num2:setString(data.need_diamond)
    self.Num3:setString(qy.tank.model.UserInfoModel.userInfoEntity.diamond)
end

function MainDialog:play2()
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsyncByModules("lucky_cat/fx/ui_fx_shan",function()
        self.effect = ccs.Armature:create("ui_fx_shan")
        self.effect:getAnimation():playWithIndex(0,-1,0)
        self.effect:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
            if movementType == ccs.MovementEventType.complete then
                self.effect:getParent():removeChild(self.effect)
            end
        end)
        self.effect:setPosition(242, 99)
        self.sprite2:addChild(self.effect)
    end)
end

function MainDialog:onEnter()
    self.listener_2 = qy.Event.add(qy.Event.BONUS_TIME,function(event)
        self:setTime()
    end)
    self:setTime()
end

function MainDialog:onExit()
    qy.Event.remove(self.listener_2)
end

return MainDialog
