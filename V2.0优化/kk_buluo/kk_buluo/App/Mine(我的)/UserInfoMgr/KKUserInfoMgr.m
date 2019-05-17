//
//  KKUserInfoMgr.m
//  kk_buluo
//
//  Created by david on 2019/3/17.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKUserInfoMgr.h"
#import "KKLoginVC.h"

//user相关
#define kUserId         @"userId"

@interface KKUserInfoMgr()

//用于清空
@property (nonatomic,strong) NSMutableArray *keyMutArr;

@end


@implementation KKUserInfoMgr

static KKUserInfoMgr *userInfoMgr = nil;
static dispatch_once_t onceToken;

#pragma mark - lazy load
-(NSMutableArray *)keyMutArr {
    if (!_keyMutArr) {
        _keyMutArr = [NSMutableArray array];
    }
    return _keyMutArr;
}


#pragma mark - life circle
+ (instancetype)shareInstance {
    dispatch_once(&onceToken, ^{
        userInfoMgr = [[KKUserInfoMgr alloc] init];
    });
    return userInfoMgr;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupInfo];
    }
    return self;
}

/** 清空 */
- (void)remove{
    //1.删除userDefault中的用户信息
    for (NSInteger i=0; i<self.keyMutArr.count; i++) {
        [ccs saveDefaultKey:self.keyMutArr[i] andV:nil];
    }
    
    //2.释放self
    userInfoMgr = nil;
    onceToken = 0;
}


#pragma mark - 用户信息
- (void)setupInfo{
    //1.user相关
    self.userId = [ccs getDefault:kUserId];
    [self.keyMutArr addObject:kUserId];
}

/** request获取用户信息 */
-(void)requestUserInfo:(void(^)(void))finish {
    //1.参数
    NSMutableDictionary *para = [[NSMutableDictionary alloc] init];
    [para setObject:@"MY_USER_INFO_QUERY" forKey:@"service"];
    
    //2.请求
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:para model:nil finishCallbackBlock:^(NSString *error, ResModel *resmodel) {
        if (error) {
            [CC_NoticeView showError:error];
        }else{
            NSDictionary *responseDic = resmodel.resultDic[@"response"];
            
            NSMutableDictionary *clientDic = [NSMutableDictionary dictionaryWithDictionary:responseDic[@"userInfoClient"]];
            [clientDic safeSetObject:responseDic[@"userMemo"] forKey:@"userMemo"];
            [clientDic safeSetObject:responseDic[@"userLogoUrl"] forKey:@"userLogoUrl"];
            [clientDic safeSetObject:responseDic[@"location"] forKey:@"location"];
            [clientDic safeSetObject:responseDic[@"validateIdentity"] forKey:@"validateIdentity"];
            [clientDic safeSetObject:responseDic[@"userLogoUrl"] forKey:@"userLogoUrl"];
            //model
            [KKUserInfoMgr shareInstance].userInfoModel = [KKUserInfoModel mj_objectWithKeyValues:clientDic];
            //userId
            [KKUserInfoMgr shareInstance].userId = clientDic[@"userId"];
        }
        
        if (finish) {
            finish();
        }
    }];
}


#pragma mark- login
+ (BOOL)isLogin{
    if ([KKUserInfoMgr shareInstance].userId.length > 0) {
        return YES;
    }
    return NO;
}


- (void)logoutAndSetNil:(void(^)(void))finish{
    
    //1.释放self单例
    [self remove];
    
    //2.释放网络配置
    [[KKNetworkConfig shareInstance] removeHttpTaskConfig];
    
    //3.释放融云
    [[KKRCloudMgr shareInstance] remove];
    
    //4.跳转登录VC
    [self presentLoginVC];
    
    //5.执行block
    if (finish) {
        finish();
    }
    
}


/** preset跳转logoinVC */
- (void)presentLoginVC{
    //1.过滤
    if ([KKUserInfoMgr shareInstance].userId.length > 0) {
        return;
    }
    
    //2.跳转loginVC
    KKLoginVC *loginVC = [[KKLoginVC alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    nav.navigationBarHidden = YES;
    [[CC_CodeLib getRootNav]presentViewController:nav animated:YES completion:nil];
}


#pragma mark - setter
-(void)setUserId:(NSString *)userId {
    _userId = userId;
    [ccs saveDefaultKey:kUserId andV:userId];
}



@end
