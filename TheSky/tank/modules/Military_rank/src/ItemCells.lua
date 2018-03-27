
local ItemCells = qy.class("ItemCells", qy.tank.view.BaseView, "Military_rank/ui/ItemCell")

local Service = qy.tank.service.MilitaryRankService
local  model = qy.tank.model.MilitaryRankModel
local StringUtil = qy.tank.utils.String
local ColorMapUtil = qy.tank.utils.ColorMapUtil
function ItemCells:ctor(delegate)
    ItemCells.super.ctor(self)
    self.h = 100
    self.status = 0
    self.num = 0
    self.delegate = delegate
    self:InjectView("Panel_1")
    self:InjectView("bg")
    self:InjectView("Image_1")
    self:InjectView("titletext")--特权名称
    self:InjectView("ranktext")--军衔
    self:InjectView("rankimage")--军衔图
    self:InjectView("actnum_3")--当前攻击力
    self:InjectView("fangnum_3")--当前防御力
    self:InjectView("lifenum_3")--生命值
    self.Panel_1:setSwallowTouches(false)
    -- self:OnClick("bg", function(sender)
    --     self:update()
    --     delegate:update()
    -- end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})
    self:OnClickForBuilding("bg", function()
        print("mmmmm",self.touchType)
        if self.touchType == true then
            self:update()
            delegate:update()
        end
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})
    self.bg:setSwallowTouches(false)
    self.bg:setTouchEnabled(true)

    self.list = {}
    self.level = model:getRankLevel()--或许当前等级
end
function ItemCells:render(_idx)
    self.data ={}
    self.data2 ={}
    self.data = model:getlocalDateById(_idx)
    self.data2 = model:getlocalLevelDateById(_idx)
    self:update()
    self:initData(_idx)
end
function ItemCells:initData(_idx)
    --做初始化数据和奖励
    local award =  self.data.award
    for i=1,#award do
        local item = qy.tank.view.common.AwardItem.createAwardView(award[i] ,1)
        self.Panel_1:addChild(item)
        item:setPosition(330 + 120*(i - 1), 60)
        item:setScale(0.8)
        item.name:setVisible(false)
    end
    -- self.titletext:setString(self:getDescInfoByStr(self.data.desc))
    self.ranktext:setString(self.data.nickname)
    -- local attackNum = 0
    -- local defenseNum = 0
    -- local blookNum = 0
    if _idx == self.level then
        self.bg:loadTexture("Military_rank/res/26.png",1)
        -- attackNum = model:GetNumById(1)
        -- defenseNum = model:GetNumById(2)
        -- blookNum = model:GetNumById(3)
    else
        self.bg:loadTexture("Military_rank/res/25.png",1)
        -- attackNum = 10
        -- defenseNum = 10
        -- blookNum = 10
    end

    local _att = 0
    local _def = 0
    local _blod = 0
    if _idx ~= 1 then 
        for i=1,_idx-1 do
            local data2 =  model:getlocalLevelDateById(i)
            _att = _att + data2.attack*10
            _def = _def + data2.defense*10
            _blod = _blod + data2.blood*10
        end
    end
    local att = self.data.attack + self.data2.attack*10 + _att
    self.actnum_3:setString("攻击力+"..att)

    local defense = self.data.defense + self.data2.defense*10 + _def
    self.fangnum_3:setString("防御力+"..defense)

    local blood = self.data.blood + self.data2.blood*10 + _blod
    self.lifenum_3:setString("生命值+"..blood)

    local png = "Military_rank/res/rank/"..self.data.id..".png"
    self.rankimage:loadTexture(png,1)
    if _idx == self.level then
        self.bg:loadTexture("Military_rank/res/26.png",1)
    else
        self.bg:loadTexture("Military_rank/res/25.png",1)
    end
     local dess = model:getDescInfoByStr(self.data.desc,2)
    self.titletext:setString("")
    dess:setPosition(-10,0)
    self.titletext:addChild(dess)
    
end
function ItemCells:update()
    if self.status == 1 then
        self.Panel_1:setVisible(true)
        -- self:createlist(self.data)
        self.Panel_1:setPositionY(0)
        self.bg:setPositionY(300 + 10)
        self.h = 100+300 
    else
        self.Panel_1:setVisible(false)
        self.old_h = self.h
        self.h = 100
        self.bg:setPositionY(10)
    end

    self.status = self.status == 1 and 0 or 1

    self.Image_1:setFlippedY(self.status == 0)
end

function ItemCells:onEnter()
    self.listener = cc.EventListenerTouchOneByOne:create()
    local function onTouchBegan(touch, event)
        self.touchPoint1 = touch:getLocation()
        return true
    end

    local function onTouchMoved(touch, event)
        self.touchPoint = self.bg:convertToNodeSpace(touch:getLocation())
        return true
    end

    local function onTouchEnded(touch, event)
        self.touchPoint2 = touch:getLocation()
        if math.abs(self.touchPoint1.y - self.touchPoint2.y) <=5 then
            self.touchType = true
        else
            self.touchType = false
        end
        return true

    end

    self.listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
    self.listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED)
    self.listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED)
    self.eventDispatcher = self:getEventDispatcher()
    self.eventDispatcher:addEventListenerWithSceneGraphPriority(self.listener,self.bg)
end

function ItemCells:onExit()
    self:getEventDispatcher():removeEventListener(self.listener)
end



return ItemCells
