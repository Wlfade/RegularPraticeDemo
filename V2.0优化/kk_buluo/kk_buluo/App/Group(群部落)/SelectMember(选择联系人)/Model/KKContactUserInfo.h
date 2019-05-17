//
//  KKContactUserInfo.h
//  kk_buluo
//
//  Created by new on 2019/3/17.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 {
 "userLogoUrl" : "http:\/\/mapi1.kknew.net\/userLogoUrl-dXNlcklkPTEwOTg0MDAzNjk0NTM4Nzk2OTAwMjkwOTcwMDI1NzM0Jm10PU1vbitGZWIrMjUrMTQlM0EzNiUzQTI3K0NTVCsyMDE5-r.htm",
 "userId" : "10984003694538796900290970025734",
 "loginName" : "耳朵"
 },
 */
NS_ASSUME_NONNULL_BEGIN

@interface KKContactUserInfo : NSObject
@property(nonatomic, copy) NSString *userLogoUrl;
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *loginName;

@end

NS_ASSUME_NONNULL_END
