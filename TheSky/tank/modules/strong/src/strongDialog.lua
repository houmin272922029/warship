local strongDialog = qy.class("strongDialog", qy.tank.view.BaseView, "strong.ui.strongDialog")

local model = qy.tank.model.StrongModel
local GarageModel = qy.tank.model.GarageModel
function strongDialog:ctor(delegate)
   	strongDialog.super.ctor(self)

   	self:InjectView("Btn_close")
   	self:InjectView("Panel_1")
   	self:InjectView("Panel_2")
   	self:InjectView("Panel_3")
   	self:InjectView("textBg")
   	self:InjectView("Text_1")
   	self:InjectView("fightPow")
   	self:InjectView("resource")
   	self.textBg:setVisible(false)
   	self:OnClick("Btn_close", function()
        delegate:onBackClicked()
    end,{["isScale"] = false})
    self.selectIdx = 1
    self.textIndex = 1
    self:switch(1)
    self:OnClick("fightPow", function()
        self:switch(1)
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})
    self:OnClick("resource", function()
        self:switch(2)
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self:OnClick("Panel_3", function()
        self:updateDes()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self.fightPow:setLocalZOrder(10)
    self.resource:setLocalZOrder(10)
    self.fightPow:setTitleFontName(qy.res.FONT_NAME)
    self.fightPow:getTitleRenderer():enableOutline(cc.c4b(0,0,0,255),1)
    self.resource:setTitleFontName(qy.res.FONT_NAME)
    self.resource:getTitleRenderer():enableOutline(cc.c4b(0,0,0,255),1)
end

function strongDialog:switch(idx)
	self.selectIdx = 1
	self.textIndex = 1
    self.fightPow:setBright(idx ~= 1)
    self.resource:setBright(idx ~= 2)
    self.index = idx
    self.fightPow:setTitleFontSize(22)
    self.resource:setTitleFontSize(22)
    if self.index == 2 then
    	self.fightPow:setTitleColor(cc.c3b(155, 145, 95))
    	self.resource:setTitleColor(cc.c3b(255, 255, 255))
    else
    	self.fightPow:setTitleColor(cc.c3b(255, 255, 255))
    	self.resource:setTitleColor(cc.c3b(155, 145, 95))
    end
    
    self.Panel_1:removeAllChildren()
    self.Panel_1:addChild(self:createTableView())
    -- if self.isTouch then
    	self.textIndex = 1
    	self:updateDes()
    -- end
end

function strongDialog:createTableView()
	local tableView = cc.TableView:create(cc.size(350, 510))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(18, 0)
    tableView:setDelegate()
    self.SelectCellList = {}

    local function numberOfCellsInTableView(tableView)
        return self.index == 1 and 3 or 10
    end

    local function cellSizeForTable(tableView,idx)
        return 350, 125
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("strong.src.SelectCell").new()
            cell:addChild(item)
            cell.item = item
        end
        cell.item.idx = idx
        cell.item:setData(self.index, (idx+1))

        if self.selectIdx == idx+1 then
            cell.item.Sprite_1:setVisible(true)
            cell.item.Sprite_2:setScale(1.05)
        else
            cell.item.Sprite_1:setVisible(false)
            cell.item.Sprite_2:setScale(0.95)
        end

        return cell
    end

    local function tableAtTouched(table, cell)
     	if self.selectIdx-1 ~= cell:getIdx() then
            qy.QYPlaySound.playEffect(qy.SoundType.SWITCH_TANK)
        end

        local before = table:cellAtIndex(self.selectIdx-1)
        if before then
            before.item.Sprite_1:setVisible(false)
            before.item.Sprite_2:setScale(0.95)
        end
        self:setIdx(cell:getIdx()+1)
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableAtTouched,cc.TABLECELL_TOUCHED)
    
    tableView:reloadData()

    self.tableView = tableView
    self:setIdx(self.selectIdx)
    return tableView
end

function strongDialog:setIdx(idx,isClick)
    self.selectIdx = idx
    local cell = self.tableView:cellAtIndex(idx-1)
    if cell then
        cell.item.Sprite_1:setVisible(true)
        cell.item.Sprite_2:setScale(1.05)
    end
    local index = self.index == 1 and idx or (idx + 3)
    model:initStrongData(index)

    self.Panel_2:removeAllChildren()
    self.Panel_2:addChild(self:createListView())
end

function strongDialog:createListView()
	local tableView = cc.TableView:create(cc.size(660, 505))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(5, 0)
    tableView:setDelegate()

    local function numberOfCellsInTableView(tableView)
        return #model.strongData
    end

    local function cellSizeForTable(tableView,idx)
        return 624, 127
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("strong.src.ItemCell").new()
            cell:addChild(item)
            cell.item = item
        end
        cell.item.idx = idx
        cell.item:setData(self.index, model.strongData[idx+1])

        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()
    self.ListView = tableView
    return tableView
end

function strongDialog:updateDes()
	self.textBg:stopAction(self.playSeq)
	self.textBg:setVisible(true)
	local text = model.typeNameList[qy.language..""][self.index..""]
	if self.textIndex > #text then
		self.textIndex = 1
	end
	self.Text_1:setString(text[self.textIndex])
	-- self.textIndex = self.textIndex + 1
    local x = math.random(1, 5)
    local y
    local z
    if x == self.textIndex then
        y = math.random(1, 5)
        if y == self.textIndex then
            z = math.random(1, 5)
            self.textIndex = z == self.textIndex and math.random(1, 5) or z
        else
            self.textIndex = y
        end
    else
        self.textIndex = x
    end
	self.playSeq = cc.Sequence:create(cc.FadeTo:create(0.1, 255), cc.DelayTime:create(1.8),cc.FadeTo:create(1.7, 0), cc.CallFunc:create(function()
        -- self.textBg:setVisible(false)
    end))
    
	self.textBg:runAction(self.playSeq)
end

function strongDialog:onEnter()
	GarageModel:UpdateStrong()
	GarageModel:updateEquipStrong()
	model:sort()
    print(json.encode(model.StrongFcList).."=================")
    if self.ListView then
        local listCurY = self.ListView:getContentOffset().y
        self.ListView:reloadData()
        self.ListView:setContentOffset(cc.p(0,listCurY))
    end
    self.textIndex = 1
    self:updateDes()
end

function strongDialog:onExit()
    -- cc.Director:getInstance():getTextureCache():removeAllTextures()
end

return strongDialog