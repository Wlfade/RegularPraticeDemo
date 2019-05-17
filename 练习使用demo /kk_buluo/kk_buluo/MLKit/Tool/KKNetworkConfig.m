//
//  KKNetworkConfig.m
//  kk_buluo
//
//  Created by david on 2019/3/16.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKNetworkConfig.h"
#import "KKKeyChainStore.h"
#import "LoginKit.h"


#define kOneAuth_id        @"oneAuthId"//与后台约定的
#define kOneAuth_loginKey  @"loginKey" //与后台约定的
#define kOneAuth_loginKey_save  @"oneAuth_loginKey" //用于储存

#define kOneAuth_signKey   @"oneAuth_signKey" //这个没用到 所以后台没定
#define kOneAuth_cryptKey  @"oneAuth_cryptKey"//这个没用到 所以后台没定

#define kUser_id        @"authedUserId"//与后台约定的
#define kUser_loginKey  @"loginKey"//与后台约定的
#define kUser_signKey   @"signKey" //这个没用到 所以后台没定
#define kUser_cryptKey  @"cryptKey"//这个没用到 所以后台没定


@interface KKNetworkConfig ()
//用于清空
@property (nonatomic,strong) NSMutableArray *keyMutArr;
@end

@implementation KKNetworkConfig

static KKNetworkConfig *_netWorkConfig = nil;
static dispatch_once_t onceToken;

#pragma mark - lazy load
-(NSMutableArray *)keyMutArr {
    if (!_keyMutArr) {
        _keyMutArr = [NSMutableArray array];
    }
    return _keyMutArr;
}



#pragma mark - life circle
+(instancetype)shareInstance{
    dispatch_once(&onceToken, ^{
        _netWorkConfig = [[KKNetworkConfig alloc] init];
    });
    return _netWorkConfig;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupSignInfo];
    }
    return self;
}

- (void)removeHttpTaskConfig{
    //1.删除userDefault中的用户信息
    for (NSInteger i=0; i<self.keyMutArr.count; i++) {
        [ccs saveDefaultKey:self.keyMutArr[i] andV:nil];
    }
    
    //2.释放自己
    self.user_id = nil;
    self.user_loginKey = nil;
    self.user_signKey = nil;
    self.user_cryptKey = nil;
    self.oneAuth_id = nil;
    self.oneAuth_loginKey = nil;
    self.oneAuth_signKey = nil;
    self.oneAuth_cryptKey = nil;
    
    //3.释放相关配置
    [LoginKit getInstance].httpTask = nil;
    [KKNetworkConfig removeDefaultNetworkSignAndExtraParams];
}

#pragma mark - 签名
/** 配置 签名信息 */
- (void)setupSignInfo{
    //1.user签名
    self.user_id = [ccs getDefault:kUser_id];
    self.user_loginKey = [ccs getDefault:kUser_loginKey];
    self.user_signKey=[ccs getDefault:kUser_signKey];
    self.user_cryptKey=[ccs getDefault:kUser_cryptKey];
    [self.keyMutArr addObject:kUser_id];
    [self.keyMutArr addObject:kUser_loginKey];
    [self.keyMutArr addObject:kUser_signKey];
    [self.keyMutArr addObject:kUser_cryptKey];
    
    //2.oneAuth签名
    self.oneAuth_id = [ccs getDefault:kOneAuth_id];
    self.oneAuth_loginKey = [ccs getDefault:kOneAuth_loginKey_save];
    self.oneAuth_signKey = [ccs getDefault:kOneAuth_signKey];
    self.oneAuth_cryptKey = [ccs getDefault:kOneAuth_cryptKey];
    [self.keyMutArr addObject:kOneAuth_id];
    [self.keyMutArr addObject:kOneAuth_loginKey_save];
    [self.keyMutArr addObject:kOneAuth_signKey];
    [self.keyMutArr addObject:kOneAuth_cryptKey];
}

/**
 保存用户的平台Info
 @param dic 平台登录信息
 */
-(void)saveOneAuthInfo:(NSDictionary *)dic {
    
    //1.内存保存
    self.oneAuth_id = dic[kNetConfig_id];
    self.oneAuth_loginKey = dic[kNetConfig_loginKey];
    self.oneAuth_signKey  = dic[kNetConfig_signKey];
    self.oneAuth_cryptKey = dic[kNetConfig_cryptKey];
    
    //2.NSUserDefault保存
    [ccs saveDefaultKey:kOneAuth_id andV:self.oneAuth_id];
    [ccs saveDefaultKey:kOneAuth_loginKey_save andV:self.oneAuth_loginKey];
    [ccs saveDefaultKey:kOneAuth_signKey andV:self.oneAuth_signKey];
    [ccs saveDefaultKey:kOneAuth_cryptKey andV:self.oneAuth_cryptKey];
    
    //3.重新配置network
    [KKNetworkConfig configLoginKitNetwork];
}

/**
 保存用户的角色Info
 @param dic 用户角色登录信息
 */
-(void)saveUserInfo:(NSDictionary *)dic {
    
    //1.内存保存
    self.user_id = dic[kNetConfig_id];
    self.user_signKey = dic[kNetConfig_signKey];
    self.user_loginKey = dic[kNetConfig_loginKey];
    self.user_cryptKey = dic[kNetConfig_cryptKey];
    
    //2.NSUserDefault保存
    [ccs saveDefaultKey:kUser_id andV:self.user_id];
    [ccs saveDefaultKey:kUser_signKey andV:self.user_signKey];
    [ccs saveDefaultKey:kUser_loginKey andV:self.user_loginKey];
    [ccs saveDefaultKey:kUser_cryptKey andV:self.user_cryptKey];
    
    //3.重新配置network
    [KKNetworkConfig configDefaultNetwork];
}


#pragma mark - 配置网络

/** 配置网络 */
+(void)configNetWork {
    [self configDefaultNetwork];
    [self configLoginKitNetwork];
}

/** 获取 当前请求地址 */
+(NSURL *)currentUrl {
    NSString *urlStr = [NSString stringWithFormat:@"%@/client/service.json?",[KKNetworkConfig shareInstance].domainStr];
    return [NSURL URLWithString:urlStr];
}

#pragma mark - 请求配置
/** 配置 默认网络 */
+(void)configDefaultNetwork {
    //1.设置请求头
    NSDictionary *headersDic = [KKNetworkConfig getHttpHeadersDic];
    [[CC_HttpTask getInstance] setRequestHTTPHeaderFieldDic:headersDic];
    
    //2.签名 额外参数
    //2.1 签名
    [[CC_HttpTask getInstance] setSignKeyStr:[KKNetworkConfig shareInstance].user_signKey];
    //2.2额外参数
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc]init];
    [mutDic safeSetObject:[KKNetworkConfig shareInstance].user_id forKey:kUser_id];
    [mutDic safeSetObject:[KKNetworkConfig shareInstance].user_loginKey forKey:kUser_loginKey];
    [[CC_HttpTask getInstance] setExtreDic:mutDic];
    
    //3.通知
    [KKNetworkConfig addNotificationToHttpTask:[CC_HttpTask getInstance]];

    //4.连接融云服务器
    [[KKRCloudMgr shareInstance] rcDisconnect:NO];
    [[KKRCloudMgr shareInstance] rcConnectService];
}

+(void)removeDefaultNetworkSignAndExtraParams {
    //1.签名
    [[CC_HttpTask getInstance] setSignKeyStr:nil];
    //2.额外参数
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc]init];
    [[CC_HttpTask getInstance] setExtreDic:mutDic];
}

/** 配置 登录网络 */
+(void)configLoginKitNetwork {
    CC_HttpTask *httpTask = [[CC_HttpTask alloc]init];
    
    //1.设置请求头
    NSDictionary *headersDic = [KKNetworkConfig getHttpHeadersDic];
    [httpTask setRequestHTTPHeaderFieldDic:headersDic];
    
    //2.签名 额外参数
    //2.1 签名
    [httpTask setSignKeyStr:[KKNetworkConfig shareInstance].oneAuth_signKey];
    //2.2额外参数
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc]initWithDictionary:[CC_HttpTask getInstance].extreDic];
    [mutDic safeSetObject:[KKNetworkConfig shareInstance].oneAuth_id forKey:kOneAuth_id];
    [mutDic safeSetObject:[KKNetworkConfig shareInstance].oneAuth_loginKey forKey:kOneAuth_loginKey];
    [httpTask setExtreDic:mutDic];
    
    //3.通知
    [KKNetworkConfig addNotificationToHttpTask:httpTask];
    
    //4.配置
    
    NSString *urlStr = [NSString stringWithFormat:@"http://mapi.platform.kkbuluo.net/client/service.json?"];
//    NSString *urlStr = [NSString stringWithFormat:@"%@/client/service.json?",[KKNetworkConfig shareInstance].domainStr ];
    [LoginKit configWithHttpTask:httpTask url:Url(urlStr)];
}





#pragma mark tool
/** http请求的heads */
+(NSDictionary *)getHttpHeadersDic {
    //1.创建
    NSMutableDictionary *headers = [[NSMutableDictionary alloc]init];
    
    //2.添加
    //appCode
    NSArray* array = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"] componentsSeparatedByString:@"."];
    NSString *subDomainStr = array.lastObject;
    [headers setObject:subDomainStr forKey:@"appCode"];
    //appName
    [headers setObject:[KKNetworkConfig appName] forKey:@"appName"];
    //bundleId
    [headers setObject:CurrentAppBundleId forKey:@"appBundleId"];
    //appVersion
    [headers setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forKey:@"appVersion"];
    //appUserAgent
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    float screenH = [UIScreen mainScreen].bounds.size.height;
    [headers setObject:[NSString stringWithFormat:@"IOS_VERSION%fSCREEN_HEIGHT%d",version,(int)screenH] forKey:@"appUserAgent"];
    //appDeviceId
    [headers setObject:[KKNetworkConfig getKeyChainUuid] forKey:@"appDeviceId"];
    
    //3.return
    return headers;
}

+(void)addNotificationToHttpTask:(CC_HttpTask *)httpTask {
    
    //1.通知 需要签名
    [httpTask addResponseLogic:@"SIGN_REQUIRED" logicStr:@"response,error,name=SIGN_REQUIRED" stop:0 popOnce:1 logicBlock:^(ResModel *result, void (^finishCallbackBlock)(NSString *error, ResModel *result)) {
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PRESENT_LOGINVC_SIGN_REQUIRED object:nil];
    }];
    //2.通知 异地登录
    [httpTask addResponseLogic:@"LOGIN_ELSEWHERE" logicStr:@"response,error,name=LOGIN_ELSEWHERE" stop:1 popOnce:1 logicBlock:^(ResModel *result, void (^finishCallbackBlock)(NSString *error, ResModel *result)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PRESENT_LOGINVC_LOGIN_ELSE object:nil];
    }];
}

#pragma mark - tool
/**
 @return app的名字
 */
+(NSString *)appName {
    return @"kkbuluo-iphone";
}

/** 储存于KeyChain中,用于表示设备 */
+ (NSString *)getKeyChainUuid {
    
    //@"com.hhslive.app.usernamepassword"
    //@"com.hhslive.app.username"
    //@"com.hhslive.app.password"
    
    //1.尝试获取
    NSString *uuidKey = @"com.hhslive.app.usernamepassword";
    NSString *uuidStr = (NSString*)[KKKeyChainStore load:uuidKey];
    
    //2.为空则创建
    //首次执行该方法时，uuid为空
    if([uuidStr isEqualToString:@""]|| !uuidStr) {
        //生成一个uuid的方法
        uuidStr = [NSUUID UUID].UUIDString;
        //将该uuid保存到keychain
        [KKKeyChainStore save:uuidKey data:uuidStr];
        
    }
    
    //3.return
    return uuidStr;
}

@end
