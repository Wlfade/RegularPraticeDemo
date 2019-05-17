//
//  KKDyDetailWholeItem.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/18.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDyDetailWholeItem.h"

@implementation KKDyDetailWholeItem
+ (instancetype)KKDyDetailWholeItemTransmakeTheDict:(NSDictionary *)dict{
    BBLOG(@"%@",dict);
    KKDyDetailWholeItem *item = [[KKDyDetailWholeItem alloc]init];
    item.nowDate = dict[@"nowDate"];
    
    NSDictionary *subjectSimple = dict[@"subjectSimple"];
    item.subjectId = subjectSimple[@"subjectId"];
    
    NSMutableDictionary *mutSubjectSimple = [NSMutableDictionary dictionaryWithDictionary:subjectSimple];
    
    [mutSubjectSimple setObject:dict[@"focus"] forKey:@"focus"];
    
    [mutSubjectSimple setObject:dict[@"collected"] forKey:@"collected"];
    
    [mutSubjectSimple setObject:dict[@"liked"] forKey:@"liked"];
    
    item.dynamicDictionary = [NSDictionary dictionaryWithDictionary:mutSubjectSimple];
    //取出标题的字典数据
    if ([[mutSubjectSimple allKeys]containsObject:@"title"]) {
        item.dynamicTitleItem = [item dynamicTitleDic:mutSubjectSimple];
    }
    
    //取出头像的字典数据
    item.dynamicHeadItem = [item dynamicHeadDic:mutSubjectSimple];

    item.dynamicHeadItem.nowDate = item.nowDate;
    
    //取出内容文本的字典数据
    item.dynamicTextItem = [item dynamicTextDic:mutSubjectSimple];
    //判断这个动态是否带有图片数据
    item.isImages = NO;
    if ([[mutSubjectSimple allKeys]containsObject:@"properties"]) {
        NSDictionary *properties = subjectSimple[@"properties"];
        if ([[properties allKeys]containsObject:@"smallImageList"]) {
            item.isImages = YES;
            item.dynamicImageitem = [item dynamicImagesDic:subjectSimple[@"properties"]];
            
            NSArray *smallImageList = [NSArray arrayWithArray:properties[@"smallImageList"]];
            NSDictionary *firstUrl = [smallImageList objectAtIndex:0];
            NSString *firstUrlStr = firstUrl[@"url"];
            //弄一个方法获取第一张图片
            item.firstImageUrl = firstUrlStr;
        }
    }
    //判断这个这个动态是否为转发
    if ([[mutSubjectSimple allKeys]containsObject:@"sourceSubjectSimple"]) {
        item.isTransmitSubject = YES;
        NSDictionary *sourceSubjectSimple = subjectSimple[@"sourceSubjectSimple"];
        item.dynamicCardItem = [item dynamicCardDic:sourceSubjectSimple];
    }else{
        item.isTransmitSubject = NO;
    }

    item.dynamicAccessCountItem = [item dynamicAccessDic:mutSubjectSimple];
    
    item.dynamicOperationItem = [item dynamicOperationDic:mutSubjectSimple];
    return item;
    
}
/* 取出需要的动态的文本数据组成新字典转出模型 */
- (KKDyDetailTitleItem *)dynamicTitleDic:(NSDictionary *)topicObject{
    NSArray *keys = @[@"title"];
    NSDictionary *itemDict = [KKDyDetailWholeItem makeTheDictWithKeys:keys fromTheOriginalDictonary:topicObject];
    KKDyDetailTitleItem *dynamicTitleItem = [KKDyDetailTitleItem mj_objectWithKeyValues:itemDict];
    
    return dynamicTitleItem;
}
/* 取出需要的动态的头部数据组成新字典转出数据模型 */
- (KKDynamicHeadItem *)dynamicHeadDic:(NSDictionary *)topicObject{
    NSArray *orignalkeys = @[@"commonObjectCert",@"commonObjectType",@"commonObjectId",@"commonObjectLogoUrl",@"commonObjectName",@"gmtCreate",@"focus"];
    NSArray *transkeys = @[@"commonObjectCert",@"commonObjectType",@"userId",@"userLogoUrl",@"userName",@"gmtCreate",@"focus"];
    
    NSDictionary *itemDict = [KKDyDetailWholeItem makeTheDictWithOriginalKeys:orignalkeys withTransMakeKeys:transkeys fromTheOriginalDictonary:topicObject];
    
    KKDynamicHeadItem *dynamicHeadItem = [KKDynamicHeadItem mj_objectWithKeyValues:itemDict];
    
    return dynamicHeadItem;
}
/* 取出需要的动态的文本数据组成新字典转出模型 */
- (KKDynamicTextItem *)dynamicTextDic:(NSDictionary *)topicObject{
    NSArray *orignalkeys = @[@"content"];
    NSArray *transkeys = @[@"summary"];
    
    NSDictionary *itemDict = [KKDyDetailWholeItem makeTheDictWithOriginalKeys:orignalkeys withTransMakeKeys:transkeys fromTheOriginalDictonary:topicObject];
    
    KKDynamicTextItem *dynamicTextItem = [KKDynamicTextItem mj_objectWithKeyValues:itemDict];
    
    return dynamicTextItem;
}
/* 取出需要的动态的图片数据组成新字典转出模型 */
- (BBDynamicImageItem *)dynamicImagesDic:(NSDictionary *)properties{
    NSArray *keys = @[@"smallImageList",@"middleImageList",@"originalImageList",@"largerImageList",];
    NSDictionary *itemDict = [KKDyDetailWholeItem makeTheDictWithKeys:keys fromTheOriginalDictonary:properties];
    
    BBDynamicImageItem *dynamicImageItem = [BBDynamicImageItem mj_objectWithKeyValues:itemDict];
    
    return dynamicImageItem;
}
/* 取出需要的动态的名片数据组成新字典转出模型 */
- (KKDynamicCardItem *)dynamicCardDic:(NSDictionary *)sourceSubjectSimple{
    
    KKDynamicCardItem *dynamicCardItem = [KKDynamicCardItem mj_objectWithKeyValues:sourceSubjectSimple];
    
    return dynamicCardItem;
}
/* 取出需要的动态的浏览次数组成新字典转出模型 */
- (KKDyDetailAccessCountItem *)dynamicAccessDic:(NSDictionary *)topicObject{
    NSArray *keys = @[@"accessCount"];

    NSDictionary *itemDict = [KKDyDetailWholeItem makeTheDictWithKeys:keys fromTheOriginalDictonary:topicObject];

    KKDyDetailAccessCountItem *dynamicImageItem = [KKDyDetailAccessCountItem mj_objectWithKeyValues:itemDict];
    
    return dynamicImageItem;
}
/* 取出需要的动态的操作数据组成新字典转出模型 */
- (KKDynamicOperationItem *)dynamicOperationDic:(NSDictionary *)topicObject{
    
    NSArray *orignalkeys = @[@"transmitCount",@"commentCount",@"likeCount",@"liked",@"collected"];
    NSArray *transkeys = @[@"transmitCount",@"replyCount",@"likeCount",@"liked",@"collected"];
    
    NSDictionary *itemDict = [KKDyDetailWholeItem makeTheDictWithOriginalKeys:orignalkeys withTransMakeKeys:transkeys fromTheOriginalDictonary:topicObject];
    
    KKDynamicOperationItem *dynamicOperationItem = [KKDynamicOperationItem mj_objectWithKeyValues:itemDict];


    return dynamicOperationItem;
}
/* 根据传入的 键数组 从对应的字典中取出数据 然后组成新的字典返回 key 与服务端给的保持一致 赋值给模型*/
+ (NSDictionary *)makeTheDictWithKeys:(NSArray *)keys
             fromTheOriginalDictonary:(NSDictionary *)dictionary{
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    for (NSString *key in keys) {
        id value = dictionary[key];
        if (value) {
            [tempDict setValue:value forKey:key];
        }
    }
    NSDictionary *resulDic = [NSDictionary dictionaryWithDictionary:tempDict];
    
    return resulDic;
}

/**
 传入键值数组 取出 元素 赋值新字典替换键值 形成新字典
 
 @param oriKeys 目标字典中的键值数组
 @param transKeys 转换的键值数组
 @param dictionary 目标字典
 @return 新字典
 */
+ (NSDictionary *)makeTheDictWithOriginalKeys:(NSArray *)oriKeys
                            withTransMakeKeys:(NSArray *)transKeys
                     fromTheOriginalDictonary:(NSDictionary *)dictionary{
    NSInteger oriCount = oriKeys.count;
    NSInteger tranCount = transKeys.count;
    
    NSInteger count = oriCount<=tranCount? oriCount : tranCount;
    
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    
    for (NSInteger i = 0; i < count; i ++) {
        NSString *oriKey = oriKeys[i];
        NSString *transKey = transKeys[i];
        
        id value = dictionary[oriKey];
        if (value) {
            [tempDict setValue:value forKey:transKey];
        }
    }
    NSDictionary *resulDic = [NSDictionary dictionaryWithDictionary:tempDict];
    return resulDic;
}
+ (CGFloat)dynamicDetailHeadViewHeight:(KKDyDetailWholeItem *)item{
    if (item.dyDetailWholeHeight && item.dyDetailWholeHeight!= 0) {
        return item.dyDetailWholeHeight;
    }else{
        
        CGFloat titleHeight = 0;
        if (item.dynamicTitleItem) {
            titleHeight = item.dynamicTitleItem.titleHeight;
        }
        
        CGFloat headHeight = 0;
        if (item.dynamicHeadItem) {
            headHeight = item.dynamicHeadItem.dynamicHeadHeight;
        }
        CGFloat textHeight = 0;
        if (item.dynamicTextItem) {
            textHeight = item.dynamicTextItem.dyTextHeight;
        }
        CGFloat imageHeight = 0;
        if (item.dynamicImageitem) {
            imageHeight = item.dynamicImageitem.dynamicImageHeight;
        }
        CGFloat cardHeight = 0;
        if (item.dynamicHeadItem) {
            cardHeight = item.dynamicCardItem.dyCardHeight;
        }
        CGFloat accessHeight = 0;
        if (item.dynamicAccessCountItem) {
            accessHeight = item.dynamicAccessCountItem.dynamicAccessHeight;
        }

        
        item.dyDetailWholeHeight = titleHeight + headHeight + textHeight + imageHeight +cardHeight+ accessHeight;
    }
    return item.dyDetailWholeHeight;
}
@end
