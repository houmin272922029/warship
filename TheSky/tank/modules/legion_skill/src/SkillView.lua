--[[
    军团技能
]]

local SkillView = qy.class("SkillView", qy.tank.view.BaseView, "legion_skill.ui.SkillView")

local model = qy.tank.model.LegionModel

function SkillView:ctor(delegate) 
    SkillView.super.ctor(self)
    self:InjectView("Panel_1")
    self:InjectView("now")
    self:InjectView("now_0")
    self:InjectView("silver")
    self:InjectView("Button_1")
    self:OnClick("Button_1",function()
        if delegate and delegate.dismiss then
            delegate.dismiss()
        end
    end)
    local contribution = model.contributions
    local contribution_skill = model.contribution_skill
    self.now:setString(qy.InternationalUtil:getResNumString(contribution))
    self.now_0:setString(qy.InternationalUtil:getResNumString(contribution_skill))
    self.Panel_1:addChild(self:creteAttrList())
    self.silver:setString(qy.InternationalUtil:getResNumString(qy.tank.model.UserInfoModel.userInfoEntity.silver))
end

function SkillView:creteAttrList()
    local tableView = cc.TableView:create(cc.size(920, 475))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(0, 0)


    local function numberOfCellsInTableView(tableView)
        return 4
    end

    local function cellSizeForTable(tableView,idx)
        return 920, 160
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("legion_skill.src.SkillCell").new()
            cell:addChild(item)
            cell.item = item
        end

        cell.item.idx = idx
        cell.item:setData((idx+1))
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()
    self.AttrtableView = tableView
    return tableView
end

--更新列表
function SkillView:updateTankList()
    local listCurY = self.AttrtableView:getContentOffset().y
    self.AttrtableView:reloadData()
    self.AttrtableView:setContentOffset(cc.p(0,listCurY))
    self.silver:setString(qy.InternationalUtil:getResNumString(qy.tank.model.UserInfoModel.userInfoEntity.silver))
    local contribution_skill = model.contribution_skill
    self.now_0:setString(qy.InternationalUtil:getResNumString(contribution_skill))
end

function SkillView:onEnter()
    self.listener_1 = qy.Event.add(qy.Event.SEARCH_TREASURE,function(event)
        self:updateTankList()
    end)
end

function SkillView:onExit()
    qy.Event.remove(self.listener_1)
end

return SkillView