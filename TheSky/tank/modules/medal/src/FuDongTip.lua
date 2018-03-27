
local FuDongTip = qy.class("FuDongTip", qy.tank.view.BaseDialog, "medal/ui/FuDongTip")

local  model = qy.tank.model.MedalModel

function FuDongTip:ctor(delegate)
    FuDongTip.super.ctor(self)
    self.delegate = delegate
    for i=1,3 do
        self:InjectView("shuxing"..i)
        self:InjectView("extra"..i)
    end
    self:setCanceledOnTouchOutside(true)
    self.data = delegate.data
    self:update()
end
function FuDongTip:update(  )
	local medal_id = self.data.medal_id--勋章id
	local medaldata = model.medalcfg[medal_id..""]
	local color = qy.tank.utils.ColorMapUtil.qualityMapColorFor3b(medaldata.medal_colour)
    local attr = {}
    if self.delegate.type == 1 then
    	attr = self.data.attr
    else
    	attr = self.data.mod_attr
    end
    local tempnum = 1
	if #attr == 1 then
		tempnum = 1 
	elseif #attr == 2 then
		tempnum = 2
	else
		tempnum = 3
	end
	for i=1,tempnum do
		self["shuxing"..i]:setVisible(true)
		self["extra"..i]:setVisible(true)
	end
	for i=(tempnum+1),3 do
		self["shuxing"..i]:setVisible(false)
		self["extra"..i]:setVisible(false)
	end
	local isfulllist2 = model:IsFull(self.data,1)
	for j=1,#attr do
		local id = attr[j].attr_id
		local medalattr = model.medalattribute[id..""]
		local attribute = medalattr.attribute--类型
		local color = medalattr.colour_id --颜i
		if color > 6 then color = 6 end
		local color = qy.tank.utils.ColorMapUtil.qualityMapColorFor3b(color)
		self["shuxing"..j]:setColor(color)
		local  totalnum = attr[j].attr_val
		 --判断属性满不满
        if isfulllist2["id"..j] == -1 then
         	if attribute < 6 then
				self["extra"..j]:setString("("..medalattr.min.."-"..medalattr.max..")")
			else
				local nums1 = medalattr.min/10
				local nums2 = medalattr.max/10
				self["extra"..j]:setString("("..nums1.."%-"..nums2.."%)")
			end
        elseif isfulllist2["id"..j] == 1 then
        	self["extra"..j]:setString("")
            totalnum = totalnum + isfulllist2["num"..j]
        else
        	self["extra"..j]:setString("")
            totalnum = totalnum + isfulllist2["num"..j]
        end
		if attribute < 6 then
        	self["shuxing"..j]:setString(model.tujianTypeNameList[tostring(attribute)]..":+"..totalnum)
    	else
        	local tempnum = totalnum/10
        	self["shuxing"..j]:setString(model.tujianTypeNameList[tostring(attribute)]..":+"..tempnum.."%")
    	end
	end
end
function FuDongTip:onEnter()
    
end

function FuDongTip:onExit()
    
end


return FuDongTip
