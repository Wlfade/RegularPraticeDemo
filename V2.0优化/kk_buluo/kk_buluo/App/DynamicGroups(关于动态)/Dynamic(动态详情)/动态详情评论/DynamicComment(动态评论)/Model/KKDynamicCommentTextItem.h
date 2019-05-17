//
//  KKDynamicCommentTextItem.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/19.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class KKDynamicCommentTextItem;

@protocol KKDynamicCommentTextItemDelegate <NSObject>

- (CGFloat)KKDynamicCommentTextItemMaxTextH:(KKDynamicCommentTextItem *)item;

@end

@interface KKDynamicCommentTextItem : NSObject
/** 摘要内容 */
@property (nonatomic,strong) NSString *comSummary;
/** 显示动态摘要 */
@property (nonatomic,strong) NSMutableAttributedString *outAttComSummary;
/** 动态内容 高度*/
@property (nonatomic,assign) CGFloat comSummaryHeight;
/** 文本控件 总体*/
@property (nonatomic,assign) CGFloat dyComTextHeight;

@property (nonatomic,weak) id <KKDynamicCommentTextItemDelegate> delegate;

+ (instancetype)KKDynamicCommentTextItemInitWithDictionary:(NSDictionary *)dictioanry withDelegate:( id <KKDynamicCommentTextItemDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
