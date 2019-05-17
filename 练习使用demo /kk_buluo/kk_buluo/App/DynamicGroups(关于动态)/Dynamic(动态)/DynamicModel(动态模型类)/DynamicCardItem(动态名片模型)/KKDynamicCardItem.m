//
//  KKDynamicCardItem.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/17.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDynamicCardItem.h"
#import "KKReMakeDictionary.h"

@implementation KKDynamicCardItem

- (void)mj_keyValuesDidFinishConvertingToObject{
    
    
    if (self.deleted == YES) {
        self.dyCardHeight = 40;
    }else{
        self.dyCardHeight = 60;
    }
    //设置默认图片
    self.placeHoldImage = [UIImage imageNamed:@"default_trasmit_icon"];
    
//    if (self.title) {
//        NSDictionary *attdict = [KKReMakeDictionary getHtmlAttributedStringAndHeightWithString:self.title withTextFont:[UIFont systemFontOfSize:14] withTextColor:RGB(51, 51, 51) withMaxWith:SCREEN_WIDTH - 20 withMaxHeight:CGFLOAT_MAX wihthImageFont:16];
//        //设置文本内容
//        self.outAttTitle = [attdict objectForKey:@"html"];
//    }
    NSString *nameStr = [NSString stringWithFormat:@"@%@",self.commonObjectName ? self.commonObjectName : @""];
    
    NSDictionary *titleAttdict = [KKReMakeDictionary getHtmlAttributedStringAndHeightWithString:nameStr withTextFont:[UIFont systemFontOfSize:13] withTextColor:RGB(51, 51, 51) withMaxWith:SCREEN_WIDTH - 20 withMaxHeight:CGFLOAT_MAX wihthImageFont:14 withLineSpaceing:0];
    
    self.outAttTitle = [titleAttdict objectForKey:@"html"];

    NSNumber *titleHeight = [titleAttdict objectForKey:@"height"];
    self.titleHeight = titleHeight.floatValue;
    
    NSString *content = nil;
    if (self.title) {
        content = self.title;
    }else{
        content = self.summary;
    }
    
    
    NSDictionary *attdict = [KKReMakeDictionary getHtmlAttributedStringAndHeightWithString:content withTextFont:[UIFont systemFontOfSize:13] withTextColor:RGB(153, 153, 153) withMaxWith:SCREEN_WIDTH - 20 - 70 withMaxHeight:CGFLOAT_MAX wihthImageFont:14 withLineSpaceing:0];
    //设置文本内容
    self.outAttSummary = [attdict objectForKey:@"html"];
    
    NSNumber *summaryHeight = [attdict objectForKey:@"height"];
    self.summaryHeight = summaryHeight.floatValue;
    
////    [NSString stringWithFormat:@"%@%@%
//    NSMutableString *str = []
//    self.showAttContent = self.outAttTitle appendAttributedString:[NSMutableString all]
    
    
    if (self.summaryHeight > 30) {
        self.summaryHeight = 35;
    }

    if (self.properties) {
        if ([[_properties allKeys]containsObject:@"smallImageList"]) {
            NSArray *smallImageList = [NSArray arrayWithArray:_properties[@"smallImageList"]];
            NSDictionary *firstUrl = [smallImageList objectAtIndex:0];
            NSString *firstUrlStr = firstUrl[@"url"];
            //弄一个方法获取第一张图片
            self.firstUrlStr = firstUrlStr;
        }
    }
    self.topGapH = ceilf((self.dyCardHeight - (self.titleHeight + self.summaryHeight))/2);
}


@end
