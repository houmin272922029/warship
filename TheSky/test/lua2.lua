+ (BinaryTreeNode *)invertBinaryTree:(BinaryTreeNode *)rootNode {
	if (!rootNode) {  return nil; }
	if (!rootNode.leftNode && !rootNode.rightNode) {  return rootNode; }
		NSMutableArray *queueArray = [NSMutableArray array]; --数组当成队列
		[queueArray addObject:rootNode]; --压入根节点
		while (queueArray.count > 0) {
				BinaryTreeNode *node = [queueArray firstObject];
				[queueArray removeObjectAtIndex:0]; --弹出最前面的节点，仿照队列先进先出原则
				BinaryTreeNode *pLeft = node.leftNode;
				node.leftNode = node.rightNode;
				node.rightNode = pLeft;

				if (node.leftNode) {
				    [queueArray addObject:node.leftNode];
				}
				if (node.rightNode) {
				    [queueArray addObject:node.rightNode];
				}

			}

	return rootNode;
}

-- --当前日期
-- var curDate = new Date();

-- --当前时间戳
-- var curTamp = curDate.getTime();

-- --当日凌晨的时间戳,减去一毫秒是为了防止后续得到的时间不会达到00:00:00的状态
-- var curWeeHours = new Date(curDate.toLocaleDateString()).getTime() - 1;

-- --当日已经过去的时间（毫秒）
-- var passedTamp = curTamp - curWeeHours;

-- --当日剩余时间
-- var leftTamp = 24 * 60 * 60 * 1000 - passedTamp;
-- var leftTime = new Date();
-- leftTime.setTime(leftTamp + curTamp);
-- document.cookie = cookieName + "=" + escape(cookieValue + id + ',') + ";expires=" + leftTime.toGMTString();






-- window.onload = function() {
-- 	setTimeout(function(){
-- 		var head = document.getElementsByTagName('head')[0];

-- 		var css = document.createElement('link');
-- 		css.type = "text/css";
-- 		css.rel = "stylesheet";
-- 		css.href = "http//domain.tld/preload.css";

-- 		var js = document.createElement("script");
-- 		js.type = "text/javascript";
-- 		js.src = "http://domain.tld/preload.js";

-- 		head.appendChild(css);
-- 		head.appendChild(js);

-- 		new Image().src = "http://domain.tld/preload.png";
-- 	},1000)
-- }


  
  
-- 1
-- 对Lua中元表的解释: 元表可以改变表的行为模式。
-- Window = {}
-- Window.prototype = {x = 0 ,y = 0 ,width = 100 ,height = 100,}  
  
-- Window.mt = {}  
  
-- function Window.new(o)  
--     setmetatable(o ,Window.mt)  -- 设置o为Window.mt的元表
--     return o  
-- end  
  
-- Window.mt.__index = Window.prototype  --Window.mt中的key指向Window.prototype表
  
-- Window.mt.__newindex = function (table ,key ,value)  
--     if key == "wangbin" then  
--         rawset(table ,"wangbin" ,"yes,i am")  --rawset进行赋值
--     end  
-- end  
  
-- w = Window.new{x = 10 ,y = 20}  
-- w.wangbin = "55"  
-- print(w.wangbin) 

-- 然后，我们可以看到打印信息是:yes,i am
-- 原本赋值的地方是w.wangbin = "55"，但是结果却是 yes,i am。
-- 这里就改变了元表的行为模式。

-- 2
-- __index是:当我们访问一个表中的元素不存在时，则会触发去寻找__index元方法，如果不存在，则返回nil，如果存在，则返回结果。
-- 打印结果是:1000。这里可以看出，我们在new的时候，w这个表里其实没有wangbin这个元素的，我们重写了元表中的__index，
-- 使其返回1000，意思是:如果你要寻找的元素，该表中没有，那么默认返回1000。
-- 备注:__index也可以是一个表，我们这里也可以写__index = {wangbin = 1000},打印的值仍然可以是1000。


-- 3
-- __newindex：当给你的表中不存在的值进行赋值时，lua解释器则会寻找__newindex元方法，
-- 发现存在该方法，则执行该方法进行赋值，注意，是使用rawset来进行赋值
  
-- 这里的打印结果是:yes,i am。w这个表里本来没有wangbin这个元素的，我们重写了元表中__newindex，
-- 并在__newindex方法中重新进行赋值操作，然后，我们对这个本不存在的w.wangbin进行赋值时，
-- 执行__newindex方法的赋值操作，最后，打印结果便是:yes,i am

-- 4 
-- rawget是为了绕过__index而出现的，直接点，就是让__index方法的重写无效。(类似重写)

-- Window = {}  
  
-- Window.prototype = {x = 0 ,y = 0 ,width = 100 ,height = 100,}  
-- Window.mt = {}  
-- function Window.new(o)  
--     setmetatable(o ,Window.mt)  
--     return o  
-- end  
-- Window.mt.__index = Window.prototype
-- -- Window.mt.__index = function (t ,key)  
-- --     return 1000  
-- -- end  
-- Window.mt.__newindex = function (table ,key ,value)  
--     if key == "wangbin" then  
--         rawset(table ,"wangbin" ,"yes,i am")  
--     end  
-- end  
-- w = Window.new{x = 10 ,y = 20}  
-- w.wangbin = "55" --调用__newindex方法 对wangbin这个key赋值为"yes,i am"
-- print(w.x, w.width, rawget(w ,w.wangbin),w.wangbin) 




-- self 

-- girl = {money = 200}  
-- function girl.goToMarket(girl ,someMoney)  
--     girl.money = girl.money - someMoney  
-- end  
-- girl.goToMarket(girl ,100)  
-- print(girl.money)


-- boy = {money = 200}  
-- function boy:goToMarket(someMoney)  
--     self.money = self.money - someMoney  
-- end  
-- boy:goToMarket(100)  
-- print(boy.money) 


-- boy = {money = 200}  
-- function boy.goToMarket(self ,someMoney)  
--     self.money = self.money - someMoney  
-- end  
-- boy:goToMarket(100)  
-- print(boy.money) 

-- 冒号只是起了省略第一个参数self的作用，该self指向调用者本身，并没有其他特殊的地方。


