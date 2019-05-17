//
//  KKPersonalPageModel.m
//  kk_buluo
//
//  Created by 樊星 on 2019/3/25.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKPersonalPageModel.h"

@implementation KKPersonalPageModel
-(void)mj_keyValuesDidFinishConvertingToObject{
    NSLog(@"%@",self.myGroups);
}

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"myGroups":[KKPersonalPageGroupModel class]
             };
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"myGroups": @[@"guildGroups",@"myGroups"]};
}
@end



@implementation KKPersonalPageGroupModel
@end
