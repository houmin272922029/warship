--[[
--分解
--Author: mingming
--Date:
]]

local ResolveView = qy.class("ResolveView", qy.tank.view.BaseView, "view/resolve/ResolveView")

local model = qy.tank.model.ResolveModel

function ResolveView:ctor(delegate)
    ResolveView.super.ctor(self)

    self:InjectView("Panel")
    self:InjectView("Btn_tank")
    self:InjectView("Btn_equip")
    self:InjectView("closeBtn")
    self:InjectView("Num")
    self:InjectView("info")

    self:addChild(qy.tank.view.style.ViewStyle1.new({
            ["onExit"] = function()
                delegate.dismiss()
            end,
            ["titleUrl"] = "Resources/common/title/fenjie.png",
        }))
    
    self.delegate = delegate
    self.idx = 1

    -- self.closeBtn:setLocalZOrder(20)
 	-- self:OnClick("closeBtn", function()
  --       --qy.QYPlaySound.stopMusic()
  --       delegate.dismiss()
  --   end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self:OnClick("Btn_tank", function()
        --qy.QYPlaySound.stopMusic()
        self:switch(1)
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self:OnClick("Btn_equip", function()
        --qy.QYPlaySound.stopMusic()
        self:switch(2)
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self:OnClick("Btn_verify", function()
        --qy.QYPlaySound.stopMusic()
        if table.nums(model.selectList) > 0 then
            delegate.showTips(self.idx, self)
            print("ResolveView,Btn_verify,self.idx",self.idx)
        else
            if self.idx == 1 then
                qy.hint:show(qy.TextUtil:substitute(28001))
            else
                qy.hint:show(qy.TextUtil:substitute(28002))
            end
            
        end
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self:OnClick("helpBtn", function()
        --qy.QYPlaySound.stopMusic()
        qy.tank.view.common.HelpDialog.new(self.idx == 1 and 8 or 9):show(true)
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self:OnClick("Btn_all", function()
        qy.QYPlaySound.stopMusic()
        -- delegate.selectAll(self.idx, function()
        --     self:update()
        --     self:reloadData()
        --     if table.nums(model.selectList) > 0 then
        --         if self.idx == 1 then
        --             qy.hint:show(qy.TextUtil:substitute(28003))--已勾选蓝色及一下品质战车
        --         else
        --             qy.hint:show(qy.TextUtil:substitute(28004))--已勾选蓝色及一下品质装备
        --         end
        --     end
            
        --     -- delegate.showTips(self.idx, self)
        -- end)
      
        if self.idx == 1 then
            require("view.resolve.ChoiseDialog").new(self.idx,delegate,self):show()
        else
            require("view.resolve.ChoiseDialog1").new(self.idx,delegate,self):show()
        end
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    

    self:createTableView()

    self.Btn_tank:setLocalZOrder(10)
    self.Btn_equip:setLocalZOrder(10)

    self:switch(self.idx)
    self:update()
end

function ResolveView:createTableView()
    local tableView = cc.TableView:create(cc.size(1080, 450))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(5, 10)
    self.Panel:addChild(tableView)

    local function numberOfCellsInTableView(tableView)
        return table.nums(model:getList(self.idx))
    end

    local function cellSizeForTable(tableView,idx)
        return 1040, 150
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.resolve.TankItem.new({
                ["selected"] = function(entity, sender)
                    if not tableView:isTouchMoved() then
                        self.delegate.selectItem(entity, self.idx, sender)
                        self:update()
                    end
                end
            })
            cell:addChild(item)
            cell.item = item
        end
        local entity = model:atTank(idx, self.idx)
        cell.item:setData(entity, self.idx, model:testSelect(entity))
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()

    self.tableView = tableView

    return tableView
end

function ResolveView:switch(idx)
    self.Btn_tank:setBright(idx ~= 1)
    self.Btn_equip:setBright(idx ~= 2)
    self.idx = idx
    self.tableView:reloadData()
    model:clearSelectList()
    self:update(idx)
end

function ResolveView:update()
    self.Num:setString(table.nums(model.selectList) .. " / " .. table.nums(model:getList(self.idx)))
    self.info:setString(self.idx == 1 and qy.TextUtil:substitute(28005) or qy.TextUtil:substitute(28006))
end

function ResolveView:reloadData()
    self.tableView:reloadData()
end

return ResolveView