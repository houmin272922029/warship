--[[
    签到
    2016年07月26日17:42:39
]]
local SignDialog = qy.class("SignDialog", qy.tank.view.BaseDialog, "sign.ui.SignDialog")

local model = qy.tank.model.SignModel
local service = qy.tank.service.SignService
function SignDialog:ctor(delegate)
    SignDialog.super.ctor(self)


    self:InjectView("Bg")
    self:InjectView("Sign_times")
    self:InjectView("Total")
    self:InjectView("Btn_receive")
    
    self:OnClick("Btn_close", function(sender)
        self:removeSelf()
    end,{["isScale"] = false})


    self.Bg:addChild(self:__createList(), 1)       
    self.Bg:addChild(self:__createTotalList(), 1)     
end




function SignDialog:__createList()
    local tableView = cc.TableView:create(cc.size(794, 485))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(237, 60)
    tableView:setDelegate()

    local function numberOfCellsInTableView(tableView)
        return model:getTotalAwardSize()
    end

    local function cellSizeForTable(tableView,idx)
        return 794, 159
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("sign.src.SignCell").new(self)            
            cell:addChild(item)
            cell.item = item
        end

        cell.item:render(model:getTotalAwardByIndex(idx+1), idx+1)

        
        return cell
    end

    local function tableAtTouched(table, cell)

    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableAtTouched,cc.TABLECELL_TOUCHED)

    tableView:reloadData()

    self.tableViewList = tableView
    self.tableViewList:setContentOffset(cc.p(0, math.min(-159 * (model:getTotalAwardSize() - math.floor(model:getCurrentNum() / 5 + 1)) + 326,  self.tableViewList:maxContainerOffset().y)), false)

    return tableView
end




function SignDialog:__createTotalList()
    local tableView = cc.TableView:create(cc.size(150, 360))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(39, 110)
    tableView:setDelegate()

    local function numberOfCellsInTableView(tableView)
        return 1
    end

    local function cellSizeForTable(tableView,idx)
        return 125, 390
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.AwardList.new({
                ["award"] = model:getSignNumAward(),
                ["cellSize"] = cc.size(130,120),
                ["type"] = 1,
                ["itemSize"] = 1,
                ["hasName"] = false,
                ["len"] = 1})

            item:setPosition(80,450)
            cell:addChild(item)
            cell.item = item
        end
        
        return cell
    end

    local function tableAtTouched(table, cell)

    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableAtTouched,cc.TABLECELL_TOUCHED)

    tableView:reloadData()

    return tableView
end



function SignDialog:update()
    self.Sign_times:setString(model:getCurrentNum())
    self.Total:setString(model:getTotalNum().."/"..math.floor((model:getTotalNum() + 10) / 10) * 10)
    
    if model.status == 100 then
        self.Btn_receive:setBright(true)
        self:OnClick(self.Btn_receive, function(sender)
            service:getAward(function(data)
                self:update()

                if data.award then
                    qy.tank.command.AwardCommand:add(data.award)
                    qy.tank.command.AwardCommand:show(data.award,{["isShowHint"]=false})

                end
            end, "200") 
        end,{["isScale"] = false})
    else 
        self.Btn_receive:setBright(false)
    end

end



function SignDialog:onEnter()
    self:update()
end
function SignDialog:onExit()
    -- cc.Director:getInstance():getTextureCache():removeAllTextures()
end


return SignDialog
