//
//  KKDynamicArticleItem.m
//  kk_buluo
//
//  Created by 单车 on 2019/4/23.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDynamicArticleItem.h"
#import "KKReMakeDictionary.h"
#import "KKRemakeCountTool.h"
#import "CC_Time.h"
@implementation KKDynamicArticleItem
- (void)mj_keyValuesDidFinishConvertingToObject{

    self.dyArticleHeight = 100;
    
    self.titleWidth = SCREEN_WIDTH - 20 - 120 ;
    
    NSDictionary *titleAttdict = [KKReMakeDictionary getHtmlAttributedStringAndHeightWithString:self.title withTextFont:[UIFont boldSystemFontOfSize:15] withTextColor:RGB(51, 51, 51) withMaxWith:self.titleWidth withMaxHeight:CGFLOAT_MAX wihthImageFont:15];
    
    NSNumber *titleHeight = [titleAttdict objectForKey:@"height"];
    CGFloat titleHeightFloat = titleHeight.floatValue + 5;
    if (self.titleMaxHeight) {
        if (titleHeightFloat > self.titleMaxHeight) {
            titleHeightFloat = self.titleMaxHeight;
        }
    }
    self.titleHeight = titleHeightFloat;

    self.outAttTitle = [titleAttdict objectForKey:@"html"];
    
    self.placeHoldImage = [UIImage imageNamed:@"default_Article_icon"];
//    NSNumber *titleHeight = titleAttdict[@"height"];
//    self.titleHeight = titleHeight.floatValue;
    self.accessCountStr = [NSString stringWithFormat:@"%@阅读",[KKRemakeCountTool remakeCountFromeCount:self.accessCount]];
    NSString *timeString = [CC_Time getTimeStringWithNowDate:_nowDate OldDate:self.gmtCreate];
    self.showDate = timeString;
    
    self.fromeStr = [NSString stringWithFormat:@"%@ %@ %@",self.commonObjectName,self.showDate,self.accessCountStr];
}
- (void)setNowDate:(NSString *)nowDate{
    _nowDate = nowDate;
    
    NSString *timeString = [CC_Time getTimeStringWithNowDate:_nowDate OldDate:self.gmtCreate];
    if (![HHObjectCheck isEmpty:self.commonObjectCert]) {
        self.showDate = [NSString stringWithFormat:@"%@.%@",timeString,self.commonObjectCert];
    }else{
        self.showDate = timeString;
    }
}
@end
