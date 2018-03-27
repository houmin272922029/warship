--[[
    成长基金
    Author: mingming
    Date: 2015-08-21 16:28:15
]]

local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "view/operatingActivities/growthFund/MainDialog")

local model = qy.tank.model.OperatingActivitiesModel
local service = qy.tank.service.OperatingActivitiesService
function MainDialog:ctor(entity)
    -- model:initFund()
    MainDialog.super.ctor(self)

    self:setCanceledOnTouchOutside(true)
    -- self:setCanceledOnTouchOutside(true)
    -- self:InjectView("Bg")
    self:InjectView("Btn_buy")
    -- self:InjectView("Input")
    self:InjectView("List")
    self:InjectView("timeTxt")

    self:OnClick("Close", function()
        --qy.QYPlaySound.stopMusic()
       self:dismiss()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self:OnClick("Btn_buy", function()
        --qy.QYPlaySound.stopMusic()
        if qy.tank.model.UserInfoModel.userInfoEntity.vipLevel >= 2 then
            service:buyFund(function()
                self.Btn_buy:setVisible(not model.is_have_buy)
                self.timeTxt:setVisible(not model.is_have_buy)
                self.tableView:reloadData()
                qy.hint:show(qy.TextUtil:substitute(63008))
            end)
        else
            self:dismiss()
            qy.hint:show(qy.TextUtil:substitute(63009))
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.RECHARGE)
            -- qy.tank.command.VipCommand:showPrivilegeView()
        end
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})
    
    self.Btn_buy:setVisible(not model.is_have_buy)
    self.timeTxt:setVisible(not model.is_have_buy)

    -- -- 通用弹窗样式
    -- local style = qy.tank.view.style.DialogStyle3.new({
    --     size = cc.size(835, 545),   
    --     position = cc.p(0, 0),
    --     offset = cc.p(0, 0),
        
    --     ["onClose"] = function()
    --         self:dismiss()
    --     end
    -- })
    -- self:addChild(style)
    -- style:setLocalZOrder(-1)
    -- self.style = style

    -- self:OnClick("Btn_comment", function()
    --     --qy.QYPlaySound.stopMusic()
    --     local content = self.Input:getString()
    --     if string.len(content) > 0 then
    --         qy.tank.service.AchievementService:addComment(entity.tank_id, content, function()
    --             self.Input:setString("")
    --         end)
    --     else
    --         qy.hint:show("请先输入评论内容")
    --     end
    -- end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    -- local winSize = cc.Director:getInstance():getWinSize()
    -- self.TitleBg:setPositionX(winSize.width / 2 - 2)

    -- self.TitleBg:addChild(self:createView(entity))

    -- self.enableService = true
    self.List:addChild(self:createView())
end

function MainDialog:createView(entity)
    local tableView = cc.TableView:create(cc.size(631, 370))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(cc.p(0, 0))

    -- local data = atFund

    local function numberOfCellsInTableView(tableView)
        return #model.fundList
    end

    local function cellSizeForTable(tableView,idx)
        return 631, 150
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil
        -- local data = model:getList(idx)
        -- local height = model:getHeight(idx)
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.operatingActivities.growthFund.ItemView.new({
               ["onReward"] = function(node)
                    local aType = qy.tank.view.type.ModuleType
                    service:getCommonGiftAward(node.entity.level, aType.UP_FUND,false, function(reData)
                        node.entity.status = 1
                        node:setButton()
                    end)
                end
            })
            cell:addChild(item)
            cell.item = item
        end

        cell.item.idx = idx
        cell.item:setData(model:atFund(idx), model.is_have_buy)

        -- local offset = tableView:getContentOffset()
        
        -- self.idx = idx
        -- if (idx == table.nums(data) - 1 and self.enableService) and model.nextPage ~= -1 then
        --     self.enableService = false
        --     qy.tank.service.AchievementService:getCommentList(entity.tank_id, function()
        --         self.tableView:reloadData()
        --         self.tableView:setContentOffset(cc.p(0, self.idx * -79), false)
        --         self.enableService = true
        --     end, model.nextPage)
        -- end

        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    -- tableView:registerScriptHandler(tableScroll,cc.SCROLLVIEW_SCRIPT_SCROLL)
    
    tableView:reloadData()
    self.tableView = tableView

    return tableView
end

return MainDialog


