--[[--
    连充惊喜
--]]--


local Dialog = qy.class("Dialog", qy.tank.view.BaseDialog, "series_recharge/ui/Layer")



function Dialog:ctor(delegate)
    Dialog.super.ctor(self)
    self.model = qy.tank.model.SeriesRechargeModel
    self.service = qy.tank.service.SeriesRechargeService


    self:InjectView("Text_time")
    self:InjectView("Btn_left")
    self:InjectView("Btn_right")
    self:InjectView("Node1")
    self:InjectView("Node2")
    self:InjectView("Btn_get")
    self:InjectView("Txt_get")
    self:InjectView("Txt_not")
    self:InjectView("ps")
    self:InjectView("Img_yilingqu")
    self:InjectView("bg")

    for i = 1, 7 do
        self:InjectView("zuanshi"..i)
        self:InjectView("zuanshi_liang"..i)
    end

	self:OnClick("Btn_close", function(sender)
        self:removeSelf()
    end,{["isScale"] = false})

    self:OnClick("Btn_get", function(sender)
        if self.Btn_get:isBright() then
            self.service:getAward(function(data)
                if data.award then
                    qy.tank.command.AwardCommand:add(data.award)
                    qy.tank.command.AwardCommand:show(data.award)
                    self.model.award_status = -1
                    self:update()

                end
            end)
        end
    end,{["isScale"] = false})

    self.Node1:addChild(self:createTableView())


    self.award = qy.AwardList.new({
        ["award"] = self.model.config[8].award,
        ["cellSize"] = cc.size(90,180),
        ["type"] = 1,
        ["len"] = 5,
        ["itemSize"] = 2,
        ["hasName"] = false,
    })
    self.award:setPosition(40,215)
    self.Node2:addChild(self.award)




    for i = 1, self.model.complete do
        self["zuanshi_liang"..i]:setVisible(true)        
    end

    self.ps:setScaleY(self.model.complete / 7)




    self:OnClick("Btn_left", function(sender)
        if self.Btn_left:isBright() then
            self.Btn_left:setBright(false)

            local x = self.tableView:getContentOffset().x
            if x < 0 then
                x = x + 230
            end
            self.tableView:setContentOffset(cc.p(x, 0), true)

            self.Btn_left:runAction(cc.Sequence:create(cc.DelayTime:create(0.3), cc.CallFunc:create(function()
                self.Btn_left:setBright(true)
            end)))
        end
    end)


    self:OnClick("Btn_right", function(sender)
        if self.Btn_right:isBright() then
            self.Btn_right:setBright(false)

            local x = self.tableView:getContentOffset().x
            if x >= -230 * 3 then  --   3 = 7 - 3 - 1
                x = x - 230
            end
            self.tableView:setContentOffset(cc.p(x, 0), true)

            self.Btn_right:runAction(cc.Sequence:create(cc.DelayTime:create(0.3), cc.CallFunc:create(function()
                self.Btn_right:setBright(true)
            end)))
        end
    end)

    self.Btn_left:setSwallowTouches(true)
    self.Btn_right:setSwallowTouches(true)

    local index = self.model.progress <= 5 and self.model.progress or 5
    self.tableView:setContentOffset(cc.p((index - 1) * -230, 0))


    self:update()
end


function Dialog:update()
    if self.model.award_status == 0 then        
        self.Btn_get:setBright(false)
        self.Txt_not:setVisible(true)
        self.Txt_get:setVisible(false)
        self.Img_yilingqu:setVisible(false)
    elseif self.model.award_status == 1 then
        self.Btn_get:setBright(true)
        self.Txt_not:setVisible(false)
        self.Txt_get:setVisible(true)
        self.Img_yilingqu:setVisible(false)
    else
        self.Btn_get:setVisible(false)
        self.Img_yilingqu:setVisible(true)
    end
end



function Dialog:createTableView()
    tableView = cc.TableView:create(cc.size(690,260))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setTouchEnabled(false)
    tableView:setAnchorPoint(0,0)
    tableView:setPosition(5, 0)
    tableView:setDelegate()
    
    local function numberOfCellsInTableView(table)
        return 7
    end
    
    local function tableCellTouched(table,cell)

    end

    local function cellSizeForTable(tableView, idx)
        return 230, 260
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("series_recharge.src.Cell").new()
            cell:addChild(item)
            cell.item = item
        end
        cell.item:render(self.model.config[idx+1].award, idx+1)
       
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()
    self.tableView = tableView
    return tableView
end





function Dialog:updateTime()
    if self.Text_time then
        self.Text_time:setString(self.model:getEndTime())
    end
end

function Dialog:onEnter()
    self:updateTime()
    self.timeListener = qy.Event.add(qy.Runtime.TIMER_UPDATE,function(event)
        self:updateTime()
    end)
end

function Dialog:onExit()
    qy.Event.remove(self.timeListener)
    self.timeListener = nil
end



return Dialog