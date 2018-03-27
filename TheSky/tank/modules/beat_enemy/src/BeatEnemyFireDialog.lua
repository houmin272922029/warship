local BeatEnemyFireDialog = qy.class("BeatEnemyFireDialog", qy.tank.view.BaseDialog, "beat_enemy.ui.BeatEnemyFireDialog")

local service = qy.tank.service.BeatEnemyService
function BeatEnemyFireDialog:ctor(delegate, _idx)
   	BeatEnemyFireDialog.super.ctor(self)

    self:InjectView("bg")

    local x = 0

    if _idx % 3 == 1 then
        x = 600 + (qy.winSize.width - 1080) / 2

    elseif _idx % 3 == 2 then
        x = 885 + (qy.winSize.width - 1080) / 2
    else 
        x = 455 + (qy.winSize.width - 1080) / 2
    end

    self.bg:setPosition(x, qy.winSize.height / 2)

    local icon = cc.Sprite:create("beat_enemy/res/".._idx..".png")
    local icon_bg = cc.Sprite:create("beat_enemy/res/21.png")
    icon_bg:setPosition(139, 68)
    icon:addChild(icon_bg)

    --280 是从左到右 每个cell的中心点的间距   260为最左边cell相对于原点的x坐标  188与226.5为bg的contentSize的一半
    icon:setPosition((_idx - 1) % 3 * 280 + 260 - x + 188 + (qy.winSize.width - 1080) / 2, math.floor((_idx - 1) / 3) * -138 + 570 - 360 + 226.5 + (qy.winSize.height - 720) / 2)
    self.bg:addChild(icon, -1)


    self:OnClick("Btn_Close", function()
        self:dismiss()
    end,{["isScale"] = false})

    for i = 1, 3 do
        self:OnClick("Btn_Fire_"..i, function()
            service:getAward(function(data)
                if data.award then
                    delegate:update()

                    self:play(i, icon_bg)

                    if i == 3 then
                        table.insert(data.award, 1, {["type"] = 29, ["num"] = data.add_point})
                    end

                    qy.tank.command.AwardCommand:add(data.award,{["textType"]=2, ["s_num"] = data.add_point})

                    qy.tank.command.AwardCommand:show(data.award,{["textType"]=2, ["s_num"] = data.add_point})


                    qy.QYPlaySound.playEffect(qy.SoundType.INVADE)
                end
            end, 1, i)
        end,{["isScale"] = false})
    end

end



function BeatEnemyFireDialog:play(_type, node)

    if _type == 1 then 
        qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/ui/ui_fx_jiqiang",function()
            local effect = ccs.Armature:create("ui_fx_jiqiang")
            node:addChild(effect)
            effect:setPosition(node:getContentSize().width * math.random(20, 80) / 100, node:getContentSize().height * math.random(20, 80) / 100)
            effect:getAnimation():playWithIndex(0)
            effect:setScale(0.8)
            effect:runAction(cc.Sequence:create(cc.FadeTo:create(2, 0), cc.CallFunc:create(function()
                node:removeChild(effect)
            end)))
        end)
    elseif _type == 2 then
        qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/ui/ui_fx_paohuo",function()
            local effect = ccs.Armature:create("ui_fx_paohuo")
            node:addChild(effect)
            effect:setPosition(node:getContentSize().width * math.random(20, 80) / 100, node:getContentSize().height * math.random(20, 80) / 100)
            effect:getAnimation():playWithIndex(0)
            effect:runAction(cc.Sequence:create(cc.FadeTo:create(2, 0), cc.CallFunc:create(function()
                node:removeChild(effect)
            end)))
        end)
    elseif _type == 3 then
        for i = 1, 3 do
            qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/ui/ui_fx_paohuo",function()
                local effect = ccs.Armature:create("ui_fx_paohuo")
                node:addChild(effect)
                effect:setPosition(node:getContentSize().width * math.random(20, 80) / 100, node:getContentSize().height * math.random(20, 80) / 100)
                effect:getAnimation():playWithIndex(0)
                effect:runAction(cc.Sequence:create(cc.FadeTo:create(2, 0), cc.CallFunc:create(function()
                    node:removeChild(effect)
                end)))
            end)
        end
    end




end


return BeatEnemyFireDialog
