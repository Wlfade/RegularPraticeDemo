//
//  BBDynamicImageItem.m
//  BananaBall
//
//  Created by 单车 on 2018/3/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BBDynamicImageItem.h"
#import "BBDynaicTapImageView.h"
#import "KKImageListItem.h"
#define gap 8 //布局间隔
#define MaxImageCount 3//最大一行个数
//#define MaxCounts 9//最大数

static const NSInteger defaultMaxCounts = 9;

@interface BBDynamicImageItem ()
///** 默认最大数 */
- (NSInteger)MaxCounts;
@end

@implementation BBDynamicImageItem

- (NSInteger)MaxCounts{
    if (_theMaxCounts > 0) {
        return _theMaxCounts;
    }else{
        return defaultMaxCounts;
    }
}

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"smallImageUrlArr":@"smallImageList",
             @"midImageUrlArr":@"middleImageList"
//             originalImageList
//             largerImageList
             };
}
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"midImageUrlArr":[KKImageListItem class],
             @"smallImageUrlArr":[KKImageListItem class],
             @"originalImageList":[KKImageListItem class],
             @"largerImageList":[KKImageListItem class],
             };
}

- (void)mj_keyValuesDidFinishConvertingToObject{
    [self setImageFramesWithImageArr:self.smallImageUrlArr.count];
}
/** 重新设置布局 */
- (void)setImageFramesWithImageArr:(NSInteger)repeatCount{
    NSMutableArray *frameMutArr = [NSMutableArray arrayWithCapacity:repeatCount];
    
    NSMutableArray *imageViewMutArr = [NSMutableArray arrayWithCapacity:repeatCount];
    //判断数量 1 2 3
    CGFloat imageViewW = 0;
    
    CGFloat imageViewH = 0;
    
    if (repeatCount >= self.MaxCounts) {
        repeatCount = self.MaxCounts;
    }
    NSInteger arrCount = repeatCount;
    if (arrCount >= MaxImageCount) {
        imageViewW = ((SCREEN_WIDTH - 20) - (MaxImageCount - 1)*gap)/MaxImageCount;
    }else{
        
        imageViewW = ((SCREEN_WIDTH - 20) - (arrCount - 1)*gap)/arrCount;
    }
    
    if (arrCount == 1) {
        imageViewH = imageViewW * 5 / 9;
    }else{
        imageViewH = imageViewW;
    }

    for (NSInteger i = 0; i < repeatCount; i ++) {
        
        CGRect frame = CGRectMake(10 + (imageViewW + gap)*(i%MaxImageCount), 0 + (i/MaxImageCount)*(imageViewH + gap), imageViewW, imageViewH);
        //frame 转 value
        NSValue *frameValue = [NSValue valueWithCGRect:frame];
        
        BBDynaicTapImageView *dynamicView=[[BBDynaicTapImageView alloc]init];
        dynamicView.contentMode =  UIViewContentModeScaleAspectFill;
//        dynamicView.contentMode =  UIViewContentModeScaleAspectFit;

        dynamicView.clipsToBounds  = YES;
        dynamicView.tag = 11+i;
        
        //value 转 frame
        dynamicView.frame=[frameValue CGRectValue];
        
        [imageViewMutArr addObject:dynamicView];
        [frameMutArr addObject:frameValue];
    }
    NSValue *lastValue = [frameMutArr lastObject];
    CGRect lastFrame = [lastValue CGRectValue];
    //最后布局计算整体高度
    self.dynamicImageHeight = lastFrame.origin.y + lastFrame.size.height + gap;
    //设置图片布局数组
    self.imageFrameArr = frameMutArr;
    //设置图片数组
    self.tapImageViewArr = imageViewMutArr;
}
@end
