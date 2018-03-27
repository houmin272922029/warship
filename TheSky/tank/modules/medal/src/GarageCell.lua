

local GarageCell = qy.class("GarageCell", qy.tank.view.BaseView, "medal/ui/GarageCell")

local service = qy.tank.service.MedalService
local garageModel = qy.tank.model.GarageModel
local  model = qy.tank.model.MedalModel
local StorageModel = qy.tank.model.StorageModel
local userInfoModel = qy.tank.model.UserInfoModel

function GarageCell:ctor(delegate)
    GarageCell.super.ctor(self)
    self.delegate = delegate
    for i=1,6 do
        self:InjectView("bg"..i)
        self:InjectView("fram"..i)
        self:InjectView("item"..i)
        self:InjectView("name"..i)
        self:InjectView("shuxing"..i.."_1")
        self:InjectView("shuxing"..i.."_2")
        self:InjectView("shuxing"..i.."_3")
        self:InjectView("extra"..i.."_1")
        self:InjectView("extra"..i.."_2")
        self:InjectView("extra"..i.."_3")
        self:InjectView("flag"..i)
        self:InjectView("box"..i)
        self:InjectView("boxchild"..i)
    end
    self:OnClickForBuilding1("bg1",function ( sender )
    	local aa = (self.index-1)*6 + 1
    	print("ssssssssssssss",self.touchflag)
    	local seq = cc.Sequence:create(delay , cc.CallFunc:create(function()
	        if self.touchType == true and delegate.type == 3 and self.touchflag == true then
	        	local delay = cc.DelayTime:create(0.3)
	        	delegate.callback(aa)
	    	else
	     		self.touchType = false
	    	end
    	end))
        self:runAction(seq)
    end)
    self:OnClickForBuilding1("bg2",function ( sender )
    	local aa = (self.index-1)*6 + 2
    	local seq = cc.Sequence:create(delay , cc.CallFunc:create(function()
	        if self.touchType == true and delegate.type == 3 and self.touchflag then
	        	local delay = cc.DelayTime:create(0.3)
	        	delegate.callback(aa)
	    	else
	     		self.touchType = false
	    	end
    	end))
        self:runAction(seq)
    end)
    self:OnClickForBuilding1("bg3",function ( sender )
    	local aa = (self.index-1)*6 + 3
    	local seq = cc.Sequence:create(delay , cc.CallFunc:create(function()
	        if self.touchType == true and delegate.type == 3 then
	        	local delay = cc.DelayTime:create(0.3)
	        	delegate.callback(aa)
	    	else
	     		self.touchType = false
	    	end
    	end))
        self:runAction(seq)
    end)
    self:OnClickForBuilding1("bg4",function ( sender )
    	local aa = (self.index-1)*6 + 4
    	local seq = cc.Sequence:create(delay , cc.CallFunc:create(function()
	        if self.touchType == true and delegate.type == 3 and self.touchflag then
	        	local delay = cc.DelayTime:create(0.3)
	        	delegate.callback(aa)
	    	else
	     		self.touchType = false
	    	end
    	end))
        self:runAction(seq)
    end)
    self:OnClickForBuilding1("bg5",function ( sender )
    	local aa = (self.index-1)*6 + 5
    	local seq = cc.Sequence:create(delay , cc.CallFunc:create(function()
	        if self.touchType == true and delegate.type == 3 and self.touchflag then
	        	local delay = cc.DelayTime:create(0.3)
	        	delegate.callback(aa)
	    	else
	     		self.touchType = false
	    	end
    	end))
        self:runAction(seq)
    end)
    self:OnClickForBuilding1("bg6",function ( sender )
    	local aa = (self.index-1)*6 + 6
    	local seq = cc.Sequence:create(delay , cc.CallFunc:create(function()
	        if self.touchType == true and delegate.type == 3 and self.touchflag then
	        	local delay = cc.DelayTime:create(0.3)
	        	delegate.callback(aa)
	    	else
	     		self.touchType = false
	    	end
    	end))
        self:runAction(seq)
    end)
    self:OnClickForBuilding1("box1",function ( sender )
    	local aa = (self.index-1)*6 + 1
        if self.flag_1 == 0 then
            self.flag_1 = 1
            self.boxchild1:setVisible(true)
            --选中了，存一下
        else
            self.flag_1 = 0
            self.boxchild1:setVisible(false)
        end
        delegate.callback2(aa)
    end)
     self:OnClickForBuilding1("box2",function ( sender )
     	local aa = (self.index-1)*6 + 2
        if self.flag_2 == 0 then
            self.flag_2 = 1
            self.boxchild2:setVisible(true)
            --选中了，存一下
        else
            self.flag_2 = 0
            self.boxchild2:setVisible(false)
        end
        delegate.callback2(aa)
    end)
    self:OnClickForBuilding1("box3",function ( sender )
    	local aa = (self.index-1)*6 + 3
        if self.flag_3 == 0 then
            self.flag_3 = 1
            self.boxchild3:setVisible(true)
            --选中了，存一下
        else
            self.flag_3 = 0
            self.boxchild3:setVisible(false)
        end
        delegate.callback2(aa)
    end)
    self:OnClickForBuilding1("box4",function ( sender )
    	local aa = (self.index-1)*6 + 4
        if self.flag_4 == 0 then
            self.flag_4 = 1
            self.boxchild4:setVisible(true)
            --选中了，存一下
        else
            self.flag_4 = 0
            self.boxchild4:setVisible(false)
        end
        delegate.callback2(aa)
    end)
    self:OnClickForBuilding1("box5",function ( sender )
    	local aa = (self.index-1)*6 + 5
        if self.flag_5 == 0 then
            self.flag_5 = 1
            self.boxchild5:setVisible(true)
            --选中了，存一下
        else
            self.flag_5 = 0
            self.boxchild5:setVisible(false)
        end
        delegate.callback2(aa)
    end)
    self:OnClickForBuilding1("box6",function ( sender )
    	local aa = (self.index-1)*6 + 6
        if self.flag_6 == 0 then
            self.flag_6 = 1
            self.boxchild6:setVisible(true)
            --选中了，存一下
        else
            self.flag_6 = 0
            self.boxchild6:setVisible(false)
        end
        delegate.callback2(aa)
    end)
    self:OnClickForBuilding1("item1",function ( sender )
    	local aa = (self.index-1)*6 + 1
    	self:clickBt(aa)
     	
    end)
     self:OnClickForBuilding1("item2",function ( sender )
     	local aa = (self.index-1)*6 + 2
     	self:clickBt(aa)
     	
    end)
    self:OnClickForBuilding1("item3",function ( sender )
    	local aa = (self.index-1)*6 + 3
    	self:clickBt(aa)
  		
    end)
    self:OnClickForBuilding1("item4",function ( sender )
    	local aa = (self.index-1)*6 + 4
    	self:clickBt(aa)
     	
    end)
    self:OnClickForBuilding1("item5",function ( sender )
    	local aa = (self.index-1)*6 + 5
    	self:clickBt(aa)
    	
    end)
    self:OnClickForBuilding1("item6",function ( sender )
    	local aa = (self.index-1)*6 + 6
    	self:clickBt(aa)
      	
    end)
    self.explainlist = delegate.explainlist
    self.data = delegate.data
    self.flag_1 = 0
    self.flag_2 = 0
    self.flag_3 = 0
    self.flag_4 = 0
    self.flag_5 = 0
    self.flag_6 = 0
    self.touchflag = true
    self.totalnum = delegate.totalnum--传过来的
end
function GarageCell:clickBt( id )
	 self.touchflag = false
	local node1 = require("medal.src.MedalTip").new({
            ["data"] = self.data[id],
            ["type"] = 1,
            ["callback1"] = function ( _data )
            	self.delegate.callback_c(self.data[id],self.delegate.type)
            end,
            ["callback2"] = function ( data1 )
            	self.delegate.callback_j(self.data[id],self.delegate.type)
            end,
            ["finish"] = function (  )
            	local delay = cc.DelayTime:create(0.4)
            	self:runAction(cc.Sequence:create(delay,cc.CallFunc:create(function()
                	self.touchflag = true
            	end)))
            	if self.delegate.self1:getChildByTag(777) then
                	self.delegate.self1:removeChildByTag(777,true)
            	end
            end
            })
    self.delegate.self1:addChild(node1,777,777)
end
function GarageCell:render(_idx,num)
	local isfulllist = {}
	self.index = _idx
	local x = (_idx-1)*6
	local tempnum = 0
	if _idx == self.totalnum then
		if num == 0  then
			for i=1,6 do
				self["bg"..i]:setVisible(true)
			end
			tempnum =  6
		elseif num == 1 then
			self.bg1:setVisible(true)
			for i=2,6 do
				self["bg"..i]:setVisible(false)
			end
			tempnum = 1
		elseif num == 2 then
			tempnum = 2
			for i=1,2 do
				self["bg"..i]:setVisible(true)
			end
			for i=3,6 do
				self["bg"..i]:setVisible(false)
			end
		elseif num == 3 then
			tempnum = 3
			for i=1,3 do
				self["bg"..i]:setVisible(true)
			end
			for i=4,6 do
				self["bg"..i]:setVisible(false)
			end
		elseif num == 4 then
			tempnum = 4
			for i=1,4 do
				self["bg"..i]:setVisible(true)
			end
			for i=5,6 do
				self["bg"..i]:setVisible(false)
			end
		else
			for i=1,5 do
				self["bg"..i]:setVisible(true)
			end
			tempnum = 5
			self.bg6:setVisible(false)
		end
		
	else
		for i=1,6 do
			self["bg"..i]:setVisible(true)
		end
		tempnum = 6
	end
	for i=1,tempnum do
		--做初始化数据操作
		isfulllist = model:IsFull(self.data[x+i],1)
		if self.delegate.type == 2 then
			self["box"..i]:setVisible(true)
			self["boxchild"..i]:setVisible(false)
			self["flag_"..i] = 0
			for mm=1,#self.explainlist do
				if self.explainlist[mm] == (x + i) then
					self["flag_"..i] = 1
					self["boxchild"..i]:setVisible(true)
					break
				end
			end
			
		else
			self["box"..i]:setVisible(false)
		end
		local medal_id = self.data[x+i].medal_id--勋章id
		local medaldata = model.medalcfg[medal_id..""]
		self["name"..i]:setString(medaldata.name)
		local color = qy.tank.utils.ColorMapUtil.qualityMapColorFor3b(medaldata.medal_colour)
		self["name"..i]:setColor(color)
		print("lllllll",medal_id)
		self["item"..i]:loadTexture("res/medal/"..medaldata.foreign_id.."_0"..medaldata.position..".jpg")
		self["item"..i]:setScale(0.78)
		local png = "Resources/common/item/item_bg_"..medaldata.medal_colour..".png"
        self["fram"..i]:loadTexture(png,1)
		if self["bg"..i]:getChildByTag(999) then
        	self["bg"..i]:removeChildByTag(999,true)
   		end
		if self.data[x+i].tank_unique_id == 0 then
			self["flag"..i]:setString("未装备")
			self["flag"..i]:setVisible(true)
			if self["bg"..i]:getChildByTag(999) then
                self["bg"..i]:removeChildByTag(999,true)
            end
		else
			self["flag"..i]:setVisible(false)
			local entity = qy.tank.model.GarageModel:getEntityByUniqueID(self.data[x+i].tank_unique_id)
			local color = qy.tank.utils.ColorMapUtil.qualityMapColorFor3b(entity.quality)
			local richTxt = ccui.RichText:create()
		    richTxt:ignoreContentAdaptWithSize(false)
		    richTxt:setContentSize(250, 50)
		    richTxt:setAnchorPoint(0,0.5)
		    local stringTxt1 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, "装备于", qy.res.FONT_NAME_2, 20)
		    richTxt:pushBackElement(stringTxt1)
		    local stringTxt2 = ccui.RichElementText:create(2, color, 255, entity.name, qy.res.FONT_NAME_2, 20)
		    richTxt:pushBackElement(stringTxt2)
		    richTxt:setPosition(cc.p(30,15))
		    self["bg"..i]:addChild(richTxt,999,999)
			-- self["flag"..i]:setString("装备上哪个坦克上了"..entity.name)
		end
		local attr = self.data[x+i].attr
		if #attr == 1 then
			self["shuxing"..i.."_2"]:setString("未激活")
			self["extra"..i.."_2"]:setString("")
            self["shuxing"..i.."_2"]:setColor(cc.c3b(255,255,255))
			self["shuxing"..i.."_3"]:setString("未激活")
            self["shuxing"..i.."_3"]:setColor(cc.c3b(255,255,255))
            self["extra"..i.."_3"]:setString("")
		elseif #attr == 2 then
			self["shuxing"..i.."_3"]:setString("未激活")
			self["extra"..i.."_3"]:setString("")
            self["shuxing"..i.."_3"]:setColor(cc.c3b(255,255,255))
		else
			self["shuxing"..i.."_2"]:setVisible(true)
			self["shuxing"..i.."_3"]:setVisible(true)
		end
		for j=1,#attr do
			local id = attr[j].attr_id
			local medalattr = model.medalattribute[id..""]
			local attribute = medalattr.attribute--类型
			local color = medalattr.colour_id --颜色 
			if color > 6 then color = 6 end
			local color = qy.tank.utils.ColorMapUtil.qualityMapColorFor3b(color)
			self["shuxing"..i.."_"..j]:setColor(color)
			local  totalnum = attr[j].attr_val

			 --判断属性满不满
            if isfulllist["id"..j] == -1 then
                local tempnum = isfulllist["num"..j]/10
                if attribute < 6 then
                    -- self["extra"..i.."_"..j]:setString("+"..isfulllist["num"..j])
                    self["extra"..i.."_"..j]:setString("")
                else
                    -- self["extra"..i.."_"..j]:setString("+"..tempnum.."%")
                    self["extra"..i.."_"..j]:setString("")
                end
                self["extra"..i.."_"..j]:setColor(cc.c3b(170,170,170))
            elseif isfulllist["id"..j] == 1 then
                self["extra"..i.."_"..j]:setString("(满)")
                totalnum = totalnum + isfulllist["num"..j]
                self["extra"..i.."_"..j]:setColor(cc.c3b(170,170,170))
            else
                totalnum = totalnum + isfulllist["num"..j]
                self["extra"..i.."_"..j]:setString("(共鸣)")
                self["extra"..i.."_"..j]:setColor(color)
            end

			if attribute < 6 then
            	self["shuxing"..i.."_"..j]:setString(model.tujianTypeNameList[tostring(attribute)]..":+"..totalnum)
        	else
            	local tempnum = totalnum/10
            	self["shuxing"..i.."_"..j]:setString(model.tujianTypeNameList[tostring(attribute)]..":+"..tempnum.."%")
        	end
		end
	end

end
function GarageCell:onEnter()
    self.listener = cc.EventListenerTouchOneByOne:create()
    local function onTouchBegan(touch, event)
        self.touchPoint1 = touch:getLocation()
        self.touchType = true
        return true
    end

    local function onTouchMoved(touch, event)
        return true
    end
    local function onTouchCancel(touch, event)
        self.touchType = false
        return false
    end

    local function onTouchEnded(touch, event)
        self.touchPoint2 = touch:getLocation()
        if math.abs(self.touchPoint1.y - self.touchPoint2.y) <=5 then
            self.touchType = true
        else
            self.touchType = false
        end
        return true

    end

    self.listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
    self.listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED)
    self.listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED)
    self.eventDispatcher = self:getEventDispatcher()
    self.eventDispatcher:addEventListenerWithSceneGraphPriority(self.listener,self.bg1)
end

function GarageCell:onExit()
    self:getEventDispatcher():removeEventListener(self.listener)
end


return GarageCell
