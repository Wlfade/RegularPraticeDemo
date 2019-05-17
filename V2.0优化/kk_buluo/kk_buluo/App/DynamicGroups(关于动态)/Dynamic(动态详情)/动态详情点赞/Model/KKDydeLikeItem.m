//
//  KKDydeLikeItem.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/19.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDydeLikeItem.h"
#import "KKReMakeDictionary.h"


@implementation KKDydeLikeItem
+ (instancetype)KKDydeLikeItemWithDictionary:(NSDictionary *)dict{
    KKDydeLikeItem *likeItem = [[KKDydeLikeItem alloc]init];
    
    likeItem.dynamicHeadItem = [likeItem dynamicHeadDic:dict];
    
    return likeItem;
}
/* 取出需要的动态的头部数据组成新字典转出数据模型 */
- (KKDynamicHeadItem *)dynamicHeadDic:(NSDictionary *)topicObject{
    NSArray *orignalkeys = @[@"commonObjectCert",@"commonObjectType",@"commonObjectId",@"commonObjectLogoUrl",@"commonObjectName",@"gmtCreate"];
    NSArray *transkeys = @[@"commonObjectCert",@"commonObjectType",@"userId",@"userLogoUrl",@"userName",@"gmtCreate"];
    NSDictionary *itemDict = [KKReMakeDictionary makeTheDictWithOriginalKeys:orignalkeys withTransMakeKeys:transkeys fromTheOriginalDictonary:topicObject];
    
    KKDynamicHeadItem *dynamicHeadItem = [KKDynamicHeadItem mj_objectWithKeyValues:itemDict];
    
    return dynamicHeadItem;
}

+ (CGFloat)cellHeight:(KKDydeLikeItem *)item{
    if (item.dydeLikeHeight && item.dydeLikeHeight!= 0) {
        return item.dydeLikeHeight;
    }else{
        CGFloat headHeight = 0;
        if (item.dynamicHeadItem) {
            headHeight = item.dynamicHeadItem.dynamicHeadHeight;
        }
        item.dydeLikeHeight = headHeight;
    }
    return item.dydeLikeHeight;
}
@end
