//
//  KKChatDbMgr.h
//  kk_buluo
//
//  Created by david on 2019/3/29.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKChatDbModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKChatDbMgr : NSObject

+ (instancetype)shareInstance;

-(void)saveUserInfo:(KKChatDbModel *)model;
-(KKChatDbModel *)getDbUserInfo:(NSString *)idStr;
-(void)removeUserInfo:(NSString *)idStr;


-(void)saveGroupInfo:(KKChatDbModel *)model;
-(KKChatDbModel *)getDbGroupInfo:(NSString *)idStr;
-(void)removeGroupInfo:(NSString *)idStr;

/** 清空所有表的数据 (表还在) */
-(void)clearAllTableData;

@end

NS_ASSUME_NONNULL_END
