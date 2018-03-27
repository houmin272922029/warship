--[[--
--折扣贩售cell
--Author: lijian ren
--Date: 2015-08-04
--]]--

local DiscountSaleCell = qy.class("DiscountSaleCell", qy.tank.view.BaseView, "discount_sale/ui/salecell")

local tankType = qy.tank.view.type.AwardType.TANK
local _moduleType = qy.tank.view.type.ModuleType.ACHIEVE_SHARE

function DiscountSaleCell:ctor(delegate)
    DiscountSaleCell.super.ctor(self)
    self.model = qy.tank.model.OperatingActivitiesModel
    local service = qy.tank.service.OperatingActivitiesService
    self.type = 1
    self:InjectView("bg")
    self:InjectView("countNum")--打折数
    self:InjectView("SunNum")--剩余次数
    self:InjectView("Buy_bt")
    -- qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.RECHARGE)
    self:OnClick("Buy_bt", function(sender)
        print("第几个啊 ",self.index)
        local dataa = self.model:getDiscountByIndex(self.index)
        local dataname = qy.tank.view.common.AwardItem.getItemData(dataa.award[1])
        print("----------",json.encode(dataa))
        local function callBack(flag)
            if flag == qy.TextUtil:substitute(4012) then
                service:BuyDicountSale(self.index,function (data)
                -- 刷新逻辑
                self:updateButton(self.index)
                end)
            end
        end
    local num = tonumber(dataa.award[1].num)
    local numStr = num <=1 and "" or "x"..num

    local itemData = qy.tank.view.common.AwardItem.getItemData(dataa.award[1])
    --手写弹出框
    local image = ccui.ImageView:create()
    image:setContentSize(cc.size(500,120))
    image:setScale9Enabled(true)
    image:loadTexture("Resources/common/bg/c_12.png")

    local color = qy.tank.utils.ColorMapUtil.qualityMapColorFor3b(itemData.quality)

    local richTxt = ccui.RichText:create()
    richTxt:ignoreContentAdaptWithSize(false)
    richTxt:setContentSize(500, 150)
    richTxt:setAnchorPoint(0,0.5)
    local stringTxt1 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, qy.TextUtil:substitute(4007), qy.res.FONT_NAME_2, 24)
    richTxt:pushBackElement(stringTxt1)
    local stringTxt2 = ccui.RichElementText:create(2, cc.c3b(30,144,255), 255, dataa.expend[1].num , qy.res.FONT_NAME_2, 24)
    richTxt:pushBackElement(stringTxt2)
    local stringTxt3 = ccui.RichElementText:create(3, cc.c3b(255,255,255), 255, qy.TextUtil:substitute(90039), qy.res.FONT_NAME_2, 24)
    richTxt:pushBackElement(stringTxt3)
    local stringTxt4 = ccui.RichElementText:create(4, color, 255, dataname.name , qy.res.FONT_NAME_2, 24)
    richTxt:pushBackElement(stringTxt4)
    local stringTxt5 = ccui.RichElementText:create(5, cc.c3b(255,255,0), 255, numStr , qy.res.FONT_NAME_2, 24)
    richTxt:pushBackElement(stringTxt5)
    image:addChild(richTxt)


    qy.alert:showWithNode(qy.TextUtil:substitute(4010),  image, cc.size(560,250), {{qy.TextUtil:substitute(4011) , 4},{qy.TextUtil:substitute(4012) , 5} }, callBack, {})
    image:setPosition(image:getPositionX() + 5, image:getPositionY() - 30)
        -- local alertMesg = "确定要花费"..dataa.expend[1].num.."钻石购买".. dataname.name.."吗？"
        -- qy.alert:show({"购买提示" ,{255,255,255} }  ,  alertMesg , cc.size(450 , 220),{{qy.TextUtil:substitute(70057) , 4}   , {qy.TextUtil:substitute(70054) , 5}} ,callBack,"")
    end)
end

function DiscountSaleCell:render(_idx)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("discount_sale/res/ui.plist")
    self.data = self.model:getDiscountByIndex(_idx)
    self:updateButton(_idx)
    self.expendList = qy.AwardList.new({
        ["award"] = self.data.expend,
        ["cellSize"] = cc.size(80,80),
        ["type"] = self.data.expend.type,
        ["itemSize"] = 1,
        ["hasName"] = false,
    })
    self.expendList:setPosition(15,170)
    self.bg:removeAllChildren()
    self.bg:addChild(self.expendList)

    self.awardList = qy.AwardList.new({
        ["award"] = self.data.award,
        ["cellSize"] = cc.size(80,80),
        ["type"] = self.data.award.type,
        ["itemSize"] = 1,
        ["hasName"] = false,
    })
    self.awardList:setPosition(256,170)
    self.bg:addChild(self.awardList)
end

function DiscountSaleCell:updateButton(_idx)
    self.index = _idx
    local datas  = self.model:getDiscountByIndex(_idx)
    local discountNum = tostring(datas.discount)
    local png = "discount_sale/res/zhekou"..discountNum..".png"
    local num = tostring(datas.limit_num-datas.pay_num)
    local Num
    if datas.limit_num == 0 then
        Num=""
        self.Buy_bt:setTouchEnabled(true)
        self.Buy_bt:setEnabled(true)
        self.Buy_bt:setPosition(603,80)
    else
        Num = num.."/"..datas.limit_num
        self.Buy_bt:setPosition(603,65)
        if datas.limit_num == datas.pay_num then
            self.Buy_bt:setTouchEnabled(false)
            self.Buy_bt:setEnabled(false)
        else
            self.Buy_bt:setTouchEnabled(true)
            self.Buy_bt:setEnabled(true)
        end
    end
    self.SunNum:setString(Num)
    self.countNum:setSpriteFrame(png)
    

end


return DiscountSaleCell
