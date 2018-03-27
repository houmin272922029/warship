--[[
	报名列表 & 剩余人数列表
	Author: H.X.Sun
]]

local SignUpList = qy.class("SignUpList", qy.tank.view.BaseView, "legion_war/ui/SignUpList")

function SignUpList:ctor(params)
    SignUpList.super.ctor(self)
    self:InjectView("title")
    -- self:InjectView("sign_node")
    -- self:InjectView("results_node")
    -- self:InjectView("rank_txt")
    -- self:InjectView("num_txt")
    self:InjectView("num_member")
    self:InjectView("t_member")

    self.model = qy.tank.model.LegionWarModel
    cc.SpriteFrameCache:getInstance():addSpriteFrames("legion_war/res/legion_war.plist")
    self.infoEntity = self.model:getLegionWarInfoEntity()
    if self.infoEntity:getGameAction() == self.model.ACTION_PLAY or self.infoEntity:getGameStage() == self.model.STAGE_FINAL then
        self.title:setSpriteFrame("legion_war/res/result_t_"..self.infoEntity:getGameStage()..".png")
        -- self.sign_node:setVisible(false)
        -- self.results_node:setVisible(true)
    else
        self.title:setSpriteFrame("legion_war/res/baomingqingkuang.png")
        -- self.sign_node:setVisible(true)
        -- self.results_node:setVisible(false)
    end
end

function SignUpList:updateNum()
    if self.infoEntity:getGameAction() == self.model.ACTION_SIGN then
        self.t_member:setString(qy.TextUtil:substitute(53035))
    else
        self.t_member:setString(qy.TextUtil:substitute(53036))
    end
    self.num_member:setString(self.model:getJoinNum() .. "/"..self.model.member_len)
end

function SignUpList:createList()
    local tableView = cc.TableView:create(cc.size(307,356))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setDelegate()

    local function numberOfCellsInTableView(table)
        if self.infoEntity:getGameAction() == self.model.ACTION_PLAY or self.infoEntity:getGameStage() == self.model.STAGE_FINAL then
            return self.model:getJoinNum()
        else
            return self.model:getMemberNum()
        end
    end

    local function tableCellTouched(table,cell)
    end

    local function cellSizeForTable(tableView, idx)
        return 307, 42
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.legion.war.NameCell.new()
            cell:addChild(item)
            cell.item = item
        end
        cell.item:render(idx+1)

        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()
    return tableView
end

function SignUpList:update()
    self.list:reloadData()
    self:updateNum()
end

function SignUpList:onEnter()
    if not tolua.cast(self.list,"cc.Node") then
        self.list = self:createList()
        self:addChild(self.list)
        self.list:setPosition(12,92)
    end
    self:updateNum()
end

return SignUpList
