--[[
    扫荡dialog
]]
local AutoFightDialog = qy.class("AutoFightDialog", qy.tank.view.BaseView, "soul_road.ui.AutoFightDialog")

local model = qy.tank.model.SoulRoadModel
function AutoFightDialog:ctor(delegate)
    AutoFightDialog.super.ctor(self)

    self:InjectView("panel")
    self:InjectView("selectSign")
    self:InjectView("selectBtn1")
    self:InjectView("selectBtn2")
    self:InjectView("selectBtn3")
    self:InjectView("autoFightBtn")
    self:InjectView("container")
    self:InjectView("costTxt1")
    self:InjectView("costTxt2")
    self:InjectView("costTxt3")

    self.checkpoint = delegate
    local userEneryNum  = 5

    self.clickTimes = 1
    -- self.autoFightDisableBtn:setVisible(false)
    self.isCellFightEnd = false
    self.isAutoFightEnd = true
    -- self:OnClick(self.closeBtn, function()
    --     self:dismiss()
    -- end)

    self.costTxt1:setString(model:getAutoFightCost(1))
    self.costTxt2:setString(model:getAutoFightCost(5))
    self.costTxt3:setString(model:getAutoFightCost(10))
       
    self:OnClick(self.selectBtn1, function()
        self.clickTimes = 1
        self.selectSign:setPositionY(self.selectBtn1:getPositionY() + 33)
    end)
    
    self:OnClick(self.selectBtn2, function()
        self.clickTimes = 5
        self.selectSign:setPositionY(self.selectBtn2:getPositionY() + 33)
    end)
    
    self:OnClick(self.selectBtn3, function()
        self.clickTimes = 10
        self.selectSign:setPositionY(self.selectBtn3:getPositionY() + 33)
    end)

    -- local model = qy.tank.model.UserInfoModel
   
    self:OnClick(self.autoFightBtn, function()
        if model:getAutoFightCost(self.clickTimes) > 0 then
            -- --体力不足
            -- qy.hint:show("体力不足")
            -- qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.BUY_OR_USE)
            -- return
            local alertMesg = qy.TextUtil:substitute(67001) .. model:getAutoFightCost(self.clickTimes) .. qy.TextUtil:substitute(67002) 
            qy.alert:show(               
                {qy.TextUtil:substitute(67003) ,{255,255,255} } ,
                alertMesg ,
                cc.size(533 , 250) ,{{qy.TextUtil:substitute(67004) , 4} , {qy.TextUtil:substitute(67005) , 5} } ,
                function(flag)
                    if qy.TextUtil:substitute(67005) == flag then
                        self:start()
                    end
                end ,"")
        else
            self:start()
        end
    end)
end

function AutoFightDialog:start()
    self.tableMax = self.clickTimes
    local service = qy.tank.service.SoulRoadService
    local param = {}
    param["checkpoint_id"] = self.checkpoint.checkpoint_id
    param["times"] = self.tableMax

    service:raids(param,function(data)
        self.awardList = data.list
--        {"list":{"1":{"exp":{"is_max_level":false,"add_exp":10,"upgrade_level":0,"upgrade_level_list":[]},"award":{"3":[{"type":3,"num":50}]}}},"level_award":[]}   
        self.isCellFightEnd = false  -- 独立的cell动画是否完成
        self.isAutoFightEnd = false
        -- self.autoFightDisableBtn:setVisible(true)
        self.autoFightBtn:setEnabled(false)
        if self.fightTableView~=nil then
            self.container:removeChild( self.fightTableView )
            self.fightTableView = nil
        end

        self:runAutoFight()
        self:update()
        qy.Event.dispatch(qy.Event.SOUL_ROAD)
    end)    
end

function AutoFightDialog:runAutoFight()
    -- self.maskLayer:setVisible(true)
    
    local count = -2;
    self.callBackFunc = function(index)
        if self.fightTableView then
            self.fightTableView:setTouchEnabled(false)
        end

        if(index == -1) then return end
        if self.effect~=nil then
            self.fightTableView:removeChild(self.effect)
            self.effect = nil
        end
        function scrollTableView()
            local offsetY = self.fightTableView:getContentOffset().y
            if self.tableMax >1 and index <self.tableMax then
                count = count+1
                if(count >0) then
                    self.isCellFightEnd = true
                    self.fightTableView:setContentOffset(cc.p(0,offsetY + 150) , true)
                end
            end
            local cell = self.fightTableView:cellAtIndex(index)

            if(cell==nil) then  
                -- self.maskLayer:setVisible(false)
                -- self.autoFightDisableBtn:setVisible(false)

                performWithDelay(self, function()
                    self.fightTableView:setTouchEnabled(true)
                end, 0.5)
                
                self.autoFightBtn:setEnabled(true)
                self.effect = ccs.Armature:create("ui_fx_saodang") 
                self.fightTableView:addChild(self.effect,999)
                self.effect:setPosition(200, -80)
                if self.tableMax >1 then 
                    self.fightTableView:setContentOffset(cc.p(0,offsetY + 150) , true)
                    local delay = cc.DelayTime:create(0.5)
                    local seq = cc.Sequence:create(delay , cc.CallFunc:create(function()
                        self.effect:getAnimation():playWithIndex(0)
                    end))
                    self:runAction(seq)
                else
                    self.effect:getAnimation():playWithIndex(0)
                end
                
                self.isAutoFightEnd = true
            return end
            cell.item:runThisAnimation(index+1)
        end
        self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5) ,cc.CallFunc:create(scrollTableView)))  
    end
    if self.fightTableView == nil then
        self.fightTableView = self:createTableView(1)
        self.container:addChild( self.fightTableView)
    end
    self.callBackFunc(0)
    
end

function AutoFightDialog:createTableView(idx)
    tableView = cc.TableView:create(cc.size(476,300))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setAnchorPoint(0,0)
    tableView:setPosition(280, 100)
    tableView:setDelegate()
    
    self.selectIdx = 1
    local function numberOfCellsInTableView(table)
        return self.tableMax
    end
    
    local function tableCellTouched(table,cell)
        print("cell touched at index: " .. cell:getIdx()+1)
       
        self.selectIdx = cell:getIdx()
    end

    local function cellSizeForTable(tableView, idx)
        return 460, 149
    end

    local function tableCellAtIndex(table, idx)
        local strValue = string.format("%d",idx)
        local cell = table:dequeueCell()
        local item,label,status
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.campaign.AutoFightItem.new( self.callBackFunc, idx)
            cell:addChild(item)
            cell.item = item

            status = cc.Label:createWithSystemFont("", "Helvetica", 24.0)
            status:setTextColor(cc.c4b(255,255,0,255))
            status:setPosition(145,47)
            status:setAnchorPoint(0.5,0.5)
            cell:addChild(status)
            cell.status = status
        end
        if self.isCellFightEnd == true then
            cell.item:update(idx)
        end
        cell.item:setData(self.awardList[tostring(idx+1)])
       
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()
    return tableView
end

function AutoFightDialog:update()
    self.costTxt1:setString(model:getAutoFightCost(1))
    self.costTxt2:setString(model:getAutoFightCost(5))
    self.costTxt3:setString(model:getAutoFightCost(10))
end

return AutoFightDialog