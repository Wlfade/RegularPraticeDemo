//
//  KKDynamicCommentReplyItem.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/19.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDynamicCommentReplyItem.h"

#import "KKReMakeDictionary.h"

@implementation KKDynamicCommentReplyItem

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"replyUserId":@"commentReplyId",
             @"replyUserLogoUrl":@"commonObjectLogoUrl",
             @"replyUserName":@"commonObjectName",
             };
}
- (void)mj_keyValuesDidFinishConvertingToObject{
    _replyUserName = [NSString stringWithFormat:@"%@:",self.replyUserName];
    
    CGFloat mixH = 20;
    
    CGSize textSize = CGSizeMake(SCREEN_WIDTH, MAXFLOAT);
    NSDictionary *contextArr = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    
    CGFloat nameWidth = [_replyUserName boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:contextArr context:nil].size.width;
    
//    CGFloat contentWidth = SCREEN_WIDTH - 62 - nameWidth ;
    //62 是 减去头像 间隔 宽度 后的距离 在加10 是 用来处理内部的间隔
    CGFloat contentWidth = SCREEN_WIDTH - 72 - nameWidth ;

    
    NSDictionary *attdict = [KKReMakeDictionary getHtmlAttributedStringAndHeightWithString:self.content withTextFont:[UIFont systemFontOfSize:13] withTextColor:RGB(51, 51, 51) withMaxWith:contentWidth withMaxHeight:CGFLOAT_MAX wihthImageFont:13];
    self.mutContent = [attdict objectForKey:@"html"];
    
    NSNumber *height = attdict[@"height"];
    
    
//
    if (height.floatValue < mixH) {
        self.dyReplyHeight = mixH;
    }else{
        //加10高度是为了处理Y上面的间隔
       self.dyReplyHeight = height.floatValue + 10;
    }
}
@end
