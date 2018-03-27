local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "fire_rebate.ui.Maindialog")

local model = qy.tank.model.FireRebateModel
local service = qy.tank.service.FireRebateService

function MainDialog:ctor(delegate)
   	MainDialog.super.ctor(self)
    self:InjectView("BG")
    self:InjectView("TimeNum")

   	self:OnClick("Btn_close", function()
        if model:GetLuckdrawState() then
            return
        end

        self:removeSelf()
    end,{["isScale"] = false})


    for i=1,3 do
        self:InjectView("Button_"..i)
        self["Button_"..i]:setTag(i)
    end


    local function CloseParent( ... )
         self:removeSelf()
    end




    local function Button_1Click( _d, _sender )
        if self.mLeijiLoginLayer == nil then
            self.mLeijiLoginLayer = require("fire_rebate.src.LeijiDengLu").new({
            })
            self:addChild(self.mLeijiLoginLayer)
            self.mLeijiLoginLayer.CloseParentFun = CloseParent
        end
        self:SelectShowLayer( _sender )
    end 

    self.mButton_1Clickfun = Button_1Click


    self:UpdateDate()
    -- 累计登录
    self:OnClick("Button_1",function(d,sender)
        if model:GetLuckdrawState() then
            return
        end
        Button_1Click(d,sender)
    end)

    -- 充值福利
    self:OnClick("Button_2",function(d,sender)
        if model:GetLuckdrawState() then
            return
        end
        if self.mWelfareLayer == nil then
            self.mWelfareLayer = require("fire_rebate.src.LeijiRechage").new({
            })
            self:addChild(self.mWelfareLayer)
            self.mWelfareLayer.CloseParentFun = CloseParent
        end
        self:SelectShowLayer( sender )
    end)

    -- 活动累充
    self:OnClick("Button_3",function(d,sender)
        if model:GetLuckdrawState() then
            return
        end
        if self.mActivityAddLayer == nil  then
            self.mActivityAddLayer = require("fire_rebate.src.HuoDongLeiChong").new({
            })
            self:addChild(self.mActivityAddLayer)  
            self.mActivityAddLayer.CloseParentFun = CloseParent        
        end
        self:SelectShowLayer( sender )

    end)
    self:OpenSelfHandle()

end

function MainDialog:SelectShowLayer( _button )
    for i=1,3 do
        self["Button_"..i]:setBright(true)
    end
    _button:setBright(false)
    local _index = _button:getTag()
    if self.mLeijiLoginLayer then
        self.mLeijiLoginLayer:setVisible( _index == 1)
    end
    
    if self.mWelfareLayer then
        self.mWelfareLayer:setVisible( _index == 2)
    end
    
    if self.mActivityAddLayer then
        self.mActivityAddLayer:setVisible( _index == 3)
    end
end


--[[
    初始化打开界面
]]--

function MainDialog:OpenSelfHandle(  )

     self.mButton_1Clickfun(self,self.Button_1)
end

function MainDialog:UpdateDate( ... )
    self:setTime()
end

function MainDialog:setTime()

    if model:GetSurplusTiemsState() then
        self.TimeNum:setString("活动已结束")
        return
    end
    local Su = model:GetSurplusTiems()
    self.TimeNum:setString(qy.tank.utils.DateFormatUtil:toDateString(Su,1))
end

return MainDialog
