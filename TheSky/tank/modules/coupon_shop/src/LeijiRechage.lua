--[[--
	
--]]--

local LeijiRechage = qy.class("LeijiRechage", qy.tank.view.BaseView, "fire_rebate/ui/LeijiRechage")

function LeijiRechage:ctor(delegate)
    LeijiRechage.super.ctor(self)
    self.model = qy.tank.model.FireRebateModel
    self.service = qy.tank.service.FireRebateService

    self:InjectView("RechageBtn")
    self:InjectView("Num")
    self:InjectView("BG")
    self:InjectView("qiandao_1")
    self:InjectView("Light")
    self.BG:setVisible(false)


    self:Init()

    self:OnClick("RechageBtn",function(sender)
        if self.model:GetLuckdrawState() then
            return
        end

    	if self.Times >= 1 then  -- 开始转盘
            self.service:GetgetawardData(2,1,function ( data )
            local itemindex = self.model:getLuckdrawIndex(data.award)
            self.model:SetWelfareTime()
            self:UpdateDate()
            self:StareCircle(tonumber(itemindex),data)
            end)
    	else
            self.CloseParentFun()
    		qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.RECHARGE)
        end   
    end)

    self:UpdateDate()

end

function LeijiRechage:Init()

    self.ItemPosArr = 
    {
        [1] = {x = -187.78 , y = 108.82},
        [2] = {x = -1.30 , y = 108.82},
        [3] = {x = 185.99 , y = 104.99},
        [4] = {x = 373.43 , y = 108.82},
        [5] = {x = 374.35 , y = -41.77},
        [6] = {x = 376.31 , y = -187.67},
        [7] = {x = 187.48 , y = -190.28},
        [8] = {x = -1.56 , y = -189.77},
        [9] = {x = -187.78 , y = -191.52},
        [10] = {x = -187.78 , y = -40.86}

    }
	local data = self.model:ReturnWelfareCf()
	for i = 1,10 do
		self:InjectCustomView("ProjectNode_" .. i, require("fire_rebate/src/ZPGiftCell", {}))
		self["ProjectNode_" .. i]:render(-1,data[""..i].award[1])
    end
end

--[[
     开始转圈
     data  转圈奖励的数据
]]--
function LeijiRechage:StareCircle( _Num, data )
    if _Num == nil or _Num < 0 then
        print("=====寻找转圈的下标失败======")
        return
    end

    local func2 = cc.CallFunc:create(function()
        qy.tank.command.AwardCommand:add(data.award)
        qy.tank.command.AwardCommand:show(data.award,{["critMultiple"] = data.weight})
        self.model:SetLuckdrawState( false )
    end)


    self.model:SetLuckdrawState( true )
    local actions = {}
    local CircleNum = 4 -- 固定转的圈数
    for i = 1, CircleNum do
        for j = 1, 10 do        
            local pos = self.ItemPosArr[j]
            local func = cc.CallFunc:create(function()
                qy.QYPlaySound.playEffect(qy.SoundType.OPEN_MENU)
                self.Light:setPosition(pos)
            end)
            local delay = cc.DelayTime:create(0.1)
            table.insert(actions, func)
            table.insert(actions, delay)
            if i == CircleNum and j == _Num then
                table.insert(actions, func2)
                break
            end
        end
    end
    self.Light:runAction(cc.Sequence:create(actions))
end



function LeijiRechage:UpdateDate(  )
	self.Times = self.model:GetWelfareTime()
	self.Num:setString( self.Times )

	-- 次数用完了   你要买次数撒   qiandao
	if self.Times <= 0 then
		self.qiandao_1:setSpriteFrame("fire_rebate/res/quchongzhi.png")
        if self.model:GetSurplusTiemsState() then    
            self.RechageBtn:setBright(false)
            self.RechageBtn:setTouchEnabled(false)
        end	
    else
		self.qiandao_1:setSpriteFrame("fire_rebate/res/kaiqi.png")
	end

end

return LeijiRechage