//
//  KKDynamicCardItem.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/17.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKDynamicCardItem : NSObject
/** 原作者名字 */
@property (nonatomic,strong) NSString *commonObjectName;
/** 图片的URL */
@property (nonatomic,strong) NSString *firstUrlStr;
/** 占位图片 */
@property (nonatomic,strong) UIImage *placeHoldImage;
/** 摘要标题 */
@property (nonatomic,strong) NSString *title;
/** 显示标题摘要 */
@property (nonatomic,strong) NSMutableAttributedString *outAttTitle;

/** 显示动态摘要 */
@property (nonatomic,assign) CGFloat titleHeight;

/** 摘要内容 */
@property (nonatomic,strong) NSString *summary;
/** 显示动态摘要 */
@property (nonatomic,strong) NSMutableAttributedString *outAttSummary;

/** 显示动态摘要 */
@property (nonatomic,assign) CGFloat summaryHeight;
/** 文本控件 总体*/
@property (nonatomic,assign) CGFloat dyCardHeight;

/** 距离头部高度 */
@property (nonatomic,assign) CGFloat topGapH;

//动态的id
@property (nonatomic, strong) NSString *subjectId;
//图片 方案 等其他数据
@property (nonatomic, strong) NSDictionary *properties;
//动态是否已被删除
@property (nonatomic, assign) BOOL deleted;


@end

NS_ASSUME_NONNULL_END
