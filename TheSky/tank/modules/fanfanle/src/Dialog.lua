--[[--
--翻翻乐
--Author: Fu.Qiang
--Date: 2016-07-04
--]]--


local FanFanLeDialog = qy.class("FanFanLeDialog", qy.tank.view.BaseDialog, "fanfanle/ui/Dialog")

local model = qy.tank.model.FanFanLeModel
local service = qy.tank.service.FanFanLeService
local userModel = qy.tank.model.UserInfoModel
function FanFanLeDialog:ctor(delegate)
    FanFanLeDialog.super.ctor(self)

    local style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(980, 630),
        position = cc.p(0, 0),
        offset = cc.p(0, 0),
        bgShow = false,
        titleUrl = "Resources/common/title/fanfanle.png",

        ["onClose"] = function()
            self:removeSelf()
        end
    })

    self:addChild(style)

    self:InjectView("bg")
    self:InjectView("gold_node")
    self:InjectView("silver_node")
    self:InjectView("node")
    self:InjectView("node2")
    self:InjectView("Button_refresh")
    self:InjectView("Button_switch")
    self:InjectView("Button_open")
    self:InjectView("Button_go_pay")
    self:InjectView("Text_times")
    self:InjectView("Text_next")
    self:InjectView("Text_refresh")
    self:InjectView("Text_time")
    self:InjectView("Text_meichong")
    self:InjectView("shopBt")

    
       
    --当前是金牌组还是银牌组 100银200金
    self.current_card = cc.UserDefault:getInstance():getIntegerForKey(userModel.userInfoEntity.kid.."fanfanle_poker", 200)


    self:OnClick(self.Button_refresh, function(sender)        
        service:updateAward(function()
            self:updateAward(self.current_card)
        end, self.current_card)
    end,{["isScale"] = false})

    self:OnClick("shopBt", function(sender)        
       local item = require("fanfanle.src.ShopDialog").new()
        item:show()
    end,{["isScale"] = false})

    self:OnClick(self.Button_go_pay, function(sender)
        self:removeSelf()
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.RECHARGE)
    end,{["isScale"] = false})

    self:OnClick(self.Button_open, function(sender)
        service:getAward(function(data)           
            if data.award then
                qy.tank.command.AwardCommand:add(data.award)
                qy.tank.command.AwardCommand:show(data.award, {["isShowHint"] = false}) 
                self:update()             
            end
        end, self.current_card, 200)        
    end,{["isScale"] = false})


    self:OnClick(self.Button_switch, function(sender)
        self.Button_open:setTouchEnabled(false)--自动翻拍按钮在洗完牌之前不可点
        self.Button_switch:setTouchEnabled(false)
        if self.current_card == 200 then
            self:updatePokerVisible(100)
        else
            self:updatePokerVisible(200)
        end

        self:judgeShuffle()
    end,{["isScale"] = false})


    self:OnClick("Button_help", function()
        qy.tank.view.common.HelpDialog.new(31):show(true)
    end, {["isScale"] = false})

   

    self.card_poss = {cc.p(80, 422), cc.p(200, 422), cc.p(320, 422), cc.p(440, 422), cc.p(560, 422), cc.p(80, 267), cc.p(200, 267), cc.p(320, 267), cc.p(440, 267), cc.p(560, 267)}
    self.silver_cards = {}
    self.gold_cards = {}   

    self.Button_open:setTouchEnabled(false)--自动翻拍按钮在洗完牌之前不可点
    self.Button_switch:setTouchEnabled(false)
    self:updatePokerVisible(self.current_card)
    self:judgeShuffle()
    self.node:addChild(self:__createList())
    self:update()    
    self.Text_time:setString(os.date("%Y-%m-%d %H:%M:%S",model.start_time).."至"..os.date("%Y-%m-%d %H:%M:%S",model.end_time))


end

--初始化金牌
function FanFanLeDialog:initGoldCards()
    self.gold_node:removeAllChildren()
    self.gold_cards = {}
    for i = 1, 10 do 
        local gold_card = require("src.view.common.PokerSprite").new(cc.Sprite:create("fanfanle/res/9.png"), cc.Sprite:create("fanfanle/res/3.png"), function()
            if self.gold_cards[i]:getOpenStatus() == false then
                service:getAward(function(data)
                    self:addPokerAward(data.award[1], self.gold_cards[i])  
                    self:updateCardTouch(self.gold_cards, false)
                    self.gold_cards[i]:setOpenStatus(false)--上面addPokerAward时会给所有有奖励的牌setOpenStatus(true),所以这里加一句，使得下面的open可以正确执行动画
                    self.gold_cards[i]:open(0.5, function() 
                        self:runAction(cc.Sequence:create(cc.DelayTime:create(1), cc.CallFunc:create(function()
                            qy.tank.command.AwardCommand:add(data.award)
                            qy.tank.command.AwardCommand:show(data.award, {["isShowHint"] = false})
                            self.tableView:reloadData()
                            self.gold_cards[i]:open(0.5, function()
                                self:updateCardTouch(self.gold_cards, true)
                            end)                            
                        end)))                        
                    end)

                    self:update()
                end, self.current_card, 100, i)
            end
        end)

        gold_card:setOpenStatus(isOpen)
        gold_card:setPosition(self.card_poss[i])
        self.gold_node:addChild(gold_card, 11 - i)
        table.insert(self.gold_cards, gold_card)
    end
end



function FanFanLeDialog:initSilverCards()
    self.silver_node:removeAllChildren()
    self.silver_cards = {}
    for i = 1, 10 do 
        local silver_card = require("src.view.common.PokerSprite").new(cc.Sprite:create("fanfanle/res/10.png"), cc.Sprite:create("fanfanle/res/2.png"), function()
            if self.silver_cards[i]:getOpenStatus() == false then
                service:getAward(function(data)      
                    self:addPokerAward(data.award[1], self.silver_cards[i])  
                    self:updateCardTouch(self.silver_cards, false)
                    self.silver_cards[i]:setOpenStatus(false)--上面addPokerAward时会给所有有奖励的牌setOpenStatus(true),所以这里加一句，使得下面的open可以正确执行动画
                    self.silver_cards[i]:open(0.5, function() 
                        self:runAction(cc.Sequence:create(cc.DelayTime:create(1), cc.CallFunc:create(function()
                            qy.tank.command.AwardCommand:add(data.award)
                            qy.tank.command.AwardCommand:show(data.award, {["isShowHint"] = false})
                            self.tableView:reloadData()
                            self.silver_cards[i]:open(0.5, function()
                                self:updateCardTouch(self.silver_cards, true)
                            end)                            
                        end)))
                    end)

                    self:update()
                end, self.current_card, 100, i)
            end
        end)
        silver_card:setOpenStatus(isOpen)
        silver_card:setPosition(self.card_poss[i])
        self.silver_node:addChild(silver_card, 11 - i)
        table.insert(self.silver_cards, silver_card)
    end
end

--洗牌动画
function FanFanLeDialog:shuffle(cards, card_poss, center_pos)
    
    self:runAction(cc.Sequence:create(cc.DelayTime:create(5), cc.CallFunc:create(function()
        if #cards == #card_poss then
            for i = 1, #cards do
                cards[i]:setTouchStatus(false) --洗牌时间设置不可点击
                cards[i]:runAction(cc.Sequence:create(cc.CallFunc:create(function()
                    cards[i]:open(1)
                end), cc.DelayTime:create(1), cc.CallFunc:create(function()
                    if i == #cards then
                        cards[i]:runAction(cc.Sequence:create(cc.DelayTime:create(i * 0.08), cc.MoveTo:create(0.15, center_pos), cc.CallFunc:create(function()
                            for i = 1, #cards do
                                local move_by = cc.MoveBy:create(0.2, cc.p(-150 + i * 30, 0))
                                local move_back = move_by:reverse()
                                local move_by2 = cc.MoveBy:create(0.2, cc.p(-150 + (#cards - i) * 30, 0))
                                local move_back2 = move_by2:reverse()
                                local move_by3 = cc.MoveBy:create(0.2, cc.p(-150 + i * 30, 0))
                                local move_back3 = move_by3:reverse()
                                local move_to = cc.Sequence:create(cc.DelayTime:create(i * 0.08), cc.MoveTo:create(0.15, card_poss[i]))
                                cards[i]:runAction(cc.Sequence:create(move_by, move_back, move_by2, move_back2, move_by3, move_back3, move_to, cc.CallFunc:create(function()
                                        cards[i]:setTouchStatus(true)
                                        self.Button_open:setTouchEnabled(true)--自动翻拍按钮在洗完牌之后恢复可点
                                        self.Button_switch:setTouchEnabled(true)
                                    end)))
                            end
                        end)))
                    else
                        cards[i]:runAction(cc.Sequence:create(cc.DelayTime:create(i * 0.08), cc.MoveTo:create(0.15, center_pos)))
                    end
                end)))
            end
        end
    end)))
end

--决定是否洗牌 
function FanFanLeDialog:judgeShuffle()    
    --if self.current_card == 200 and model.gold_award ~= nil and (#model.gold_award == 0 or #model.gold_award == 10) then  
    if self.current_card == 200 then
        for i = 1, 10 do
            self.gold_cards[i]:setOpenStatus(true)
        end
        self:previewAward(self.current_card)
        self:shuffle(self.gold_cards, self.card_poss, cc.p(330, 330))
        
        
        --return true            
        
    --elseif self.current_card == 100 and model.silver_award ~= nil and (#model.silver_award == 0 or #model.silver_award == 10) then
    elseif self.current_card == 100 then
        for i = 1, 10 do
            self.silver_cards[i]:setOpenStatus(true)
        end
        self:previewAward(self.current_card)
        self:shuffle(self.silver_cards, self.card_poss, cc.p(330, 330))        
        
        --return true
    end

    --return false
end



function FanFanLeDialog:update()
    --self:updatePokerVisible(self.current_card)

    if self.current_card == 100 then
        self.Text_times:setString(model.silver_remain)
    else
        self.Text_times:setString(model.gold_remain)
    end

    
end


function FanFanLeDialog:updatePokerVisible(card_type)    

    if card_type == 100 then        
        self:initSilverCards()
        self.gold_node:removeAllChildren()
        self.Text_times:setString(model.silver_remain)
        self.Text_next:setString(200 - model.cash % 200)
        self.Text_refresh:setString("X"..100)
        self.Text_meichong:setString(200)
    else
        self:initGoldCards()
        self.silver_node:removeAllChildren()
        self.Text_times:setString(model.gold_remain)
        self.Text_next:setString(2000 - model.cash % 2000)
        self.Text_refresh:setString("X"..300)
        self.Text_meichong:setString(2000)
    end



    self:stopAllActions()
    self.current_card = card_type
    cc.UserDefault:getInstance():setIntegerForKey("fanfanle_poker", card_type)
    

    self:updateAward(card_type)
    
end


function FanFanLeDialog:updateAward(card_type)
    local current_award

    if card_type == 100 then
        current_award = model.silver_must_award
    else
        current_award = model.gold_must_award
    end


    if self.awardList then
        self.node2:removeChild(self.awardList)
    end

    -- local size = cc.size(100, 130)
    -- for i = 1, #current_award do 
    --     if current_award[i].type == 11 then --战车
    --         size = cc.size(160,130)
    --     end
    -- end

    self.awardList = qy.AwardList.new({
        ["award"] = current_award,
        ["cellSize"] = cc.size(100, 130),
        ["type"] = 1,
        ["itemSize"] = 2,
        ["hasName"] = false,
    })
    self.awardList:setPosition(210,275)
    self.node2:addChild(self.awardList, 2)

end


-- function FanFanLeDialog:addPokerAward(current_card)
--     if current_card == 100 then 
--         for i = 1, #model.silver_award do
--             local award = qy.tank.view.common.AwardItem.createAwardView(model.silver_award[i].award[1], 1)
--             award:setPosition(54, 80)
--             award:setScale(0.8)

--             local front = self.silver_cards[tonumber(model.silver_award[i].post)]:findViewByName("front")
--             front:removeAllChildren()
--             front:addChild(award)

--             self.silver_cards[tonumber(model.silver_award[i].post)]:setOpenStatus(true)
--         end
--     else
--         for i = 1, #model.gold_award do
--             local award = qy.tank.view.common.AwardItem.createAwardView(model.gold_award[i].award[1], 1)
--             award:setPosition(54, 80)
--             award:setScale(0.8)

--             local front = self.gold_cards[tonumber(model.gold_award[i].post)]:findViewByName("front")
--             front:removeAllChildren()
--             front:addChild(award)

--             self.gold_cards[tonumber(model.gold_award[i].post)]:setOpenStatus(true)
--         end
--     end
-- end

function FanFanLeDialog:addPokerAward(data, card)
    local award = qy.tank.view.common.AwardItem.createAwardView(data, 1)
    award:setPosition(54, 80)
    award:setScale(0.8)

    local front = card:findViewByName("front")
    front:removeAllChildren()
    front:addChild(award) 
end


function FanFanLeDialog:previewAward(current_card)
    if current_card == 100 then
        local silver_award_list = model:getSilverAwardList()
        for i = 1, 10 do
            local award = qy.tank.view.common.AwardItem.createAwardView(silver_award_list[i].award[1], 1)
            award:setPosition(54, 80)
            award:setScale(0.8)

            local front = self.silver_cards[i]:findViewByName("front")
            front:removeAllChildren()
            front:addChild(award)

            self.silver_cards[i]:setOpenStatus(true)
        end
    else
        local gold_award_list = model:getGoldAwardList()
        for i = 1, 10 do
            local award = qy.tank.view.common.AwardItem.createAwardView(gold_award_list[i].award[1], 1)
            award:setPosition(54, 80)
            award:setScale(0.8)

            local front = self.gold_cards[i]:findViewByName("front")
            front:removeAllChildren()
            front:addChild(award)

            self.gold_cards[i]:setOpenStatus(true)
        end
    end
end


-- function FanFanLeDialog:autoOpen(cards, award_list)
--     for i = 1, #award_list do
--         local card = cards[tonumber(award_list[i].post)]
--         if card and not card:getOpenStatus() then
--             cards[award_list[i].post]:setTouchStatus(false)
--             cards[award_list[i].post]:open(1)
--         end
--     end
-- end
function FanFanLeDialog:updateCardTouch(cards, flag)
    for i = 1, #cards do
        cards[i]:setTouchStatus(flag)
    end
end




function FanFanLeDialog:__createList()
    local tableView = cc.TableView:create(cc.size(300, 470))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(0,0)
    tableView:setDelegate()

    local function numberOfCellsInTableView(table)
        return #model.get_award_user_list > 10 and 10 or #model.get_award_user_list
    end

    local function tableCellTouched(table,cell)
    end

    local function cellSizeForTable(tableView, idx)
        return 285, 70
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        cell = cc.TableViewCell:new()
        item  = ccui.RichText:create()
        item:ignoreContentAdaptWithSize(false)
        item:setContentSize(285, 0)
        item:setVerticalSpace(2)
        item:setAnchorPoint(0, 0)
        item:setPosition(0, 70)
        item:pushBackElement(ccui.RichElementText:create(1, cc.c3b(255, 255, 200), 255, "恭喜 ", qy.res.FONT_NAME_2, 18))
            
        item:pushBackElement(ccui.RichElementText:create(1, cc.c3b(59, 158, 252), 255, model.get_award_user_list[idx + 1].nickname, qy.res.FONT_NAME_2, 18))
        item:pushBackElement(ccui.RichElementText:create(1, cc.c3b(255, 255, 200), 255, " 在"..(model.get_award_user_list[idx + 1].type == 100 and "银" or "金").."牌抽奖抽到  ", qy.res.FONT_NAME_2, 18))
        local awardItem = qy.tank.view.common.AwardItem.getItemData(model.get_award_user_list[idx + 1].award[1])

        item:pushBackElement(ccui.RichElementText:create(1, qy.tank.utils.ColorMapUtil.qualityMapColor(awardItem.quality), 255, awardItem.name, qy.res.FONT_NAME_2, 18))
        item:pushBackElement(ccui.RichElementText:create(1, cc.c3b(255, 255, 200), 255, " X "..model.get_award_user_list[idx + 1].award[1].num.." 的奖励", qy.res.FONT_NAME_2, 18))
            
        cell:addChild(item)
        cell.item = item
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()
    self.tableView = tableView
    return tableView
end



return FanFanLeDialog