--[[--
	合金主界面
	Author: H.X.Sun
--]]--

local MainView = qy.class("MainView", qy.tank.view.BaseView, "alloy/ui/MainView")

local awardType = qy.tank.view.type.AwardType

function MainView:ctor(delegate)
	MainView.super.ctor(self)

	local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "alloy/res/alloy_embedded_title.png",
        ["onExit"] = function()
            delegate.dismiss()
        end
    })
    self:addChild(style, 13)
    self.delegate = delegate

    self.garageModel = qy.tank.model.GarageModel
    self.model = qy.tank.model.AlloyModel
    local PropShopModel = qy.tank.model.PropShopModel

    self:__initView()


    self:OnClick("help_btn",function()
        qy.tank.view.common.HelpDialog.new(10):show(true)
    end)

    self:OnClick("buy_btn",function()
    	qy.tank.command.MainCommand:viewRedirectByModuleType(
            qy.tank.view.type.ModuleType.PROP_SHOP,
            {["idx"] = PropShopModel:getAlloyChestIdx(),}
        )
    end,{["isScale"] =false})

    self:OnClick("left_btn",function()
    	self:moveToSelectEquip(2)
    end)

    self:OnClick("right_btn",function()
    	self:moveToSelectEquip(1)
    end)
end

function MainView:__initView()
	self:InjectView("help_btn")
    self.help_btn:setLocalZOrder(15)
    self:InjectView("list_bg")
    self:InjectView("mask")
    self.mask:setLocalZOrder(15)
    self:InjectView("e_name")
    self:InjectView("e_bg_top")
    self:InjectView("equip_top")

    self:OnClick("e_bg_top",function()
    	local entity = self.equipTable[self.curEquipIdx]
    	if entity and type(entity) == "table" then
			qy.alert:showTip(qy.tank.utils.TipUtil.createTipContent({
				["entity"] = entity,
				["type"] = awardType.EQUIP,
			}))
        else
            qy.hint:show(qy.TextUtil:substitute(41023))
		end
    end,{["isScale"] = false})

    for i = 1, 4 do
    	self:InjectView("e_bg_"..i)
    	self:InjectView("equip_"..i)
    	self:OnClick("e_bg_"..i,function()
            if self.curEquipIdx ~= i then
    			self:showOneEquipInfo(i, self.equipTable[i])
    		end
    	end,{["isScale"] = false})

    	if i < 4 then
    		self:InjectView("a_bg_"..i)
    		self:InjectView("alloy_"..i)
    		self:InjectView("a_name_"..i)
    		self:OnClick("a_bg_"..i,function()
                local _equipEntity =  self.equipTable[self.curEquipIdx]
                if _equipEntity == nil or type(_equipEntity) == "number" then
                    --未装载装备
                    qy.hint:show(qy.TextUtil:substitute(41024))
                elseif _equipEntity.alloy and _equipEntity.alloy["p_"..i] > 0 then
                    --已装载合金
                    self.delegate.showPreview(self.curAlloyEntityList[i],_equipEntity)
                else
                    --未装载合金
                    self.delegate.showEmbeddedList(i,self.model.OPNE_LISTT_1,_equipEntity)
                end
    		end,{["isScale"] = false})
    	end
    end
end

function MainView:createTankList()
	self.tankList = cc.TableView:create(cc.size(260,587))
    self.tankList:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tankList:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.tankList:setPosition(32,0)
    self.list_bg:addChild(self.tankList)
    self.tankList:setDelegate()
    self.selectIdx = 0

    local function numberOfCellsInTableView(table)
        return 6
    end

    local function tableCellTouched(table,cell)
        local value = self.garageModel.formation[cell:getIdx()+1]

        if self.selectIdx ~= cell:getIdx() then
            qy.QYPlaySound.playEffect(qy.SoundType.SWITCH_TANK)
        end
        local before = table:cellAtIndex(self.selectIdx)
        if before then
            before.item.light:setVisible(false)
        end
        self.selectIdx = cell:getIdx()
        local now = table:cellAtIndex(self.selectIdx)
        if now then
            now.item.light:setVisible(true)
        end

        self:showEquipList(value, false)
    end

    local function cellSizeForTable(tableView, idx)
        return 210, 130
    end

    local function tableCellAtIndex(table, idx)
        local strValue = string.format("%d",idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("alloy.src.TankCell"):new()
            cell:addChild(item)
            cell.item = item
        end
        cell.item:render(self.garageModel.formation[idx+1])
        if self.selectIdx == idx then
            cell.item.light:setVisible(true)
        else
            cell.item.light:setVisible(false)
        end
        return cell
    end

    self.tankList:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.tankList:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    self.tankList:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    self.tankList:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)

    self.tankList:reloadData()
end

function MainView:moveToSelectEquip(_type)
	local index = 0
	if _type == 1 then
		--左
		index = self.curEquipIdx % 4 + 1
	else
		--右
		index = self.curEquipIdx - 1
		if index < 1 then
			index = 4
		end
	end
	self:showOneEquipInfo(index, self.equipTable[index])
end

function MainView:showAlloyByIndex(_index)
	-- print("_index========>>>>",_index)
	local _equipEntity =  self.equipTable[self.curEquipIdx]
	if _equipEntity == nil or type(_equipEntity) == "number" then
        self["a_name_".._index]:setString("")
        self["alloy_".._index]:setTexture("Resources/common/bg/c_12.png")
        self["alloy_".._index]:stopAllActions()
    elseif _equipEntity.alloy and _equipEntity.alloy["p_".._index] and _equipEntity.alloy["p_".._index] > 0 then
		self["alloy_".._index]:stopAllActions()
    	self["alloy_".._index]:setScale(1)
    	self["alloy_".._index]:setOpacity(255)
        self.curAlloyEntityList[_index] = _equipEntity:getAlloyEntityByAlloyId(_index)
		-- print("self.curAlloyEntityList[_index]:getIcon()===>>>",self.curAlloyEntityList[_index]:getIcon())
        self["alloy_".._index]:setTexture(self.curAlloyEntityList[_index]:getIcon())
        self["a_name_".._index]:setString(self.curAlloyEntityList[_index]:getName())
        self["a_name_".._index]:setTextColor(self.curAlloyEntityList[_index]:getColor())
	else
        local time = 1
    	self["a_name_".._index]:setString(self.model:getAttributeNameByAlloyId(_index) .. qy.TextUtil:substitute(41025))
        self["a_name_".._index]:setTextColor(cc.c4b(255,255,255,255))
		self["alloy_".._index]:setSpriteFrame("alloy/res/hjqr_0019.png")
        local scaleSmall = cc.ScaleTo:create(time,0.9)
        local scaleBig = cc.ScaleTo:create(time,1)
        local FadeIn = cc.FadeTo:create(time, 255)
        local FadeOut = cc.FadeTo:create(time, 0)
        local spawn1 = cc.Spawn:create(scaleSmall,FadeOut)
        local spawn2 = cc.Spawn:create(scaleBig,FadeIn)
        local seq = cc.Sequence:create(spawn1, spawn2)
        self["alloy_".._index]:runAction(cc.RepeatForever:create(seq))
	end
end

function MainView:showOneEquipInfo(index, entity)
	self:setDefaultSize()
	if entity and type(entity) == "table" then
		self["e_bg_top"]:loadTexture(entity:getIconBg(),1)
    	self["equip_top"]:setTexture(entity:getIcon())
    	self.e_name:setString(entity:getName())
    	self.e_name:setTextColor(entity:getTextColor())
    else
    	self["e_bg_top"]:loadTexture("Resources/common/item/item_bg_1.png",1)
        self["equip_top"]:setSpriteFrame("Resources/garage/equip_d"..index..".png")
    	self.e_name:setTextColor(qy.tank.utils.ColorMapUtil.qualityMapColor(1))
    	self.e_name:setString(qy.TextUtil:substitute(41026))
    end
	self["e_bg_"..index]:setScale(1.2)
    self.curEquipIdx = index
    self.curAlloyEntityList = {}
    for i = 1, 3 do
    	self:showAlloyByIndex(i)
    end
end

function MainView:setDefaultSize()
	if self.curEquipIdx then
		self["e_bg_"..self.curEquipIdx]:setScale(1)
	end
end

--[[--
--显示当前坦克的装备
--@param #table entity 坦克实体 当为0或者-1时，表示没有上阵的坦克
--]]
function MainView:showEquipList(entity, _isRefresh)
	self:setDefaultSize()
	local isShowTopEquip = false
	self.equipTable = {}

    if type(entity) == "table" then
        self.equipTable = entity:getEquipEntity()
        if self.equipTable then
            self.selectTankUid = entity.unique_id
            for i = 1, 4 do
                if type(self.equipTable[i]) == "table" then
                    self:setLoadEquipByIndx(i, self.equipTable[i])
                    if not isShowTopEquip and not _isRefresh then
                    	self:showOneEquipInfo(i, self.equipTable[i])
                    	isShowTopEquip = true
                    end
                else
                    self:setEquipDefaultStatusByEquipIndex(i)
                end
            end
            if _isRefresh and tonumber(self.curEquipIdx) then
                self:showOneEquipInfo(self.curEquipIdx, self.equipTable[self.curEquipIdx])
                isShowTopEquip = true
            end
            if not isShowTopEquip then
                self:showOneEquipInfo(1)
            end
        else
            for i = 1, 4 do
                self:setEquipDefaultStatusByEquipIndex(i)
            end
            self:showOneEquipInfo(1)
        end
    else
        for i = 1, 4 do
            self:setEquipDefaultStatusByEquipIndex(i)
        end
        self:showOneEquipInfo(1)
    end
end

--[[--
--设置已装备
--]]
function MainView:setLoadEquipByIndx(index, entity)
    self["e_bg_"..index]:loadTexture(entity:getIconBg(),1)
    self["equip_"..index]:setTexture(entity:getIcon())
    if self.equipEffertTable == nil then
    	self.equipEffertTable = {}
    end

    if self.equipEffertTable[index] == nil and entity:getSuitID() > 0 then
        self.equipEffertTable[index] = self:createEquipSuitEffert(self["equip_"..index])
    end

    if entity:getSuitID() == 0 then
        if self.equipEffertTable[index] then
            self.equipEffertTable[index]:setVisible(false)
        end
    else
        if self.equipEffertTable[index] == nil then
            self.equipEffertTable[index] = self:createEquipSuitEffert(self["equip_"..index])
        end
        self.equipEffertTable[index]:setVisible(true)
    end
end

--[[--
--设置装备默认状态
--]]
function MainView:setEquipDefaultStatusByEquipIndex(index)
    self["e_bg_"..index]:loadTexture("Resources/common/item/item_bg_1.png",1)
    self["equip_"..index]:setSpriteFrame("Resources/garage/equip_d"..index..".png")
    if self.equipEffertTable and self.equipEffertTable[index] then
        self.equipEffertTable[index]:setVisible(false)
    end
end

function MainView:createEquipSuitEffert(_target)
    local _effert = ccs.Armature:create("Flame")
    _target:addChild(_effert,999)
    _effert:setPosition(51,49)
    _effert:getAnimation():playWithIndex(0)
    return _effert
end

function MainView:updateTankList()
	if self.tankList then
        local listCurY = self.tankList:getContentOffset().y
        self.tankList:reloadData()
        self.tankList:setContentOffset(cc.p(0,listCurY))
    end
end

function MainView:onEnter()
    local _isRefresh = false
	if self.tankList == nil or not tolua.cast(self.tankList, "cc.Node") then
        self:createTankList()
    else
        self:updateTankList()
        _isRefresh = true
    end
    self:showEquipList(self.garageModel.formation[self.selectIdx+1],_isRefresh)
end

function MainView:onExit()
	-- body
end

return MainView
