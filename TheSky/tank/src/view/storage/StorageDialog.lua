--[[
    仓库弹框
    Author: Aaron Wei
    Date: 2015-04-15 16:28:15
]]

local StorageDialog = qy.class("StorageDialog", qy.tank.view.BaseDialog, "view/storage/StorageDialog")

function StorageDialog:ctor(delegate)
    StorageDialog.super.ctor(self)

    -- 通用弹窗样式
    local style = qy.tank.view.style.DialogStyle2.new({
        size = cc.size(870,580),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "Resources/common/title/storage.png",

        ["onClose"] = function()
            self:dismiss()
        end
    })
    self:addChild(style)

    -- 内容样式
    self.delegate = delegate
    self.model = qy.tank.model.StorageModel

    self.tab_host = qy.tank.widget.TabHost.new({
        delegate = self,
        csd = "widget/TabButton1",
        tabs = {qy.TextUtil:substitute(32011), qy.TextUtil:substitute(32012), qy.TextUtil:substitute(32013), qy.TextUtil:substitute(32014)},
        size = cc.size(185,70),
        layout = "h",
        idx = 1,

        ["onCreate"] = function(tabHost, idx)
            return self:createContent(idx)
        end,

        ["onTabChange"] = function(tabHost, idx)
            tabHost.views[idx]:reloadData()
        end
    })
    self:InjectView("panel")
    self.panel:setLocalZOrder(1)
    self.panel:setSwallowTouches(false)
    self.panel:addChild(self.tab_host)
    self.tab_host:setPosition(130,535)
end

function StorageDialog:createContent(_idx)
    -- local layer = cc.LayerColor:create(cc.c4b(0,255,255,100),625,380)

    local tableView = cc.TableView:create(cc.size(900,430))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(-5,-445)
    -- self.panel:addChild(tableView)
    -- tableView:addChild(layer)
    tableView:setDelegate()

    local function numberOfCellsInTableView(table)
        if _idx == 1 then
            return #self.model.totalList
        elseif _idx == 2 then
            return #self.model.chestList
        elseif _idx == 3 then
            return #self.model.materialList
        elseif _idx == 4 then
            return #self.model.propsList
        end
    end

    local function tableCellTouched(table,cell)
        print("cell touched at index: " .. cell:getIdx())
    end

    local function cellSizeForTable(tableView, idx)
        return 825, 150
    end

    local function tableCellAtIndex(table, idx)
        local strValue = string.format("%d",idx)
        local cell = table:dequeueCell()
        local item = nil
        local label = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.storage.StorageCell.new({
                ["onUse"] = function(entity)
                    if entity.id == "3" then
                        local service = qy.tank.service.StorageService
                        service:use("3",1,function(data)
                            service = nil
                            qy.tank.command.MainCommand:viewRedirectByModuleType("extractionCard")
                            self:dismiss()
                        end)
                    elseif entity.id == "10" then
                        -- local service = qy.tank.service.StorageService
                        -- service:use("10",1,function(data)
                        --     service = nil
                        --     qy.tank.command.MainCommand:viewRedirectByModuleType("extractionCard")
                        --     self:dismiss()
                        -- end)
                        qy.tank.command.MainCommand:viewRedirectByModuleType("extractionCard")
                        self:dismiss()
                    elseif entity.id == "51" then
                        local passenger = {["idx1"] = 2, ["idx2"] = 1}
                        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.PASSENGER, passenger)
                        self:dismiss()
                    elseif entity.id == "68" or entity.id == "69" or entity.id == "70" or entity.id == "71" then
                        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.MILITARY_RANK)
                        self:dismiss()
                    elseif entity.id == "11" then
                        local service = qy.tank.service.StorageService
                        service:use("3",1,function(data)
                            service = nil
                            qy.tank.command.MainCommand:viewRedirectByModuleType("training")
                            self:dismiss()
                        end)
                    --elseif entity.id == "88" or entity.id == "93" then
                    elseif #entity.award > 0 then
                        local useDialog = qy.tank.view.storage.ChoiceAwardDialog.new(entity,function(_id,_num, select_id)
                            local service = qy.tank.service.StorageService
                            service:use2(_id,_num,select_id,function(data)
                                service = nil
                                tableView:reloadData()
                            end)
                        end)
                        useDialog:show(true)

                    else
                        -- 正常选择数量使用
                        local useDialog = qy.tank.view.storage.PropUseDialog.new(entity,function(_id,_num)
                            local service = qy.tank.service.StorageService
                            service:use(_id,_num,function(data)
                                service = nil
                                tableView:reloadData()
                            end)
                        end)
                        useDialog:show(true)
                    end
                end,

                ["onSell"] = function(entity)
                    local sellDialog = qy.tank.view.storage.PropSaleDialog.new(entity,function(_id,_num)
                        local service = qy.tank.service.StorageService
                        service:sell(_id,_num,function(data)
                            qy.QYPlaySound.playEffect(qy.SoundType.SALE)
                            service = nil
                            tableView:reloadData()
                        end)
                    end)
                    sellDialog:show(true)
                end,
                ["dismiss"] = function()
                    self:dismiss()
                end
            })
            cell:addChild(item)
            cell.item = item
            -- label = cc.Label:createWithSystemFont(strValue, "Helvetica", 20.0)
            -- label:setPosition(0,0)
            -- label:setAnchorPoint(0,0)
            -- cell:addChild(label)
            -- cell.label = label
        end

        if _idx == 1 then
            cell.item:render(self.model.totalList[idx+1])
        elseif _idx == 2 then
            cell.item:render(self.model.chestList[idx+1])
        elseif _idx == 3 then
            cell.item:render(self.model.materialList[idx+1])
        elseif _idx == 4 then
            cell.item:render(self.model.propsList[idx+1])
        end
        -- cell.label:setString(strValue)
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)

    tableView:reloadData()

    return tableView
end


return StorageDialog
