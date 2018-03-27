local AutoFightDialog = qy.class("AutoFightDialog", qy.tank.view.BaseDialog, "singlehero.ui.AutoFightDialog")


local model = qy.tank.model.SingleHeroModel
local service = qy.tank.service.SingleHeroService
function AutoFightDialog:ctor(data)
   	AutoFightDialog.super.ctor(self)

    self:InjectView("Node")

      --通用弹窗样式
    local style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(540, 435),
        position = cc.p(0, 0),
        offset = cc.p(0, 0),
        bgShow = false,
        titleUrl = "Resources/common/title/saodang.png",

        ["onClose"] = function()
            self:removeSelf()
        end
    })

    self:addChild(style)


    self:OnClick("Btn_close", function()
        self:dismiss()
    end,{["isScale"] = false})


    self.awardList = data.list
    print(#data.list)
    self.tableMax = #data.list
    self.isCellFightEnd = false  -- 独立的cell动画是否完成
    self.isAutoFightEnd = false
    if self.fightTableView~=nil then
      self.Node:removeChild( self.fightTableView )
      self.fightTableView = nil
    end
    
    self:runAutoFight()


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

                performWithDelay(self, function()
                    self.fightTableView:setTouchEnabled(true)
                end, 0.5)
                
                self.effect = ccs.Armature:create("ui_fx_saodang") 
                self.fightTableView:addChild(self.effect,999)
                self.effect:setPosition(220, -80)
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
        self.Node:addChild(self.fightTableView)
    end
    self.callBackFunc(0)
    
end

function AutoFightDialog:createTableView(idx)
    tableView = cc.TableView:create(cc.size(490,300))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setAnchorPoint(0,0)
    tableView:setPosition(5, 2)
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
        return 490, 149
    end

    local function tableCellAtIndex(table, idx)
        local strValue = string.format("%d",idx)
        local cell = table:dequeueCell()
        local item,label,status
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("singlehero.src.AutoFightItem").new( self.callBackFunc, idx)
            cell:addChild(item)
            cell.item = item

            status = cc.Label:createWithSystemFont("", "Helvetica", 24.0)
            status:setTextColor(cc.c4b(255,255,0,255))
            status:setPosition(125,47)
            status:setAnchorPoint(0.5,0.5)
            cell:addChild(status)
            cell.status = status
        end
        if self.isCellFightEnd == true then
            cell.item:update(idx)
        end
        print(idx + 1)
        cell.item:setData(self.awardList[idx+1])
       
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()
    return tableView
end


return AutoFightDialog
