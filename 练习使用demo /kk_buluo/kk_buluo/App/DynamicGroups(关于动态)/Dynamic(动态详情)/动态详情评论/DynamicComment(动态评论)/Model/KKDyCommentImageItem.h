//
//  KKDyCommentImageItem.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/19.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKDyCommentImageItem : NSObject
/** 小图片数组 */
@property (nonatomic,strong) NSMutableArray *smallImageUrlArr;
/** 中图片数组 */
@property (nonatomic,strong) NSMutableArray *midImageUrlArr;
/** 原图片数组 */
@property (nonatomic,strong) NSMutableArray *originalImageList;
/** 大图片数组 */
@property (nonatomic,strong) NSMutableArray *largerImageList;

@property (nonatomic,strong) NSString *subjectFirstCardType;

/** 保存视图控件数组 */
//@property (nonatomic,strong) NSMutableArray *tapImageViewArr;
@property (nonatomic,strong) NSArray *tapImageViewArr;
/** 布局数组 */
//@property (nonatomic,strong) NSMutableArray *imageFrameArr;
@property (nonatomic,strong) NSArray *imageFrameArr;

@property (nonatomic,assign) CGFloat dynamicImageHeight;
@end

NS_ASSUME_NONNULL_END
