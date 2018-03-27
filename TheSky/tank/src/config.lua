-- 全局表
-- 注册一个全局的APP表, 存储所有对象
qy = {
    -- debug模式
    DEBUG = true,
    -- 服务器信息配置
    SERVER_SCHEME = "http",
    SERVER_PORT = "80",
    SERVER_DOMAIN = "tank.test.9173.com",
    SERVER_PATH = "vms/index.php?mod=api&config=dev&platform=dev",
    SERVER_VERSION = "develop",

    -- 天天测试服
    -- SERVER_DOMAIN = "tank.9173.com",
    -- SERVER_PATH = "/vms/index.php?mod=api",
    -- SERVER_VERSION = "2822",

    -- 耿少萌 测试服
    -- SERVER_DOMAIN = "tank.test.9173.com",
    -- SERVER_PATH = "vms/index.php?mod=api&ver=1.0.1&config=dev&platform=dev",

    -- SERVER_DOMAIN = "tank.9173.com",
    -- SERVER_PATH = "/vms/index.php?mod=api",

    -- SERVER_DOMAIN = "192.168.31.171",
    -- SERVER_PATH = "/index.php?mod=api&ver=tank&config=dev&platform=dev",
    -- 动态存储注册的包路径，类名
    product = "local",  -- 产品类型：release, test, develop, local, appstore,sina,oversea,oversea-test,zhangxin pioneer测试服 
    tank = {},
    is_package = 0,
    has_module = 0,
    language = "cn",  -- 语言： cn,en,tw,jp
}

-- 热更新，开发模式下热更新关闭
QY_IS_USE_UPDATE = false

DEBUG = 2

cc.FileUtils:getInstance():addSearchPath("modules")