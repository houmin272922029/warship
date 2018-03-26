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












#ifndef __CCTEXTURE_CACHE_H__
#define __CCTEXTURE_CACHE_H__
//由CCObject派生
#include "cocoa/CCObject.h"
//需要用到字典
#include "cocoa/CCDictionary.h"
#include "textures/CCTexture2D.h"
#include <string>

//这里用到CCImage类和STL容器之一list
#if CC_ENABLE_CACHE_TEXTURE_DATA
    #include "platform/CCImage.h"
    #include <list>
#endif

//Cocos2d命名空间
NS_CC_BEGIN
//用到线程锁
class CCLock;
//用到CCImage处理图片
class CCImage;

//纹理管理器
class CC_DLL CCTextureCache : public CCObject
{
protected:
    //字典对象指针。
CCDictionary*               m_pTextures;
//线程临界区。用于锁定字典访问，貌似用不到。这里屏蔽了~
    //pthread_mutex_t          *m_pDictLock;


private:
    // 设置多线程加载图片时的回调函数。
    void addImageAsyncCallBack(float dt);

public:
    //构造函数
CCTextureCache();
//析构函数
    virtual ~CCTextureCache();
    //取得当前类描述
    const char* description(void);
    //取得当前字典的快照（拷贝）
    CCDictionary* snapshotTextures();

    //返回唯一纹理管理器的实例指针
    static CCTextureCache * sharedTextureCache();

    //销毁唯一纹理管理器的实例指针
    static void purgeSharedTextureCache();

//加载一个图片生成纹理，文件名做为字典的查询对应关键字。返回生成的纹理指针，支持png,bmp,tiff,jpeg,pvr,gif等格式。
    CCTexture2D* addImage(const char* fileimage);

    //此函数可以支持多线程载入图片，调用时会创建一个线程进行异步加载，加载成功后由主线程调用设置的回调函数，当然创建的纹理会做为参数传递。支持png和jpg
    void addImageAsync(const char *path, CCObject *target, SEL_CallFuncO selector);


    //加载一个图片生成纹理，指定参数key（其实要求是图片的相对路径字符串）做为字典的查询对应关键字。
    CCTexture2D* addUIImage(CCImage *image, const char *key);

    //通过查询关键字（其实要求是图片的相对路径字符串）从字典里找到对应的纹理。
CCTexture2D* textureForKey(const char* key);

    //清空字典，释放所有纹理。
    void removeAllTextures();

    //清除未被外部使用的纹理。怎么知道未使用呢？因为在Cocos2d-x中使用“引用计数器”来管理各种资源的使用情况，纹理也不例外。在资源类构造时，纹理的计数器值为0，但由CCTextureCache来创建完成后，会对纹理的资源计数器做加1操作以通知纹理说“你现在被我占用呢”。如果纹理被外部使用，应该再次调用其资源计数器做加1操作，退出使用时做减1操作通知其“我现在不用你了”。所以这里只需要遍历下计数器值为1的纹理即未被外部使用的纹理进行释放即可。
    void removeUnusedTextures();

    //移除一个纹理
    void removeTexture(CCTexture2D* texture);

    //由字典查询关键字找到相应纹理并移除。
    void removeTextureForKey(const char *textureKeyName);

    //打印出当前管理的纹理信息，包括现在纹理占用的内存和总的纹理内存。
    void dumpCachedTextureInfo();

#ifdef CC_SUPPORT_PVRTC
//如果开启支持PVR的压缩格式，这里提供加载PVR压缩文件生成纹理的函数。
//参1:PVR压缩文件名
//参2:压缩质量参数，只能设为2或4，4比2质量高，但压缩比低。2则相反。
//参3:是否有Alpha通道。这里会根据是否有ALPHA通道以生成相应的默认纹理格式。
//参4:图片必须是2的幂次方大小的正方形，所以这里只需要填写一下宽度，也就是图片大小。
    CCTexture2D* addPVRTCImage(const char* fileimage, int bpp, bool hasAlpha, int width);
#endif // CC_SUPPORT_PVRTC
    
   //加载普通的PVR图片文件生成纹理。
    CCTexture2D* addPVRImage(const char* filename);

//如果CC_ENABLE_CACHE_TEXTURE_DATA宏定义为可用（即值为1），则调用此函数会将所有的纹理都预加载进内存生成相应纹理。
    static void reloadAllTextures();
};

//如果定义了CC_ENABLE_CACHE_TEXTURE_DATA，这里定义一个新的类
#if CC_ENABLE_CACHE_TEXTURE_DATA

//新定义的类名称为VolatileTexture，意思是多变纹理。这里代表了多种数据源生成的纹理的管理器。
class VolatileTexture
{
//这里声明了一个枚举，代表了多变纹理对应的几种数据源类型
typedef enum {
    kInvalid = 0,//无效未加载任何数据的状态
    kImageFile,  //图片文件
    kImageData,  //内存中的图片数据
    kString,     //字符串
    kImage,      //图片对象(CCImage)
}ccCachedImageType;

public:
    //构造
VolatileTexture(CCTexture2D *t);
//析构
    ~VolatileTexture();
     //静态函数：通过图片文件生成的纹理及相关信息生成一个多变纹理并将其指针放入容器。
static void addImageTexture(CCTexture2D *tt, const char* imageFileName, CCImage::EImageFormat format);
//静态函数：通过字符串生成的纹理及相关信息生成一个多变纹理并将其指针放入容器。
static void addStringTexture(CCTexture2D *tt, const char* text, const CCSize& dimensions, CCTextAlignment alignment, 
                                 CCVerticalTextAlignment vAlignment, const char *fontName, float fontSize);
    //通过图片数据生成的纹理及相关信息生成一个多变纹理并将其指针放入容器。
static void addDataTexture(CCTexture2D *tt, void* data, CCTexture2DPixelFormat pixelFormat, const CCSize& contentSize);
//通过图片对象生成的纹理及相关信息生成一个多变纹理并将其指针放入容器。
static void addCCImage(CCTexture2D *tt, CCImage *image);
    //通过纹理指针参数从容器中删除对应的多变纹理
static void removeTexture(CCTexture2D *t);
//重新载入所有的纹理
    static void reloadAllTextures();

public:
    //静态多变纹理指针容器，用来存储所有的多变纹理对象指针。
static std::list<VolatileTexture*> textures;
//是否正在进行全部重新载入
    static bool isReloading;
    
private:
    //通过纹理指针参数从容器找到对应的多变纹理对象指针
    static VolatileTexture* findVolotileTexture(CCTexture2D *tt);

protected:
    //与当前多变纹理对应的纹理指针
    CCTexture2D *texture;
    //对应的图片对象
    CCImage *uiImage;
//数据源类型
    ccCachedImageType m_eCashedImageType;
//纹理数据指针
void *m_pTextureData;
//纹理的实际大小
CCSize m_TextureSize;
//纹理的像素格式
    CCTexture2DPixelFormat m_PixelFormat;
//对应的图片名称
std::string m_strFileName;
//图片的像素格式
    CCImage::EImageFormat m_FmtImage;
//图片的大小
    CCSize          m_size;
    //横向文字的对齐方式
CCTextAlignment m_alignment;
 //纵向文字的对齐方式
CCVerticalTextAlignment m_vAlignment;
//字体名称
std::string     m_strFontName;
//文字
std::string     m_strText;
//字体大小
    float           m_fFontSize;
};

#endif


NS_CC_END

#endif //__CCTEXTURE_CACHE_H__
然后是CPP文件：

#include "CCTextureCache.h"
#include "CCTexture2D.h"
#include "ccMacros.h"
#include "CCDirector.h"
#include "platform/platform.h"
#include "platform/CCFileUtils.h"
#include "platform/CCThread.h"
#include "platform/CCImage.h"
#include "support/ccUtils.h"
#include "CCScheduler.h"
#include "cocoa/CCString.h"
#include <errno.h>
#include <stack>
#include <string>
#include <cctype>
#include <queue>
#include <list>
#include <pthread.h>
#include <semaphore.h>
//使用标准库命名空间
using namespace std;
//使用Cocos2d命名空间
NS_CC_BEGIN
//异步加载所用的消息结构
typedef struct _AsyncStruct
{
    std::string          filename;//文件名
    CCObject                *target;  //调用者
    SEL_CallFuncO        selector; //载回完的回调函数
} AsyncStruct;
//图片信息
typedef struct _ImageInfo
{
    AsyncStruct    *asyncStruct;    //异步加载消息结构
    CCImage        *image;         //图片指针
    CCImage::EImageFormat imageType//图片类型
} ImageInfo;

//加载图片的线程
static pthread_t s_loadingThread;
//用于读取异步消息队列的线程临界区
static pthread_mutex_t      s_asyncStructQueueMutex;
//用于存储图片信息结构处理的临界区
static pthread_mutex_t      s_ImageInfoMutex;
//信号量指针。信号量是当前进程中的多个线程通信的一种方式。
static sem_t* s_pSem = NULL;
//多线程加载图片的数量。
static unsigned long s_nAsyncRefCount = 0;
//如果是IOS平台，则定义是否使用信号量命名。
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
    #define CC_ASYNC_TEXTURE_CACHE_USE_NAMED_SEMAPHORE 1
#else
    #define CC_ASYNC_TEXTURE_CACHE_USE_NAMED_SEMAPHORE 0
#endif
    
//如果使用信号量命名，则定义命名的字符串宏，否则定义静态全局的信号量结构。
#if CC_ASYNC_TEXTURE_CACHE_USE_NAMED_SEMAPHORE
    #define CC_ASYNC_TEXTURE_CACHE_SEMAPHORE "ccAsync"
#else
    static sem_t s_sem;
#endif

//是否在当前加载线程处理完手上的活儿就退出。
static bool need_quit = false;
//异步加载图片的消息结构指针容器，即消息队列。
static std::queue<AsyncStruct*>* s_pAsyncStructQueue = NULL;
//异步存储图片信息结构指针的容器。
static std::queue<ImageInfo*>*   s_pImageQueue = NULL;
//通过文件扩展名取得图片格式
static CCImage::EImageFormat computeImageFormatType(string& filename)
{
    CCImage::EImageFormat ret = CCImage::kFmtUnKnown;
    //JPG
    if ((std::string::npos != filename.find(".jpg")) || (std::string::npos != filename.find(".jpeg")))
    {
        ret = CCImage::kFmtJpg;
    }//PNG
    else if ((std::string::npos != filename.find(".png")) || (std::string::npos != filename.find(".PNG")))
    {
        ret = CCImage::kFmtPng;
    }//TIFF
    else if ((std::string::npos != filename.find(".tiff")) || (std::string::npos != filename.find(".TIFF")))
    {
        ret = CCImage::kFmtTiff;
    }
    
    return ret;
}
//加载图片的线程函数
static void* loadImage(void* data)
{
    // 创建一个线程信息对象
    CCThread thread;
    thread.createAutoreleasePool();
    //多线程加载消息结构
    AsyncStruct *pAsyncStruct = NULL;

    //线程将处理所有随时要进行多线程加载的图片，所以会有一个While循环。
    while (true)
    {
        //当前线程等待信号量变为非零值，并减1。
        int semWaitRet = sem_wait(s_pSem);
         //如果信号量为负值，打印出错信息并中断。
        if( semWaitRet < 0 )
        {
            CCLOG( "CCTextureCache async thread semaphore error: %s\n", strerror( errno ) );
            break;
        }
        //取得全局的异步加载信息结构指针容器
        std::queue<AsyncStruct*> *pQueue = s_pAsyncStructQueue;
         //下面代码作为临界区上锁
        pthread_mutex_lock(&s_asyncStructQueueMutex);
        //如果没有需要异步加载的图片
        if (pQueue->empty())
        {
              //解锁临界区
            pthread_mutex_unlock(&s_asyncStructQueueMutex);
            //如果退出线程标记为true则中断退出，否则继续。
            if (need_quit)
                break;
            else
                continue;
        }
        else
        {   
              //如果有需要异步加载的图片，则从队列中取第一个消息指针保存在变量pAsyncStruct中随后将其从队列中移除。
            pAsyncStruct = pQueue->front();
            pQueue->pop();
             //解锁临界区
            pthread_mutex_unlock(&s_asyncStructQueueMutex);
        }        
         //取得要进行异步加载的图片名称
        const char *filename = pAsyncStruct->filename.c_str();

        //取得图片类型
        CCImage::EImageFormat imageType = computeImageFormatType(pAsyncStruct->filename);
         //如果不是PNG,JPG或TIFF就不支持了。打印错误后进行相应处理。
        if (imageType == CCImage::kFmtUnKnown)
        {
            CCLOG("unsupportted format %s",filename);
            delete pAsyncStruct;
            
            continue;
        }
        
        // 如果是有效格式，生成一个新的CCImage对象           
        CCImage *pImage = new CCImage();
        // 由文件名和图片格式将图片加载到CCImage中。
        if (! pImage->initWithImageFileThreadSafe(filename, imageType))
        {    //如果失败，释放CCImage对象并打印错误。
            delete pImage;
            CCLOG("can not load %s", filename);
            continue;
        }

        // 动态创建一个新的图片信息结构并填充相应信息
        ImageInfo *pImageInfo = new ImageInfo();
        pImageInfo->asyncStruct = pAsyncStruct;
        pImageInfo->image = pImage;
        pImageInfo->imageType = imageType;

        //下面代码作为临界区上锁
        pthread_mutex_lock(&s_ImageInfoMutex);
        //将新的图片信息放入图片信息结构容器。
        s_pImageQueue->push(pImageInfo);
        //解锁临界区
        pthread_mutex_unlock(&s_ImageInfoMutex);    
    }
    //如果退出循环，释放信号量
    if( s_pSem != NULL )
    {
    #if CC_ASYNC_TEXTURE_CACHE_USE_NAMED_SEMAPHORE
        sem_unlink(CC_ASYNC_TEXTURE_CACHE_SEMAPHORE);
        sem_close(s_pSem);
    #else
        sem_destroy(s_pSem);
    #endif
        s_pSem = NULL;
         //释放多线程加载所用的消息队列和与之对应的图片信息队列。
        delete s_pAsyncStructQueue;
        delete s_pImageQueue;
    }
    
    return 0;
}


// 唯一的全局纹理数据缓冲区对象指针
static CCTextureCache *g_sharedTextureCache = NULL;
//取得唯一的全局纹理数据缓冲区对象指针
CCTextureCache * CCTextureCache::sharedTextureCache()
{
    if (!g_sharedTextureCache)
    {
        g_sharedTextureCache = new CCTextureCache();
    }
    return g_sharedTextureCache;
}
//构造函数
CCTextureCache::CCTextureCache()
{
    CCAssert(g_sharedTextureCache == NULL, "Attempted to allocate a second instance of a singleton.");
    //生成一个字典  
    m_pTextures = new CCDictionary();
}
//析构函数
CCTextureCache::~CCTextureCache()
{
    CCLOGINFO("cocos2d: deallocing CCTextureCache.");
    need_quit = true;
    if (s_pSem != NULL)
    {
        sem_post(s_pSem);
    }
    //释放字典
    CC_SAFE_RELEASE(m_pTextures);
}
//释放唯一的全局纹理数据缓冲区对象
void CCTextureCache::purgeSharedTextureCache()
{
    CC_SAFE_RELEASE_NULL(g_sharedTextureCache);
}
//取得当前类描述
const char* CCTextureCache::description()
{
    return CCString::createWithFormat("<CCTextureCache | Number of textures = %u>", m_pTextures->count())->getCString();
}
//取得当前字典的快照
CCDictionary* CCTextureCache::snapshotTextures()
{ 
    //动态创建一个新的字典
    CCDictionary* pRet = new CCDictionary();
CCDictElement* pElement = NULL;
//遍历原来字典将数据填充到新字典中
    CCDICT_FOREACH(m_pTextures, pElement)
    {
        pRet->setObject(pElement->getObject(), pElement->getStrKey());
    }
    return pRet;
}
//使用多线程载入图片。
//参1:图片相对路径名。
//参2:载入完成后要通知的对象。
//参3:载入完成后要通知对象调用的函数。
void CCTextureCache::addImageAsync(const char *path, CCObject *target, SEL_CallFuncO selector)
{
//文件名不能为空
    CCAssert(path != NULL, "TextureCache: fileimage MUST not be NULL");    
//定义一个纹理指针并置空
    CCTexture2D *texture = NULL;

//创建字符串pathKey做为字典查询关键字。
    std::string pathKey = path;
//取得图片所在位置的全路径名
pathKey = CCFileUtils::sharedFileUtils()->fullPathFromRelativePath(pathKey.c_str());
//先查询一下是否字典里已经有了此纹理。
    texture = (CCTexture2D*)m_pTextures->objectForKey(pathKey.c_str());

    std::string fullpath = pathKey;
//如果已经有了，则直接把纹理做为参数调用要通知的对象的函数。
if (texture != NULL)
    {
        if (target && selector)
        {
            (target->*selector)(texture);
        }
        
        return;
    }

//如果是第一次调用多线程载入，创建信号量并进行相应初始化。
if (s_pSem == NULL)
{   
    //判断是否使用信号量命名，如果是，创建一个信号量返回其地址给指针s_pSem。
#if CC_ASYNC_TEXTURE_CACHE_USE_NAMED_SEMAPHORE
        s_pSem = sem_open(CC_ASYNC_TEXTURE_CACHE_SEMAPHORE, O_CREAT, 0644, 0);
        if( s_pSem == SEM_FAILED )
        {
            CCLOG( "CCTextureCache async thread semaphore init error: %s\n", strerror( errno ) );
            s_pSem = NULL;
            return;
        }
#else
         //如果不使用信号量命名，直接用sem_init来初始化信号量对象s_sem。
        int semInitRet = sem_init(&s_sem, 0, 0);
        if( semInitRet < 0 )
        {
              //如果失败，打印出错并退出。
            CCLOG( "CCTextureCache async thread semaphore init error: %s\n", strerror( errno ) );
            return;
        }
         //如果成功，将信号量对象地址给指针s_pSem。
        s_pSem = &s_sem;
#endif
 //建立加载消息队列
        s_pAsyncStructQueue = new queue<AsyncStruct*>();
        //建立加载的图片信息结构队列
        s_pImageQueue = new queue<ImageInfo*>();        
        //线程锁初始化
        pthread_mutex_init(&s_asyncStructQueueMutex, NULL);
        pthread_mutex_init(&s_ImageInfoMutex, NULL);
 //创建加载线程。
        pthread_create(&s_loadingThread, NULL, loadImage, NULL);
         //将退出指令设为false。
        need_quit = false;
    }
//多线程加载图片的引用计数器如果为0，
    if (0 == s_nAsyncRefCount)
    {
    //将addImageAsyncCallBack函数加入显示设备上的回调函数处理器中。
CCDirector::sharedDirector()->getScheduler()->scheduleSelector(schedule_selector(CCTextureCache::addImageAsyncCallBack), this, 0, false);
    }
//计数器加1
    ++s_nAsyncRefCount;
//
    if (target)
    {
        target->retain();
    }

    // 产生一个新的加载消息，放入加载消息队列中。
    AsyncStruct *data = new AsyncStruct();
    data->filename = fullpath.c_str();
    data->target = target;
    data->selector = selector;

    // 当然，放入时得锁一下，放入后再解锁。
    pthread_mutex_lock(&s_asyncStructQueueMutex);
    s_pAsyncStructQueue->push(data);
    pthread_mutex_unlock(&s_asyncStructQueueMutex);
//给信号量加1，sem_post是原子操作，即多个线程同时调用并不会产生冲突。
    sem_post(s_pSem);
}
//多线程加载图片时的回调函数。
void CCTextureCache::addImageAsyncCallBack(float dt)
{
    // 取得多线程加载的图片信息队列
    std::queue<ImageInfo*> *imagesQueue = s_pImageQueue;
    //下面代码作为临界区上锁
pthread_mutex_lock(&s_ImageInfoMutex);
//如果图片信息队列为空直接解锁，否则进行处理
    if (imagesQueue->empty())
    {
        pthread_mutex_unlock(&s_ImageInfoMutex);
    }
    else
{
     //取出图片信息队列的头一个信息从队列中弹出。
        ImageInfo *pImageInfo = imagesQueue->front();
        imagesQueue->pop();
        //解锁临界区
        pthread_mutex_unlock(&s_ImageInfoMutex);
        //取得信息中的加载消息。
        AsyncStruct *pAsyncStruct = pImageInfo->asyncStruct;
         //取得图片信息中的CCImage指针。
        CCImage *pImage = pImageInfo->image;
         //取得加载完成后要通知的对象以及要调用的函数。
        CCObject *target = pAsyncStruct->target;
        SEL_CallFuncO selector = pAsyncStruct->selector;
         //取得图片文件名
        const char* filename = pAsyncStruct->filename.c_str();

        // 新建一个纹理。
        CCTexture2D *texture = new CCTexture2D();
        //使用CCImage指针pImage来初始化纹理生成OpenGL贴图。
#if 0 //TODO: (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
        texture->initWithImage(pImage, kCCResolutioniPhone);
#else
        texture->initWithImage(pImage);
#endif

#if CC_ENABLE_CACHE_TEXTURE_DATA
       //使用纹理和图片信息生成相应的可变纹理
       VolatileTexture::addImageTexture(texture, filename, pImageInfo->imageType);
#endif

        //使用文件名做为查询关键字将纹理存入字典
        m_pTextures->setObject(texture, filename);
        texture->autorelease();
        //调用通知目标的相应函数。
        if (target && selector)
        {
            (target->*selector)(texture);
            target->release();
        }        
         //释放CCImage对象。
        pImage->release();
         //释放new出来的消息结构和图片信息结构。
        delete pAsyncStruct;
        delete pImageInfo;
        //多线程加载引用计数器减1，
        --s_nAsyncRefCount;
        if (0 == s_nAsyncRefCount)
        {
          //从显示设备上的回调函数处理器中移除加载回调函数。
CCDirector::sharedDirector()->getScheduler()->unscheduleSelector(schedule_selector(CCTextureCache::addImageAsyncCallBack), this);
        }
    }
}
//加载一个图片生成纹理。
CCTexture2D * CCTextureCache::addImage(const char * path)
{
//参数有效性判断
    CCAssert(path != NULL, "TextureCache: fileimage MUST not be NULL");
//定义纹理指针变量并置空
    CCTexture2D * texture = NULL;
    //非多线程，故屏蔽，如果addImageAsync在其它线程调用此函数，则打开这段代码。
    //pthread_mutex_lock(m_pDictLock);

//创建字符串pathKey做为字典查询关键字。
    std::string pathKey = path;
//取得图片所在位置的全路径名
pathKey = CCFileUtils::sharedFileUtils()->fullPathFromRelativePath(pathKey.c_str());
    //用pathKey查询字典中是否有此纹理。
    texture = (CCTexture2D*)m_pTextures->objectForKey(pathKey.c_str());
//新建字符串fullpath存储全路径。
std::string fullpath = pathKey;
//如果没有找到，
    if( ! texture ) 
{
//将文件路径放入新字符串lowerCase。并将字符串中的所有字母转为小写。
        std::string lowerCase(path);
        for (unsigned int i = 0; i < lowerCase.length(); ++i)
        {
            lowerCase[i] = tolower(lowerCase[i]);
        }
        // 
        do 
        {   
 //如果字符串能够找到".pvr"，则代表是pvr文件。调用相应函数将其载入。
            if (std::string::npos != lowerCase.find(".pvr"))
            {
                texture = this->addPVRImage(fullpath.c_str());
            }
            else
            {
                //否则分别取得文件的格式。
                CCImage::EImageFormat eImageFormat = CCImage::kFmtUnKnown;
                if (std::string::npos != lowerCase.find(".png"))
                {
                    eImageFormat = CCImage::kFmtPng;
                }
                else if (std::string::npos != lowerCase.find(".jpg") || std::string::npos != lowerCase.find(".jpeg"))
                {
                    eImageFormat = CCImage::kFmtJpg;
                }
                else if (std::string::npos != lowerCase.find(".tif") || std::string::npos != lowerCase.find(".tiff"))
                {
                    eImageFormat = CCImage::kFmtTiff;
                }
                
                  //创建CCImage对象，从文件中读取文件的数据并初始化CCImage对象。
                CCImage image;  
                //取得文件大小 
                unsigned long nSize = 0;
                  //读入数据返回给BYTE类型指针。
                unsigned char* pBuffer = CCFileUtils::sharedFileUtils()->getFileData(fullpath.c_str(), "rb", &nSize);
                //使用读入的数据初始化相应的图片对象。
                CC_BREAK_IF(! image.initWithImageData((void*)pBuffer, nSize, eImageFormat));
                //读完后释放数据占用的内存。
                CC_SAFE_DELETE_ARRAY(pBuffer);
  //创建一个纹理。
                texture = new CCTexture2D();
                //使用图片对象创建纹理。
                if( texture &&
                    texture->initWithImage(&image) )
                {
#if CC_ENABLE_CACHE_TEXTURE_DATA
                    // 使用图片对象生成可变纹理
                    VolatileTexture::addImageTexture(texture, fullpath.c_str(), eImageFormat);
#endif
                    //利用路径名做为查询关键字将纹理存入字典。
                    m_pTextures->setObject(texture, pathKey.c_str());
                    //计数器减1。则刚存入字典的纹理的引用计数器值标记为尚未使用。
                    texture->release();
                }
                else
                {
                    //失败则打印错误。                          
                    CCLOG("cocos2d: Couldn't add image:%s in CCTextureCache", path);
                }
            }
        } while (0);
    }
//与上面屏蔽加锁一样，这里屏蔽解锁。
    //pthread_mutex_unlock(m_pDictLock);
    return texture;
}

//如果支持PVR的压缩格式。
#ifdef CC_SUPPORT_PVRTC
//加载一个PVR的压缩格式的图片。
CCTexture2D* CCTextureCache::addPVRTCImage(const char* path, int bpp, bool hasAlpha, int width)
{
//参数有效性判断
CCAssert(path != NULL, "TextureCache: fileimage MUST not be nill");
//压缩类型参数有效性判断，只能为2或4
    CCAssert( bpp==2 || bpp==4, "TextureCache: bpp must be either 2 or 4");
//定义一个新的纹理指针
    CCTexture2D * texture;

//定义临时字符串存储相对路径名。
    std::string temp(path);
    //查询字典中是否已经有此纹理。有则取得并直接返回纹理。
    if ( (texture = (CCTexture2D*)m_pTextures->objectForKey(temp.c_str())) )
    {
        return texture;
    }
    
    // 取得文件的全路径字符串。
    std::string fullpath( CCFileUtils::sharedFileUtils()->fullPathFromRelativePath(path) );

    //新建变量nLeng用于存储读取到的数据大小。初始化为0。
 unsigned long nLen = 0;
//新建字符指针pData用于存储读取到的数据并实际读取文件数据。
    unsigned char* pData = CCFileUtils::sharedFileUtils()->getFileData(fullpath.c_str(), "rb", &nLen);
 //新建创一个纹理。
    texture = new CCTexture2D();
    //使用读取到的数据创建纹理。
    if( texture->initWithPVRTCData(pData, 0, bpp, hasAlpha, width,
                                   (bpp==2 ? kCCTexture2DPixelFormat_PVRTC2 : kCCTexture2DPixelFormat_PVRTC4)))
{
        //将纹理以文件名做为关键字存入字典。
        m_pTextures->setObject(texture, temp.c_str());
 //将纹理交由内存管理器处理。
        texture->autorelease();
    }
    else
    {
        //如果创建失败或读取PVR文件失败，打印错误日志。\
        CCLOG("cocos2d: Couldn't add PVRTCImage:%s in CCTextureCache",path);
}
//释放读取文件的数据所占用的内存。
    CC_SAFE_DELETE_ARRAY(pData);

    return texture;
}
#endif // CC_SUPPORT_PVRTC

//加载一个普通的PVR图片文件
CCTexture2D * CCTextureCache::addPVRImage(const char* path)
{
//文件名参数有效性判断。
    CCAssert(path != NULL, "TextureCache: fileimage MUST not be nill");
//新建纹理指针变量置空。
CCTexture2D* texture = NULL;
//定义临时字符串存储相对路径名。
    std::string key(path);
    //先使用文件名查询是否字典中已经有此纹理了。如果有直接取得并返回纹理。
    if( (texture = (CCTexture2D*)m_pTextures->objectForKey(key.c_str())) ) 
    {
        return texture;
    }

// 由文件名字符串取得图片的全路径字符串。
std::string fullpath = CCFileUtils::sharedFileUtils()->fullPathFromRelativePath(key.c_str());
//动态创建一个纹理。
    texture = new CCTexture2D();
     //如果创建成功，则读取相应的PVR文件来初始化纹理。
    if(texture != NULL && texture->initWithPVRFile(fullpath.c_str()) )
{
//初始化成功。
#if CC_ENABLE_CACHE_TEXTURE_DATA
        // 使用纹理和图片信息生成可变纹理。
        VolatileTexture::addImageTexture(texture, fullpath.c_str(), CCImage::kFmtRawData);
#endif
//将纹理以文件名做为查询关键字存入字典。
        m_pTextures->setObject(texture, key.c_str());
        texture->autorelease();
    }
    else
{
        //如果创建失败或读取PVR文件失败，打印错误日志。
        CCLOG("cocos2d: Couldn't add PVRImage:%s in CCTextureCache",key.c_str());
        CC_SAFE_DELETE(texture);
    }

    return texture;
}
//加载一个图片生成纹理，指定参数key做为字典的查询对应关键字。
CCTexture2D* CCTextureCache::addUIImage(CCImage *image, const char *key)
{
    //参数有效性判断
    CCAssert(image != NULL, "TextureCache: image MUST not be nill");

    //定义纹理指针变量texure做为返回值。这里初始化为空。
    CCTexture2D * texture = NULL;
    //定义字符串变量forKey用来存储完整的图片路径名称。
    std::string forKey;
    if (key)
{
    //取得文件名所对应的全路径名，呵呵，这个key也还是个相对路径名啊。
        forKey = CCFileUtils::sharedFileUtils()->fullPathFromRelativePath(key);
    }

    do 
    {
        // 查询字典是否已经有此纹理了。如果有，取出纹理返回给texture，中断退出。
        if(key && (texture = (CCTexture2D *)m_pTextures->objectForKey(forKey.c_str())))
        {
            break;
        }

        //动态创建一个纹理对象.返回给texture。
        texture = new CCTexture2D();
        //使用image来初始化纹理.注意:这一句应该移到下面的if中。
        texture->initWithImage(image);
         //初始化完成后以路径名做为查询关键字将纹理存入字典。
        if(key && texture)
        {
            m_pTextures->setObject(texture, forKey.c_str());
            texture->autorelease();
        }
        else
        {
             //如果key为空或texture为空打印错误
            CCLOG("cocos2d: Couldn't add UIImage in CCTextureCache");
        }

    } while (0);

#if CC_ENABLE_CACHE_TEXTURE_DATA
    //使用纹理和CCImage对象生成可变纹理。
    VolatileTexture::addCCImage(texture, image);
#endif
    
    return texture;
}

//清空字典，释放所有纹理。
void CCTextureCache::removeAllTextures()
{
    m_pTextures->removeAllObjects();
}
//清除未被外部使用的纹理
void CCTextureCache::removeUnusedTextures()
{
/*原来的做法，因为有问题给屏蔽了，仍然解释下：
//定义字典词汇指针变量pElement。
CCDictElement* pElement = NULL;
//遍历字典
    CCDICT_FOREACH(m_pTextures, pElement)
{
    //打印词汇信息
        CCLOG("cocos2d: CCTextureCache: texture: %s", pElement->getStrKey());
        //取得词汇对应的纹理
        CCTexture2D *value = (CCTexture2D*)pElement->getObject();
         //如果引用计数器值为1，从字典中删除。
        if (value->retainCount() == 1)
        {
            CCLOG("cocos2d: CCTextureCache: removing unused texture: %s", pElement->getStrKey());
            m_pTextures->removeObjectForElememt(pElement);
        }
    }
     */
    
    //现在的做法 
    // 判断字典不为空
    if (m_pTextures->count())
    {   
        //定义字典词汇指针变量pElement。
CCDictElement* pElement = NULL;
    //定义一个list容器用来存储未被外部使用的纹理指针。
        list<CCDictElement*> elementToRemove;
        //遍历字典
        CCDICT_FOREACH(m_pTextures, pElement)
        {
             //打印词汇信息
            CCLOG("cocos2d: CCTextureCache: texture: %s", pElement->getStrKey());
            //取得词汇对应的纹理
            CCTexture2D *value = (CCTexture2D*)pElement->getObject();
            if (value->retainCount() == 1)
            {
                //如果引用计数器值为1，先存入容器中。
                elementToRemove.push_back(pElement);
            
        }
        
        // 遍历list中的元素从字典中删除
        for (list<CCDictElement*>::iterator iter = elementToRemove.begin(); iter != elementToRemove.end(); ++iter)
        {
            //打印删除元素日志。
            CCLOG("cocos2d: CCTextureCache: removing unused texture: %s", (*iter)->getStrKey()); 
           //从字典中删除
            m_pTextures->removeObjectForElememt(*iter);
        }
}
//好吧，答案是因为CCDICT_FOREACH和removeObjectForElememt会互相影响，CCDICT_FOREACH中会调用HASH_ITER循环遍历。而循环的计数器是位置，通过地址对比来找下一个结点位置。而removeObjectForElememt会调用HASH_DELETE删除元素导致链表的重构。重构后会影响到HASK_ITER的查询。

}
//移除一个纹理
void CCTextureCache::removeTexture(CCTexture2D* texture)
{
    //参数有效性判断
    if( ! texture )
    {
        return;
    }
    //查询所有对应此纹理的词汇
CCArray* keys = m_pTextures->allKeysForObject(texture);
//从字典中把这些词汇及相应纹理删除。
    m_pTextures->removeObjectsForKeys(keys);
}
//由字典查询关键字找到相应纹理并移除。
void CCTextureCache::removeTextureForKey(const char *textureKeyName)
{
    //参数有效性判断
    if (textureKeyName == NULL)
    {
        return;
    }
    //查询关键字实际是文件的相对路径，这里取得全路径。
string fullPath = CCFileUtils::sharedFileUtils()->fullPathFromRelativePath(textureKeyName);
//将全路径做为查询关键字从字典中删除相应词汇及纹理
    m_pTextures->removeObjectForKey(fullPath.c_str());
}
//由字典查询关键字找到相应纹理
CCTexture2D* CCTextureCache::textureForKey(const char* key)
{
    return (CCTexture2D*)m_pTextures->objectForKey(CCFileUtils::sharedFileUtils()->fullPathFromRelativePath(key));
}
//重新载入所有的纹理
void CCTextureCache::reloadAllTextures()
{
#if CC_ENABLE_CACHE_TEXTURE_DATA
    //调用可变纹理的静态函数重新载入所有的纹理
    VolatileTexture::reloadAllTextures();
#endif
}
//打印字典中的纹理统计信息。
void CCTextureCache::dumpCachedTextureInfo()
{
    unsigned int count = 0;
    unsigned int totalBytes = 0;

CCDictElement* pElement = NULL;
//遍历字典中的所有词汇信息
    CCDICT_FOREACH(m_pTextures, pElement)
{
    //取得词汇对应的纹理
    CCTexture2D* tex = (CCTexture2D*)pElement->getObject();
     //取得纹理对应贴图的色深
        unsigned int bpp = tex->bitsPerPixelForFormat();
        // 生成贴图占用的内存大小(字节数量)
        unsigned int bytes = tex->getPixelsWide() * tex->getPixelsHigh() * bpp / 8;
         // 统计内存总大小
        totalBytes += bytes;
        count++;
         //打印纹理信息
        CCLOG("cocos2d: \"%s\" rc=%lu id=%lu %lu x %lu @ %ld bpp => %lu KB",
               pElement->getStrKey(),       //查询关键字
               (long)tex->retainCount(),    //使用次数
               (long)tex->getName(),        //图片名称
               (long)tex->getPixelsWide(),//对应贴图的宽度
               (long)tex->getPixelsHigh(),//对应贴图的高度
               (long)bpp,                   //对应贴图色深
               (long)bytes / 1024);     //占用内存大小(千字节数量)
    }
    //打印总的数量数量，占用内存数量。
    CCLOG("cocos2d: CCTextureCache dumpDebugInfo: %ld textures, for %lu KB (%.2f MB)", (long)count, (long)totalBytes / 1024, totalBytes / (1024.0f*1024.0f));
}
//如果开启了使用多变纹理
#if CC_ENABLE_CACHE_TEXTURE_DATA
//定义全局的list容器，用来存储产生的多变纹理对象指针
std::list<VolatileTexture*> VolatileTexture::textures;
//定义布尔变量标记是否在全部重新载入
bool VolatileTexture::isReloading = false;
//构造函数
VolatileTexture::VolatileTexture(CCTexture2D *t)
: texture(t)
, m_eCashedImageType(kInvalid)
, m_pTextureData(NULL)
, m_PixelFormat(kTexture2DPixelFormat_RGBA8888)
, m_strFileName("")
, m_FmtImage(CCImage::kFmtPng)
, m_alignment(kCCTextAlignmentCenter)
, m_vAlignment(kCCVerticalTextAlignmentCenter)
, m_strFontName("")
, m_strText("")
, uiImage(NULL)
, m_fFontSize(0.0f)
{
    m_size = CCSizeMake(0, 0);
    textures.push_back(this);
}
//析构函数
VolatileTexture::~VolatileTexture()
{
    textures.remove(this);
    CC_SAFE_RELEASE(uiImage);
}
//通过纹理图片属性信息生成可变纹理。
void VolatileTexture::addImageTexture(CCTexture2D *tt, const char* imageFileName, CCImage::EImageFormat format)
{
    //如果正在重新载入过程中，直接返回。
    if (isReloading)
    {
        return;
    }
    //通过纹理指针找到相应的可变纹理，如果没有则new一个返回其指针。
    VolatileTexture *vt = findVolotileTexture(tt);
    //设置相关属性，注意:这里最好对vt做下有效性检查，如果为NULL的话会崩溃的。
    vt->m_eCashedImageType = kImageFile;
    vt->m_strFileName = imageFileName;
    vt->m_FmtImage    = format;
    vt->m_PixelFormat = tt->getPixelFormat();
}
//通过CCImage对象生成可变纹理。
void VolatileTexture::addCCImage(CCTexture2D *tt, CCImage *image)
{
    //通过纹理指针找到相应的可变纹理，如果没有则new一个返回其指针。
    VolatileTexture *vt = findVolotileTexture(tt);
image->retain();
//设置相关属性
    vt->uiImage = image;
    vt->m_eCashedImageType = kImage;
}
//通过纹理指针找到相应的可变纹理，如果没有则new出一个返回。
VolatileTexture* VolatileTexture::findVolotileTexture(CCTexture2D *tt)
{
VolatileTexture *vt = 0;
//遍历list容器，对比查询。
    std::list<VolatileTexture *>::iterator i = textures.begin();
    while (i != textures.end())
    {
        VolatileTexture *v = *i++;
        if (v->texture == tt) 
        {
            vt = v;
            break;
        }
    }
    //如果没有找到，则由纹理参数new出一个可变纹理，new会调用其带参数的拷贝构造函数设置其对应纹理。
    if (! vt)
    {
        vt = new VolatileTexture(tt);
    }
    
    return vt;
}
//通过指定图像数据，像素格式和图片大小来生成可变纹理。
void VolatileTexture::addDataTexture(CCTexture2D *tt, void* data, CCTexture2DPixelFormat pixelFormat, const CCSize& contentSize)
{
    //如果正在重新载入过程中，直接返回。
    if (isReloading)
    {
        return;
    }
    //通过纹理指针找到相应的可变纹理，如果没有则new一个返回其指针。
    VolatileTexture *vt = findVolotileTexture(tt);
    //设置相关属性
    vt->m_eCashedImageType = kImageData;
    vt->m_pTextureData = data;
    vt->m_PixelFormat = pixelFormat;
    vt->m_TextureSize = contentSize;
}
//由字符串和相应信息生成可变纹理
void VolatileTexture::addStringTexture(CCTexture2D *tt, const char* text, const CCSize& dimensions, CCTextAlignment alignment, 
                                       CCVerticalTextAlignment vAlignment, const char *fontName, float fontSize)
{
    //如果正在重新载入过程中，直接返回。
    if (isReloading)
    {
        return;
    }
    //通过纹理指针找到相应的可变纹理，如果没有则new一个返回其指针。
    VolatileTexture *vt = findVolotileTexture(tt);
    //设置相关属性
    vt->m_eCashedImageType = kString;
    vt->m_size        = dimensions;
    vt->m_strFontName = fontName;
    vt->m_alignment   = alignment;
    vt->m_vAlignment  = vAlignment;
    vt->m_fFontSize   = fontSize;
    vt->m_strText     = text;
}
//通过纹理指针找到相应的可变纹理并删除。
void VolatileTexture::removeTexture(CCTexture2D *t) 
{

    std::list<VolatileTexture *>::iterator i = textures.begin();
    while (i != textures.end())
    {
        VolatileTexture *vt = *i++;
        if (vt->texture == t) 
        {
            delete vt;
            break;
        }
    }
}
//重新载入所有的纹理。
void VolatileTexture::reloadAllTextures()
{
    //设置开始进行重新载入所有纹理。
    isReloading = true;

CCLOG("reload all texture");
//通过迭代器遍历list容器
    std::list<VolatileTexture *>::iterator iter = textures.begin();
    while (iter != textures.end())
    {
        VolatileTexture *vt = *iter++;
         //根据不同的格式进行纹理的重建
        switch (vt->m_eCashedImageType)
        {
        case kImageFile:
            {
                  //这里定义一个CCImage对象image
                CCImage image;
                  //先将路径名都变成小写字符串。
                std::string lowerCase(vt->m_strFileName.c_str());
                for (unsigned int i = 0; i < lowerCase.length(); ++i)
                {
                    lowerCase[i] = tolower(lowerCase[i]);
                }
                  //扩展名对比，如果是PVR文件
                if (std::string::npos != lowerCase.find(".pvr")) 
                {
                      //取得原来的默认带ALPHA通道的像素格式。
                    CCTexture2DPixelFormat oldPixelFormat = CCTexture2D::defaultAlphaPixelFormat();
                    //重设默认带ALPHA通道的像素格式。
CCTexture2D::setDefaultAlphaPixelFormat(vt->m_PixelFormat);

                    //纹理重新由PVR文件进行初始化。会用到新的默认带ALPHA通道的像素格式。
vt->texture->initWithPVRFile(vt->m_strFileName.c_str());
                    //重设原来的默认带ALPHA通道的像素格式。
CCTexture2D::setDefaultAlphaPixelFormat(oldPixelFormat);
                } 
                else 
                {
                      //如果是非PVR文件。
                    unsigned long nSize = 0;
                      //通过文件工具集中的接口读入图片文件并返回数据地址。
                    unsigned char* pBuffer = CCFileUtils::sharedFileUtils()->getFileData(vt->m_strFileName.c_str(), "rb", &nSize);
                       //使用数据地址对前面定义的CCImage对象image进行初始化。
                    if (image.initWithImageData((void*)pBuffer, nSize, vt->m_FmtImage))
                    {
                           //取得原来的默认带ALPHA通道的像素格式。
                        CCTexture2DPixelFormat oldPixelFormat = CCTexture2D::defaultAlphaPixelFormat();
                        //重设默认带ALPHA通道的像素格式。CCTexture2D::setDefaultAlphaPixelFormat(vt->m_PixelFormat);
                          //纹理重新由图片对象初始化。会用到新的默认带ALPHA通道的像素格式。

                        vt->texture->initWithImage(&image);
                        //重设原来的默认带ALPHA通道的像素格式。
CCTexture2D::setDefaultAlphaPixelFormat(oldPixelFormat);
                    }

                    CC_SAFE_DELETE_ARRAY(pBuffer);
                }
            }
            break;
        case kImageData:
            {
                  //纹理重新由图片数据初始化。
                vt->texture->initWithData(vt->m_pTextureData, 
                                          vt->m_PixelFormat, 
                                          vt->m_TextureSize.width, 
                                          vt->m_TextureSize.height, 
                                          vt->m_TextureSize);
            }
            break;
        case kString:
            {
                  //纹理重新由字符串初始化。
                vt->texture->initWithString(vt->m_strText.c_str(),
                    vt->m_size,
                    vt->m_alignment,
                    vt->m_vAlignment,
                    vt->m_strFontName.c_str(),
                    vt->m_fFontSize);
            }
            break;
        case kImage:
            {
                  //纹理重新由图片对象初始化。
                vt->texture->initWithImage(vt->uiImage);
            }
            break;
        default:
            break;
        }
    }
    //设置重新载入完成
    isReloading = false;
}

#endif // CC_ENABLE_CACHE_TEXTURE_DATA

NS_CC_END









local Player = class("Player", function ()
    return display.newSprite("icon.png")
end)

function Player:ctor()
    self:addStateMachine()
end

function Player:doEvent(event)
    self.fsm:doEvent(event)
end

function Player:addStateMachine()
    self.fsm = {}
    cc.GameObject.extend(self.fsm):addComponent("components.behavior.StateMachine"):exportMethods()

    self.fsm:setupState({
        initial = "idle",

        events = {
            {name = "move", from = {"idle", "jump"}, to = "walk"},
            {name = "attack", from = {"idle", "walk"}, to = "jump"},
            {name = "normal", from = {"walk", "jump"}, to = "idle"},
        },

        callbacks = {
            onenteridle = function ()
                local scale = CCScaleBy:create(0.2, 1.2)
                self:runAction(CCRepeat:create(transition.sequence({scale, scale:reverse()}), 2))
            end,

            onenterwalk = function ()
                local move = CCMoveBy:create(0.2, ccp(100, 0))
                self:runAction(CCRepeat:create(transition.sequence({move, move:reverse()}), 2))
            end,

            onenterjump = function ()
                local jump = CCJumpBy:create(0.5, ccp(0, 0), 100, 2)
                self:runAction(jump)
            end,
        },
    })
end

return Player




local Player = import("..views.Player")

local MyScene = class("MyScene", function ()
    return display.newScene("MyScene")
end)

function MyScene:ctor() 
  
    local player = Player.new()
    player:setPosition(display.cx, display.cy)
    self:addChild(player)

    local function menuCallback(tag)
        if tag == 1 then 
            player:doEvent("normal")
        elseif tag == 2 then
            player:doEvent("move")
        elseif tag == 3 then
            player:doEvent("attack")
        end
    end

    local mormalItem = ui.newTTFLabelMenuItem({text = "normal", x = display.width*0.3, y = display.height*0.2, listener = menuCallback, tag = 1})
    local moveItem =  ui.newTTFLabelMenuItem({text = "move", x = display.width*0.5, y = display.height*0.2, listener = menuCallback, tag = 2})
    local attackItem =  ui.newTTFLabelMenuItem({text = "attack", x = display.width*0.7, y = display.height*0.2, listener = menuCallback, tag = 3})
    local menu = ui.newMenu({mormalItem, moveItem, attackItem})
    self:addChild(menu)
      
end

return MyScene




