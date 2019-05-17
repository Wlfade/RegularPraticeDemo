//
//  KKDynamicTextItem.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/17.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKDynamicTextItem : NSObject

/** 标题 */
@property (nonatomic,strong) NSString *title;
/** 显示标题 */
@property (nonatomic,strong) NSMutableAttributedString *outAttTitle;
/** 动态内容 高度*/
@property (nonatomic,assign) CGFloat titleHeight;


/** 摘要内容 */
@property (nonatomic,strong) NSString *summary;
/** 显示动态摘要 */
@property (nonatomic,strong) NSMutableAttributedString *outAttSummary;
/** 动态内容 高度*/
@property (nonatomic,assign) CGFloat summaryHeight;
/** 文本控件 总体*/
@property (nonatomic,assign) CGFloat dyTextHeight;

@property (nonatomic,assign) CGFloat textMaxHeight;
@end

NS_ASSUME_NONNULL_END
