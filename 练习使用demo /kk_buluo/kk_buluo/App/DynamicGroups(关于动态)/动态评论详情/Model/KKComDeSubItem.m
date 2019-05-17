//
//  KKComDeSubItem.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/20.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKComDeSubItem.h"
#import "KKReMakeDictionary.h"

@interface KKComDeSubItem ()

@end

@implementation KKComDeSubItem
//评论数据的处理返回个存放了模型的数组
+ (instancetype)KKComDeSubItemWithDictionary:(NSDictionary *)dict{
    KKComDeSubItem *deSubItem = [[KKComDeSubItem alloc]init];
    
    
    NSDictionary *commentDic = dict[@"comment"];
    
    deSubItem.commentId = dict[@"commentId"];

    deSubItem = [KKComDeSubItem mj_objectWithKeyValues:commentDic];
    
    deSubItem.dynamicHeadItem = [deSubItem dynamicHeadDic:commentDic];
    
    deSubItem.dynamicComTextItem = [deSubItem dynamicComTextDic:commentDic];
    deSubItem.isImages = NO;
    deSubItem.dyImageHeight = 0;
    if ([[commentDic allKeys]containsObject:@"properties"]) {
        NSDictionary *properties = commentDic[@"properties"];
        if ([[properties allKeys]containsObject:@"smallImageList"]) {
            deSubItem.isImages = YES;
            deSubItem.dynamicImageitem = [deSubItem dynamicImagesDic:commentDic[@"properties"]];
            deSubItem.dyImageHeight = deSubItem.dynamicImageitem.dynamicImageHeight;
        }
    }
    return deSubItem;
}

/* 取出需要的动态的头部数据组成新字典转出数据模型 */
- (KKDynamicHeadItem *)dynamicHeadDic:(NSDictionary *)topicObject{
    NSArray *orignalkeys = @[@"commonObjectCert",@"commonObjectType",@"commentId",@"commonObjectId",@"commonObjectLogoUrl",@"commonObjectName",@"gmtCreate",@"liked",@"likeCount",@"nowDate"];
    NSArray *transkeys = @[@"commonObjectCert",@"commonObjectType",@"commentId",@"userId",@"userLogoUrl",@"userName",@"gmtCreate",@"liked",@"likeCount",@"nowDate"];
    NSDictionary *itemDict = [KKReMakeDictionary makeTheDictWithOriginalKeys:orignalkeys withTransMakeKeys:transkeys fromTheOriginalDictonary:topicObject];
    
    KKDynamicHeadItem *dynamicHeadItem = [KKDynamicHeadItem mj_objectWithKeyValues:itemDict];
    
    return dynamicHeadItem;
}
/* 取出需要的动态的文本数据组成新字典转出模型 */
- (KKDynamicCommentTextItem *)dynamicComTextDic:(NSDictionary *)topicObject{
    NSArray *orignalkeys = @[@"content"];
    NSArray *transkeys = @[@"comSummary"];
    
    NSDictionary *itemDict = [KKReMakeDictionary makeTheDictWithOriginalKeys:orignalkeys withTransMakeKeys:transkeys fromTheOriginalDictonary:topicObject];
    
    KKDynamicCommentTextItem *dynamicTextItem = [KKDynamicCommentTextItem mj_objectWithKeyValues:itemDict];
    
    return dynamicTextItem;
}
- (KKDyCommentImageItem *)dynamicImagesDic:(NSDictionary *)properties{
    NSArray *keys = @[@"smallImageList",@"middleImageList",@"originalImageList",@"largerImageList",];
    NSDictionary *itemDict = [KKReMakeDictionary makeTheDictWithKeys:keys fromTheOriginalDictonary:properties];
    
    KKDyCommentImageItem *dynamicImageItem = [KKDyCommentImageItem mj_objectWithKeyValues:itemDict];
    
    return dynamicImageItem;
}
+ (CGFloat)cellHeight:(KKComDeSubItem *)item{
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
        
        item.dyCommentHeight = headHeight + textHeight + imageHeight;
        
    }
    return item.dyCommentHeight;
}
- (void)setNowDate:(NSString *)nowDate{
    _nowDate = nowDate;
    self.dynamicHeadItem.nowDate = nowDate;
}


@end
