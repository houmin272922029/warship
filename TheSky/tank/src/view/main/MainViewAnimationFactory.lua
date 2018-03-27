local MainViewAnimationFactory = {}

--门
function MainViewAnimationFactory:getDoor(autoPlay)
	return self:create(18 , "fx/".. qy.language .."/ui/mainCity/door/door")
end

--人
function MainViewAnimationFactory:getMan( )
	return self:create(40 , "fx/".. qy.language .."/ui/mainCity/man/man")
end

--卡车
function MainViewAnimationFactory:getTruck( )
	return self:create(8 , "fx/".. qy.language .."/ui/mainCity/truck/truck")
end

function MainViewAnimationFactory:getTr( )
	
end

function MainViewAnimationFactory:create( max , url )
	local framesArr = {}
	for i=1,max do
		table.insert(framesArr , url..i..".png")
		--print(url..i..".png")
	end

	local animate = qy.tank.utils.AnimationUtil.createFrames(framesArr , 0 , 1 , 0)
	if autoPlay == nil or autoPlay == true then
		qy.tank.utils.AnimationUtil.playFrames(animate)
	end
	return animate
end

return  MainViewAnimationFactory