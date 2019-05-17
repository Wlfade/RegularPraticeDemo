//
//  KKDynamicHeadItem.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/17.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDynamicHeadItem.h"
#import "CC_Time.h"

@implementation KKDynamicHeadItem

- (void)setNowDate:(NSString *)nowDate{
    _nowDate = nowDate;
    
    NSString *timeString = [CC_Time getTimeStringWithNowDate:_nowDate OldDate:self.gmtCreate];
    if (![HHObjectCheck isEmpty:self.commonObjectCert]) {
        self.showDate = [NSString stringWithFormat:@"%@.%@",timeString,self.commonObjectCert];
    }else{
        self.showDate = timeString;
    }
    
}

- (void)mj_keyValuesDidFinishConvertingToObject{
    self.dynamicHeadHeight = 60;
    
    if (self.commonObjectType) {
        self.commonObjectTypeName = self.commonObjectType[@"name"];
    }
    //判断是否为自己 如果是 则 相当于关注了
    if ([self.userId isEqualToString:[KKUserInfoMgr shareInstance].userId]) {
        self.focus = YES;
    }
}
@end
