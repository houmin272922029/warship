

local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "newyear_redpacket/ui/MainDialog")

local model = qy.tank.model.RedPacketModel
local service = qy.tank.service.RedPacketService

function MainDialog:ctor(delegate)
    MainDialog.super.ctor(self)
    self.model = qy.tank.model.OperatingActivitiesModel
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync(qy.ResConfig.HONGBAO)
	self:InjectView("closeBt")
	self:InjectView("jilu")--红包记录
	self:InjectView("help")
	self:InjectView("time")

	for i=1,5 do
        self:InjectView("Bt"..i)
    end
    for i=1,2 do
    	 self:InjectView("dian"..i)
    	 self["dian"..i]:setVisible(false)
    end
     for i=1,3 do
    	 self:InjectView("pannel"..i)
    	 self["pannel"..i]:setVisible(false)
    end
    for i=1,8 do
        self:InjectView("hongbao"..i)
        self:InjectView("title"..i)
    end
    self:InjectView("shuaxin")--刷新按钮
    self:InjectView("fagongbao")--发红包
    self:InjectView("fagongbao2")--发幸运红包

    self:InjectView("awardnum")--奖励数
    self:InjectView("awardrank")--我的排名
    self:InjectView("lingqu")--
    self:InjectView("lingqu2")
    self:InjectView("yilingqu")
    self:InjectView("icon")
    self:InjectView("Panel_2")

    self:OnClick("help",function ( sender )
    	qy.tank.view.common.HelpDialog.new(qy.tank.model.HelpTxtModel:getHelpDataByIndx(38)):show(true)
    end)
    self:OnClick("Bt1",function ( sender )
    	self:choosedayBt(1)
    end)
     self:OnClick("Bt2",function ( sender )
    	self:choosedayBt(2)
    end)
    self:OnClick("Bt3",function ( sender )
    	self:choosedayBt(3)
    end)
    self:OnClick("Bt4",function ( sender )
	 	if qy.tank.model.UserInfoModel.userInfoEntity.legionName ~= qy.TextUtil:substitute(90019) then
            self:choosedayBt(4)
        else
            qy.hint:show(qy.TextUtil:substitute(90020))
        end
    end)
    self:OnClick("Bt5",function ( sender )
    	service:getAward(idx,"p",function ( data )
			self.ranklist = model.rank_list
			self:choosedayBt(5)
		end)
    end)
	self:OnClick("closeBt", function(sender)
        self:removeSelf()
    end)
    self:OnClick("jilu", function(sender)
    	service:getRankList("xx",1,function ( datas )
    		local dialog = require("newyear_redpacket.src.PacketHistory").new({
    			["data"]= datas,
    			})
        	dialog:show(true)
    	end)
        
    end)
    self:OnClick("shuaxin",function ( sender )
    	service:shuaxin(self.range,"s",function ( data )
			self:updatepannels(self.chooseday)
		end)
    end)
    self:OnClick("fagongbao",function ( sender )
    	if qy.tank.model.UserInfoModel.userInfoEntity.level <= 60 or qy.tank.model.UserInfoModel.userInfoEntity.vipLevel < 5 then
    		qy.hint:show("达到VIP5且等级大于60级享有发红包的特权")
    		return
    	end
    	if model.end_time - qy.tank.model.UserInfoModel.serverTime <= 0 then
         	qy.hint:show("活动已结束")
         	return
     	end
    	local dialog = require("newyear_redpacket.src.FightluckDialog").new({
    		["range"] = self.range,
    		["callback"] = function ( )
    			print("shuaxina==================== 2222",self.chooseday)
    			self:updatepannels(self.chooseday)
    		end
    		})
        dialog:show(true)
    end)
    self:OnClick("fagongbao2",function ( sender )
    	if qy.tank.model.UserInfoModel.userInfoEntity.level <= 60 or qy.tank.model.UserInfoModel.userInfoEntity.vipLevel < 5 then
    		qy.hint:show("达到VIP5且等级大于60级享有发红包的特权")
    		return
    	end
    	if model.end_time - qy.tank.model.UserInfoModel.serverTime <= 0 then
         	qy.hint:show("活动已结束")
         	return
     	end
    	local dialog = require("newyear_redpacket.src.LuckyPacket").new({
    		["range"] = self.range,
    		["type"] = 3,
    		["callback"] = function ( )
    			print("shuaxina==================== ",self.chooseday)
    			self:updatepannels(self.chooseday)
    		end
    		})
        dialog:show(true)
    end)
    self:OnClick("hongbao1",function ( sender )
    	self:openeveryaward(1)
    end)
    self:OnClick("hongbao2",function ( sender )
    	self:openeveryaward(2)
    end)
    self:OnClick("hongbao3",function ( sender )
    	self:openeveryaward(3)
    end)
    self:OnClick("hongbao4",function ( sender )
    	self:openeveryaward(4)
    end)
    self:OnClick("hongbao5",function ( sender )
    	self:openeveryaward(5)
    end)
    self:OnClick("hongbao6",function ( sender )
    	self:openeveryaward(6)
    end)
    self:OnClick("hongbao7",function ( sender )
    	self:openeveryaward(7)
    end)
    self:OnClick("hongbao8",function ( sender )
    	self:openeveryaward(8)
    end)
    self:OnClick("lingqu",function ( sender )
    	--领奖
    	service:getRankAward(function ( data )
    		self.lingqu:setVisible(false)
    		self.lingqu2:setVisible(false)
    		self.yilingqu:setVisible(true)
    		self.dian2:setVisible(false)
    	end)
    	
    end)
    self:OnClick("lingqu2",function ( sender )
    	if self.touchflag == 1 then
    		qy.hint:show("未到领奖时间") 
    	else
    		qy.hint:show("未上榜") 
    	end
    end)
	self.day = 1
	self.touchflag = 0
	self.every_award_list = model.every_award_list
	self.chooseday = 0
	self.range = 0
	self.pannelsdata = {}
	self:choosedayBt(1)
	self:updatepannel1()
	self:updateredpoint()--刷新红点方法
	self:updateredpoint2()
	self:updaterange()

	
    
end
function MainDialog:updaterange(  )
	if self.chooseday == 2 then
		self.range = 0
	elseif self.chooseday == 3 then
		self.range =1
	else
		self.range = 2
	end
end
function MainDialog:__showEffert2(id)
    local currentEffert = nil
    local isEffertShow1 = false
    if currentEffert == nil then
        currentEffert = ccs.Armature:create("ui_fx_hongbao")
        self["hongbao"..id]:addChild(currentEffert,888,888)
        -- currentEffert:setScale(1.25)
        local size = self["hongbao"..id]:getContentSize()
        currentEffert:setPosition(size.width/2,size.height/2)
    end

    currentEffert:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
        if movementType == ccs.MovementEventType.complete then
            isEffertShow1 = false
        end
    end)
    if not self.isEffertShow1 then
        isEffertShow1 = true
        currentEffert:getAnimation():playWithIndex(0)
    end
    currentEffert = nil
end
function MainDialog:updateredpoint2( )
	--第二个
	if model.award_time <= qy.tank.model.UserInfoModel.serverTime then
		if model.share_list.award_status == 1 then
			self.dian2:setVisible(true)
		else
			self.dian2:setVisible(false)
		end
	else
		self.dian2:setVisible(false)
	end
end
function MainDialog:updateredpoint(  )
	--刷新第一个红点
	self.dian1:setVisible(false)
	for i=1,model.nowday do
		if self.every_award_list[tostring(i)] == 1 then
			self.dian1:setVisible(true)
			return
		end
	end
	

end
function MainDialog:openeveryaward( idx )
	if self.every_award_list[tostring(idx)] == -1 then
		qy.hint:show("已经领取完了")
		return
	end
	if self.every_award_list[tostring(idx)] == 0 then
		qy.hint:show("未到领奖时间")
		return
	end
	service:getAward(idx,"e",function ( data )
		print("回来啦")
		self.every_award_list[tostring(idx)] = -1
		self:updatepannel1()
		self:updateredpoint()--刷新红点
	end)
end
function MainDialog:updatepannel1( )
	for i=1,8 do
		if self["hongbao"..i]:getChildByTag(888) then
        	self["hongbao"..i]:removeChildByTag(888,true)
    	end
        self["title"..i]:setString(model.newyearawardcfg[tostring(i)].desc)
        if self.every_award_list[tostring(i)] == -1 then
        	self["hongbao"..i]:loadTexture("newyear_redpacket/res/open.png",1)
        elseif self.every_award_list[tostring(i)] == 1 then
        	self["hongbao"..i]:loadTexture("newyear_redpacket/res/meilingqu.png",1)
        	self:__showEffert2(i)
        else
        	self["hongbao"..i]:loadTexture("newyear_redpacket/res/meilingqu.png",1)
        end
    end
end
function MainDialog:updatepannels( flags )
	print("lllllllllllllll",flags)
    self.Panel_2:removeAllChildren(true)
    self.pannellist = {}
	self.pannellist = self:__createList(flags)
	self.Panel_2:addChild(self.pannellist)
end
function MainDialog:updatepannel3(  )
	if model.share_list.self_rank == -1 then
		self.awardnum:setString("未上榜")
		self.awardrank:setString("未上榜")
		self.icon:setVisible(false)
	else
		self.awardrank:setString(model.share_list.self_rank.."名")
		if model.share_list.self_rank <= #self.ranklist then
			self.awardnum:setString(model.rankcfg[tostring(model.share_list.self_rank)].award[1].num)
			self.icon:setVisible(true)
		else
			self.awardnum:setString("未上榜")
			self.icon:setVisible(false)
		end
	end
	if model.award_time <= qy.tank.model.UserInfoModel.serverTime then
		if model.share_list.award_status == -1 then
			self.lingqu:setVisible(false)
    		self.yilingqu:setVisible(true)
    		self.lingqu2:setVisible(false)
		elseif model.share_list.award_status == 0 then
			self.lingqu:setVisible(false)
    		self.yilingqu:setVisible(false)
    		self.lingqu2:setVisible(true)
    		self.touchflag = 2
		else
			self.lingqu:setVisible(true)
    		self.yilingqu:setVisible(false)
    		self.lingqu2:setVisible(false)
		end
	else
		self.lingqu:setVisible(false)
    	self.yilingqu:setVisible(false)
    	self.lingqu2:setVisible(true)
    	self.touchflag = 1
	end
	self.pannellist3 = {}
	self.pannellist3 = self:__createList2()
	if self.pannel3:getChildByTag(888) then
        self.pannel3:removeChildByTag(888,true)
    end
	self.pannel3:addChild(self.pannellist3,888,888)
end
function MainDialog:choosedayBt( day )
	if self.chooseday ~= day then
		self.chooseday = day
		self:updateDayBt(day)
		self:updaterange()
		if day == 1 then
			self.pannel1:setVisible(true)
			self.pannel2:setVisible(false)
			self.pannel3:setVisible(false)
		elseif day == 5 then
			self.pannel1:setVisible(false)
			self.pannel2:setVisible(false)
			self.pannel3:setVisible(true)
			self:updatepannel3()
		elseif day == 2 then
			self.fagongbao:setVisible(false)
			self.fagongbao2:setVisible(false)
			self:updatepannels(day)
			self.pannel1:setVisible(false)
			self.pannel2:setVisible(true)
			self.pannel3:setVisible(false)
		else
			self.fagongbao:setVisible(true)
			self.fagongbao2:setVisible(true)
			self:updatepannels(day)
			self.pannel1:setVisible(false)
			self.pannel2:setVisible(true)
			self.pannel3:setVisible(false)
		end
	end
end
function MainDialog:updateDayBt(day)
	for i=1,5 do
		if i == day then
			self["Bt"..i]:loadTexture("newyear_redpacket/res/anniuhuang.png",1)
		else
			self["Bt"..i]:loadTexture("newyear_redpacket/res/anniuhong.png",1)
		end
	end
end

function MainDialog:__createList(_idx)
	local tableView = cc.TableView:create(cc.size(580, 400))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setPosition(10,75)
	tableView:setDelegate()
	
	if _idx == 2 then
		self.pannelsdata = model.red_pack_list_system
	elseif _idx == 3 then
		self.pannelsdata = model.red_pack_list_world
	else
		self.pannelsdata = model.red_pack_list_legion
	end
	local tempnum = #self.pannelsdata
	local function numberOfCellsInTableView(table)
		 return math.ceil(tempnum/4)
	end

	local function tableCellTouched(table,cell)
	end

	local function cellSizeForTable(tableView, idx)
		return 580, 180
	end

	local function tableCellAtIndex(table, idx)
		local cell = table:dequeueCell()
		local item
		if nil == cell then
			cell = cc.TableViewCell:new()
			item = require("newyear_redpacket.src.RedPacketCell").new({
				["num"]= math.ceil(tempnum/4),
				["data"] = self.pannelsdata,
				["type"] = _idx,
				["callback"]=function (  )
					print("领完刷新")
					local listCury = self.pannellist:getContentOffset()
					self.pannellist:reloadData()
					self.pannellist:setContentOffset(listCury)--设置滚动距离
					
				end
				})
			cell:addChild(item)
			cell.item = item
		end
		cell.item.idx = idx
		cell.item:render(idx + 1,tempnum%4)
		return cell
	end

	tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
	tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
	tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
	tableView:reloadData()
	return tableView
end
function MainDialog:__createList2()
	local tableView = cc.TableView:create(cc.size(580, 360))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setPosition(10,60)
	tableView:setDelegate()

	local function numberOfCellsInTableView(table)
		 return #self.ranklist
	end

	local function tableCellTouched(table,cell)
	end

	local function cellSizeForTable(tableView, idx)
		return 580, 35
	end

	local function tableCellAtIndex(table, idx)
		local cell = table:dequeueCell()
		local item
		if nil == cell then
			cell = cc.TableViewCell:new()
			item = require("newyear_redpacket.src.RankCell").new({
				["data"] = self.ranklist
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
function MainDialog:onEnter()
	if model.end_time - qy.tank.model.UserInfoModel.serverTime <= 0 then
         self.time:setString("活动已结束")
    else
    	self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(model.end_time - qy.tank.model.UserInfoModel.serverTime, 7))
    	self.listener_1 = qy.Event.add(qy.Event.BONUS_TIME,function(event)
        self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(model.end_time - qy.tank.model.UserInfoModel.serverTime, 7))
        if model.end_time - qy.tank.model.UserInfoModel.serverTime <= 0 then
         	self.time:setString("活动已结束")
     	end
    end)
    end
     
end

function MainDialog:onExit()
  	qy.Event.remove(self.listener_1)
end


return MainDialog
