//
//  KKDynamicCommentTextItem.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/19.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDynamicCommentTextItem.h"
#import "KKReMakeDictionary.h"


@interface KKDynamicCommentTextItem ()

- (CGFloat)maxTextHeight;

@end

static CGFloat const defineMaxTextH = CGFLOAT_MAX;

@implementation KKDynamicCommentTextItem

- (CGFloat)maxTextHeight{
    if ([self.delegate respondsToSelector:@selector(KKDynamicCommentTextItemMaxTextH:)]) {
        [self.delegate KKDynamicCommentTextItemMaxTextH:self];
    }else{
        return defineMaxTextH;
    }
    return 100;
}

- (void)mj_keyValuesDidFinishConvertingToObject{    

    
    NSDictionary *attdict = [KKReMakeDictionary getHtmlAttributedStringAndHeightWithString:self.comSummary withTextFont:[UIFont systemFontOfSize:16] withTextColor:RGB(51, 51, 51) withMaxWith:SCREEN_WIDTH - 62 withMaxHeight:CGFLOAT_MAX wihthImageFont:16];

    self.outAttComSummary = [attdict objectForKey:@"html"];
    NSNumber *height = attdict[@"height"];
    
    if (_comSummary) {
        self.comSummaryHeight = height.floatValue + 5;
        self.dyComTextHeight = self.comSummaryHeight + 5;
    }else{
        self.comSummaryHeight = 0;
        self.dyComTextHeight = 0;
    }
}
+ (instancetype)KKDynamicCommentTextItemInitWithDictionary:(NSDictionary *)dictioanry withDelegate:( id <KKDynamicCommentTextItemDelegate>)delegate{
    KKDynamicCommentTextItem *textItem = [[KKDynamicCommentTextItem alloc]init];
    textItem.delegate = delegate;
    
    
    NSDictionary *attdict = [KKReMakeDictionary getHtmlAttributedStringAndHeightWithString:dictioanry[@"comSummary"] withTextFont:[UIFont systemFontOfSize:16] withTextColor:RGB(51, 51, 51) withMaxWith:SCREEN_WIDTH - 62 withMaxHeight:textItem.maxTextHeight wihthImageFont:16];
    
    textItem.comSummary = dictioanry[@"comSummary"];
    textItem.outAttComSummary = [attdict objectForKey:@"html"];
    NSNumber *height = attdict[@"height"];
    
    if (textItem.comSummary) {
        textItem.comSummaryHeight = height.floatValue + 5;
        textItem.dyComTextHeight = textItem.comSummaryHeight + 5;
    }else{
        textItem.comSummaryHeight = 0;
        textItem.dyComTextHeight = 0;
    }
    return textItem;
    
}

@end
