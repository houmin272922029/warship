--[[
	每日福利
	
]]

local MainDialog = qy.class("MainDialog", qy.tank.view.BaseView, "daily_snap_up.ui.MainDialog")

function MainDialog:ctor()
    MainDialog.super.ctor(self)
    --self:setCanceledOnTouchOutside(true)
    self.model = require("daily_snap_up.src.Model")
    self.service = require("daily_snap_up.src.Service")
     
    self:InjectView("Panel_1")
    self:InjectView("Button_1")
      
    local week = self.model.week_day
    --local week = 0
    if week == 0 then
        self.data = self.model:GetPersonalDataById(tonumber(7))
        self.data1 = self.model:GetBuyDataById(tonumber(7))
    else
        self.data = self.model:GetPersonalDataById(tonumber(week))
        self.data1 = self.model:GetBuyDataById(tonumber(week)) 
    end
    countpersonal = #self.data
    countbuy = #self.data1 
    print("090---------990",self.data1)--{{},{}}
    print("090---------666",countpersonal，countbuy)
    

    --全屏界面通用header样式1
    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "daily_snap_up/res/meirifuliwenzi.png", 
        showHome = false,
        ["onExit"] = function()
        --关闭当前页面
            self:removeSelf()
        end
    })
    self:addChild(style)

    --滑动事件
    self.Panel_1:setContentSize(qy.winSize.width, qy.winSize.height)--重新加载一边tableview的长宽
    self.Panel_1:removeAllChildren()
    self.Panel_1:addChild(self:createView())
    self.Button_1:setPosition(-qy.winSize.width/2 + 132, qy.winSize.height/2 - 24)--设置详情按钮的位置
    --详情按钮点击事件
    self:OnClick("Button_1", function()
        qy.tank.view.common.HelpDialog.new(51):show(true)
    end)
end

--创建滑动列表item
function MainDialog:createView()
    local tableView = cc.TableView:create(cc.size(qy.winSize.width, 570))   
    --纵向滑动
    --tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    --横向滑动
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    -- tableView:setSwallowTouches(false)
    tableView:setTouchEnabled(true)
    tableView:setPosition(1,1)
      
    local function numberOfCellsInTableView(tableView)         
            
        return  countpersonal + countbuy
    end

    local function cellSizeForTable(tableView,idx)       
        return 310,569
    end

    local function tableCellAtIndex(tableView, idx)       
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil
        
        if nil == cell then
            cell = cc.TableViewCell:new()
            print(countbuy.."========"..countpersonal)
            item = require("daily_snap_up.src.ItemView").new(countpersonal,countbuy,{
                ["callback"] = function ()
                   
                    print("回调方法...")
                    local listCury = self.tableView:getContentOffset()
                    self.tableView:reloadData()
                    self.tableView:setContentOffset(listCury)--设置滚动距离
                end
                })            
            cell:addChild(item)
            cell.item = item
        end
        --idx是从0开始的    
        if idx < #self.data then            
           cell.item:render(self.data[idx + 1],idx + 1,1)

        elseif idx >= #self.data then          
           cell.item:render(self.data1[idx - #self.data + 1],idx + 1,2)
        end       
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()
    self.tableView = tableView
    return tableView
end



function MainDialog:onExit()	
    if self.timer2 ~= nil then
        self.timer2:stop()
    end       
    self.timer2 = nil
end


function MainDialog:onEnter()
print("hhhhhhhhhhhhhhhhhhhhhhh111")    
    self.timer2 = qy.tank.utils.Timer.new(1,999999999,function(leftTime)
        print("hhhhhhhhhhhhhhhhhhhhhhh")
        self.model.current_time = self.model.current_time + 1
    end)
    self.timer2:start()
end
return MainDialog

