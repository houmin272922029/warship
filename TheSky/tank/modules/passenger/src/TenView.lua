
local TenView = qy.class("TenView", qy.tank.view.BaseDialog, "passenger.ui.TenView")

local PassengerService = qy.tank.service.PassengerService
local model = qy.tank.model.StorageModel
local StorageModel = qy.tank.model.StorageModel
local PassengerModel = qy.tank.model.PassengerModel
local UserInfoModel = qy.tank.model.UserInfoModel

function TenView:ctor(delegete)
   	TenView.super.ctor(self)
   	self:InjectView("awardlist")
    self:InjectView("agionBt")
    self:InjectView("backBt")
    for i=1,2 do
        self:InjectView("list"..i)
        self:InjectView("listnum"..i)
    end
    self:OnClick("backBt",function(sender)
        delegete:callback()--刷新资源的
        self:removeSelf()
    end)
    self:OnClick("agionBt",function(sender)
       if self.type == 100 then
            if StorageModel:getPropNumByID(51) > 9 then
                PassengerService:extract({
                        ["num"] = 10,
                        ["type"] = 100,
                    },function(reData)
                        StorageModel:remove(51, 10)
                        self:update()
                        self:updateaward(reData.award)
                end)
            else
                qy.hint:show(qy.TextUtil:substitute(12001))
                qy.tank.model.PropShopModel:init()
                local entity = qy.tank.model.PropShopModel:getShopPropsEntityById(24)
                local buyDialog = qy.tank.view.shop.PurchaseDialog.new(entity,function(num)
                    local service = qy.tank.service.ShopService
                    service:buyProp(entity.id,num,function(data)
                        if data and data.consume then
                            qy.hint:show(qy.TextUtil:substitute(8029)..data.consume.num)
                        end
                        self:update()
                    end)
                end)
                buyDialog:show(true)
            end
       else
            PassengerService:extract({
                    ["num"] = 10,
                    ["type"] = 200,
                },function(reData)
                    self:update()
                    self:updateaward(reData.award)
            end)
       end
    end)
    self.type = delegete.type
    self:updateaward(delegete.data)
    self:update()
end
function TenView:update(  )
    self.listnum2:setString(UserInfoModel.userInfoEntity.diamond)
    local itemNums = StorageModel:getPropNumByID(51)
    self.listnum1:setString(itemNums)
    self.list1:setVisible(self.type == 100)
    self.list2:setVisible(self.type == 200)
end

function TenView:updateaward( data )
    self.agionBt:setEnabled(false)
    self.awardlist:removeAllChildren(true)
    -- for i=1,#data do
    --     local item = qy.tank.view.common.AwardItem.createAwardView(data[i] ,1)
    --     self.awardlist:addChild(item)
    --     item:setScale(1.2)
    --     if i < 6 then
    --         item:setPosition(270 + 180*(i - 1), 420)
    --     else
    --         item:setPosition(270 + 180*(i - 6), 180)
    --     end
    -- end
    if self.itemContainer ~=nil then
        self:removeChild(self.itemContainer , true)
    end
    self.itemContainer = cc.Node:create()
    self:addChild(self.itemContainer)

    self.itemContainer:setPosition(qy.winSize.width/2 - 400 , 480)
    for i=1,  #data do
        local item = qy.tank.view.common.AwardItem.createAwardView(data[i] ,1, 1.1)
        -- item:setScale(1.4)
        x =   (i-1)%5 * 200
        y =  - math.floor((i-1)/5) * 200
        self.itemContainer:addChild(item)
        self:runSingleCard(item , cc.p(500,qy.winSize.height ) , cc.p(x,y) , i*0.2 , i == #data and true or false)
    end
end
function TenView:runSingleCard( card , startPoint , endPoint ,delayTime , isEnd)
    card:setScale(0.1)
    card:setPosition(startPoint)
    local runTime = 0.5
    local fadeIn = cc.FadeIn:create(runTime) -- 渐入
    local rotate = cc.RotateBy:create(runTime,360) -- 旋转
    local scale = cc.ScaleTo:create(runTime,1) --  缩放
    local max = 100
    function getRandom()
        local randomNum = max*math.random() - max*math.random()
        return randomNum
    end
    local bezier ={
            startPoint,--起始点
            cc.p(getRandom(),getRandom()),--控制点
            endPoint--结束点
        }
        local bezierTo = cc.BezierTo:create(runTime, bezier)
        local spawn = cc.Spawn:create(fadeIn , rotate , scale , bezierTo)
        local delay = cc.DelayTime:create(delayTime)
        -- local sound = cc.CallFunc:create(function()
        --     qy.QYPlaySound.playEffect(qy.SoundType.SWITCH_CHAPTER)
        -- end)
        local seq = cc.Sequence:create(delay , spawn,cc.CallFunc:create(function()
            if isEnd then
                -- self.isPlaying = false
                self.agionBt:setEnabled(true)
            end
        end))
        card:runAction(seq)
end

function TenView:onEnter()
    
end

function TenView:onExit()

end

return TenView