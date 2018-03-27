--[[
	最强之战-积分商城
	Author: H.X.Sun
]]

local ShopCell = qy.class("ShopCell", qy.tank.view.BaseView, "greatest_race/ui/ShopCell")

function ShopCell:ctor(delegate)
    ShopCell.super.ctor(self)
    self.delegate = delegate
    self.model = qy.tank.model.GreatestRaceModel

    self:InjectView("list_node")
    for i = 1,4 do
        self:InjectView("btn_"..i)
        self:OnClickForBuilding("btn_"..i,function()
            -- print("xxxxxxxx===",i)
            self.model:setShopSelectIndex(self.last_idx + i)
            delegate.callBack()
        end)
    end
end

function ShopCell:render(idx)
    self.last_idx = idx*4
    self.list_node:removeAllChildren()
    local award = {}
    local index,fdata
    local select = self.model:getShopSelectIndex()
    for i = 1, 4 do
        index = self.last_idx + i
        if index == select then
            self["btn_"..i]:loadTexture("greatest_race/res/select_light.png",1)
        else
            self["btn_"..i]:loadTexture("Resources/common/bg/c_12.png",0)
        end
        local cdata = self.model:getShopListByIndex(index)
        if cdata then
            self["btn_"..i]:setTouchEnabled(true)
            fdata = {["type"]=14,["num"]=0,["id"]=cdata.propid}
            table.insert(award,fdata)
        else
            self["btn_"..i]:setTouchEnabled(false)
        end
    end
    local awardList = qy.AwardList.new({
        ["award"] = award,
        ["hasName"] = false,
        ["len"] = 4,
        ["type"] = 1,
        ["cellSize"] = cc.size(127,40),
        ["itemSize"] = 2,
    })
    self.list_node:addChild(awardList)
    awardList:setPosition(66,94)
    awardList:setTouchEnabled(false)
end

return ShopCell
