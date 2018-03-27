--[[
    科技详细页面（升级用）
]]
local TechnologyDetailNewView = qy.class("TechnologyDetailNewView", qy.tank.view.BaseView, "view/technology/TechnologyDetailNewView")

function TechnologyDetailNewView:ctor(delegate)
    TechnologyDetailNewView.super.ctor(self)

    self.service = qy.tank.service.TechnologyService
    self.userInfoModel = qy.tank.model.UserInfoModel
    self.model = qy.tank.model.TechnologyModel


    self.delegate = delegate
    self.index = delegate.index
    self.page_id = 1
    self.position = 1
    self.type = 1 --洗属性的消耗类型
    self.num = 1 --洗属性的次数


    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = self.index == 1 and "Resources/activity/kejiwuzhuang1.png" or "Resources/activity/kejiwuzhuang2.png", 
        showHome = false,
        ["onExit"] = function()
            delegate:dismiss()
        end
    })
    self:addChild(style)

    self:InjectView("bg")
    self:InjectView("Text_book_num")

    self:InjectView("Text_atk")
    self:InjectView("Text_atk_add")
    self:InjectView("Img_atk")
    self:InjectView("Text_atk_num")

    self:InjectView("Text_blood")
    self:InjectView("Text_blood_add")
    self:InjectView("Img_blood")
    self:InjectView("Text_blood_num")

    self:InjectView("Text_def")
    self:InjectView("Text_def_add")
    self:InjectView("Img_def")
    self:InjectView("Text_def_num")

    self:InjectView("Button_left")
    self:InjectView("Button_right")

    self:InjectView("CheckBox_1")
    self:InjectView("CheckBox_2")
    self:InjectView("CheckBox_3")

    self:InjectView("Button_go")
    self:InjectView("Button_replace")

    self:InjectView("Button_select2")
    self:InjectView("Img_select")
    self:InjectView("Text_select")

    self:InjectView("Button_pos_1")
    self:InjectView("Button_pos_2")
    self:InjectView("Button_pos_3")
    self:InjectView("Button_pos_4")
    self:InjectView("Button_pos_5")
    self:InjectView("Button_pos_6")
    self:InjectView("Image_3")
    self:InjectView("Text_5")
    self:InjectView("Text_zhenwei")
    self:InjectView("Text_zhenwei2")

    self:InjectView("Text_c_book_1")
    self:InjectView("Text_c_book_2")
    self:InjectView("Text_c_book_3")
    self:InjectView("Text_c_silver_2")
    self:InjectView("Text_c_diamond_3")

    self:InjectView("Img_tank")




    self:OnClick("Button_go", function(sender)
        if self.type ~= 0 then
            self.service:clear(self.index, "p_"..self.page_id, self.type, self.num,function(data)
                self:update()
            end)
        end
    end)

    self:OnClick("Button_replace", function(sender)
        if self.type ~= 0 then
            self.service:replace(self.index, "p_"..self.page_id, function(data)
                if self.index == 1 then
                    self:showUtil()
                end
                self:update()
            end)
        end
    end)

    self.Image_3:setScaleY(0)
    self:OnClick("Button_select2", function(sender)
        if self.Image_3:getScaleY() == 0 then
            self.Image_3:setScaleY(1)
        else
            self.Image_3:setScaleY(0)
        end
    end)

    self:OnClick("Panel", function(sender)
        self.Image_3:setScaleY(0)
    end)


    self:OnClick("Img_select", function(sender)
        qy.tank.view.technology.TechnologyDetailNewSelectDialog.new(function(num)
            self.num = num
            self:update()
        end):show(true)
    end)



    self.CheckBox_1:setOpacity(255)
    for i = 1, 3 do
        self:OnClick("CheckBox_"..i, function(sender)
            self.CheckBox_1:setOpacity(0)
            self.CheckBox_2:setOpacity(0)
            self.CheckBox_3:setOpacity(0)
            self.type = i
            if i == 1 then
                self.CheckBox_1:setOpacity(255)
            elseif i == 2 then 
                self.CheckBox_2:setOpacity(255)
            else
                self.CheckBox_3:setOpacity(255)
            end
        end)
    end

    for i = 1, 6 do
        self:OnClick("Button_pos_"..i, function(sender)
            self.service:change(self.index, "p_"..self.page_id, "p_"..i,function(data)
                self:update()
                if self.index == 1 then
                    self:showUtil()
                end
                self.Image_3:setScaleY(0)
            end)
        end)
    end




    self:OnClick("Button_left", function(sender)
        self.page_id = self.page_id - 1
        self:update()
    end)

    self:OnClick("Button_right", function(sender)
        self.page_id = self.page_id + 1
        self:update()
    end)


    self:OnClick("Button_help", function(sender)
        qy.tank.view.common.HelpDialog.new(32):show(true)
    end)

    self.Img_atk_y = self.Img_atk:getPositionY()
    self.Img_blood_y = self.Img_blood:getPositionY()
    self.Img_def_y = self.Img_def:getPositionY()

    self:update()
end

--更新view
function TechnologyDetailNewView:update()
    self.Img_atk:setPositionY(self.Img_atk_y)
    self.Img_blood:setPositionY(self.Img_blood_y)
    self.Img_def:setPositionY(self.Img_def_y)

    if self.index == 1 then
        local data = self.model.base["p_"..self.page_id]
        local froces = self.model.armed_forces_1[data.stage]
        local consume = self.model.armed_forces_consume_1[data.stage]

        self.position = data.position

        self.Text_atk_num:setString(data.base.attack.."/"..froces.attack)
        self.Text_blood_num:setString(data.base.blood.."/"..froces.blood)
        self.Text_def_num:setString(data.base.defense.."/"..froces.defense)
        
        self.Text_atk:setString(qy.TextUtil:substitute(40035))
        self.Text_blood:setString(qy.TextUtil:substitute(90245))
        self.Text_def:setString(qy.TextUtil:substitute(40033))

        self.Text_c_book_1:setString(consume.technology_hammer_1 * self.num)
        self.Text_c_book_2:setString(consume.technology_hammer_2 * self.num)
        self.Text_c_book_3:setString(consume.technology_hammer_3 * self.num)
        self.Text_c_silver_2:setString(consume.silver_2 * self.num)
        self.Text_c_diamond_3:setString(consume.diamond_3 * self.num)

        self:updateColor(self.Text_atk_add, self.Img_atk, data.replace.attack, 1)
        self:updateColor(self.Text_blood_add, self.Img_blood, data.replace.blood, 1)
        self:updateColor(self.Text_def_add, self.Img_def, data.replace.defense, 1)

        self.Text_zhenwei:setString("("..string.split(data.position, "_")[2]..")")
        self.Text_zhenwei2:setString(string.split(data.position, "_")[2])

        if data.replace.attack >= 0 and data.replace.blood >= 0 and data.replace.defense >= 0 and data.replace.attack + data.replace.blood + data.replace.defense > 0 then
            self.Button_go:setVisible(false)
            self.Button_replace:setPositionY(145)
        else
            self.Button_go:setVisible(true)
            self.Button_replace:setPositionY(60)
        end

        if data.replace.attack ~= 0 or data.replace.blood ~= 0 or data.replace.defense ~= 0 then
            self.Button_replace:setTouchEnabled(true)
        else
            self.Button_replace:setTouchEnabled(false)
        end
    else
        local data = self.model.special["p_"..self.page_id]
        local froces = self.model.armed_forces_2[data.stage]
        local consume = self.model.armed_forces_consume_2[data.stage]

        self.position = data.position

        self.Text_atk_num:setString((data.base.crit_hurt_reduction / 10).."%".."/"..(froces.crit_hurt_reduction / 10).."%") --爆伤减免
        self.Text_blood_num:setString((data.base.hit_plus / 10).."%".."/"..(froces.hit_plus / 10).."%")  --命中
        self.Text_def_num:setString((data.base.crit_reduction / 10).."%".."/"..(froces.crit_reduction / 10).."%")  --暴击减免
        
        -- 范围总命中   范围总减暴击  范围总减暴击伤害
        -- hit_plus[int]   crit_reduction[int] crit_hurt_reduction[int]

        self.Text_atk:setString(qy.TextUtil:substitute(90249))  
        self.Text_blood:setString(qy.TextUtil:substitute(90250))
        self.Text_def:setString(qy.TextUtil:substitute(90251)) 

        self.Text_c_book_1:setString(consume.technology_hammer_1 * self.num)
        self.Text_c_book_2:setString(consume.technology_hammer_2 * self.num)
        self.Text_c_book_3:setString(consume.technology_hammer_3 * self.num)
        self.Text_c_silver_2:setString(consume.silver_2 * self.num)
        self.Text_c_diamond_3:setString(consume.diamond_3 * self.num)   

        self:updateColor(self.Text_atk_add, self.Img_atk, data.replace.crit_hurt_reduction, 2)
        self:updateColor(self.Text_blood_add, self.Img_blood, data.replace.hit_plus, 2)
        self:updateColor(self.Text_def_add, self.Img_def, data.replace.crit_reduction, 2)

        self.Text_zhenwei:setString("("..string.split(data.position, "_")[2]..")")
        self.Text_zhenwei2:setString(string.split(data.position, "_")[2])

        if data.replace.crit_hurt_reduction >= 0 and data.replace.hit_plus >= 0 and data.replace.crit_reduction >= 0 and data.replace.crit_hurt_reduction + data.replace.hit_plus + data.replace.crit_reduction > 0 then
            self.Button_go:setVisible(false)
            self.Button_replace:setPositionY(145)
        else
            self.Button_go:setVisible(true)
            self.Button_replace:setPositionY(60)
        end

        if data.replace.crit_hurt_reduction ~= 0 or data.replace.hit_plus ~= 0 or data.replace.crit_reduction ~= 0 then
            self.Button_replace:setTouchEnabled(true)
        else
            self.Button_replace:setTouchEnabled(false)
        end
    end

     

    self.Text_book_num:setString(self.userInfoModel.userInfoEntity.technologyHammer)

    

    --qy.TextUtil:substitute(90246)
    if self.num == 1 then
        self.Text_select:setString(qy.TextUtil:substitute(90246))
    elseif self.num == 5 then
        self.Text_select:setString(qy.TextUtil:substitute(90247))
    elseif self.num == 10 then
        self.Text_select:setString(qy.TextUtil:substitute(90248))
    end

    self.Button_left:setVisible(true)
    self.Button_right:setVisible(true)
    if self.page_id == 1 then 
        self.Button_left:setVisible(false)
    elseif self.page_id == 6 then
        self.Button_right:setVisible(false)
    end


    --local entity = qy.tank.entity.TankEntity.new(tonumber(string.split(self.position, "_")[2]))
    local entity = qy.tank.model.GarageModel.selectedTanks[tonumber(string.split(self.position, "_")[2])]
    if entity then
        self.Img_tank:loadTexture(entity:getImg()) 
    --     self.Img_tank:setVisible(true)
    -- else
    --     self.Img_tank:setVisible(false)
    end

end





function TechnologyDetailNewView:updateColor(Textview, Image, num, type)
    Textview:setString(num)
    Image:setVisible(true)
    Image:stopAllActions()
    if num == 0 then
        Textview:setColor((cc.c3b(255, 255, 255)))   
        Textview:setString("+0")     
        Image:setVisible(false)
    elseif num < 0 then
        Textview:setColor((cc.c3b(255, 0, 0)))        
        Image:loadTexture("Resources/technology/technology_new/zengjia.png",0)
        Image:setFlippedY(true)
        Image:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.MoveBy:create(0.7, cc.p(0, -8)), cc.MoveBy:create(0, cc.p(0, 8)), cc.DelayTime:create(0.01))))
        if type == 1 then
            Textview:setString(num)
        else
            Textview:setString((num / 10).."%")
        end
    else
        Textview:setColor((cc.c3b(0, 255, 0)))
        Image:loadTexture("Resources/technology/technology_new/jianshao.png",0)
        Image:setFlippedY(true)
        Image:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.MoveBy:create(0.7, cc.p(0, 8)), cc.MoveBy:create(0, cc.p(0, -8)), cc.DelayTime:create(0.01))))

        if type == 1 then
            Textview:setString("+"..num)
        else
            Textview:setString("+"..(num / 10).."%")
        end
    end


end



-- 战斗力飘字
function TechnologyDetailNewView:showUtil()
    local _aData = {}
    local fightPower = qy.tank.model.UserInfoModel.userInfoEntity.fightPower - qy.tank.model.UserInfoModel.userInfoEntity.oldfight_power
    if fightPower then
        local numType = 0
        if fightPower > 0 then
            numType = 15
        else
            numType = 14
        end
        _data = {
            ["value"] = fightPower,
            ["url"] = qy.ResConfig.IMG_FIGHT_POWER,
            ["type"] = numType,
            ["picType"] = 2,
         }
        table.insert(_aData, _data)
        qy.tank.utils.HintUtil.showSomeImageToast(_aData,cc.p(qy.winSize.width / 2, qy.winSize.height * 0.6))
    end
end



return TechnologyDetailNewView
