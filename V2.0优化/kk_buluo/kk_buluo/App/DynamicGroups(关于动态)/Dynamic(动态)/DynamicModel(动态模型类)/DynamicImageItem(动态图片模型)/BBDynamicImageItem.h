//
//  BBDynamicImageItem.h
//  BananaBall
//
//  Created by 单车 on 2018/3/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BBDynamicImageItem;

@protocol BBDynamicImageItemDelegate <NSObject>

//设置显示 图片的组大的数量
- (CGFloat)maxRowCountBBDynamicImageItem:(BBDynamicImageItem *)dynamicImageItem;


@end

@interface BBDynamicImageItem : NSObject

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

@property (nonatomic,assign) NSInteger theMaxCounts;

/** 代理 */
@property (nonatomic, weak) id<BBDynamicImageItemDelegate> delegate;



@end
