--[[--

--]]--

local LeijiDengLu = qy.class("LeijiDengLu", qy.tank.view.BaseView, "fire_rebate/ui/LeijiDengLu")

function LeijiDengLu:ctor(delegate)
    LeijiDengLu.super.ctor(self)
    self.model = qy.tank.model.FireRebateModel
    self.service = qy.tank.service.FireRebateService
    self:InjectView("qiandaobtn")
    self:InjectView("BG")
    self.BG:setVisible(false)

    for i = 1,6 do
		self:InjectCustomView("ProjectNode_" .. i, require("fire_rebate/src/ZPGiftCellMax", {}))
    end
    self:OnClick("qiandaobtn",function(sender)
   
   		self.service:GetgetawardData(1,tonumber(self.msingKey),function ( data )
   			self.model:SetSignState(self.msingKey)
   			self.model:SetSignStateYes(0)
   			self:render()
			qy.tank.command.AwardCommand:add(data.award)
			qy.tank.command.AwardCommand:show(data.award,{["critMultiple"] = data.weight})
   		end)

    end)
	self:InjectCustomView("ProjectNode_" .. 7, require("fire_rebate/src/ZPGiftCellMax2", {}))
    self:Init()
    self:render()
end

function LeijiDengLu:Init(  )

	self.msingKey = 0

end


-- 0不可以，1 可以签到，2 签过
function LeijiDengLu:render(idx)

	local data = self.model:ReturnLeijiLoginCf()
	local SingArray = self.model:GetSign()

	for i=1,6 do
		self["ProjectNode_" .. i]:render(i,data[""..i].award[1],SingArray[tostring(i)])
	end
	self.ProjectNode_7:render(7,data[""..7].award[1],SingArray["7"])



	local singKey,singVal = self.model:IsSignState()
	self.msingKey = singKey

	print("singKey====="..singKey)
	local state = self.model:GetSignState()


	if state ~= 1  then -- 已经签到
		self.qiandaobtn:setTouchEnabled(false)
		self.qiandaobtn:setBright(false)
	end

	if self.model:GetSurplusTiemsState() then
        self.qiandaobtn:setTouchEnabled(false)
        self.qiandaobtn:setBright(false)
    end
end

return LeijiDengLu