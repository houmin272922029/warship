--[[--
	预览
	Author: H.X.Sun
--]]--

local AlloyList = qy.class("AlloyList", qy.tank.view.BaseView, "alloy/ui/AlloyList")

function AlloyList:ctor(delegate)
	AlloyList.super.ctor(self)

    self.model = qy.tank.model.AlloyModel
    self:InjectView("bg")
    self:InjectView("up_info")
    self:InjectView("line")
    self:InjectView("exp_num")
    self.exp_num:setString("0")
    self.line:setLocalZOrder(20)
    self.delegate = delegate
    self.alloyId = delegate.alloyId

    local _titleUrl = ""
    if self.model.OPNE_LISTT_3 == delegate.type then
        self.bg:setPosition(self.bg:getPositionX(),303)
        self.up_info:setVisible(true)
        self.alloyEntity = self.model:getSelectAlloyByIndex(delegate.alloyId,delegate.equipEntity.unique_id)
        _titleUrl = "alloy/res/choose_up_title.png"
    else
        self.bg:setPosition(self.bg:getPositionX(),329)
        self.up_info:setVisible(false)
        _titleUrl = "alloy/res/alloy_embedded_title.png"
    end

    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = _titleUrl, 
        showHome = true, 
        ["onExit"] = function()
            self.model:clearUpSelectStatus()
            if delegate and delegate.dismiss then
                delegate.dismiss()
            end
        end
    })
    
    self:addChild(style, 13)

    self:OnClick("confirm_btn",function()
        if self.diffExp and self.diffExp < 0 then
            delegate.showTips(self.diffExp)
        else
            delegate.dismiss()
        end
    end,{["isScale"] = false})
    
end

function AlloyList:createAlloyList()
    local _h = 7
    if self.model.OPNE_LISTT_3 == self.delegate.type then
        _h = 100
    end
    self.alloyArr = cc.TableView:create(cc.size(900,582 - _h))
    self.alloyArr:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.alloyArr:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.alloyArr:setPosition(17,_h)
    self.bg:addChild(self.alloyArr,5)
    self.alloyArr:setDelegate()
    -- self.selectIdx = 0

    local function numberOfCellsInTableView(table)
        return self.model:getUnSelectNumByIndex(self.alloyId)
    end

    local function tableCellTouched(table,cell)
        
    end

    local function cellSizeForTable(tableView, idx)
        return 861, 150
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("alloy.src.AlloyCell").new({
                ["type"] = self.delegate.type,
                ["dismiss"] = function ()
                    self.delegate.dismiss()
                end,
                ["selectIdx"] = function ()
                    if not table:isTouchMoved() then
                        item:updateTick(function ()
                            self:updateSelectExp()
                        end)
                    end
                end
            })
            cell:addChild(item)
            cell.item = item
        end
        cell.item:render(idx+1, self.delegate)
        return cell
    end

    self.alloyArr:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    self.alloyArr:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    self.alloyArr:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    self.alloyArr:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    self.alloyArr:reloadData()
end

function AlloyList:updateSelectExp()
    local _selectExp = self.model:getSelectUpExp(self.alloyId)
    --比最大经验值多多少经验，不足的为负
    self.diffExp = self.model:expExpectMoreMax(self.alloyEntity, _selectExp)
    self.exp_num:setString(_selectExp .. "")
    if self.diffExp < 0 then
        self.exp_num:setTextColor(cc.c4b(208,17,17,255))
    else
        self.exp_num:setTextColor(cc.c4b(255,255,255,255))
    end
end

function AlloyList:updateAlloyList()
    if self.alloyArr then
        local listCurY = self.alloyArr:getContentOffset().y
        self.alloyArr:reloadData()
        self.alloyArr:setContentOffset(cc.p(0,listCurY))
    end
end

function AlloyList:onEnter()
    if self.alloyArr == nil or not tolua.cast(self.alloyArr, "cc.Node") then
        self:createAlloyList()
    else
        self:updateAlloyList()
    end
    if self.model.OPNE_LISTT_3 == self.delegate.type then
        self:updateSelectExp()
    end
end

return AlloyList