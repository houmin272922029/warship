local TitleCell = qy.class("TitleCell", qy.tank.view.BaseView, "server_exercise/ui/TitleCell")

local model = qy.tank.model.ServerExerciseModel

function TitleCell:ctor(delegate)
	TitleCell.super.ctor(self)

	self:InjectView("titleicon")--称号
	self:InjectView("title")--
	self:InjectView("des")--
	self:InjectView("ranktext")--
	self.list = model.configlist
   
end
function TitleCell:render( _idx )
	local data = self.list[_idx]

	local dx = _idx >=4 and 4 or _idx
	local png ="server_exercise/res/chenghao"..dx..".png"
	self.titleicon:setSpriteFrame(png)

	self.ranktext:setString("排名第".._idx.."可获得")
	self.title:setString(data.name)
	local num = data.num--有几个类型
	local str = ""
	for i=1,num do
		local types = data["attr_type_"..i]
		local val = data["attr_val_"..i]
		if types > 10 then
			local temp = val/10
			val = temp.."%"
		end
		local fen 
		if i == num then
			fen = ""
		else
			fen = ";"
		end
		local text = model.tujianTypeNameList[tostring(types)]
		str = str .. text ..": +"..val..fen
	end
	self.des:setString(str)
end

return TitleCell