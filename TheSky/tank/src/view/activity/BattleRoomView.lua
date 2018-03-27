--[[
	活动导航(作战室)
	Author: Aaron Wei
	Date: 2015-06-01 19:52:17
]]

local BattleRoomView = qy.class("BattleRoomView", qy.tank.view.BaseView, "view/activity/BattleRoomView")

function BattleRoomView:ctor(delegate)
    BattleRoomView.super.ctor(self)
    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "Resources/common/title/zuozhanshi.png",
        ["onExit"] = function()
            if delegate and delegate.dismiss then
                delegate.dismiss()
            end
        end
    })
    self:addChild(style, 13)

	self:InjectView("list")
    self:InjectView("bg")
	self:InjectView("mask_left")
	self:InjectView("mask_right")
	self.mask_left:setPosition(0,0)
	self.mask_left:setLocalZOrder(10)
	self.mask_right:setPosition(qy.winSize.width,0)
	self.mask_right:setLocalZOrder(10)
    self.btnList = {}

	self.model = qy.tank.model.BattleRoomModel
	self:createList()

	local userInfoModel = qy.tank.model.UserInfoModel
    local index = 0
	if qy.isTriggerGuide then
		local name = qy.GuideModel:getTriggerGuideIcon()
		index = self.model:getIdxByRoomName(name)
		local _w = qy.winSize.width - 310 * index
		if _w < 0 then
			self.roomList:setContentOffset(cc.p(self.roomList:getContentOffset().x + _w -20,0),false)
		end
        self:OnClick("bg",function()
            self:__clickLogic(index)
        end,{["isScale"]=false})
    end
    -- if qy.isTriggerGuide then
    --     self.bg:setTouchEnabled(true)
    -- else
    --     self.bg:setTouchEnabled(false)
	-- end
end

function BattleRoomView:createList()
    self.roomList = cc.TableView:create(cc.size(qy.winSize.width-10,600))
    self.roomList:setDirection(cc.TABLEVIEW_FILL_TOPDOWN)
    self.roomList:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.roomList:setPosition(5,5)
    self:addChild(self.roomList,1)
    self.roomList:setDelegate()
    self.roomIdx = 1

    local function numberOfCellsInTableView(table)
        return self.model:getNum()
    end

    local function tableCellTouched(table,cell)
        qy.QYPlaySound.playEffect(qy.SoundType.COMMON_CLICK)
        self.selectTrainIdx = cell:getIdx() + 1
        self:__clickLogic(self.selectTrainIdx)
    end

    local function cellSizeForTable(tableView, idx)
        return 305, 505
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.activity.RoomCell.new()

            cell:addChild(item)
            cell.item = item
        	-- cell:setAnchorPoint(0.5,0.5)
        end
        cell.item:render(idx + 1)
        self.btnList[self.model:getListIndex()[idx + 1]] = cell.item.frame
        return cell
    end

    self.roomList:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.roomList:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    self.roomList:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    self.roomList:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    self.roomList:reloadData()
end

function BattleRoomView:__clickLogic(_idx)
	local _k = self.model:getKeyByIndex(_idx)
	qy.tank.command.ActivitiesCommand:showActivity(_k)
end

function BattleRoomView:msgAnim()
	self.msg:setString(self.model:getAnnouncement())
	local w = self.msg:getContentSize().width

	self.msg:setPosition(qy.winSize.width, 61)
	local move = cc.MoveTo:create(25 * 5, cc.p(-w + 100, 61))
	local callFunc = cc.CallFunc:create(function ()
		self.msg:setPosition(qy.winSize.width, 61)
		self.msg:setString(self.model:getAnnouncement())
		w = self.msg:getContentSize().width
	end)
	local seq = cc.Sequence:create(move,callFunc)
	self.msg:runAction(cc.RepeatForever:create(seq))
end

function BattleRoomView:onEnter()
	-- self:msgAnim()
	--触发式引导
    qy.GuideCommand:addTriggerUiRegister({
        {["ui"] = self.btnList["arena"], ["step"] = {"T_AR_4"}},
        {["ui"] = self.btnList["classicBattle"], ["step"] = {"T_CB_4"}},
        -- {["ui"] = self.btnList["inspection"], ["step"] = {"T_23_5"}},
        -- {["ui"] = self.btnList["invade"], ["step"] = {"T_28_5"}},
        {["ui"] = self.btnList["expedition"], ["step"] = {"T_EX_4"}},
        -- {["ui"] = self.btnList["gunner_train"], ["step"] = {"T_GB_4"}},
    })
    -- --触发引导，主城不能移动
    if qy.isTriggerGuide then
        print("=======================================>>>>>>>>>>>>>>>>>>>>>>>>>触发式引导期间：不能移动主城")
        self.roomList:setTouchEnabled(false)
        self.bg:setTouchEnabled(true)
    else
        print("=======================================>>>>>>>>>>>>>>>>>>>>>>>>>不是触发式引导期间：可以移动主城")
        self.roomList:setTouchEnabled(true)
        self.bg:setTouchEnabled(false)
    end
end

function BattleRoomView:onExit()
	qy.GuideCommand:removeTriggerUiRegister({"T_CB_4","T_AR_4","T_EX_4"})
end

function BattleRoomView:onCleanup()
	print("BattleRoomView:onCleanup")
    -- qy.tank.utils.cache.CachePoolUtil.removePlist("Resources/activity/activity",1)
    -- qy.tank.utils.cache.CachePoolUtil.removeTextureForKey("Resources/arena/war_room_006.jpg")
end

return BattleRoomView
