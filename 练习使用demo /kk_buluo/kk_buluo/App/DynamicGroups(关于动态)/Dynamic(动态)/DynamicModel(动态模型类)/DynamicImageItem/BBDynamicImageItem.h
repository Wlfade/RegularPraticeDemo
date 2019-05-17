//
//  BBDynamicImageItem.h
//  BananaBall
//
//  Created by 单车 on 2018/3/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBDynamicImageItem : NSObject
//@property(nonatomic,strong) NSDictionary *properties;
/** 小图片数组 */
@property (nonatomic,strong) NSMutableArray *smallImageUrlArr;

/** 中图片数组 */
@property (nonatomic,strong) NSMutableArray *midImageUrlArr;

@property (nonatomic,strong) NSString *subjectFirstCardType;

/** 保存视图控件数组 */
//@property (nonatomic,strong) NSMutableArray *tapImageViewArr;
@property (nonatomic,strong) NSArray *tapImageViewArr;

/** 布局数组 */
//@property (nonatomic,strong) NSMutableArray *imageFrameArr;
@property (nonatomic,strong) NSArray *imageFrameArr;


@property (nonatomic,assign) CGFloat dynamicImageHeight;

//- (instancetype)initWithImagePropertist:(NSDictionary *)dic;
//+ (instancetype)propertistWithDic:(NSDictionary *)dic;

@end
