--[[
	跨服军团战
	Author: 
]]

local MainView = qy.class("MainView", qy.tank.view.BaseView, "service_legion_war/ui/MainView")

local userModel = qy.tank.model.UserInfoModel
local service = qy.tank.service.ServiceLegionWarService
local model = qy.tank.model.ServiceLegionWarModel

function MainView:ctor(delegate)
    MainView.super.ctor(self)
    self.delegate = delegate
    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "service_legion_war/res/legoin_war.png",
        ["onExit"] = function()
            delegate:finish()
        end
    })
    self:addChild(style, 13)
    self:InjectView("helpBt")
    self:OnClick("helpBt",function()
        qy.tank.view.common.HelpDialog.new(45):show(true)
    end)
    self:InjectView("pannel1")
    self:InjectView("baomingimg")
    self:InjectView("titleimg")
    self:InjectView("time")
    self:InjectView("timetitle")
    self:InjectView("xiuzhantext")
    for i = 1, 3 do
        self:InjectView("Bt"..i)
    end
    self:OnClick("Bt1",function()
        if model.is_enter == 0 then
            qy.hint:show("军团尚未报名")
            return
        end
        if model.status == 4 then
            service:enterfight(function (  )
                local item = require("service_legion_war.src.AttackMainView").new()
                item:show()
            end)
        else
            qy.hint:show("未到进攻时间")
        end
        
    end)
    self:OnClick("Bt2",function()
        if model.is_enter == 0 then
            qy.hint:show("军团尚未报名")
            return
        end
        if model.status == 2 or model.status == 5 or model.status == 4 then
            local item = require("service_legion_war.src.DefenceMainView").new({
                ["type"] = 2,
                ["legionname"] = model.legionname
                })
            item:show()
        else
            qy.hint:show("未到调整布防时间")
        end
     
    end)
    self:OnClick("Bt3",function()
        if model.is_enter == 1 then
            qy.hint:show("军团已经报名")
            return
        end
        if model.legionlevel <= 10 then
             qy.hint:show("军团等级10级以上可参加跨服军团战")
             return
        end
        if model.is_auth == 0 then
            qy.hint:show("您无报名权限,军团军团司令，副司令，参谋长可进行报名。")
            return
        end
        if model.status == 2 then
            service:enter(function (  )
                qy.hint:show("报名成功")
                self:uptate()
            end)
        else
            qy.hint:show("未到时间或者报名时间已过")
        end
    end)
    self:InjectView("pannel2")
    self:InjectView("zhanbaolist")
    self:InjectView("wuzhanbao")

    self:InjectView("pannel3")
    self:InjectView("leginlist")--军团排行
    self:InjectView("peoplelist")--个人排行
    self:InjectView("zanwu1")
    self:InjectView("zanwu2")
    
    self.flag = true
    self:OnClick("helpBt",function()
        qy.tank.view.common.HelpDialog.new(45):show(true)
    end)
    self.tab = qy.tank.widget.TabButtonGroup.new("widget/TabButton2",{"征战", "进攻战报","防守战报","日排行","周排行","奖励"},cc.size(160,67),"h",function(idx)
        self:createContent(idx)
    end, 1)

    self:addChild(self.tab)
    self.tab:setPosition(qy.winSize.width/2-475,qy.winSize.height-135)
    self.tab:setLocalZOrder(4)
    
    self.image1 = ccui.ImageView:create()--红点
    self.image1:loadTexture("Resources/common/icon/icon_hd.png",1)
    self.image1:setPosition(cc.p(942,50))
    self.tab:addChild(self.image1,22)
    self:uptatehongdian()
    self:uptate()
end
function MainView:uptatehongdian(  )
    -- print("红点信息"..qy.tank.model.RedDotModel.interservice_legionbattle)
    if qy.tank.model.RedDotModel.interservice_legionbattle == 0 then
        self.image1:setVisible(false)
         -- print("没有红点")
    else
        self.image1:setVisible(true)
        -- print("有红点")
    end
end
function MainView:uptate(  )
    if model.is_auth == 1 then
        self.Bt3:setBright(true)
        self.Bt3:setEnabled(true)
    else
        self.Bt3:setBright(false)
        self.Bt3:setEnabled(false)
    end
    if model.is_enter == 0 then
        self.baomingimg:setVisible(true)
        self.time:setVisible(false)
        self.timetitle:setVisible(false)
        self.titleimg:setVisible(false)
        self.xiuzhantext:setVisible(false)
    else
        self.baomingimg:setVisible(false)
        self.time:setVisible(true)
        self.timetitle:setVisible(true)
        self.titleimg:setVisible(true)
        self.xiuzhantext:setVisible(false)
        if model.status == 1 then
            self.titleimg:setVisible(false)
            self.timetitle:setString("距开始报名时间:")
        elseif model.status == 2 then
            self.titleimg:loadTexture("service_legion_war/res/zhufangjieduan.png",1)
            self.timetitle:setString("距进攻准备时间:")
        elseif model.status == 3 then
            self.titleimg:loadTexture("service_legion_war/res/qq2.png",1)
            self.timetitle:setString("距开始进攻时间:")
        elseif model.status == 4 then
            self.titleimg:loadTexture("service_legion_war/res/jingongjieduan.png",1)
            self.timetitle:setString("进攻剩余时间:")
        elseif model.status == 5 then
            self.titleimg:loadTexture("service_legion_war/res/zhufangjieduan.png",1)
            self.timetitle:setString("距进攻准备时间:")
        elseif model.status == 6 then
            self.titleimg:loadTexture("service_legion_war/res/qq1.png",1)
            self.timetitle:setString("")
            self.time:setVisible(false)
            self.xiuzhantext:setVisible(true)
        end
    end
end

function MainView:createContent(_idx)
    if _idx ~= 1 then
        if model.is_enter == 0 then
            qy.hint:show("军团尚未报名")
            self.tab:switchTo(1)
            return
        end
    end
    if _idx == 1 then
        self.pannel1:setVisible(true)
        self.pannel2:setVisible(false)
        self.pannel3:setVisible(false)
    elseif _idx == 2 then
        self.page_num = 1
        self.zhanbaolist:removeAllChildren()
        service:getReport(1,1,function ( data )
            self.newslist = data.list.list
            self.zhanbao = self:createView(1)
            self.zhanbaolist:addChild(self.zhanbao)
            self.pannel1:setVisible(false)
            self.pannel2:setVisible(true)
            self.pannel3:setVisible(false)
        end)
     
    elseif _idx == 3 then
        self.page_num = 1
        self.zhanbaolist:removeAllChildren()
        service:getReport(2,1,function ( data )
            self.newslist = data.list.list
            self.zhanbao = self:createView(2)
            self.zhanbaolist:addChild(self.zhanbao)
            self.pannel1:setVisible(false)
            self.pannel2:setVisible(true)
            self.pannel3:setVisible(false)
        end)
    elseif _idx == 4 then
        service:getRank(function (  )
            self.leginlist:removeAllChildren()
            self.peoplelist:removeAllChildren()
            self.leginrank = self:createleginView(1)
            self.leginlist:addChild(self.leginrank)
            self.personlist = self:createpersonView(1)
            self.peoplelist:addChild(self.personlist)
            self.pannel1:setVisible(false)
            self.pannel2:setVisible(false)
            self.pannel3:setVisible(true)
        end)
    elseif _idx == 5 then
        service:getRank(function (  )
            self.leginlist:removeAllChildren()
            self.peoplelist:removeAllChildren()
            self.leginrank = self:createleginView(2)
            self.leginlist:addChild(self.leginrank)
            self.personlist = self:createpersonView(2)
            self.peoplelist:addChild(self.personlist)
            self.pannel1:setVisible(false)
            self.pannel2:setVisible(false)
            self.pannel3:setVisible(true)
        end)
    elseif _idx == 6 then
        service:getRank(function (  )
            local item = require("service_legion_war.src.AwardDialog").new({
                ["callback"] = function (  )
                    self.tab:switchTo(1)
                    self:createContent(1)
                    self:uptatehongdian()
                end
                })
            item:show()
        end)
    end
end
function MainView:createleginView(_type)
    local tableView = cc.TableView:create(cc.size(420, 380))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(0, 30)
    tableView:setDelegate()
    local data = {}
    if _type == 1 then
        data = model.legion_day_rank
    else
        data = model.legion_week_rank
    end
    if #data == 0 then
        self.zanwu1:setVisible(true)
    else
        self.zanwu1:setVisible(false)
    end
    local function numberOfCellsInTableView(tableView)
        return #data
    end

    local function tableCellTouched(table, cell)
       
    end
    
    local function cellSizeForTable(tableView, idx)
        return 410, 55
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("service_legion_war.src.LeginList").new({
                ["data"] = data
                })
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
function MainView:createpersonView(_type)--1代表日 2代表周
    local tableView = cc.TableView:create(cc.size(520, 350))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(10, 25)
    tableView:setDelegate()
    local data = {}
    if _type == 1 then
        data = model.personal_day_rank
    else
        data = model.personal_week_rank
    end
    if #data == 0 then
        self.zanwu2:setVisible(true)
    else
        self.zanwu2:setVisible(false)
    end
    local function numberOfCellsInTableView(tableView)
        return #data
    end

    local function tableCellTouched(table, cell)
       
    end
    
    local function cellSizeForTable(tableView, idx)
        return 510, 85
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("service_legion_war.src.PersonCell").new({
                ["data"] = data
                })
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
function MainView:createView(_type)
    local tableView = cc.TableView:create(cc.size(950, 480))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(0, 0)
    tableView:setDelegate()
    if #self.newslist== 0 then
        self.wuzhanbao:setVisible(true)
    else
        self.wuzhanbao:setVisible(false)
    end
    local function numberOfCellsInTableView(tableView)
        return #self.newslist
    end

    local function tableCellTouched(table, cell)
       
    end
    
    local function cellSizeForTable(tableView, idx)
        return 940, 125
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("service_legion_war.src.NewsCell").new({
                ["type"] = _type,
                ["data"] = self.newslist,
                })
            cell:addChild(item)
            cell.item = item
        end
        cell.item.idx = idx
        cell.item:render(idx+1)
        if idx+1 == #self.newslist and self.flag  and #self.newslist >= 10 then
            self.page_num = self.page_num + 1
            service:getReport(_type, self.page_num,function(data)
                table.insertto(self.newslist, data.list.list)

                if #data.list.list < 10 then
                    self.flag = false
                end

                local y = self.tableView:getContentOffset().y
                y = y - #data.list.list * 125

                self.tableView:reloadData()
                self.tableView:setContentOffset(cc.p(0, y))

            end)
        end
        return cell
    end
    tableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)

    tableView:reloadData()
    self.tableView = tableView
    return tableView
end

function MainView:onEnter()
    self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(model.end_time - qy.tank.model.UserInfoModel.serverTime, 8))
    self.listener_1 = qy.Event.add(qy.Event.BONUS_TIME,function(event)
        self:uptatehongdian()
        self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(model.end_time - qy.tank.model.UserInfoModel.serverTime, 8))
        if model.end_time - qy.tank.model.UserInfoModel.serverTime <= 0 then
            self.time:setString("0")
        end
    end)
end

function MainView:onExit()
    qy.Event.remove(self.listener_1)
end

return MainView
