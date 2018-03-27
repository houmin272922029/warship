--[[
	战狼归来
	
]]

local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "legion_recharge.ui.MainDialog")

function MainDialog:ctor()
    MainDialog.super.ctor(self)
    self.model = qy.tank.model.LegionRechargeModel
    self.service = qy.tank.service.LegionRechargeService

    self:InjectView("Btn_close")
    self:InjectView("Txt_time")
    self:InjectView("Panel_1")
    self:InjectView("Panel_2")
    self:InjectView("Txt_my_money")
    self:InjectView("Txt_my_contribution")
    self:InjectView("Txt_legion_money")

    self.page_num = 1
    self.flag = true

    self:OnClick("Btn_close",function (  )
        self:removeSelf()
    end)

    self:createTimer1()
    
    

    self.Right_view = self.model.config
    self.model_data = self.model.data

    self.Panel_1:removeAllChildren()
    self.Panel_1:addChild(self:createView())

    self.Panel_2:removeAllChildren()
    self.Panel_2:addChild(self:createView2())

    self:setMoney()
    self:setMyMoney()
    self:createTimer1()
end

--创建列表item    左边
function MainDialog:createView()
    local tableView = cc.TableView:create(cc.size(420, 403))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setTouchEnabled(true)
    tableView:setPosition(1,1)   
    local function numberOfCellsInTableView(tableView)       
        return #self.model_data.legion_recharge_info
    end

    local function cellSizeForTable(tableView,idx)       
        return 417,41
    end

    local function tableCellAtIndex(tableView, idx)
       
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("legion_recharge.src.ItemView").new()
            cell:addChild(item)
            cell.item = item
        end
        --idx是从0开始的
        if self.model_data.legion_recharge_info ~= nil then
            cell.item:render(self.model_data.legion_recharge_info[idx + 1],idx + 1 )     
        end

       -- if idx + 1 == #self.today_rank.rank_list and self.flag and #self.today_rank.rank_list >= 30 then
       --  self.page_num = self.page_num + 1 
       --  self.service:getNextList(1,self.page_num,function (data)
       --      table.insertto(self.today_rank.rank_list,data.rank_list)
       --      if #data.rank_list < 30 then
       --          self.flag = false
       --      end
       --      local y = self.tableView:getContentOffset().y
       --      y = y - #data.rank_list * 70
       --      self.tableView:reloadData()
       --      --self.tableView:reloadData()
       --      self.tableView:setContentOffset(cc.p(0,y))

       --      end)
       --  end   
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()
    self.tableView = tableView
    return tableView
end

--创建tableview2  右边
function MainDialog:createView2()--idxx 1 2 3
    tableView = cc.TableView:create(cc.size(440, 425))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setTouchEnabled(true)
    tableView:setPosition(1,1)
    
    local function numberOfCellsInTableView(tableView)
        return table.nums(self.Right_view)
    end

    local function cellSizeForTable(tableView,idx)       
        return 437,130
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("legion_recharge.src.ItemViewTwo").new({
                ["callback"] = function (  )
                    self.tableView2:reloadData()
                end
                })
            cell:addChild(item)
            cell.item = item
        end
        if self.Right_view ~= nil then
            cell.item:render(self.Right_view[tostring(idx + 1)],idx + 1)
        end
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()
    self.tableView2 = tableView
    return tableView
end

function MainDialog:setMoney(  )
    -- local data = self.model_data.legion_recharge_info
    -- if self.model_data.my_legion_recharge_info ~= nil then
    --     local my_legion_id = self.model_data.my_legion_recharge_info.legion_id
    --     print("000--0000",my_legion_id)
    --     for k,v in pairs(data) do
    --         print(k,v.legion_id)
    --     end
    --     for k,v in pairs(data) do
    --         if v.legion_id == my_legion_id then
    --             self.Txt_legion_money:setString(v.recharge.."元")
    --             return
    --         else
    --             self.Txt_legion_money:setString("000000元")
    --         end
    --     end
    -- else
    --     qy.hint:show("请加入军团")
    -- end
    if self.model_data.my_legion_recharge_info ~= nil then
        if self.model_data.my_legion_recharge_info.recharge ~= nil then
            self.Txt_legion_money:setString(self.model_data.my_legion_recharge_info.recharge.."元")
        else
            self.Txt_legion_money:setString("0元")
        end
    else
        qy.hint:show("请加入军团")
    end

end

function MainDialog:setMyMoney(  )
    if self.model_data.user_activity_data ~= nil then
        self.Txt_my_money:setString(self.model_data.user_activity_data.recharge.."元")
        self.Txt_my_contribution:setString(self.model_data.user_activity_data.contribution)
    end
end

--创建定时器1
function MainDialog:createTimer1()
    -- local endTime = os.date(self.model.end_time)
    -- local endTime2 = os.date("%Y.%m.%d",self.model.end_time)
    -- local currentTime=os.time()
    --local remainTime1 =endTime-currentTime
    local enttiem = self.model.end_time
    local starttime = self.model.start_time
    local remainTime1 = enttiem - starttime
      
    if remainTime1 <=0 then 
        self:clearTimer()
        self:updateLeftTime(0)
        return
    end

    if self.timer1 == nil then
        self.timer1 = qy.tank.utils.Timer.new(1,remainTime1,function(leftTime)
            self:updateLeftTime(leftTime)
        end)
        self.timer1:start()
    end
    self:updateLeftTime(remainTime1)
end

--更新剩余时间
function MainDialog:updateLeftTime(leftTime)
    if leftTime == 0 then        
        self:clearTimer()
        self.Txt_time:setString(""..leftTime)
    else
       local timeStr = qy.tank.utils.DateFormatUtil:toDateString1(leftTime , 1)
        self.Txt_time:setString(timeStr)
    end
end

-- 清除时钟
function MainDialog:clearTimer( )
    if self.timer1 ~=nil then
        self.timer1:stop()
    end       
    self.timer1 = nil
end

function MainDialog:onExit()
    self:clearTimer()
end

function MainDialog:onEnter(  )
    self:createTimer1()
end

return MainDialog

