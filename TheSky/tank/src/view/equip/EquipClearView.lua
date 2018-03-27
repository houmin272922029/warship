--[[--

--Author: Fu.Qiang 
--]]--


local EquipClearView = qy.class("EquipClearView", qy.tank.view.BaseView, "view/equip/EquipClearView")

local model = qy.tank.model.EquipModel
local service = qy.tank.service.EquipService
local userInfoModel =  qy.tank.model.UserInfoModel
function EquipClearView:ctor(delegate)
    EquipClearView.super.ctor(self)
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync(qy.ResConfig.XUNZHANG_BAOCUN)
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync(qy.ResConfig.XUNZHANG_KUANG)
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync(qy.ResConfig.XUNZHANG_GUANG)
    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "Resources/equip/cleartitle.png", 
        showHome = false,
        ["onExit"] = function()
            if delegate and delegate.dismiss then
                delegate.dismiss()
            end
        end
    })
    self:addChild(style)

    self:InjectView("p1")
    self:InjectView("shuxing1")
    self:InjectView("shuxing2")
    self:InjectView("Btimg")
    self:InjectView("awardbg")
    self:InjectView("num1")
    self:InjectView("num2")    
    self:InjectView("num3")
    self:InjectView("equipBg1")
    self:InjectView("equipBg2")
    self:InjectView("equipIcon1")
    self:InjectView("equipIcon2")
    self:InjectView("wenzi")
    self:InjectView("noshuxing1")
    self:InjectView("noshuxing2")
    self:InjectView("sss")

    self.equip_type = delegate.type    
    self.parent = delegate.parent.delegate
    self.select_equip_unique_id = delegate.unique_id

    self:updateData1()
    self.tab = qy.tank.widget.TabButtonGroup.new("widget/TabButton1",{qy.TextUtil:substitute(90327), qy.TextUtil:substitute(90328),qy.TextUtil:substitute(90329)},cc.size(185,67),"h",function(idx)
        self:createContent(idx)
    end, 1)
    self.tab:setPosition(qy.winSize.width/2-485,qy.winSize.height-145)
    self.tab:setLocalZOrder(4)
    self:addChild(self.tab)

    self:OnClick("Btn_help", function()
        qy.tank.view.common.HelpDialog.new(53):show(true)
    end, {["isScale"] = false})
    self:OnClick("clearBt", function()
        local entity = self:updateEntity()
        if self.bad == 1 then
            self:badornot()
            return
        end
        if self.flag == 1 then
            service:clearEquip(entity.unique_id, entity:getComponentEnglishName(),function(data)
                self:updateData1()
                self:badornot()
                self:update()     
            end)
        elseif self.flag == 2 then
            service:ExtracterEquip(entity.unique_id, entity:getComponentEnglishName(),function(data)
                self:updateData2(true,data)
                self:updateEquipInfo(delegate.parent)
                -- self:showUtil()
                self:update()     
            end)
        else
             service:BrokenEquip(entity.unique_id, entity:getComponentEnglishName(),function(data)
                self:updateData2(true,data)
                self:updateEquipInfo(delegate.parent)
                -- self:showUtil()
                self:update()     
            end)
        end
    end, {["isScale"] = false})
    self:OnClick("replaceBt", function()
        if #self.arr_data == 0 then
            qy.hint:show("请洗练后替换")
            return
        end
        local entity = self:updateEntity()
            service:saveClearEquip(entity.unique_id, entity:getComponentEnglishName(),function(data)
                self:updateEquipInfo(delegate.parent)  
                self:updateData1()
                self:showEff2()
                -- self:showUtil()
            end)
    end, {["isScale"] = false})
    self:update()
 
end
function EquipClearView:updateData1(  )
    local entity = self:updateEntity()
    self.data = entity.addition_attr
    self.arr_data = entity.addition_attr_tmp
    self.bad = entity.addition_bad
    self.shuxing1:removeAllChildren(true)
    self.shuxing2:removeAllChildren(true)
    self.noshuxing1:setVisible(#self.data == 0)
    self.noshuxing2:setVisible(#self.arr_data == 0)
    for i=1,#self.data do
        local item = qy.tank.view.equip.ProgressCell1.new(self.data[i])
        item:setPosition(cc.p(30,270 - i * 32))
        self.shuxing1:addChild(item)
    end
    for i=1,#self.arr_data do
        local item = qy.tank.view.equip.ProgressCell1.new(self.arr_data[i])
        item:setPosition(cc.p(25,270 - i * 32))
        self.shuxing2:addChild(item)
    end
end
function EquipClearView:badornot(  )
    local entity = self:updateEntity()
    self.bad = entity.addition_bad
    if self.bad == 1 then
        qy.tank.view.equip.ErrorTip.new(entity,function (  )
            self.bad = 0
            entity.addition_bad = 0
            qy.Event.dispatch(qy.Event.GARAGE_UPDATE)
        end):show(true)
    end
end
function EquipClearView:updateData2( flag , data )
    if flag then
        local entity = self:updateEntity()
        self.data1 = entity.addition_attr
        self.shuxing1:removeAllChildren(true)
        self.shuxing2:removeAllChildren(true)
        self.noshuxing1:setVisible(false)
        self.noshuxing2:setVisible(false)
        for i=1,#self.data1 do
            local item = qy.tank.view.equip.ProgressCell1.new(self.data1[i])
            item:setPosition(cc.p(30,270 - i * 32))
            self.shuxing1:addChild(item)

            local item1 = qy.tank.view.equip.ProgressCell.new(self.data1[i],i,data)
            item1:setPosition(cc.p(25,270 - i * 32))
            self.shuxing2:addChild(item1)
        end
        qy.Event.dispatch(qy.Event.GARAGE_UPDATE)
    else
        self.shuxing1:removeAllChildren(true)
        self.shuxing2:removeAllChildren(true)
        local entity = self:updateEntity()
        self.data = entity.addition_attr
        for i=1,#self.data do
            local item = qy.tank.view.equip.ProgressCell1.new(self.data[i])
            item:setPosition(cc.p(30,270 - i * 32))
            self.shuxing1:addChild(item)
        end
        self.noshuxing2:setVisible(true)
    end
end
function EquipClearView:createContent( idx )
    if #self.data == 0 and idx == 2 then
        qy.hint:show("请先洗练后萃取")
        self.tab:switchTo(1)
        return
    end
    if #self.data == 0 and idx == 3 then
        qy.hint:show("请先洗练后突破")
        self.tab:switchTo(1)
        return
    end
    self.awardbg:removeAllChildren(true)
    self.p1:setVisible(idx == 1)
    self.flag = idx
 
    self:updateaward()
    if idx == 1 then
        self.sss:setPosition(cc.p(-110,-10))
        self.awardbg:setPosition(cc.p(40,-6.5))
        self:updateData1()
        self.Btimg:loadTexture("Resources/equip/xiliantext.png", 1)
        self.wenzi:setString(qy.TextUtil:substitute(90330))
    elseif idx == 2 then
        if self.bad == 1 then
            self:badornot()
            self.tab:switchTo(1)
            return
        end
        self.sss:setPosition(cc.p(-160,-10))
        self.awardbg:setPosition(cc.p(-10,-6.5))
        self:updateData2()
        self.Btimg:loadTexture("Resources/equip/cuiqu.png", 1)
        self.wenzi:setString(qy.TextUtil:substitute(90331))
    else
        if self.bad == 1 then
            self:badornot()
            self.tab:switchTo(1)
            return
        end
        self.sss:setPosition(cc.p(-110,-10))
        self.awardbg:setPosition(cc.p(40,-6.5))
        self:updateData2()
        self.Btimg:loadTexture("Resources/equip/tupo.png", 1)
        self.wenzi:setString(qy.TextUtil:substitute(90332))
    end
end
function EquipClearView:updateaward(  )
    local award = model:getConsumeByid(self.flag)
    for i=1,#award do
        local item = qy.tank.view.common.AwardItem.createAwardView(award[i], 1)
        item:setPosition( 90 *i -60,45)
        item:showTitle(false)
        item:setScale(0.7)
        item.num:setColor(cc.c3b(255,255,255))
        if i == 1 then
            if award[1].num > userInfoModel.userInfoEntity.silver then
                item.num:setColor(cc.c3b(251, 48, 0))
            end
        elseif i == 2 then
            if self.flag == 3 then
                if award[i].num > userInfoModel.userInfoEntity.break_stone then
                    item.num:setColor(cc.c3b(251, 48, 0))
                end
            else
                if award[i].num > userInfoModel.userInfoEntity.polish_stone then
                    item.num:setColor(cc.c3b(251, 48, 0))
                end
            end
        else
            if award[i].num > userInfoModel.userInfoEntity.extractor then
                    item.num:setColor(cc.c3b(251, 48, 0))
            end
        end
        self.awardbg:addChild(item)
    end
end
function EquipClearView:updateEntity()
    return model:getEquipEntityByUniqueId(self.select_equip_unique_id, self.equip_type)
end
function EquipClearView:update(  )
    self:updateaward()
    local entity = self:updateEntity()
    self.equipBg1:setSpriteFrame(entity:getIconBg())
    self.equipIcon1:setTexture(entity:getIcon())
    self.equipBg2:setSpriteFrame(entity:getIconBg())
    self.equipIcon2:setTexture(entity:getIcon())
    self.num1:setString(userInfoModel.userInfoEntity.polish_stone)
    self.num2:setString(userInfoModel.userInfoEntity.extractor)
    self.num3:setString(userInfoModel.userInfoEntity.break_stone)
end
--[[--
--更新装备详情
--]]
function EquipClearView:updateEquipInfo(delegate, _type)
    delegate:setSelectedEquip(model:getEquipEntity(delegate.delegate.type, delegate.selectEquipIdx + 1),_type)

    -- local _data = model:getAddAttribute()
    -- qy.tank.utils.HintUtil.showSomeImageToast(_data,cc.p(qy.winSize.width / 2, qy.winSize.height * 0.7))
end
function EquipClearView:showEff2(  )
    local currentEffert = nil
    if currentEffert == nil then
        qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/ui/ui_fx_baocunshuxing",function()
            currentEffert = ccs.Armature:create("ui_fx_baocunshuxing")
            currentEffert:setScaleX(0.91)
            self.equipIcon2:addChild(currentEffert,699,699)
            local size = self.equipIcon2:getContentSize()
            currentEffert:setPosition(size.width/2,size.height/2)
            currentEffert:getAnimation():playWithIndex(0)
        end)
        currentEffert:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
            if movementType == ccs.MovementEventType.complete then
                currentEffert:removeFromParent()
                currentEffert = nil
                if currentEffert == nil then
                    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/ui/ui_fx_baocunshuxing1",function()
                    currentEffert = ccs.Armature:create("ui_fx_baocunshuxing1")
                    self.equipIcon2:addChild(currentEffert,699,699)
                    local size = self.equipIcon2:getContentSize()
                    currentEffert:setPosition(size.width/2 - 30,size.height/2)
                    currentEffert:getAnimation():playWithIndex(0)
                    end)
                    currentEffert:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
                        if movementType == ccs.MovementEventType.complete then
                            currentEffert:removeFromParent()
                            currentEffert = nil
                            if currentEffert == nil then
                                qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/ui/ui_fx_baocunshuxing",function()
                                currentEffert = ccs.Armature:create("ui_fx_baocunshuxing")
                                self.equipIcon1:addChild(currentEffert,699,699)
                                local size = self.equipIcon1:getContentSize()
                                currentEffert:setPosition(size.width/2,size.height/2)
                                currentEffert:getAnimation():playWithIndex(0)
                                end)
                            end
                        end
                    end)

                end
            end
        end)

    end
end

-- 战斗力飘字
function EquipClearView:showUtil()
    local _aData = {}
    local fightPower = qy.tank.model.UserInfoModel.userInfoEntity.fightPower - qy.tank.model.UserInfoModel.userInfoEntity.oldfight_power
    if fightPower and fightPower ~= 0 then
        local numType = 0
        if fightPower > 0 then
            numType = 15
        else
            numType = 14
        end
        _data = {
            ["value"] = fightPower,
            ["url"] = qy.ResConfig.IMG_FIGHT_POWER,
            ["type"] = numType,
            ["picType"] = 2,
         }
        table.insert(_aData, _data)
        qy.tank.utils.HintUtil.showSomeImageToast(_aData,cc.p(qy.winSize.width / 2, qy.winSize.height * 0.6))
    end
end







return EquipClearView