--[[
    奖品list
    Author: H.X.Sun
    Date: 2015-05-05
用法：
    local awardList = qy.AwardList.new({
        ["award"] = award,
        ["hasName"] = true,
        ["len"] = 3,--每行个数，默认是3
        ["type"] = 2,--当只有奖励个数少于len的时候，对齐方式 1：左对齐；2：中对齐；3：右对齐 默认是2
        ["cellSize"] = cc.size(240,180),--一个cell的大小，包括间距
        ["itemSize"] = 1, --cell的尺寸 1：大； 2：小 3更小。。 默认1
    })
--]]
local AwardList = class("AwardList", function()
    return cc.Node:create()
end)

function AwardList:ctor(delegate)
    self.award = delegate.award

    if delegate.hasName == false then
        self.hasName = false
    else
        self.hasName = true
    end

    self.itemSize = delegate.itemSize
    self.cellSize = delegate.cellSize or cc.size(240,180)
    self.len = delegate.len or 3
    self.type = delegate.type or 2
    self.isPub = delegate.isPub

    -- print("++++++++++++++++kkkkkllll",delegate.len)

    self:__createList()
    self:__arrange()

end

function AwardList:__createList()
    local awardItem
    local bgScale
    self.list = {}
    for i=1, #self.award do
        if self.itemSize == 2 then
            bgScale = 0.8
        elseif self.itemSize == 3 then
            bgScale = 0.6
        else
            bgScale = 1
        end
        awardItem = qy.tank.view.common.AwardItem.createAwardView(self.award[i] ,1,bgScale)
        if self.isPub then
            local pubFlag = cc.Sprite:createWithSpriteFrameName("Resources/common/img/pubflag.png")
            awardItem:addChild(pubFlag)
        end
        awardItem.fatherSprite:setSwallowTouches(false)
        awardItem:showTitle(self.hasName)

        if self.award[i].type == 22 then -- 军魂特殊处理，数量显示的是物品等级
            local data = qy.tank.view.common.AwardItem.getItemData(self.award[i])
            awardItem.num:setString("Lv." ..data.entity.level)
        end

        table.insert(self.list,awardItem)
        self:addChild(awardItem)
    end
end

--[[--
--只有奖励个数少于一行数，才会有对齐方式
--]]
function AwardList:__arrange()
    local posX = (self.len - #self.list) *  self.cellSize.width
    if #self.list < self.len then
        if self.type == 1 then
            --左对齐
            qy.tank.utils.TileUtil.arrange(self.list, self.len, self.cellSize.width, self.cellSize.height,cc.p(0,0))
        elseif self.type == 3 then
            --右对齐
            qy.tank.utils.TileUtil.arrange(self.list, self.len, self.cellSize.width, self.cellSize.height,cc.p(posX,0))
        else
            --中对齐
             qy.tank.utils.TileUtil.arrange(self.list, self.len, self.cellSize.width, self.cellSize.height,cc.p(posX / 2,0))
        end

    else
        qy.tank.utils.TileUtil.arrange(self.list, self.len, self.cellSize.width, self.cellSize.height,cc.p(0,0))
    end
end

--1，标题至于icon之上。
--2，标题至于icon之下。
--3 ,标题在框内，且在正下方
function AwardList:updateNamePosition(_pos)
    if self.hasName then
        for i = 1, #self.list do
            self.list[i]:setTitlePosition(_pos)
        end
    end
end

function AwardList:setTouchEnabled(flag)
    for i = 1, #self.list do
        self.list[i]:setTouchEnabled(flag)
    end
end

function AwardList:getList()
    return self.list
end

function AwardList:update(data)
    self.award = data
    self:__remove()
    self:__createList()
    self:__arrange()
end

function AwardList:__remove()
    self:removeAllChildren()
end

function AwardList:getHeight()
    return math.ceil(#self.list / self.len) * self.cellSize.height
end

return AwardList
