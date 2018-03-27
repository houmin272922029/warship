--[[
    车库视图层
    Author: Aaron Wei
    Date: 2015-03-18 15:34:17
]]

local GarageView = qy.class("GarageView", qy.tank.view.BaseView, "view/garage/GarageView")

function GarageView:ctor(delegate)
    print("GarageView:ctor")
    GarageView.super.ctor(self)
    self.delegate = delegate
    self.model = qy.tank.model.GarageModel
    self.selectIdx = 1

    self:InjectView("panel")
    self:InjectView("tankListPanel")
    self:InjectView("equiListPanel")
    self:InjectView("infoListPanel")
    self:InjectView("tankImg")
    self:InjectView("changeTankBtn")
    self:InjectView("equipmentBtn")
    self:InjectView("freeTips")
    self:InjectView("exitBtn")
    self:InjectView("updateTankBtn")
    self:InjectView("infoTips")
    self:InjectView("equip_1")
    self:InjectView("advanceBtn")
    self:InjectView("UpBtn")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/toast/toast.plist")
    --gun: 火炮 bullet:炮弹 armor：装甲 engine：发动机
    local equipName = {"gun","bullet","armor","engine"}
    self.equipEffertTable = {} --装备动画
    self.equipBg = {}
    self.equipIcon = {}
    for i =1, 4 do
        self:InjectView("equip_" .. i)
        self:InjectView("equip_icon_".. i)
        self.equipBg[i] = self["equip_" .. i]
        self.equipIcon[i] = self["equip_icon_" .. i]
        self:OnClick("equip_" .. i, function(sender)
            if tonumber(self.model.formation[self.selectIdx]) then
                qy.hint:show(qy.TextUtil:substitute(14007))
                return
            end
            if delegate and delegate.clickEquip then
                delegate.clickEquip(self, equipName[i], self.selectTankUid)
            end
            -- if i == 1 then
            --     qy.GuideManager:next(90870)
            -- end
        end)
    end

    self:OnClick("helpBtn", function(sender)
        qy.tank.view.common.HelpDialog.new(1):show(true)
    end)

    self:OnClick("changeTankBtn", function(sender)
        if delegate and delegate.showTankList then
            delegate.showTankList(self.selectIdx)
        end
    end)

    self:OnClick("changeFormationBtn", function(sender)
        if delegate and delegate.showFormation then
            delegate.showFormation()
        end
    end)
    
    --鼠式坦克晋升
    self:OnClick("UpBtn", function(sender)
        local entity = self.model.formation[self.selectIdx]--选中的tank的基本属性，后边加tank就直接传这个
        local uid = self.model.formation[self.selectIdx].unique_id
        if delegate and delegate.showPromotion then
            delegate.showPromotion(uid,self)
        end
    end)

    self:OnClick("exitBtn", function(sender)
        if delegate and delegate.dismiss then
            delegate.dismiss()
            qy.GuideManager:next(98712)
        end
    end,{["audioType"] = qy.SoundType.BTN_CLOSE,["isScale"] = false})

    self:OnClick("updateTankBtn", function(sender)
        if tonumber(self.tankEntity) then
            qy.hint:show(qy.TextUtil:substitute(14008))
        else
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.TRAINING, {["tankUid"] = self.model.formation[self.selectIdx].unique_id})
        end
    end)

    self:OnClick("InheritBtn", function(sender)
        self.fightJapanModel = qy.tank.model.FightJapanGarageModel
        if tonumber(self.tankEntity) then
            qy.hint:show(qy.TextUtil:substitute(14008))
        elseif self.model.formation[self.selectIdx].inherit == 0 then 
            qy.hint:show("不可置换")
        elseif self.model.formation[self.selectIdx].is_train ~= 0 then
            qy.hint:show("需终止该战车训练")
        else
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.INHERIT, {["entity"] = self.model.formation[self.selectIdx]})
        end
    end)

    self:OnClick("equipmentBtn", function(sender)
        self:equipmentLogic()
    end)

    self:OnClick("ImgBtn", function(sender)
        if tonumber(self.tankEntity) then

        else
            local data = qy.tank.view.common.AwardItem.getItemData({
                  ["type"] = 11,
                  ["tank_id"] = self.model.formation[self.selectIdx].tank_id,
            })
            qy.alert:showTip(qy.tank.utils.TipUtil.createTipContent(data))
        end

    end,{["audioType"] = qy.SoundType.BTN_CLOSE,["isScale"] = false})

    self:OnClick("advanceBtn", function(sender)
        delegate.showAdvance({["entity"] = self.model.formation[self.selectIdx]})
        -- qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.ADVANCE, {["entity"] = self.model.formation[self.selectIdx]})
        -- qy.tank.module.Helper:register("advance")
        -- qy.tank.module.Helper:start("advance", self)
    end)

    if not tolua.cast(self.tankInfoList,"cc.Node") then
        self.tankInfoList = qy.tank.view.common.TankInfoList.new(cc.size(270,475))
        self.infoListPanel:addChild(self.tankInfoList)
        self.tankInfoList:setPosition(15,500)
    end
end

function GarageView:__showToast()
    local _data = qy.tank.model.EquipModel:getAddAttribute()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/toast/toast_txt.plist")
    qy.hint:showImageToast(cc.Sprite:createWithSpriteFrameName(qy.ResConfig.LOAD_EQUIP),3,1,cc.p(qy.winSize.width / 2, qy.winSize.height * 0.6))

    qy.tank.utils.HintUtil.showSomeImageToast(_data,cc.p(qy.winSize.width / 2, qy.winSize.height * 0.7))

end

--[[--
--一键装备
--]]
function GarageView:equipmentLogic()
    local selectEquip = qy.tank.model.EquipModel:getEquipmentData(self.selectTankUid)
    local canLoaded = false
    for i = 1, 4 do
        if selectEquip[i] > 0 then
            local service = qy.tank.service.EquipService
            service:loadEquipment(self.selectTankUid, selectEquip,self.delegate.type,function(data)
                self:__showToast()
                qy.GuideManager:next(90868)
                self:updateTankList()
                self:showCurEquip(self.model.formation[self.selectIdx])
                self:setIdx(self.selectIdx,false)
                -- local toast = ccui.ImageView:create(qy.ResConfig.LOAD_EQUIP)
                -- qy.hint:showImageToast(toast,3)
            end)
            canLoaded = true
            break
        end
    end
    if not canLoaded then
        qy.hint:show(qy.TextUtil:substitute(14009))
    end
end

function GarageView:setIdx(idx,isClick)
    local entity = self.model.formation[idx]
    if entity == -1 then
        -- 未解锁
        qy.hint:show(qy.TextUtil:substitute(14010),0.5)
    else
        self.selectIdx = idx
        local cell = self.tankList:cellAtIndex(idx-1)
        if cell then
            -- cell.status:setString("选中")
            cell.item.light:setVisible(true)
        end
        if entity == 0 then
            -- 空位
            self.tankInfoList:setVisible(false)
            self.freeTips:setVisible(true)
            self:clearInfoList()
            if isClick then
                self.delegate.showTankList(idx)
            end
            self:showTankImg(1,entity)
        else
            self.tankInfoList:setVisible(true)
            self.freeTips:setVisible(false)
            -- 有战车
            self:showTankImg(2,entity)
            self:createInfoPanel(entity)
        end
        self.advanceBtn:setVisible(qy.tank.model.AdvanceModel:testGrowUpEnable(entity))
    end
    --打开训练场判断需要
    self.tankEntity = entity
end

function GarageView:createTankPanel()
    -- local layer = cc.LayerColor:create(cc.c4b(0,255,255,100),240,520)
    self.tankList = cc.TableView:create(cc.size(210,492))
    self.tankList:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tankList:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.tankList:setPosition(8,10)
    self.tankListPanel:addChild(self.tankList)
    -- self.tankList:addChild(layer)
    self.tankList:setDelegate()

    local function numberOfCellsInTableView(table)
        return 6
    end

    local function tableCellTouched(table,cell)
        print("cell touched at index: " .. cell:getIdx())
        local value = self.model.formation[cell:getIdx()+1]
        if value == -1 then
            -- 未解锁
            qy.hint:show(qy.TextUtil:substitute(14011),0.5)
        else
            if self.selectIdx-1 ~= cell:getIdx() then
                qy.QYPlaySound.playEffect(qy.SoundType.SWITCH_TANK)
            end

            local before = table:cellAtIndex(self.selectIdx-1)
            if before then
                before.item.light:setVisible(false)
            end
            self:setIdx(cell:getIdx()+1,true)
            self:showCurEquip(value)
        end

        qy.GuideManager:next(9080758)
    end

    local function cellSizeForTable(tableView, idx)
        return 210, 125
    end

    local function tableCellAtIndex(table, idx)
        local strValue = string.format("%d",idx)
        local cell = table:dequeueCell()
        local item,label,status
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.garage.GarageTankCell.new(self.model.formation[idx+1], idx + 1,true)
            cell:addChild(item)
            cell.item = item

            -- label = cc.Label:createWithSystemFont("", "Helvetica", 20.0)
            -- label:setPosition(0,0)
            -- label:setAnchorPoint(0,0)
            -- cell:addChild(label)
            -- cell.label = label

            status = cc.Label:createWithSystemFont("", "Helvetica", 24.0)
            status:setTextColor(cc.c4b(255,255,0,255))
            status:setPosition(110,65)
            status:setAnchorPoint(0.5,0.5)
            cell:addChild(status)
            cell.status = status
        end
        cell.item:render(self.model.formation[idx+1], idx+1)
        -- cell.label:setString(strValue)
        if self.selectIdx == idx+1 then
            -- cell.status:setString("选中")
            cell.item.light:setVisible(true)
--            self.selectTankUid = self.model.formation[idx+1].unique_id
        else
            -- cell.status:setString("")
            cell.item.light:setVisible(false)
        end
        return cell
    end

    self.tankList:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.tankList:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    self.tankList:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    self.tankList:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)

    self.tankList:reloadData()
    self:showCurEquip(self.model.formation[self.selectIdx])
    self:setIdx(self.selectIdx,false)
end

--[[--
--更新装备界面
--]]
function GarageView:updateEquipView()
    self:showCurEquip(self.model.formation[self.selectIdx])
    self.tankInfoList:render(self.model.formation[self.selectIdx])
end

--[[--
--显示当前坦克的装备
--@param #table entity 坦克实体 当为0或者-1时，表示没有上阵的坦克
--]]
function GarageView:showCurEquip(entity)
    local _redDotTankUid = 0
    if type(entity) == "table" then
        local equipTable = entity:getEquipEntity()
        if equipTable then
            self.selectTankUid = entity.unique_id
            _redDotTankUid = entity.unique_id
            -- print("selectTankUid===" ..self.selectTankUid)
            for i = 1, 4 do
                if type(equipTable[i]) == "table" then
                    self:setLoadEquipByIndx(i, equipTable[i])
                else
                    self:setEquipDefaultStatusByEquipIndex(i)
                end
            end
        else
            for i = 1, 4 do
                self:setEquipDefaultStatusByEquipIndex(i)
            end
        end
    else
         for i = 1, 4 do
                self:setEquipDefaultStatusByEquipIndex(i)
            end
    end
    qy.RedDotCommand:updateGarageViewRedDot(_redDotTankUid)
end

function GarageView:createEquipSuitEffert(_target)
    local _effert = ccs.Armature:create("Flame")
    -- _effert:setScale(1.1)
    _target:addChild(_effert,999)
    _effert:setPosition(51,49)
    _effert:getAnimation():playWithIndex(0)
    return _effert
end

--[[--
--设置已装备
--]]
function GarageView:setLoadEquipByIndx(index, entity)
    self.equipBg[index]:loadTexture(entity:getIconBg(),1)
    self.equipIcon[index]:setTexture(entity:getIcon())

    if self.equipEffertTable[index] == nil and entity:getSuitID() > 0 then
        self.equipEffertTable[index] = self:createEquipSuitEffert(self.equipIcon[index])
    end

    if entity:getSuitID() == 0 then
        if self.equipEffertTable[index] then
            self.equipEffertTable[index]:setVisible(false)
        end
    else
        if self.equipEffertTable[index] == nil then
            self.equipEffertTable[index] = self:createEquipSuitEffert(self.equipIcon[index])
        end
        self.equipEffertTable[index]:setVisible(true)
    end

end

--[[--
--设置装备默认状态
--]]
function GarageView:setEquipDefaultStatusByEquipIndex(index)
    self.equipBg[index]:loadTexture("Resources/common/item/item_bg_1.png",1)
    self.equipIcon[index]:setSpriteFrame("Resources/garage/equip_d"..index..".png")
    if self.equipEffertTable[index] then
        self.equipEffertTable[index]:setVisible(false)
    end
end

-- 展示tank特写
function GarageView:showTankImg(id,entity)
    local x = self.model.config3
    if tonumber(entity) == nil then
        self.tankImg:setTexture(entity:getImg())
         self.tankImg:setPosition(entity:getImgPosition())
    else
        self.tankImg:setTexture("Resources/common/bg/c_12.png")
    end
    if id == 2 then
        -- for k,v in pairs(x) do
        --     if tonumber(entity.tank_id) == tonumber(k) then
        --         print("GarageView000-",entity.tank_id)
        --         print("GarageView000-1",k)
        --         self.UpBtn:setVisible(true)
        --     else
        --         print("GarageView隐藏")
        --         self.UpBtn:setVisible(false)
        --     end 
        -- end
        if x[tostring(entity.tank_id)] ~= nil then
            self.UpBtn:setVisible(true)
        else
            self.UpBtn:setVisible(false)
        end 
        
    else
        print("GarageView隐藏2")
        self.UpBtn:setVisible(false)
    end
    
    print("GarageView000--",self.model.formation[self.selectIdx])
    if self.model.formation[self.selectIdx] ~= 0 then
        self.model:set_tankd_id(self.model.formation[self.selectIdx].tank_id)
    end
end

function GarageView:updateTankList()
    if self.tankList then
        local listCurY = self.tankList:getContentOffset().y
        self.tankList:reloadData()
        self.tankList:setContentOffset(cc.p(0,listCurY))
    end
end

function GarageView:createInfoPanel(entity)
    -- self:clearInfoList()

    if entity and type(entity) == "table" then
        self.tankInfoList:render(entity)
    else
        -- self:clearInfoList()
    end
end

function GarageView:setStar(value)
    --print("GarageView:setStar star="..value)
    for i = 1,6 do
        if i <= value then
            self["star"..i]:setVisible(true)
        else
            self["star"..i]:setVisible(false)
        end
    end
end

function GarageView:clearInfoList()
    -- self.tankName:setString("未选中坦克")
    -- self.tankType:setString("未选中坦克")
    -- self.attack:setString("未选中坦克")
    -- self.defense:setString("未选中坦克")
    -- self.blood:setString("未选中坦克")
    -- self.hit:setString("未选中坦克")
    -- self.dodge:setString("未选中坦克")
    -- self.crit:setString("未选中坦克")
    -- self.wear:setString("未选中坦克")
    -- self.antiWear:setString("未选中坦克")
    -- self:setStar(0)
    if self.tankInfoList and tolua.cast(self.tankInfoList,"cc.Node") then
        self.tankInfoList:clear()
    end
end

function GarageView:update()
    self:updateTankList()
    self:setIdx(self.selectIdx,false)
    self:showCurEquip(self.model.formation[self.selectIdx])
end

function GarageView:showInfoTipsAnim()
    local scaleSmall = cc.ScaleTo:create(1.2,0.9)
    local scaleBig = cc.ScaleTo:create(1.2,1)
    local FadeIn = cc.FadeTo:create(1.2, 255)
    local FadeOut = cc.FadeTo:create(1.2, 125)
    local spawn1 = cc.Spawn:create(scaleSmall,FadeOut)
    local spawn2 = cc.Spawn:create(scaleBig,FadeIn)
    local seq = cc.Sequence:create(spawn1, spawn2)
    self.infoTips:runAction(cc.RepeatForever:create(seq))
end

function GarageView:onEnter()
    -- GarageView.super.onEnter(self)
    self.panel:setTouchEnabled(true)
    self.panel:setSwallowTouches(true)

    qy.Event.dispatch(qy.Event.SERVICE_LOADING_HIDE)

    if self.tankList == nil or not tolua.cast(self.tankList, "cc.Node") then
        self:createTankPanel()
    else
        self:updateTankList()
    end

    self.listener = qy.Event.add(qy.Event.LINEUP_SUCCESS,function()
        self:update()
    end,1)

     self.listUpdateListener = qy.Event.add(qy.Event.GARAGE_UPDATE,function()
        self:update()
    end,1)

     self.listUpdateShushi = qy.Event.add(qy.Event.UPDATA_SHUSHI,function ()
         self:update()
     end,1)

     --新手引导：注册控件
     qy.GuideCommand:addUiRegister({
        {["ui"] = self.equip_1,["step"] = {"SG_24","SG_27","SG_30","SG_33"}},
        {["ui"] = self.exitBtn,["step"] = {"SG_36"}}
    })

     qy.RedDotCommand:addSignal({
        [qy.RedDotType.G_CHANGE] = self.changeTankBtn,
        [qy.RedDotType.G_LOAD] = self.equipmentBtn,
        [qy.RedDotType.G_EQUIP_1] = self.equip_1,
        [qy.RedDotType.G_EQUIP_2] = self.equip_2,
        [qy.RedDotType.G_EQUIP_3] = self.equip_3,
        [qy.RedDotType.G_EQUIP_4] = self.equip_4,
    })

    qy.RedDotCommand:updateGarageViewRedDot(self.selectTankUid)
    qy.RedDotCommand:emitSignal(qy.RedDotType.G_CHANGE, qy.tank.model.RedDotModel:getGarageHasNew(), true)
    self:showInfoTipsAnim()

    self:update()  -- 从进阶出来需要刷新数据
end

function GarageView:onExit()
    if self.listener then
        qy.Event.remove(self.listener)
    end
    if self.listUpdateListener then
        qy.Event.remove(self.listUpdateListener)
    end
    if self.listUpdateListener then
        qy.Event.remove(self.listUpdateShushi)
    end
    --新手引导：移除控件注册
    qy.GuideCommand:removeUiRegister({"SG_24","SG_27","SG_30","SG_33","SG_36"})

    qy.RedDotCommand:removeSignal({
        qy.RedDotType.G_CHANGE,qy.RedDotType.G_LOAD,qy.RedDotType.G_EQUIP_1,qy.RedDotType.G_EQUIP_2,qy.RedDotType.G_EQUIP_3,qy.RedDotType.G_EQUIP_4,
    })
    -- self.equipEffertTable = {}
    self.infoTips:stopAllActions()
end

-- 销毁
function GarageView:onCleanup()
    print("GarageView:onCleanup")
    -- qy.tank.utils.cache.CachePoolUtil.removePlist("Resources/garage/garage",1)
end

return GarageView
