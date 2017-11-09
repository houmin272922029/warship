//1
char * strcpy(char *strDest, const char *strSrc)
{
	assert((strDest != NULL) && (strSrc != NULL));
	char *addRess = strDest;
	while((*strDest ++ = *strSrc ++) != '\0');
	return addRess;
}
//strlen(str) strlen 它没有包括字符串末尾的'\0'

//2
int strlen( const char *str)
{
	assert( str != NULL);
	int len;
	while( (*str++) != '\0')
	{
		len++;
	}
	return len;
}

//3
void GetMemory(char *p)
{
	p = (char *) malloc(100);
}
void Test( void )
{
	char *str = NULL;
	GetMemory(str);
	strcpy(str, "hello world!");
	printf("%s\n", str);
}
//GetMemory(char *p)函数的形参为字符串指针，在函数内部修改形参并不能真正的改变传入形参的值，执行完 char*str = NULL;GetMemory(str)
//后仍然为NULL

//4
char *GetMemory(void)
{
	char p[] = "hello world!";
	return p;   //p[]数组为函数内的局部自动变量，在函数返回后，内部已经释放。
}
void Test(void)
{
	char *str =NULL;
	str = GetMemory();
	printf(str);
}


//5
void GetMemory( char **p, int num)
{
	*p = (char *)malloc(num); //开辟空间后未判断是否申请成功应加上 if (*p == NULL){抛出错误}
}
void Test( void )
{
	char *str = NULL;
	GetMemory(&str, 100);
	strcpy(str, "hello world!");
	printf("%s\n", str);//未对malloc的内存进行释放 并且对str制空(未制空会变成野指针)
}





void HelloWorld::onEnter()
{
    addNotificationListener();
}

void HelloWorld::onExit()
{
    removeNotificationListener();
}

void HelloWorld::addNotificationListener()
{
    notification_listener =  EventListenerCustom::create(NOTIFICATION_EVENT, [=](EventCustom* event){
        char* buf = static_cast<char*>(event->getUserData());
        CCLOG("Notification=%s",buf);
    });
    _eventDispatcher->addEventListenerWithFixedPriority(notification_listener, 1);


    register_notification_deviceToken_listener =  EventListenerCustom::create(REGISTER_NOTIFICATION_DEVICETOKEN_EVENT, [=](EventCustom* event){
        char* buf = static_cast<char*>(event->getUserData());
        CCLOG("register notification deviceToken=%s",buf);
    });
    _eventDispatcher->addEventListenerWithFixedPriority(register_notification_deviceToken_listener, 1);


    register_notification_error_listener =  EventListenerCustom::create(REGISTER_NOTIFICATION_ERROR_EVENT, [=](EventCustom* event){
        char* buf = static_cast<char*>(event->getUserData());
        CCLOG("register notification error=%s",buf);
    });
    _eventDispatcher->addEventListenerWithFixedPriority(register_notification_error_listener, 1);

}

void HelloWorld::removeNotificationListener()
{
    _eventDispatcher->removeEventListener(notification_listener);
    _eventDispatcher->removeEventListener(register_notification_deviceToken_listener);
    _eventDispatcher->removeEventListener(register_notification_error_listener);
}






void PushNotificationIOS::addNoticfy(std::string title,
	std::string content,
	unsigned int delalt,
	std::string key,
	unsigned int repeatTime)
{
    
    -- 创建一个本地推送
    UILocalNotification *notification = [[[UILocalNotification alloc] init] autorelease];
    -- 设置delalt秒之后
    NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow:delalt];
    if (notification != nil)
    {
        // 设置推送时间//
        notification.fireDate = pushDate;
        // 设置时区//
        notification.timeZone = [NSTimeZone defaultTimeZone];
        // 设置重复间隔//
        if (repeatTime!=0)
        {
            notification.repeatInterval = kCFCalendarUnitDay;
        }
        else
        {
            notification.repeatInterval = 0;
        }
        // 推送声音//
        notification.soundName = UILocalNotificationDefaultSoundName;
        // 推送内容//
        notification.alertBody = [NSString stringWithUTF8String: content.c_str()];
        //显示在icon上的红色圈中的数子//
        notification.applicationIconBadgeNumber = 1;
        //设置userinfo 方便在之后需要撤销的时候使用//
        NSDictionary *info = [NSDictionary dictionaryWithObject:[NSString stringWithUTF8String: key.c_str()] forKey:@"DDNoticfykey"];
        notification.userInfo = info;
        //添加推送到UIApplication//
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:notification];
        
    }

}



public static void FindMaxSumInString2()  
{  
    
    int[] a = new int[] { -1, -2, -3, -5, -4, -3, -10, -1 };  

    int sum = int.MinValue;  
    int tempSum = 0;  

    for (int i = 0; i < a.Length; i++)  
    {  
         
        if (tempSum > 0)  
        {  
            tempSum = tempSum + a[i];  
        }  
        else  
        {  
            tempSum = a[i];  
        }  

        if (tempSum > sum)  
        {  
            sum = tempSum;  
        }  

    }  
    Console.WriteLine(sum);  
}  

1、
#ifndef __TestShader__ShaderSprite__  
#define __TestShader__ShaderSprite__  
  
#include "cocos2d.h"  
USING_NS_CC;  
  
class ShaderSprite : public CCSprite {  
      
public:  
    static ShaderSprite* create(const char* pszFileName);  
    virtual bool initWithTexture(CCTexture2D *pTexture, const CCRect& rect);  
    virtual void draw(void);  
};  
  
#endif /* defined(__TestShader__ShaderSprite__) */  


2、
#include "ShaderSprite.h"  
  
static CC_DLL const GLchar *transparentshader =  
#include "tansparentshader.h"  
  
ShaderSprite* ShaderSprite::create(const char *pszFileName)  
{  
    ShaderSprite *pRet = new ShaderSprite();  
    if (pRet && pRet->initWithFile(pszFileName)) {  
        pRet->autorelease();  
        return pRet;  
    }  
    else  
    {  
        delete pRet;  
        pRet = NULL;  
        return NULL;  
    }  
}  
  
bool ShaderSprite::initWithTexture(CCTexture2D *pTexture, const CCRect& rect)  
{  
    do{  
//        CCLog("override initWithTexture!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");  
        CC_BREAK_IF(!CCSprite::initWithTexture(pTexture, rect));  
          
        // 加载顶点着色器和片元着色器  
        m_pShaderProgram = new  CCGLProgram();  
        m_pShaderProgram ->initWithVertexShaderByteArray(ccPositionTextureA8Color_vert, transparentshader);  
          
        CHECK_GL_ERROR_DEBUG();  
          
        // 启用顶点着色器的attribute变量，坐标、纹理坐标、颜色  
        m_pShaderProgram->addAttribute(kCCAttributeNamePosition, kCCVertexAttrib_Position);  
        m_pShaderProgram->addAttribute(kCCAttributeNameColor, kCCVertexAttrib_Color);  
        m_pShaderProgram->addAttribute(kCCAttributeNameTexCoord, kCCVertexAttrib_TexCoords);  
          
        CHECK_GL_ERROR_DEBUG();  
          
        // 自定义着色器链接  
        m_pShaderProgram->link();  
          
        CHECK_GL_ERROR_DEBUG();  
          
        // 设置移动、缩放、旋转矩阵  
        m_pShaderProgram->updateUniforms();  
          
        CHECK_GL_ERROR_DEBUG();  
          
        return true;  
          
    }while(0);  
    return false;  
}  
  
void ShaderSprite::draw(void)  
{  
//    CCLog("override draw!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");  
    CC_PROFILER_START_CATEGORY(kCCProfilerCategorySprite, "CCSprite - draw");  
      
    CCAssert(!m_pobBatchNode, "If CCSprite is being rendered by CCSpriteBatchNode, CCSprite#draw SHOULD NOT be called");  
      
    CC_NODE_DRAW_SETUP();  
      
    //  
    // 启用attributes变量输入，顶点坐标，纹理坐标，颜色  
    //  
    ccGLEnableVertexAttribs( kCCVertexAttribFlag_PosColorTex );  
    ccGLBlendFunc(m_sBlendFunc.src, m_sBlendFunc.dst);  
      
    m_pShaderProgram->use();  
    m_pShaderProgram->setUniformsForBuiltins();  
      
    // 绑定纹理到纹理槽0  
    ccGLBindTexture2D(m_pobTexture->getName());  
  
  
      
#define kQuadSize sizeof(m_sQuad.bl)  
    long offset = (long)&m_sQuad;  
      
    // vertex  
    int diff = offsetof( ccV3F_C4B_T2F, vertices);  
    glVertexAttribPointer(kCCVertexAttrib_Position, 3, GL_FLOAT, GL_FALSE, kQuadSize, (void*) (offset + diff));  
      
    // texCoods  
    diff = offsetof( ccV3F_C4B_T2F, texCoords);  
    glVertexAttribPointer(kCCVertexAttrib_TexCoords, 2, GL_FLOAT, GL_FALSE, kQuadSize, (void*)(offset + diff));  
      
    // color  
    diff = offsetof( ccV3F_C4B_T2F, colors);  
    glVertexAttribPointer(kCCVertexAttrib_Color, 4, GL_UNSIGNED_BYTE, GL_TRUE, kQuadSize, (void*)(offset + diff));  
      
      
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);  
      
    CHECK_GL_ERROR_DEBUG();  
  
    CC_INCREMENT_GL_DRAWS(1);  
    CC_PROFILER_STOP_CATEGORY(kCCProfilerCategorySprite, "CCSprite - draw");  
}  

3、
 
#ifdef GL_ES                                           
precision lowp float;                                 
#endif                                               
varying vec4 v_fragmentColor;                        
varying vec2 v_texCoord;                              
uniform sampler2D u_texture;                            
void main()                                             
{                                                       
    float ratio=0.0;                                    
    vec4 texColor = texture2D(u_texture, v_texCoord);    
    ratio = texColor[0] > texColor[1]?(texColor[0] > texColor[2] ? texColor[0] : texColor[2]) :(texColor[1] > texColor[2]? texColor[1] : texColor[2]);                                       
if (ratio != 0.0)                                           
{                                                           
    texColor[0] = texColor[0] /  ratio;                    
    texColor[1] = texColor[1] /  ratio;                    
    texColor[2] = texColor[2] /  ratio;                      
    texColor[3] = ratio;                                     
}                                                           
else                                                         
{                                                           
    texColor[3] = 0.0;                                     
}                                                          
gl_FragColor = v_fragmentColor*texColor;                    
}";  
