--[[
	竞技场
	Author: Aaron Wei
	Date: 2015-05-25 16:58:36
]]

local ArenaView = qy.class("ArenaView", qy.tank.view.BaseView, "view/arena/ArenaView")

function ArenaView:ctor(delegate) 
    ArenaView.super.ctor(self)

    self.delegate = delegate
    self.model = qy.tank.model.ArenaModel
    self.userInfo = qy.tank.model.UserInfoModel

    self.isCtor = true

    self:InjectView("panel")
    self:InjectView("rankTitle")
    self:InjectView("rank")
    self:InjectView("remainTitle")
    self:InjectView("remain")
    self:InjectView("winNum")
    self:InjectView("addBtn")
    self:InjectView("awardIcon")
    self:InjectView("awardLabel")
    self:InjectView("helpBtn")
    self:InjectView("previewBtn")

    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "Resources/arena/JJC_0003.png", 
        showHome = true,
        ["onExit"] = function()
            if delegate and delegate.dismiss then  
                delegate.dismiss()
            end
        end
    })
    self:addChild(style)

    self.awardIcon:setSwallowTouches(true)
    self:OnClick("awardIcon", function(sender)
        if self.model.win_times < 5 then
            -- 不可领
            qy.hint:show(qy.TextUtil:substitute(4014))
        else
            if self.model.is_draw_award == 0 then
                -- 可领未领
                if delegate and delegate.getAward then
                    delegate.getAward()
                end
            else
                -- 可领已领
                -- test 
                --qy.hint:show(qy.TextUtil:substitute(4015))
            end
        end
    end)

    self:OnClick("addBtn", function(sender)
        local num = self.model.challenge_times+self.model.buy_times
        local buyDialog = qy.tank.view.common.BuyNumDialog.new(num,function()
            local service = qy.tank.service.ArenaService
            service:buy(function()
                service = nil
                self:render()
                -- if data and data.consume then
                --     qy.hint:show("购买成功!消费"..self.currencyMap[data.consume.type].."x"..data.consume.num)
                -- end
            end)
        end)
        buyDialog:show(true) 
    end)    

    self.helpBtn:setSwallowTouches(true)
    self:OnClick("helpBtn", function(sender)
        qy.tank.view.common.HelpDialog.new(2):show(true)
    end,{["isScale"]=false})

    self:OnClick("previewBtn", function(sender)
        qy.tank.view.arena.AwardPreviewDialog.new():show(true)
    end)

    -- 军神商店
    self:OnClick("shopBtn", function(sender)
        self.model:initGoodsList()
        local service = qy.tank.service.ArenaService
        service:getExchage(function(data)
            qy.tank.view.arena.ArenaShopDialog.new(
                {["data"] = data}):show(true)
        end)

    end,{["isScale"]=false})

    --远征商店
    self:OnClick("exchangeBtn", function(sender)
       openExchangeDialog()
    end)

    self.tab_host = qy.tank.widget.TabHost.new({
        delegate = self,
        csd = "widget/TabButton1",
        tabs = {qy.TextUtil:substitute(4016), qy.TextUtil:substitute(4017)},
        size = cc.size(185,70),
        layout = "h",
        idx = 1,

        ["onCreate"] = function(tabHost, idx)
            self.idx = idx
            return self:createContent(idx)
        end,
        
        ["onTabChange"] = function(tabHost, idx)
            self.idx = idx
            local tv = tabHost.views[idx] 
            if idx == 1 then
                self:focusOn(tv,#self.model.challengeList,self.model.myChallengeIdx)
            else
                tv:reloadData()
            end
        end
    })
    self.panel:addChild(self.tab_host)
    self.tab_host:setPosition(0,579)

    self.panel:setSwallowTouches(false)
end

function ArenaView:showShareView()
    print("cc.UserDefault:getInstance():getIntegerForKey(shareArena)=="..cc.UserDefault:getInstance():getIntegerForKey("shareArena"))
    if qy.language == "en" and cc.UserDefault:getInstance():getIntegerForKey("shareArena",1) == 1 then
            cc.UserDefault:getInstance():setIntegerForKey("shareArena", 2)
            qy.tank.view.common.ShareView.new():show(1)
    end
end
function ArenaView:onEnter()
    if not self.isCtor then
        self:updateTankList()
    end
    self:render()
    self.isCtor = false
    self.listener_1 = qy.Event.add(qy.Event.SHARE_SHOP,function(event)
        self:showShareView()
    end)
end

function ArenaView:onExit()
    qy.Event.remove(self.listener_1)
end

function ArenaView:onCleanup()
    print("ArenaView:onCleanup")
    if self.fx and tolua.cast(self.fx,"cc.Node") then
       self.awardIcon:removeChild(self.fx)
       self.fx = nil
    end
end

function ArenaView:createContent(_idx)
    local h = 456
    local tableView = cc.TableView:create(cc.size(1080,h))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(0,-h-13)
    -- local layer = cc.LayerColor:create(cc.c4b(0,255,255,100),625,380)
    -- tableView:addChild(layer)
    tableView:setDelegate()

    local function numberOfCellsInTableView(table)
        if _idx == 1 then
            return #self.model.challengeList
        elseif _idx == 2 then
            return #self.model.rankList
        end
    end

    local function tableCellTouched(table,cell)
        print("cell touched at index: " .. cell:getIdx())
        local kid = cell.item.entity.kid
        if kid ~= self.userInfo.kid then
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXAMINE,cell.item.entity.kid)
        end
    end

    local function cellSizeForTable(tableView, idx)
        return 1080, 190
    end

    local function tableCellAtIndex(table, idx)
        local strValue = string.format("%d",idx)
        local cell = table:dequeueCell()
        local item = nil
        local label = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.arena.ArenaCell.new({
                ["type"] = _idx,
                ["kid"] = self.userInfo.kid,
                ["look"] = function(entity)
                    qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXAMINE,entity.kid)
                end,

                ["challenge"] = function(rank)
                    qy.tank.service.ArenaService:attack(rank,function()
                        -- self:updateTankList()
                        -- self:render()
                    end)
                end,

                ["embattle"] = function()
                end,  
            })
            cell:addChild(item)
            cell.item = item
        end

        if _idx == 1 then
            cell.item:render(self.model.challengeList[idx+1])
        elseif _idx == 2 then
            cell.item:render(self.model.rankList[idx+1])
        end
        -- cell.label:setString(strValue)
        return cell
    end

    local function tableCellHighLight(table,cell)
        if cell.item.entity.kid ~= self.userInfo.kid then
            cell.item:hightLight()
        end
    end

    local function tableCellUnhighLight(table,cell)
        if cell.item.entity.kid ~= self.userInfo.kid then
            cell.item:unhightLight()
        end
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)

    tableView:registerScriptHandler(tableCellHighLight, cc.TABLECELL_HIGH_LIGHT)
    tableView:registerScriptHandler(tableCellUnhighLight, cc.TABLECELL_UNHIGH_LIGHT)
    
    if _idx == 1 then
        self:focusOn(tableView,#self.model.challengeList,self.model.myChallengeIdx)
    else
        tableView:reloadData()
    end

    return tableView
end

function ArenaView:updateTankList()
    if self.tab_host then
        local tv = self.tab_host.views[self.idx]
        if self.idx == 1 then
            self:focusOn(tv,#self.model.challengeList,self.model.myChallengeIdx)
        else
            tv:reloadData()
        end
    end
end

function ArenaView:render()
    self.rank:setString(tostring(self.model.rank))
    self.remain:setString(tostring(self.model.challenge_times+self.model.buy_times))
    self.winNum:setString(tostring(self.model.win_times).."/5")
    

    self.awardIcon:setContentSize(95,89)   
    if self.model.win_times < 5 then
        -- 不可领
        if self.fx and tolua.cast(self.fx,"cc.Node") then
           self.awardIcon:removeChild(self.fx)
           self.fx = nil
        end
        -- self.awardIcon:setTouchEnabled(false)
        self.awardIcon:loadTexture("Resources/arena/wusheng3.png",1)
        self.awardLabel:initWithSpriteFrameName("Resources/arena/wusheng1.png")
        self.winNum:setTextColor(cc.c4b(255,0,0,255))
    else
        if self.model.is_draw_award == 0 then
            -- self.awardIcon:setTouchEnabled(true)
            -- 可领未领
            self.awardIcon:loadTexture("Resources/common/bg/c_12.png")
            self.awardLabel:initWithSpriteFrameName("Resources/arena/wusheng1.png")
            if not tolua.cast(self.fx,"cc.Node") then
                self.fx = ccs.Armature:create("ui_fx_xiangziguang")
                self.fx:setScaleX(-1)
                self.fx:setPosition(44,50)
                self.awardIcon:addChild(self.fx,-1)
            end
            self.fx:getAnimation():playWithIndex(0,-1,-1)
        else
            -- 可领已领
            if self.fx and tolua.cast(self.fx,"cc.Node") then
                self.awardIcon:removeChild(self.fx)
                self.fx = nil 
            end
            -- self.awardIcon:setTouchEnabled(false)
            self.awardIcon:loadTexture("Resources/arena/wusheng4.png",1)
            self.awardLabel:initWithSpriteFrameName("Resources/arena/wusheng2.png")
        end
        self.winNum:setTextColor(cc.c4b(0,255,0,255))
    end
end

-- 定位到指定索引
function ArenaView:focusOn(_tableView,_len,_idx)
    if _len > 3 then
        -- 偏移  
        if _idx <= 1 then 
            -- 偏移到顶部
        elseif _len - _idx > 0 then
            -- 偏移到中间
            _tableView:setContentOffset(cc.p(0,-(190*(_len-_idx)-508/2)-120), true)
        else
            -- 偏移到底部
            _tableView:setContentOffset(cc.p(0,0), true)
        end 
    else
        -- 不偏移，顶对齐
    end
    _tableView:reloadData()
end

return ArenaView