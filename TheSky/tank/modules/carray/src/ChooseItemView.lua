local ChooseItemView = qy.class("ChooseItemView", qy.tank.view.BaseView, "carray.ui.ChooseItemView")

local model = qy.tank.model.CarrayModel
function ChooseItemView:ctor(delegate)
   	ChooseItemView.super.ctor(self)

   	self:InjectView("Img")
   	self:InjectView("Choose")
   	self:InjectView("Name")
   	self:InjectView("Num")
   	self.Choose:setVisible(false)
   	-- self:OnClick("BG", function()
    --     print("我去")
    --     -- qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.ADVANCE, {["entity"] = self.entity, ["isTips"] = true})
    -- end,{["isScale"] = false})
end

function ChooseItemView:setData(idx)
	local data = model:atRescours(idx + 1)
    self.Img:loadTexture("carray/res/" .. idx + 1 .. ".png", 1)
    self.Name:setString(data.name)
    self.Name:setTextColor(qy.tank.utils.ColorMapUtil.qualityMapColor(tostring(idx + 1)))

    local level = qy.tank.model.UserInfoModel.userInfoEntity.level
    self.Num:setString(data.award[1].num * level)

    if idx + 1 == model.appointQuality then
    	self.Choose:setVisible(true)
    else
    	self.Choose:setVisible(false)
    end
end


return ChooseItemView
