--[[
--战争动员
--Author: H.X.Sun
--Date:
]]
local ArmyAssaultDialog = qy.class("TrainingView", qy.tank.view.BaseDialog, "view/operatingActivities/armyAssault/ArmyAssaultDialog")

function ArmyAssaultDialog:ctor(delegate)
    ArmyAssaultDialog.super.ctor(self)

	self.model = qy.tank.model.OperatingActivitiesModel
	local style = qy.tank.view.style.DialogStyle1.new({
		size = cc.size(978,560),
		position = cc.p(0,0),
		offset = cc.p(0,0),
		titleUrl = "Resources/common/title/army_assault.png",

		["onClose"] = function()
            		self:dismiss()
        		end
    	})
	self:addChild(style, -1)
	local activity = qy.tank.view.type.ModuleType

	local top_sp = cc.Sprite:create("Resources/operatingActivities/top_1.jpg")
	local bgSize = style.bg:getContentSize()
	top_sp:setPosition(bgSize.width/2,bgSize.height - top_sp:getContentSize().height/2 -7)
	style.bg:addChild(top_sp)

	self:InjectView("remainTime")
	self:InjectView("giftNumTxt")
	self:InjectView("tips")
	self:InjectView("container")
	self:InjectView("supplyInfo")
	self:InjectView("bar")
	self:InjectView("openGiftBtn")
	self:__initData()
	self:updataGiftNum()
	self:showTime()

	self.list = self:__createList()
	self.container:addChild(self.list)

	self:OnClick("toBtn",function(sender)
		self:dismiss()
		qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.SUPPLY)
	end)

	local function openGift()
		local callFunc = cc.CallFunc:create(function ()
			if self.model:getGiftNumOfArnyAssault() > 0 then
				local service = qy.tank.service.OperatingActivitiesService
				service:getCommonGiftAward(1, activity.ARNY_ASSAULT,false, function(reData)
                    if self.isViewOpen then
					    self:updataGiftNum()
                    end
				end)
			else
				self.openGiftBtn:stopAllActions()
				qy.hint:show(qy.TextUtil:substitute(63001))
			end
		end)
		local seq = cc.Sequence:create(callFunc,cc.DelayTime:create(0.1))
		self.openGiftBtn:runAction(cc.RepeatForever:create(seq))
	end

	self:OnClick("openGiftBtn",function (sender)
		self.openGiftBtn:stopAllActions()
	end, {["beganFunc"] = function(sender)
		openGift()
	end, ["canceledFunc"]=function (sender)
		self.openGiftBtn:stopAllActions()
	end})
end

function ArmyAssaultDialog:__initData()
	local _data = self.model:getRewardDataOfArnyAssault()
	local _str = ""

	for i = 1, self.model:getSupplyViewNum() do
		self:InjectView("num_" .. i .. "_l")
    self:InjectView("num_" .. i .. "_r")
		if _str ~= "" then
			_str = _str .. "、"
		end
		if i > #_data then
			self["num_" .. i .. "_l"]:setVisible(false)
      self["num_" .. i .. "_r"]:setVisible(false)
		else
			self["num_" .. i .. "_l"]:setVisible(true)
      self["num_" .. i .. "_r"]:setVisible(true)
			for _k, _v in pairs(_data[i]) do
				self["num_" .. i .. "_l"]:setString(_k)
        self["num_" .. i .. "_r"]:setString(_data[i][_k])
				_str = _str .. _k
			end
		end
	end

	self.tips:setString(qy.TextUtil:substitute(63002) .. _str ..qy.TextUtil:substitute(63003))
	self.supplyInfo:setString(self.model:getMyEarningsStr())
	self.bar:setPercent(self.model:getEarningsPercent())
end

function ArmyAssaultDialog:updataGiftNum()
	self.giftNumTxt:setString(qy.TextUtil:substitute(63004) .. self.model:getGiftNumOfArnyAssault())
end

function ArmyAssaultDialog:__createList()
	local tableView = cc.TableView:create(cc.size(485, 270))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setPosition(-475,-205)
	tableView:setDelegate()

	local function numberOfCellsInTableView(table)
		return self.model:getListNumOfArnyAssault()
	end

	local function tableCellTouched(table,cell)
	end

	local function cellSizeForTable(tableView, idx)
		return 485, 51
	end

	local function tableCellAtIndex(table, idx)
		local cell = table:dequeueCell()
		local item
		if nil == cell then
			cell = cc.TableViewCell:new()
			item = qy.tank.view.operatingActivities.armyAssault.SupplyRankCell.new()
			cell:addChild(item)
			cell.item = item
		end
		cell.item:render(idx + 1)
		return cell
	end

	tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    	tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
	tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
	tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
	tableView:reloadData()
	return tableView
end

function ArmyAssaultDialog:showTime()
	self.remainTime:setString(self.model:getRemainTimeOfArnyAssault())
end

function ArmyAssaultDialog:onEnter()
    self.isViewOpen = true
end

function ArmyAssaultDialog:onExit()
    self.isViewOpen = false
	-- qy.Event.remove(self.timeListener)
end

return ArmyAssaultDialog
