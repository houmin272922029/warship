-- local MainDialog = qy.tank.module.BaseUI.class("MainDialog", "pub.ui.MainDialog")
local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "pubs.ui.MainDialog")

local model = qy.tank.model.OperatingActivitiesModel
local service = qy.tank.service.OperatingActivitiesService
function MainDialog:ctor()
    MainDialog.super.ctor(self)

    local winSize = cc.Director:getInstance():getWinSize()
    -- self.ui.Bg:setPositionX(winSize.width / 2)
    -- self.ui.Reward:setSwallowTouches(false)
    self:InjectView("Cheers")
    self:InjectView("Frame")
    self:InjectView("FreeTimes")
    self:InjectView("SpecialTimes")
    self:InjectView("Time")
    self:InjectView("Rank")
    self:InjectView("MyRank")
    self:InjectView("Btn_Reward")
    self:InjectView("Close")
    self:InjectView("Diamond")
    self:InjectView("RedPoint")
    self:InjectView("Btn_ten")
    
    self.Frame:setLocalZOrder(8)

    self:OnClick("Btn_Reward", function()
        --qy.QYPlaySound.stopMusic()
        local dialog = require("pubs.src.AchievementRewardDialog").new(self)
        dialog:show()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self:OnClick("Cheers", function()
        --qy.QYPlaySound.stopMusic()
        service:getCommonGiftAward(nil, "jiuguan", true, function(reData)
            -- self:setTimes()
            self.Cheers:setEnabled(false)
            self.Btn_Reward:setEnabled(false)
            self.Close:setEnabled(false)
            self.Btn_ten:setEnabled(false)
            self:play(model:pubGetIdx())
        end,false)
        
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self:OnClick("Btn_ten", function()
        --qy.QYPlaySound.stopMusic()
        service:getTenCheers(function(reData)
            -- self:setTimes()
            self:update()
        end)
        
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self:OnClick("Close", function()
        --qy.QYPlaySound.stopMusic()
        qy.Event.remove(self.timeListener)
        self:removeSelf()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})


    for i, v in pairs(model.pubListPosition) do
    	local item = qy.tank.view.common.AwardItem.createAwardView(model:pubAtType(i).award[1] ,1)
    	item:setPosition(v)
    	item.name:setString("")
    	self["item" .. i] = item
        local sprite = cc.Sprite:createWithSpriteFrameName("pubs/res/pub9.png")
        item:addChild(sprite)
        sprite:setLocalZOrder(3)
        sprite:setScale(1.2)
        item.frame = sprite
        item:setScale(0.85)

        item.frame:setVisible(model.pubType == 2)
    	self.Cheers:addChild(item)
    end

    self:setTimes()
    -- self.Cheers:loadTexture("Res/" .. model.pubType == 1 and 1 or 11 .. ".png")

    --更新时间
    self.timeListener = qy.Event.add(qy.Runtime.TIMER_UPDATE,function(event)
        -- if self:update
        self:updateTime()
    end)

    self:updateTime()

    self:setMyRank()

    self.Rank:addChild(self:createRankView())

    self:setFrame()
end

function MainDialog:initAction()
	self.Frame:setPosition(model.pubListPosition["1"])
end

function MainDialog:play(idx)
    local num =  math.random(4, 2)

    local actions = {}
    for i = 1, num do
        local sec = i == num and 0.4 or 0.1
        for j = 1, 12 do        
            local pos = model.pubListPosition[tostring(j)]
            local func = cc.CallFunc:create(function()
                qy.QYPlaySound.playEffect(qy.SoundType.OPEN_MENU)
                self.Frame:setPosition(pos)
            end)
            local delay = cc.DelayTime:create(sec)
            table.insert(actions, func)
            table.insert(actions, delay)
            if idx == j and i == num then
                break
            end
        end
    end

    local func2 = cc.CallFunc:create(function()
        local awardData = model.pubAward
        -- qy.tank.command.AwardCommand:add(awardData)
        qy.tank.command.AwardCommand:show(awardData)
    end)
    table.insert(actions, func2)

    local func3 = cc.CallFunc:create(function()
        self:update()
        self.Cheers:setEnabled(true)
        self.Btn_Reward:setEnabled(true)
        self.Close:setEnabled(true)
        self.Btn_ten:setEnabled(true)
    end)

    table.insert(actions, func3)

    self.Frame:runAction(cc.Sequence:create(actions))
end

function MainDialog:update()
	for i, v in pairs(model.pubListPosition) do	
    	self["item" .. i]:setData(qy.tank.view.common.AwardItem.getItemData(model:pubAtType(i).award[1]))
    	self["item" .. i].name:setString("")
        self["item" .. i].frame:setVisible(model.pubType == 2)
    end

    self:setMyRank()

    self.tableView:reloadData()

    self:setFrame()

    if model.oldPubType ~= model.pubType then
        local func1 = cc.ScaleTo:create(0.2, 0, 1)
        local func2 = cc.ScaleTo:create(0.2, 1, 1)

        self.Cheers:runAction(cc.Sequence:create(func1, func2))
    end

    self:setTimes()
end

function MainDialog:setTimes()
    if model.pubFreeTimes > 0 then
    	self.FreeTimes:setString(qy.TextUtil:substitute(59001) .. model.pubFreeTimes .. qy.TextUtil:substitute(59002))
        self.Diamond:setVisible(false)
    else
        self.FreeTimes:setString("干杯花费：188")
        self.Diamond:setVisible(true)
    end

    if model.pubType == 2 then
        self.Diamond:setVisible(false)
        self.FreeTimes:setString(qy.TextUtil:substitute(59004))
        self.SpecialTimes:setString(qy.TextUtil:substitute(59005))
        self.FreeTimes:setTextColor(cc.c3b(0, 255, 0))
    else
        self.FreeTimes:setTextColor(cc.c3b(255, 255, 255))
        self.SpecialTimes:setString(qy.TextUtil:substitute(59006) .. model.pubSpecialTimes .. qy.TextUtil:substitute(59007))
    end
    
    -- self.SpecialTimes:setVisible(model.pubType ~= 2)


    -- self.Cheers:loadTexture("Res/11.png", ccui.TextureResType.plistType)
end

function MainDialog:updateTime()
    local time = qy.tank.utils.DateFormatUtil:toDateString(model.pubLevelTime, 3)
    self.Time:setString(time)
    model.pubLevelTime = model.pubLevelTime - 1
    model.pubLevelTime = model.pubLevelTime < 0 and 0 or model.pubLevelTime
end

function MainDialog:setMyRank()
    local myrank = model:getMyRank() or qy.TextUtil:substitute(59008)
    self.MyRank:setString(qy.TextUtil:substitute(59009) .. myrank)

    self.RedPoint:setVisible(model:testPubAwardRedPoint())
end

function MainDialog:setFrame()
    local idx = model.pubType == 1 and 1 or 11
    self.Cheers:loadTexture("pubs/res/" .. idx .. ".png", ccui.TextureResType.plistType)
end

-- 排名
function MainDialog:createRankView()
    local tableView = cc.TableView:create(cc.size(380, 300))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(20, 110)

    local function numberOfCellsInTableView(tableView)
        return #model:getRank()
    end

    local function cellSizeForTable(tableView, idx)
        return 380, 30
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil
        -- local data = model:getList(idx)
        -- local height = model:getHeight(idx)
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("pubs.src.RankItem").new({

                })
            cell:addChild(item)
            cell.item = item
        end

        cell.item:setData(model:getRank()[idx + 1], idx)
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()

    self.tableView = tableView
    return tableView
end

return MainDialog
