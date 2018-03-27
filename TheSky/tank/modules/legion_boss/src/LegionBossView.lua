--[[
	世界boss
	Author: Aaron Wei
	Date: 2015-12-01 16:10:07
]]

local LegionBossView = qy.class("LegionBossView", qy.tank.view.BaseView, "legion_boss.ui.LegionBossView")

function LegionBossView:ctor(delegate) 
    LegionBossView.super.ctor(self)

    self.delegate = delegate
    self.model = qy.tank.model.LegionBossModel
    self.userInfo = qy.tank.model.UserInfoModel
    self.legionModel = qy.tank.model.LegionModel  

    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "legion_boss/res/jtboss_04.png",
        ["onExit"] = function()
            if delegate and delegate.dismiss then
                delegate.dismiss()
            end
        end
    })
    self:addChild(style)

    self:InjectView("panel")
    self:InjectView("topNode")
    self:InjectView("bottomNode")
    self:InjectView("rank")
    self:InjectView("my_rank")
    self:InjectView("my_hurt")
    self:InjectView("plusLabel")
    self:InjectView("cdLabel")
    self:InjectView("battleLabel")
    self:InjectView("resetLabel")
    self:InjectView("topNode")
    self:InjectView("bottomNode")
    self:InjectView("tipLabel")
    self:InjectView("hpBar")
    self:InjectView("progressLabel")
    self:InjectView("boss")
    self:InjectView("openTitle")
    self:InjectView("openTime")
    self:InjectView("endTitle")
    self:InjectView("endTime")
    self:InjectView("bossLevel")
    self:InjectView("boss_level")

    self:OnClick("awardReview", function(sender)
        local award = require("legion_boss.src.LegionBossAwardDialog").new()
        award:show(true)
    end,{["isScale"]=true})

    self:InjectView("diamondBtn")
    self:OnClick("diamondBtn", function(sender)
        local service = qy.tank.service.LegionBossService
        service:inspire(1,function(data)
            self:render()
            qy.hint:show(qy.TextUtil:substitute(80001))
        end)
    end,{["isScale"]=false})

    self:InjectView("coinBtn")
    self:OnClick("coinBtn", function(sender)
        local service = qy.tank.service.LegionBossService
        service:inspire(2,function(data)
            self:render()
            qy.hint:show(qy.TextUtil:substitute(80001))
        end)
    end,{["isScale"]=false})

    self:InjectView("battleBtn")
    self:OnClick("battleBtn", function(sender)
        local service = qy.tank.service.LegionBossService
        if self.alive then
            service:attack(function(data)
            end)
        else
            service:reset(function(data)
                self:render()
                self:updateTime()
            end)
        end
    end,{["isScale"]=false})

    self:OnClick("helpBtn", function(sender)
         qy.tank.view.common.HelpDialog.new(13):show(true)
    end,{["isScale"]=false})

    self:OnClick("addBtn",function(sender)
        if self.legionModel:getCommanderEntity():canAudit() then
            if self.model.boss_id < 6 then
                local id = self.model.boss_id + 1            
                local service = qy.tank.service.LegionBossService
                service:selectboss(id,function(data)
                    self:setBossLevel(self.model.boss_id)
                end)
            else
               qy.hint:show("军团BOSS已到最大等级")  
            end
        else
            qy.hint:show("权限不够，请联系军团管理人员调整难度")
        end

    end,{["isScale"]=true})

    self:OnClick("reduceBtn",function(sender)
        if self.legionModel:getCommanderEntity():canAudit() then
            if self.model.boss_id > 1 then
                local id = self.model.boss_id - 1
                local service = qy.tank.service.LegionBossService
                service:selectboss(id,function(data)
                    self:setBossLevel(self.model.boss_id)
                end)
            else
                qy.hint:show("军团BOSS已到最小等级")    
            end            
        else
            qy.hint:show("权限不够，请联系军团管理人员调整难度")
        end
    end,{["isScale"]=true})

    -- local layer = cc.LayerColor:create(cc.c4b(0,255,255,100),360,350)
    self.rankList = cc.TableView:create(cc.size(360,348))
    self.rankList:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.rankList:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.rankList:setPosition(15,100)
    self.rank:addChild(self.rankList)
    -- self.rankList:addChild(layer)
    self.rankList:setDelegate()

    local function numberOfCellsInTableView(table)
        return #self.model.list
    end

    local function tableCellTouched(table,cell)
        print("cell touched at index: " .. cell:getIdx())
    end

    local function cellSizeForTable(tableView, idx)
        return 360, 50
    end

    local function tableCellAtIndex(table, idx)
        local strValue = string.format("%d",idx)
        local cell = table:dequeueCell()
        local item,label,status
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("legion_boss.src.LegionBossCell").new()
            cell:addChild(item)
            cell.item = item
          end
        cell.item:render(self.model.list[idx+1])
        return cell
    end

    self.rankList:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    self.rankList:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    self.rankList:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    self.rankList:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    self.rankList:reloadData()

    self.px,self.py = self.topNode:getPosition()
end

function LegionBossView:render()
    self:setBossLevel(self.model.boss_id)

    if self.fighting then
        if self.model.left_blood ~= 0 then
            self.hpBar:setPercent(self.model.left_blood/10)
            self.progressLabel:setString(tostring(math.floor(self.model.left_blood/10)).."%")
        else
            self.hpBar:setPercent(1)
            self.progressLabel:setString("1%")
        end
    end
    if self.model.attack_plus then
        self.plusLabel:setString(qy.TextUtil:substitute(80002)..tostring(100+self.model.attack_plus*100).."%")
    end
    self.rankList:reloadData()
    self.my_rank:setString(tostring(self.model.my_rank))
    if math.log10(self.model.my_hurt) > 10 then  
        self.my_hurt:setString(tostring(math.floor(self.model.my_hurt/10^8)).."E")
    elseif math.log10(self.model.my_hurt) > 7 then
        self.my_hurt:setString(tostring(math.floor(self.model.my_hurt/10^4)).."W")
    else
        self.my_hurt:setString(tostring(self.model.my_hurt))
    end
end

function LegionBossView:updateTime()
    local serverTime = self.userInfo.serverTime
    -- 是否结束
    for i=1,#self.model.time do
        if serverTime >= self.model.time[i].start and serverTime <= self.model.time[i]["end"] then
            if self.model.left_blood == nil then
                -- 开战临界点刷新数据&界面
                local service = qy.tank.service.LegionBossService
                    service:get(function(data)
                        self:render()
                end)
            elseif self.model.left_blood <= 0 then 
                -- 已阵亡
                if self.fighting ~= false then 
                    self.fighting = false
                    self.topNode:setPosition(self.px,self.py)
                    self.bottomNode:setVisible(false)
                    self.tipLabel:setVisible(true)
                    self.openTitle:setVisible(true)
                    self.openTime:setVisible(true)
                    self.endTitle:setVisible(false)
                    self.endTime:setVisible(false)
                    self.boss_level:setVisible(false)
                end
            else
                -- 未阵亡
                if self.fighting ~= true then
                    self.fighting = true
                    self.topNode:setPosition(self.px,self.py)
                    self.bottomNode:setVisible(true)
                    self.tipLabel:setVisible(false)
                    self.openTitle:setVisible(false)
                    self.openTime:setVisible(false)
                    self.endTitle:setVisible(true)
                    self.endTime:setVisible(true)
                    self.boss_level:setVisible(false)
                end
                self:showRandomBuff()
            end
            break
        else
            if self.fighting ~= false then 
                self.fighting = false
                self.topNode:setPosition(self.px,self.py)
                self.bottomNode:setVisible(false)
                self.tipLabel:setVisible(true)
                self.openTitle:setVisible(true)
                self.openTime:setVisible(true)
                self.endTitle:setVisible(false)
                self.endTime:setVisible(false)
                self.boss_level:setVisible(true)
            end
        end
    end
        
    if self.fighting then
        -- 复活倒计时
        if self.model.cd then
            local cd = self.model.cd - self.userInfo.serverTime
            if cd > 0 then
                self.alive = false
                self.cdLabel:setString(qy.TextUtil:substitute(80003)..qy.tank.utils.DateFormatUtil:toDateString(cd))
                self.battleLabel:setVisible(false)
                self.resetLabel:setVisible(true)
            else
                self.alive = true
                self.cdLabel:setString("")
                self.battleLabel:setVisible(true)
                self.resetLabel:setVisible(false)
            end
        end
        
        -- 结束倒计时
        local cd = self.model.time[1]["end"] - self.userInfo.serverTime
        if cd > 0 then
            self.endTime:setString(qy.tank.utils.DateFormatUtil:toDateString(cd))
        else
            self.endTime:setString("")
        end
    else
        self.cdLabel:setString("")
        -- 开启倒计时
        local cd = self.model.time[1]["start"] - self.userInfo.serverTime
        if cd > 0 then
            self.openTime:setString(qy.tank.utils.DateFormatUtil:toDateString1(cd,1))
        else
            self.openTime:setString("")
        end
    end
end

function LegionBossView:showRandomBuff()
    local num = math.ceil(math.random(3))
    for i=1,num do
        local params = {
                ["numType"] = 2,
                ["value"] = -(math.random(500000-2000)+2000),
                ["hasMark"] = 1,
                ["picType"] = 2,
            }

        local toast = qy.tank.widget.Attribute.new(params)
        toast.valueLabel:setAnchorPoint(0.5,0.5)
        local x,y = math.random(300)+150,math.random(200)+200
        toast:setPosition(x,y)
        self.boss:addChild(toast)
        toast:setVisible(false)
        
        
        local duration = 0.8 + math.random()
        -- local mov1 = cc.MoveTo:create(duration, cc.p(x,y+100+math.random(100)))
        local mov1 = cc.MoveTo:create(duration, cc.p(x,y+200))
        local fade1 = cc.FadeOut:create(duration)
        local spawn1 = cc.Spawn:create(mov1,fade1)
        
        -- local seq1 = cc.Sequence:create(mov1,cc.DelayTime:create(0.1),spawn1,cc.CallFunc:create(function()
        local seq1 = cc.Sequence:create(cc.DelayTime:create(0.5+math.random()),cc.CallFunc:create(function()
                toast:setVisible(true)
            end),spawn1,cc.CallFunc:create(function()
            self.boss:removeChild(toast)
            toast = nil
        end))

        toast:runAction(seq1)
    end
end

function LegionBossView:onEnter()
    if not self.timeListener then
        self.timeListener = qy.Event.add(qy.Runtime.TIMER_UPDATE,function(event)
            self:updateTime()
        end)
    end
    self:updateTime()
    self:render()
end

function LegionBossView:onExit()
    print("LegionBossView:onExit")
    qy.Event.remove(self.timeListener)
    self.timeListener = nil
end

function LegionBossView:onCleanup()
    print("LegionBossView:onCleanup")
    qy.Event.remove(self.timeListener)
    self.timeListener = nil
end

function LegionBossView:setBossLevel(level)
    print("LegionBossView:setBossLevel")
    self.bossLevel:setString(tostring(level))
    if not self.label then
        self.label = ccui.TextAtlas:create()
        self.boss:addChild(self.label)
        self.label:setPosition(543,193)
    end
    local img = "legion_boss/res/number.png"
    self.label:setProperty(string.format("%d", math.abs(level)),img,47.2,45,"0")
end

return LegionBossView