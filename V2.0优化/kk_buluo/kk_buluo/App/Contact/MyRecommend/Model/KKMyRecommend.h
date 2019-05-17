//
//  KKRecommend.h
//  kk_buluo
//
//  Created by new on 2019/3/20.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKMyRecommend : NSObject
/*
 {
 "cell" : "13300110022",
 "userId" : "10984003694538796900290970025734",
 "loginName" : "耳朵",
 "userLogoUrl" : "http:\/\/mapi1.kknew.net\/userLogoUrl-dXNlcklkPTEwOTg0MDAzNjk0NTM4Nzk2OTAwMjkwOTcwMDI1NzM0Jm10PU1vbitGZWIrMjUrMTQlM0EzNiUzQTI3K0NTVCsyMDE5-r.htm"
 }
 */
@property (nonatomic, copy) NSString *cell;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *userLogoUrl;

@end

NS_ASSUME_NONNULL_END
