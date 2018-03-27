--[[
	
	限时秒杀
]]

local LuckyDialog = qy.class("LuckyDialog", qy.tank.view.BaseDialog, "time_limit_spike.ui.LuckyDialog")

function LuckyDialog:ctor(delegete)
    
    LuckyDialog.super.ctor(self)
    self:setCanceledOnTouchOutside(false)
    self.model = require("time_limit_spike.src.Model")
    self.service = require("time_limit_spike.src.Service")
    
    self:InjectView("Panel_1")

    self.delegete = self.model:getlist()

    self.style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(820,550),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "time_limit_spike/res/10.png",

        ["onClose"] = function()
            self:removeSelf()
        end
    })
    self:addChild(self.style,-1)
       print("7777----777",#(self.delegete))
    if delegete ~=nil then
       --滑动事件   
        self.Panel_1:removeAllChildren()
        self.Panel_1:addChild(self:createView())
    else
    end
 
end 

--创建列表item
function LuckyDialog:createView()
    local tableView = cc.TableView:create(cc.size(750, 410))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setTouchEnabled(true)
    tableView:setPosition(8,5)  

    local function numberOfCellsInTableView(tableView)       
        return #self.delegete
    end

    local function cellSizeForTable(tableView,idx)       
        return 742,100
    end

    local function tableCellAtIndex(tableView, idx)
       
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil

        -- local data = model:getList(idx)
        -- local height = model:getHeight(idx)
        if nil == cell then
            cell = cc.TableViewCell:new()
            -- item = require("fight_the_wolf.src.ItemView").new({
            --     ["callback"] = function (  )
            --         self:render()
            --         local listCury = self.tableView:getContentOffset()
            --         self.tableView:reloadData()
            --         self.tableView:setContentOffset(listCury)--设置滚动距离
            --     end
            --     })
            item = require("time_limit_spike.src.LuckyCell").new()

            cell:addChild(item)
            cell.item = item
        end
        --idx是从0开始的
       
            cell.item:render(self.delegete[idx + 1],idx)
              
        return cell
    end

    
    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    
    tableView:reloadData()
    self.tableView = tableView
    return tableView
end 
	
function LuckyDialog:onExit()

end


function LuckyDialog:onEnter()

    
end

return LuckyDialog

