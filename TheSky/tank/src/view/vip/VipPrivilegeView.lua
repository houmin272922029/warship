--[[
	VIP特权
	Author: Aaron Wei
	Date: 2015-06-11 11:51:03
]]

local VipPrivilegeView = qy.class("VipPrivilegeView", qy.tank.view.BaseView, "view/vip/VipPrivilegeView")

local ONE_CELL_W = 988

function VipPrivilegeView:ctor(delegate)
    VipPrivilegeView.super.ctor(self)

    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "Resources/common/title/vip_privilege_title.png",
        ["onExit"] = function()
            if delegate and delegate.dismiss then
                delegate.dismiss()
            end
        end
    })
    self:addChild(style, 13)

    self.delegate = delegate
    self.userInfo = qy.tank.model.UserInfoModel
    self.model = qy.tank.model.VipModel

    self:InjectView("panel")
    self:InjectView("vip_level")
    self:InjectView("next_vip")
    self:InjectView("need_diamond")
    self:InjectView("diamond_icon")
    self:InjectView("rechargeBar")
    self:InjectView("rechargeLabel")
    self:InjectView("info_bg")
    self.panel:setSwallowTouches(false)

    self:OnClick("rechargeBtn", function(sender)
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.RECHARGE, {["isVipView"] = true})
    end)

    self:OnClick("toLeft", function(sender)
        self:moveAreaLogic(1)
    end)

    self:OnClick("toRight", function(sender)
        self:moveAreaLogic(2)
    end)

    local tableView = cc.TableView:create(cc.size(988, 497))
    tableView:setDirection(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(10,0)
    self.info_bg:addChild(tableView)
    tableView:setDelegate()
    self.vipIdx = 1

    local function numberOfCellsInTableView(table)
        return #self.model.list
    end

    local function tableCellTouched(table,cell)
        print("cell touched at index: " .. cell:getIdx())
    end

    local function cellSizeForTable(tableView, idx)
        return ONE_CELL_W, 497
    end

    local function tableCellAtIndex(table, idx)
        local strValue = string.format("%d",idx)
        local cell = table:dequeueCell()
        local item = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.vip.VipPrivilegeCell.new()
            cell:addChild(item)
            cell.item = item
        end
        cell.item:render(idx+1)
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)

    tableView:reloadData()
    tableView:setTouchEnabled(false)
    self.p_list = tableView
    if delegate and delegate.index and tonumber(delegate.index) > -1 then
        self:moveAreaLogic(2, tonumber(delegate.index) - 1, false)
    else
        self:moveAreaLogic(2,self.model:getShowPrivileIndex()-1,false)
    end

end

--移动逻辑 param _type 1：左移 2：右移
--_num:移动的格数,默认是1
function VipPrivilegeView:moveAreaLogic(_type,_num,_isAnim)
    if self.lastListX == nil then
        self.lastListX = self.p_list:getContentOffset().x
    else
        if math.abs(self.lastListX - self.p_list:getContentOffset().x) > 20 then
            return
        end
    end
    local _w = ONE_CELL_W
    if _num == nil then
        _num = 1
    elseif _num >= self.model:getMAxVipLevel() then
        _num = self.model:getMAxVipLevel() - 1
    end
    if _isAnim == nil then
        _isAnim =  true
    end
    if _type == 1 then
        --左
        if self.vipIdx > 1 then
            self.vipIdx = self.vipIdx - _num
            self.lastListX = self.lastListX + _w * _num
        end
    else
        if self.vipIdx < self.model:getMAxVipLevel() then
            self.vipIdx = self.vipIdx + _num
            self.lastListX = self.lastListX - _w * _num
        end
    end
    self:changeCellBg()
    self.p_list:setContentOffset(cc.p(self.lastListX ,0), _isAnim)
end

function VipPrivilegeView:changeCellBg()
    -- if self.vipIdx == 5 then
    --     self.info_bg:setTexture("Resources/vip/VIP_5_bg.jpg")
    -- elseif self.vipIdx == 8 then
    --     self.info_bg:setTexture("Resources/vip/VIP_8_bg.jpg")
    -- elseif self.vipIdx == 10 then
    --     self.info_bg:setTexture("Resources/vip/VIP_10_bg.jpg")
    -- elseif self.vipIdx == 12 then
    --     self.info_bg:setTexture("Resources/vip/VIP_12_bg.jpg")
    -- else
        self.info_bg:setTexture("Resources/common/bg/VIP_img_0001.jpg")
    --end
end

function VipPrivilegeView:renderInfo()
    local vip_level = self.userInfo.userInfoEntity:get("vipLevel")
    if vip_level == nil or vip_level <= 0 then
        vip_level = 0
        self.vip_level:setString(qy.TextUtil:substitute(39007))
    else
        self.vip_level:setString("VIP"..tostring(self.userInfo.userInfoEntity:get("vipLevel")))
    end

    if qy.language == "cn" then
        local current_diamond,next_diamond
        current_diamond = self.userInfo.userInfoEntity.payment_diamond_added
        if vip_level < #self.model.list then
            next_diamond = tonumber(vip_level < #self.model.list and self.model.list[vip_level+1].diamond or 0)
            self.next_vip:setString(qy.TextUtil:substitute(39008)..(vip_level+1)..qy.TextUtil:substitute(39009))
            self.need_diamond:setString(next_diamond-current_diamond)
            self.diamond_icon:setVisible(true)
            self.need_diamond:setVisible(true)
            self.rechargeBar:setPercent(current_diamond/next_diamond*100)
        else
            self.next_vip:setString(qy.TextUtil:substitute(39010))
            next_diamond = tonumber(self.model.list[self.model:getMAxVipLevel()].diamond)
            self.diamond_icon:setVisible(false)
            self.need_diamond:setVisible(false)
            self.rechargeBar:setPercent(100)
        end
        self.rechargeLabel:setString(qy.TextUtil:substitute(39011) .. "     " .. tostring(current_diamond).."/"..tostring(next_diamond))
        -- self.rechargeLabel:setString(tostring(current_diamond).."/"..tostring(next_diamond))
    elseif qy.language == "en" then
        local current_money, next_money
        current_money = self.userInfo.userInfoEntity.amount
        next_money = tonumber(vip_level < #self.model.list and self.model.list[vip_level+1].price or 0)
        self.diamond_icon:setVisible(false)
        if vip_level < #self.model.list then
            self.next_vip:setString(qy.TextUtil:substitute(39008)..(vip_level+1).." "..qy.TextUtil:substitute(39009))
            self.need_diamond:setString("$"..(next_money-current_money))
            self.rechargeBar:setPercent(current_money/next_money*100)
        else
            self.next_vip:setString(qy.TextUtil:substitute(39010))
            self.need_diamond:setString("")
            self.rechargeBar:setPercent(100)
        end
        self.rechargeLabel:setString(qy.TextUtil:substitute(39011) .. "     $" .. tostring(current_money).."/$"..tostring(next_money))
    end
end

function VipPrivilegeView:onEnter()
    self:renderInfo()
    self.updateVipListener = qy.Event.add(qy.Event.USER_RECHARGE_DATA_UPDATE,function(event)
        self:renderInfo()
    end)
end

function VipPrivilegeView:onExit()
    qy.Event.remove(self.updateVipListener)
end

function VipPrivilegeView:onCleanup()
    print("VipPrivilegeView:onCleanup")
    qy.tank.utils.cache.CachePoolUtil.removePlist("Resources/vip/vip",1)
end

return VipPrivilegeView
