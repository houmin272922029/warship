--[[--

--]]--

local ZhengZhanKuangQu = qy.class("ZhengZhanKuangQu", qy.tank.view.BaseView, "legion_generaltion/ui/ZhengZhanKuangQu")

function ZhengZhanKuangQu:ctor(delegate)
    ZhengZhanKuangQu.super.ctor(self)
    self.model = qy.tank.model.FireRebateModel
    self.service = qy.tank.service.FireRebateService
    self:InjectView("qiandaobtn")
    self:InjectView("BG")
    self:InjectView("jinrubtn")
    self:InjectView("Tips2")
    self:InjectView("Tips1")

    self.BG:setVisible(false)


    self:OnClick("jinrubtn",function(sender)
    	if self.mIndex == 1 then
    		print("11111")
        	qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.MINE_MAIN_VIEW)
    	else
    		print("22222")
        	-- qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.CARRAY)    		
    	   qy.tank.command.ActivitiesCommand:showActivity(qy.tank.view.type.ModuleType.CARRAY)
        end
  		self.CloseParentFun()
    end)
    self:Init()
    self:render()
end

function ZhengZhanKuangQu:Init(  )

	self.mIndex = 0

end


function ZhengZhanKuangQu:UpdataText(idx)
	if idx == 1 then
		self.Tips1:setVisible(true)
		self.Tips2:setVisible(false)
	else
		self.Tips1:setVisible(false)
		self.Tips2:setVisible(true)
	end
	self.mIndex = idx

end

function ZhengZhanKuangQu:render(idx)


end

return ZhengZhanKuangQu