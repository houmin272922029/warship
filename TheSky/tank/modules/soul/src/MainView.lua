local MainView = qy.class("MainView", qy.tank.view.BaseView, "soul.ui.MainView")

local model = qy.tank.model.SoulModel
local garageModel = qy.tank.model.GarageModel
local service = qy.tank.service.SoulService
local MOVE_INCH = 7.0/160.0
local function convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local factor = (glview:getScaleX() + glview:getScaleY())/2
    return pointDis * factor / cc.Device:getDPI()
end

function MainView:ctor(delegate)
   	MainView.super.ctor(self)

    for i = 1, 8 do
        self:InjectView("p_" .. i)
        self:InjectView("Soulbg" .. i)
        self:InjectView("Soul" .. i)
        self:InjectView("Name" .. i)
        self:InjectView("_Name" .. i)
        self:InjectView("Block" .. i)
    end
    self:InjectView("BG")
   	self:InjectView("TankList")
   	self:InjectView("SouList")
   	self:InjectView("Image_2")
    self:InjectView("Name")
    self:InjectView("Attr1")
    self:InjectView("Attr2")
    self:InjectView("Num")
    self:InjectView("Image_3")
    self:InjectView("Tank")
    self:InjectView("Frement_num")
    self:InjectView("Page")
    self:InjectView("InfoIcon")
    self:InjectView("NoInfo")
    self:InjectView("Text_1_2")
    self:InjectView("InfoIcon2")
    self:InjectView("checkallBtn")
    self.checkallBtn:setVisible(false)

   	self:OnClick("Btn_close", function()
        delegate:onBackClicked()
    end,{["isScale"] = false})

    self:OnClick("Btn_pre", function()
        if model.page > 1 then
            local page = model.page - 1
            model:setPage(page)
            self.Page:setString(model.page)
            self:updateSoulList()
            self:updateTank()
        else
            qy.hint:show(qy.TextUtil:substitute(66009))
        end
    end,{["isScale"] = false})

    self:OnClick("Btn_next", function()
        if model.page < model:getMaxPage() then
            local page = model.page + 1
            model:setPage(page)
            self.Page:setString(model.page)
            self:updateSoulList()
            self:updateTank()
        else
            qy.hint:show(qy.TextUtil:substitute(66009))
        end
    end,{["isScale"] = false})

    self:OnClick("Btn_part", function()
        if self.soulEntity then
            local dialog = require("soul.src.ApartDialog").new(self):show()
        else
            qy.hint:show(qy.TextUtil:substitute(66010))
        end
    end,{["isScale"] = false})

    self:OnClick("Btn_upgrade", function()
        service:upgrade({
            ["unique_id"] = self.soulEntity.unique_id,
        }, function(data)
            self:updateSoulInfo2(self.soulEntity)
            self:updateFrement()
            qy.hint:show(qy.TextUtil:substitute(66011))
        end)
    end,{["isScale"] = false})

    self:OnClick("Btn_help", function()
        qy.tank.view.common.HelpDialog.new(qy.tank.model.HelpTxtModel:getHelpDataByIndx(14)):show(true)
    end,{["isScale"] = false})

    self:OnClick("Button_2", function()
        qy.tank.command.ActivitiesCommand:showActivity(qy.tank.view.type.ModuleType.SOUL_ROAD)
    end,{["isScale"] = false})

    self.infoSoul = qy.tank.view.common.ItemIcon.new()
    self.infoSoul:setPosition(68, 128)
    self.Image_2:addChild(self.infoSoul)

    self.selectTankIdx = 1
    self.selectTank = nil

    self.TankList:addChild(self:createView())
    self:setSoulPotions()
    self:createSoulView()
    self:updateTank()
    self:updateSoulInfo()
    self:updateFrement()
    self.Page:setString(model.page)
    -- self.SouList:addChild(self:createView2())
end

function MainView:setSoulPotions()
    if type(self.selectTank.item.entity) == "table" then
        for i = 1, 8 do

            self["Block" .. i]:setVisible(self.selectTank.item.entity.reform_stage < model.positions["p_" .. i].level)
            self["Block" .. i].idx = i
            self:OnClick("Soul" .. i, function()
                if not self["Block" .. i]:isVisible() then
                    self.soulSeceltType = 2
                    -- self.soulSeceltIdx = self["Block" .. i].idx
                    self:updateSoulInfo(self["Block" .. i].idx)
                end
            end,{["isScale"] = false, beganFunc = function(sender)
                self.selectItem = self["Soul" .. i]
                self.selectType = 2
                self.selectItem.oldorder = self.selectItem:getParent():getLocalZOrder()
                self.selectItem:getParent():setLocalZOrder(10)
                self.initPositionX = self["Soul" .. i]:getPositionX()
                self.initPositionY = self["Soul" .. i]:getPositionY()
                self.selectItem.idx = i
            end})
        end
    end
end

function MainView:createView()
    local tableView = cc.TableView:create(cc.size(210, 522))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    -- tableView:setSwallowTouches(false)
    tableView:setPosition(3, 5)
    tableView:setDelegate()

    self.tanks = {}

    local function numberOfCellsInTableView(tableView)
        return #garageModel.formation
    end

    local function cellSizeForTable(tableView,idx)
        return 210, 125
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.garage.GarageTankCell.new(garageModel.formation[idx+1], idx + 1,true)
            cell:addChild(item)
            cell.item = item
            if type(garageModel.formation[idx+1]) == "table" and self.selectTank == nil then
                cell.item.light:setVisible(true)
                self.selectTank = cell
            end
            table.insert(self.tanks, cell)
        end

        cell.item:render(garageModel.formation[idx+1], idx+1)
        cell.item.entity = garageModel.formation[idx+1]
        cell.idx = idx + 1
        return cell
    end

    local function tableAtTouched(table, cell)
        if type(cell.item.entity) == "table" then
            for i, v in pairs(self.tanks) do
                v.item.light:setVisible(false)
            end


            cell.item.light:setVisible(true)
            self.selectTank = cell
            self:updateTank()
        elseif cell.item.entity == 0 then
            qy.tank.command.GarageCommand:showUnselectedTankListDialog(false,function(uid)
                local service = qy.tank.service.GarageService
                service:lineup(1,1,"p_"..cell.idx,uid,function()
                    qy.Event.dispatch(qy.Event.LINEUP_SUCCESS)
                    qy.tank.command.GarageCommand:hideTankListDialog()
                end)
            end)
        elseif cell.item.entity == -1 then
            qy.hint:show(qy.TextUtil:substitute(66012),0.5)
        end
        -- self.selectTankIdx = cell:getIdx()
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableAtTouched,cc.TABLECELL_TOUCHED)

    tableView:reloadData()

    self.tankViewList = tableView

    return tableView
end

function MainView:createSoulView()
    for i = 1, 8 do
        self["item" .. i] = qy.tank.view.common.ItemIcon.new()

        -- self["Block" .. i]:setVisible(self.selectTank.item.entity.level >= model.positions["p_" .. i].level)
        self["item" .. i]:setPosition(130 * math.ceil((i - 1) % 2) + 75, 420 - 115 * math.floor((i - 1) / 2))
        self["item" .. i]:setVisible(false)
        self.SouList:addChild(self["item" .. i])
    end

    self:updateSoulList()
end

function MainView:updateSoulList()
    for i = 1, 8 do
        self["item" .. i]:setVisible(false)
    end

    local data = model:getEnableUse()[model.page] or {}

    for i, v in pairs(data) do
        local data = qy.tank.view.common.AwardItem.getItemData(v)
        data.beganFunc = function(sender)
            self.selectItem = self["item" .. i].childSprite
            self.selectItem.oldorder = self.Image_3:getLocalZOrder()
            self.selectItem.oldorder2 = self.selectItem:getParent():getParent():getLocalZOrder()
            self.Image_3:setLocalZOrder(10)
            self.selectItem:getParent():getParent():setLocalZOrder(10)

            self.selectType = 1
            self.initPositionX = self.selectItem:getPositionX()
            self.initPositionY = self.selectItem:getPositionY()
            self.initPositionX2 = self["item" .. i].name:getPositionX()
            self.initPositionY2 = self["item" .. i].name:getPositionY()
        end
        data.callback = function()
            self.soulSeceltType = 1
            self:updateSoulInfo(self["item" .. i].idx)
            -- self["item" .. i].light:setVisible(true)
        end
        local name = model.typeNameList[tostring(v.soulType)]
        self["item" .. i]:setData(data)
        self["item" .. i].name:setString(name)
        self["item" .. i].name:setTextColor(cc.c3b(255,255,255))
        self["item" .. i]:setVisible(true)
        self["item" .. i]:setTitlePosition(3)
        self["item" .. i].childSprite.entity = data
        self["item" .. i].childSprite.idx = i
        self["item" .. i].idx = i
    end
end

function MainView:updateTank()
    self.selectTank.item.light:setVisible(true)

    for i = 1, 8 do
        self["Soul" .. i]:setVisible(false)
        self["Block" .. i]:setVisible(self.selectTank.item.entity.reform_stage < model.positions["p_" .. i].level)
        -- self["Name" .. i]:setVisible(false)
        if self["Block" .. i]:isVisible() then
            self["_Name" .. i]:setString(qy.TextUtil:substitute(66013, model.positions["p_" .. i].level))
            self["_Name" .. i]:setVisible(true)
        else
            self["_Name" .. i]:setVisible(false)
        end
        self["Soulbg" .. i]:setVisible(false)
    end

    local entity = self.selectTank.item.entity
    local list = model:atTank(entity)

    if type(entity) == "table" then
        self.Tank:setTexture(entity:getImg())
        self:updateSoulInfo()
    end

    if list then
        for i, v in pairs(list) do
            if v.pos ~= "" then
                local key = string.sub(v.pos, 3)
                local soul = self["Soul" .. key]
                soul:setVisible(true)
                local data = qy.tank.view.common.AwardItem.getItemData(v)
                soul:loadTexture(data.icon)
                local name = model.typeNameList[tostring(v.soulType)]
                self["Name" .. key]:setString(name)
                self["Name" .. key]:setVisible(true)
                self["Soul" .. key]:loadTexture("res/soul/" .. v.soulType .. "_" .. v.quality .. ".png")
                -- self["Name" .. key]:setTextColor(data.nameTextColor)
                self["Block" .. key]:setVisible(false)
                self["_Name" .. key]:setVisible(false)
            end
        end
    end
end

function MainView:updateSoulInfo(idx)
    for i = 1, 8 do
        self["Soulbg" ..i]:setVisible(false)
        if self["item" .. i].light then
            self["item" .. i].light:setVisible(false)
        end
    end

    local entity, idx = model:getSelectSoulEntity(self.selectTank.item.entity, idx, self.soulSeceltType)

    if idx then
        if self["item" .. idx].light then
            self["item" .. idx].light:setVisible(true)
        end
    end
    self:updateSoulInfo2(entity)
end

function MainView:updateSoulInfo2(entity)
    if entity then
        self.NoInfo:setVisible(false)
        self.InfoIcon:setVisible(true)
        self.Name:setString(entity.name .. " Lv." .. entity.level)

        local attr1 = entity:getAttr1()
        local attr2 = entity:getAttr2()

        if entity.soulType == 5 or entity.soulType == 6 or entity.soulType == 7 or entity.soulType == 8 or entity.soulType == 4 or entity.soulType == 9 then
            attr1.num = attr1.num / 10 .. "%"
            attr2.num = attr2.num / 10 .. "%"
        end
        self.Attr1:setString(attr1.name .. "+" .. attr1.num)
        self.Attr2:setString("+" .. attr2.num)
        self.Num:setString(attr2.soulNum - attr1.soulNum)

        local num2 = qy.tank.model.UserInfoModel.userInfoEntity.soul_fragment or 0
        local color = cc.c3b(0, 255, 60)
        if attr2.soulNum - attr1.soulNum - num2 > 0 then
            color = cc.c3b(255, 0, 0)
        end

        self.Num:setColor(color)

        local data = qy.tank.view.common.AwardItem.getItemData(entity)
        self.infoSoul:setData(data)
        self.Name:setTextColor(data.nameTextColor)
        self.infoSoul.name:setVisible(false)
        self.infoSoul:setVisible(true)

        self.InfoIcon2:setVisible(not attr2.maxLevel)
        self.Num:setVisible(not attr2.maxLevel)
        if attr2.maxLevel then
            self.Text_1_2:setString(qy.TextUtil:substitute(66014))
        else
            self.Text_1_2:setString(qy.TextUtil:substitute(66015))
        end

        if entity.pos ~= "" then
            local key = string.sub(entity.pos, 3)
            self["Soulbg" .. key]:setVisible(true)
        end
        self.soulEntity = entity
        if entity.quality >= 6 then
            self.checkallBtn:setVisible(true)
            self:OnClick("checkallBtn",function (  )
                model.flag = true
                qy.alert:showTip(qy.tank.utils.TipUtil.createTipContent(data))
            end)
        else
            self.checkallBtn:setVisible(false)
        end
    else
        self.checkallBtn:setVisible(false)
        self.NoInfo:setVisible(true)
        self.InfoIcon:setVisible(false)
        self.infoSoul:setVisible(false)
        self.soulEntity = nil
    end
end

function MainView:checkUpPos()
    local isSelected = false
    self.selectItem:setPosition(self.initPositionX, self.initPositionY)
    self.Image_3:setLocalZOrder(self.selectItem.oldorder)
    self.selectItem:getParent():getParent():setLocalZOrder(self.selectItem.oldorder2)
    -- self.selectItem:getParent():getParent():setLocalZOrder(self.selectItem.oldorder2)
    self.selectItem:getParent():getParent().name:setPosition(self.initPositionX2, self.initPositionY2)

    for i = 1, 8 do
        if not self["Block" .. i]:isVisible() then
            -- if self.endPoint.x
            local boxPoint = self["p_" .. i]:getBoundingBox()
            local box = self.BG:convertToNodeSpace(cc.p(self["p_" .. i]:getPositionX(), self["p_" .. i]:getPositionY()))

            if (self.endPoint.x > boxPoint.x and self.endPoint.x < boxPoint.x + boxPoint.width) and (self.endPoint.y > boxPoint.y and self.endPoint.y < boxPoint.y + boxPoint.height) then
                isSelected = true
                self:addPos(i, self.selectItem.entity)
            end
        end
    end

    if not isSelected then
        self.selectItem = nil
    end
end

-- 给某个位置添加军魂
function MainView:addPos(i, data)
    service:load({
        ["tank_unique_id"] = self.selectTank.item.entity.unique_id,
        ["pos"] = "p_" .. i,
        ["unique_id"] = data.entity.unique_id
    }, function(data)
        -- self["Soul" .. i]:setVisible(true)
        -- self["Soul" .. i]:setTexture(self.selectItem.entity.icon)
        -- self.selectItem:setVisible(false)
        -- self.selectItem:setLocalZOrder(self.selectItem.oldorder)
        self:updateTank()
        self:updateSoulList()
    end)
end

-- 检查卸载
function MainView:checkUnload()
    local boxPoint = self.Image_3:getBoundingBox()
    local box = self.BG:convertToNodeSpace(cc.p(self.Image_3:getPositionX(), self.Image_3:getPositionY()))

    self.selectItem:setPosition(self.initPositionX, self.initPositionY)
    self.selectItem:getParent():setLocalZOrder(self.selectItem.oldorder)

    if (self.endPoint.x > boxPoint.x and self.endPoint.x < boxPoint.x + boxPoint.width) and (self.endPoint.y > boxPoint.y and self.endPoint.y < boxPoint.y + boxPoint.height) then
        self.selectItem:setVisible(false)
        self:unload(self.selectItem)
    else
        self.selectItem = nil
    end
end

-- 执行卸载
function MainView:unload()
    service:unload({
        ["tank_unique_id"] = self.selectTank.item.entity.unique_id,
        ["pos"] = "p_" .. self.selectItem.idx,
    }, function(data)
        -- self["Soul" .. i]:setVisible(true)
        -- self["Soul" .. i]:setTexture(self.selectItem.entity.icon)
        -- self.selectItem:setVisible(false)
        -- self.selectItem:setLocalZOrder(self.selectItem.oldorder)
        self:updateTank()
        self:updateSoulList()
        self:updateSoulInfo()
    end)
end

-- 更新碎片数目
function MainView:updateFrement()
    self.Frement_num:setString(qy.tank.model.UserInfoModel.userInfoEntity.soul_fragment)
end

function MainView:onEnter()
    self.listener_1 = qy.Event.add(qy.Event.LINEUP_SUCCESS,function(event)
        self.tankViewList:reloadData()
    end)

    local touchPoint = nil
    self.onTouchBegan = function(touch, event)
        touchPoint = touch:getLocation()

        return true
    end

    self.onTouchMoved = function(touch, event)
        local point = touch:getLocation()
        local moveDistance = {}
        moveDistance.x = point.x - touchPoint.x
        moveDistance.y = point.y - touchPoint.y
        local dis = math.sqrt(moveDistance.x * moveDistance.x + moveDistance.y * moveDistance.y)
        if math.abs(convertDistanceFromPointToInch(dis)) >= MOVE_INCH then
            if self.selectItem then
                self.selectItem:setPosition(self.initPositionX + moveDistance.x, self.initPositionY + moveDistance.y)
                if self.selectType == 1 then
                    self.selectItem:getParent():getParent().name:setPosition(self.initPositionX2 + moveDistance.x, self.initPositionY2 + moveDistance.y)
                end
            end
        end
    end

    self.onTouchended = function(touch, event)
        local point = touch:getLocation()
        self.endPoint = self.BG:convertToNodeSpace(point)
        if self.selectItem then
            if self.selectType == 1 then
                self:checkUpPos(point) -- 判断是否装载
            else
                self:checkUnload(point)
            end
            -- self.selectItem:setPosition(self.initPositionX, self.initPositionY)
        end
    end

    self.onTouchCancelled = function(touch, event)
        if self.selectItem then
            if self.selectType == 1 then
                self.Image_3:setLocalZOrder(self.selectItem.oldorder)
                self.selectItem:getParent():getParent():setLocalZOrder(self.selectItem.oldorder2)
            else
                self.selectItem:getParent():setLocalZOrder(self.selectItem.oldorder)
            end
            self.selectItem = nil
        end
    end

    if self.listener == nil then
        self.listener = cc.EventListenerTouchOneByOne:create()
        self.listener:setSwallowTouches(false)
        self.listener:registerScriptHandler(self.onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
        self.listener:registerScriptHandler(self.onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
        self.listener:registerScriptHandler(self.onTouchended, cc.Handler.EVENT_TOUCH_ENDED)
        self.listener:registerScriptHandler(self.onTouchCancelled, cc.Handler.EVENT_TOUCH_CANCELLED)


        self:getEventDispatcher():addEventListenerWithFixedPriority(self.listener, -1)
    end

    self:updateFrement()
    self:updateSoulList()
end


function MainView:onExit()
    -- self.mapMove = false
    -- qy.Event.remove(self.listener_1)
end

return MainView
