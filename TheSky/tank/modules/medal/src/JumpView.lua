

local JumpView = qy.class("JumpView", qy.tank.view.BaseDialog, "medal/ui/JumpView")

local service = qy.tank.service.MedalService
local garageModel = qy.tank.model.GarageModel
local  model = qy.tank.model.MedalModel
local StorageModel = qy.tank.model.StorageModel
local userInfoModel = qy.tank.model.UserInfoModel

function JumpView:ctor(delegate)
    JumpView.super.ctor(self)
    self.delegate = delegate
    local style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(850,525),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "medal/res/huoqu2.png",--

        ["onClose"] = function()
            self:dismiss()
        end
    })
    -- style:setPositionY(-60)
    self:addChild(style,-10)
    self:InjectView("Bt1")
    self:OnClick("Bt1",function ( sender )
        self:dismiss()
        delegate:callback()
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.PROP_SHOP)
        -- body
    end)
    self:InjectView("Bt2")
    self:OnClick("Bt2",function ( sender )
        self:dismiss()
        delegate:callback()
        qy.tank.command.ActivitiesCommand:showActivity(qy.tank.view.type.ModuleType.GOLD_BUNKER)
    end)
end
function JumpView:onEnter()
    
end

function JumpView:Update()

end
function JumpView:onExit()
    
end


return JumpView
