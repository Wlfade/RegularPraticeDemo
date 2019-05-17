//
//  KKContactDealTool.h
//  kk_buluo
//
//  Created by summmerxx on 2019/3/17.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKContactDealTool : NSObject
+ (NSString *)transform:(NSString *)chinese;
+ (NSMutableDictionary *)sortArrayWithPinYin:(NSMutableArray *)list;
+ (NSMutableDictionary *)sortGroupMemberArrayWithPinYin:(NSMutableArray *)list;
@end

NS_ASSUME_NONNULL_END
