

local MedalCell = qy.class("MedalCell", qy.tank.view.BaseView, "view/examine/MedalCell")

local model = qy.tank.model.MedalModel

function MedalCell:ctor(delegate)
    MedalCell.super.ctor(self)
    self.delegate = delegate
    local totalnum = delegate.num
    self:InjectView("text")
    if tonumber(delegate.id) < 6 then
            self["text"]:setString(model.tujianTypeNameList[delegate.id..""]..":   +"..totalnum)
    else
        local tempnum = totalnum/10
        self["text"]:setString(model.tujianTypeNameList[delegate.id..""]..":   +"..tempnum.."%")
    end
end
function MedalCell:onEnter()
    
end

function MedalCell:onExit()
    
end


return MedalCell
