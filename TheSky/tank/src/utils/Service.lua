-- cc.XMLHTTPREQUEST_RESPONSE_STRING = 0  -- 返回字符串类型
-- cc.XMLHTTPREQUEST_RESPONSE_ARRAY_BUFFER = 1 -- 返回字节数组类型
-- cc.XMLHTTPREQUEST_RESPONSE_BLOB   = 2 -- 返回二进制大对象类型
-- cc.XMLHTTPREQUEST_RESPONSE_DOCUMENT = 3 -- 返回文档对象类型
-- cc.XMLHTTPREQUEST_RESPONSE_JSON = 4 -- 返回JSON数据类型

local Service = {}

--Get String
function Service.getString(url,callback)    
  local xhr = cc.XMLHttpRequest:new() -- http请求   
  xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING -- 响应类型  
  -- xhr:open("GET", "http://httpbin.org/get") 
  xhr:open("GET",url) -- 打开链接

  -- 状态改变时调用  
  local function onReadyStateChange()    
    print("Http Status Code:",xhr.statusText)
    print(xhr.response)
    if xhr.status == 200 then
      callback(qy.json.decode(xhr.response))
    end  
  end  

  -- 注册脚本回调方法  
  xhr:registerScriptHandler(onReadyStateChange)  
  -- 发送请求  
  xhr:send() 
  print("waiting...")  
end  
 
--Post String
function Service.postString(url,callback)  
  local xhr = cc.XMLHttpRequest:new() 
  xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING 
  xhr:open("POST",url)
  
  local function onReadyStateChange()  
    print("Http Status Code:",xhr.statusText)  
    print(xhr.response)
    callback(qy.json.decode(xhr.response))  
  end 
  
  xhr:registerScriptHandler(onReadyStateChange)  
  xhr:send()
  print("waiting...")  
end  


--Post Binary  
function Service.postBinary(url,callback)  
  local xhr = cc.XMLHttpRequest:new() 
  xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_ARRAY_BUFFER 
  -- xhr:open("POST", "http://httpbin.org/post") -- 打开Socket  
  xhr:open("POST",url) -- 打开Socket  

  -- 状态改变时调用  
  local function onReadyStateChange()  
    local response   = xhr.response -- 获得返回数据  
    local size     = table.getn(response) -- 获得返回数据大小  
    local strInfo = ""  

    for i = 1,size do  
      if 0 == response[i] then  
        strInfo = strInfo.."\'\\0\'"  
      else  
        strInfo = strInfo..string.char(response[i])  
      end  
    end  
    print("Http Status Code:",xhr.statusText)  
    print(strInfo) 
    callback(xhr) 
  end  

  xhr:registerScriptHandler(onReadyStateChange)
  xhr:send()  
  print("waiting...")  
end  
 
--Post Json  
function Service.postJson(url,callback)  
  local xhr = cc.XMLHttpRequest:new() 
  xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
  -- xhr:open("POST", "http://httpbin.org/post")  
  xhr:open("POST",url)  

  local function onReadyStateChange()  
    -- 显示状态码,成功显示200  
    print("Http Status Code:",xhr.statusText)  
    local response   = xhr.response -- 获得响应数据  
    local output = json.decode(response,1) -- 解析json数据  
    table.foreach(output,function(i, v) print (i, v) end)  
    print("headers are")  
    table.foreach(output.headers,print)  
    callback(xhr)
  end  
  
  xhr:registerScriptHandler(onReadyStateChange)  
  xhr:send()
  print("waiting...")  
end  

return Service
  