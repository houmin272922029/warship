--[[
	
	限时秒杀
]]

local NoticeDialog = qy.class("NoticeDialog", qy.tank.view.BaseDialog, "time_limit_spike.ui.NoticeDialog")

function NoticeDialog:ctor()
    NoticeDialog.super.ctor(self)
    self:setCanceledOnTouchOutside(false)
    self.model = require("time_limit_spike.src.Model")
    self.service = require("time_limit_spike.src.Service")
    self:InjectView("Panel_1")
    self:InjectView("Text_1")
    self:InjectView("Node_1")
    self:InjectView("Node_2")
    self:InjectView("Node_3")

    self.style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(820,550),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "time_limit_spike/res/13.png",

        ["onClose"] = function()
            self:removeSelf()
        end
    })
    self:addChild(self.style,-1)
    if self.model.data.next_list[1] ~=nil then
        self.date = self.model.data
        self.Text_1:setString(self.date.next_list[1].stage)
        --三个奖励显示
        for e=1,3 do
            self.data = self.model:GestAwardById(tonumber(self.date.next_list[e].id))    
            local item = qy.tank.view.common.AwardItem.createAwardView(self.data[1].award[1] ,1)
            self["Node_"..e]:addChild(item)            
            item:setScale(0.7)
            item.fatherSprite:setSwallowTouches(false)
            item.name:setVisible(false)
        end
        --滑动事件
    self.Panel_1:removeAllChildren()
    self.Panel_1:addChild(self:createView())
    else
    end
    
 
end 

--创建列表item
function NoticeDialog:createView()
    local tableView = cc.TableView:create(cc.size(750, 328))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setTouchEnabled(true)
    tableView:setPosition(8,5)   
    local function numberOfCellsInTableView(tableView)       
        return #self.date.next_list/3 - 1
    end

    local function cellSizeForTable(tableView,idx)       
        return 742,110
    end

    local function tableCellAtIndex(tableView, idx)       
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil

        if nil == cell then
            cell = cc.TableViewCell:new()            
            item = require("time_limit_spike.src.NoticeCell").new()

            cell:addChild(item)
            cell.item = item
        end
        --idx是从0开始的
        
        cell.item:render(self.date.next_list[3 * idx + 4],self.date.next_list[3 * idx + 5],self.date.next_list[3 * idx + 6],idx)       
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()
    self.tableView = tableView
    return tableView
end  
	
function NoticeDialog:onExit()

end


function NoticeDialog:onEnter()

    
end

return NoticeDialog

