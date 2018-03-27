--[[--
--开服礼包cell
--Author: H.X.Sun
--Date: 2015-06-24
--]]--

local ShangChengCell = qy.class("ShangChengCell", qy.tank.view.BaseView, "legion_generaltion/ui/ShangChengCell")

function ShangChengCell:ctor(delegate)
    ShangChengCell.super.ctor(self)
    self:InjectView("ZuanShi")
    self:InjectView("GouWuka")
    self:InjectView("GouWuka2")

    self:InjectView("Node_1")
    self:InjectView("Node_1_0")
    self:InjectView("bg")
    self:InjectView("YiLingqu")
    self:InjectView("Button_1")

    self.service = qy.tank.service.LegionGeneraltionService
    self.model = qy.tank.model.LegionGeneraltionModel



    
    self:OnClick("Button_1",function(sender)

        self.service:GetgetawardData(self.shopData.type,self.shopData.id,function ( data )
                
                self.model:SetShopInID( self.shopData.id )
                self.model:SetShopCardNum( self.GouWukanum )
                self:UpdateState()
                self.idxdelegate:Updata()

                qy.tank.command.AwardCommand:add(data.award)
                qy.tank.command.AwardCommand:show(data.award,{["critMultiple"] = data.weight})
            end)
    end)

end


function ShangChengCell:UpdateState(  )

    local state = self.model:GetShopInID(self.shopData.id) 
    self.YiLingqu:setVisible(state == false )
    self.Button_1:setTouchEnabled(state==true)
    self.Button_1:setBright(state==true)
end



function ShangChengCell:render(idx,data)

    self.shopData = data
    self.GouWukanum = 0
    self.idxdelegate = idx.delegate



    if idx.mIndexShop == 1 then
        self.ZuanShi:setString(data["expend"][1].num)
        self.GouWuka:setString(data["expend"][2].num)
        self.GouWukanum = data["expend"][2].num

    else
        self.GouWuka2:setString(data["expend"][1].num)
        self.GouWukanum = data["expend"][1].num
    end
    self.Node_1_0:setVisible(idx.mIndexShop == 2)
    self.Node_1:setVisible(idx.mIndexShop == 1)


    self:UpdateState()



    if self.mitem then
        self.bg:removeChild(self.mitem)
        self.mitem = nil
    end


    if self.mitem == nil then
	 	local item = qy.tank.view.common.AwardItem.createAwardView(data["award"][1] ,1)
	  	item:setPosition(self.YiLingqu:getPosition())
	  	item:setScale(0.8)
	  	item.fatherSprite:setSwallowTouches(false)
        item.name:setVisible(false)
	  	self.mitem = item
	  	self.bg:addChild(item)
    end
end




return ShangChengCell