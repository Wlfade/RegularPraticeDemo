//
//  KKDyDetailTitleItem.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/31.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDyDetailTitleItem.h"
#import "KKReMakeDictionary.h"

@implementation KKDyDetailTitleItem
- (void)mj_keyValuesDidFinishConvertingToObject{
    self.titleHeight = 0;
    if (self.title) {
        NSDictionary *titleAttdict = [KKReMakeDictionary getHtmlAttributedStringAndHeightWithString:self.title withTextFont:[UIFont boldSystemFontOfSize:17] withTextColor:RGB(51, 51, 51) withMaxWith:SCREEN_WIDTH - 20 withMaxHeight:CGFLOAT_MAX wihthImageFont:16];
        self.outAttTitle = [titleAttdict objectForKey:@"html"];
        NSNumber *titleHeight = titleAttdict[@"height"];
        
//        self.titleHeight = titleHeight.floatValue;
        self.titleHeight = titleHeight.floatValue + 10;

    }
}
@end
