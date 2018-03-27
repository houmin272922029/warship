local GroupBattlesCell2 = qy.class("GroupBattlesCell2", qy.tank.view.BaseView, "group_battles.ui.GroupBattlesCell")

local model = qy.tank.model.GroupBattlesModel
local service = qy.tank.service.GroupBattlesService

function GroupBattlesCell2:ctor(delegate)
   	GroupBattlesCell2.super.ctor(self)

    self:InjectView("Bg")
   	self:InjectView("Times")
    self:InjectView("Name")
    self:InjectView("Selected")
    self:InjectView("Btn_lock")
    self:InjectView("Lock")
    self:InjectView("Level")
    self.delegate = delegate

    self.Btn_lock:setSwallowTouches(false)
end



function GroupBattlesCell2:render(data, _idx)

    self.Name:setString(data.name)
    self.Bg:loadTexture("group_battles/res/"..data.scene_id..".jpg")
    print(qy.json.encode(data))
    self.Times:setString(3 - data.join_num)

    if qy.tank.model.UserInfoModel.userInfoEntity.level >= (tonumber(data.level) or 0) then
        self.Btn_lock:setOpacity(0)
        self.Lock:setVisible(false)

        self:OnClick(self.Btn_lock, function(sender)
            model:setCurrentSceneId(data.scene_id)
            self.delegate:update()
        end,{["isScale"] = false})

        self.Btn_lock:setSwallowTouches(false)
    else
        self.Level:setString(data.level)

        self:OnClick(self.Btn_lock, function(sender)
            qy.hint:show("指挥官等级不足")
        end,{["isScale"] = false})
    end

    if data.scene_id == model:getCurrentSceneId() then
        self.Selected:setVisible(true)
    end


end

return GroupBattlesCell2