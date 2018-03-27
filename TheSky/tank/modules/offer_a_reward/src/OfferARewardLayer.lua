--[[
    军功悬赏
]]

local OfferARewardLayer = qy.class("OfferARewardLayer", qy.tank.view.BaseView, "offer_a_reward/ui/OfferARewardLayer")

function OfferARewardLayer:ctor(delegate)
    OfferARewardLayer.super.ctor(self)

    -- 内容样式
    self.delegate = delegate
    self.model = qy.tank.model.OfferARewardModel
    self.service = qy.tank.service.OfferARewardService
    self.userInfo = qy.tank.model.UserInfoModel


    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "Resources/activity/title_reward.png", 
        showHome = false,
        ["onExit"] = function()
            delegate:finish()
        end
    })
    self:addChild(style)


    self:InjectView("Bg")
    self:InjectView("Btn_refresh")
    self:InjectView("Btn_free_refresh")
    self:InjectView("Text_free_times")
    self:InjectView("Text_free_txt")
    self:InjectView("Text_num")
    self:InjectView("Img_free")
    self:InjectView("Img_refresh")

    self:OnClick(self.Btn_refresh, function()
        self.service:refresh(function(data)
            self:update()
        end, 2) 
        -- qy.alert:show({qy.TextUtil:substitute(46004), {255,255,255}}, "当前有橙色品质，是否继续刷新？", cc.size(450 , 260), {{qy.TextUtil:substitute(46007) , 5}, {qy.TextUtil:substitute(46006), 4}}, function(flag)
        --     if flag == qy.TextUtil:substitute(46007) then
        --         self.service:refresh(function(data)
        --             self:update()
        --         end, type) 
        --     end
        -- end,"")
    end,{["isScale"] = false})

    self:OnClick(self.Btn_free_refresh, function()
        if self:RefreshJudge(1) == 0 then
            self.service:refresh(function(data)
                self:update()
            end, 1) 
        end
    end,{["isScale"] = false})


    self.tab_host_idx = 1
    self.table_views = {}
    

    
    self.tab_host = qy.tank.widget.TabHost.new({
        delegate = self,
        csd = "widget/TabButton1",
        tabs = {"新悬赏", "执行中", "已完成"},
        size = cc.size(190,50),
        layout = "h",
        idx = 1,

        ["onCreate"] = function(tabHost, idx)    
            self.Btn_refresh:setVisible(false)        
            self.Btn_free_refresh:setVisible(false) 

            if idx == 1 then
                self.Btn_refresh:setVisible(true)        
                self.Btn_free_refresh:setVisible(true)                 
            end

            self.tab_host_idx = idx
            self.table_views[idx] = self:createContent(idx)

            return self.table_views[idx]
        end,
        
        ["onTabChange"] = function(tabHost, idx)
            tabHost.views[idx]:reloadData()
            self.tab_host_idx = idx

            self.Btn_refresh:setVisible(false)        
            self.Btn_free_refresh:setVisible(false) 

            if idx == 1 then
                self.Btn_refresh:setVisible(true)        
                self.Btn_free_refresh:setVisible(true)                 
            end
        end
    })

    self.Bg:addChild(self.tab_host)
    self.tab_host:setPosition(155,580)

    

    self.timer = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
        if #self.model:getFinish() > 0 then
            require("offer_a_reward.src.CompleteDialog").new(self.model:getFinish()):show()
        end
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.timer)
    end,0.5,false)

    self.Text_num:setString("x "..qy.tank.model.UserInfoModel.userInfoEntity.military_exploit)


    self:updateRefreshTimes()
end


function OfferARewardLayer:switchTo(idx)
    self.tab_host_idx = idx
    self.tab_host:__switchTabTo(idx)
end


function OfferARewardLayer:createContent(_idx)

    local tableView = cc.TableView:create(cc.size(930,465))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setAnchorPoint(0, 0)
    tableView:setPosition(10, -473)
    tableView:setDelegate()

    local function numberOfCellsInTableView(table)
        if _idx == 1 then
            return 3
        elseif _idx == 2 then
            return #self.model:getOngoingList()
        elseif _idx == 3 then
            return #self.model:getCompleteList()
        end
    end

    local function tableCellTouched(table,cell)
        if self.tab_host_idx == 1 then
            if #self.model:getOngoingList() >= 3 then
                self.service:getInfo(function(data)
                    if data.reward ~= nil and #data.reward.ongoing_list < 3 then
                        require("offer_a_reward.src.DetailsDialog").new(self, cell.item:getCellData(), cell.item:getCellIdx()):show()
                    elseif data.reward ~= nil and #data.reward.ongoing_list >= 3 then
                        qy.hint:show("当前悬赏任务已经接满")
                    end
                end, 1) 
            else 
                require("offer_a_reward.src.DetailsDialog").new(self, cell.item:getCellData(), cell.item:getCellIdx()):show()
            end
        end
    end

    local function cellSizeForTable(tableView, idx)
        return 930, 155
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item = nil
        local label = nil
        if nil == cell then
            cell = cc.TableViewCell:new()            
            if _idx == 1 then
                item = require("offer_a_reward.src.Cell").new()
            elseif _idx == 2 then
                item = require("offer_a_reward.src.Cell1").new(self)
            elseif _idx == 3 then
                item = require("offer_a_reward.src.Cell2").new()
            end
            cell:addChild(item)
            cell.item = item
        end

        if _idx == 1 then
            cell.item:render(self.model:getNewList()[idx+1], idx+1)
        elseif _idx == 2 then
            cell.item:render(self.model:getOngoingList()[idx+1], idx+1)
        elseif _idx == 3 then
            cell.item:render(self.model:getCompleteList()[idx+1])
        end

        return cell
    end


    local function tableCellHighLight(table,cell)
        if self.tab_host_idx == 1 then
            cell.item:hightLight()
        end
    end

    local function tableCellUnhighLight(table,cell)
        if self.tab_host_idx == 1 then
            cell.item:unhightLight()
        end
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)

    tableView:registerScriptHandler(tableCellHighLight, cc.TABLECELL_HIGH_LIGHT)
    tableView:registerScriptHandler(tableCellUnhighLight, cc.TABLECELL_UNHIGH_LIGHT)

    tableView:reloadData()

    return tableView
end



function OfferARewardLayer:update()
    if self.table_views[self.tab_host_idx] ~= nil then
        self.table_views[self.tab_host_idx]:reloadData()
    end

    if #self.model:getFinish() > 0 then
        require("offer_a_reward.src.CompleteDialog").new(self.model:getFinish()):show()
    end

    self.Text_num:setString("x "..qy.tank.model.UserInfoModel.userInfoEntity.military_exploit)

    self:updateRefreshTimes()
end


function OfferARewardLayer:updateRefreshTimes()
    local times = self.model:getFreeRefreshTimes()
    if times <= 0 then
        self.Text_free_times:setVisible(false)
        self.Text_free_txt:setVisible(false)
    else
        self.Text_free_times:setVisible(true)
        self.Text_free_txt:setVisible(true)
        self.Text_free_times:setString(self.model:getFreeRefreshTimes().."次")
    end
    

    if self.model:getFreeRefreshTimes() > 0 then
        self.Img_free:setVisible(true)
        self.Img_refresh:setVisible(false)
    else
        self.Img_free:setVisible(false)
        self.Img_refresh:setVisible(true)
    end
end


function OfferARewardLayer:RefreshJudge(type)
    local status = 0  --0无橙色 1不全橙色 2全橙色

    for i = 1, 3 do 
        if self.model:getRewardById(self.model:getNewList()[i].id).quality == 5 then
            if status == 0 and i == 1 then
                status = 2
            elseif status == 0 then
                status = 1
            end
        elseif status == 2 then
            status = 1
        end
    end

    if status ~= 0 then
        qy.alert:show({qy.TextUtil:substitute(46004), {255,255,255}}, "当前有橙色品质，是否继续刷新？", cc.size(450 , 260), {{qy.TextUtil:substitute(46007) , 5}, {qy.TextUtil:substitute(46006), 4}}, function(flag)
            if flag == qy.TextUtil:substitute(46007) then
                self.service:refresh(function(data)
                    self:update()
                end, type) 
            end
        end,"")
    end

    return status    
end

return OfferARewardLayer

