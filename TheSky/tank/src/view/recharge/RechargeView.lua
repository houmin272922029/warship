--[[
	充值
	Author: H.X.Sun
	Date: 2015-09-22
]]

local RechargeView = qy.class("RechargeView", qy.tank.view.BaseView, "view/recharge/RechargeView")

function RechargeView:ctor(delegate)
    RechargeView.super.ctor(self)

    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "Resources/common/title/recharge_title.png",
        ["onExit"] = function()
            if delegate and delegate.dismiss then
                delegate.dismiss()
            end
        end
    })
    self:addChild(style, 13)

	self:InjectView("panel")
    self:InjectView("lsitNode")
    self:InjectView("next_vip")
    self:InjectView("need_diamond")
    self:InjectView("diamond_icon")
    self:InjectView("rechargeLabel")
	self:InjectView("rechargeBar")
    self:InjectView("privilegeBtn")
    self:InjectView("progressBarBg")

	local isVipView = false
	if delegate and delegate.isVipView then
		isVipView = delegate.isVipView
	end

    self.model = qy.tank.model.RechargeModel
	self.vipModel = qy.tank.model.VipModel
    self.userInfoEntity = qy.tank.model.UserInfoModel.userInfoEntity

	self.paymentList = self:createList()
    self.lsitNode:addChild(self.paymentList)

    self:OnClick("exitBtn", function(sender)
        if delegate and delegate.dismiss then
            delegate.dismiss()
        end
    end,{["audioType"] = qy.SoundType.BTN_CLOSE,["isScale"] = false})

	self:OnClick("toLeft", function(sender)
        self:moveAreaLogic(2)
    end)

    self:OnClick("toRight", function(sender)
        self:moveAreaLogic(1)
    end)

    self:OnClick("privilegeBtn", function(sender)
    	if isVipView then
    		delegate.dismiss()
    	else
        	qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.VIP, {["isRechargeView"] = true})
    	end
    end)

    self.vip = qy.tank.view.common.VipNode.new()
    self.vip:setPosition(qy.InternationalUtil:getRechargeViewVip(),qy.winSize.height - 150)
    self.panel:addChild(self.vip)


    qy.Event.dispatch(qy.Event.BEAT_ENEMY)
end

function RechargeView:createList()
	self.num = math.ceil(self.model:getPaymentDataNum() / 2)

    local tableView = cc.TableView:create(cc.size(982, 470))
    tableView:setDirection(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(cc.p(-491, -217))

    local function numberOfCellsInTableView(tableView)
        return self.num
    end

    local function cellSizeForTable(tableView, idx)
        return 305, 470
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.recharge.RechargeCell.new({
                ["isTouchMoved"] = function()
                    return tableView:isTouchMoved()
                end,
            })
            cell:addChild(item)
            cell.item = item
        end

        cell.item:render(idx)

        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)

    tableView:reloadData()

    return tableView
end

--移动逻辑 param _type 1：左移 2：右移
function RechargeView:moveAreaLogic(_type)
    local listCurX = math.abs(self.paymentList:getContentOffset().x)
    local _w = 305
    local listMaxX = _w * (self.num - 3) - 60

    if _type == 1 then
        if listCurX < listMaxX then
            --向上取值
            local nextX = (math.ceil(listCurX / _w ) + 1) * _w
            if nextX > listMaxX then
                self.paymentList:setContentOffset(cc.p(-listMaxX ,0), true)
            else
                self.paymentList:setContentOffset(cc.p(-nextX ,0), true)
            end
        end
    else
        if listCurX > 0 then
            --向下取值
            local nextIdx = math.floor(listCurX / _w ) - 1
            if nextIdx < 0 then
                self.paymentList:setContentOffset(cc.p(0 ,0), true)
            else
                self.paymentList:setContentOffset(cc.p(-_w * nextIdx ,0), true)
            end
        end
    end
end

function RechargeView:renderInfo()
    local vip_level = self.userInfoEntity:get("vipLevel")
    if vip_level == nil or vip_level <= 0 then
        vip_level = 0
    end

    if qy.language == "cn" then
        local current_diamond,next_diamond
        current_diamond = self.userInfoEntity.payment_diamond_added
        print("self.userInfoEntity.payment_diamond_added ==".. current_diamond)
        if vip_level < #self.vipModel.list then
            next_diamond = tonumber(vip_level < #self.vipModel.list and self.vipModel.list[vip_level+1].diamond or 0)
            self.next_vip:setString(qy.TextUtil:substitute(27003)..(vip_level+1).." "..qy.TextUtil:substitute(27004))
            self.need_diamond:setString(next_diamond-current_diamond)
            self.diamond_icon:setVisible(true)
            self.need_diamond:setVisible(true)
            -- self.rechargeLabel:setVisible(true)
            self.rechargeBar:setPercent(current_diamond/next_diamond*100)
        else
            self.next_vip:setString(qy.TextUtil:substitute(27005))
            self.diamond_icon:setVisible(false)
            self.need_diamond:setVisible(false)
            next_diamond = tonumber(self.vipModel.list[self.vipModel:getMAxVipLevel()].diamond)
            -- self.rechargeLabel:setVisible(false)
            self.rechargeBar:setPercent(100)
        end
        print("本级内已充值     " .. tostring(current_diamond).."/"..tostring(next_diamond))
        self.rechargeLabel:setString(qy.TextUtil:substitute(27006) .. "     " .. tostring(current_diamond).."/"..tostring(next_diamond))
    elseif qy.language == "en" then
        local current_money, next_money
        current_money = self.userInfoEntity.amount
        next_money = tonumber(vip_level < #self.vipModel.list and self.vipModel.list[vip_level+1].price or 0 )
        self.diamond_icon:setVisible(false)
        if vip_level < #self.vipModel.list then
            self.next_vip:setString(qy.TextUtil:substitute(39008)..(vip_level+1).." "..qy.TextUtil:substitute(39009))
            self.need_diamond:setString("$"..(string.format("%.2f", next_money-current_money)))
            self.rechargeBar:setPercent(current_money/next_money*100)
        else
            self.next_vip:setString(qy.TextUtil:substitute(39010))
            self.need_diamond:setString("")
            self.rechargeBar:setPercent(100)
        end
        self.rechargeLabel:setString(qy.TextUtil:substitute(39011) .. "     $" .. tostring(current_money).."/$"..tostring(next_money))
    end

    self:dealAuditLogic()
end

function RechargeView:onEnter()
    self:renderInfo()
    self.listener = qy.Event.add(qy.Event.USER_RECHARGE_DATA_UPDATE,function(event)
        self:renderInfo()
    end)
    self:dealAuditLogic()
end

function RechargeView:dealAuditLogic()
    if qy.isAudit and qy.product == "sina" then
        self.privilegeBtn:setVisible(false)
        self.vip:setVisible(false)
        self.next_vip:setVisible(false)
        self.diamond_icon:setVisible(false)
        self.need_diamond:setVisible(false)
        self.progressBarBg:setVisible(false)
    end
end

function RechargeView:onExit()
    qy.Event.remove(self.listener)
    self.listener = nil
end

return RechargeView
