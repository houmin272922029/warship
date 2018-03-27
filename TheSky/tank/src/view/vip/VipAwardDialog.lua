--[[
	VIP每日津贴
	Author: Aaron Wei
	Date: 2015-06-11 11:43:23	
]]

local VipAwardDialog = qy.class("VipAwardDialog", qy.tank.view.BaseDialog, "view/vip/VipAwardDialog")

function VipAwardDialog:ctor(delegate)
    VipAwardDialog.super.ctor(self)

	self:setCanceledOnTouchOutside(true)
    -- 内容样式
    self.delegate = delegate
    self.model = qy.tank.model.VipModel
    self.userInfo = qy.tank.model.UserInfoModel
    
    self:InjectView("panel")
    self:InjectView("vipLevel")
    self:InjectView("getAwardBtn")
    self:InjectView("getAwardIcon")
    self:InjectView("vipTip")

    self:OnClick("closeBtn", function(sender)
        self:dismiss()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE,["isScale"] = false})

    local h = 320
    local tableView = cc.TableView:create(cc.size(710,h))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(192,256)
    self.panel:addChild(tableView)
    tableView:setDelegate()

    local function numberOfCellsInTableView(table)
        return #self.model.list
    end

    local function tableCellTouched(table,cell)
        print("cell touched at index: " .. cell:getIdx())
    end

    local function cellSizeForTable(tableView, idx)
        return 760, 76
    end

    local function tableCellAtIndex(table, idx)
        local strValue = string.format("%d",idx)
        local cell = table:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()
            local item = qy.tank.view.vip.VipAwardCell.new()
            cell:addChild(item)
            cell.item = item
        end
        cell.item:render(self.model.list[idx+1]) 
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()

    local vip_level = self.userInfo.userInfoEntity.vipLevel
    if vip_level > 0 then
        self.awardList = qy.AwardList.new({
            ["award"] =  self.model.awardList[vip_level].daily_award,
            ["hasName"] = false,
            ["type"] = 1,
            ["cellSize"] = cc.size(120,120),
            ["itemSize"] = 2, 
        })
        self.awardList:setPosition(270,275)
        self.panel:addChild(self.awardList)
        self.vipTip:setVisible(false)
        
        if self.userInfo.userInfoEntity.isDrawDaily then
            self.getAwardBtn:setTitleText(qy.TextUtil:substitute(39002))
            self.getAwardBtn:setVisible(false)
            self.getAwardIcon:setVisible(true)
        else
            self.getAwardBtn:setTitleText(qy.TextUtil:substitute(39001))
            self.getAwardBtn:setVisible(true)
            self.getAwardIcon:setVisible(false)
        end
    else
        self.vipTip:setVisible(true)
        self.getAwardBtn:setTitleText(qy.TextUtil:substitute(37019))
        self.getAwardBtn:setVisible(true)
        self.getAwardIcon:setVisible(false)
    end
    self.vipLevel:setString("VIP"..tostring(vip_level))

    self:OnClick("getAwardBtn", function (sendr)
        if self.getAwardBtn:getTitleText() == qy.TextUtil:substitute(39001) then
            local service = qy.tank.service.VipService:new()
            service:drawDailyAward(self.userInfo.userInfoEntity.vipLevel,function(data)
                qy.tank.command.AwardCommand:add(data.award)
                qy.tank.command.AwardCommand:show(data.award)
                self.userInfo.userInfoEntity.isDrawDaily_:set(true)
                self.getAwardBtn:setTitleText(qy.TextUtil:substitute(39002))
                self.getAwardBtn:setVisible(false)
                self.getAwardIcon:setVisible(true)
            end)
        elseif self.getAwardBtn:getTitleText() == qy.TextUtil:substitute(39002) then
            qy.hint:show(qy.TextUtil:substitute(39003))
        else
            qy.tank.command.MainCommand:viewRedirectByModuleType("vip")
            self:dismiss()
        end
    end)
end

function VipAwardDialog:onEnter()
end

function VipAwardDialog:onEnterFinish()
end

function VipAwardDialog:onCleanup()
    print("VipAwardDialog:onCleanup")
    qy.tank.utils.cache.CachePoolUtil.removePlist("Resources/vip/vip",1)
end
function VipAwardDialog:onExit()
    -- cc.Director:getInstance():getTextureCache():removeAllTextures()
end

return VipAwardDialog