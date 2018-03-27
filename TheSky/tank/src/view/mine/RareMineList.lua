--[[--
--稀有矿列表
--Author: H.X.Sun
--Date: 2015-05-25
--]]--

local RareMineList = qy.class("RareMineList", qy.tank.view.BaseView)

function RareMineList:ctor(delegate)
    RareMineList.super.ctor(self)

	self.delegate = delegate
	self.model = qy.tank.model.MineModel
    self:_initRareMineViewList()
end

--[[--
--初始化稀有矿视图列表
--]]
function RareMineList:_initRareMineViewList()
	self.mineViewList = {}
	local cell = nil
	local column = 0 --列
	local row = 0 --行
	self._w = 400
	self._h = 200
	self._x = qy.winSize.width / 2 - self._w
	self._y = qy.winSize.height / 2 - self._h
	-- print("qy.winSize.width ==" .. qy.winSize.width)
	-- print("qy.winSize.height ==" .. qy.winSize.height)
	for i = 1, 9 do
		cell = qy.tank.view.mine.RareMineCell.new({
			["updateOil"] = function ()
				self.delegate:updateOil()
			end,
			["refreshPage"] = function ()
				self.delegate:refreshPage()
			end
			})
		table.insert(self.mineViewList, cell)
		cell:setAnchorPoint(0.5, 0.5)
		self:addChild(cell)

		column = (i - 1) % 3
		row = math.ceil(i / 3) - 1
		cell:setPosition(self._x + column * self._w , self._y + row * self._h)
	end
end

function RareMineList:updateList()
	local list = self.model:getMineList()
	for i = 1, #self.mineViewList do
		self.mineViewList[i]:updateCell(i)
	end

	if #list < 9 then
		self.mineViewList[8]:setPosition(self._x + 2 * self._w , self._y + 2 * self._h)
		self.mineViewList[5]:setPosition(self._x +  self._w , self._y + self._h + 85)
	else
		self.mineViewList[5]:setPosition(self._x +  self._w , self._y +  self._h)
		self.mineViewList[8]:setPosition(self._x + 1 * self._w , self._y + 2 * self._h)
	end
end

return RareMineList