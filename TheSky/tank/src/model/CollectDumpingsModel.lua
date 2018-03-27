--[[
	Author: lj
	Date: 2016年08月05日15:02:46
]]

local CollectDumpingsModel = qy.class("CollectDumpingsModel", qy.tank.model.BaseModel)

local userinfoModel = qy.tank.model.UserInfoModel


function CollectDumpingsModel:init(datas )
	local data = datas.activity_info
	self.shoplist = qy.Config.collect_dumplings_shop
	local datas = qy.Config.collect_dumplings_checkpoint
	self.endtime = data.end_time 
	self.list = data.list
	self.free_time = datas["1"].free_times


end
function CollectDumpingsModel:Getshoplistnum(  )
	return table.nums(self.shoplist)
end
function CollectDumpingsModel:updatelist(id, data )
	self.list[id..""] = data
	for k,v in pairs(data) do
		self.list[id..""] = v
	end
	-- body
end




return CollectDumpingsModel