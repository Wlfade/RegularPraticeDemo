//
//  KKRecommend.h
//  kk_buluo
//
//  Created by new on 2019/3/20.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKMyObjectType : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *message;

@end

typedef NS_ENUM(NSUInteger, isShowTextType) {
    commonObjectMemoType,
    commonObjectCertType,
    cellType,
};


@interface KKMyRecommend : NSObject



@property (nonatomic, copy) NSString *cell;
@property (nonatomic, copy) NSString *gmtInvite;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *userLogoUrl;
//@property (nonatomic, copy) NSString *commonObjectId;
//@property (nonatomic, copy) NSString *commonObjectName;
//@property (nonatomic, copy) NSString *commonObjectLogoUrl;
@property (nonatomic, copy) NSString *commonObjectCert;
@property (nonatomic, copy) NSString *commonObjectMemo;
@property (nonatomic, copy) NSString *fans;
@property (nonatomic, assign) BOOL focus;
@property (nonatomic, strong) KKMyObjectType *objectType;
@property (nonatomic, assign) BOOL isHasFocus;
/// guildId
@property (nonatomic, copy) NSString *guildId;
@property (nonatomic, assign) isShowTextType type;

@end

NS_ASSUME_NONNULL_END
