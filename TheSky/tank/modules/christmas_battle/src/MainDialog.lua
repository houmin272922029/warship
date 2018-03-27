--[[
	
]]

local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "christmas_battle.ui.MainDialog")
--ChristmasBattleService
--ChristmasBattleModule
function MainDialog:ctor(delegate)
    MainDialog.super.ctor(self)
    self.model = qy.tank.model.ChristmasBattleModel
    self.service = qy.tank.service.ChristmasBattleService

    self:InjectView("Btn_close")
    self:InjectView("Txt_time")
    self:InjectView("Bg")
    self:InjectView("Image_4")
    self:InjectView("Image_5")
    self:InjectView("Image_6")
    self:InjectView("Times")
    self:InjectView("Ranking")
    self:InjectView("Ranking_y")
    self:InjectView("Hurt")
    self:InjectView("Hurt_y")
    self:InjectView("Btn_battle")

    self.data = self.model.data
    -- self.today_rank_list = self.data.today_rank.rank_list 
    -- self.yesterday_rank_list = self.data.yesterday.rank_list

    self.today_page_num = 1
    self.today_flag = true
    self.yesterday_page_num = 1
    self.yesterday_flag = true

    self.host = qy.tank.widget.TabHost.new({
        csd = "widget/TabButton3",--按钮样式
        tabs = {"昨日排行", "今日排行", "排名礼包"},--按钮显示文字
        size = cc.size(140,20),--按钮尺寸
        layout = "h",
        idx = 2,

        ["onCreate"] = function(tabHost,idx)
            self.idx = idx
            print("点击11",idx)
            if idx == 1 then
                return self:createView() 
            elseif idx == 2 then
                return self:createView2()
            elseif idx == 3 then
                return self:createView3()
            end
        end,
        
        ["onTabChange"] = function(tabHost, idx)
            self.idx = idx
            print("点击id",idx)
            tabHost.views[idx]:reloadData()
            self:change_title(idx)
            self:setTimes(idx)
        end
    })
    self.Bg:addChild(self.host)
    self.host:setPosition(370,480)

    
    

    self:OnClick("Btn_close",function (  )
        self:removeSelf()
    end)

    self:OnClick("Btn_battle",function (  )
        
        self.service:attack(function (data)
            self.model:getattackUpdate()
            self.model:jianyi()
            self:setTimes(self.idx)
            self.today_flag = true
            self.today_page_num = 1
            self.tableView2:reloadData()

        end)
    end)

    self:setTime()
end

--设置活动时间
function MainDialog:setTime(  )
    local startTime = os.date("%Y年%m月%d日",self.model.start_time)
    local endTime = os.date("%Y年%m月%d日",self.model.end_time)
    self.Txt_time:setString(startTime..qy.TextUtil:substitute(52003)..endTime)
end

--设置剩余次数，我的排名，伤害
function MainDialog:setTimes(type_id)
    self.Hurt_y:setVisible(type_id == 1)
    self.Ranking_y:setVisible(type_id == 1)
    self.Hurt:setVisible(type_id ~= 1)
    self.Ranking:setVisible(type_id ~= 1)
    if type_id == 1 then 
        local yesterday_rank = self.model:getYesterdayRank().my_rank
        
        self.Ranking_y:setString(yesterday_rank.rank)
        self.Hurt_y:setString(yesterday_rank.hurt)
    elseif type_id == 2 then 
        local today_rank = self.model:getTodayRank().my_rank
        print("today_rank_111111",today_rank.rank)
        print("today_rank_22222",today_rank.hurt)
        self.Ranking:setString(today_rank.rank)
        self.Hurt:setString(today_rank.hurt)
    elseif type_id == 3 then
        local today_rank = self.model:getTodayRank().my_rank
        self.Ranking:setString(today_rank.rank)
        self.Hurt:setString(today_rank.hurt)
    end 
        local times = self.model.data
        self.Times:setString(times.activity_info.times)
end

--创建列表item 昨天
function MainDialog:createView(idxx)--idxx 1 2 3
    self:change_title(self.idx)
    self:setTimes(self.idx)

    tableView = cc.TableView:create(cc.size(535, 370))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setTouchEnabled(true)
    tableView:setPosition(-80,-420)
    
    local function numberOfCellsInTableView(tableView)
        self.yesterday_rank = self.model:getYesterdayRank()
        print("昨天个数",#self.yesterday_rank.rank_list)
        return #self.yesterday_rank.rank_list
    end

    local function cellSizeForTable(tableView,idx)       
        return 530,70
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("christmas_battle.src.ItemView").new()
            cell:addChild(item)
            cell.item = item
        end
        --idx是从0开始的
            local yesterday_rank_list = self.model:getYesterdayRank().rank_list
            if yesterday_rank_list ~=nil then
                cell.item:render(yesterday_rank_list[idx + 1],1,idx + 1)
            end
        
            if idx + 1 == #self.yesterday_rank.rank_list and self.yesterday_flag and #self.yesterday_rank.rank_list >= 30  then
                self.yesterday_page_num = self.yesterday_page_num + 1 
                self.service:getRankList(2,self.yesterday_page_num,function (data)
                    table.insertto(self.yesterday_rank.rank_list,data.rank_list)
                    if #data.rank_list < 30 then
                        self.yesterday_flag = false
                    end
                    local y = self.tableView:getContentOffset().y
                    y = y - #data.rank_list * 70
                    self.tableView:reloadData()
                    --self.host.views[1]:reloadData()
                    self.tableView:setContentOffset(cc.p(0,y))

                end)
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

--今天
function MainDialog:createView2()--idxx 1 2 3
    self:change_title(self.idx)
    self:setTimes(self.idx)

    tableView = cc.TableView:create(cc.size(535, 370))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setTouchEnabled(true)
    tableView:setPosition(-80,-420)
    
    local function numberOfCellsInTableView(tableView)
        self.today_rank = self.model:getTodayRank()
        print("今天个数",#self.today_rank.rank_list)
        return #self.today_rank.rank_list
    end

    local function cellSizeForTable(tableView,idx)       
        return 530,70
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("christmas_battle.src.ItemView").new()
            cell:addChild(item)
            cell.item = item
        end
        --idx是从0开始的
            local today_rank_list = self.model:getTodayRank().rank_list
            if today_rank_list ~= nil then
                cell.item:render(today_rank_list[idx + 1],2,idx + 1)
            end
        
           if idx + 1 == #self.today_rank.rank_list and self.today_flag and #self.today_rank.rank_list >= 30 then
            self.today_page_num = self.today_page_num + 1 
            self.service:getRankList(1,self.today_page_num,function (data)
                table.insertto(self.today_rank.rank_list,data.rank_list)
                if #data.rank_list < 30 then
                    self.today_flag = false
                end
                local y = self.tableView2:getContentOffset().y
                y = y - #data.rank_list * 70
                self.tableView2:reloadData()
                --self.host.views[2]:reloadData()
                self.tableView2:setContentOffset(cc.p(0,y))

            end)
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

function MainDialog:createView3()--idxx 1 2 3
    self:change_title(self.idx)
    self:setTimes(self.idx)
    tableView = cc.TableView:create(cc.size(535, 370))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setTouchEnabled(true)
    tableView:setPosition(-80,-420)
    
    local function numberOfCellsInTableView(tableView)
        self.today_rank = self.model:getTodayRank()
        self.yesterday_rank = self.model:getYesterdayRank()
        local num = self.model:getlenght()
        return num
    end

    local function cellSizeForTable(tableView,idx)       
        return 530,70
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("christmas_battle.src.ItemView").new()
            cell:addChild(item)
            cell.item = item
        end
        --idx是从0开始的
        cell.item:render(nil,3,idx + 1)
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()
    self.tableView3 = tableView
    return tableView
end

function MainDialog:change_title(type_id)
    self.Image_6:setVisible(type_id == 3)
    self.Image_5:setVisible(type_id ~= 3)

end

return MainDialog

