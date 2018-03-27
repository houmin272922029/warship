


local ServerExerciseModel = qy.class("ServerExerciseModel", qy.tank.model.BaseModel)

ServerExerciseModel.tujianTypeNameList ={
	["1"] = qy.TextUtil:substitute(90046),
	["2"] = qy.TextUtil:substitute(90047),
	["3"] = qy.TextUtil:substitute(90048),
	["4"] = qy.TextUtil:substitute(90049),
	["5"] = qy.TextUtil:substitute(90050),
	["6"] = qy.TextUtil:substitute(90051),
	["7"] = qy.TextUtil:substitute(90052),
	["8"] = qy.TextUtil:substitute(90053),
	["9"] = qy.TextUtil:substitute(90054),
	["10"] = qy.TextUtil:substitute(90055),
	["11"] = qy.TextUtil:substitute(90056),
	["12"] = qy.TextUtil:substitute(90057),
	["13"] = qy.TextUtil:substitute(90058)
}

function ServerExerciseModel:init(data)
	self.data = {}
	self.mainlist = {}
	self.oppenentlist = {}
	self.ranklist = {}--排行榜
	self.configlist = {} --称号预览，读表
	self.WarDetailist = {}
	self.enterflag = true
	local staticData  = qy.Config.exervse_title
	
	for i, v in pairs(staticData) do
		table.insert(self.configlist, v)
	end
	  table.sort(self.configlist, function(a, b)
        return a.id < b.id
    end)
	  --{"exercise_user_info":{"strength":0,"total_num":0,
	  --"opponent_uid":0,"status":100,"integral":0,"total_win":0,"remain_diamond":0}}
	 self.data = data 
	 self.mainlist = data.exercise_user_info

	 print("解析",json.encode(data))
	 print(self.mainlist.status)
	if self.mainlist.opponent_uid ~= 0 and data.exercise_opponent_info then
		self.oppenentlist = data.exercise_opponent_info
	end
	
end
function ServerExerciseModel:update( data )
	self.data = data 
	self.enterflag = true
	self.mainlist = data.exercise_user_info
		--{"exercise_opponent_info":{"strength":0,"total_win":6,"win_proba":100,"head":"head_1","total_num":6,"remain_diamond":1540,"integral":6291,"up_num":1,"status":200},
		--"exercise_user_info":{"strength":488,"total_win":0,"status":200,"opponent_uid":136444,"head":"head_1","total_num":0,"win_proba":100,"integral":5000,"up_num":0,"remain_diamond":1000}}
	if self.mainlist.opponent_uid ~= 0 and data.exercise_opponent_info then
		self.oppenentlist = data.exercise_opponent_info
	end
	
	print("报名",json.encode(data))
end
function ServerExerciseModel:initranklist( data )
	--{"rank":0,"list":[{"kid":136444,"source":6291,"nickname":136444,"rank":1,"headicon":"head_1","server":"s8"},
	--{"kid":136527,"source":3495,"nickname":136527,"rank":2,"headicon":"head_1","server":"s6"}],"source":0}

	self.ranklist = data
	print("排行榜",json.encode(data))
end
function ServerExerciseModel:getstatus(  )
	--100 未报名 200 报名中 300 退赛
	return self.mainlist.status
end
function ServerExerciseModel:setstatus(  )
	self.enterflag = false
	self.configlist ={}
	local staticData  = qy.Config.exervse_title
	for i, v in pairs(staticData) do
		table.insert(self.configlist, v)
	end
	  table.sort(self.configlist, function(a, b)
        return a.id < b.id
    end)
end

function  ServerExerciseModel:getList()
	
end
function ServerExerciseModel:getMyWarDetail( data )
	self.list = data.list
	self.pages = data.page
	self.Maxpage = data.maxpage
	
end
function ServerExerciseModel:getAllWarDetail( data )
	-- body
end
function ServerExerciseModel:initatt( data )
	print("称号加成",json.encode(data))
	self.endlist = {}
	local list = {}
	if data.type_1  then
		print("...",#data.type_1)
		if #data.type_1 ~= 0 then
			local id = data.type_1[1].id
			local staticData  = qy.Config.exervse_title

			for i, v in pairs(staticData) do
				table.insert(list, v)
			end
			  table.sort(list, function(a, b)
			    return a.id < b.id
			end)
			local enddata = list[id]
			local num = enddata.num--有几个类型
			for i=1,num do
				local types = enddata["attr_type_"..i]
				local val = enddata["attr_val_"..i]
				if types > 10 then
				val  = (val/1000) +1
				 local params = {
		        	["id"] = types,
		        	["num"] = val,
	   			}
	    		table.insert(self.endlist,params);
			end
			end
		end
	end
	
end
function ServerExerciseModel:gettanklist( id1 )
	-- print("iiiiiiiii",json.encode(self.endlist))
	local total_num 
	if #self.endlist == 0 then
		if id1 < 11 then
			total_num =  0
		else
			total_num = 1
		end
	end
	for i=1,#self.endlist do
		if self.endlist[i].id == id1 then
			return  self.endlist[i].num
		else
			if id1 < 11 then
				total_num =  0
			else
				total_num = 1
			end
		end 
	end
	return total_num
end

return ServerExerciseModel