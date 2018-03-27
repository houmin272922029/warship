local SignCell2 = qy.class("SignCell2", qy.tank.view.BaseView, "sign.ui.SignCell")

local model = qy.tank.model.SignModel
local service = qy.tank.service.SignService

function SignCell2:ctor(delegate)
   	SignCell2.super.ctor(self)

   	self:InjectView("Bg")
    self:InjectView("Vip_icon")
    self:InjectView("Receive")
    self:InjectView("Bg_selected")
    self:InjectView("Btn_receive")
    self.delegate = delegate

    self.Vip_icon:setLocalZOrder(1)
    self.Receive:setLocalZOrder(1)
    self.Btn_receive:setLocalZOrder(2)
end

function SignCell2:render(data, _idx)

	if data.vip_level > 0 then
		self.Vip_icon:setVisible(true)
		self.Vip_icon:loadTexture("sign/res/v"..data.vip_level..".png",0)
	end

	local award = data.double_award
	if model:isSingle() then
		award = data.single_award
	end

    if self.award then
        self.Bg:removeChild(self.award)
    end

	
	self.award = qy.tank.view.common.AwardItem.createAwardView(award[1], 1)
    self.award:showTitle(false)
    self.award:setPosition(77,77)
    self.award.fatherSprite:setSwallowTouches(false)
    self.Bg:addChild(self.award)

    if model:getCurrentNum() == _idx - 1 and model.sign_status == 200 then
        self.Bg_selected:setVisible(true)

        qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/ui/ui_fx_qiandao",function()
            self.effect = ccs.Armature:create("ui_fx_qiandao")
            self.Bg:addChild(self.effect, 3)
            self.effect:setPosition(-45, 200)
            self.effect:getAnimation():playWithIndex(0)
        end)

        self.Btn_receive:setVisible(true)
        self.Btn_receive:setSwallowTouches(true)
        self:OnClick(self.Btn_receive, function(sender)
            service:getAward(function(data)
                self.delegate:update()

                if data.award then
                    qy.tank.command.AwardCommand:add(data.award)
                    qy.tank.command.AwardCommand:show(data.award,{["isShowHint"]=false})

                    self.Btn_receive:setVisible(false)
                    self.Receive:setVisible(true)
                    self.Bg_selected:setVisible(false)

                    if self.effect then
                        self.Bg:removeChild(self.effect)
                    end
                end
            end, "100") 
        end,{["isScale"] = false})
    elseif model:getCurrentNum() >= _idx then
        self.Receive:setVisible(true)
    end
end

return SignCell2