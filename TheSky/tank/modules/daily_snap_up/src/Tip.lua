--[[
战狼归来
]]

local Tip = qy.class("Tip",  qy.tank.view.BaseDialog, "daily_snap_up/ui/Tip")

--local model = qy.tank.model.AttackBerlinModel
local service = qy.tank.service.AttackBerlinService
 moudel = require("daily_snap_up.src.Model")
function Tip:ctor(id,idc)
    Tip.super.ctor(self)
    self:InjectView("okimg")
    self:InjectView("closeBt")
    self:InjectView("title")
    self:InjectView("Image_3")
    self:InjectView("title1")
    
    self.id = id
    self.idc = idc
    
  	--self.types  = delegate.types
    --self.num = delegate.num
    
   
    self:OnClick("closeBt", function(sender)
        self:removeSelf()
    end)
    self.selected = 0
    self.data = {}
    --self.types = delegate.types
    --self.ids = delegate.ids --1
    self.Image_3:addChild(self:__createList())
    --print("22==============22",self.types)--nil
    --print("22==============33",self.ids) --1
    --print("22==============44",self.num)--nil
end
function Tip:__createList()
    self.title1:setString("礼包包含以下奖励")
    if self.idc == 1 then
        self.data = moudel:GetPersonalAwardId(self.id)
    else
        self.data = moudel:GetBuyAwardId(self.id)
    end
    
    
    local nums = #self.data
   
   
    local tableView = cc.TableView:create(cc.size(550, 200))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(0, 5)
    tableView:setDelegate()

    local function numberOfCellsInTableView(tableView)
        return math.ceil(nums/5)
    end

    local function cellSizeForTable(tableView,idx)
        return 550, 95
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("daily_snap_up.src.PropCellList").new(self)
            print("55=============67",self)
            cell:addChild(item)
            cell.item = item
        end

        cell.item:render(self:getAwardByLine(idx+1), idx+1,self:getAwardByLine1(idx+1))

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

    return tableView
end

--line_num 从1开始 
function Tip:getAwardByLine(line_num)
    local line_award = {}
    for i = 5 * (line_num - 1) + 1, 5 * line_num  do
        if self.data[i] ~= nil then
            for a=1,#self.data[i].award do
                table.insert(line_award, self.data[i].award[a])
            end
            -- table.insert(line_award, self.data[i].award[1])
            -- table.insert(line_award, self.data[i].award[2])
        end
    end

    return line_award
end
function Tip:getAwardByLine1(line_num)
    local line_award = {}
    for i = 5 * (line_num - 1) + 1, 5 * line_num  do
        if self.data[i] ~= nil then
            table.insert(line_award, self.data[i].num)
        end
    end
    print("=========555",json.encode(line_award))
    return line_award
end

return Tip
