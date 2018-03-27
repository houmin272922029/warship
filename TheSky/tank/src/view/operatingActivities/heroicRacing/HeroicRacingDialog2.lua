--[[--
--y英勇竞速dialog
--Author: lianyi
--Date: 2015-06-29
--]]--

local HeroicRacingDialog = qy.class("HeroicRacingDialog", qy.tank.view.BaseView, "view/operatingActivities/heroicRacing/HeroicRacingDialog")

function HeroicRacingDialog:ctor(delegate)
    HeroicRacingDialog.super.ctor(self)
	self.model = qy.tank.model.OperatingActivitiesModel 
	--通用弹窗样式
	self:InjectView("listViewContainer")
	self:InjectView("timeTxt")
	self:InjectView("leftDiamondTxt")
	self:create()
	self.delegate = delegate
end

function  HeroicRacingDialog:create( )
	function createList()
		local tableView = cc.TableView:create(cc.size(750, 500))
		tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
		tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
		tableView:setAnchorPoint(0,0)
		tableView:setPosition(0, -60)
		tableView:setDelegate()
		self.userList = self.model:getHeroicRacingUserList()
		local function numberOfCellsInTableView(table)
			return #self.userList
		end

		local function tableCellTouched(table,cell)

		end

		local function cellSizeForTable(tableView, idx)
			return 750, 150
		end

		local function tableCellAtIndex(table, idx)
			local cell = table:dequeueCell()
			local item
			if nil == cell then
				cell = cc.TableViewCell:new()
				item = qy.tank.view.operatingActivities.heroicRacing.HeroicRacingItem.new({
					["callBack"] = function ()
						self:updateList()
					end
				})
				cell:addChild(item)
				cell.item = item
			end
			local data = {
				["itemData"] = self.userList[idx+1],
				["dismiss"] = function( )
					self.delegate:dismiss()
				end
			}
			cell.item:render(data)
			return cell
		end

		tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
	    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
		tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
		tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
		tableView:reloadData()
		return tableView
	end

	self.list = createList()
	self.listViewContainer:addChild(self.list)

	self:createTimer1()
	self:updateLeftDiamond()
end

function HeroicRacingDialog:updateList()
	if self.list ~= nil then
		self.userList = self.model:getHeroicRacingUserList()
		self:updateLeftDiamond()
		self.list:reloadData()
	end
end

function HeroicRacingDialog:updateLeftDiamond( )
	self.leftDiamondTxt:setString(self.model:getHeroicRacingLeftDiamond())
end

--创建定时器1
function HeroicRacingDialog:createTimer1()
    local remainTime1 = self.model:getHeroicRacingLeftTime()
   print(remainTime1.."-=-=123123-=-=-=")
    if remainTime1 <=0 then 
        self:clearTimer()
        self:updateLeftTime(0)
        return
    end
    if self.timer1 == nil then
        self.timer1 = qy.tank.utils.Timer.new(1,remainTime1,function(leftTime)
            self:updateLeftTime(leftTime)
        end)
        self.timer1:start()
    end
    self:updateLeftTime(remainTime1)
end

--更新剩余时间
function HeroicRacingDialog:updateLeftTime( leftTime)
    if leftTime == 0 then        
        self:clearTimer()
        self.timeTxt:setString(""..leftTime)
    else
       local timeStr = qy.tank.utils.DateFormatUtil:toDateString(leftTime , 1)
        self.timeTxt:setString(timeStr)
    end
end

-- 清除时钟
function HeroicRacingDialog:clearTimer( )
    if self.timer1 ~=nil then
        self.timer1:stop()
    end   
    
    self.timer1 = nil
end

function HeroicRacingDialog:onExit()
    self:clearTimer()
end

return HeroicRacingDialog