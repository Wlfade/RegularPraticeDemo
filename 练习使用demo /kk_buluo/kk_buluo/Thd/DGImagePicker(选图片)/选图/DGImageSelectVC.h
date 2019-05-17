//
//  DGImageSelectVC.h
//  DGImagePicker
//
//  Created by david on 2018/12/18.
//  Copyright © 2018 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface DGImageSelectVC : UIViewController

/** 相册list */
@property(nonatomic,strong) NSArray *assertsGroupArray ;


/** 图片选择完成block
 *  @param isCanceled  是否是 取消
 *  @param isCamera    是否是 相机
 *  @param assets      选中的 数据
 */
@property (nonatomic,copy) void(^finishHandler)(BOOL isCanceled,BOOL isCamera,NSArray *assets);

/** 最多选择几张图 */
@property (nonatomic,assign) NSInteger maxCount ;


#pragma mark - 裁剪
/** 是否 需要裁剪 */
@property (nonatomic,assign) BOOL needClip;

/** 是否 是圆形 */
@property (nonatomic,assign) BOOL needCircle;

/** 是否 是矩形 */
@property (nonatomic,assign) BOOL needRectangle;

/** 矩形自定义尺寸 */
@property (nonatomic,assign) CGSize rectangleSize;

@end
