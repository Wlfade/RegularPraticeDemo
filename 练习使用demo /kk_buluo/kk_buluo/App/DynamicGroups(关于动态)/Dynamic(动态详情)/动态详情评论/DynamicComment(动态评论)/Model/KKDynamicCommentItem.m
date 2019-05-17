//
//  KKDynamicCommentItem.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/18.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDynamicCommentItem.h"

#import "KKReMakeDictionary.h"

@interface KKDynamicCommentItem ()<KKDynamicCommentTextItemDelegate>

@end

@implementation KKDynamicCommentItem
+ (NSMutableArray *)makeTheDynamicCommentItem:(NSDictionary *)dict{
    
    NSMutableArray *commentMutArr = [NSMutableArray array];
    
    //取出数组 commentList
    NSArray *commentList = [NSArray arrayWithArray:dict[@"commentList"]];
    //是否有回复
    BOOL hasReply = [[dict allKeys]containsObject:@"commentReplyMap"];
    //取出回复的字典
    NSDictionary *replyDic = nil;
    NSArray *replyKeys = nil;
    if (hasReply) {
        replyDic = [NSDictionary dictionaryWithDictionary:dict[@"commentReplyMap"]];
        replyKeys = [NSArray arrayWithArray:[replyDic allKeys]];
    }
    
    for (NSDictionary *dictonary in commentList) {
        NSMutableDictionary *mutDictionary = [NSMutableDictionary dictionaryWithDictionary:dictonary];
//        NSString *commentId = dictonary[@"commentId"];
        NSString *commentId = [NSString stringWithFormat:@"%@",dictonary[@"commentId"]];

        if (hasReply == YES) {
            if ([replyKeys containsObject:commentId]) {
                //取出数组
                NSArray *replyArr = [NSArray arrayWithArray:replyDic[commentId]];
                
                [mutDictionary setObject:replyArr forKey:@"replyList"];
                
            }
        }
        
        KKDynamicCommentItem *commentItem = [KKDynamicCommentItem makeTheCommentItemFromDict:mutDictionary];
        
        [commentMutArr addObject:commentItem];
        NSLog(@"获取的字典:%@",mutDictionary);
    }
    return commentMutArr;
}

+(KKDynamicCommentItem *)makeTheCommentItemFromDict:(NSMutableDictionary *)dictionary{
    KKDynamicCommentItem *commentItem = [[KKDynamicCommentItem alloc]init];
    
    commentItem.commentId = dictionary[@"commentId"];
    
    commentItem.dynamicHeadItem = [commentItem dynamicHeadDic:dictionary];
    
    commentItem.dynamicComTextItem = [commentItem dynamicComTextDic:dictionary];
    
    commentItem.isImages = NO;
    commentItem.dyImageHeight = 0;
    if ([[dictionary allKeys]containsObject:@"properties"]) {
        NSDictionary *properties = dictionary[@"properties"];
        if ([[properties allKeys]containsObject:@"smallImageList"]) {
            commentItem.isImages = YES;
            commentItem.dynamicImageitem = [commentItem dynamicImagesDic:dictionary[@"properties"]];
            commentItem.dyImageHeight = commentItem.dynamicImageitem.dynamicImageHeight;
        }
    }
    
    commentItem.hasReply = NO;
    if ([[dictionary allKeys]containsObject:@"replyList"]) {
        commentItem.replyCount = dictionary[@"replyCount"];
        commentItem.hasReply = YES;
        [commentItem dynamicReplyArr:[NSArray arrayWithArray:dictionary[@"replyList"]]];
    }
    
    return commentItem;
}

/* 取出需要的动态的头部数据组成新字典转出数据模型 */
- (KKDynamicHeadItem *)dynamicHeadDic:(NSMutableDictionary *)topicObject{
    NSArray *orignalkeys = @[@"commonObjectCert",@"commonObjectType",@"commentId",@"commonObjectId",@"commonObjectLogoUrl",@"commonObjectName",@"gmtCreate",@"liked",@"likeCount"];
    NSArray *transkeys = @[@"commonObjectCert",@"commonObjectType",@"commentId",@"userId",@"userLogoUrl",@"userName",@"gmtCreate",@"liked",@"likeCount"];
    NSDictionary *itemDict = [KKReMakeDictionary makeTheDictWithOriginalKeys:orignalkeys withTransMakeKeys:transkeys fromTheOriginalDictonary:topicObject];
    
    KKDynamicHeadItem *dynamicHeadItem = [KKDynamicHeadItem mj_objectWithKeyValues:itemDict];
    
    return dynamicHeadItem;
}
/* 取出需要的动态的文本数据组成新字典转出模型 */
- (KKDynamicCommentTextItem *)dynamicComTextDic:(NSMutableDictionary *)topicObject{
    NSArray *orignalkeys = @[@"summary"];
    NSArray *transkeys = @[@"comSummary"];
    
    NSDictionary *itemDict = [KKReMakeDictionary makeTheDictWithOriginalKeys:orignalkeys withTransMakeKeys:transkeys fromTheOriginalDictonary:topicObject];

//    KKDynamicCommentTextItem *dynamicTextItem = [KKDynamicCommentTextItem mj_objectWithKeyValues:itemDict];
    
    KKDynamicCommentTextItem *dynamicTextItem = [KKDynamicCommentTextItem KKDynamicCommentTextItemInitWithDictionary:itemDict withDelegate:self];

    
    return dynamicTextItem;
}
- (CGFloat)KKDynamicCommentTextItemMaxTextH:(KKDynamicCommentTextItem *)item{
    return 90;
}
- (KKDyCommentImageItem *)dynamicImagesDic:(NSDictionary *)properties{
    NSArray *keys = @[@"smallImageList",@"middleImageList",@"originalImageList",@"largerImageList",];
    NSDictionary *itemDict = [KKReMakeDictionary makeTheDictWithKeys:keys fromTheOriginalDictonary:properties];
    
    KKDyCommentImageItem *dynamicImageItem = [KKDyCommentImageItem mj_objectWithKeyValues:itemDict];
    
    return dynamicImageItem;
}
//回复的数据
- (void)dynamicReplyArr:(NSArray *)replyList{
    NSMutableArray *replyArr = [NSMutableArray array];
    CGFloat replyViewH = 5;
    
    NSInteger repCount = [self.replyCount integerValue];
    BOOL isOverCount = NO;
//    if (repCount >= 3) {
//        isOverCount = YES;
//        repCount = 3;
//    }
    if (repCount > 3) {
        isOverCount = YES;
    }
    
    for (NSInteger i = 0; i < replyList.count; i ++) {
        NSDictionary *replyDic = [replyList objectAtIndex:i];
         KKDynamicCommentReplyItem *replyItem = [KKDynamicCommentReplyItem mj_objectWithKeyValues:replyDic];
        [replyArr addObject:replyItem];
        
        replyViewH += replyItem.dyReplyHeight;
    }
    
    if(isOverCount){
        KKDynamicCommentReplyItem *replyItem = [[KKDynamicCommentReplyItem alloc]init];
        
        replyItem.replyUserName = [NSString stringWithFormat:@"查看全部%@条动态>",self.replyCount];
        
        replyItem.dyReplyHeight = 20;
        [replyArr addObject:replyItem];
        
        replyViewH += replyItem.dyReplyHeight;
    }
    
    self.replyList = replyArr;
    self.dyReplyHeight = replyViewH;
    
}
+ (CGFloat)cellHeight:(KKDynamicCommentItem *)item{
    if (item.dyCommentHeight && item.dyCommentHeight!= 0) {
        return item.dyCommentHeight;
    }else{
        CGFloat headHeight = 0;
        if (item.dynamicHeadItem) {
            headHeight = item.dynamicHeadItem.dynamicHeadHeight;
        }
        CGFloat textHeight = 0;
        if (item.dynamicComTextItem) {
            textHeight = item.dynamicComTextItem.dyComTextHeight;
        }
        CGFloat imageHeight = 0;
        if (item.dynamicImageitem) {
            imageHeight = item.dynamicImageitem.dynamicImageHeight;
        }
        CGFloat repelyHeight = 0;
        if (item.dyReplyHeight != 0) {
            repelyHeight = item.dyReplyHeight + 5;
        }
       
        item.dyCommentHeight = headHeight + textHeight + imageHeight+ repelyHeight ;
        
    }
    return item.dyCommentHeight;
}
- (void)setNowDate:(NSString *)nowDate{
    _nowDate = nowDate;
    self.dynamicHeadItem.nowDate = nowDate;
}

@end
