//
//  KKGroupMember.m
//  kk_buluo
//
//  Created by new on 2019/3/20.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKGroupMember.h"

@implementation KKGroupMember
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{ @"ID" : @"id" };
}
- (BOOL)isEqualToModel:(KKGroupMember *)model {
    if (!model) {
        return NO;
    }
    BOOL isEqual = [self.userId isEqualToString:model.userId];
    return isEqual;
}
- (void)mj_keyValuesDidFinishConvertingToObject{
    self.isExist = NO;
}
@end
