local attribute = qy.class("attribute", qy.tank.view.BaseView, "passenger.ui.attribute")
local PassengerModel = qy.tank.model.PassengerModel

function attribute:ctor(delegate)
	attribute.super.ctor(self)

	self:InjectView("name")
	self:InjectView("attr")
end

function attribute:setData(idx)

    local attrs = PassengerModel:getAttrbute2()
   	if idx == 1 then
         self.name:setString("攻 击 力")
         self.attr:setString("+" ..(attrs[idx..""] ~= nil and attrs[idx..""] or 0))
      elseif idx == 2 then
         self.name:setString("防 御 力")
         self.attr:setString("+" ..(attrs[idx..""] ~= nil and attrs[idx..""] or 0))
      elseif idx == 3 then
         self.name:setString("生 命 值")
         self.attr:setString("+" ..(attrs[idx..""] ~= nil and attrs[idx..""] or 0))
      elseif idx == 4 then
         self.name:setString("穿   深")
         self.attr:setString("+" ..(attrs[idx..""] ~= nil and attrs[idx..""] or 0))
      elseif idx == 5 then
         self.name:setString("穿深抵抗")
         self.attr:setString("+" ..(attrs[idx..""] ~= nil and attrs[idx..""] or 0))
      elseif idx == 6 then
         self.name:setString("暴 击 率")
         self.attr:setString("+" ..(attrs[idx..""] ~= nil and attrs[idx..""] or 0).."%")
      elseif idx == 7 then
         self.name:setString("暴击伤害")
         self.attr:setString("+" ..(attrs[idx..""] ~= nil and attrs[idx..""] or 0))
      elseif idx == 8 then
         self.name:setString("初始士气")
         self.attr:setString("+" ..(attrs[idx..""] ~= nil and attrs[idx..""] or 0))
      elseif idx == 9 then
         self.name:setString("命   中")
         self.attr:setString("+" ..(attrs[idx..""] ~= nil and attrs[idx..""] or 0))
      elseif idx == 10 then
         self.name:setString("闪   避")
         self.attr:setString("+" ..(attrs[idx..""] ~= nil and attrs[idx..""] or 0).."%")
      elseif idx == 11 then
         self.name:setString("攻击力千分比")
         self.attr:setString("+" ..(attrs[idx..""] ~= nil and attrs[idx..""] or 0).."%")
      elseif idx == 12 then
         self.name:setString("防御力千分比")
         self.attr:setString("+" ..(attrs[idx..""] ~= nil and attrs[idx..""] or 0).."%")
      elseif idx == 13 then
         self.name:setString("生命值千分比")
         self.attr:setString("+" ..(attrs[idx..""] ~= nil and attrs[idx..""] or 0).."%")
      end
end

return attribute