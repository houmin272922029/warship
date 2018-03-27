

local CheckView = qy.class("CheckView", qy.tank.view.BaseDialog, "medal/ui/CheckVIew")

local service = qy.tank.service.MedalService
local garageModel = qy.tank.model.GarageModel
local  model = qy.tank.model.MedalModel
local StorageModel = qy.tank.model.StorageModel
local userInfoModel = qy.tank.model.UserInfoModel

function CheckView:ctor(delegate)
    CheckView.super.ctor(self)
    self.delegate = delegate
    self:InjectView("bg")
    self:InjectView("pannel")
    self:InjectView("title")
    -- self:OnClick("bg",function ( sender )
    --     self:dismiss()
    -- end)
    self:OnClickForBuilding1("bg",function ( sender )
       self:dismiss()
    end)
    self.tankid = delegate.tank_id
    self:Update()
end
function CheckView:onEnter()
    
end

function CheckView:Update()
    local data = model:totalAttr2(self.tankid)
    print("总数性啊",json.encode(data))
    local temp = 0
    for k,v in pairs(data) do
        if v ~= 0 then
            temp = temp + 1
            print("ssssssssssss",k)
            print("ssssssssssss",v)
            local item = require("medal.src.TextCell").new({
                ["id"] = k,
                ["num"] = v
                })
            self.pannel:addChild(item)
            item:setPosition(cc.p(20,330-(35*temp)))
        end
    end
    -- for i=1,9 do
    --     local num = model:totalAttr(self.tankid)
    --     if num ~= 0 then
    --         temp = temp + 1
    --         local item = require("medal.src.TextCell").new({
    --             ["id"] = i,
    --             ["num"] = num
    --             })
    --         self.pannel:addChild(item)
    --         item:setPosition(cc.p(20,330-(35*temp)))
    --     end
       
    -- end
end
function CheckView:onExit()
    
end


return CheckView
