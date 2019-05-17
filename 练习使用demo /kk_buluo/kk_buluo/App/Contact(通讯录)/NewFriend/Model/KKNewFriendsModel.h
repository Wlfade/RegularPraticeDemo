//
//  KKNewFriendsModel.h
//  kk_buluo
//
//  Created by new on 2019/3/19.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKStatusModel : NSObject

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *message;

@end

@interface KKNewFriendsModel : NSObject
/*
 {
 "status" : {
 "name" : "APPLYING",
 "message" : "申请中"
 },
 "userLogoUrl" : "http:\/\/mapi1.kknew.net\/userLogoUrl-dXNlcklkPTEwOTg0MDAzNzI4MTk5OTUxODAwMjkwOTcwMDI2Njc0Jm10PUZyaStNYXIrMDErMTIlM0EwNiUzQTM4K0NTVCsyMDE5-r.htm",
 "gmtApply" : "2019-03-14 17:47:43",
 "userId" : "10984003728199951800290970026674",
 "loginName" : "kk6竞彩7二",
 "validateMessage" : "测试"
 }
 */
@property (nonatomic, copy) NSString *userLogoUrl;
@property (nonatomic, copy) NSString *gmtApply;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *validateMessage;
@property (nonatomic, strong) KKStatusModel *status;

@end

NS_ASSUME_NONNULL_END
