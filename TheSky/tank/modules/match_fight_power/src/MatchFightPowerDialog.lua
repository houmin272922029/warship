--[[
    
]]

local MatchFightPowerDialog = qy.class("MatchFightPowerDialog", qy.tank.view.BaseDialog, "match_fight_power/ui/MatchFightPowerDialog")

function MatchFightPowerDialog:ctor(delegate)
    MatchFightPowerDialog.super.ctor(self)

    self:InjectView("Time")
    self:InjectView("bg")
    self:InjectView("Tap_top_bg")
    self:InjectView("Tap_top_bg2")
    self:InjectView("Tap_top_1_2")
    self:InjectView("Tap_top_3")
    self:InjectView("My_power")
    self:InjectView("My_rank")
    self:InjectView("Text")

    self.Tap_top_1_2:setLocalZOrder(1)
    self.Tap_top_3:setLocalZOrder(1)
    self.Tap_top_bg:setLocalZOrder(1)
    self.Tap_top_bg2:setLocalZOrder(1)

    self:OnClick("Close", function(sender)
        self:removeSelf()
    end,{["isScale"] = false})

    -- 内容样式
    self.delegate = delegate
    self.model = qy.tank.model.MatchFightPowerModel
    self.userInfo = qy.tank.model.UserInfoModel

    
    self.tab_host = qy.tank.widget.TabHost.new({
        delegate = self,
        csd = "widget/TabButton2",
        tabs = {qy.TextUtil:substitute(90097), qy.TextUtil:substitute(90098), qy.TextUtil:substitute(90099), qy.TextUtil:substitute(90100), qy.TextUtil:substitute(90101)},
        size = cc.size(155,50),
        layout = "h",
        idx = 1,

        ["onCreate"] = function(tabHost, idx)            

            self.Tap_top_1_2:setVisible(false)
            self.Tap_top_3:setVisible(false)
            self.Tap_top_bg:setVisible(true)

            if idx == 1 then
                self.Tap_top_1_2:setVisible(true)
                self.Text:setString(qy.TextUtil:substitute(90102))
            elseif idx == 2 then
                self.Tap_top_1_2:setVisible(true)    
                self.Text:setString(qy.TextUtil:substitute(90103))                            
            elseif idx == 3 then                
                self.Tap_top_3:setVisible(true)
            else 
                self.Tap_top_bg:setVisible(false)
            end

            return self:createContent(idx)
        end,
        
        ["onTabChange"] = function(tabHost, idx)
            if idx < 4 then
                tabHost.views[idx]:reloadData()
            end

            self.Tap_top_1_2:setVisible(false)
            self.Tap_top_3:setVisible(false)
            self.Tap_top_bg:setVisible(true)

            if idx == 1 then
                self.Tap_top_1_2:setVisible(true)
                self.Text:setString(qy.TextUtil:substitute(90102))
            elseif idx == 2 then
                self.Tap_top_1_2:setVisible(true)    
                self.Text:setString(qy.TextUtil:substitute(90103))                 
            elseif idx == 3 then                
                self.Tap_top_3:setVisible(true)
            else 
                self.Tap_top_bg:setVisible(false)
            end
        end
    })
    self:InjectView("panel")
    self.panel:setLocalZOrder(1)
    self.panel:setSwallowTouches(false)
    self.panel:addChild(self.tab_host)
    self.tab_host:setPosition(155,495)

    if self.model.ranking ~= 0 then
        self.My_rank:setString(qy.TextUtil:substitute(67011)..self.model.ranking.. qy.TextUtil:substitute(50012))
    end 

    self.My_power:setString(self.model.myFightPower)
end

function MatchFightPowerDialog:createContent(_idx)

    if _idx == 4 then
        local data = qy.tank.view.common.AwardItem.getItemData({
                  ["type"] = 11,
                  ["tank_id"] = 83,
            })
        local tip = require("match_fight_power.src.TankTip").new(data.entity)
        tip:setPosition(0, -490)
        return tip
    elseif _idx == 5 then
        local help_txt = require("match_fight_power.src.Help").new()
        help_txt:setPosition(0, -490)
        return  help_txt
    else 
        local tableView = cc.TableView:create(cc.size(770,379))
        tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        tableView:setAnchorPoint(0, 0)
        tableView:setPosition(10, -420)
        tableView:setDelegate()

        local function numberOfCellsInTableView(table)
            if _idx == 1 then
                return #self.model.chest_list
            elseif _idx == 2 then
                return #self.model.power_chest_list
            elseif _idx == 3 then
                return #self.model.list
                --return 10
            end
        end

        local function tableCellTouched(table,cell)
            print("cell touched at index: " .. cell:getIdx())
            if cell.item.entity then
                local kid = cell.item.entity.kid or 0
                if kid ~= self.userInfo.kid and kid ~= 0 then
                    qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXAMINE,cell.item.entity.kid)
                end
            end
        end

        local function cellSizeForTable(tableView, idx)
            return 770, 135
        end

        local function tableCellAtIndex(table, idx)
            local cell = table:dequeueCell()
            local item = nil
            local label = nil
            if nil == cell then
                cell = cc.TableViewCell:new()
                item = require("match_fight_power.src.MatchFightPowerCell").new(_idx)
                cell:addChild(item)
                cell.item = item
            end

            if _idx == 1 then
                cell.item:render(self.model.chest_list[idx+1], 1, idx+1)
            elseif _idx == 2 then
                cell.item:render(self.model.power_chest_list[idx+1], 2, idx+1)
            elseif _idx == 3 then
                if #self.model.list > idx then
                    cell.item:render(self.model.list[idx+1], 3, idx+1)
                else 
                    cell.item:render(nil, 3, idx+1)
                end
            end
            return cell
        end

        tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
        tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
        tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
        tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
        
        tableView:reloadData()

        return tableView
    end
end


function MatchFightPowerDialog:updateTime()
    if self.Time then
        self.Time:setString(self.model:getEndTime())
    end
end

function MatchFightPowerDialog:onEnter()
    self:updateTime()
    self.timeListener = qy.Event.add(qy.Runtime.TIMER_UPDATE,function(event)
        self:updateTime()
    end)
end

function MatchFightPowerDialog:onExit()
    qy.Event.remove(self.timeListener)
    self.timeListener = nil
end

return MatchFightPowerDialog

