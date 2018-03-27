

local SystemPacketDialog = qy.class("SystemPacketDialog", qy.tank.view.BaseDialog, "newyear_redpacket/ui/SystemPacketDialog")

local model = qy.tank.model.RedPacketModel
local service = qy.tank.service.RedPacketService

function SystemPacketDialog:ctor(delegate)
    SystemPacketDialog.super.ctor(self)
	self:InjectView("yilingqu")
	self:InjectView("shengyu")
	self:InjectView("lingquimg")
	self:InjectView("miaoshu")--红包描述
	self:InjectView("bg")
	self:InjectView("titletext")
	self:InjectView("titleimg")
	self:InjectView("icon")--头像
 
   
	self:OnClick("closeBt", function(sender)
        self:removeSelf()
    end)
    self.delegate = delegate
    self.data = delegate.data
    self.type = delegate.type
    self.flag = false
    self.redtype = delegate.redtype
    self:update()
    self.list = self:__createList()
    self.bg:addChild(self.list)
    

end
function SystemPacketDialog:update()
	if self.data.status == 2 or self.data.status == 3 then
		self.lingquimg:setVisible(true)
	else
		self.lingquimg:setVisible(false)
	end
	local png = "Resources/user/icon_"..self.data.sender_headicon..".png"
	self.icon:loadTexture(png)
	self.miaoshu:setString(self.delegate.content)
	if self.type == 2 then
		self.titleimg:setVisible(true)
		self.titletext:setVisible(false)
	else
		self.titleimg:setVisible(false)
		self.titletext:setVisible(true)
		if self.redtype == 1 then
			self.titletext:setString(self.data.sender_name.."的定额红包")
		else
			self.titletext:setString(self.data.sender_name.."的拼手气红包")
		end
	end
	self.yilingqu:setString("个数领取"..self.data.already_dole.."/"..self.data.total_num)
	self.shengyu:setString("金额剩余"..self.data.surplus_diamond.."/"..self.data.total_diamond)
	if self.data.already_dole == self.data.total_num then
		self.flag = true
	else
		self.flag = false
	end

 
     
end
function SystemPacketDialog:__createList(_idx)
	local tableView = cc.TableView:create(cc.size(400, 290))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setPosition(150,35)
	tableView:setDelegate()
	-- print("红包列表",json.encode(self.data.clist[1]))
	-- print("红包列表",#(self.data.clist))
	local function numberOfCellsInTableView(table)
		 return #(self.data.clist)
	end

	local function tableCellTouched(table,cell)
	end

	local function cellSizeForTable(tableView, idx)
		return 400, 33
	end

	local function tableCellAtIndex(table, idx)
		local cell = table:dequeueCell()
		local item
		if nil == cell then
			cell = cc.TableViewCell:new()
			item = require("newyear_redpacket.src.SystemCell").new({
				["data"]= self.data.clist,
				["type"]= self.redtype,
				["flag"]= self.flag
				})
			cell:addChild(item)
			cell.item = item
		end
		cell.item.idx = idx
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
function SystemPacketDialog:onEnter()
     
end

function SystemPacketDialog:onExit()
  
end


return SystemPacketDialog
