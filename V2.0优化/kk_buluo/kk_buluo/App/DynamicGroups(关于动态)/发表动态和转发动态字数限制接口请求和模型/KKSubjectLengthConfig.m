//
//  KKSubjectLengthConfig.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/31.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKSubjectLengthConfig.h"


@implementation KKSubjectLengthConfig
- (void)mj_keyValuesDidFinishConvertingToObject{
    
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return@{
        @"personal":@"PERSONAL_ARTICLE_SUBJECT_LENGTH_CONFIG",
        @"normal":@"NORMAL_SUBJECT_LENGTH_CONFIG"
    };
}

@end

@implementation ContentLengthItem
- (void)mj_keyValuesDidFinishConvertingToObject{
    
}
@end
