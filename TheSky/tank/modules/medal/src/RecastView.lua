
--重铸
local RecastView = qy.class("RecastView", qy.tank.view.BaseView, "medal/ui/RecastView")

local service = qy.tank.service.MedalService
local garageModel = qy.tank.model.GarageModel
local  model = qy.tank.model.MedalModel
local StorageModel = qy.tank.model.StorageModel
local userInfoModel = qy.tank.model.UserInfoModel

function RecastView:ctor(delegate)
    RecastView.super.ctor(self)
    self.delegate = delegate
  	qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync(qy.ResConfig.XUNZHANG_BAOCUN)
  	qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync(qy.ResConfig.XUNZHANG_KUANG)
  	qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync(qy.ResConfig.XUNZHANG_GUANG)
    for i=1,2 do
        self:InjectView("c_item"..i)
        self:InjectView("c_name"..i)--勋章名字
        self:InjectView("c_fram"..i)
    end
    for i=1,3 do
        self:InjectView("c_shuxing"..i)
        self:InjectView("c_extra"..i)
        self:InjectView("c_box"..i)--锁定
        self:InjectView("c_boxchild"..i)--锁定duihao
        self:InjectView("xinlist"..i)
        self:InjectView("x_shuxing"..i)
        self:InjectView("x_extra"..i)
    end
    self:InjectView("Image_109")
    self.Image_109:setVisible(false)
    self:InjectView("jihuo2Bt")--激活第2个
    self:InjectView("jihuo3Bt")--激活第3个
    self:InjectView("chongzhunum")--免费次数
    self:InjectView("c_chongzhuBt")--重铸bt
    self:InjectView("okBt")--保存结果
    self:InjectView("xioahaonum1")
    self:InjectView("xioahaonum2")
    self.xioahaonum2:setVisible(false)
    self:InjectView("xiaohaolist")
    self:InjectView("fangda1")
    self:InjectView("fangda2")
        -- --pannel4
    self:OnClick("jihuo2Bt",function ( sender )--20000000
    	self:jihuofun(1)
    end)
    self:OnClick("fangda1",function ( sender )
    	local node = require("medal.src.FuDongTip").new({
    		["data"] = self.data,
    		["type"] = 1
    		})
            node:show()
    end)
    self:OnClick("fangda2",function ( sender )
    	if #self.mod_attr == 0 then
    		qy.hint:show("请重铸后查看")
    		return
    	end
    	local node = require("medal.src.FuDongTip").new({
    		["data"] = self.data,
    		["type"] = 2
    		})
            node:show()
    end)
    self:OnClick("jihuo3Bt",function ( sender )
      	self:jihuofun(2)
    end)
    self:OnClick1("c_chongzhuBt",function ( sender )
    	
    	if #self.mod_attr == 0 then
    		self:chonghzu()
		else
			local tempnum = 0
			for i=1,#self.mod_attr do
				if self["c_box"..i.."flag"] == 0 then
					local id = self.mod_attr[i].attr_id
					local medalattr = model.medalattribute[id..""]
					local attribute = medalattr.attribute--类型
					local color = medalattr.colour_id --颜色 
					if color >= 4 then
						tempnum = 1 
						break
					end
				end
			end
			if tempnum == 1 and model.chonghzutype == 0 then
				require("medal.src.Tip1").new(self):show()
			else
				self:chonghzu()
			end
		end
    end)
    self:OnClick("okBt",function ( sender )
    	if self.baocunflag or #self.mod_attr ~= 0 then
    		service:saveRecast(self.data.unique_id,function ( data )
	    		self.baocunflag = false
	    		local list = {}
				for k,v in pairs(data) do
				    table.insert(list,v)
				end
				print("保存回答普")
				qy.Event.dispatch(qy.Event.XUNZHANG)
				self.data =  list[1]
				self:showEff2()
				self:update()
				delegate:callback()
    		end)
    	else
    		qy.hint:show("请先重铸勋章")
    	end
        
    end)
    self:OnClickForBuilding1("c_box1",function ( sender )
        if self.c_box1flag == 0 then
            self.c_box1flag = 1--存本地
            self.c_boxchild1:setVisible(true)
        else
            self.c_box1flag = 0--存本地
            self.c_boxchild1:setVisible(false)
        end
        self:updateBox()
        self:updatexiaohao()
    end)
    self:OnClickForBuilding1("c_box2",function ( sender )
        if self.c_box2flag == 0 then
            self.c_box2flag = 1--存本地
            self.c_boxchild2:setVisible(true)
        else
            self.c_box2flag = 0--存本地
            self.c_boxchild2:setVisible(false)
        end
        self:updateBox()
        self:updatexiaohao()
    end)
    self:OnClickForBuilding1("c_box3",function ( sender )
        if self.c_box3flag == 0 then
            self.c_box3flag = 1--存本地
            self.c_boxchild3:setVisible(true)
        else
            self.c_box3flag = 0--存本地
            self.c_boxchild3:setVisible(false)
        end
        self:updateBox()
        self:updatexiaohao()
    end)
    self.c_box1flag = 0 --存本地数据，是否锁定，0 为未锁定
    self.c_box2flag = 0
    self.c_box3flag = 0
    self.mod_attr = {}
    self.baocunflag = false
    self.totalnum = 0
    print("最终重铸的数据",json.encode(delegate.data))
    self.data = delegate.data
    self:update()
    self:updateBoxs()
end
function RecastView:chonghzu(  )
	local lock = {}
	if self.c_box1flag == 1 then
		table.insert(lock,0)
	end
	if self.c_box2flag == 1 then
		table.insert(lock,1)
	end
	if self.c_box3flag == 1 then
		table.insert(lock,2)
	end
	print("lock",json.encode(lock))
	if (userInfoModel.userInfoEntity.afliquid < self.totalnum or userInfoModel.userInfoEntity.exliquid < self.totalnum2) and model.freetime <=0 then
		print("资源不足")
		local function callBack(flag)
		    if flag == qy.TextUtil:substitute(4012) then
		    service:RecastAttr(self.data.unique_id,lock,function ( data )
	        	self.baocunflag = true
	        	model.freetime = model.freetime - 1
	        	local list = {}
				for k,v in pairs(data) do
				    table.insert(list,v)
				end
				qy.QYPlaySound.playEffect(qy.SoundType.TANK_UPGRADE)
				self.data =  list[1]
				self.delegate:callback()
				self:showEff1(lock)
				self:update()
        	end)
        	else
        	qy.QYPlaySound.playEffect(qy.SoundType.COMMON_CLICK)
		end
			end
			local image = ccui.ImageView:create()
			image:setContentSize(cc.size(500,120))
			image:setScale9Enabled(true)
			image:loadTexture("Resources/common/bg/c_12.png")

			local image1 = ccui.ImageView:create()
			image1:loadTexture("Resources/common/icon/coin/1a.png")
			image1:setPosition(cc.p(265,60))
			image:addChild(image1)

			local richTxt = ccui.RichText:create()
			richTxt:ignoreContentAdaptWithSize(false)
			richTxt:setContentSize(500, 150)
			richTxt:setAnchorPoint(0,0.5)
			 local tempnum = 0
    		if userInfoModel.userInfoEntity.afliquid < self.totalnum then
        		tempnum = self.totalnum - userInfoModel.userInfoEntity.afliquid
   			end
    		if userInfoModel.userInfoEntity.exliquid < self.totalnum2 then
        		tempnum = tempnum + (self.totalnum2 - userInfoModel.userInfoEntity.exliquid ) * 2
    		end
			local stringTxt1 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, "所需资源不足,确定花费      ", qy.res.FONT_NAME_2, 24)
			richTxt:pushBackElement(stringTxt1)
			local stringTxt2 = ccui.RichElementText:create(1, cc.c3b(255, 165, 0), 255, tempnum, qy.res.FONT_NAME_2, 24)
			richTxt:pushBackElement(stringTxt2)
			local stringTxt3 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, "继续重铸吗？", qy.res.FONT_NAME_2, 24)
			richTxt:pushBackElement(stringTxt3)
			image:addChild(richTxt)

			qy.alert1:showWithNode(qy.TextUtil:substitute(9004),  image, cc.size(560,250), {{qy.TextUtil:substitute(4011) , 4},{qy.TextUtil:substitute(4012) , 5} }, callBack, {})
			image:setPosition(image:getPositionX() + 5, image:getPositionY() - 30)
	else
        service:RecastAttr(self.data.unique_id,lock,function ( data )
        	self.baocunflag = true
        	model.freetime = model.freetime - 1
        	local list = {}
			for k,v in pairs(data) do
			    table.insert(list,v)
			end
			qy.QYPlaySound.playEffect(qy.SoundType.TANK_UPGRADE)
			self.data =  list[1]
			self.delegate:callback()
			self:update()
			self:showEff1(lock)
        end)
	end
end
function RecastView:showEff2(  )
	local currentEffert = nil
    if currentEffert == nil then
    	qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/ui/ui_fx_baocunshuxing",function()
	        currentEffert = ccs.Armature:create("ui_fx_baocunshuxing")
	        currentEffert:setScaleX(0.91)
	        self["c_item2"]:addChild(currentEffert,699,699)
	        local size = self["c_item2"]:getContentSize()
	        currentEffert:setPosition(size.width/2,size.height/2)
	        currentEffert:getAnimation():playWithIndex(0)
		end)
    	currentEffert:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
			if movementType == ccs.MovementEventType.complete then
    			currentEffert:removeFromParent()
    			currentEffert = nil
    			if currentEffert == nil then
		    		qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/ui/ui_fx_baocunshuxing1",function()
			        currentEffert = ccs.Armature:create("ui_fx_baocunshuxing1")
			        self["c_item2"]:addChild(currentEffert,699,699)
			        local size = self["c_item2"]:getContentSize()
			        currentEffert:setPosition(size.width/2,size.height/2)
			        currentEffert:getAnimation():playWithIndex(0)
					end)
			    	currentEffert:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
						if movementType == ccs.MovementEventType.complete then
			    			currentEffert:removeFromParent()
			    			currentEffert = nil
			    			if currentEffert == nil then
					    		qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/ui/ui_fx_baocunshuxing",function()
						        currentEffert = ccs.Armature:create("ui_fx_baocunshuxing")
						        self["c_item1"]:addChild(currentEffert,699,699)
						        local size = self["c_item1"]:getContentSize()
						        currentEffert:setPosition(size.width/2,size.height/2)
						        currentEffert:getAnimation():playWithIndex(0)
								end)
							end
						end
					end)

    			end
			end
		end)

    end
end
function RecastView:showEff1( lock )
	local nums = #self.data.mod_attr
	local list = {
	["1"] = 0 ,
	["2"] = 0 ,
	["3"] = 0
	}
	for i=1,#lock do
		if lock[i] == 0 then
			list["1"] = 1
		end
		if lock[i] == 1 then
			list["2"] = 1
		end
			if lock[i] == 2 then
			list["3"] = 1
		end
	end
	for i=1,nums do
		if list[i..""] == 0 then
			if self["xinlist"..i]:getChildByTag(699) then
        		self["xinlist"..i]:removeChildByTag(699,true)
    		end
		    local currentEffert = nil
		    if currentEffert == nil then
		    	qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/ui/ui_fx_shuaxinshuxing1",function()
			        currentEffert = ccs.Armature:create("ui_fx_shuaxinshuxing1")
			        currentEffert:setScaleX(0.91)
			        self["xinlist"..i]:addChild(currentEffert,699,699)
			        local size = self["xinlist"..i]:getContentSize()
			        currentEffert:setPosition(size.width/2,size.height/2)
			        currentEffert:getAnimation():playWithIndex(0)
    			end)
		    	currentEffert:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
        			if movementType == ccs.MovementEventType.complete then
            			currentEffert:removeFromParent()
        			end
    			end)

		    end
		end
	end
end
function RecastView:jihuofun( id )
	local function callBack(flag)
    if flag == qy.TextUtil:substitute(4012) then
    	if userInfoModel.userInfoEntity.silver < 20000000 then
    		qy.hint:show("金币不足")
    		return
    	end
       	service:activateAttr(self.data.unique_id,id,function ( data )
         	local list = {}
        	for k,v in pairs(data) do
			    table.insert(list,v)
			end
			self.data =  list[1]
			self:update()
        end)
    end
	end
	local image = ccui.ImageView:create()
	image:setContentSize(cc.size(500,120))
	image:setScale9Enabled(true)
	image:loadTexture("Resources/common/bg/c_12.png")

	local image1 = ccui.ImageView:create()
	image1:loadTexture("Resources/common/icon/coin/3.png")
	image1:setScale(0.4)
	image1:setPosition(cc.p(115,60))
	image:addChild(image1)

	local richTxt = ccui.RichText:create()
	richTxt:ignoreContentAdaptWithSize(false)
	richTxt:setContentSize(500, 150)
	richTxt:setAnchorPoint(0,0.5)
	local stringTxt1 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, "确定花费      ", qy.res.FONT_NAME_2, 24)
	richTxt:pushBackElement(stringTxt1)
	local stringTxt2 = ccui.RichElementText:create(1, cc.c3b(255, 165, 0), 255, 20000000, qy.res.FONT_NAME_2, 24)
	richTxt:pushBackElement(stringTxt2)
	local stringTxt3 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, "激活一条属性吗", qy.res.FONT_NAME_2, 24)
	richTxt:pushBackElement(stringTxt3)
	image:addChild(richTxt)

	qy.alert:showWithNode(qy.TextUtil:substitute(9004),  image, cc.size(560,250), {{qy.TextUtil:substitute(4011) , 4},{qy.TextUtil:substitute(4012) , 5} }, callBack, {})
	image:setPosition(image:getPositionX() + 5, image:getPositionY() - 30)
end
function RecastView:updateBoxs(	 )
	 if self.c_box1flag == 0 then
        self.c_boxchild1:setVisible(false)
    else
        self.c_boxchild1:setVisible(true)
    end
    if self.c_box2flag == 0 then
        self.c_boxchild2:setVisible(false)
    else
        self.c_boxchild2:setVisible(true)
    end
    if self.c_box3flag == 0 then
        self.c_boxchild3:setVisible(false)
    else
        self.c_boxchild3:setVisible(true)
    end
end
function RecastView:update(  )
	local medal_id = self.data.medal_id--勋章id
	local medaldata = model.medalcfg[medal_id..""]
	local color = qy.tank.utils.ColorMapUtil.qualityMapColorFor3b(medaldata.medal_colour)
	for i=1,2 do
		self["c_name"..i]:setString(medaldata.name)
		self["c_name"..i]:setColor(color)
		self["c_item"..i]:loadTexture("res/medal/"..medaldata.foreign_id.."_0"..medaldata.position..".jpg")
		local png = "Resources/common/item/item_bg_"..medaldata.medal_colour..".png"
        self["c_fram"..i]:loadTexture(png,1)
	end
	
    local attr = self.data.attr
    local tempnum = 1
	if #attr == 1 then
		tempnum = 1 
		for i=1,3 do
			self["c_box"..i]:setVisible(false)
		end
	elseif #attr == 2 then
		tempnum = 2
		self["c_box1"]:setVisible(true)
		self["c_box2"]:setVisible(true)
		self["c_box3"]:setVisible(false)
	else
		tempnum = 3
		self["c_box1"]:setVisible(true)
		self["c_box2"]:setVisible(true)
		self["c_box3"]:setVisible(true)
	end
	for i=1,tempnum do
		self["c_shuxing"..i]:setVisible(true)
		self["c_extra"..i]:setVisible(true)
		if self["jihuo"..i.."Bt"] then
			self["jihuo"..i.."Bt"]:setVisible(false)
		end
	end
	for i=(tempnum+1),3 do
		self["c_shuxing"..i]:setVisible(false)
		self["c_extra"..i]:setVisible(false)
		if self["jihuo"..i.."Bt"] then
			self["jihuo"..i.."Bt"]:setVisible(true)
		end
	end
	local isfulllist2 = model:IsFull(self.data,1)
	for j=1,#attr do
		local id = attr[j].attr_id
		local medalattr = model.medalattribute[id..""]
		local attribute = medalattr.attribute--类型
		local color = medalattr.colour_id --颜色 
		if color > 6 then color = 6 end
		local color = qy.tank.utils.ColorMapUtil.qualityMapColorFor3b(color)
		self["c_shuxing"..j]:setColor(color)
		local  totalnum = attr[j].attr_val
		 --判断属性满不满
        if isfulllist2["id"..j] == -1 then
            local tempnum1 = isfulllist2["min"..j]/10
            local tempnum2 = isfulllist2["max"..j]/10
            if attribute < 6 then
                self["c_extra"..j]:setString("("..isfulllist2["min"..j].."-"..isfulllist2["max"..j]..")")
            else
                self["c_extra"..j]:setString("("..tempnum1.."%-"..tempnum2.."%)")
            end
             self["c_extra"..j]:setString("")
            self["c_extra"..j]:setColor(cc.c3b(255,255,255))
        elseif isfulllist2["id"..j] == 1 then
            self["c_extra"..j]:setString("(满)")
            totalnum = totalnum + isfulllist2["num"..j]
            self["c_extra"..j]:setColor(cc.c3b(255,255,255))
        else
            totalnum = totalnum + isfulllist2["num"..j]
            self["c_extra"..j]:setString("(共鸣)")
            self["c_extra"..j]:setColor(color)
        end
		if attribute < 6 then
        	self["c_shuxing"..j]:setString(model.tujianTypeNameList[tostring(attribute)]..":+"..totalnum)
    	else
        	local tempnum = totalnum/10
        	self["c_shuxing"..j]:setString(model.tujianTypeNameList[tostring(attribute)]..":+"..tempnum.."%")
    	end
	end
	self.mod_attr = self.data.mod_attr
	local isfulllist = model:IsFull(self.data,2)
	if #self.mod_attr == 0 then
		for i=1,3 do
			self["xinlist"..i]:setVisible(false)
		end
	elseif #self.mod_attr == 1 then
		self["xinlist1"]:setVisible(true)
		self["xinlist2"]:setVisible(false)
		self["xinlist3"]:setVisible(false)
	elseif #self.mod_attr == 2 then
		self["xinlist1"]:setVisible(true)
		self["xinlist2"]:setVisible(true)
		self["xinlist3"]:setVisible(false)
	else
		for i=1,3 do
			self["xinlist"..i]:setVisible(true)
		end
	end
	for j=1,#self.mod_attr do
		local id = self.mod_attr[j].attr_id
		local medalattr = model.medalattribute[id..""]
		local attribute = medalattr.attribute--类型
		local color = medalattr.colour_id --颜色 
		if color > 6 then color = 6 end
		local color = qy.tank.utils.ColorMapUtil.qualityMapColorFor3b(color)
		self["x_shuxing"..j]:setColor(color)
		local  totalnum = self.mod_attr[j].attr_val
		 --判断属性满不满
        if isfulllist["id"..j] == -1 then
            local tempnum1 = isfulllist["min"..j]/10
            local tempnum2 = isfulllist["max"..j]/10
            if attribute < 6 then
                self["x_extra"..j]:setString("("..isfulllist["min"..j].."-"..isfulllist["max"..j]..")")
            else
                self["x_extra"..j]:setString("("..tempnum1.."%-"..tempnum2.."%)")
            end
            self["x_extra"..j]:setString("")
            self["x_extra"..j]:setColor(cc.c3b(255,255,255))
        elseif isfulllist["id"..j] == 1 then
            self["x_extra"..j]:setString("(满)")
            totalnum = totalnum + isfulllist["num"..j]
            self["x_extra"..j]:setColor(cc.c3b(255,255,255))
        else
            totalnum = totalnum + isfulllist["num"..j]
            self["x_extra"..j]:setString("(共鸣)")
            self["x_extra"..j]:setColor(color)
        end
		if attribute < 6 then
        	self["x_shuxing"..j]:setString(model.tujianTypeNameList[tostring(attribute)]..":+"..totalnum)
    	else
        	local tempnum = totalnum/10
        	self["x_shuxing"..j]:setString(model.tujianTypeNameList[tostring(attribute)]..":+"..tempnum.."%")
    	end
	end
	local freetime = model.freetime
	if freetime <= 0 then
		self.chongzhunum:setVisible(false)
		self.xiaohaolist:setVisible(true)
		self:updatexiaohao()
	else
		self.totalnum = 0
		self.totalnum2 = 0
		self.chongzhunum:setString("可免费重铸"..freetime.."次")
		self.xiaohaolist:setVisible(false)
	end
	self:updateBox()

end
function RecastView:updatexiaohao(  )
	self.totalnum = 0
	self.totalnum2 = 0
	local list = model.explainlist--分解的id
    local localrevise = model.localrevise--本地消耗表
    local medallist = model.medalcfg
   
    local medal_id = self.data.medal_id
    local qulity = medallist[medal_id..""].medal_colour
    local recast_afliquid_cost = localrevise[qulity..""].recast_afliquid_cost
    local recast_exliquid_cost = localrevise[qulity..""].recast_exliquid_cost
    if recast_exliquid_cost == 0 then
    	self.Image_109:setVisible(false)
    	self.xioahaonum2:setVisible(false)
	else
		self.Image_109:setVisible(true)
    	self.xioahaonum2:setVisible(true)
	end
    self.totalnum = recast_afliquid_cost
    self.totalnum2 = recast_exliquid_cost
    if self.c_box1flag == 1 then
    	self.totalnum = self.totalnum + recast_afliquid_cost 
    	self.totalnum2 = self.totalnum2 + recast_exliquid_cost
    end
    if self.c_box2flag == 1 then
    	self.totalnum = self.totalnum + recast_afliquid_cost 
    	self.totalnum2 = self.totalnum2 + recast_exliquid_cost
    end
    if self.c_box3flag == 1 then
    	self.totalnum = self.totalnum + recast_afliquid_cost 
    	self.totalnum2 = self.totalnum2 + recast_exliquid_cost
    end
   	self.xioahaonum1:setString(self.totalnum)
   	self.xioahaonum2:setString(self.totalnum2)
   	if userInfoModel.userInfoEntity.afliquid < self.totalnum then
		self.xioahaonum1:setColor( cc.c3b(251, 48, 0))
	else
		self.xioahaonum1:setColor( cc.c3b(255, 255, 255))
	end
	if userInfoModel.userInfoEntity.exliquid < self.totalnum2 then
		self.xioahaonum2:setColor( cc.c3b(251, 48, 0))
	else
		self.xioahaonum2:setColor( cc.c3b(255, 255, 255))
	end
end
function RecastView:updateBox(  )
	local attr = self.data.attr
	if #attr == 1 then
	elseif #attr == 2 then
		if self.c_box1flag == 1 then
			self["c_box2"]:setVisible(false)
		else
			self["c_box2"]:setVisible(true)
		end
		if self.c_box2flag == 1 then
			self["c_box1"]:setVisible(false)
		else
			self["c_box1"]:setVisible(true)
		end
	else
		if self.c_box1flag == 1 and self.c_box3flag == 1 then
			self["c_box2"]:setVisible(false)
		else
			self["c_box2"]:setVisible(true)
		end
		if self.c_box2flag == 1 and self.c_box3flag == 1 then
			self["c_box1"]:setVisible(false)
		else
			self["c_box1"]:setVisible(true)
		end
		if self.c_box2flag == 1 and self.c_box1flag == 1 then
			self["c_box3"]:setVisible(false)
		else
			self["c_box3"]:setVisible(true)
		end
	end
end
function RecastView:onEnter()
    
end
function RecastView:onExit()
    
end


return RecastView
