local ShopCell = qy.class("ShopCell", qy.tank.view.BaseView, "fanfanle.ui.ShopCell")

local userInfoModel = qy.tank.model.UserInfoModel
local service = qy.tank.service.FanFanLeService
function ShopCell:ctor(delegate)
   	ShopCell.super.ctor(self) 
   	self.delegate = delegate
    self.data = delegate.data
    self.types = delegate.types
    for i=1,3 do
    	self:InjectView("bg"..i)
     	self:InjectView("name"..i)
   		self:InjectView("num"..i)
   		self:InjectView("xiaohaonum"..i)
   		self:InjectView("expendimg"..i)
   		self:InjectView("buyBt"..i)
    end
    self:OnClick("buyBt1", function()
    	local aa = (self.index-1)*3 +1
    	self:confirmation(aa)
       print("duihuan"..aa)
    end)
    self:OnClick("buyBt2", function()
    	local aa = (self.index-1)*3 +2
    	self:confirmation(aa)
       print("duihuan"..aa)
    end)
    self:OnClick("buyBt3", function()
    	local aa = (self.index-1)*3 +3
       self:confirmation(aa)
    end)
    self.totalnum = delegate.num
    if delegate.types == 1 then
		for i=1,3 do
			self["expendimg"..i]:loadTexture("fanfanle/res/guang.png",0)
		end
    else
		for i=1,3 do
			self["expendimg"..i]:loadTexture("fanfanle/res/riyao.png",0)
		end
    end
    


end

function ShopCell:confirmation( nums )
	local dataa = self.data[nums]
    local dataname = qy.tank.view.common.AwardItem.getItemData(dataa.award[1])
    print("----------",json.encode(dataa))
    local function callBack(flag)
        if flag == qy.TextUtil:substitute(4012) then
            service:buyAward(dataa.id, function(data)
                self.delegate:callback()
            end)
        end
    end
    local num = tonumber(dataa.award[1].num)
    local numStr = num <=1 and "" or "x"..num

    local itemData = qy.tank.view.common.AwardItem.getItemData(dataa.award[1])
    --手写弹出框
    local image = ccui.ImageView:create()
    image:setContentSize(cc.size(500,120))
    image:setScale9Enabled(true)
    image:loadTexture("Resources/common/bg/c_12.png")

    local color = qy.tank.utils.ColorMapUtil.qualityMapColorFor3b(itemData.quality)

    local richTxt = ccui.RichText:create()
    richTxt:ignoreContentAdaptWithSize(false)
    richTxt:setContentSize(500, 150)
    richTxt:setAnchorPoint(0,0.5)
    local shuijing 
    local colors 
    if self.types == 1 then
    	shuijing = "日耀徽章"
    	colors = qy.tank.utils.ColorMapUtil.qualityMapColorFor3b(6)
    else
    	shuijing = "月华徽章"
    	colors = qy.tank.utils.ColorMapUtil.qualityMapColorFor3b(5)
    end
    local stringTxt1 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, qy.TextUtil:substitute(4007), qy.res.FONT_NAME_2, 24)
    richTxt:pushBackElement(stringTxt1)
    local stringTxt2 = ccui.RichElementText:create(2, cc.c3b(30,144,255), 255, dataa.num , qy.res.FONT_NAME_2, 24)
    richTxt:pushBackElement(stringTxt2)
    local stringTxt11 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, "个",qy.res.FONT_NAME_2, 24)
    richTxt:pushBackElement(stringTxt11)
    local stringTxt3 = ccui.RichElementText:create(3, colors, 255, shuijing, qy.res.FONT_NAME_2, 24)
    richTxt:pushBackElement(stringTxt3)
    local stringTxt111 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, "兑换",qy.res.FONT_NAME_2, 24)
    richTxt:pushBackElement(stringTxt111)
    local stringTxt4 = ccui.RichElementText:create(4, color, 255, dataname.name , qy.res.FONT_NAME_2, 24)
    richTxt:pushBackElement(stringTxt4)
    local stringTxt5 = ccui.RichElementText:create(5, cc.c3b(255,255,0), 255, numStr , qy.res.FONT_NAME_2, 24)
    richTxt:pushBackElement(stringTxt5)
    image:addChild(richTxt)


    qy.alert:showWithNode("提示",  image, cc.size(560,250), {{qy.TextUtil:substitute(4011) , 4},{qy.TextUtil:substitute(4012) , 5} }, callBack, {})
    image:setPosition(image:getPositionX() + 5, image:getPositionY() - 30)
end
function ShopCell:setData(_idx,num)
	print("lllllll",_idx.."ssssssss"..num)
	self.index = _idx
	local x = (_idx-1)*3
	if _idx == self.totalnum then
		if num == 0  then
			for i=1,3 do
				self["bg"..i]:setVisible(true)
				self["xiaohaonum"..i]:setString(self.data[x+i].num)
				local award = self.data[x+i].award[1] 
                local numStrs = 0
                if award.num > 10000 then
                    numStrs = award.num/10000 .."万"
                else
                    numStrs = award.num 
                end 
				self["num"..i]:setString(numStrs)
				local itemData = qy.tank.view.common.AwardItem.getItemData(award)
				local color = qy.tank.utils.ColorMapUtil.qualityMapColorFor3b(itemData.quality)
				self["name"..i]:setColor(color)
				self["name"..i]:setString(itemData.name)

				local item = qy.tank.view.common.AwardItem.createAwardView(award ,1)
			    self["bg"..i]:addChild(item)
			    item:setPosition(60 , 120)
			    item:setScale(0.8)
			    item.name:setVisible(false)
			    item.num:setVisible(false)
			end
		elseif num == 1 then
			self.bg1:setVisible(true)
			self.bg2:setVisible(false)
			self.bg3:setVisible(false)
			self["xiaohaonum1"]:setString(self.data[x+1].num)
			local award = self.data[x+1].award[1]
            local numStrs = 0
            if award.num > 10000 then
                numStrs = award.num/10000 .."万"
            else
                numStrs = award.num 
            end  
			self["num1"]:setString(numStrs)
			local itemData = qy.tank.view.common.AwardItem.getItemData(award)
    		local color = qy.tank.utils.ColorMapUtil.qualityMapColorFor3b(itemData.quality)
    		self["name1"]:setColor(color)
    		self["name1"]:setString(itemData.name)

    		local item = qy.tank.view.common.AwardItem.createAwardView(award ,1)
		    self["bg1"]:addChild(item)
		    item:setPosition(60 , 120)
		    item:setScale(0.8)
		    item.name:setVisible(false)
		    item.num:setVisible(false)
		else
			self.bg1:setVisible(true)
			self.bg2:setVisible(true)
			self.bg3:setVisible(false)
			self["xiaohaonum1"]:setString(self.data[x+1].num)
			local award = self.data[x+1].award[1]
            local numStrs = 0
            if award.num > 10000 then
                numStrs = award.num/10000 .."万"
            else
                numStrs = award.num 
            end
			self["num1"]:setString(numStrs)
			local itemData = qy.tank.view.common.AwardItem.getItemData(award)
    		local color = qy.tank.utils.ColorMapUtil.qualityMapColorFor3b(itemData.quality)
    		self["name1"]:setColor(color)
    		self["name1"]:setString(itemData.name)

    		local item = qy.tank.view.common.AwardItem.createAwardView(award ,1)
		    self["bg1"]:addChild(item)
		    item:setPosition(60 , 120)
		    item:setScale(0.8)
		    item.name:setVisible(false)
		    item.num:setVisible(false)
            self["xiaohaonum2"]:setString(self.data[x+2].num)
			local award = self.data[x+2].award[1]
            local numStrs = 0
            if award.num > 10000 then
                numStrs = award.num/10000 .."万"
            else
                numStrs = award.num 
            end 
			self["num2"]:setString(numStrs)
			local itemData = qy.tank.view.common.AwardItem.getItemData(award)
    		local color = qy.tank.utils.ColorMapUtil.qualityMapColorFor3b(itemData.quality)
    		self["name2"]:setColor(color)
    		self["name2"]:setString(itemData.name)

    		local item = qy.tank.view.common.AwardItem.createAwardView(award ,1)
		    self["bg2"]:addChild(item)
		    item:setPosition(60 , 120)
		    item:setScale(0.8)
		    item.name:setVisible(false)
		    item.num:setVisible(false)
		end
	else
		for i=1,3 do
			self["bg"..i]:setVisible(true)
			self["xiaohaonum"..i]:setString(self.data[x+i].num)
			local award = self.data[x+i].award[1]
            local numStrs = 0
            if award.num > 10000 then
                numStrs = award.num/10000 .."万"
            else
                numStrs = award.num 
            end
			self["num"..i]:setString(numStrs)
			local itemData = qy.tank.view.common.AwardItem.getItemData(award)
    		local color = qy.tank.utils.ColorMapUtil.qualityMapColorFor3b(itemData.quality)
    		self["name"..i]:setColor(color)
    		self["name"..i]:setString(itemData.name)
            print("======",json.encode(award))
    		local item = qy.tank.view.common.AwardItem.createAwardView(award ,1)
		    self["bg"..i]:addChild(item)
		    item:setPosition(60 , 120)
		    item:setScale(0.8)
		    item.name:setVisible(false)
		    item.num:setVisible(false)

		end
		
	end
end


return ShopCell
