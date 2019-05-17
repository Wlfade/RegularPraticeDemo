//
//  KKRemakeCountTool.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/31.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKRemakeCountTool.h"

@implementation KKRemakeCountTool
+ (NSString *)remakeCountFromeCount:(NSInteger)count{
    NSString *countString = nil;
    if(count >= 10000) {
        float f = count/10000.0;
        countString = [NSString stringWithFormat:@"%.2fW",floor(f*100)/100];
    }else if(count > 1000) {
        float f = count/1000.0;
        countString = [NSString stringWithFormat:@"%.2fK",floor(f*100)/100];
    }else{
        float f = count;
        countString = [NSString stringWithFormat:@"%.f",floor(f)];
    }
    return countString;
}
@end
