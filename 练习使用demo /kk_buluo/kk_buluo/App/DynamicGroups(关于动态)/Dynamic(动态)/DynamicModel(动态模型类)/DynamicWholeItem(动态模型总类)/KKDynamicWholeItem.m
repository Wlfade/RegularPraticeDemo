//
//  KKDynamicWholeItem.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/15.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDynamicWholeItem.h"
#import "NSDictionary+CCCat.h"

@interface KKDynamicWholeItem ()<BBDynamicImageItemDelegate>

@end

@implementation KKDynamicWholeItem

+ (instancetype)makeTheDynamicItemWithDictionary:(NSDictionary *)dict{
    BBLOG(@"%@",dict);
    
    KKDynamicWholeItem *item = [[KKDynamicWholeItem alloc]init];
    
    NSDictionary *topicObject = dict[@"topicObject"];
    item.dynamicDictionary = topicObject;
    
    item.subjectId = topicObject[@"subjectId"];
    
    //判断数据的类型
    item.objectType = topicObject[@"objectType"];
    NSLog(@"objectType:%@",item.objectType);
    
    if ([item.objectType isEqualToString:@"PERSONAL_ARTICLE"]) {
        item = [item makeArticleItem:item withDict:topicObject];
    }else{
        item = [item makeSubjectItem:item withDict:topicObject];
    }
    return item;
}
#pragma mark - 处理普通动态NORMAL
//处理普通动态的数据模型
- (KKDynamicWholeItem *)makeSubjectItem:(KKDynamicWholeItem *)item withDict:(NSDictionary *)topicObject{
    //取出头像的字典数据
    item.dynamicHeadItem = [item dynamicHeadDic:topicObject];
    //取出内容文本的字典数据
    item.dynamicTextItem = [item dynamicTextDic:topicObject];
    //判断这个动态是否带有图片数据
    item.isImages = NO;
    if ([[topicObject allKeys]containsObject:@"properties"]) {
        NSDictionary *properties = topicObject[@"properties"];
        if ([[properties allKeys]containsObject:@"smallImageList"]) {
            item.isImages = YES;
            item.dynamicImageitem = [item dynamicImagesDic:topicObject[@"properties"]];
            
            NSArray *smallImageList = [NSArray arrayWithArray:properties[@"smallImageList"]];
            NSDictionary *firstUrl = [smallImageList objectAtIndex:0];
            NSString *firstUrlStr = firstUrl[@"url"];
            //弄一个方法获取第一张图片
            item.firstImageUrl = firstUrlStr;
        }
    }
    
    //判断这个这个动态是否为转发
    if ([[topicObject allKeys]containsObject:@"sourceSubjectSimple"]) {
        item.isTransmitSubject = YES;
        NSDictionary *sourceSubjectSimple = topicObject[@"sourceSubjectSimple"];
        item.dynamicCardItem = [item dynamicCardDic:sourceSubjectSimple];
    }else{
        item.isTransmitSubject = NO;
    }
    
    //取出操作的字典数据
    item.dynamicOperationItem = [item dynamicOperationDic:topicObject];
    
    return item;
}
#pragma mark - 处理长文动态Article
- (KKDynamicWholeItem *)makeArticleItem:(KKDynamicWholeItem *)item withDict:(NSDictionary *)topicObject{
    //限制单元格高度
    NSMutableDictionary *articleDictionary = [NSMutableDictionary dictionary];
    //获取第一张图片地址
    if ([[topicObject allKeys]containsObject:@"properties"]) {
        NSDictionary *properties = topicObject[@"properties"];
        if ([[properties allKeys]containsObject:@"smallImageList"]) {
            NSArray *smallImageList = [NSArray arrayWithArray:properties[@"smallImageList"]];
            NSDictionary *firstUrl = [smallImageList objectAtIndex:0];
            NSString *firstUrlStr = firstUrl[@"url"];
            //弄一个方法获取第一张图片
            [articleDictionary safeSetObject:firstUrlStr forKey:@"firstUrlStr"];
        }
    }
    
    [articleDictionary safeSetObject:topicObject[@"commonObjectId"] forKey:@"userId"];
    //标题
    [articleDictionary safeSetObject:topicObject[@"title"] forKey:@"title"];
    //认证
//    [articleDictionary safeSetObject:topicObject[@"commonObjectCert"] forKey:@"commonObjectCert"];
    
    [articleDictionary safeSetObject:topicObject[@"commonObjectName"] forKey:@"commonObjectName"];

    //时间
    [articleDictionary safeSetObject:topicObject[@"gmtCreate"] forKey:@"gmtCreate"];
    
//    [articleDictionary safeSetObject:topicObject[@"gmtCreate"] forKey:@"gmtCreate"];
    
    [articleDictionary safeSetObject:topicObject[@"accessCount"] forKey:@"accessCount"];
    
    [articleDictionary setValue:@50 forKey:@"titleMaxHeight"];

    item.dynamicArticleItem = [KKDynamicArticleItem mj_objectWithKeyValues:articleDictionary];
    
    return item;
}
/* 取出需要的动态的头部数据组成新字典转出数据模型 */
- (KKDynamicHeadItem *)dynamicHeadDic:(NSDictionary *)topicObject{
    NSArray *orignalkeys = @[@"focus",@"commonObjectCert",@"commonObjectType",@"commonObjectId",@"commonObjectLogoUrl",@"commonObjectName",@"gmtCreate"];
    NSArray *transkeys = @[@"focus",@"commonObjectCert",@"commonObjectType",@"userId",@"userLogoUrl",@"userName",@"gmtCreate"];
    
    NSDictionary *itemDict = [KKDynamicWholeItem makeTheDictWithOriginalKeys:orignalkeys withTransMakeKeys:transkeys fromTheOriginalDictonary:topicObject];
    
    KKDynamicHeadItem *dynamicHeadItem = [KKDynamicHeadItem mj_objectWithKeyValues:itemDict];
    
    return dynamicHeadItem;
}
/* 取出需要的动态的文本数据组成新字典转出模型 */
- (KKDynamicTextItem *)dynamicTextDic:(NSDictionary *)topicObject{
    NSMutableDictionary *tempTopicObject = [NSMutableDictionary dictionaryWithDictionary:topicObject];
    //设置动态文本中的最大高度为85
    [tempTopicObject setValue:@85 forKey:@"textMaxHeight"];
    NSArray *keys = @[@"title",@"summary",@"textMaxHeight"];
    NSDictionary *itemDict = [KKDynamicWholeItem makeTheDictWithKeys:keys fromTheOriginalDictonary:[NSDictionary dictionaryWithDictionary:tempTopicObject]];
    
    KKDynamicTextItem *dynamicTextItem = [KKDynamicTextItem mj_objectWithKeyValues:itemDict];
    
    
    return dynamicTextItem;
}
/* 取出需要的动态的图片数据组成新字典转出模型 */
- (BBDynamicImageItem *)dynamicImagesDic:(NSDictionary *)properties{
    NSArray *keys = @[@"smallImageList",@"middleImageList",@"originalImageList",@"largerImageList",];
//    NSDictionary *itemDict = [KKDynamicWholeItem makeTheDictWithKeys:keys fromTheOriginalDictonary:properties];
    
    NSMutableDictionary *itemDict =[NSMutableDictionary dictionaryWithDictionary:[KKDynamicWholeItem makeTheDictWithKeys:keys fromTheOriginalDictonary:properties]];

    //设置图片最大显示数量限制
    [itemDict safeSetObject:@9 forKey:@"theMaxCounts"];
    
    
    BBDynamicImageItem *dynamicImageItem = [BBDynamicImageItem mj_objectWithKeyValues:itemDict];
    
    return dynamicImageItem;
}

/* 取出需要的动态的名片数据组成新字典转出模型 */
- (KKDynamicCardItem *)dynamicCardDic:(NSDictionary *)sourceSubjectSimple{
//    NSArray *keys = @[@"summary",@"title"];
//    NSDictionary *itemDict = [KKDynamicWholeItem makeTheDictWithKeys:keys fromTheOriginalDictonary:sourceSubjectSimple];
    
//    [sourceSubjectSimple creatPropertyCode];
    
    KKDynamicCardItem *dynamicCardItem = [KKDynamicCardItem mj_objectWithKeyValues:sourceSubjectSimple];
    
    return dynamicCardItem;
}
/* 取出需要的动态的操作数据组成新字典转出模型 */
- (KKDynamicOperationItem *)dynamicOperationDic:(NSDictionary *)topicObject{
    NSArray *keys = @[@"transmitCount",@"transmited",@"replyCount",@"likeCount",@"liked"];
    NSDictionary *itemDict = [KKDynamicWholeItem makeTheDictWithKeys:keys fromTheOriginalDictonary:topicObject];
    
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

/**
 返回单元格高度的数据
 @param item 动态模型
 @return 单元格高度
 */
+ (CGFloat)cellHeight:(KKDynamicWholeItem *)item{
    if (item.cellHeight && item.cellHeight!= 0) {
        return item.cellHeight;
    }else{
        if ([item.objectType isEqualToString:@"PERSONAL_ARTICLE"]) {
            CGFloat atricleHeight = 0;
            if (item.dynamicArticleItem) {
                atricleHeight = item.dynamicArticleItem.dyArticleHeight;
            }
            item.cellHeight = atricleHeight;
        }else{
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
            CGFloat operationHeight = 0;
            if (item.dynamicOperationItem) {
                operationHeight = item.dynamicOperationItem.dyOperationHeight;
            }
            //2 为底部灰色线的高度
            item.cellHeight = headHeight + textHeight + imageHeight + cardHeight + operationHeight ;
        }
    }

    return item.cellHeight;
}

- (void)setNowDate:(NSString *)nowDate{
    _nowDate = nowDate;
   
    if (self.dynamicHeadItem != nil) {
         self.dynamicHeadItem.nowDate = nowDate;
    }
    else if (self.dynamicArticleItem != nil){
         self.dynamicArticleItem.nowDate = nowDate;
    }
}

#pragma mark - BBDynamicImageItemDelegate
- (CGFloat)maxRowCountBBDynamicImageItem:(BBDynamicImageItem *)dynamicImageItem{
    return 3;
}
@end
