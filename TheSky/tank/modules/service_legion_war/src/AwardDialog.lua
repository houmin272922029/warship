--[[
	跨服军团战
	Author: 
]]

local AwardDialog = qy.class("AwardDialog", qy.tank.view.BaseDialog, "service_legion_war/ui/AwardDialog")

local userModel = qy.tank.model.UserInfoModel
local service = qy.tank.service.ServiceLegionWarService
local model = qy.tank.model.ServiceLegionWarModel

function AwardDialog:ctor(delegate)
    AwardDialog.super.ctor(self)

    self.delegate = delegate
    local style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(1020,600),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "service_legion_war/res/jiangli.png",--

        ["onClose"] = function()
            delegate:callback()
            self:dismiss()
        end
    })
    style:setPositionY(-20)
    self:addChild(style,-10)
    self:InjectView("titleimg")
    self:InjectView("awardlist")--容器 
    self:InjectView("list1")
    self:InjectView("text")
    self:InjectView("zhanjinum")
    self:InjectView("list2")
    self:InjectView("list2award")
    self:InjectView("lingquBt")
    self:InjectView("yilingqu")
    self:InjectView("shuoming")
    self.data = {}
    self.tab = qy.tank.widget.TabButtonGroup.new("widget/TabButton4",{"个人日排名奖励", "个人周排名奖励","个人周战绩奖励","军团周排名奖励","军团周战绩奖励"},cc.size(185,67),"h",function(idx)
        self:createContent(idx)
    end, 1)
    self:addChild(self.tab)
    self.tab:setPosition(qy.winSize.width/2-485,qy.winSize.height-196)
    self.tab:setLocalZOrder(4)
    self.touchBt = 1
    self:OnClick("lingquBt",function()
        -- if self.butflag == 0 then
        --     qy.hint:show("未到领奖时间")
        -- else
            service:drawAward1(self.touchBt,function (  )
                self.yilingqu:setVisible(true)
                self.lingquBt:setVisible(false)
            end)
        -- end
   
        
    end)
end

function AwardDialog:createContent(_idx)
    self.touchBt  = _idx
    self.butflag = 0 --领取按钮的状态  0 代表能未领取 1代表已经领取  
    local png = "service_legion_war/res/title".._idx..".png"
    self.titleimg:loadTexture(png,1)
    self:updateBelow(_idx)
    self.awardlist:removeAllChildren()
    self.list11 = self:createView(_idx)
    self.awardlist:addChild(self.list11)
end
function AwardDialog:updateBelow( _idx )
    if _idx == 1 then
        self.shuoming:setString("每次驻防期都可领取上次进攻奖励")
        self.list1:setVisible(false)
        self.data = model.personnal_day_award
        if model.my_day_rank == 0 then
            self.list2:setVisible(false)
        else
            self.list2:setVisible(true)
            self.list2award:removeAllChildren()
            local award = self.data[tostring(model.my_day_rank)].award
            for i=1,#award do
              local item = qy.tank.view.common.AwardItem.createAwardView(award[i] ,1)
              self.list2award:addChild(item)
              item:setPosition(55+ 100*(i - 1), 55)
              item:setScale(0.8)
              item.name:setVisible(false)
            end
            self.butflag = model.day_award
        end
    elseif _idx == 2 then
        self.list1:setVisible(false)
        self.shuoming:setString("周日领取")
        self.data = model.personnal_week_award
        if model.my_week_rank == 0 then
            self.list2:setVisible(false)
        else
            self.list2:setVisible(true)
            self.list2award:removeAllChildren()
            local award = self.data[tostring(model.my_week_rank)].award
            for i=1,#award do
              local item = qy.tank.view.common.AwardItem.createAwardView(award[i] ,1)
              self.list2award:addChild(item)
              item:setPosition(55+ 100*(i - 1), 55)
              item:setScale(0.8)
              item.name:setVisible(false)
            end
            self.butflag = model.week_award
        end
    elseif _idx == 3 then
        self.shuoming:setString("")
        self.list1:setVisible(true)
        self.list2:setVisible(false)
        self.text:setString("当前战绩:")
        self.zhanjinum:setString(model.personal_record)
        self.data = model.personnal_achieve_award
    elseif _idx == 4 then
        self.shuoming:setString("周日领取")
        self.list1:setVisible(false)
        self.data = model.legion_week_award
         if model.my_legion_week_rank == 0 then
            self.list2:setVisible(false)
        else
            self.list2:setVisible(true)
            self.list2award:removeAllChildren()
            local award = self.data[tostring(model.my_legion_week_rank)].award
            for i=1,#award do
              local item = qy.tank.view.common.AwardItem.createAwardView(award[i] ,1)
              self.list2award:addChild(item)
              item:setPosition(55+ 100*(i - 1), 55)
              item:setScale(0.8)
              item.name:setVisible(false)
            end
            self.butflag = model.legion_award
        end
    elseif _idx == 5 then
        self.shuoming:setString("")
        self.list1:setVisible(true)
        self.list2:setVisible(false)
        self.text:setString("当前军团战绩:")
        self.zhanjinum:setString(model.legion_record)
        self.data = model.legion_achieve_award
    end
    if self.butflag == 0 then
        self.yilingqu:setVisible(false)
        self.lingquBt:setVisible(true)
    else
        self.yilingqu:setVisible(true)
        self.lingquBt:setVisible(false)
    end
end
function AwardDialog:createView(awardtype)
    local tableView = cc.TableView:create(cc.size(940, 265))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(0, 15)
    tableView:setDelegate()
    local num = table.nums(self.data)
    local function numberOfCellsInTableView(tableView)
        return num
    end

    local function tableCellTouched(table, cell)
       
    end
    
    local function cellSizeForTable(tableView, idx)
        return 955, 110
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            if awardtype == 3 or awardtype == 5 then
                item = require("service_legion_war.src.AwardCell1").new({
                    ["type"] = awardtype,
                    ["data"] = self.data,
                    ["callback"] = function (  )
                        local listCury = self.list11:getContentOffset()
                        self.list11:reloadData()
                        self.list11:setContentOffset(listCury)--设置滚动距离
                    end
                })
            else
                item = require("service_legion_war.src.AwardCell").new({
                    ["type"] = awardtype,
                    ["data"] = self.data
                })
            end
            
            cell:addChild(item)
            cell.item = item
        end
        cell.item.idx = idx
        cell.item:render(idx+1)
        return cell
    end
    tableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)

    tableView:reloadData()
    return tableView
end
function AwardDialog:onEnter()
  
end

function AwardDialog:onExit()
    
end

return AwardDialog
