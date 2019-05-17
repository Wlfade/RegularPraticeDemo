//
//  KKDydeTransmitItem.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/19.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDydeTransmitItem.h"
#import "KKReMakeDictionary.h"

@implementation KKDydeTransmitItem
+ (instancetype)KKDydeTransmitItemWithDictionary:(NSDictionary *)dict{
    KKDydeTransmitItem *transmitItem = [[KKDydeTransmitItem alloc]init];
    transmitItem.transDyId = dict[@"id"];
    
    transmitItem.dynamicHeadItem = [transmitItem dynamicHeadDic:dict];
    
    transmitItem.dynamicTransmitTextItem = [transmitItem dynamicComTextDic:dict];
    
    return transmitItem;
    
}
+ (instancetype)KKDydeReplyWithDictionary:(NSDictionary *)dict{
    KKDydeTransmitItem *transmitItem = [[KKDydeTransmitItem alloc]init];
    transmitItem.transDyId = dict[@"id"];
    
    transmitItem.dynamicHeadItem = [transmitItem dynamicReplyHeadDic:dict];
    
    transmitItem.dynamicTransmitTextItem = [transmitItem dynamicComReplyTextDic:dict];
    
    return transmitItem;
}
/* 取出需要的动态的头部数据组成新字典转出数据模型 */
- (KKDynamicHeadItem *)dynamicHeadDic:(NSDictionary *)topicObject{
    NSArray *orignalkeys = @[@"commonObjectCert",@"commonObjectType",@"commonObjectId",@"commonObjectLogoUrl",@"commonObjectName",@"gmtCreate"];
    NSArray *transkeys = @[@"commonObjectCert",@"commonObjectType",@"userId",@"userLogoUrl",@"userName",@"gmtCreate"];
    NSDictionary *itemDict = [KKReMakeDictionary makeTheDictWithOriginalKeys:orignalkeys withTransMakeKeys:transkeys fromTheOriginalDictonary:topicObject];
    
    KKDynamicHeadItem *dynamicHeadItem = [KKDynamicHeadItem mj_objectWithKeyValues:itemDict];
    
    return dynamicHeadItem;
}

- (KKDynamicHeadItem *)dynamicReplyHeadDic:(NSDictionary *)topicObject{
//    NSArray *orignalkeys = @[@"replyUserId",@"replyUserLogoUrl",@"replyUserName",@"gmtCreate"];
    NSArray *orignalkeys = @[@"commentReplyId",@"commonObjectLogoUrl",@"commonObjectName",@"gmtCreate"];

    NSArray *transkeys = @[@"userId",@"userLogoUrl",@"userName",@"gmtCreate"];
    NSDictionary *itemDict = [KKReMakeDictionary makeTheDictWithOriginalKeys:orignalkeys withTransMakeKeys:transkeys fromTheOriginalDictonary:topicObject];
    
    KKDynamicHeadItem *dynamicHeadItem = [KKDynamicHeadItem mj_objectWithKeyValues:itemDict];
    
    return dynamicHeadItem;
}
/*（动态的转发使用） 取出需要的动态的文本数据组成新字典转出模型 */
- (KKDynamicCommentTextItem *)dynamicComTextDic:(NSDictionary *)topicObject{
//    NSArray *orignalkeys = @[@"content"];
    NSArray *orignalkeys = @[@"summary"];

    NSArray *transkeys = @[@"comSummary"];
    
    NSDictionary *itemDict = [KKReMakeDictionary makeTheDictWithOriginalKeys:orignalkeys withTransMakeKeys:transkeys fromTheOriginalDictonary:topicObject];
    
    KKDynamicCommentTextItem *dynamicTextItem = [KKDynamicCommentTextItem mj_objectWithKeyValues:itemDict];
    
    return dynamicTextItem;
}

- (KKDynamicCommentTextItem *)dynamicComReplyTextDic:(NSDictionary *)topicObject{
    NSArray *orignalkeys = @[@"content"];
    
    NSArray *transkeys = @[@"comSummary"];
    
    NSDictionary *itemDict = [KKReMakeDictionary makeTheDictWithOriginalKeys:orignalkeys withTransMakeKeys:transkeys fromTheOriginalDictonary:topicObject];
    
    KKDynamicCommentTextItem *dynamicTextItem = [KKDynamicCommentTextItem mj_objectWithKeyValues:itemDict];
    
    return dynamicTextItem;
}

+ (CGFloat)cellHeight:(KKDydeTransmitItem *)item{
    if (item.dyTranmitHeight && item.dyTranmitHeight!= 0) {
        return item.dyTranmitHeight;
    }else{
        CGFloat headHeight = 0;
        if (item.dynamicHeadItem) {
            headHeight = item.dynamicHeadItem.dynamicHeadHeight;
        }
        CGFloat textHeight = 0;
        if (item.dynamicHeadItem) {
            textHeight = item.dynamicTransmitTextItem.dyComTextHeight;
        }
        item.dyTranmitHeight = headHeight + textHeight;
        
    }
    return item.dyTranmitHeight;
}
- (void)setNowDate:(NSString *)nowDate{
    _nowDate = nowDate;
    self.dynamicHeadItem.nowDate = nowDate;
}
@end
