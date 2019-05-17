//
//  KKDyDetailTitleItem.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/31.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKDyDetailTitleItem : NSObject
/** 标题 */
@property (nonatomic,strong) NSString *title;

@property (nonatomic,strong) NSMutableAttributedString *outAttTitle;
/** 标题 高度*/
@property (nonatomic,assign) CGFloat titleHeight;
@end

NS_ASSUME_NONNULL_END
