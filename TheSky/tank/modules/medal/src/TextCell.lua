

local TextCell = qy.class("TextCell", qy.tank.view.BaseView, "medal/ui/TextCell")

local service = qy.tank.service.MedalService
local garageModel = qy.tank.model.GarageModel
local  model = qy.tank.model.MedalModel
local StorageModel = qy.tank.model.StorageModel
local userInfoModel = qy.tank.model.UserInfoModel

function TextCell:ctor(delegate)
    TextCell.super.ctor(self)
    self.delegate = delegate
    local totalnum = delegate.num
    self:InjectView("shuxing")
    if tonumber(delegate.id) < 6 then
            self["shuxing"]:setString("·"..model.tujianTypeNameList[delegate.id..""]..":+"..totalnum)
    else
        local tempnum = totalnum/10
        self["shuxing"]:setString("·"..model.tujianTypeNameList[delegate.id..""]..":+"..tempnum.."%")
    end
end
function TextCell:onEnter()
    
end

function TextCell:onExit()
    
end


return TextCell
