local FameDialog = qy.class("FameDialog", qy.tank.view.BaseDialog, "fame/ui/FameDialog")
local service = qy.tank.service.FameService
local model = qy.tank.model.FameModel

local cfg = qy.Config.overawe

function FameDialog:ctor(delegate)
   	FameDialog.super.ctor(self)
    self.delegate = delegate
    self.style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(930,590),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "Resources/activity/title_overawe.png",

        ["onClose"] = function()
            self:removeSelf()
        end
    })
    self:addChild(self.style , -1)
    self:InjectView("fame")
    self:InjectView("Sprite_4")
    for i=1,3 do
        self:InjectView("Text_"..i)
        self:InjectView("Button_"..i)
        self:InjectView("cost"..i)
    end
    for i=1,3 do
        self:OnClick("Button_"..i, function()
            if model.times == 0 then
                service:draw({["type"] = i,},
                    function(response)
                        self:update(i)
                    end)
            else
                qy.hint:show(qy.TextUtil:substitute(90094))
            end
        end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})
    end
    
    for i=1,3 do
        self["Text_"..i]:setString(qy.TextUtil:substitute(90095).. cfg[i..""].reputation .. qy.TextUtil:substitute(90096))
        self["cost"..i]:setString(cfg[i..""].diamond.."")
    end
    self:btnState()
end

function FameDialog:btnState()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/button/common_button.plist")
    if model.times == 0 then
        for i=1,3 do
            self["Button_"..i]:loadTextureNormal("Resources/common/button/btn_3.png",1)
            self["Button_"..i]:loadTexturePressed("Resources/common/button/anniuhong02.png",1)
            self["Button_"..i]:loadTextureDisabled("Resources/common/button/anniuhui.png",1)
        end 
    else
        for i=1,3 do
            self["Button_"..i]:loadTextureNormal("Resources/common/button/anniuhui.png",1)
            self["Button_"..i]:loadTexturePressed("Resources/common/button/anniuhui.png",1)
            self["Button_"..i]:loadTextureDisabled("Resources/common/button/anniuhui.png",1)
        end 
    end
    self.fame:setString(qy.tank.model.UserInfoModel.userInfoEntity.reputation)

end

function FameDialog:update(fames)
    local _aData = {}
    local fameNums = cfg[fames..""].reputation
    -- if fameNums then
    --     _data = {
    --         ["value"] = fameNums,
    --         ["url"] = qy.ResConfig.IMG_FAME,
    --         ["type"] = 3,
    --         ["picType"] = 2,
    --      }
    --     table.insert(_aData, _data)
    --     qy.tank.utils.HintUtil.showSomeImageToast(_aData,cc.p(qy.winSize.width / 5 * 3, qy.winSize.height * 0.65))
    -- end
    qy.hint:show({["textType"] = 1,["text"] = fameNums,})
    self:btnState()
end

function FameDialog:onEnter()

end

function FameDialog:onExit()
    -- cc.Director:getInstance():getTextureCache():removeAllTextures()
end

return FameDialog