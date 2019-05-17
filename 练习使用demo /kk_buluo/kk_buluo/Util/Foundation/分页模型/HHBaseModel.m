//
//  HHBaseModel.m
//  HHSLive
//
//  Created by 郦道元  on 2017/7/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "HHBaseModel.h"

@implementation HHBaseModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"nowDate":@"response.nowDate"};
}

-(void)didFinishConvertToModel
{
    
}

@end
