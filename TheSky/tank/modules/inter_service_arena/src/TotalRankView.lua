local TotalRankView = qy.class("TotalRankView", qy.tank.view.BaseView, "inter_service_arena.ui.TotalRankView")


function TotalRankView:ctor(delegate)
   	TotalRankView.super.ctor(self)

    self.model = qy.tank.model.InterServiceArenaModel
    self.service = qy.tank.service.InterServiceArenaService

    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "Resources/activity/title_inter_service_arena.png", 
        showHome = false,
        ["onExit"] = function()
            if delegate and delegate.dismiss then
                delegate.dismiss()
            end
        end
    })
    self:addChild(style)

    self.data = delegate.data
    self.rank_list = self.data.list
    self.user_info = self.data.userinfo
    self.page_num = 1
    self.flag = true

    self:InjectView("bg")
    self:InjectView("table_bg")
    self:InjectView("Img_stage")
    self:InjectView("Img_stage_num")

    self:InjectView("Text_rank")

    self.table_bg:addChild(self:createTable())


    local icon, num = self.model:getStageIcon()
    self.Img_stage:loadTexture("inter_service_arena/res/stage_name2_".. icon ..".png",0)
    if num and num > 0 then
        self.Img_stage_num:loadTexture("inter_service_arena/res/stage_num2_".. num ..".png",0)
    end

    self.Text_rank:setString(qy.TextUtil:substitute(4003, self.model.stage_rank))


end


function TotalRankView:update()
    self:tableViewUpdate()
end



function TotalRankView:createTable()
    local tableView = cc.TableView:create(cc.size(940, 360))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    -- tableView:setSwallowTouches(false)
    tableView:setPosition(5, 5)
    tableView:setDelegate()

    local function numberOfCellsInTableView(tableView)
        return #self.rank_list
    end

    local function cellSizeForTable(tableView,idx)
        return 920, 150
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("inter_service_arena.src.TotalRankCell").new(self)
            cell:addChild(item)
            cell.item = item
        end

        cell.item:render(self.rank_list[idx+1], idx+1)
        cell.item.entity = self.rank_list[idx+1]
        cell.item.idx = idx + 1

        if idx+1 == #self.rank_list and self.flag then
            print(self.tableView:getContentOffset().y)
            self.page_num = self.page_num + 1
            self.service:getRankList(function(data)

                table.insertto(self.rank_list, data.list)

                if #data.list < self.model.rank_list_page_size then
                    self.flag = false
                end

                local y = self.tableView:getContentOffset().y
                y = y - #data.list * 150

                self.tableView:reloadData()
                self.tableView:setContentOffset(cc.p(0, y))

            end, self.page_num, self.model.rank_list_page_size)
        end


        return cell
    end

    local function tableAtTouched(table, cell)
        if cell.item.entity then
            local kid = 0
            if cell.item.entity.server == "syouke" then
                kid = cell.item.entity.ai_kid or 0
            else
                kid = cell.item.entity.kid or 0
                if kid ~= qy.tank.model.UserInfoModel.userInfoEntity and kid ~= 0 then
                    qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXAMINE_AI,cell.item.entity.kid, 2)
                end
            end
         
        end
    end


    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableAtTouched,cc.TABLECELL_TOUCHED)

    tableView:reloadData()

    self.tableView = tableView

    return tableView
end




return TotalRankView
