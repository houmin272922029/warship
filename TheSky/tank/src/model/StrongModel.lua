local StrongModel = qy.class("StrongModel", qy.tank.model.BaseModel)

StrongModel.typeNameList ={ 
	["cn"] = {
		["1"] = {
			"进度条百分比越低，代表这种途径的战斗力提升空间越大。",
			"指挥官，要和我拥抱一下吗？",
			"希望我的指引能帮助到您，有需要点击我。",
			"合理搭配阵容会有意想不到的收获。",
			"战车进阶到+6可以提升战车的品质和星级。",
			"战车成就、科技、军团技能和图鉴都可以永久提升全体战车战斗力",
			"进度条百分比越低，代表这种途径的战斗力提升空间越大。"},
		["2"] = {
			"获取资源中的星星数越多，代表这种途径的产出最为优质。",
			"黑市商人出售最低7折的战车，是最理想的战车获得途径。",
			"多余的银币可以用来购买招募令，战地招募可以获得精铁、科技书等物资。",
			"经典战役可以获得高级装备、橙色精铁。",
			"主线战役遇到强大的敌人时，可以查看其他玩家的通关攻略。",
			"你轻点，我的衣服都破了。"
		}
	}
}

function StrongModel:init()
    self.StrongFcList = {} --提升战斗力列表
    self.StrongResList = {} --获取资源列表
    self:sort()
end

function StrongModel:sort()
	table.sort(self.StrongFcList,function(a,b)
		return tonumber(a.id) < tonumber(b.id)
	end)
end

function StrongModel:clearList()
	self.StrongFcList = {} --提升战斗力列表
    self.StrongResList = {} --获取资源列表
end

function StrongModel:initStrongData(index)
	self.strongData = {}
	local cfg = qy.Config.strong
	for k,v in pairs(cfg) do
		if v.index == tonumber(index) then
			table.insert(self.strongData, v)
		end
	end

	table.sort(self.strongData, function(a, b)
		return a.id < b.id
	end)
end

function StrongModel:viewRedirectByModuleType(data)
	if data.id == 3 or data.id == 33 then
		local passenger = {["idx1"] = 2, ["idx2"] = 1}
		qy.tank.command.MainCommand:viewRedirectByModuleType(data.e_name, passenger)
	elseif data.id == 9 or data.id == 10 or data.id == 20 or data.id == 21 or data.id == 41 or data.id == 42 or data.id == 46 or data.id == 26 or data.id == 27 or data.id == 28 or data.id == 29 or data.id == 32 or data.id == 31 or data.id ==37 or data.id == 34 or data.id == 24 then
		qy.tank.command.ActivitiesCommand:showActivity(data.e_name)
	elseif data.id == 18 then
		qy.tank.command.MainCommand:viewRedirectByModuleType("mine_view")
	else
		qy.tank.command.MainCommand:viewRedirectByModuleType(data.e_name)
	end
end

return StrongModel