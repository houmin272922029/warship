--[[--
	跨服排名cell
--]]--

local RankCellNew = qy.class("RankCellNew", qy.tank.view.BaseView, "servicewar.ui.RankCellNew")

local model = qy.tank.model.ServiceWarModel
local userModel = qy.tank.model.UserInfoModel

function RankCellNew:ctor(delegate)
	RankCellNew.super.ctor(self)

	self:InjectView("name")
    self:InjectView("image")
    self:InjectView("rank")
  
    self.data = delegate.data
    self:OnClick("name", function (sender)
      if model.service_user_list then
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXAMINE,self.data[self.index].kid, 1)
      end
    end)
end
	
function RankCellNew:setData(_idx)
	self.index = _idx
	self.name:setString(self.data[_idx].nickname)
	self.rank:setString(self.data[_idx].rank)
	self.rank:setVisible(_idx > 3)
	self.image:setVisible(_idx <= 3)
	if _idx <= 3 then
		self.image:loadTexture("servicewar/res/rank".._idx..".png",1)
	end
	
end

return RankCellNew