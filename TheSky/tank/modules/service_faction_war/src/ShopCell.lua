

local ShopCell = qy.class("ShopCell", qy.tank.view.BaseView, "service_faction_war/ui/ShopCell")

local model = qy.tank.model.ServerFactionModel
local service = qy.tank.service.ServerFactionService
function ShopCell:ctor(delegate)
    ShopCell.super.ctor(self)
    self.delegate = delegate
    self:InjectView("rank")
    self:InjectView("num1")
    self:InjectView("num2")
    self:InjectView("des")
    self:InjectView("buyBt")
    self:InjectView("awardbg")
    self:InjectView("Award_Node")
    self:InjectView("Icon_1")
    self:InjectView("name")
    self:OnClick("buyBt",function()
        service:getShopAward(self.award,self.id,function (  )
            model:changeGongXian(self.contribution)
            model:changeNums(self.id)
            delegate:callback()
            qy.Event.dispatch(qy.Event.REFRESHMAINVIEW)
        end)
    end)

end

function ShopCell:render(idx,camp_type)
    self.Award_Node:removeAllChildren()
    local data = model:getAward(idx,camp_type)
    self.id = data.id
    self.award = data.award
    self.contribution = data.contribution
    local item = qy.tank.view.common.AwardItem.createAwardView(data.award[1],1)
    self.Award_Node:addChild(item)
    item:setScale(0.8)
    self.num1:setString("贡献："..data.contribution)

    local des_name = model:getName(data.level)
    self.name:setString(des_name.."以上可兑换")

    --self.des:setString(des_name.."以上可兑换")
    local my_nums = model:getNums(self.id)
    if data.name ~= "" then
        self.des:setString(data.name..":"..(data.limit_num - my_nums).."/"..data.limit_num)
    else
        self.des:setString("")
    end
    cc.SpriteFrameCache:getInstance():addSpriteFrames("service_faction_war/res/common.plist")

    local xun_type,nums = model:getXunZhang(data)
    self.Icon_1:loadTexture(xun_type,0)
    self.Icon_1:setScale(0.4)
    self.num2:setString("X"..nums)

end


return ShopCell
