--[[
	军团内部排行榜
	Author: H.X.Sun
]]

local PostRankList = qy.class("PostRankList", qy.tank.view.BaseView, "legion/ui/basic/PostRankList")

function PostRankList:ctor(delegate)
    PostRankList.super.ctor(self)
    self:InjectView("rank_id")
    self:InjectView("rank_num")
    self:InjectView("op_legion_txt")
    self:InjectView("up_btn")

    self.model = qy.tank.model.LegionModel
    self.selectIdx = 0
    self.delegate = delegate
    local service = qy.tank.service.LegionService

    self:OnClick("up_btn",function()
        if not self.model:getCommanderEntity():isCanPk() then
            qy.hint:show(self.model:canNotPkPostDes())
            return
        end

        qy.tank.view.legion.basic.TipsDialog.new({
            ["type"] = self.model.TIPS_UP,
            ["post"] = self.model:getCommanderEntity():getNextPostName(),
            ["callback"] = function()
                service:postPk(function(data)
                    if data.fight_result then
                        qy.tank.manager.ScenesManager:pushBattleScene()
                    else
                        qy.hint:show(qy.TextUtil:substitute(50056))
                    end
                    self:update()
                    self.delegate.updatePost()
                end)
            end
        }):show(true)
    end)

    self:OnClick("op_legion_btn",function()
        if self.model:getCommanderEntity().user_score == 1 then
            qy.tank.view.legion.basic.TipsDialog.new({
                ["type"] = self.model.TIPS_OP,
                ["entity"] = self.model:getHisLegion(),
            }):show(true)
        else
            qy.tank.view.legion.basic.TipsDialog.new({
                ["type"] = self.model.TIPS_LEAVE,
                ["entity"] = self.model:getHisLegion(),
                -- ["callback"] = function()
                --     service:leave(function()
                --         qy.hint:show("退出成功")
                --         delegate.onExit()
                --     end)
                -- end
            }):show(true)
            -- local msg = {
            --     {id=1,color={255,255,255},alpha=255,text = "\n确定退出",font=qy.res.FONT_NAME_2,size=24},
            --     {id=2,color={251,253,84},alpha=255,text = self.model:getHisLegion().name,font=qy.res.FONT_NAME_2,size=24},
            --     {id=3,color={255,255,255},alpha=255,text = "军团？这里的战友舍不得你",font=qy.res.FONT_NAME_2,size=24},
            -- }
            -- qy.alert:show({"退出军团" ,{255,255,255} }  ,  msg , cc.size(550 , 260),{{"确认" , 5}} ,
            -- function()
            --     service:leave(function()
            --         qy.hint:show("退出成功")
            --         delegate.onExit()
            --     end)
            -- end,"")
        end
    end)
end

function PostRankList:createList()
    local tableView = cc.TableView:create(cc.size(739,436))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setDelegate()

    local function numberOfCellsInTableView(table)
        return self.model:getMemberNum()
    end

    local function tableCellTouched(table,cell)
        if self.selectIdx ~= cell:getIdx() then
            if tableView:cellAtIndex(self.selectIdx) then
                tableView:cellAtIndex(self.selectIdx).item:removeSelected()
            end
            cell.item:setSelected()
            self.selectIdx = cell:getIdx()
        end
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXAMINE,self.model:getMemberEntityByIndex(self.selectIdx + 1).kid)
    end

    local function cellSizeForTable(tableView, idx)
        return 730, 133
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.legion.basic.PostCell.new({
                ["updateJob"] = function()
                    self.delegate.updatePost()
                    self:update()
                    self:updateBtnStatus()
                end
            })
            cell:addChild(item)
            cell.item = item
        end
        cell.item:render(self.model:getMemberEntityByIndex(idx + 1))
        if idx == self.selectIdx then
            cell.item:setSelected()
        else
            cell.item:removeSelected()
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

function PostRankList:updateRankInfo()
    local entity = self.model:getHisLegion()
    self.rank_id:setString(self.model:getCommanderEntity().legion_id)
    if tonumber(entity.rank) and tonumber(entity.rank) > 0 then
        self.rank_num:setString(entity.rank)
    else
        self.rank_num:setString(qy.TextUtil:substitute(50057))
    end
    self.delegate.updatePost()
end

function PostRankList:updateList()
    if self.rankList ~= nil then
        local listCurY = self.rankList:getContentOffset().y
        self.rankList:reloadData()
        self.rankList:setContentOffset(cc.p(0,listCurY))
    end
end

function PostRankList:updateBtnStatus()
    if self.model:getCommanderEntity().user_score == 1 then
        self.op_legion_txt:setSpriteFrame("legion/res/basic/jiesanjuntuan.png")
    else
        self.op_legion_txt:setSpriteFrame("legion/res/basic/tuichujuntuan.png")
    end
    if self.model:getCommanderEntity():canAudit() then
        self.up_btn:setVisible(false)
    else
        self.up_btn:setVisible(true)
    end
end

function PostRankList:update()
    self.selectIdx = 0
    self.rankList:reloadData()
end

function PostRankList:delayToShowTips(_tips)
    self.timer = qy.tank.utils.Timer.new(0.3,1,function()
        qy.hint:show(_tips)
    end)
    self.timer:start()
end

function PostRankList:onEnter()
    print("PostRankList:onEnter PostRankList:onEnter PostRankList:onEnter PostRankList:onEnter")
    self:updateBtnStatus()
    self:updateRankInfo()
    if not tolua.cast(self.rankList,"cc.Node") then
        self.rankList = self:createList()
        self:addChild(self.rankList)
        self.rankList:setPosition(5,7)
    end

    if self.model:getPostPkStatus() == self.model.POST_PK_LOSE then
        self:delayToShowTips(qy.TextUtil:substitute(50058))
    elseif self.model:getPostPkStatus() == self.model.POST_PK_WIN then
        self:delayToShowTips(qy.TextUtil:substitute(50059))
    end

    self.model:setPostPkStatus(-1)
end

return PostRankList
