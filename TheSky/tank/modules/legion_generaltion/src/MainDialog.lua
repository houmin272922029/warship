local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "legion_generaltion.ui.Maindialog")

local model = qy.tank.model.LegionGeneraltionModel
local service = qy.tank.service.LegionGeneraltionService

function MainDialog:ctor(delegate)
   	MainDialog.super.ctor(self)
    self:InjectView("BG")
    self:InjectView("TimeNum")
    self:InjectView("ShopCardNum")
   	self:OnClick("Btn_close", function()
        self:removeSelf()
    end,{["isScale"] = false})


    for i=1,4 do
        self:InjectView("Button_"..i)
        self["Button_"..i]:setTag(i)
    end


    local function CloseParent( ... )
         self:removeSelf()
    end




    local function Button_1Click( _d, _sender )
        if self.mKuangQuLayer == nil then
            self.mKuangQuLayer = require("legion_generaltion.src.ZhengZhanKuangQu").new({
            })
            self:addChild(self.mKuangQuLayer)
            self.mKuangQuLayer.CloseParentFun = CloseParent
        end
        self.mKuangQuLayer:UpdataText(1)
        self:SelectShowLayer( _sender )
    end 

    self.mButton_1Clickfun = Button_1Click


    self:UpdateDate()
    -- 矿区
    self:OnClick("Button_1",function(d,sender)
        Button_1Click(d,sender)
    end)

    -- 押运
    self:OnClick("Button_2",function(d,sender)
        if self.mKuangQuLayer then
            self.mKuangQuLayer:UpdataText(2)
        end
        self:SelectShowLayer( sender )
    end)

    -- 兑换商城
    self:OnClick("Button_3",function(d,sender)

        if self.mDuiHuanShopLayer == nil  then
            self.mDuiHuanShopLayer = require("legion_generaltion.src.DuiHuanShop").new({
                ["Updata"] = function ( ... )
                    self:UpdateDate()
                end
            })
            self:addChild(self.mDuiHuanShopLayer)  
            self.mDuiHuanShopLayer.CloseParentFun = CloseParent        
        end
        self:SelectShowLayer( sender )

    end)


    -- 积分排行榜
    self:OnClick("Button_4",function(d,sender)
        if self.mRankLayer == nil  then
            self.mRankLayer = require("legion_generaltion.src.JunTuanPaiHang").new({
            })
            self:addChild(self.mRankLayer)  
            self.mRankLayer.CloseParentFun = CloseParent        
        end
        self:SelectShowLayer( sender )

    end)


    self:OpenSelfHandle()

end

function MainDialog:SelectShowLayer( _button )
    for i=1,4 do
        self["Button_"..i]:setBright(true)
    end
    _button:setBright(false)
    local _index = _button:getTag()
    if self.mKuangQuLayer then
        self.mKuangQuLayer:setVisible( _index == 1 or _index == 2 )
    end

    if self.mDuiHuanShopLayer then
        self.mDuiHuanShopLayer:setVisible( _index == 3 )
    end


    if self.mRankLayer then
        self.mRankLayer:setVisible( _index == 4)
    end
end


--[[
    初始化打开界面
]]--

function MainDialog:OpenSelfHandle(  )

    self.mButton_1Clickfun(self,self.Button_1)
end

function MainDialog:UpdateDate( ... )
    print("111")
    self:setTime()
end

function MainDialog:setTime()

    local Su = model:GetSurplusTiems()
    self.TimeNum:setString(qy.tank.utils.DateFormatUtil:toDateString(Su,1))

    local scnum = model:GetShopCardNum()
    self.ShopCardNum:setString(scnum)
end

return MainDialog
