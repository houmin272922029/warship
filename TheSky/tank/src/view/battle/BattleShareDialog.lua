--[[
	奖励预览
	Author: Aaron Wei
	Date: 2016-05-30 18:31:35
]]

local BattleShareDialog = qy.class("BattleShareDialog", qy.tank.view.BaseDialog,"view/battle/BattleShareDialog")


function BattleShareDialog:ctor()
	BattleShareDialog.super.ctor(self)
	self:setCanceledOnTouchOutside(true)
	
    self:OnClick("chat_share_btn", function()
        qy.tank.service.BattleService:share(function()
            qy.hint:show(qy.TextUtil:substitute(5001))
        end)
    end,{["isScale"] = true, ["hasAudio"] = false})


   self:OnClick("fb_share_btn", function()
        qy.tank.utils.SDK:shareToFacebook({},function(result)
            if result == 1 then
                qy.hint:show("share to facebook callback success!")
            elseif result == 2 then
                qy.hint:show("share to facebook callback cancel!")
            elseif resume() == 3 then
                qy.hint:show("share to facebook callback error!")
            end
        end)
    end,{["isScale"] = true, ["hasAudio"] = false})
end


function BattleShareDialog:onEnter()
    
end


return BattleShareDialog
