//
//  KKDynamicArticleItem.h
//  kk_buluo
//
//  Created by 单车 on 2019/4/23.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKDynamicArticleItem : NSObject
/** 动态长文的单元格高度 */
@property (nonatomic,assign) CGFloat dyArticleHeight;
//发帖人的用户id
@property (nonatomic,strong) NSString *userId;

/** 图片的URL */
@property (nonatomic,strong) NSString *firstUrlStr;

//默认图片
@property(nonatomic,strong) UIImage *placeHoldImage;

/** 标题 */
@property (nonatomic,strong) NSString *title;
/** 显示标题 */
@property (nonatomic,strong) NSMutableAttributedString *outAttTitle;
/** 显示标题的高度 */
@property (nonatomic,assign) CGFloat titleHeight;

/** 用户认证 */
@property (nonatomic,strong) NSString *commonObjectCert;

/** 用户名字 */
@property (nonatomic,strong) NSString *commonObjectName;

/** 申请时间 */
@property (nonatomic, strong) NSString *gmtCreate;
/** 请求数据的时间 */
@property (nonatomic, strong) NSString *nowDate;
/** 显示的时间 */
@property (nonatomic, strong) NSString *showDate;

/** 浏览次数 */
@property (nonatomic,assign) NSInteger accessCount;
/** 浏览次数文字 */
@property (nonatomic,strong) NSString *accessCountStr;
/** 组合文字 */
@property (nonatomic,strong) NSString *fromeStr;

@property (nonatomic,assign) CGFloat titleMaxHeight;

@property (nonatomic,assign) CGFloat titleWidth;

@end

NS_ASSUME_NONNULL_END
