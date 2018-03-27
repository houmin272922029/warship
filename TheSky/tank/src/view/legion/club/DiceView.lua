--[[
	骰子
	Author: H.X.Sun
]]

local DiceView = qy.class("DiceView", qy.tank.view.BaseView, "legion/ui/club/DiceView")

function DiceView:ctor(delegate)
    DiceView.super.ctor(self)
    local head = qy.tank.view.legion.HeadCell.new({
        ["onExit"] = function()
            delegate.dismiss(false)
        end,
        ["showLine"] = true,
        ["titleUrl"] = "legion/res/club/jtsz_01.png",
    })
    self:addChild(head,10)
    self.delegate = delegate
    self.model = qy.tank.model.LegionModel
    local service = qy.tank.service.LegionService

    self:InjectView("img_left")
    self:InjectView("img_right")
    self:InjectView("l_p_count")
    self:InjectView("l_rank_txt")
    self:InjectView("l_re_txt")
    self:InjectView("rank_txt")
    self:InjectView("day_times")
    self:InjectView("p_count")
    self:InjectView("rank_tip_txt")
    self:InjectView("action_btn")

    for i = 1, 3 do
        self:InjectView("dice_"..i)
        self:InjectView("get_btn_"..i)
        if i ~= 3 then
            self:InjectView("reward_tip_"..i)
            self:InjectView("reward_"..i)
        end
        self:OnClick("get_btn_"..i,function()
            if self.model:canGetDiceAward(i) then
                service:getDiceAward(i,function()
                    self:updateBtnStatus()
                end)
            else
                qy.hint:show(self.model:getDiceNotAwardMsg(i))
            end
        end)
    end

    self.effertArr = {}
    self:OnClick("action_btn",function()
        if self.model:getCommanderEntity().d_use_times > 0 then
            if not self.isShowAnima then
                self.isShowAnima = true
                service:getDiceBegin(function()
                    self:__showEffert(self.model:getDiceResult())
                end)
            end
        else
            qy.hint:show(qy.TextUtil:substitute(51005))
        end
    end)
end

function DiceView:update()
    local entity = self.model:getCommanderEntity()
    self.l_p_count:setString(qy.TextUtil:substitute(51006, entity.d_ago_score))
    self.l_rank_txt:setString(entity.d_ago_rank)
    self.l_re_txt:setString(entity.d_ago_dia_num)
    self.rank_txt:setString(qy.TextUtil:substitute(51007, entity.d_my_rank))
    self.day_times:setString(qy.TextUtil:substitute(51009, entity.d_use_times))
    self.p_count:setString(qy.TextUtil:substitute(51011, entity.d_my_score))
    if 0 < entity.d_my_rank and entity.d_my_rank < 31 then
        self.rank_tip_txt:setVisible(false)
    else
        self.rank_tip_txt:setVisible(true)
    end
    self.action_btn:setBright(entity.d_use_times > 0)

    self.list:reloadData()
    self:updateBtnStatus()
end

function DiceView:updateBtnStatus()
    for i = 1, 3 do
        if self.model:canGetDiceAward(i) then
            -- print("setBright(true)=======>>>>>",i)
            self["get_btn_"..i]:setBright(true)
        else
            -- print("setBright(false)=======>>>>>",i)
            self["get_btn_"..i]:setBright(false)
        end
    end
end

function DiceView:createList()
    local tableView = cc.TableView:create(cc.size(551,508))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setDelegate()

    local function numberOfCellsInTableView(table)
        return self.model:getDiceRankNum()
    end

    local function tableCellTouched(table,cell)
    end

    local function cellSizeForTable(tableView, idx)
        return 551,40
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.legion.club.DiceCell.new()
            cell:addChild(item)
            cell.item = item
        end
        cell.item:update(self.model:getDiceRankByIndex(idx + 1))

        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()
    return tableView
end

function DiceView:__showEffert(data)
    local val = 0
    for i = 1, 3 do
        val = val + data[i]
        self["dice_"..i]:setVisible(false)
        local _url = "legion/res/club/dice_"..data[i]..".png"
        if cc.SpriteFrameCache:getInstance():getSpriteFrame(_url) then
            self["dice_"..i]:setSpriteFrame(_url)
        end
        if self.effertArr[i] == nil then
            self.effertArr[i] = ccs.Armature:create("ui_fx_shaizi")
            self.effertArr[i]:setPosition(self["dice_"..i]:getPosition())
            self.img_right:addChild(self.effertArr[i],999)
        end

        self.effertArr[i]:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
            if movementType == ccs.MovementEventType.complete then
                self.isShowAnima = false
                self["dice_"..i]:setVisible(true)
                if i == 1 then
                    self:update()
                    local toast = qy.tank.widget.Attribute.new({
                        ["numType"] = 3,
                        ["picType"] = 2,
                        ["value"] = val,
                        ["hasMark"] = 1,
                        ["anchorPoint"] = cc.p(0.5, 0.5)
                    })
                    local _pos = self.dice_2:getParent():convertToWorldSpace(cc.p(self.dice_2:getPositionX(),self.dice_2:getPositionY()+60))
                    qy.hint:showImageToast(toast, nil,nil,_pos,3)
                end
            end
        end)
        self.effertArr[i]:getAnimation():playWithIndex(0)
    end
end

function DiceView:onEnter()
    if not tolua.cast(self.list,"cc.Node") then
        self.list = self:createList()
        self.list:setPosition(0,48)
        self.img_left:addChild(self.list)
    end
    self:update()

    local award = self.model:getDiceAward()
    for i = 1, 2 do
        self["reward_tip_"..i]:setString(qy.TextUtil:substitute(51012, award[i].score))
        self["reward_"..i]:setString(award[i].num)
    end
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileByModules("legion/fx/ui_fx_shaizi")
end

function DiceView:onExit()
    qy.tank.utils.cache.CachePoolUtil.removeArmatureFileByModules("legion/fx/ui_fx_shaizi")
end

return DiceView
