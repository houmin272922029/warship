--[[--
    装备
    Author: H.X.Sun
--]]--
local EquipView = qy.class("EquipView", qy.tank.view.BaseView, "view/equip/EquipView")

local service = qy.tank.service.EquipService
local userInfoModel =  qy.tank.model.UserInfoModel

function EquipView:ctor(delegate)
    EquipView.super.ctor(self)

    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "Resources/common/title/equip_title.png",
        ["onExit"] = function()
            if delegate and delegate.dismiss then
                delegate.dismiss()
                qy.GuideManager:next()
                qy.tank.model.EquipModel:sortEquipList(self.curEquipType)
            end
        end
    })
    self:addChild(style, 13)
    self.model = qy.tank.model.EquipModel
    self.delegate = delegate
    self.exitBtn = style.exitBtn
    self.isMsgBack = true

    self.selectEquipIdx = 0
    self.cell_isOpenStatus = true

    self:InjectView("list_bg_1")
    self:InjectView("list_bg_2")
    self:InjectView("redDot")
    self:InjectView("scrollView")
    self:InjectView("btn_txt")
    self:InjectView("strength_btn")
    self:InjectView("redDot")
    self:InjectView("equip_btn")
    self:InjectView("select_btn")
    self:InjectView("formationTitle")
    self:InjectView("auto_strength_btn")
    self.equipViewOpen = true

    self:OnClick("equip_btn",function()
        if self.curEquipEntity.tank_unique_id == self.model:getFirstEquipTankUid() then
            --卸下逻辑
            local fontName = qy.language == "tw" and "res/Resources/font/ttf/black_body_2.TTF" or "Arial"
            qy.alert:show({qy.TextUtil:substitute(9004) ,{255,255,255} } ,
                {{id=1,color={255,255,255},alpha=255,text=qy.TextUtil:substitute(9003),font=fontName,size=20} },cc.size(533 , 250) ,{{qy.TextUtil:substitute(9005), 4}, {qy.TextUtil:substitute(9006), 5}} ,
                function(flag)
                    if qy.TextUtil:substitute(9006) == flag then
                        service:unload({
                            ["unique_id"] = self.curEquipEntity.unique_id,
                            ["type"] = self.curEquipEntity:getComponentEnglishName(),
                        },self.curEquipEntity.tank_unique_id,function()
                            self.selectEquipIdx = 0
                            self:updateEquipList(false)
                            self:updateEquipInfo(3)
                        end)
                    end
                end ,"")
            -- end
        else
            --装载逻辑
            local equipUid = self.curEquipEntity.unique_id
            local nType = tonumber(self.curEquipEntity:getType())
            local tankUid = self.curEquipEntity.tank_unique_id
            local selectEquip = {}
            for i = 1, 4 do
                if nType == i then
                    selectEquip[i] = equipUid
                else
                    selectEquip[i] = 0
                end
            end
            if tankUid == 0 then
                self:sendLoadMsg(selectEquip)
            else
                local fontName = qy.language == "tw" and "res/Resources/font/ttf/black_body_2.TTF" or "Arial"
                qy.alert:show(
                    {qy.TextUtil:substitute(9004) ,{255,255,255} } ,
                    {{id=1,color={255,255,255},alpha=255,text=qy.TextUtil:substitute(9007),font=fontName,size=20} },
                        cc.size(533 , 250) ,{{qy.TextUtil:substitute(9005) , 4}, {qy.TextUtil:substitute(9006) , 5}} ,
                        function(flag)
                            if qy.TextUtil:substitute(9006) == flag then
                                self:sendLoadMsg(selectEquip)
                            end
                        end ,"")
                end
            end
    end,{["isScale"] = false})

    self:OnClick("strength_btn",function()        
        self.isClicking = false
        self:stopTimer()
    end,{["isScale"] = false,
    ["beganFunc"]=function ()
        local timer = qy.tank.utils.Timer.new(0.2,1,function()
            self.isContinuous = false
        end)
        timer:start()
        if self.isContinuous then
            return
        end
        if not self.isMsgBack then
            return
        end
        self.msgNum1 = 0
        self.msgNum2 = 0
        self.isClicking = true
        self.cishu = 1
        self:strengthenLogic()
    end, ["canceledFunc"]=function (sender)
        self.isClicking = false
        self:stopTimer()
    end})



    self:OnClick("auto_strength_btn",function()
        self.isClicking = false
        self:stopTimer()
    end,{["isScale"] = false,
    ["beganFunc"]=function ()
        local timer = qy.tank.utils.Timer.new(0.2,1,function()
            self.isContinuous = false
        end)
        timer:start()
        if self.isContinuous then
            return
        end
        if not self.isMsgBack then
            return
        end
        self.msgNum1 = 0
        self.msgNum2 = 0
        self.isClicking = true
        self.cishu = 10
        self:strengthenLogic()
    end, ["canceledFunc"]=function (sender)
        self.isClicking = false
        self:stopTimer()
    end})


    self:OnClick("select_btn",function()
        if self.delegate.equipEntity and self.delegate.callback then
            local entity = self.model:getNoUseEquipEntity(self.delegate.equipEntity)[self.selectEquipIdx + 1]

            if entity then
                self.delegate.callback(entity.unique_id)
                delegate.dismiss()
            end
        end
    end,{["isScale"] = false})

    if not self.delegate.equipEntity then
        self.model:setFirstEquipTankUid(self.delegate.selectTankUid)
    end
end

function EquipView:stopTimer()
    if self.timer then
        self.timer:stop()
    end
    self.timer = nil
    self.msgNum1 = 0
    self.msgNum2 = 0
end

function EquipView:timeToStrengthen()
    if tonumber(self.msgNum1) and self.msgNum1 > 0 then
        local num = self.msgNum1
        self.timer = qy.tank.utils.Timer.new(0.2,num,function()
            self.msgNum1 = self.msgNum1 - 1
            self:strengthenLogic()
        end)
        self.timer:start()
    end
end

--排一个序列 msgNum1 发消息，三秒发一次，然后消息回来在 msgNum2 加一次消息，当 msgNum1 为0时，则 msgNum1 = msgNum2,msgNum2 = 0
function EquipView:strengthenLogic()
    if not self.isClicking then
        self:updateOneCell()
        return
    end

    if self.curEquipEntity.level < userInfoModel.userInfoEntity.level * 2 then
        if self.curEquipEntity.level < userInfoModel.userInfoEntity.level * 2 then
            self.isMsgBack = false
            self.isContinuous = true


            local function_ = nil
            if self.cishu == 1 then
                function_ = service["strengthenEquip"]
            else
                function_ = service["autoStrengthenEquip"]
            end

            print("sssssssssssssssssssss", self.cishu)
            function_(service, qy.isNoviceGuide ,self.curEquipEntity.unique_id,self.curEquipType,function(data)--||||||
                self.isMsgBack = true
                if self.equipViewOpen then
                    self.msgNum2 = self.msgNum2 + 1
                    qy.QYPlaySound.playEffect(qy.SoundType.EQUIP_STRENGTH)
                    self:__showStrengEffert()
                    self:updateOneCell()
                    self:updateEquipInfo(2)
                    qy.GuideManager:next(15)
                    if not qy.isNoviceGuide then --||||||
                        if tonumber(self.msgNum1) and not (self.msgNum1 > 0) then
                            self.msgNum1 = self.msgNum2
                            self.msgNum2 = 0
                            self:timeToStrengthen()
                        end
                    end
                end
            end,function()
                self.isMsgBack = true
            end,function()
                self.isMsgBack = true
            end)
        else
            qy.hint:show(qy.TextUtil:substitute(9008))
            self.isMsgBack = true
            self.isContinuous = false
        end
    else
        qy.hint:show(qy.TextUtil:substitute(9009))
        self.isMsgBack = true
        self.isContinuous = false
    end
end

--[--
--发送装载消息
--]
function EquipView:sendLoadMsg(selectEquip)
    local service = qy.tank.service.EquipService
    service:loadEquipment(self.delegate.selectTankUid, selectEquip,self.delegate.type,function(data)
        qy.GuideManager:next(14)
        self.selectEquipIdx = 0
        self:updateEquipList(true)
        self:updateEquipInfo(1)
    end)
end

--[[--
--更新装备cell
--]]
function EquipView:updateOneCell()
    self.equipList:updateCellAtIndex(self.selectEquipIdx)
end

--[[--
--更新装备详情
--]]
function EquipView:updateEquipInfo(_type)
    self:setSelectedEquip(self:getEntity(self.selectEquipIdx + 1),_type)

    --在引用前加载plist
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/toast/toast_txt.plist")
    local _url = ""
    if _type == 1 then
        _url = qy.ResConfig.LOAD_EQUIP
    elseif self.model:isStrengthenCrit() then
        _url = qy.ResConfig.IMG_STRENG_CRIT
    elseif _type == 2 then
        _url = qy.ResConfig.IMG_STRENG_SUCCESS
    else
        _url = qy.ResConfig.IMG_E_UNLOAD
    end
    qy.hint:showImageToast(cc.Sprite:createWithSpriteFrameName(_url),3,1,cc.p(qy.winSize.width / 3 * 2, qy.winSize.height * 0.6))

    local toastTable = {}
    local _data = self.model:getAddAttribute()
    qy.tank.utils.HintUtil.showSomeImageToast(_data,cc.p(qy.winSize.width / 3 * 2, qy.winSize.height * 0.7))
end


function EquipView:createEquipList()
    self.equipList = cc.TableView:create(cc.size(510,563))
    self.equipList:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.equipList:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.equipList:setPosition(14,6)
    self.list_bg_1:addChild(self.equipList)
    self.equipList:setDelegate()
    --self.selectEquipIdx = 0

    local function numberOfCellsInTableView(table)
        if self.delegate.equipEntity then
            return #self.model:getNoUseEquipEntity(self.delegate.equipEntity)
        end
        return self.model:getEquipListLength(self.delegate.type)
    end

    local function tableCellTouched(table,cell)
        qy.QYPlaySound.playEffect(qy.SoundType.COMMON_CLICK)

        if self.selectEquipIdx ~= cell:getIdx() then
            if self.equipList:cellAtIndex(self.selectEquipIdx) then
                self.equipList:cellAtIndex(self.selectEquipIdx).item:removeSelected()
            end
            self.selectEquipIdx = cell:getIdx()
            self:setSelectedEquip(self:getEntity(self.selectEquipIdx + 1))
            self:updateContentOffset(true)
        elseif self.cell_isOpenStatus then
            cell.item:closeExpand(function()
                self:updateContentOffset(false)
            end)
        else
            self:updateContentOffset(true)
        end

    end

    local function cellSizeForTable(tableView, idx)
        if idx == self.selectEquipIdx and self.cell_isOpenStatus and self.model:getEquipEntity(self.delegate.type, idx + 1).tank_unique_id > 0 and not self.delegate.equipEntity then
            return 510, 233
        else
            return 510, 158
        end
    end
 
    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.equip.EquipInfoCell.new({
                ["idx"] = idx,
                ["type"] = self.delegate.type
                })
            cell:addChild(item)
            cell.item = item
        end

        local entity = self:getEntity(idx + 1) 

        if self.delegate.equipEntity then
            if entity.unique_id == self.delegate.unique_id then
                self.selectEquipIdx = idx
            end

            cell.item:render(entity, self.selectEquipIdx, idx)
        else
            cell.item:render(entity, self.selectEquipIdx, idx, function(cell)
                self.reformDialog = qy.tank.view.equip.ReformDialog.new(self, cell, self.delegate.type, idx + 1)
                self.reformDialog:show(true)
            end, function(cell)
                self.delegate.showEquipAdvanceView(self, cell, self.delegate.type, entity.unique_id)
            end,function(cell)
                self.delegate.showEquipClearView(self, cell, self.delegate.type, entity.unique_id)
            end)
        end
        

        if idx == self.selectEquipIdx then
            cell.item:setSelected(self.cell_isOpenStatus)
        else
            cell.item:removeSelected()
        end
        return cell
    end

    self.equipList:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.equipList:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    self.equipList:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    self.equipList:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    self.equipList:reloadData()
    self:setSelectedEquip(self:getEntity(self.selectEquipIdx + 1))
end

function EquipView:getEntity(idx)
    local entity
    if self.delegate.equipEntity then
        entity = self.model:getNoUseEquipEntity(self.delegate.equipEntity)[idx]
    else
        entity = self.model:getEquipEntity(self.delegate.type, idx)
    end

    return entity
end



function EquipView:updateContentOffset(flag)
    if not self.delegate.equipEntity then
        local open = self.cell_isOpenStatus
        if self.model:getEquipEntity(self.delegate.type, self.selectEquipIdx + 1).tank_unique_id <= 0 then
            flag = false
        end 
        self.cell_isOpenStatus = flag

        self.point = self.equipList:getContentOffset()

        local _len = self.len or 0

        if self.delegate.equipEntity then
            self.len = #self.model:getNoUseEquipEntity(self.delegate.equipEntity)
        else
            self.len = self.model:getEquipListLength(self.delegate.type)
        end

        if _len > 0 and _len > self.len then            
            self.point.y = self.point.y + 165
        end


        self.equipList:reloadData()

        if self.selectEquipIdx > 1 and open and flag or (not open and not flag) then
            self.equipList:setContentOffset(cc.p(self.point.x, self.point.y))
        elseif self.selectEquipIdx > 1 and open and not flag then
            self.equipList:setContentOffset(cc.p(self.point.x, self.point.y + 75))
        elseif self.selectEquipIdx > 1 and not open and flag then
            self.equipList:setContentOffset(cc.p(self.point.x, self.point.y - 75))
        end
    else
        if self.equipList:cellAtIndex(self.selectEquipIdx) then
            self.equipList:cellAtIndex(self.selectEquipIdx).item:setSelected()
        end
    end
end


--[[--
--更新装备列表
--]]
function EquipView:updateEquipList(flag)
    if self.equipList ~= nil then
        local listCurY = self.equipList:getContentOffset().y
        local dic = 0
        --self.equipList:reloadData()

        self:updateContentOffset(flag) 
    end
end

function EquipView:onEnter()
    --新手引导：注册控件
    qy.GuideCommand:addUiRegister({
        {["ui"] = self.equip_btn, ["step"] ={"SG_25"}},
        {["ui"] = self.strength_btn, ["step"] ={"SG_28","SG_31","SG_34"}},
        {["ui"] = self.exitBtn, ["step"] ={"SG_35"}},
    })
    self.equipViewOpen = true
    qy.tank.utils.cache.CachePoolUtil.addArmatureFile(qy.ResConfig.EQUIP_STRENG_EFFECTS)
    if self.equipList and tolua.cast(self.equipList, "cc.Node") then
        self:updateEquipList(false)
    else
        self:createEquipList()
    end
end

function EquipView:__showStrengEffert()
    if tolua.cast(self.list,"cc.Node") then
        self.list:showStrengEffert()
    end
end

--[[--
--选择道具
--@param #table entity 装备实体
--]]
function EquipView:setSelectedEquip(entity, _type)
    self.curEquipEntity = entity
    self.curEquipType = entity:getComponentEnglishName()
    if not tolua.cast(self.list,"cc.Node") then
        self.list =  qy.tank.view.equip.EquipInfoList.new({
            ["entity"] = entity,
            ["size"] = cc.size(500,480)
        })
        self.list_bg_2:addChild(self.list)
        self.list:setPosition(10,570)
    else
        self.list:update(entity)
    end


    if self.delegate.equipEntity then
        self.select_btn:setVisible(true)
        self.equip_btn:setVisible(false)
        self.strength_btn:setVisible(false)
        self.auto_strength_btn:setVisible(false)
        self.formationTitle:setVisible(false)        
    elseif entity.tank_unique_id == -1 then
        --装备碎片
        self.equip_btn:setVisible(false)
        self.strength_btn:setVisible(false)
        self.auto_strength_btn:setVisible(false)
        self.select_btn:setVisible(false)
        self.formationTitle:setVisible(true)
    else
        --强化
        self.formationTitle:setVisible(false)
        self.select_btn:setVisible(false)
        if self.delegate.type == "total" then
            self.equip_btn:setVisible(false)
            self.strength_btn:setVisible(true)
            self.strength_btn:setPosition(cc.p(151, 42))

            self.auto_strength_btn:setVisible(true)
            self.auto_strength_btn:setPosition(cc.p(371, 42))
        else
            self.equip_btn:setVisible(true)
            if entity.tank_unique_id == self.model:getFirstEquipTankUid() then

                --卸下
                self.btn_txt:setSpriteFrame(("Resources/common/txt/xiexia.png"))
                self.strength_btn:setVisible(true)
                self.auto_strength_btn:setVisible(true)
                self.strength_btn:setPosition(255,42)
                self.auto_strength_btn:setPosition(411,42)
                self.equip_btn:setPosition(99,42)
            else
                --装载
                self.btn_txt:setSpriteFrame(("Resources/common/txt/zhuangzai.png"))
                self.strength_btn:setVisible(false)
                self.auto_strength_btn:setVisible(false)
                self.equip_btn:setPosition(self.formationTitle:getPosition())
            end
        end
    end
    self.redDot:setVisible(entity:hasRedDot())
end

function EquipView:onExit()
    self:stopTimer()
    self.equipViewOpen = false
    --新手引导：移除控件注册
     qy.GuideCommand:removeUiRegister({"SG_25","SG_28","SG_31","SG_34","SG_35"})
    self.currentEffert = nil
    self.effertTable = {}
    qy.tank.utils.cache.CachePoolUtil.removeArmatureFile(qy.ResConfig.EQUIP_STRENG_EFFECTS)
end

return EquipView
