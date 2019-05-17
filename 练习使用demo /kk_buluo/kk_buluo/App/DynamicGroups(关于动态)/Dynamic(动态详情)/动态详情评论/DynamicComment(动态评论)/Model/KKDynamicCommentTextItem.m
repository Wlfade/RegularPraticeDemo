//
//  KKDynamicCommentTextItem.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/19.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDynamicCommentTextItem.h"
#import "KKReMakeDictionary.h"
@implementation KKDynamicCommentTextItem
- (void)mj_keyValuesDidFinishConvertingToObject{    
    NSDictionary *attdict = [KKReMakeDictionary getHtmlAttributedStringAndHeightWithString:self.comSummary withTextFont:[UIFont systemFontOfSize:16] withTextColor:RGB(51, 51, 51) withMaxWith:SCREEN_WIDTH - 62 withMaxHeight:CGFLOAT_MAX wihthImageFont:16];
    self.outAttComSummary = [attdict objectForKey:@"html"];
    NSNumber *height = attdict[@"height"];
    
    if (_comSummary) {
        self.comSummaryHeight = height.floatValue;
        self.dyComTextHeight = self.comSummaryHeight + 5;
    }else{
        self.comSummaryHeight = 0;
        self.dyComTextHeight = 0;
    }
}
@end
