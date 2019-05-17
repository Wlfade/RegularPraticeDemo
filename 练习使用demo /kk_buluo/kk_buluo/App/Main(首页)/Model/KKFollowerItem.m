//
//  KKFollowerItem.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/25.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKFollowerItem.h"

@implementation KKFollowerItem
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return@{
        @"commonObjectTypeName":@"commonObjectType.name",
    };
}
@end
